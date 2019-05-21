#!/usr/bin/python

import re
import sys
import os.path
import csv

# solve.py creates basic functionality for reading and writing files,
# to be used to help with solving NPR Puzzle of the weeks!

class solve(object):

#-__init__--------------------
# Defines object when created
  def __init__(self):
    self.file = None     # the data file for reading
    self.fileout = None  # the output file name
    self.fields = []     # A list that holds the column titles of data from file
    self.data = []       # A list that holds raw data for each column
    self.numentries = 0  # The number of data entries (rows)
    self.numfields = 0   # The number of fields (columns) in the file

# -__repr__-------------------
# Defines object when printed  
  def __repr__(self):
    if self.file and self.fileout: return "<File:%s,Output:%s,Fields:%i,Rows:%i>"%(self.file,self.fileout,self.numfields,self.numentries)
    if self.file and not self.fileout: return "<File:%s,Output:Undefined,Fields:%i,Rows:%i>"%(self.file,self.numfields,self.numentries)
    else: return "<File:Undefined,Output:Undefined,Fields:%i,Rows:%i>"%(self.numfields,self.numentries)
    
    
#--------------------------------------------------------------------
# INPUT FUNCTIONS
#--------------------------------------------------------------------
#-setFile---------------------
# Check file exists and is readable 
  def setFile(self,filepath):
    try:  
      self.file = open(filepath,'r')
      print "File " + filepath + " set."
    except IOError:
      print "The file does not exist, exiting"
      return

#-parseData--------------------
# read in columns into list
  def parseData(self,delim):
    if self.file is not None:
      filelist = []
      columns = csv.reader(self.file,delimiter=delim)
      #columnsniff = csv.Sniffer()
      
      for line in columns:
         filelist.append(line)
	 
      #if csv.Sniffer.has_header(columnsniff,'%s %s %s'):
      self.fields = filelist.pop(0) 
      self.numentries = len(filelist)
      self.data = filelist
      self.numfields = len(self.data[0])
      print self
      return
      
#--------------------------------------------------------------------
# READ FUNCTIONS
#--------------------------------------------------------------------         
#-lookup--------------------
# Lookup one data value based on a coordinate
  def lookup(self,row,column):
    return self.data[row][column]
    
# EntireRow returns an entire row of data
  def entireRow(self,row):
    return self.data[row]


#-getFieldNum---------------
# Returns total number of fields (columns), or specific one
  def getFieldNum(self, fieldname = None):
    if not fieldname: return self.numfields
    else:
      for i in range(len(self.fields)):
        if self.fields[i] == fieldname: return i
	else: print "Field name not found" 
	  

#-getFieldName--------------------
# return list of header titles, or one header title
  def getFieldName(self,loc=None):
    if self.fields and loc in range(len(self.fields)): return self.fields[loc]
    elif self.fields: return self.fields
    else: print "No fields found."
    return 

#--------------------------------------------------------------------
# OUTPUT FUNCTIONS
#--------------------------------------------------------------------
#-fileOut-------------------
# Output file creation
  def fileOut(self,outputname):
    self.fileout = outputname
    print self
    return

#-writeRow--------------------
# Write line of complete data to output file
  def writeRow(self,row):
    self.writeOut(self.data[row],"/n")
    return


#-writeOut--------------------
# Write line of complete data to output file
  def writeOut(self,towrite,separator="\n"):
    if not self.fileout: print "Output file not defined.  Use .fileOut() to set outfile."
    else:
      try:
        outputfile = open(self.fileout,'a')
      except IOError: print "Output file not found.  Use .fileOut() to set outfile" 
      outputfile.write(str(towrite) + separator)
      outputfile.write("\n")
      outputfile.close()        
    return
    
#-write--------------------
# Write list or other to outfile
  def write(self,towrite,separator):
     if type(towrite) is 'list':
       for i in range(len(towrite)):
         self.writeOut(towrite[i],separator)
     else: self.writeOut(towrite,separator)
     return


#-main-------      
# Main class      
def main():
  puzzle = solve()
    
# If being called as object and not directly, call this main
if __name__ == '__main__':
  main()
