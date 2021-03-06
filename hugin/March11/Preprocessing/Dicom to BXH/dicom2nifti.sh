#!/bin/sh

# -------- DICOM 2 NIFTI ---------

# This script is intended for converting raw dicom images into a 4D nifti file
# through use of the bxhtools and bxh header provided by BIAC

# -------- SUBMITTING JOB ON COMMAND LINE --------------
 
# >  qsub -v EXPERIMENT=FIGS.01 dicom2nifti.sh    Anat          series005      Faces     01252010_21546
#                                                 Anat or Func?  Folder name   Out-pre   Subject ID

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
#$ -M vsochat@gmail.com
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here

# --- LONG VARIABLE DEFINITIONS ---

TYPE=$1     # this is either going to be "Anat" or "Func"
FOLDER=$2   # this is the series folder name
OUTPRE=$3   # this is the name you want for the resulting nifti
SUBJECT=$4  # this is the subject ID

OUTDIR=$EXPERIMENT/Data/$TYPE/$SUBJECT/$FOLDER/
 
# ------- LONG SCRIPT ------------------

cd $OUTDIR
# here we navigate to the folder with the dicoms to run the command

bxhreorient --orientation=LAS $FOLDER.bxh LAS.bxh
# here we are changing the orientation from LPS to LAS, (TO Radiological) for use in FSL

OUTPUT=$OUTPRE"_LAS"
# Here we are appending "LAS" to the name of the output so that the orientation is clear   
                    
bxh2analyze --nii -b LAS.bxh $OUTPUT
# -nii indicates that we want an uncompressed nifti
# -b suppresses the output of a second bxh file 
 
 
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
