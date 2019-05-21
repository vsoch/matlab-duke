#!/bin/sh

# --------------SPM BATCH FIGS TEMPLATE ----------------
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

FACESRUN=SUB_FACESRUN_SUB    # yes runs, no skips processing faces task
CARDSRUN=SUB_CARDSRUN_SUB    # yes runs, no skips processing cards task
DESIGN=SUB_FACESDESIGN_SUB        #1: 4block, 2: mixedblock, 3: Individual
SEGMENT=SUB_IMAGEPREPONLY_SUB   # yes runs ONLY dicom to nifti imports without segmentation.
                                # If this option is selected, the user must manually segment and
				# copy the c1* images into each functional folder, and then run with
				# the "funconly" option to finish processing
ONLYFUNC=SUB_FUNCONLY_SUB       # yes does all processing after segmentation, in spm_batch2.m

# Set the design type based on the user choice
if [ $DESIGN == 1 ]
then
MDESIGN="4block"
fi

if [ $DESIGN == 2 ]
then
MDESIGN="4blockmixed"
fi

if [ $DESIGN == 3 ]
then
MDESIGN="Individual"
fi

#Make the subject specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/anat/raw
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/raw
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/raw
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/highres
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/highres/raw
mkdir -p $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/Scripts
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Cards
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Faces
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Faces/block
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Faces/affect

#Go to individual subject  folder and set data directories
cd $EXPERIMENT/Data/$SUBJ

ANATFOLDER=SUB_ANATFOL_SUB         # This is the name of the anatomical folder
TFOLD=SUB_TONEFOLD_SUB             # This is the name of the highres folder
FACESFOLD=SUB_FACESFOLD_SUB        # This is the name of the faces functional folder
CARDSFOLD=SUB_CARDSFOLD_SUB        # This is the name of the cards functional folder

SUBPRE=$SUBJ

# Initialize other variables to pass on to matlab template script
ANATDIRECTORY=$EXPERIMENT/Data/$SUBJ/$ANATFOLDER      # This is the location of the anatomical data
T1DIRECTORY=$EXPERIMENT/Data/$SUBJ/$TFOLD             # This is the location of the highres data
FACESDIRECTORY=$EXPERIMENT/Data/$SUBJ/$FACESFOLD      # This is the faces data directory
CARDSDIRECTORY=$EXPERIMENT/Data/$SUBJ/$CARDSFOLD      # This is the cards data directory

OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ       # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
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

if [ $ANATFOLDER == 'anat' ]; then

if [ -e "$ANATDIRECTORY" ]; then

# Go to the subject anatomical data directory to rename and move images
cd $ANATDIRECTORY

countVar=1;

#Prepare the anatomical images
for file in *.dcm
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER/raw/V0$countVar.dcm
fi

let "countVar += 1";

done
fi
fi


##########################################################################
#
# Highres
#
##########################################################################

if [ $TFOLD != 'none' ]; then

if [ -e "$T1DIRECTORY" ]; then

# Go to the subject highres data directory to rename and move images
cd $T1DIRECTORY

countVar=1;

#Prepare the anatomical images
for file in *.dcm
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD/raw/V0$countVar.dcm
fi

let "countVar += 1";

done
fi
fi

##########################################################################
#
# Cards Functional Data
#
##########################################################################

if [ $CARDSRUN == 'yes' ]; then

if [ -e "$CARDSDIRECTORY" ]; then

# Go to the subject cards data directory to rename and move images
cd $CARDSDIRECTORY

countVar=1;

#Prepare the cards functional images
for file in *.dcm
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/raw/V0$countVar.dcm
fi

let "countVar += 1";

done
fi
fi

##########################################################################
#
# Faces Functional Data
#
##########################################################################

if [ $FACESRUN == 'yes' ]; then

if [ -e "$FACESDIRECTORY" ]; then

# Go to the subject faces data directory to rename and move images
cd $FACESDIRECTORY

countVar=1;

#Prepare the images
for file in *.dcm
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/raw/V000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/raw/V00$countVar.dcm
fi 
fi

