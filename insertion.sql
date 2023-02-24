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