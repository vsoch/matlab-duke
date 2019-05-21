#!/usr/bin/python

import sys
sys.path.append('/home/vvs4/FUN/Puzzle/')   # Add path to solve module
from solve import solve

peoplepuzzle = solve()           # Create new solve object
peoplepuzzle.setFile('peopletoo')   # Give file to object
peoplepuzzle.fileOut('answer')   # Set output file name
peoplepuzzle.parseData('\t')     # Read file

# Read in the first and last names
for i in range(len(peoplepuzzle.data)):
  first=peoplepuzzle.lookup(i,0)
  last=peoplepuzzle.lookup(i,1)
 
  # Check if the last name has 7 letters
  if len(last) == 7:
    lasttwo=last[len(last)-2:len(last)].lower()   # Break into last two
    firstfour=last[0:4].lower()			  # Break into first four
    profession=lasttwo + firstfour
    
    # Print line to file as possible answer
    answer=profession + ' ' + first + ' ' + last 
    peoplepuzzle.write(answer,"\n")
      



  






