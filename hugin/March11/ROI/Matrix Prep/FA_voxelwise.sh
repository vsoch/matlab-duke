#!/bin/sh

#-------------FA_voxelwise.sh---------------------------------------

# This script is run after the entire TBSS series is complete, and you have created
# a design file in FSLs GLM util.  

# The script results in a standard-space version of each subject's FA image; 
# next these are all merged into a single 4D image file called all_FA, created 
# in a new subdirectory called stats. Next, the mean of all FA images is 
# created, called mean_FA, and this is then fed into the FA skeletonisation 
# program to create mean_FA_skeleton. 


# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 FA_voxelwise.sh  Design  FA_folder 
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
# echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----"
# -- END PRE-USER --
# **********************************************************

# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M @vsoch

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --
# User script goes here

# LONG VARIABLES
DESIGN=$1     #This is the name of the design folder with the correct design under FA/Design
              #The design itself should be called design.fsf
FA_FOLDER=$2  #This is the name of the FA folder (under Analysis/FA) that contains the stat folder
              #with the all_FA_skeletonized.nii
	            
FA_DIRECTORY=$EXPERIMENT/Analysis/DTI/FA/$FA_FOLDER
DESIGN_FOLDER=$EXPERIMENT/Analysis/DTI/FA/Design/$DESIGN

mkdir -p $DESIGN_FOLDER/Results
cd $DESIGN_FOLDER/Results

randomise -i $FA_DIRECTORY/stats/all_FA_skeletonised.nii.gz -o tbss -m
$FA_DIRECTORY/stats/mean_FA_skeleton_mask.nii.gz -d $DESIGN_FOLDER/design.mat -t $DESIGN_FOLDER/design.con -n 500 -T -1 -V

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER --
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/DTI/FA}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--
