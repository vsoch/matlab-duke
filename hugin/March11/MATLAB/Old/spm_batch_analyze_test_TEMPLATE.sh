#!/bin/sh

# --------------SPM BATCH TEMPLATE ----------------
# 
# This script takes anatomical and functional data located under
# Data/fund and Data/anat and performs all preprocessing
# by creating and utilizing two matlab scripts, and running spm
# After this script is run, output should be visually checked
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
#  Variables and Path Preparation
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=SUB_SUBNUM_SUB          # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB           # This is a run number, if applicable
ANATFOLDER=SUB_ANATFOL_SUB   # This is the name of the anatomical folder
T1FOLD=SUB_T1FOLD_SUB        # This is the name of the highres folder
FACESFOLD=SUB_FACESFOLD_SUB  # This is the name of the faces functional folder
CARDSFOLD=SUB_CARDSFOLD_SUB  # This is the name of the cards functional folder
RESTFOLD=SUB_RESTFOLD_SUB    # This is the name of the rest functional folder
FACESRUN=SUB_FACESRUN_SUB    # yes runs, no skips processing faces task
CARDSRUN=SUB_CARDSRUN_SUB    # yes runs, no skips processing cards task
RESTRUN=SUB_RESTRUN_SUB      # yes runs, no skips processing rest task

#Make the subject specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ
  
# Initialize other variables to pass on to matlab template script
ANATDIRECTORY=$EXPERIMENT/Data/Anat/$SUBJ/$ANATFOLDER # This is the location of the anatomical data
T1DIRECTORY=$EXPERIMENT/Data/Anat/$SUBJ/$T1FOLD       # This is the location of the anatomical data
OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ       # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the custer

# Go to the subject anatomical data directory to pull prefix of the image names and shove into a variable
cd $ANATDIRECTORY

# This prepares the file path if we are using dicoms that end in ,dcm
if [ $ANATFOLDER == 'series002' ]; then

ANATFILE=*01.dcm
ANATPRE=$(echo $ANATFILE | cut -c1-26)

fi

cd $T1DIRECTORY

# This prepares the file path if we are using dicoms that end in ,dcm
if [ $T1FOLD == 'series005' ]; then

T1FILE=*01.dcm
T1PRE=$(echo $T1FILE | cut -c1-26)

fi


# ------------------------------------------------------------------------------
#
#  Step 1: Naming Conventions
#
# ------------------------------------------------------------------------------

#This part of the file changes the naming scheme from NiiHdr_run02 to the
#convention that the script expects, "V0001" These are for the first 20 subjects
#that needed nifti files made manually, since we have changed the output off of
#scanner from analyze .img to 3D nifti.

# CHANGE NAMES FOR FACES

if [ $FACESRUN == 'yes' ]; then

cd $EXPERIMENT/Data/Func/$SUBJ/$FACESFOLD
mkdir -p images

for (( c=1; c<=195; c++ ))
do
IMGFILE=*$c.img
HDRFILE=*$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c19-26)
HDRPRE=$(echo $HDRFILE | cut -c19-26)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *$c.img images/$NEWIMGPATH
cp *$c.hdr images/$NEWHDRPATH
done

fi

# CHANGE NAMES FOR CARDS

if [ $CARDSRUN == 'yes' ]; then

cd $EXPERIMENT/Data/Func/$SUBJ/$CARDSFOLD
mkdir -p images

for (( c=1; c<=171; c++ ))
do
IMGFILE=*$c.img
HDRFILE=*$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c19-26)
HDRPRE=$(echo $HDRFILE | cut -c19-26)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *$c.img images/$NEWIMGPATH
cp *$c.hdr images/$NEWHDRPATH
done

fi

# CHANGE NAMES FOR REST

if [ $RESTRUN == 'yes' ]; then

cd $EXPERIMENT/Data/Func/$SUBJ/$RESTFOLD
mkdir -p images

for (( c=1; c<=128; c++ ))
do
IMGFILE=*$c.img
HDRFILE=*$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c19-26)
HDRPRE=$(echo $HDRFILE | cut -c19-26)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *$c.img images/$NEWIMGPATH
cp *$c.hdr images/$NEWHDRPATH
done

fi

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Processed/$SUBJ}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
