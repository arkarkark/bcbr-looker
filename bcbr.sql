

drop table if exists loader_redbull;
create table loader_redbull (
one integer(4),
position integer(4),
name varchar(1024) default '',
team varchar(1024) default '',
category varchar(40) default '',
country varchar(40) default '',
plate varchar(10) default '',
time varchar(20) default '',
city varchar(255) default '',
category_position integer(4),
speed decimal(4,2),
team2 varchar(1024) default '',
primary key (position)
);

drop table if exists loader;
create table loader (
one integer(4),
position integer(4),
name varchar(1024) default '',
team varchar(1024) default '',
category varchar(40) default '',
gender varchar(4) default '',
country varchar(40) default '',
nope varchar(4) default '',
plate varchar(10) default '',
time varchar(20) default '',
city varchar(255) default '',
category_position varchar(4) default '',
speed decimal(4,2),
team2 varchar(1024) default '',
primary key (position)
);

drop table if exists results;
create table results (
race varchar(512) default '',
year integer(4),
stage integer(4),
-- stage_name varchar(1024) default '',
position integer(4),
name varchar(1024) default '',
team varchar(1024) default '',
category varchar(40) default '',
gender varchar(4) default '',
country varchar(40) default '',
plate varchar(10) default '',
plate_gender varchar(10) default '',
time varchar(20) default '',
city varchar(255) default '',
category_position varchar(4) default '',
speed decimal(4,2),
team2 varchar(1024) default '',
primary key (race, year,stage,plate_gender)
);

-- useful stuff
-- stages
-- select distinct year, stage, count(*) as rider_count from results group by year, stage;
-- riders
-- select distinct year, plate_gender, name, team, team2, gender, plate, country, city, category from results;

drop table if exists stages;
create table stages (
race varchar(512) default '',
year integer(4),
stage integer(4),
name varchar(1024) default '',
rider_count integer(4),
length integer(4),
climbing integer(4),

primary key (race, year,stage)
);

drop table if exists racers;
create table racers (
race varchar(512) default '',
year integer(4),
plate_gender varchar(10) default '',
name varchar(1024) default '',
team varchar(1024) default '',
category varchar(40) default '',
gender varchar(4) default '',
country varchar(40) default '',
plate varchar(10) default '',
city varchar(255) default '',
team2 varchar(1024) default '',
primary key (race, year, plate_gender)
);


drop table if exists racers;
create table racers (
race varchar(512) default '',
year integer(4),
plate_gender varchar(10) default '',
name varchar(1024) default '',
team varchar(1024) default '',
category varchar(40) default '',
gender varchar(4) default '',
country varchar(40) default '',
plate varchar(10) default '',
city varchar(255) default '',
team2 varchar(1024) default '',
primary key (race, year, plate_gender)
);


drop table if exists categories;
create table categories (
race varchar(512) default '',
year integer(4),
id varchar(10),
name varchar(1024) default '',
primary key (id)
);

insert into categories values
("BCBR", 2016, 1, "Solo Open Men"),
("BCBR", 2016, 2, "Solo Open Women"),
("BCBR", 2016, 3, "Solo 40+ Men"),
("BCBR", 2016, 4, "Solo 40+ Women"),
("BCBR", 2016, 5, "Solo 50+ Men"),
("BCBR", 2016, 6, "Solo 50+ Women"),
("BCBR", 2016, 7, "Team of 2 Open Men"),
("BCBR", 2016, 8, "Team of 2 Open Women"),
("BCBR", 2016, 9, "Team of 2 Open Mixed"),
("BCBR", 2016, 10, "Team of 2 Veterans 80+"),
("BCBR", 2016, 11, "Team of 2 Veterans 100+"),
("BCBR", 2016, 12, "Solo Men 40+"),
("BCBR", 2016, 15, "UNKNOWN"), ("BCBR", 2016, "", "UNKNOWN")
;
