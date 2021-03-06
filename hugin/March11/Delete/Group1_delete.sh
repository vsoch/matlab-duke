#!/bin/sh

# -------- REST DELETE ---------

# This script is intended deleting functional analysis if something needs to be
# rerun.

# -------- SUBMITTING JOB ON COMMAND LINE --------------
 
# >  qsub -v EXPERIMENT=FIGS.01 REST_delete.sh  Subject  Task

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

# --- LONG VARIABLE DEFINITIONS ---

SUBJ=$1

if [ -e "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards" ]; then
cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/cards

rm art_regression_outliers*
rm c1s_sn*
rm meanuV0001*
rm swuV*
rm uV*
rm wuV*
rm rp_V0001*
rm spm_2010*
rm V0001_uw*

fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/cards_pfl" ]; then
cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/cards_pfl

rm art*
rm RPV*
rm mask*
rm beta*
rm SPM*
rm Res*

fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Cards" ]; then
cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/Cards

rm con*
rm RPV*
rm mask*
rm beta*
rm SPM*
rm Res*
rm spmT*

fi

#if [ -e "$EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest" ]; then
#cd $EXPERIMENT/Analysis/SPM/Processed/$SUBJ/rest

#rm art_regression_outliers*
#rm c1s02_sn*
#rm meanuV0001*
#rm swuV*
#rm uV*
#rm wuV*
#rm rp_V0001*
#rm spm_2010*
#rm V0001_uw*
#rm c1*

#fi

#if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/faces_pfl" ]; then
#cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/rest_pfl

#rm art*
#rm RPV*
#rm mask*
#rm beta*
#rm SPM*
#rm Res*

#fi

 
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
