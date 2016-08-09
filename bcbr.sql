

DROP TABLE IF EXISTS loader_redbull;
CREATE TABLE loader_redbull (
one INTEGER(4),
position INTEGER(4),
name VARCHAR(1024) DEFAULT '',
team VARCHAR(1024) DEFAULT '',
category VARCHAR(40) DEFAULT '',
country VARCHAR(40) DEFAULT '',
plate VARCHAR(10) DEFAULT '',
time VARCHAR(20) DEFAULT '',
city VARCHAR(255) DEFAULT '',
category_position INTEGER(4),
speed DECIMAL(4,2),
team2 VARCHAR(1024) DEFAULT '',
PRIMARY KEY (position)
);

DROP TABLE IF EXISTS loader;
CREATE TABLE loader (
one INTEGER(4),
position INTEGER(4),
name VARCHAR(1024) DEFAULT '',
team VARCHAR(1024) DEFAULT '',
category VARCHAR(40) DEFAULT '',
gender VARCHAR(4) DEFAULT '',
country VARCHAR(40) DEFAULT '',
nope VARCHAR(4) DEFAULT '',
plate VARCHAR(10) DEFAULT '',
time VARCHAR(20) DEFAULT '',
city VARCHAR(255) DEFAULT '',
category_position VARCHAR(4) DEFAULT '',
speed DECIMAL(4,2),
team2 VARCHAR(1024) DEFAULT '',
PRIMARY KEY (position)
);

DROP TABLE IF EXISTS results;
CREATE TABLE results (
year INTEGER(4),
stage INTEGER(4),
-- stage_name VARCHAR(1024) DEFAULT '',
position INTEGER(4),
name VARCHAR(1024) DEFAULT '',
team VARCHAR(1024) DEFAULT '',
category VARCHAR(40) DEFAULT '',
gender VARCHAR(4) DEFAULT '',
country VARCHAR(40) DEFAULT '',
plate VARCHAR(10) DEFAULT '',
plate_gender VARCHAR(10) DEFAULT '',
time VARCHAR(20) DEFAULT '',
city VARCHAR(255) DEFAULT '',
category_position VARCHAR(4) DEFAULT '',
speed DECIMAL(4,2),
team2 VARCHAR(1024) DEFAULT '',
PRIMARY KEY (year,stage,plate_gender)
);

-- useful stuff
-- stages
-- select distinct year, stage, count(*) as rider_count from results group by year, stage;
-- riders
-- select distinct year, plate_gender, name, team, team2, gender, plate, country, city, category from results;
