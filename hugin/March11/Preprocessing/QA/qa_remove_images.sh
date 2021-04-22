#!/bin/sh

# ------qa_remove_images-----------

# This script uses a bxh file to run QA, which checks for data
# accuracy!  It also takes in a user imput to start QA at a particular image
# in order to remove beginning saturation that is commonly seen with exams.
# If you just have raw dicom images, you must first run dicom2bxh to create the BXH header
# This script puts the QA results in a folder called QA within that same folder as the dicom images and BXH header.

#-------SUBMISSION ON COMMAND LINE-----------------
 
#
# >  qsub -v EXPERIMENT=Dummy.01 qa_remove_images.sh bxh_header 4 2 Subject
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
#$ -M @vsoch
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here

# --- LONG VARIABLE DEFINITIONS ---
# INPUT is the name of the bxh file to run QA on! (without the .bxh
# SUBJECT is the name of the subject's top folder
# FOLDER is the folder in "Subject" that contains the bxh file data

INPUT=$1 
FOLDER=$2
STARTVOL=$3
SUBJECT=$4
OUTDIR=$EXPERIMENT/Data/$SUBJECT/$FOLDER/
 
# ------- LONG SCRIPT ------------------

cd $OUTDIR

#we navigate to FIGS.01/Data/RawData/$SUBJECT/4/
#to create the header and output is dropped in this same folder
   
bxhabsorb --fromtype dicom *.dcm $INPUT.bxh  
                    
#Now we perform QA
 
fmriqa_generate.pl --overwrite --timeselect $STARTVOL: $INPUT.bxh QA
 
# $OUTPRE.bxh is the input that we just created
# QA is the output directory (this will create a QA folder in ${EXPERIMENT}/Data/Func)
 
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
