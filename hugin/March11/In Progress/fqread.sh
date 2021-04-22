#!/bin/sh

#-------------fqread.sh---------------------------------------
# SCRIPT NOT WORKING / READY FOR USE - DO NOT USE!
 
# This script takes the report.txt files produced from fq.sh and inputs them all into a
# simple excel file for further analysisc

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should run this script after you have completed running fq.sh and want to
# compile your results in a single file for analysis

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You also need to change the variable "COPES" to specify which copes you 
# want to create cluster_masks for!

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 fq_read.sh   Faces      2     20
#                                                        Design     COPE   Mask


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
# echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 
# -- END PRE-USER --
# **********************************************************
 
# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M @vsoch
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here
    
# SET OUR VARIABLES

DESIGN=$1 #this is the design under the ROI folder
COPE=$2  #this is the cope you want to concatenate report.txt files for
MASK=$3  #this is the number of the mask

SUBJECTS="040526133543 040527122743"
          #insert subjects in quotes, with a space between each one
 
COPEDIR=$EXPERIMENT/Analysis/ROI/$DESIGN

FILEPATHS=""

for SUBJ in $SUBJECTS; do

cd $COPEDIR/cope$COPE/Cluster_$MASK/$SUBJ/fq_$MASK

cat > subjectID.txt
"$SUBJ "

SUBJ_TEXT=$COPEDIR/cope$COPE/Cluster_$MASK/$SUBJ/fq_$MASK/subjectID.txt
REPORT=$COPEDIR/cope$COPE/Cluster_$MASK/$SUBJ/fq_$MASK/report.txt

cat $SUBJ_TEXT $REPORT < individual_report.txt

PATHTOADD=$COPEDIR/cope$COPE/Cluster_$MASK/$SUBJ/fq_$MASK/individual_report.txt
FILEPATHS="$FILEPATHS $PATHTOADD "

done

cat -n $FILEPATHS

# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/ROI/$DESIGN/cope$COPE}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
