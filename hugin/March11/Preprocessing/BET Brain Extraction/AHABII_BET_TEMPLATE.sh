#!/bin/sh

#-------------BET---------------------------------------
 
# This script is intended to run a brain extraction on the anatomical AHABII Data
# It is a template script to be filled by BET.py. It outputs a file
# called anat_brain.nii in the Data/SUBJECT/in_planes_t2*/BET folder
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

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 BET.sh  in_planes_t2*
#                                                      
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
 
# Need to input global EXPERIMENT, and inputs DATADIR, INFILE, OUTDIR, ANATFOLD, SUBJECT, and OUTPRE
# DATADIR is the main data directory under EXPERIMENT
# INFILE is the .nii file of the anatomicals to be extracted (*.nii)
# OUTDIR is where the output anat_brain.nii will go - we set it to "BET" in folder 3
# OUTPRE is the output prefix of the file - it should be anat_brain
# SUBJECT is the name of the subject's folder
# ANATFOLD is the name of the anatomicals folder (3)
# Example:  qsub -v EXPERIMENT=Dummy.01 BET.sh \
# Data/ anat.nii anat_brain 345234 \
  
# First, we set the output directory to a folder called "BET" in the anatomical folder.
# which we go to and make
OUTDIR=$EXPERIMENT/Data/SUB_SUBNUM_SUB/SUB_ANATFOLD_SUB
cd $OUTDIR
mkdir -p BET

# Then we remove the preceding string "EXPERIMENT" from the string $OUTDIR and $DATADIR
# Example:
# If DATADIR = EXPERIMENT/Data/Anat/99999/srs500.hdr
# running ${INFILE#EXPERIMENT}, it becomes:
# /Data/Anat/99999/srs500.hdr
# DATADIR=${EXPERIMENT}${DATADIR#EXPERIMENT}
# OUTDIR=${EXPERIMENT}${OUTDIR#EXPERIMENT}

# Then we set the BETVALUE, or the threshold that determines how much we remove
# (If you aren't sure, play with this value in the GUI until it looks right!)
BETVALUE=0.225

NIFTI=$OUTDIR/*2001.nii.gz

bet $NIFTI BET/SUB_OUTPUT_SUB -f $BETVALUE -S
 
 
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