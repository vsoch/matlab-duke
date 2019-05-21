#!/bin/sh

# --------------SPM CARDS TEMPLATE ----------------
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
TFOLD=SUB_TONEFOLD_SUB        # This is the name of the highres folder
FACESFOLD=SUB_FACESFOLD_SUB  # This is the name of the faces functional folder
CARDSFOLD=SUB_CARDSFOLD_SUB  # This is the name of the cards functional folder
RESTFOLD=SUB_RESTFOLD_SUB    # This is the name of the rest functional folder
FACESRUN=SUB_FACESRUN_SUB    # yes runs, no skips processing faces task
CARDSRUN=SUB_CARDSRUN_SUB    # yes runs, no skips processing cards task
RESTRUN=SUB_RESTRUN_SUB      # yes runs, no skips processing rest task
JUSTFUNC=SUB_JUSTFUNC_SUB    # yes skips anatomical processing, to be used if you have manually
                             # set the origins of anatomical and need to re-run faces, cards, rest
PREONLY=SUB_PREONLY_SUB      # yes only prepares the images / folder for AC-PC realign
FACESORDER=SUB_ORDERNO_SUB   # this is the faces task order that determines the matlab script template to use

#Make the subject specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ
  
# Initialize other variables to pass on to matlab template script
ANATDIRECTORY=$EXPERIMENT/Data/Anat/$SUBJ/$ANATFOLDER # This is the location of the anatomical data
T1DIRECTORY=$EXPERIMENT/Data/Anat/$SUBJ/$TFOLD       # This is the location of the anatomical data
OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ       # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the custer

if [ $JUSTFUNC == 'no' ]; then

# CHANGE NAMES FOR CARDS

if [ $CARDSRUN == 'yes' ]; then

cd $EXPERIMENT/Data/Func/$SUBJ/run004_04/NiftiHeaders
mkdir -p images

for (( c=72; c<=171; c++ ))
do
IMGFILE=*$c.img
HDRFILE=*$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c39-46)
HDRPRE=$(echo $HDRFILE | cut -c39-46)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *$c.img $OUTDIR/cards/$NEWIMGPATH
cp *$c.hdr $OUTDIR/cards/$NEWHDRPATH
done

for (( c=10; c<=71; c++ ))
do
IMGFILE=*0$c.img
HDRFILE=*0$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c39-46)
HDRPRE=$(echo $HDRFILE | cut -c39-46)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *0$c.img $OUTDIR/cards/$NEWIMGPATH
cp *0$c.hdr $OUTDIR/cards/$NEWHDRPATH
done

for (( c=1; c<=9; c++ ))
do
IMGFILE=*000$c.img
HDRFILE=*000$c.hdr
IMGPRE=$(echo $IMGFILE | cut -c39-46)
HDRPRE=$(echo $HDRFILE | cut -c39-46)
NEWIMGPATH="V"$IMGPRE
NEWHDRPATH="V"$HDRPRE
cp *000$c.img $OUTDIR/cards/$NEWIMGPATH
cp *000$c.hdr $OUTDIR/cards/$NEWHDRPATH
done

fi

fi

# ------------------------------------------------------------------------------
#
#  Step 1: Realign and Unwarp, Normalization, Smoothing
#
# ------------------------------------------------------------------------------

if [ $PREONLY == 'no' ]; then

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

    # Loop through template script replacing keywords
    for i in 'spm_cards2.m'; do
    sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
    -e 's@SUB_RUNFACES_SUB@'$FACESRUN'@g' \
    -e 's@SUB_RUNCARDS_SUB@'$CARDSRUN'@g' \
    -e 's@SUB_RUNREST_SUB@'$RESTRUN'@g' \
    -e 's@SUB_ONLYDOFUNC_SUB@'$JUSTFUNC'@g' \
    -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
    -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
    -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/spm_cards2_${RUN}.m
    done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

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
      RANDINT=$(( 100+(`od -An -N2 -i /dev/random` )%(500-100+1) ));
      echo "the random integer for Xvfb is ${RANDINT}";
done

#Initialize Xvfb, put buffer output in TEMP directory
Xvfb :$RANDINT -fbdir $TMPDIR &
/usr/local/matlab2009b/bin/matlab -display :$RANDINT < spm_cards2_${RUN}.m

echo "Done running spm_cards2.m in matlab"

If the lock was created, delete it
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
