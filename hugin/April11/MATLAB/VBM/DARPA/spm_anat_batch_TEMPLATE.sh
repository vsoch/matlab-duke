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


SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the custer

# Make the subject output directory
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ
OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ

# Make each of the output data folders, if the data exists
if [ -d "$EXPERIMENT/Data/$SUBJ/pre" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/post" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat
fi

# Make directories for faces
if [ -d "$EXPERIMENT/Data/$SUBJ/post/faces" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/faces
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/pre/faces" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/faces
fi


# Make directories for pre anat data
if [ -d "$EXPERIMENT/Data/$SUBJ/pre/anat/highres1" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/highres1
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/highres1
mkdir -p spgr
mkdir -p default
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/pre/anat/highres2" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/highres2
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/highres2
mkdir -p spgr
mkdir -p default
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/pre/anat/inplane" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/inplane
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/pre/anat/inplane
mkdir -p spgr
mkdir -p default
fi


# Make directories for post anat data
if [ -d "$EXPERIMENT/Data/$SUBJ/post/anat/highres1" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/highres1
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/highres1
mkdir -p spgr
mkdir -p default
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/post/anat/highres2" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/highres2
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/highres2
mkdir -p spgr
mkdir -p default
fi

if [ -d "$EXPERIMENT/Data/$SUBJ/post/anat/inplane" ]; then
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/inplane
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/post/anat/inplane
mkdir -p spgr
mkdir -p default
fi

# ------------------------------------------------------------------------------
#
#  Step 1: Image Format Conversions, Renaming and Segmentation
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_anat_batch.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
-e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
-e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
-e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' <$i> $OUTDIR/spm_anat_batch_${RUN}.m
done

fi

# ------------------------------------------------------------------------------
#
#  Step 2.1: Preparing Virtual Display
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

# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/bin/matlab -display :$RANDINT < spm_anat_batch_${RUN}.m
echo "Done running spm_anat_batch.m in matlab\n"


#If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
then
echo "lock file was created";
echo "cleaning up my lock file";
rm /tmp/.X${RANDINT}-lock;
rm /tmp/.X11-unix/X${RANDINT};
echo "lock file was deleted";
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
