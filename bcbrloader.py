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
  year = 2016
  cursor.execute("delete from results where year = %s and stage = %s", (year, day_number))
  sql = """insert into results select
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
  cursor.execute(sql, (year, day_number))


def Main():
  began = str(datetime.datetime.today())
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

  for opt, arg in opts:
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

if __name__ == '__main__':
  Main()
