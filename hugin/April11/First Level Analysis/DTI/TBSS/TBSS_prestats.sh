#!/bin/sh

#-------------TBSS_prestats.sh---------------------------------------

# This script must be run AFTER TBSS_postreg.sh is complete, This script 
# is the final step before voxelwise cross-subject analysis.  It thresholds
# the mean FA skeleton image at a chosen threshold, and results in a binary
# skeleton mask that defines the set of voxels used in subsequent processing.
# A "distance map" is created from the skeleton mask, and this is used in
# the projection of FA onto the skeleton.  The script then takes the 4D all_FA
# image (containing all subject data) and for each timepoint (subject ID)
# projects the FA data onto the mean FA skeleton.

# The script results in a standard-space version of each subject's FA image; 
# next these are all merged into a single 4D image file called all_FA, created 
# in a new subdirectory called stats. Next, the mean of all FA images is 
# created, called mean_FA, and this is then fed into the FA skeletonisation 
# program to create mean_FA_skeleton. This results in a 4D image file containing
# the projected skeletonised FA data for use in voxelwise statitics.


# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You need to change the path to the folder with the DTI data


#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 TBSS_prestats.sh   Folder
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

FOLDER=$1   # this is the folder containing the "FAi" directory

# Go to the FA folder with FAi as a subdirectory
cd $EXPERIMENT/Analysis/DTI/$FOLDER

# Perform the pre stats step with a threshold of .2
tbss_4_prestats 0.2

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER --
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/DTI/$FOLDER}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--
