SET GLOBAL local_infile=1;

#To insert data into Course table
LOAD DATA LOCAL INFILE '/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/system_courses.csv'
INTO TABLE Course
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Program table
LOAD DATA LOCAL INFILE '/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/programs.csv'
INTO TABLE Program
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

#To insert data into Student table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/students.csv'
INTO TABLE Student
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Professor table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/professors.csv'
INTO TABLE Professor 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Group table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/groups.csv'
INTO TABLE `Group`  
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Schedule table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/schedules.csv'
INTO TABLE `Schedule`  
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into AcademicHistory table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/academic_histories.csv'
INTO TABLE AcademicHistory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into HistoryCourse table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/history_courses.csv'
INTO TABLE HistoryCourse
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Typology table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/typologies.csv'
INTO TABLE Typology
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Prerequisite table
LOAD DATA LOCAL INFILE
'/home/edwmapa/git/DBAvanzadas/FirstProject/data_csv/new_inserts/prerequisites.csv'
INTO TABLE Prerequisite
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

