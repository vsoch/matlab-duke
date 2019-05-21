#!/usr/bin/python

import sys
sys.path.append('/home/vvs4/FUN/Puzzle/')   # Add path to solve module
from solve import solve

peoplepuzzle = solve()                # Create new solve object
peoplepuzzle.setFile('professions')   # Give file to object
peoplepuzzle.fileOut('answer')        # Set output file name
peoplepuzzle.parseData('\t')          # Read file

# Read in the first and last names
for i in range(len(peoplepuzzle.data)):
  profession=peoplepuzzle.lookup(i,0)
 
  # Check if the profession has 7 letters
  if len(profession) == 7:
    lasttwo=profession[0:2].lower()   # Break into last two
    firstfour=profession[2:6].lower()			  # Break into first four
    
    # Print line to file as possible answer
    answer= firstfour + '__' + lasttwo + ' ' + profession
    peoplepuzzle.write(answer,"\n")
      



  






