#!/usr/bin/env python

"""
Loads an bcbr results into a Mysql database

Usage: %(PROGRAM)s [options]

Options:
  -h/--help
    Print this message and exit
"""

import atexit
import os
import ConfigParser
import MySQLdb
import datetime
import logging
import sys
import getopt

def Usage(code, msg=''):
  if code:
    fd = sys.stderr
  else:
    fd = sys.stdout
  PROGRAM = os.path.basename(sys.argv[0])
  print >> fd, __doc__ % locals()
  if msg:
    print >> fd, msg
  sys.exit(code)

def LoadDay(cursor, day_number):
  sql = """load data local infile %s
      into table loader
      fields terminated by ","
      enclosed by '"'
      lines terminated by '\n'
"""
  os.system("""iconv -c -f ascii -t utf-8 "day%d.csv" > "/tmp/day%d.csv" """ % (day_number, day_number))

  file_name = "/tmp/day%(day)s.csv" % {"day": day_number}
  cursor.execute("delete from loader")
  cursor.execute(sql, (file_name,))
  # now move it over
  race = "BCBR"
  year = 2016
  cursor.execute("delete from results where race = %s and year = %s and stage = %s", (race, year, day_number))
  sql = """insert into results select
%s,
%s,
%s,
position,
name,
team,
category,
gender,
country,
plate,
concat(plate, gender),
time,
city,
category_position,
speed,
team2
from loader
"""
  cursor.execute(sql, (race, year, day_number))


def LoadStages(cursor):
  race = "BCBR"
  year = 2016
  cursor.execute("delete from stages where race = %s and year = %s", (race, year))
  sql = """insert into stages select distinct
race,
year,
stage,
"",
count(*),
0,
0
from results
group by race, year, stage
"""
  cursor.execute(sql)

  BCBR_INFO = [
    {"stage": 1, "length": 28, "climbing": 3803, "name": "Cumbria"},
    {"stage": 2, "length": 32, "climbing": 3597, "name": "Powell River"},
    {"stage": 3, "length": 36, "climbing": 5246, "name": "Earls Cove to Sechelt"},
    {"stage": 4, "length": 32, "climbing": 4949, "name": "Sechelt"},
    {"stage": 5, "length":  9, "climbing": 2780, "name": "North Vancouver"},
    {"stage": 6, "length": 33, "climbing": 6378, "name": "Squamish"},
    {"stage": 7, "length": 16, "climbing": 3511, "name": "Whistler"},
  ]

  for stage in BCBR_INFO:
    sql = """update stages set """
    values = []
    stage_number = 0
    sets = []
    for key, value in stage.items():
      if key == "stage":
        stage_number = value
        continue
      sets.append("%s = %%s" % key)
      values.append(value)
    sql += ", ".join(sets)
    sql += " where race = %s and year = %s and stage = %s"
    values.append(race)
    values.append(year)
    values.append(stage_number)
    logging.info("Updating stage: %r", values)
    cursor.execute(sql, values)


def LoadRacers(cursor):
  race = "BCBR"
  year = 2016
  cursor.execute("delete from racers where race = %s and year = %s", (race, year))
  sql = """insert into racers select distinct
race,
year,
plate_gender,
"",
"",
"",
"",
"",
"",
"",
""
from results
group by race, year, plate_gender
"""
  cursor.execute(sql)

  key_columns = "race, year, plate_gender"
  value_columns = "name, team, category, gender, country, plate, city, team2"
  sql = """select """
  sql += key_columns
  sql += ", "
  sql += value_columns
  sql += """ from results where race = %s and year = %s"""
  cursor.execute(sql, (race, year))

  rows = cursor.fetchall()

  for row in rows:
    if not row:
      break
    sql = """update racers set """
    sets = []
    for key in value_columns.split(", "):
      sets.append("%s = %%s" % key)
    sql += ", ".join(sets)
    sql += " where race = %s and year = %s and plate_gender = %s"
    values = list(row)
    for key in key_columns.split(", "):
      values.append(values.pop(0))
    cursor.execute(sql, values)

def Main():
  # began = str(datetime.datetime.today())
  logging.basicConfig()
  logging.getLogger().setLevel(logging.DEBUG)
  try:
    opts, args = getopt.getopt(sys.argv[1:], 'h',
                               ['help'])
  except getopt.error, msg:
    Usage(1, msg)

  if args:
    Usage(1)

  config = ConfigParser.ConfigParser()
  config.read(['bcbr.config', os.path.expanduser('~/.bcbr.config')])

  for opt, _ in opts:
    if opt in ('-h', '--help'):
      Usage(0)

  connection_args = {
    "host": config.get("client", "host"),
    "db": config.get("client", "database"),
    "user": config.get("client", "user"),
    "passwd": config.get("client", "password"),
    "local_infile": 1
  }
  if config.has_option("client", "port"):
    connection_args["port"] = int(config.get("client", "port"))

  connection = MySQLdb.connect(**connection_args)
  connection.autocommit(True)
  atexit.register(lambda: connection.close())
  cursor = connection.cursor()

  for day_number in range(1, 8):
    logging.info("loading day %d", day_number)
    LoadDay(cursor, day_number)
  LoadStages(cursor)
  LoadRacers(cursor)

if __name__ == '__main__':
  Main()
