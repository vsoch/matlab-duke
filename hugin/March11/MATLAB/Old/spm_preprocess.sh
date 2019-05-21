#!/bin/sh

# --------------MATLAB SPM JOB SUBMIT ----------------
# 
# This script is an attempt to launch a matlab script from the head node
#
# ----------------------------------------------------

#
# >  qsub -v EXPERIMENT=Dummy.01  test.sh $SUBJECT  $RUN   $FUNC
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
echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 
# -- END PRE-USER --
# **********************************************************

# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M vsochat@gmail.com

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --
# User script goes here

# Initialize input variables (Later have these fed in via python script)
SUBJ=$1         # This is the full subject folder name under Data
RUN=$2          # This is a run number, if applicable
FUNCFOLDER=$3   # This is the name of the functional folder run (run004_04)
ANATFOLDER=$4   # This is the name of the anatomical folder (series002)
TASK=$5         # This is the functional task, either faces or cards
SCRIPTNAME=$6   # This is the name of the template script


# First we create a directory for the subjects SPM data
mkdir -p $EXPERIMENT/Analysis/SPM/$SUBJ

# Now we create directories to put the anatomical and functional processed data
mkdir -p $EXPERIMENT/Analysis/SPM/$SUBJ/anat
mkdir -p $EXPERIMENT/Analysis/SPM/$SUBJ/$TASK
  
# Initialize other variables to pass on to matlab template script
FUNCOUTPUT=$EXPERIMENT/Analysis/SPM/$SUBJ/$TASK    # This is the functional output directory
ANATDIRECTORY=$EXPERIMENT/Data/Anat/$SUBJ/$ANATFOLDER # This is the location of the anatomical data
OUTDIR=$EXPERIMENT/Analysis/SPM/$SUBJ                 # This is the subject output directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the custer
PATHDEFS=/home/vvs4/matlab                            # This is where my pathdefs are

# Go to the subject anatomical data directory to pull prefix of the image names and shove into a variable
cd $ANATDIRECTORY

# This prepares the file path if we are using dicoms that end in ,dcm
if [ $ANATFOLDER == 'series002' ]; then

ANATFILE=*01.dcm
ANATPRE=$(echo $ANATFILE | cut -c1-26)

fi

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_convert.m'; do
sed -e 's@SUB_FUNCOUTPUT_SUB@'$FUNCOUTPUT'@g' \
 -e 's@SUB_FUNCFOLDER_SUB@'$FUNCFOLDER'@g' \
 -e 's@SUB_FUNCTYPE_SUB@'$TASK'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_DICOM_SUB@'$ANATPRE'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANATFOLDER'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_PATHDEFS_SUB@'$PATHDEFS'@g' <$i> $OUTDIR/spm_convert_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/matlab2009a/bin/matlab -nodisplay < spm_convert_${RUN}.m

# IN THE FUTURE - SCRIPT NEEDS TO BE SETUP TO PICK AND CHOOSE FUNCTIONAL / ANAT CONVERSIONS
# AND ALSO TO COPY THE C1 IMAGE TO MUILTIPLE FUNCTIONAL DIRECTORIES


# Now we want to perform the realign and unwarp steps with spm_preprocess.m

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_preprocess.m'; do
sed -e 's@SUB_FUNCOUTPUT_SUB@'$FUNCOUTPUT'@g' \
 -e 's@SUB_FUNCFOLDER_SUB@'$FUNCFOLDER'@g' \
 -e 's@SUB_FUNCTYPE_SUB@'$TASK'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANATFOLDER'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_PATHDEFS_SUB@'$PATHDEFS'@g' <$i> $OUTDIR/spm_preprocess_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/matlab2009a/bin/matlab -nodisplay < spm_preprocess_${RUN}.m


# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM8/$SUBJ}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
