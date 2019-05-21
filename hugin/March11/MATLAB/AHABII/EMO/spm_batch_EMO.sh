#!/bin/sh

# --------------SPM BATCH AHABII TEMPLATE ----------------
# 
# This script takes anatomical and functional data located under
# Data/fund and Data/anat and performs all preprocessing
# by creating and utilizing two matlab scripts, and running spm
# After this script is run, output should be visually checked
# This script is only meant to process emoreg data, and possibly
# the anatomical image.
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

USERNAME="SUB_USERNAME_SUB"    # Take in the user name to calculate the length, used in spm_emo2
EMOFOLD=SUB_EMOFOLD_SUB          # This is the name of the rest functional folder
EMORUN=SUB_EMORUN_SUB  # yes runs, no skips processing oldfaces task
ANAT=SUB_ANATFOL_SUB
SEGMENT=SUB_IMAGEPREPONLY_SUB   # yes runs ONLY dicom to nifti imports without segmentation.
                                # If this option is selected, the user must manually segment and
				# copy the c1* images into each functional folder, and then run with
				# the "funconly" option to finish processing
ONLYFUNC=SUB_FUNCONLY_SUB       # yes does all processing after segmentation, in spm_batch2.m

#Make the subject specific output directories, check for existing subject directories:
if [ ! -d "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ" ]; then
    mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ
    mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ
fi

# If this is a new run and the Scripts directory doesn't exist, make it
if [ ! -d "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/Scripts" ]; then
    mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/Scripts
fi

# Check if the anat has already been processed.  If so, we will not process it again.
if [ ! -d "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT/raw
PROCESSANAT="yes"
else
PROCESSANAT="no"
fi

# Create the new emoreg directories under Processed and Analyzed
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/raw
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/emoreg_pfl
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/EmoReg

#Go to individual subject  folder and set data directories
cd $EXPERIMENT/Data/$SUBJ

# Pull the first 5 digits of the AHAB ID from the folder name
SUBPRE=$(echo $SUBJ | cut -c1-5)

# Count the length of the username to be used in spm_emo2.  The length of our paths depends
# on this user name, so we need to make sure that the script can accomodate users with
# various lengths of user names
USERLENGTH=`expr length $USERNAME`

# Initialize other variables to pass on to matlab template script
ANATDIRECTORY=$EXPERIMENT/Data/$SUBJ/$ANAT      # This is the location of the anatomical data
EMODIRECTORY=$EXPERIMENT/Data/$SUBJ/$EMOFOLD         # This is the rest data directory

OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ       # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM/EmoReg              # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the cluster

# ------------------------------------------------------------------------------
#
#  Step 1: Anatomical and Functional Image Renaming and Moving
#
# ------------------------------------------------------------------------------

if [ $ONLYFUNC != 'yes' ]; then

##########################################################################
#
# Anatomical
#
##########################################################################

# Only process the anatomical if processed data doesn't exist, and if the 
# raw folder exists

if [ $PROCESSANAT == 'yes' ]; then

if [ $ANAT == 'anat' ]; then

if [ -e "$ANATDIRECTORY" ]; then

# Go to the subject anatomical data directory to rename and move images
cd $ANATDIRECTORY

countVar=1;

#Prepare the anatomical images
for file in MR.*
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANAT/raw/V0$countVar.dcm
fi

let "countVar += 1";

done
fi
fi
fi


##########################################################################
#
# EmoReg Functional Data
#
##########################################################################

if [ $EMORUN == 'yes' ]; then

if [ -e "$EMODIRECTORY" ]; then

# Go to the subject emo data directory to rename and move images
cd $EMODIRECTORY

countVar=1;

#Prepare the images
for file in MR.*
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/raw/V0$countVar.dcm
fi

let "countVar += 1";

done
fi
fi

# ------------------------------------------------------------------------------
#
#  Step 2: Image Format Conversions and Segmentation
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_emo.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_PROCESSANAT_SUB@'$PROCESSANAT'@g' \
 -e 's@SUB_RUNEMO_SUB@'$EMORUN'@g' \
 -e 's@SUB_SUBPRE_SUB@'$SUBPRE'@g' \
 -e 's@SUB_SEGMENT_SUB@'$SEGMENT'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANAT'@g' <$i> $OUTDIR/spm_emo_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/bin/matlab -nodisplay < spm_emo_${RUN}.m

echo "Done running spm_emo.m in matlab"


# ------------------------------------------------------------------------
#
# Step 3: Rename anatomicals for processing
#
# ------------------------------------------------------------------------

if [ $PROCESSANAT == 'yes' ]; then
if [ $ANAT == 'anat' ]; then

cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat

#Rename the sc1 image and header (it will be copied into functional
#directories in spm_emo2.m

anatfile=c1s*02.img
cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat/c1s02.img

anatfile=c1s*02.hdr

cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat/c1s02.hdr

fi
fi

# ------------------------------------------------------------------------------
#
#  Step 4: Rename functional data to prepare for second matlab script
#
# ------------------------------------------------------------------------------

##########################################################################
#
# EmoReg
#
##########################################################################

if [ $EMORUN == 'yes' ]; then

if [ -e "$EMODIRECTORY" ]; then

# Go to the subject faces directory to rename images
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$EMOFOLD
echo "Preparing emoreg images"

countVar=1;

for file in f*.img
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V000$countVar.img
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V00$countVar.img
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V0$countVar.img
fi

let "countVar += 1";

done

countVar=1;
for file in f*.hdr
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V000$countVar.hdr
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V00$countVar.hdr
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/emoreg/V0$countVar.hdr
fi

let "countVar += 1";

done
fi
fi
fi

# ------------------------------------------------------------------------------
#
#  Step 5: Realign and Unwarp, Normalization, Smoothing
#
# ------------------------------------------------------------------------------

if [ $SEGMENT != "yes" ]; then

# Now we want to perform the realign and unwarp steps with spm_preprocess.m

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_emo2.m'; do
sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_PROCESSANAT_SUB@'$PROCESSANAT'@g' \
 -e 's@SUB_SEGMENT_SUB@'$SEGMENT'@g' \
 -e 's@SUB_RUNEMO_SUB@'$EMORUN'@g' \
 -e 's@SUB_LENGTH_SUB@'$USERLENGTH'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANAT'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/spm_emo2_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR
echo "Changed to output directory";

# ------------------------------------------------------------------------------
#
#  Step 6. Preparing Virtual Display
#
# ------------------------------------------------------------------------------

#First we choose an int at random from 100-500, which will be the location in
#memory to allocate the display
RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
echo "the random integer for Xvfb is ${RANDINT}";

#Now we need to see if this number is already being used for Xvfb on the node.  We can
#tell because when it is active, it will have a "lock file"

while [ -e "/tmp/.X11-unix/X${RANDINT}" ]
do
      echo "lock file was already created for $RANDINT";
      echo "Trying a new number...";
      RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
      echo "the random integer for Xvfb is ${RANDINT}";
done

#Initialize Xvfb, put buffer output in TEMP directory
Xvfb :$RANDINT -fbdir $TMPDIR &
/usr/local/bin/matlab -display :$RANDINT < spm_emo2_${RUN}.m

echo "Done running spm_batch2.m in matlab";

#If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi

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
