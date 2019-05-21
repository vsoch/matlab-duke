#!/usr/bin/python

import sys
import os.path
import re
import datetime

#-MADLIB---------------------------------------------------------------------
# reads in a user selected text file with a story and words to be filled in,
# words are in the format SUB_ADJECTIVE_SUB, where the ADJECTIVE will get 
# presented to the user to specify the input desired.

# The line above is to run the script using ./madlib.py.
# Change the path after the shebang (#!) to whatever your python path is.


# 'madlib' is the name of the class.
# Any inherited classes go in the ().
class madlib:

#---------------------------------------------------
# __init__: class constructor, self is the object
  def __init__(self):
    self.fillerwords = list()  # This is going to be a list read from file
    self.userwords = list()    # This is going to be user specified words
    self.madlibname = None     # This is the name of the matlab file
    self.outputname = None     # This is the name of the output file
    
#---------------------------------------------------
# __repr__: defines object when printed
  def __repr__(self):
    return "<Madlib File: %s, Output: %s>"%(self.madlibname,self.outputname)

#---------------------------------------------------
# getFile: reads in user specified madlab .txt file
  def getFile(self):
    self.madlibname = raw_input("\nEnter path to madlib text file: ")
    extensions = ('.txt', '.doc')
    ext = os.path.splitext(self.madlibname)
    while not ext[len(ext)-1] in extensions:
      print "Not a valid extension."
      self.madlibname = raw_input("\nEnter path to madlib text file: ")
      ext = os.path.splitext(self.madlibname)
      
    # Check that user selected a file that exists     
    try:    # Check that file exists
      fread = open(self.madlibname)       
    except IOError:                     
      print "The file does not exist, exiting."
      sys.exit()
    	
#---------------------------------------------------
# outputName: Asks the user for output name, creates file
  def outputName(self):
    self.outputname = raw_input("Enter desired output file name (no extension): ");
    # Check that the file doesn't already exist
    while os.path.isfile(self.outputname +'.txt'):
      self.outputname = raw_input("Output already exists! Enter another: ");
    fwrite=open(self.outputname,'w')
    today = datetime.date.today()
    print 'MADLIB: ' + self.outputname + ' ' + str(today)
    fwrite.close()
  
#---------------------------------------------------
# readFile: reads in specified file, writes new lib
  def readFile(self):
    fread=open(self.madlibname,'r')
    for line in fread:  # go through the file one line at a time
       # Read until the first SUB_ is found, replace sub with user input, when
       expression = re.compile('SUB_([^\s])+_SUB',re.IGNORECASE)
       entireline = ''
       current = expression.search(line)
       if (current==None):
         entireline = entireline + line 
	
       else:
         while (current!=None):
           before_fill=line[0:current.start()]
	   fill = self.getWord((line[(current.start()+4):(current.end()-4)]))
           after_fill=line[current.end():len(line)]
	   entireline=entireline + before_fill + fill
	   current = expression.search(after_fill)
	   
         entireline=entireline + after_fill
       fwrite=open(outputname,'a')
       print entireline
       fwrite.close()
    fread.close()
  
#---------------------------------------------------
# getWords: reads in user specified words
  def getWord(word,self):
    print "Please enter " + word + " and press [ENTER]"
    wordchoice=input("")
    return wordchoice
    
#---------------------------------------------------
# createrLib: prints finished madlib for user
  def createLib(self):
    fread=open(self.outputname,'r')
    filetext = fread.read()  # Read the entire madlib
    raw_input('\n\nPlease press enter to view your completed madlib!')
    print filetext
  

#---------------------------------------------------
# main: runs when madlab.py is called
def main():
  mymadlib = madlib()
  mymadlib.getFile()
  mymadlib.outputName()
  mymadlib.readFile()
  mymadlib.createLib()
  
# Only call 'main' if you're being run as a script.   
# Otherwise, do nothing and act like an object for another script.
if __name__ == '__main__':
  main()
