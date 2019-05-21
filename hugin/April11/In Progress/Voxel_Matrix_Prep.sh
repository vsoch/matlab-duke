#!/bin/sh

#-------------Voxel_Matrix_Prep-----------------------------------

# This script is intended to prepare the Preprocessed SPM5 functional data
# in order to create a matrix with all of the voxel intensities in MATLAB with SPM5
# This script first makes the 3D swrf images into one 4D image
# It next uses the subject's tstandard space mask to clean up the 4D image
# It then runs a brain extraction on the 4D image to remove the eyeballs
# Next, this image is ready for processing in MATLAB


# ---------WHEN DO I RUN THIS?------------
# You should use this script AFTER you have preprocessed the SPM5 data

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# check if you want a different OUTDIR path (if not in folder 3, etc)
# the BET value

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 Voxel_Matrix_Prep.sh  SPMFaces
#                                                                     data name
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

DATANAME=$1

SUBJECTS="040526121358"

SUBJDIR=$EXPERIMENT/Data/$DATANAME/SPM5Processed
  
for SUBJ in $SUBJECTS; do

cd $SUBJDIR/$SUBJ

COMMANDLINE="faces_4D_swrf swrf*.img"

fslmerge -t $COMMANDLINE
# create the 4D image from the 195 3D images

COMMANDLINE="faces_4D_swrf.* -mas mask.img faces_4D_swrf_masked"
fslmaths $COMMANDLINE

# apply the mask to the 4D image to clean it up

BETVALUE=0.225
#INFILE=$SUBJDIR/faces_4D_swrf_masked.nii
#OUTPRE=$SUBJDIR/faces_4D_swrf_masked_noeyes
bet faces_4D_swrf_masked.nii faces_4D_swrf_masked_noeyes -f $BETVALUE

fslchfiletype NIFTI faces_4D_swrf_masked_noeyes.nii.gz
# uncompress the nifti so it works in matlab with SPM
  
done
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Data/SPMFaces}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
