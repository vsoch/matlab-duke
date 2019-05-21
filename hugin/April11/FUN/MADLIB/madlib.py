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
    print '\nMADLIB: ' + self.outputname + ' ' + str(today)
    fwrite.close()
  
#---------------------------------------------------
# readFile: reads in specified file, writes new lib
  def readFile(self):  
    # Read all words into a list
    words = list(open(self.madlibname).read().split())
    # Set up the expression that we want to search for
    expression = re.compile('SUB_([^\s])+_SUB',re.IGNORECASE)
    wordcount=-1
    if (len(words)>0):    
      for word in words:  # go through the words one at a time
        wordcount=wordcount+1;
	
        current=expression.search(word) 
	if (current!=None):
	  word = self.getWord(word[current.start()+4:current.end()-4])  # Prompt the user for new word
	  words.insert(wordcount,word)                                  # Place new word back in list
	  words.pop(wordcount+1)
  
      # Print output to window     
      for word in words:
        sys.stdout.writelines(word)
	sys.stdout.writelines(" ")
      
      self.createLib(words)     # Print output to file
  
#---------------------------------------------------
# getWords: reads in user specified words
  def getWord(self,word):
    print "Please enter " + word + " and press [ENTER]"
    wordchoice=raw_input("-->")
    return wordchoice
    
#---------------------------------------------------
# createLib: prints finished madlib for user
  def createLib(self,listy):
    fread=open(self.outputname,'w')
    for i in range(len(listy)):
      fread.write(listy[i] + ' ')
    print "\n\nThank you for using madlib.py!\n"

#---------------------------------------------------
# main: runs when madlab.py is called
def main():
  mymadlib = madlib()
  mymadlib.getFile()
  mymadlib.outputName()
  mymadlib.readFile()
  
# Only call 'main' if you're being run as a script.   
# Otherwise, do nothing and act like an object for another script.
if __name__ == '__main__':
  main()
