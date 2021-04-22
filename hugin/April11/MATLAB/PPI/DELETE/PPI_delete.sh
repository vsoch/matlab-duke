#!/bin/sh

# -------- PPI DELETE ---------

# This script is intended to delete PPI analyses and the VOIs
 
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

# --- LONG VARIABLE DEFINITIONS ---

SUBJ=$1
PPIFOLDER=$2   #Faces_gr_Shapes

# First delete all PPI analysis under user specified folder
if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI" ]; then
cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER" ]; then

cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/lAMY_cluster_200" ]; then 
  rm -r lAMY_cluster_200
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/rAMY_cluster_200" ]; then 
  rm -r rAMY_cluster_200
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/rAMY_cluster" ]; then 
  rm -r rAMY_cluster
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/lAMY_cluster" ]; then 
  rm -r lAMY_cluster
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/lAMY_cluster_141" ]; then 
  rm -r lAMY_cluster_141
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER/rAMY_cluster_141" ]; then 
  rm -r rAMY_cluster_141
fi

rmdir $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$PPIFOLDER

else
echo "$PPIFOLDER does not exist under PPI!"
fi

else 
echo "No PPI folder with contents to delete!"
fi

# Next delete all VOIs with same folder under VOIs
if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs" ]; then
cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER" ]; then

cd $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_lAMY_cluster_200.mat" ]; then 
  rm VOI_lAMY_cluster_200.mat
  rm VOI_lAMY_cluster_200.img
  rm VOI_lAMY_cluster_200.hdr
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_rAMY_cluster_200.mat" ]; then 
  rm VOI_rAMY_cluster_200.mat
  rm VOI_rAMY_cluster_200.img
  rm VOI_rAMY_cluster_200.hdr
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_lAMY_cluster.mat" ]; then 
  rm VOI_lAMY_cluster.mat
  rm VOI_lAMY_cluster.img
  rm VOI_lAMY_cluster.hdr
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_rAMY_cluster.mat" ]; then 
  rm VOI_rAMY_cluster.mat
  rm VOI_rAMY_cluster.img
  rm VOI_rAMY_cluster.hdr
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_rAMY_cluster_141.mat" ]; then 
  rm VOI_rAMY_cluster_141.mat
  rm VOI_rAMY_cluster_141.img
  rm VOI_rAMY_cluster_141.hdr
fi

if [ -e "$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER/VOI_lAMY_cluster_141.mat" ]; then 
  rm VOI_lAMY_cluster_141.mat
  rm VOI_lAMY_cluster_141.img
  rm VOI_lAMY_cluster_141.hdr
fi

rmdir $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$PPIFOLDER

else
echo "$PPIFOLDER does not exist under VOIs!"
fi

else 
echo "No VOIs folder with contents to delete!"
fi

 
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
