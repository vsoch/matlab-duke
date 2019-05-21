#!/bin/sh
 
#-------Mcflirt.sh------------------
# This script is intended to run Mcflirt motion correction.on the functional
# data, typically in folder 4, but you can specify the folder in the argument
# The output is saved to a folder called Mcflirt in the functional data folder.
#
#---------SUBMISSION ON COMMAND LINE-------------
# 
# >  qsub -v EXPERIMENT=Dummy.01  Mcflirt.sh *.nii           Data/RawData/    orient.mat      4      3432922345
#                                             input nifti    datadirectory   OutputName FunctFolder Subject Folder
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
#$ -M user@somewhere.edu
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here
 
# Need to input global EXPERIMENT, and inputs BxHFILE, OUTDIR and OUTPRE
# NIFTI is the input file
# DATADIR is the name of the main data Directory
# OUTDIR is where the output file will go
# OUTNAME is the output name of the file
# Example:
# qsub -v EXPERIMENT=Dummy.01 qsub_MkFlirtInitMtx \
# EXPERIMENT/Anat/99999/series500/series500.bxh \
# EXPERIMENT/Anat/99999/ ORIENT.mat
NIFTI=$1
DATADIR=$2
OUTNAME=$3
FUNCFOLD=$4
SUBJECT=$5
  
OUTDIR=$EXPERIMENT/$DATADIR/$SUBJECT/$FUNCFOLD/
cd OUTDIR  
mkdir -p Mcflirt
echo "MkFlirtInitMtx.pl --in $NIFTI --stdref --o $OUTDIR/Mcflirt/$OUTNAME"
MkFlirtInitMtx.pl --in $NIFTI --stdref --o $OUTDIR/Mcflirt/$OUTNAME
 
 
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
 
