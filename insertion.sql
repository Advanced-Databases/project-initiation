#To insert data into Course table
LOAD DATA LOCAL INFILE
'/home/brian/advanced_databases/system_courses.csv'
INTO TABLE Course
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Program table
LOAD DATA LOCAL INFILE
'/home/brian/advanced_databases/programs.csv'
INTO TABLE Program
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE table `Group` ; 

#To insert data into Student table
LOAD DATA LOCAL INFILE
'/Users/admin/Documents/unal/Transactional-Databases/students.csv'
INTO TABLE Student
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Professor table
LOAD DATA LOCAL INFILE
'/Users/admin/Documents/unal/Transactional-Databases/professors.csv'
INTO TABLE Professor 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Group table
LOAD DATA LOCAL INFILE
'/Users/admin/Documents/unal/Transactional-Databases/groups.csv'
INTO TABLE `Group`  
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#To insert data into Schedule table
LOAD DATA LOCAL INFILE
'/Users/admin/Documents/unal/Transactional-Databases/schedules.csv'
INTO TABLE `Group`  
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;