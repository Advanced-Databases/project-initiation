import pandas as pd
import numpy as np
from sqlalchemy import create_engine


# Setting up connection with sql server
uid='root'
pwd='test'
server='127.0.0.1'

connection_string = f"mysql+pymysql://{uid}:{pwd}@{server}"
engine = create_engine(connection_string)


# --------------------- 1. Data Extraction (And Transformation) ---------------

# -------------------- 1.1. Create Dimension Tables ---------------------------

# 1. CourseGroup
CourseGroup_df = pd.read_sql(
    """
        WITH course_intensity AS(
        	SELECT s.group_id
        		, sum(s.end_hour - s.start_hour) hourly_intensity
        		, sum(CASE
        				WHEN s.start_hour < 12 AND s.end_hour < 12 THEN (s.end_hour - s.start_hour)
        				WHEN s.start_hour < 12 AND s.end_hour >= 12 THEN (12 - s.start_hour)
        				ELSE 0
        				END
        		) hourly_intensity_am
        		, sum(CASE
        				WHEN s.start_hour >= 12 AND s.end_hour >=12 THEN (s.end_hour - s.start_hour)
        				WHEN s.start_hour < 12 AND s.end_hour >= 12 THEN (s.end_hour - 12)
        				ELSE 0
        				END
        		) hourly_intensity_pm
        	FROM mydb.Schedule s
        	GROUP BY s.group_id
        )
        SELECT
            	c.course_id
            	, g.group_id
            	, c.sia_code
            	, g.group_number
            	, c.name
            	, c.credits
            	, g.seats
            	, i.hourly_intensity
            	, i.hourly_intensity_am
            	, i.hourly_intensity_pm
        FROM mydb.Course c
        INNER JOIN mydb.`Group` g ON g.course_id = c.course_id 
        INNER JOIN course_intensity i ON i.group_id = g.group_id
    """,
    engine
)

# 2. Professor
Professor_df = pd.read_sql(
    """
        SELECT
            	p.professor_id
            	, p.name
            	, p.birthday birthdate
            	, p.nationality
            	, p.gender
            	, p.status
            	, p.entrance_date
            	, p.retirement_date
        FROM mydb.Professor p 
    """,
    engine
)
Professor_df['retirement_date'] = Professor_df['retirement_date'].where(Professor_df['retirement_date'] != '0000-00-00', None)
Professor_df['entrance_date'] = Professor_df['entrance_date'].where(Professor_df['entrance_date'] != '0000-00-00', None)

# 3. Program
Program_df = pd.read_sql(
    """
        SELECT
            	p.program_id
            	, p.sia_code
            , p.education_level
            	, p.name
            	, p.mandatory_disciplinary_credits
            	, p.mandatory_fundamental_credits
            	, p.optional_disciplinary_credits
            	, p.optional_fundamental_credits
            	, p.free_choice_credits
            	, p.department
            	, p.faculty
            	, p.campus 
        FROM mydb.Program p 
    """,
    engine
)

# 4. Student
Student_df = pd.read_sql(
    """
        SELECT
        	s.student_id
        	, s.name 
        	, s.birthday birthdate
        	, s.nationality
        	, s.gender
        	, s.country
        	, s.city
        FROM mydb.Student s;
    """,
    engine
)


# 5. AcademicHistory
AcademicHistory_df = pd.read_sql(
    """
        SELECT
        	ah.academic_history_id
        	, ah.program_id
        	, ah.sia_code
        	, ah.start_date
        	, ah.end_date
        	, ah.status
        FROM mydb.AcademicHistory ah;
    """,
    engine
)
AcademicHistory_df['start_date'] = AcademicHistory_df['start_date'].where(AcademicHistory_df['start_date'] != '0000-00-00', None)
AcademicHistory_df['end_date'] = AcademicHistory_df['end_date'].where(AcademicHistory_df['end_date'] != '0000-00-00', None)

# 6. Date
min_date = "2000-01-01"
max_date = "2025-12-31"

Date_df = pd.DataFrame({'date': pd.date_range(start=min_date, end=max_date, freq='D')})

