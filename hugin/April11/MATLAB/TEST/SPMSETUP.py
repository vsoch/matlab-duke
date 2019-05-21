#!/usr/bin/python

import sys
import os.path
import re
import datetime

#-SPMSETUP---------------------------------------------------------------------
# spmsetup reads through .mat file and prepares the completed .mat file to 
# be used with spm submit.  It allows the user to specify paths to variables,
# based on undefined things in the .mat file.  So to run this we just need to
# give it a .mat, and let it create a GUI for user input based on the .mat, and
# produce a text file to give to SPMSUBMIT?  There should be a function that is
# called for each "type" of analysis - so right now without a GUI the user will
# just call functions in the main in a certain order to set up the text file.
# In the future the equivalent will be done by having the user make choices in
# a GUI, and calling the same functions through the GUI

# SPMSETUP (takes in .mat and asks user for variables) --> produces text file with variables and .mat specifications
# SPMSUBMIT (takes in the text file with user variables --> submits one SPMRUN.py for each subject on cluster)
# SPMRUN creates and runs the subject specific .mat and other user specified options

# INSTRUCTIONS
# 1. Create .mat in SPM BATCH EDITOR - must include all directory changes and folder creations - but leave variables blank!
# 2. Save .mat somewhere accessible on munin
# 3. Log into cluster, navigate to saved .mat, run SPMSETUP python with .mat (need good description here how to do)
# 4. SPMSETUP will create a .job file to be used by SPMSUBMIT - copy this file onto head node and run SPMSUBMIT with this file
# 5. An instance of SPMRUN is created for each subject and submit to run out on nodes

class SPMSETUP:

#---------------------------------------------------
# __init__: class constructor, self is the object
  def __init__(self):
    self.subid = 'SUBJECT'
    self.clusterpath = 'CLUSTER'
    self.mat = None                 		# This is the .mat file name to be read?
    self.matfile = []				# The entire raw, unedited contents of the .mat file
    self.output	= None		    		# This is the name of the output file, to be used by SPMSUBMIT
    self.ready = {'var':False,'mat':False, 'section':False}      
                                                # status dictionary  
    self.modules = []                           # Holds a list of indices for self.matfile for the start of batches        
    # DO WE NEED THIS?                          # This is important to allow the user to move through modules...
    self.variables  = []            		# Holds a list of all variables for each (matlabbatch_name,value,index_in_matfile)
    self.runvars = []				# a list of custom variables to ask for at runtime
    self.clustvars = {}			        # a dict of cluster variables (not in .mat) to get from user
    self.outdirs = []				# this is a list of output directories to make (DO WE NEED THIS IF MAT DOING IT?)
    self.sections = []			        # holds ordered mat sections and running variables to print to file.
     					        # created from self.matfile after user has added variables
    
#---------------------------------------------------
# __repr__: defines object when printed
  def __repr__(self):
    return "<MAT File: %s,varsReady: %b,matReady: %b>"%(self.mat,self.ready['var'],self.mat['mat'])

#---------------------------------------------------
# .MAT FILE OPERATIONS
#---------------------------------------------------
# getMAT: reads in specified MAT file
  def getMAT(self):
    self.mat = raw_input("\nEnter path to .mat job file: ")
    extensions = ('.mat')
    ext = os.path.splitext(self.mat)
    while not ext[len(ext)-1] in extensions:
      print "Not a valid .mat file!"
      self.mat = raw_input("\nEnter path to .mat job file: ")
      ext = os.path.splitext(self.mat)
      
    # Check that user selected a file that exists     
    try:    # Check that file exists
      fread = open(self.mat)
      self.readMAT()       
    except IOError:                     
      print "The file does not exist, exiting."
      sys.exit()

