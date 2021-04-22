#!/bin/sh

#-------------FA_move.sh---------------------------------------
 
# This script takes the FA niftis produced by DTI.py, located in the subject's specified DTI folder in
# Data/SUBJECT/DTI_FOLDER/DTI, renames it to include the subject ID, and moves it to the Analysis/Faces/DTI/FA 
# folder for further procesing

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should run this script after you have completed running fq.sh and want to
# compile your results in a single file for analysis

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You need to change the variable "Subjects to include all the subjects with a particular dti folder 
# 

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 FA_move.sh         10        
#                                                           DTI Folder


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
# echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 
# -- END PRE-USER --
# **********************************************************
 
# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M @vsoch
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here
    
# SET OUR VARIABLES

DTI_FOLDER=$1  #this is the folder under the subject directory that contains DTI data and a DTI folder

SUBJECTS="45634_scandata"
          #insert subjects in quotes, with a space between each one
 
OUTPUT=$EXPERIMENT/Analysis/DTI/FA

for SUBJ in $SUBJECTS; do

# specify our nifti FA file and directory
DTI_DIR=$EXPERIMENT/Data/$SUBJ/$DTI_FOLDER/DTI
DTI_NIFTI=$DTI_DIR/DTI_FA.*

# Go to that directory
cd $DTI_DIR

# rename the FA nifti to include the subject ID
mv $DTI_NIFTI $SUBJ"_FA".nii.gz

# copy new FA nifti into the Analysis directory (only if successfully renamed)
cp $SUBJ"_FA".nii.gz $OUTPUT


done

echo "The following subjects were moved with this script:"
echo "$SUBJECTS"

# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/DTI/FA}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
