#!/bin/sh

# ---------------VOX_MATRIX TEMPLATE ----------------
# 
# This script takes preprocessed SPM images and creates
# a matrix of all voxel values within a certain mask
# and threshold specified by the user.  Input comes from
# Data/SPM(version)/AllProcessedData/(Subject) and output
# goes to Analysis/Matrices/(Design)/(Subject)
#
# ----------------------------------------------------

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


# ------------------------------------------------------------------------------
#
#  Step 1: Variables and Path Preparation
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=SUB_SUBNUM_SUB          # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB           # This is a run number, if applicable
TASK=SUB_TASKNAME_SUB        # This is the name of the task folder (rest,faces,cards)
OUTPUTFOL=SUB_OUTPUTFOL_SUB  # This is the name of the output folder under Matrices/...
NUMIMAGES=SUB_NUM_IMAGES_SUB # This is the number of images in the functional task
DESC=SUB_DESC_SUB            # This is to append to the resulting matrix, as an identified

# MASK 1
MASKTYPE=SUB_MTYPE_SUB       # This is the mask category folder under ROI/Masks
MASKFILE=SUB_MASKFILE_SUB    # This is the full name of the mask image
THRESH=SUB_THRESHOLD_SUB     # This is the masking threshold

# MASK 2
MASKTWO=SUB_YESTWOMASK_SUB
MASKTWOTYPE=SUB_MTWOTYPE_SUB
MASKTWOFILE=SUB_MASKTWOFILE_SUB
THRESHTWO=SUB_THRESHOLDTWO_SUB

#Navigate to the subject's folder with the preprocessed swu/swrf images:
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TASK

#Make a directory to hold the swrf images for processing in the script, and subject outdir
mkdir -p $EXPERIMENT/Analysis/SPM/Matrices/$OUTPUTFOL/$SUBJ/$TASK/

#Set directories
SCRIPTDIR=$EXPERIMENT/Scripts/MATLAB/Matrices
OUTDIR=$EXPERIMENT/Analysis/SPM/Matrices/$OUTPUTFOL/$SUBJ/$TASK/
BIACROOT=/usr/local/packages/MATLAB/BIAC

# ------------------------------------------------------------------------------
#
#  Step 2: Image Preparation
#
# ------------------------------------------------------------------------------

# We use the swu images directly from the Processed directory.  The script assumes
# that the data has been processed with the DNS pipeline and has the name "swuV00*"
# If this isn't the case, you will want to copy and rename the images to elsewhere,
# and delete the copies at the end.

# ------------------------------------------------------------------------------
#
#  Step 3: Matrix Creation
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'vox_extract_cluster.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_TASK_SUB@'$TASK'@g' \
 -e 's@SUB_MASKTYPE_SUB@'$MASKTYPE'@g' \
 -e 's@SUB_MASKTWOTYPE_SUB@'$MASKTWOTYPE'@g' \
 -e 's@SUB_MASKTWONAME_SUB@'$MASKTWOFILE'@g' \
 -e 's@SUB_MASKTWO_SUB@'$MASKTWO'@g' \
 -e 's@SUB_MINTHRESHTWO_SUB@'$THRESHTWO'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_MINTHRESH_SUB@'$THRESH'@g' \
 -e 's@SUB_NUMIMAGES_SUB@'$NUMIMAGES'@g' \
 -e 's@SUB_MASKNAME_SUB@'$MASKFILE'@g' <$i> $OUTDIR/vox_extract_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/bin/matlab -nodisplay < vox_extract_${RUN}.m

echo "Done running vox_matrix.m in matlab"


# ------------------------------------------------------------------------------
#
#  Step 4: File Cleanup and Matrix Copy
#
# ------------------------------------------------------------------------------

#Return to the subject specific folder to delete the renamed files and copy the matrix

cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TASK/
cp voxvalues.mat $OUTDIR/$SUBJ$DESC.mat
rm voxvalues.mat

cd $OUTDIR
rm vox_extract_${RUN}.m

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Matrices/$OUTPUTFOL/$SUBJ/$TASK/}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
