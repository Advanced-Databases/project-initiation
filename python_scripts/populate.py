#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 23:07:55 2023

@author: edwmapa
"""
from faker import Faker
import pandas as pd
import numpy as np
import datetime
import random
from itertools import cycle

fake = Faker()

def generate_students(num_students):
    users = []
    for i in range(num_students):
        name = fake.first_name()
        last_name = fake.last_name()
        birthday = fake.date_of_birth()
        nationality = random.choices([fake.country(), 'Colombia'], weights=[0.05, 0.95])[0]
        gender = random.choice(['Male', 'Female'])
        
        if nationality == 'Colombia':
            country = random.choices([fake.country(), 'Colombia'], weights=[0.1, 0.9])[0]
        else:
            country = fake.country()
        
        if country == 'Colombia':
            city = random.choices(['Bogota', 'Medellin', 'Cali', 'Rural Colombia'], weights=[0.7, 0.2, 0.05, 0.05])[0]
        else:
            city = fake.city()
        
        email = fake.email()
        user = {
            "student_id": i + 1, 
            "name": name,
            "lastname": last_name,
            "birthday": birthday,
            "nationality": nationality,
            "gender": gender,
            "country": country,
            "city": city,
            "email": email,
        }
        users.append(user)
    return users

def generate_academic_histories(Student_df, Programs_df):
    program_choices = Programs_df[['program_id', 'name']].to_dict(orient='records')
    assert len(program_choices) == 3
    
    histories = []
    academic_history_id = 1
    for i, s in Student_df.iterrows():
        student_id = s['student_id']
        n_programs = random.choices([1, 2, 3], weights=[0.8, 0.15, 0.05])[0]
        for p in range(n_programs):
            program = random.choices(program_choices, weights=[0.85, 0.1, 0.05])[0]
            sia_code = random.randint(10000, 500000)
            status = random.choices(['ACTIVE', 'INACTIVE'], weights=[0.9, 0.1])[0]            
            start_date = fake.date_between(start_date = datetime.date(2008, 1, 1))
            end_date = fake.date_between(
                start_date = datetime.date(start_date.year + 4, 1, 1),
                end_date = datetime.date(start_date.year + 7, 12, 31)
            )
            
            if status == 'INACTIVE':
                end_date = random.choices([end_date, None], weights=[0.9, 0.1])[0]
            
            histories.append({
                'academic_history_id': academic_history_id,
                'student_id': student_id,
                'program_id': program['program_id'],
                'sia_code': sia_code,
                'name': program['name'],
                'status': status,
                'start_date': start_date.strftime("%Y-%m-%d"),
                'end_date': end_date.strftime("%Y-%m-%d") if end_date is not None else None
            })
            academic_history_id += 1
    return histories

def generate_professors(num_professors):
    users = []
    for i in range(num_professors):
        name = fake.first_name()
        last_name = fake.last_name()
        birthday = fake.date_of_birth()
        nationality = random.choices([fake.country(), 'Colombia'], weights=[0.05, 0.95])[0]
        gender = random.choice(['Male', 'Female'])
        
        email = fake.email()
        status = None
        entrance_date = fake.date_between(start_date = datetime.date(1970, 1, 1))
        retirement_date = None
        
        user = {
            "professor_id": i + 1, 
            "name": name,
            "lastname": last_name,
            "birthday": birthday,
            "nationality": nationality,
            "gender": gender,
            "email": email,
            "status": status,
            "entrance_date": entrance_date,
            "retirement_date": retirement_date
        }
        users.append(user)
    return users

def create_groups(Professor_df, Course_df, max_groups=4):
    professor_ids = Professor_df['professor_id'].tolist()

    groups = []
    group_id = 1    
    for j, course in Course_df.iterrows():
        course_id = course['course_id']
        for year in range(2008, 2023):        
            for semester in [1, 2]:
                n_groups = random.randint(1, max_groups) # n groups per course per semester
                for group_number in range(1, n_groups+1):
                    seats = random.randint(20, 50)
                    groups.append({
                        'group_id': group_id,
                        'group_number': group_number,
                        'semester': f"{year}-{semester}",
                        'seats': seats,
                        'course_id': course_id
                    })
                    group_id += 1
    
    random.shuffle(groups)
    for i, professor_id in zip(range(len(groups)), cycle(professor_ids)):
        groups[i]['professor_id'] = professor_id
    return groups

def create_schedule(
    Groups_df,
    periods=2,
    hour_ranges=[6, 20],
    duration_hours = 2
):
    schedule = []
    schedule_id = 1
    for i, group in Groups_df.iterrows():
        classroom_name = fake.color_name()
        classroom_code = random.randint(100, 500)
        start_hour = random.randint(*hour_ranges)
        end_hour = start_hour + duration_hours
        
        weekdays = []
        for p in range(periods):
            new_weekday = random.randint(1, 7)
            if len(weekdays) == 0:
                weekdays.append(new_weekday)
            else:
                while new_weekday in set(weekdays):
                    new_weekday = random.randint(1, 7)
                weekdays.append(new_weekday)
        
            schedule.append({
                'schedule_id': schedule_id,
                'group_id': group['group_id'],
                'classroom_name': classroom_name,
                'classroom_code': classroom_code,
                'weekday': new_weekday,
                'start_hour': start_hour,
                'end_hour': end_hour
            })
            schedule_id += 1
    return schedule


def create_history_course(AcademicHistory_df, Groups_df):
    academic_history = AcademicHistory_df.copy()
    academic_history['start_semester'] = academic_history['start_date'].dt.year.astype('str') + '-' + np.where(academic_history['start_date'].dt.quarter.gt(2), 2, 1).astype('str')
    academic_history['end_semester'] = academic_history['end_date'].dt.year.astype('str') + '-' + np.where(academic_history['end_date'].dt.quarter.gt(2), 2, 1).astype('str')
    
    history_course = []
    history_course_id = 1
    for i, a in academic_history.iterrows():
        groups_sample = Groups_df[(Groups_df['semester'] >= a['start_semester']) & (Groups_df['semester'] <= a['end_semester'])]
        if len(groups_sample) == 0: continue
        groups_sample.groupby('course_id')\
            .sample(n=1)\
            .reset_index(drop=True)[['group_id']]
        groups_sample = groups_sample.sample(n=random.randint(5, len(groups_sample)))['group_id'].tolist()
        
        for group_id in groups_sample:
            grade = np.round(np.random.uniform() * 5, 1)
            history_course.append({
                'history_course_id': history_course_id,
                'academic_history_id': a['academic_history_id'],
                'group_id': group_id,
                'grade': grade,
                'typology': None
            })
            history_course_id += 1
            
    return history_course

# Load predefined sets
Programs_df = pd.read_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/programs.csv')
Courses_df = pd.read_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/system_courses.csv')
Typologies_df = pd.read_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/typologies.csv')
Prerequisites_df = pd.read_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/prerequisites.csv')


# ----------------------- 1. Creating fake data -------------------------------
# Params:
n_students = 1000
n_professors = 30
max_groups_period = 4

# 1. Creating students
Student_df = pd.DataFrame(generate_students(n_students))

# 2. Create Profesors
Professor_df = pd.DataFrame(generate_professors(n_professors))

# 3. Create Academic Histories.
# Note: Most students have only one history, going to fake to generate few cases
# with more than one history
AcademicHistory_df = pd.DataFrame(generate_academic_histories(Student_df, Programs_df))
AcademicHistory_df = AcademicHistory_df.astype({'start_date': 'datetime64', 'end_date':'datetime64'})

# 4. Create Groups
Groups_df = pd.DataFrame(create_groups(Professor_df, Courses_df, max_groups_period))
Groups_df = Groups_df[['group_id', 'group_number', 'semester', 'seats', 'professor_id', 'course_id']]

# 5. Create Schedules
Schedule_df = pd.DataFrame(create_schedule(Groups_df))

#6. Create HistoryCourse (grades)
HistoryCourse_df = pd.DataFrame(create_history_course(AcademicHistory_df, Groups_df))

# -------------------------------- 2. Save to CSV -----------------------------

Student_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/students.csv', index=False)
Professor_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/professors.csv', index=False)

AcademicHistory_df['start_date'] = AcademicHistory_df['start_date'].dt.strftime("%Y-%m-%d")
AcademicHistory_df['end_date'] = AcademicHistory_df['end_date'].dt.strftime("%Y-%m-%d")
AcademicHistory_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/academic_histories.csv', index=False)

Groups_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/groups.csv', index=False)
Schedule_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/schedules.csv', index=False)
HistoryCourse_df.to_csv('/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/history_courses.csv', index=False)



