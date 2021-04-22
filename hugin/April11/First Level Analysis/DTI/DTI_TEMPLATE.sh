#!/bin/sh

#-------------DTI---------------------------------------
 
# This script is intended to perform a Brain extraction, eddy current
# correction, and dtifit on a nifti of DTI data. The brain extraction, DTI_brain
# is put in a folder called "BET" within the DTI directory

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should first run the data through QA to eliminate any bad apples, 
# then convert functional and anatomicals to nifti, and then BET with McFlirt before FEAT
#

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# check if you want a different OUTDIR path (if not in folder 3, etc)
# the BET value

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 DTI.sh   10        0405174398
#                                                    DTIfolder    Subject
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


DTI=SUB_DTIFOLDER_SUB   #this is the folder that contains the DTI data in the subject's directory
SUBJECT=SUB_SUBNUM_SUB

DTIDIR=$EXPERIMENT/Data/$SUBJECT/$DTI 
 
mkdir -p $DTIDIR/BET
mkdir -p $DTIDIR/DTI

cd $DTIDIR/DTI
  
#You must first drop the DTI folder for conversion using MRIcro - this will create the
#dti.nii, the bvec, and bval files required for DTIFit  
  
  
# Perform Eddy Current Correction
eddy_correct $DTIDIR/*.nii $DTIDIR/DTI/data_corrected 0
  
# BET on the dti brain to make the mask
bet $DTIDIR/DTI/data_corrected $DTIDIR/BET/nodif_brain -F -f .3
    
#Running dtifit with input data, brain mask, output directory, bvecs and bval files
dtifit -k $DTIDIR/DTI/data_corrected.nii -m $DTIDIR/BET/nodif_brain_mask.nii -o $DTIDIR/DTI/DTI -r $DTIDIR/.bvec -b $DTIDIR/.bval
 
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Data/$SUBJECT/$DTI/DTI}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
