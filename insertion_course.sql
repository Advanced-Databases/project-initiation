LOAD DATA LOCAL INFILE
'/home/brian/advanced_databases/materias_sistemas.csv'
INTO TABLE Course
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;