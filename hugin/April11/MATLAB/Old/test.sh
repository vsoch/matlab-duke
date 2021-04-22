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
#$ -M @vsoch

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --
# User script goes here

# Initialize input variables
SUBJ=$1
RUN=$2
FUNC=$3

# echo "Cutoff frequency is " & $CUTOFF

# Initialize other variables
FUNCTIONAL=$EXPERIMENT/Data/SPM8/$SUBJ/$FUNC/*.nii
OUTDIR=$EXPERIMENT/Analysis/SPM8/$SUBJ

#OUTFILE=$OUTDIR/${RUN}_filtered
#TEMPFILE=$OUTDIR/${RUN}_temp.img

SCRIPTDIR=$EXPERIMENT/Scripts/MATLAB/SPM
BIACROOT=/usr/local/packages/MATLAB/BIAC
PATHDEFS=/home/vvs4/matlab

# Make output directory if it doesn't exist
mkdir -p $OUTDIR

# Change into directory where template exists
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'realign.m'; do
sed -e 's@SUB_FUNCTIONAL_SUB@'$FUNCTIONAL'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_PATHDEFS_SUB@'$PATHDEFS'@g' <$i> $OUTDIR/realign_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/matlab2009a/bin/matlab -nodisplay < realign_${RUN}.m

# Convert output data to .nii.gz and delete temp file
# bxh2analyze --niigz -s $OUTDIR/${RUN}_temp.bxh $OUTFILE
# rm -f $OUTDIR/${RUN}_temp.*


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