# Date_df[['year', 'week', 'weekday']] = Date_df['date'].dt.isocalendar()
Date_df['year'] = Date_df['date'].dt.year
Date_df['week'] = Date_df['date'].dt.isocalendar().week
Date_df['weekday'] = Date_df['date'].dt.weekday
Date_df['month'] = Date_df['date'].dt.month
Date_df['month_name'] = Date_df['date'].dt.strftime("%b")
Date_df['semester'] = np.where(Date_df['date'].dt.quarter.gt(2), 2, 1) 
Date_df['quarter'] = Date_df['date'].dt.quarter
Date_df['bimester'] = Date_df['month'].apply(lambda x: (x - 1) // 2 + 1)
Date_df['date_id'] = Date_df['year'].astype('str') + Date_df['month'].astype('str').str.pad(width=2, fillchar='0') + Date_df['date'].dt.dayofyear.astype('str').str.pad(width=3, fillchar='0')
Date_df['date_id'] = Date_df['date_id'].astype('int')

Date_df = Date_df[['date_id', 'date', 'year', 'semester', 'quarter', 'bimester', 'month', 'month_name', 'week', 'weekday']]


# -------------------------- 1.2. Create Facts --------------------------------

# 1. GradesFact
GradesFact_df = pd.read_sql(
    """
    SELECT
    	CONCAT(
    		SUBSTRING(g.semester, 1, 4)
    		, CASE WHEN SUBSTRING(g.semester, 6, 2) = '1' THEN '06180' ELSE '12360' END
    	) grade_date_id,
    	c.course_id
    	, g.group_id
    	, g.professor_id
    	, ah.student_id
    	, ah.program_id
    	, ah.academic_history_id
    	, hc.history_course_id
    	, hc.grade
    	, (CASE WHEN hc.grade >= 3.0 THEN 1 ELSE 0 END) approved 
    FROM mydb.HistoryCourse hc 
    INNER JOIN mydb.`Group` g ON hc.group_id = g.group_id 
    INNER JOIN mydb.Course c ON c.course_id = g.course_id  
    INNER JOIN mydb.AcademicHistory ah ON ah.academic_history_id =hc.academic_history_id 
    """,
    engine
).astype({'grade_date_id': 'int'})

# 2. CourseFact
CourseFact_df = pd.read_sql(
    """
        SELECT 
           	g.course_id 
           	, g.group_id
           	, t.program_id
           	, g.professor_id
           	, SUM(hc.grade) grade_sum
           	, COUNT(hc.academic_history_id) student_count
           	, SUM(CASE WHEN hc.grade >= 3.0 THEN 1 ELSE 0 END) approved_count
           	, SUM(CASE WHEN hc.grade >= 3.0 THEN 0 ELSE 1 END) failed_count
        FROM mydb.`Group` g 
        INNER JOIN mydb.Course c ON g.course_id = c.course_id 
        INNER JOIN mydb.Typology t ON t.course_id = c.course_id
        INNER JOIN mydb.HistoryCourse hc on hc.group_id = g.group_id 
        GROUP BY g.course_id, g.group_id, t.program_id, g.professor_id;
    """,
    engine
)

# 3 . CurriculumFact
CurriculumFact_df = pd.read_sql(
    """
        SELECT t.program_id
        	, c.course_id
        , g.group_id
        	, COUNT(*) count_prerequisites
        FROM mydb.Prerequisite p 
        INNER JOIN mydb.Typology t ON t.typology_id = p.main_course_typology_id 
        INNER JOIN mydb.Course c ON t.course_id = c.course_id 
        INNER JOIN mydb.`Group` g ON g.course_id = c.course_id
        GROUP BY t.program_id, c.course_id, g.group_id
    """,
    engine
)

# ----------------------- 2. Load Into Warehouse ------------------------------
def delete_contents_warehouse(engine, table):
    with engine.connect() as connection:
        connection.execute(f"DELETE FROM GradesWarehouse.{table}")
# ---------------------- 2.1. Load Dimensions ---------------------------------

connection_string = f"mysql+pymysql://{uid}:{pwd}@{server}"
engine = create_engine(connection_string)

delete_contents_warehouse(engine, "CourseGroup")
CourseGroup_df.to_sql(name="CourseGroup", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "Professor")
Professor_df.to_sql(name="Professor", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "Program")
Program_df.to_sql(name="Program", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "AcademicHistory")
AcademicHistory_df.to_sql(name="AcademicHistory", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "Student")
Student_df.to_sql(name="Student", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "Date")
Date_df.to_sql(name="Date", con=engine, schema='GradesWarehouse', if_exists='append', index=False)


# -------------------------- 2.2. Load Facts ----------------------------------
delete_contents_warehouse(engine, "GradesFact")
GradesFact_df.to_sql(name="GradesFact", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "CourseFact")
CourseFact_df.to_sql(name="CourseFact", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

delete_contents_warehouse(engine, "CurriculumFact")
CurriculumFact_df.to_sql(name="CurriculumFact", con=engine, schema='GradesWarehouse', if_exists='append', index=False)

