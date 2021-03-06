#!/bin/sh

# --------------SPM REST SINGLE SUBJECT TEMPLATE ----------------
# 
# This script prepares rest data for individual subjects to be run
# through the rest toolbox pipeline, including reprocessing the raw
# rest data to make it slice timed, and segmenting the anatomical
# image into grey, white, and csf, and then normalizing these images with
# the raw anatomical and rest swu* files to the standard T1 template
#
# ----------------------------------------------------

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
echo "----USER RUNNING SCRIPT IS SUB_USER_SUB" 
# -- END PRE-USER --
# **********************************************************

# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M SUB_USEREMAIL_SUB

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --

# ------------------------------------------------------------------------------
#
#  Variables and Path Preparation
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=SUB_SUBNUM_SUB          # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB           # This is a run number, if applicable
RAWREST=SUB_RESTRAW_SUB      # This is the folder that containa the raw rest data

# We are hard coding the anatomical folder name as "anat" 
# and the rest folder as "rest" because this is DNS convention

# First check if the normalized antomical exists, and exit if
# it does, meaning that we've already processed this subject.
if [ -e "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest/rest_anat/wsdns01-0002.img" ]; then
   echo "Analysis for subject " $SUBJ "has already been done.  Exiting."
   exit 32
else

# Check for the anat directory, and exit if it's not found
# Create rest_anat if it is to put newly segmented anatomical image.
if [ -d "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat" ]; then
   echo "Anat directory found.  Creating rest_anat within it."
   mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat/anat_rest
else
   echo "Anat directory not found. Exiting"
   exit 32
fi

# Check for the rest directory with processed data.  Exit if not found.
if [ ! -d "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest" ]; then
   echo "Rest directory not found.  Exiting."
   exit 32
fi

# Check for the raw rest directory and exit if not found.
if [ ! -d "$EXPERIMENT/Data/Func/$SUBJ/$RAWREST" ]; then
    echo "Raw rest directory with V00 images not found.  Exiting."
    exit 32
else  # Copy raw V00 images back into rest directory
# If subject has analyze images, get 3D niftis
    if [ -d "$EXPERIMENT/Data/Func/$SUBJ/$RAWREST/NiftiHeaders/images" ]; then
        cp $EXPERIMENT/Data/Func/$SUBJ/$RAWREST/NiftiHeaders/images/V0* $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest/
    else  # otherwise copy 3D nifti from base of rest directory
        cp $EXPERIMENT/Data/Func/$SUBJ/$RAWREST/V0* $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest/
    fi
fi

#Check that we have the rest output directory
if [ ! -d "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/rest" ]; then
   mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/rest
fi
  
# Initialize other variables to pass on to matlab template script
OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ       # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/MATLAB/Rest             # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the cluster

# ------------------------------------------------------------------------------
#
#  Step 1: Normalization with SPM, and REST analysis
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'conn_boxSS.m'; do
sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/conn_restSS_${RUN}.m
 done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

# ------------------------------------------------------------------------------
#
#  Step 2. Preparing Virtual Display
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

/usr/local/bin/matlab -display :$RANDINT < conn_restSS_${RUN}.m

echo "Done running conn_boxSS.m in matlab"

# If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi
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
