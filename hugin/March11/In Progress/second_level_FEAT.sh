#!/bin/sh
 
# ---------second_level_FEAT.sh-------------------
# This script is intended to run second level FEAT analysis,
# which combines multiple runs on an individual subject and outputs
# copes to Analysis/FEAT/second_level/SubjectID.  The copes
# make it possible and easy to run level 3, or Group FEAT analysis.
#
# ---------SUBMITTING ON COMMAND LINE-------------
#
# >  qsub -v EXPERIMENT=Dummy.01  second_level_FEAT.sh args 4Block 0506121058
#                                                           design  subject folder ID
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
$ -M @vsoch
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here
 
#Need to input EXPERIMENT and DESIGN and SUBJ
#Example qsub -v EXPERIMENT=Dummy.01 second_level_FEAT 4Block 99999
DESIGN=$1
SUBJ=$2
 
#Set the directories
FIRSTLEVELDIR=$EXPERIMENT/Analysis/FEAT/First_Level/$DESIGN/$SUBJ
OUTDIR=$EXPERIMENT/Analysis/FEAT/Second_level/$SUBJ
TEMPLATEDIR=$EXPERIMENT/Analysis/FEAT/Second_level/$DESIGN
 
#Set some variables
OUTPUT=$OUTDIR
 
mkdir -p $OUTDIR
cd $TEMPLATEDIR
 
#Makes the fsf file using the template
for i in 'design.fsf'; do
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@FSLDIR@'$FSLDIR'@g' \
-e 's@FIRSTLEVELDIR@'$FIRSTLEVELDIR'@g' <$i> ${OUTDIR}/gFEAT_${SUBJ}.fsf
done
 
#Run feat analysis
feat ${OUTDIR}/gFEAT_${SUBJ}.fsf
 
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
