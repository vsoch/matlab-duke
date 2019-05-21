#!/usr/bin/python

import re

file = open('data','r')

expression = r'\s(\w{6})\s'

fileout = open('output','w')

results = re.compile(expression).findall(file.read())

for result in results:
  setting = result[-3:] + "_ _   _ _" + result[:3].lower()
  fileout.write(setting + "\n")
  fileout.write(result + "\n")
  fileout.write("\n\n")
