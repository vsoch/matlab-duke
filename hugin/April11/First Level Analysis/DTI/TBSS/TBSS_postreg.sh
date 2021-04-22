#!/bin/sh

#-------------TBSS_postreg.sh---------------------------------------

# This script must be run AFTER TBSS_reg.sh is complete, This script 
# applies the nonlinear transforms found in the previous stage to all subjects 
# to bring them into standard space.

# The script results in a standard-space version of each subject's FA image; 
# next these are all merged into a single 4D image file called all_FA, created 
# in a new subdirectory called stats. Next, the mean of all FA images is 
# created, called mean_FA, and this is then fed into the FA skeletonisation 
# program to create mean_FA_skeleton. 

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should run this script after you have completed running fq.sh and want to
# compile your results in a single file for analysis

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You need to change the variable "Subjects to include all the subjects with a particular dti folder
#

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 TBSS_postreg.sh   
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

# Go to the FA folder with FAi as a subdirectory
cd $EXPERIMENT/Analysis/DTI/FAALL

# Perform the post registration
tbss_3_postreg -S

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER --
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/DTI/FA_ALL}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--
