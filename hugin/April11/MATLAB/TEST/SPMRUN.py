#!/usr/bin/python

import sys
import os.path
import re
import datetime

#-SPMRUN---------------------------------------------------------------------
# an spmbatch object is created, one per subject, by spmsubmit.py, and
# data and a matlabbatch .mat file is prepared before submitting the
# spmbatch script to run on the cluster.  This script is customizable
# for different spm analysis and datatypes.  The following must be set 
# before the script will run the .mat job:
#
# 1. .mat file and user ID specified
# 2. variables to go into .mat read into dictionary and specified (need a way for user to input variables in spmsubmit.py, and for this script to check
# that all those variables have been input and written to the ,mat file!
# 3. Check that all variables input to dictionary, set self.ready to 1
# 4. Create output folders
# 5. Submit!

# also need to have some way to print the various functions of this script...

class spmrun:

#---------------------------------------------------
# __init__: class constructor, self is the object
  def __init__(self):
    self.matfile = None     # This is the name of the matlab design file
    self.subid = None       # This is the subject ID (maybe should be top dictionary variable)
    self.ready = 0;	    # 0 when incomplete,1 when ready for submit
    self.variables = # should be a dictionary of vars, start off null...
    self.outputFolders =     # should be a list of output folders to make, starting null
    self.display = False     # display default is set to off

# VARIABLES WE NEED
# biacroot
# path to matlab
# subject ID
# output folder - one attached to each task/run?
# .mat file directory and name
# variables read from .mat
# processing choices and order numbers, if applicable
# display on/off
# cluster path (to be filled in by script, replaced in .mat) - user can select to concatenate cluster path with various other variables

    
#---------------------------------------------------
# __repr__: defines object when printed
  def __repr__(self):
    return "<MAT File: %s,Subject: %s,Ready: %i>"%(self.matfile,self.subid,self.ready)

#---------------------------------------------------
# READ and WRITE (SETUP) FUNCTIONS
#---------------------------------------------------
# setSUB: sets subject ID (or should this be one of the first dictionary variables?)
  def setSUB(self,userid):
    # read in userID
    
#---------------------------------------------------
# writeMAT: writes user specific mat file and saves
  def writeMAT(self):
     # check that .mat / .m script exists
     # check that all variables have been set
     # if so, go to directory and substitute, write new script, save
     # look through file for all <undefined>, give each one a spot in the self.variables array (based on the matlabbatch name?)
     # THE GUI TO SET UP THE SUBMIT SCRIPT NEEDS TO GO THROUGH THE .MAT AND FILL IN PATHS TO UNDEFINED VARIABLES - PATHS
     # should all be set when the .mat is written so we can just fill in the subject specific stuff! 

#---------------------------------------------------
# initVAR: read variables from .mat file - how do we find them?
  def setVAR(self):

#---------------------------------------------------
# setVAR: take in a (dictionary?) of user variables
  def setVAR(self):
# check that dictionary exists... then take in variables, make sure none are null

#---------------------------------------------------
# extractNAME: extracts part of an image name
  def extractNAME(self,matchexp,start,end):
    #matchexp should be something to match the image
    #start should be the start index
    #end should be the end index

#---------------------------------------------------
# FILE and FOLDER MANIUPULATION    	
#---------------------------------------------------
# setFolder: sets an output folder (assigned to data / analysis type?)
# should take in a folder and add it to a list, to be created
  def setFolder(self):
   self.outputFolders

#---------------------------------------------------
# makeFolders: creates all output directories
  def makeFolders(self):
   # read in list of folders and make them for output, exit with
   # error if we cannot

#---------------------------------------------------
# copyData: copies images
  def copyData(self,prefix,dirin,dirout):

#---------------------------------------------------
# ps2pdf: Asks the user for output name, creates file
  def ps2pdf(self,outfolder=None):
    # convert ps file to pdf in specific outfolder
    # if outfolder is none, look for ps2pdf in all outfolders!

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
# CLUSTER FUNCTIONS
#---------------------------------------------------
# mountExp: mount the experiment on the head node
  def mountExp(self):

#Name of experiment whose data you want to access 
EXPERIMENT=${EXPERIMENT:?"Experiment not provided"}

source /etc/biac_sge.sh

EXPERIMENT=`biacmount $EXPERIMENT`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}

if [ $EXPERIMENT = "ERROR" ]
then
	exit 32
else 
#setup out script and Call Timestamp function
# setup user email?
echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 

#---------------------------------------------------
# setDispl: set virtual display before submitting .mat
  def setDisplay(self,boolean setting):

# keep track of if its on or off with self.display?

#First we choose an int at random from 100-500, which will be the location in
#memory to allocate the display
RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
echo "the random integer for Xvfb is ${RANDINT}";

#Now we need to see if this number is already being used for Xvfb on the node.  We can
#tell because when it is active, it will have a "lock file"

# if we take it off, delete the lock file
#If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi


while [ -e "/tmp/.X11-unix/X${RANDINT}" ]
do
      echo "lock file was already created for $RANDINT";
      echo "Trying a new number...";
      RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
      echo "the random integer for Xvfb is ${RANDINT}";
done

#Initialize Xvfb, put buffer output in TEMP directory
Xvfb :$RANDINT -fbdir $TMPDIR &

case $FACESORDER in
    1)  /usr/local/bin/matlab -display :$RANDINT < spm_order1_${RUN}.m;;
    2)  /usr/local/bin/matlab -display :$RANDINT < spm_order2_${RUN}.m;;
    3)  /usr/local/bin/matlab -display :$RANDINT < spm_order3_${RUN}.m;;
    4)  /usr/local/bin/matlab -display :$RANDINT < spm_order4_${RUN}.m;;
    *)      echo "$FACESORDER is not a valid faces task order.";;
esac

# statDisp: return if display is on or off
 def statDisp(self):
   return self.display

#---------------------------------------------------
# LOGGING
#---------------------------------------------------
# userMail: send log to useremail (when does this get done?)
  def userMail(self):

# check if email exists, if it does, send.  If not, either ask for it, or run anyway
#$ -M SUB_USEREMAIL_SUB

#---------------------------------------------------
# timestamp: print a timestamp to the outfile
  def timestamp(self):
  
#---------------------------------------------------
# postUser: print a timestamp to the outfile
  def postUser(self):


  # -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Processed/$SUBJ}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE


#---------------------------------------------------
# DATA CHECK and SUBMISSION
#---------------------------------------------------
# dataCheck: checks that we have complete job
  def dataCheck(self):
  # if datacheck passes, then we should run .mat script
  # check that there are no null spots in the data dictionary
  # submit variable should then be set to 1

#---------------------------------------------------
# runMAT: writes user specific mat file and saves
  def runMAT(self):
  # check that self.ready is set to 1, and that .mat
  # exists, return error if not
  #  /usr/local/bin/matlab -nodisplay < spm_batch1_${RUN}.m

  
#---------------------------------------------------
# main: runs when madlab.py is called
def main():

# should these be written by the spmsubmit python as well, (changeable) but added as default order?
  job = spmbatch()
  job.dataCheck()
  job.makeFolders() 
  job.setDisplay(True)
  job.runMAT()
  job.setDisplay(False) 

  job.postUser()
  
# INSERT TEXT HERE SUBSTITUTED BY SUBMISSION PYTHON - TO SPECIFY OPTIONAL USER OPTIONS  
# here we should mount the experiment
# then we should print the timestamp to file
  
# Only call 'main' if you're being run as a script.   
# Otherwise, do nothing and act like an object for another script.
if __name__ == '__main__':
  main()
