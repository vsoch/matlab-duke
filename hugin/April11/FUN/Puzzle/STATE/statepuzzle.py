#!/usr/bin/python

from solve import solve

statepuzzle = solve()     # Create new solve object
statepuzzle.setFile('data')     # Give file to object
statepuzzle.fileOut('answer')   # Set output file name
statepuzzle.parseData('\t')     # Read file

# Read in the city and state
for i in range(len(statepuzzle.data)):
  print statepuzzle.entireRow(i)
  state=statepuzzle.lookup(i,1)
  city=statepuzzle.lookup(i,0)
  
  # Split the string by characters, put into list
  state = list(state.lower())
  city = list(city.lower())  

  # Get rid of spaces
  while ' ' in city: city.remove(' ')
  while ' ' in state: state.remove(' ')

  # Find the number of matching letters
  sharedcount=0
  if len(city) is len(state):
    for j in range(len(state)):
      if state[j] in city:
        sharedcount=sharedcount+1
       
  # Print line to file as possible answer
    if sharedcount == len(state)-1:
      statepuzzle.writeOut(i)
    
      



  