#---------------------------------------------------
# readMAT: reads in specified file, writes new lib
  def readMAT(self):  
    # Read all words/lines into a list
    self.matfile = list(open(self.mat).read().split())
    
    # Set up the expression that we want to search for
    expression = self.setExp('<UNDEFINED>')
    
    count=-1
    if (len(self.matfile)>0):    
      for line in matfile:  # go through the lines one at a time
        count=count+1;
	
        current=expression.search(line)	# if we find the <UNDEFINED> expression 
					# save the location for it to go (index of <UNDEFINED>)
					# also save the index -2 (which will be the name of the variable)
					# we will present all of these to the user later in a GUI to fill in
	if (current!=None):
	  matchset=(matfile[count-2],matfile[count],count)  # we make a list that holds the variable name, the UNDEFINED part, and the index in matfile
	  variables.append(matchset)     # We append this new list to our set
	  
	self.matVAR()  			# Present all variables to be defined to the user

#---------------------------------------------------
# matVAR: set all undefined variables - in future done in GUI
  def matVAR(self):
    if (len(self.variables)>0):    
      for var in self.variables:  # go through the lines one at a time

        # Check if this is a scan list variable
	choice = raw_input("\nIs " + str(var[0][0]) + " a variable that will be set at run-time? [y/n]:")
	choice = self.check(choice,('y','n'))		# Make sure the user has selected valid choice

	if choice is 'y':  self.runInput()	        # If the variable is set at runtime
	else:
	  choice = raw_input("\nCreate list of paths for this variable? [y/n]:")
	  choice = self.check(choice,('y','n'))	# Make sure the user has selected valid choice
	  if choice is 'y':current = self.pathList()    # Create list of paths to put in variable
	  else: current = self.getInput()		# Collect a single variable

	  # Then put current variable back into the matfile
	  self.matfile[var[0][2]] = re.sub(self.setExp('<UNDEFINED>'),current,self.matfile[var[0][2])
	 
    else: print "Error, no variables to set!"
    self.ready['mat'] = True 	# Set self.mat['mat'] to True - .mat is ready to print	
    return       

#---------------------------------------------------
# splitMAT: break apart batch components into sections
  def splitJOB(self):
    # break apart the matlabbatch components - to be put into sections
    # each section should have option for a processing choice?
    
    # An expression to search for all instances of matlabbatch with a number
    expression = self.setExp('matlabbatch[{](\d*)[}]')
    # Create match expression for the {} section that holds the number
    numexpression = self.setExp('[{]\d*[}]')
    
    count=-1
    if (len(self.matfile)>0): 
      currexp = '';   
      for line in self.matfile:  # go through the lines one at a time
        count=count+1;
	
        current=expression.search(line)		    # search for matlabbatch in current line 
	if (current!=None):             	    # if we find a matlabbatch expression
	  if current.group() is not currexp:        # if the current expression is a new batch module,save indices
	    currnum=numexpression.search(current.group())   # Pull out the number
	    self.modules.append({'index':count,'startline':line,'batch':int(currnum.group()[1:-1}))
	    currexp = current.group()               # Update the current expression
	
	    
    # Present the user with the first line of each matlabbatch - assign the numbers to groups:
    # This is where the user groups batches, and adds any desired running variables
    # Our matfile variable gets restructed and placed into self.sessions in sections.
    # It is this section variable that will be used to write the .mat portion of the job file.
        # INSERT SPM JOBMAN LINES AROUND THE BATCH GROUPS, BUT INSIDE OF RUNNING CHOICES
    # THIS SHOULD EVENTUALLY BE IN A GUI!
      print "\nThe current .mat contains the following batch components:\n"
      module_nums = []
      for module in self.modules:
        module_nums.append((module['batch']))           # Place the module numbers into a var to check input later
	print 'Module: + ' str(module['batch']) + ' : Start Line ' + str(module['startline'])

      print "\n Sections of the batch must be grouped to allow for processing variables and the addition of ART."
      print "If you do not need to add a processing choice or ART, you can choose option 1.\n"
      # NEED TO MAKE THIS SOUND BETTER! BE MORE CLEAR!
      
       # Ask the user what he/she would like to do:
      print "SECTION-IZE .MAT DESIGN?"
      print "[1] Process batch in one section, no processing variables or ART"
      print "[2] Process with variables and/or ART\n"
	
      selection = raw_input("\n Please select an option: [ENTER]")
      selection = choice(selection,('1','2')
      if selection is 1: self.oneSections(); self.ready['section'] = True 
       
      selection = ''
      while (selection is not '3'):
            
	print "PROCESSING SECTIONS:"
        print "[1] Create processing sections with/without ART"
        print "[2] Finish and continue"
      
        selection = raw_input("\n Please select an option: [ENTER]")
          selection = choice(selection,('1','2'))
	  switch selection:
	    case 1: if self.ready['section'] is False: self.addSections(module_nums); else: print "Sections have already been created!"; return  
            case 2: if self.ready['section'] is False: print "Sections must be made first!"; self.addSections(module_nums); else: selection = '3' return
	    default: print "\n Choice not valid!\n."

      
#---------------------------------------------------
# SCRIPT and INPUT OPERATIONS
#---------------------------------------------------
# choice: make sure that user input is valid
  def choice(self,selection,options):
    while selection not in str(options):
      print "Invalid selection!  Choices are: "
      for opt in options: print opt,
      selection = raw_input("\nEnter choice and press [ENTER]:")
    return selection;

#---------------------------------------------------
# searchString: make sure that user input is valid
  def setExp(self,expression):
    return re.compile(expression,re.IGNORECASE)

#---------------------------------------------------
# pathList: let user create list of paths
  def pathList(self):
    # Need to get path to image folder
    # Then get image prefix
    # number of images / naming convention
    # put list back into variable
    return pathList

#---------------------------------------------------
# showList: present variables / lists to the user
  def showList(self,showlist):
    if type(showlist) is 'dict':
      for k,v in showlist.iteritems():
        print k + ": " + v
      print ''

#---------------------------------------------------
# getInput: collect path or variable from user to put into variable
  def getInput(self):
    						# Get variable type (manual for now - can we specify types later?
						# single path{}, value matrix[], number
						# need to make list of different input types for selection
     
    inputtype = raw_input("\nIs this a path [1], a number [2], or a value matrix [3]? [ENTER]:")
    inputtype = self.check(inputtype,('1','2','3'))		# Make sure the user has selected valid choice
    
    switch (inputtype) { 
      case 1: theinput = "{"+theinput+"}"
        print "Please reference the experiment variable as SUB_MOUNT_SUB and the subject folder as SUB_SUBJ_SUB"
        theinput = raw_input("\nPlease define path and press [ENTER]:")	# Get variable from user
	outputtype = raw_input("\nIs this an output folder that must be created? [y/n] [ENTER]:")
        outputtype = self.check(outputtype,('y','n'))		# Make sure the user has selected valid choice
        if outputtype is 'y': self.outdirs.append(theinput)	# Add path as potential output folder
      case 3: theinput = raw_input("\nPlease define matrix in format 1 2 3;4 5 6 and press [ENTER]:")	
        theinput - "["+theinput+"]"}  
      default: theinput = raw_input("\nPlease define value and press [ENTER]:")
      
    return theinput    
    
#---------------------------------------------------
# runInput: set variable to be set at runtime
  def runInput(self):
    # Put variable info into list of things that will be set at run time and leave undefined
    varname = raw_input("\nPlease name this variable:")
    cusvarlist = {varname:var}  # Put entire thing in dictionary
    self.cusvars.append(cusvarlist)
    return

#---------------------------------------------------
# VARIABLE and PROCESSING OPTIONS
#---------------------------------------------------
# addSections: add sections and processing variable choices (yes/no) with art (if desired)
  def addSections(self,mod_nums):
  
    if len(self.modules)>0:
      curr_sel = self.modules[0]['batch']  
      while (curr_sel is <= self.modules[-1]['batch']):      # Move through batches until we reach the last
    
        print "The current Module is " + str(curr_sel)
        print "Sections are currently defined as follows:"
        if len(self.sections) is not 0:
          for section in self.sections:
            print "Name: " + section['name']
        else: print "[EMPTY]" 
	
        secend = raw_input("Please define the Module # to be the end of the #" + str(len(self.sections)+1) + " section: [ENTER]:")
        secend = int(choice(selection,mod_nums))
        secname = raw_input("Please name this section: [ENTER]:")
        (decision,runvarname) = self.addRunVar(curr_sel,secend)
	
        # YES, ADD A RUNNING VARIABLE
	# NOTE TO VANESSA - IF RUNNING VARIABLE IS ADDED ON SPOT WE DON'T NEED TO RECORD A RANGE!
        if decision is 'y':
  	  # ADD PROCESSING CHOICE AROUND MAT SECTION (it will ask if we want rat afterward)
	  self.writeSection('mat',curr_sel,secend,secname,runvarname)
	elif decision is 'no':  # ADD MAT SECTION WITHOUT PROCESSING CHOICE (and it will ask if we want to add an art section)
	  self.writeSection('mat',curr_sel,secend,secname,'None')
	 
	# Here we update the list of modules so the user is taken to the start of the next module that isn't in a section:
	# self.modules[0] should be the start of the next module that needs processing  
	# from module list we remove curr_sel TO secend by finding the difference between the
	# mod_num list (as a set) and the user range (set) and then putting back into list, so modules[0] is secend + 1
	# module list should not contain duplicate module numbers!	
	mod_nums = list(set(mod_nums) ^ set(range(curr_sel,secend)))
	
      print "\nFinished grouping modules into sections.\n"; return
    else: print "No modules found for processing.  Check your file." # Do I want to exit here?	

#---------------------------------------------------
# writeSection: write a section, running variable, or artBatch to the section variable
  def writeSectionI(self,vartype,range_start,range_end,secname,runvar):
  
  # VARTYPE can currently only be'mat' or 'art'
  # - if it's mat we use the start and end range to add content from the raw matfile
  # - if it's art we don't use the start and end range
  # SECNAME is either the user defined name (in the case of a mat) or ART
  # RUNVAR can either be 'None' or a name.  If it's a name, we print text to file that will allow to run
  
  # A SECTION is a dictionary with the following information:
  # 'name': either ART or user defined name
  # 'content': either code from the matfile (in a list?) or code to run ART
  # The dictionary will be used to print modified mat to file  
  
  # Add either an art or a mat section:
    switch vartype:
      case 'mat':
        if runvar is not 'None':
        # PRINT RUN VAR HEAD TO FILE TO SECTION
	# NEED TO FIGURE OUT IF SELF.SECTIONS IS A LIST OF DICTIONARIES< OR ONE LIST?
	  self.sections.append({'type':vartype,'con
	# PRINT SPM INIT TO SECTION
	# THEN ADD MAT RANGE TO SECTION - CALL FUNCTION TO RENUMBER 1 through n
	# ADD SPM SUBMIT TO SECTION
	# ADD CLOSING RUN VAR TO SECTION
        else: #if runvar is not defined, meaning we don't have a running variable
        # PRINT SPM INIT TO SECTION
	# THEN ADD MAT RANGE TO SECTION - CALL FUNCTION TO RENUMBER 1 through n
	# ADD SPM SUBMIT TO SECTION
      case 'art':
        if runvar is not 'None':
        # ADD RUNVAR TO SECTION
	# ADD ART LINES (how will we have paths? What info is needed here?
	# CLOSE RUNVAR
        else: # if runvar is not defined, meaning we don't have running variable
        # ADD ART LINES (how will we have paths?  What info is needed here?
      default: print: vartype + " is not a valid run type, exiting."; sys.exit() 
      
        self.sections.append({'type':'runvar','name':runvarname,'content':content})
	
    # Ask user if he/she wants to add an art section after current section
    artchoice = raw_input("\nWould you like to add an ART section? [y/n] [ENTER]:")
    artchoice = self.check(artchoice,('y','n'))		# Make sure the user has selected valid choice
    if artchoice is 'y': self.addART();                

#---------------------------------------------------
# addRunVar: add running variable to list, return variable name and...
  def addRunVar(self,curr_sel,secend):
  
  # need to return DECISION (secrunvar) and runvarname (if decision is y)
  
    secrunvar = raw_input("\nWould you like to add a processing choice to this section? [y/n]:")
    secrunvar = self.check(secrunvar,('y','n'))		# Make sure the user has selected valid choice
       
    # YES, ADD A RUNNING VARIABLE
    # NOTE TO VANESSA - IF RUNNING VARIABLE IS ADDED ON SPOT WE DON'T NEED TO RECORD A RANGE!
    if secrunvar is 'y': 
      # If we already have processing choices
      if len(self.runvars) is not 0:
	print "Currently defined processing variables are as follows:"
	for runvar in self.runvars:
	  print "Name: " + runvar['name'] + ", Section start,finish" + str(runvar['range'])
	      
	  runvarname = raw_input("\nPlease enter the name of a new or already defined processing choice for this section [ENTER]:")
              
	  # Do NOT allow the user to enter "None" as a choice!
	  while runvarname is 'None':
	    runvarname = raw_input("Please select a name other than 'None' for this variable! [ENTER]:")
	      
	  # Check to see if we have defined the processing choice the user has specified:
	  varadded = 'no'
	  for runv in self.runvars:
	    # If it is defined 
	    if runv['name'] == runvarname: runv['range'].append((curr_sel,secend)); varadded = 'yes'; self.writeSection(runv); return
            
	  # It it wasn't defined, add a new one
	  if varadded is 'no'
	    self.runvars.append({'name':runvarname,'range':((curr_sel,secend))}
	    
      # If we have no processing choices
      else: runvarname = raw_input("\nPlease enter the name of the processing choice for this section [ENTER]:")
        self.runvars.append({'name':runvarname,'range':((curr_sel,secend))})
      return 'y',runvarname   # return the decision and the runvarname 
       
    # If user does not want to add a running variable
    else: return 'n','None'	
  
	  
#---------------------------------------------------
# addART: add an art BATCH as a section
  def addART(self,runvar):
    
    self.writeSection('art','',(RUNVARGOESHERE))
  

#---------------------------------------------------
# oneSection: place all of batch into one section 
  def oneSection(self):
   # ASK USER IF WANT PROCESSING CHOICE
   # ADD PROCESSING CHOICE WITH ENTIRE MAT AS SECTION or
   # ADD ENTIRE MAT AS SECTION
   return
   
   
#---------------------------------------------------
# clustVAR: verify all non .mat variables
  def clustVAR(self):
     # set default
     self.clustvars={'biacroot':'/usr/local/packages/MATLAB/BIAC','matlabpath':'/usr/local/bin/matlab','Processed_dir':'SUB_MOUNT_SUB/Analysis/SPM/Processed/','Analyzed_dir':'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/','scriptdir',''}
     print "\nThe following default variables will be used:\n"
     self.showList(self.clustvars)
     
     for k,v in self.clustvars.iteritems():             # Check for empty ones, ask to define
       if v is '':
         self.clustvars[k] = raw_input("Please define " + k + "[ENTER]")
	 
     change = 'y';
     while change is 'y' or 'd':
       print "\nUpdated cluster variable list is:\n"
       self.showList(self.clustvars)
       print "  Press 'd' for a description of these variables."
       change = raw_input("\nWould you like to change any of these values? [y/n] or [d]")
       change = self.check(change,('y','n','d'))		# Make sure the user has selected valid choice
       if change is 'd': self.descClustVAR()
       elif change is 'y': self.changeClustVAR()
         
     for k,v in self.clustvars.iteritems():             # Check again for empty
       if v is '':
         self.clustvars[k] = raw_input("Please define " + k + "[ENTER]")
     
# processing choices and order numbers, if applicable
# display on/off
# cluster path (to be filled in by script, replaced in .mat) - user can select to concatenate cluster path with various other variables
# processing options / choices

#---------------------------------------------------
# changeClustVAR: verify all non .mat variables
  def changeClustVAR(self):
    tochange = raw_input("Please enter variable name to change [ENTER]:")
    for k,v in self.clustvars.iteritems():
      if k is tochange:
        newvar = raw_input("Please enter new value for " + k) 
        self.clustvars[k] = newvar
      else: print "variable " + tochange + " not found"	

#---------------------------------------------------
# descClustVAR: verify all non .mat variables
  def descClustVAR(self):
    print "biacroot:      BIAC tools cluster installation"
    print "matlabpath:    cluster installation of matlab
    print "Processed_dir: TOP directory where preprocessing single subject folder will be made"
    print "Analyzed_dir:  TOP directory where analyzed single subject folder will be made"
    print "scriptdir:     Directory where job file saved - should be on hugin head node.  Your home directory is /home/username"
    

#---------------------------------------------------
# outDIR: check output directories to be made with user
  def outDIR(self):
    # Set output directories that will likely need to be made:
    print "\nThe following output directories will be made:\n"
    
    # FIRST VERIFY PROCESSED AND ANALYZED FOLDERS - let user select paths from those areas?
    # THIS SHOULD CHECK THE SUBJECT OVERHEAD DIRS - ALL DIRECTORIES SHOULD BE SAVED TO LIST
    # AND VERIFIED ABOUT BEING MADE IN SPMRUN BEFORE THE JOB IS RUN!
    
     self.showList(self.clustvars)
        
     concat processed and analyzed directories and subject folder
     
    if (len(self.outdirs)>0):
    
    else: print "There are no output directories to create."

 
#---------------------------------------------------
# printClustVAR: print cluster variables to output file
  def printClustVAR(self):
     # Print header to define Cluster Variable Section
     # Go through list of cluster variables and print each

#---------------------------------------------------
# printRunVAR: print cluster variables to output file
  def printRunVAR(self):
    # Print header to define running variable section
    # Go through list of run variables and print each


#---------------------------------------------------
# JOB OPERATIONS
#---------------------------------------------------
# printJOB: somehow we need to take in all relevant user variables - how?
  def makeJOB(self):
    # print something for the user to check?

      # Print output to window     
      for word in words:
        sys.stdout.writelines(word)
	sys.stdout.writelines(" ")

    
#---------------------------------------------------
# jobName: name the job, if it isn't named
  def jobName(self,name = None):
    if self.output is None:
      # ask the user for a name, and set to self.output

#---------------------------------------------------
# makeJOB: creates the job file to be used by SPMRUN.py
  def makeJOB(self):
   
   # Check that self.ready['mat'] and self.ready['vars'] are both True, tell user if not
   # Set up file for job (do we want a user specified name?) ASK USER FOR NAME 
   self.jobName()
   # Print header for variable names and their values (from a dictionary?)
   # Print 
   self.printMAT()     	    # Print .mat (all new lines) to file
   self.printClustVAR()     # Print cluster variables to file 
   self.printRunVAR()       # Print variables to be set at run time to file
   
   # find all user variables
   # ask user for path (give option to parse cluster and subject ID) - what about task name?
   # save paths to variable specific to matlabbatch name - write into MAT template file
   # write MAT template file  
   
#---------------------------------------------------
# makeMAT: creates the template MAT to be used by SPMRUN.py
  def printMAT(self):
  
  # check if self.ready['mat'] is true
  # print header to file to identify MAT portion
  # print each section from matfile that is stored in SECTIONs variable.
  # if the section is ART - print code for art (or should a dummy variable go in and this is done by next script?
   
  
#---------------------------------------------------
# runJOB: uses SPMSUBMIT.py to run the finished job
# this should eventually be a GUI button!
  def runJOB(self):
  
  
#---------------------------------------------------
# main: runs when SPMSETUP.py is called
def main():

# should these be written by the spmsubmit python as well, (changeable) but added as default order?
  job = SPMSETUP()	# Create a SPMSETUP Object
  job.saveScript()      # Get cluster directory to save and run job from
  job.getMAT()		# Make the user choose a .mat file.  Calls...
			# self.readMAT | self.matVAR 
			   # somewhere in here need to add processing choices / split mat before printing
  job.splitMAT()        # Breaks matlabbatch into sections, asks user to specify chunks of running, and if there
                        # are any "running variables" or "copies" or other components of analysis!
	
  job.clustVAR()        # get cluster specific variables?
  job.outDIR()          # check list of output directories - show to user to check?   
  job.makeJOB() 	# Makes the file to be used by SPMSUBMIT.py
  			# calls self.jobName(), selfprintMAT, self.printClustVAR,self.printRunVAR
   
  job.runJOB()
  
# INSERT TEXT HERE SUBSTITUTED BY SUBMISSION PYTHON - TO SPECIFY OPTIONAL USER OPTIONS  
# here we should mount the experiment
# then we should print the timestamp to file
  
# Only call 'main' if you're being run as a script.   
# Otherwise, do nothing and act like an object for another script.
if __name__ == '__main__':
  main()

  


