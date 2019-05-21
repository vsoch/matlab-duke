#!/bin/sh

#-------------create_cluster_masks.sh---------------------------------------
 
# This script takes the cluster_index.nii as input from a groupFEAT directory
# GroupFEAT/name.gfeat/cope1.feat/stats/cluster_index.nii
# and creates the specified masks based on different intensities in the cluster_index,
# These masks are intended to be used as ROI masks in the featquery.

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should create the masks after running cluster_roi.sh
# to create the cluster_index, and after looking at the output from
# this index and deciding which intensities you want to create masks for.
# This script is the SECOND step in creating the MASK that featquery will use

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You also need to change the variable "COPES" to specify which copes you 
# want to create cluster_masks for!

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 BET.sh  Faces            run01
#                                                    design          runname

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

DESIGN=$1
RUNNAME=$2

GFEATDIRECTORY=$EXPERIMENT/Analysis/FACES/GroupFEAT/$DESIGN/$RUNNAME/$RUNNAME.gfeat
MASKS="1" # YOU MUST WRITE THE MASKS YOU WANT TO MAKE HERE!
COPES="1" # YOU MUST SPECIFY THE COPE DIRECTORY TO CREATE MASKS IN.  
          # NOTE THAT IF YOU SELECT MORE THAN ONE, THEY MUST BOTH HAVE
	  # cluster_index.nii with the chosen intensities to make masks

for COPE in $COPES; do

COPEDIR=$GFEATDIRECTORY/cope$COPE.feat
INFILE=$COPEDIR/cluster_index.nii.gz

cd $COPEDIR
mkdir -p $COPEDIR/Cluster_masks

for MASK in $MASKS; do

fslmaths $INFILE -thr $MASK -uthr $MASK.5 Cluster_masks/cluster$MASK.nii 

done

done

 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/FACES/GroupFEAT/$DESIGN/$RUNNAME}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
