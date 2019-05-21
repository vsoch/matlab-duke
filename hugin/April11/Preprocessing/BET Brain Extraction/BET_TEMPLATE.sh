#!/bin/sh

#-------------BET---------------------------------------
 
# This script is intended to run a brain extraction on the
# anatomical data, assumed to be in folder 3.  It outputs a file
# called anat_brain.nii in the RawData/SUBJECT/3/BET folder
# and takes an input *.nii from the same folder

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should first run the data through QA to eliminate any bad apples, 
# then convert functional and anatomicals to nifti, and then BET with McFlirt before FEAT
#

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# check if you want a different OUTDIR path (if not in folder 3, etc)
# the BET value

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 BET.sh    

# There are 2 USER sections 
#  1. USER DIRECTIVE: If you want mail notifications when
#     your job is completed or fails you need to set the 
#     correct email address.
#		   
#  2. USER SCRIPT: Add the user script in this section.
#     Within this section you can access your experiment 
#     folder using $EXPERIMENT. All paths are relative to this variable
#     eg: $EXPERIMENT/Data $EXPERIMENT/Analysis	
#     By default all terminal output is routed to the " Analysis "
#     folder under the Experiment directory i.e. $EXPERIMENT/Analysis
#     To change this path, set the OUTDIR variable in this section
#     to another location under your experiment folder
#     eg: OUTDIR=$EXPERIMENT/Analysis/GridOut 	
#     By default on successful completion the job will return 0
#     If you need to set another return code, set the RETURNCODE
#     variable in this section. To avoid conflict with system return 
#     codes, set a RETURNCODE higher than 100.
#     eg: RETURNCODE=110
#     Arguments to the USER SCRIPT are accessible in the usual fashion
#     eg:  $1 $2 $3
# The remaining sections are setup related and don't require
# modifications for most scripts. They are critical for access
# to your data  	 
 
# --- BEGIN GLOBAL DIRECTIVE -- 
#$ -S /bin/sh
#$ -o $HOME/$JOB_NAME.$JOB_ID.out
#$ -e $HOME/$JOB_NAME.$JOB_ID.out
#$ -m ea
# -- END GLOBAL DIRECTIVE -- 
 
# -- BEGIN PRE-USER --
#Name of experiment whose data you want to access 
EXPERIMENT=${EXPERIMENT:?"Experiment not provided"}
 
source /etc/biac_sge.sh
 
EXPERIMENT=`biacmount $EXPERIMENT`
EXPERIMENT=${EXPERIMENT:?"Returned NULL Experiment"}
 
if [ $EXPERIMENT = "ERROR" ]
then
	exit 32
else 
#Timestamp
echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 
# -- END PRE-USER --
# **********************************************************
 
# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M SUB_USEREMAIL_SUB
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here

# Let's first set all of our variables from the python script (BET.py)
INFILE=SUB_INFILE_SUB
OUTPRE=SUB_OUTFILE_SUB
DIRECTORY=SUB_DIRECTORY_SUB
SUBJECT=SUB_SUBNUM_SUB
  
# First, we set the output directory to a folder called "BET" in the anatomical folder.
# which we go to and make
OUTDIR=$EXPERIMENT/Data/$SUBJECT/$DIRECTORY

cd $OUTDIR
mkdir -p BET

# Then we set the BETVALUE, or the threshold that determines how much we remove
# (If you aren't sure, play with this value in the GUI until it looks right!)
BETVALUE=SUB_BETVALUE_SUB

# Then we print the command, in case we need to check it in the output
echo "bet $INFILE BET/$OUTPRE -f $BETVALUE"
bet $INFILE BET/$OUTPRE -f $BETVALUE
 
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