if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/raw/V0$countVar.dcm
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
for i in 'spm_batch1.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_FACESFOLDER_SUB@'$FACESFOLD'@g' \
 -e 's@SUB_CARDSFOLDER_SUB@'$CARDSFOLD'@g' \
 -e 's@SUB_RESTFOLDER_SUB@'$RESTFOLD'@g' \
 -e 's@SUB_SUBID_SUB@'$SUBPRE'@g' \
 -e 's@SUB_SEGMENT_SUB@'$SEGMENT'@g' \
 -e 's@SUB_RUNFACES_SUB@'$FACESRUN'@g' \
 -e 's@SUB_RUNOLDFACES_SUB@'$OLDFACESRUN'@g' \
 -e 's@SUB_RUNCARDS_SUB@'$CARDSRUN'@g' \
 -e 's@SUB_RUNREST_SUB@'$RESTRUN'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANATFOLDER'@g' \
 -e 's@SUB_TFOLDER_SUB@'$TFOLD'@g' <$i> $OUTDIR/spm_batch1_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/bin/matlab -nodisplay < spm_batch1_${RUN}.m

echo "Done running spm_batch1.m in matlab"


# ------------------------------------------------------------------------
#
# Step 3: Rename anatomicals for segmentation and then processing
#
# ------------------------------------------------------------------------

if [ $ANATFOLDER == 'anat' ]; then

cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER

#Rename the s* image and header (it will be segmented and copied into functional
#directories in spm_batch2.m

anatfile=s*.img
cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER/anat.img
rm $anatfile

anatfile=s*.hdr

cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$ANATFOLDER/anat.hdr
rm $anatfile

fi

if [ $TFOLD == 'highres' ]; then
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD

#Rename the s* image and header 

anatfile=s*.img
cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD/mprage.img
rm $anatfile

anatfile=s*.hdr

cp $anatfile $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/$TFOLD/mprage.hdr
rm $anatfile

fi


# ------------------------------------------------------------------------------
#
#  Step 4: Rename functional data to prepare for second matlab script
#
# ------------------------------------------------------------------------------

##########################################################################
#
# Faces
#
##########################################################################

if [ $FACESRUN == 'yes' ]; then

if [ -e "$FACESDIRECTORY" ]; then

# Go to the subject faces directory to rename images
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces
echo "Preparing faces images"

countVar=1;

for file in f*.img
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V000$countVar.img
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V00$countVar.img
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V0$countVar.img
fi

let "countVar += 1";

done

countVar=1;
for file in f*.hdr
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V000$countVar.hdr
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V00$countVar.hdr
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/faces/V0$countVar.hdr
fi

let "countVar += 1";

done
fi
fi


##########################################################################
#
# Cards
#
##########################################################################


if [ $CARDSRUN == 'yes' ]; then

if [ -e "$CARDSDIRECTORY" ]; then

# Go to the subject faces directory to rename images
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards
echo "Preparing Cards images"

countVar=1;

for file in f*.img
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V000$countVar.img
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V00$countVar.img
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V0$countVar.img
fi

let "countVar += 1";

done

countVar=1;
for file in f*.hdr
do

if (($countVar < 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V000$countVar.hdr
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V00$countVar.hdr
fi 
fi

if (($countVar >= 100)); then
mv $file $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards/V0$countVar.hdr
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
for i in 'spm_batch2.m'; do
sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_RUNFACES_SUB@'$FACESRUN'@g' \
 -e 's@SUB_RUNOLDFACES_SUB@'$OLDFACESRUN'@g' \
 -e 's@SUB_RUNCARDS_SUB@'$CARDSRUN'@g' \
 -e 's@SUB_SEGMENT_SUB@'$SEGMENT'@g' \
 -e 's@SUB_RUNREST_SUB@'$RESTRUN'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_DESIGN_SUB@'$MDESIGN'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANATFOLDER'@g' \
 -e 's@SUB_TFOLDER_SUB@'$TFOLD'@g' \
 -e 's@SUB_SUBID_SUB@'$SUBPRE'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/spm_batch2_${RUN}.m
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
/usr/local/bin/matlab -display :$RANDINT < spm_batch2_${RUN}.m

echo "Done running spm_batch2.m in matlab";

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
