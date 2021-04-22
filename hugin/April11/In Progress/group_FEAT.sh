#!/bin/sh

#----------group_FEAT.sh-----------
# This script runs a group level FEAT analysis, with the specification of..
# ... in the command line.  The script assumes that a second level analysis
#  has been run, and we are selecting individual COPESs from a gfeat folder
#  If no second level analyses have been run, this script is not the one to use!
#  Use simple_group_FEAT.sh for that!
 
#----------SUBMISSION ON COMMAND LINE----------------

#>  [user@head ~]$ qsub -v EXPERIMENT=Dummy.01 group_FEAT.sh    3        4      4Block         run01    34565434   
#                                                                  ANATDIR FUNCTDIR   design folder   run     subjFolder  
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
 
#-------------LONG VARIABLES------------------
#MODEL is the name of the anatomical directory under DATA
#COPE is the name of the functional directory under DATA
 
#Need to input EXPERIMENT, SUBJ and RUN NAME
#Example qsub -v EXPERIMENT=Dummy.01 first_level_FEAT.sh 99999 run01

MODEL=$1
COPE=$2

 
#data location and other variables
FSLDATADIR=$EXPERIMENT/Analysis/FEAT/First_level/*
# ------------------------------------------------
# I'm not sure if the * will jump to the first folder available, or check 
# all folders under First_level.  We need to make sure subjects are being
# pulled from Individual, 4Block, and MixedBlock, and the Design folder
# isn't causing any trouble!

OUT=$EXPERIMENT/Analysis/FEAT/GroupFEAT
OUTPUT=${OUT}/MODEL_${MODEL}.gfeat
 
#L3 Inputs
INPUT1=${FSLDATADIR}/47481/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT2=${FSLDATADIR}/47489/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT3=${FSLDATADIR}/47502/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT4=${FSLDATADIR}/47512/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT5=${FSLDATADIR}/47524/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT6=${FSLDATADIR}/47545/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT7=${FSLDATADIR}/47546/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT8=${FSLDATADIR}/47553/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
INPUT9=${FSLDATADIR}/47556/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT10=${FSLDATADIR}/47557/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT11=${FSLDATADIR}/47559/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT12=${FSLDATADIR}/47583/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT13=${FSLDATADIR}/47586/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT14=${FSLDATADIR}/47591/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
#INPUT15=${FSLDATADIR}/47601/memory/cope${COPE}.gfeat/cope1.feat/stats/cope1.nii.gz
NAME=Cope${COPE}
 
COUNT=0;
 
for i in `seq 1 15`; do
 
ID=INPUT${i};
TEMP=${!ID};
 
if [ -n "$TEMP" ]; then
let "COUNT=$COUNT+1";
echo $COUNT
 
 
if [ -z "$COPE1" ]; then
COPE1=$TEMP;
 
elif [ -z "$COPE2" ]; then
COPE2=$TEMP;
 
elif [ -z "$COPE3" ]; then
COPE3=$TEMP;
 
elif [ -z "$COPE4" ]; then
COPE4=$TEMP;
 
elif [ -z "$COPE5" ]; then
COPE5=$TEMP;
 
elif [ -z "$COPE6" ]; then
COPE6=$TEMP;
 
elif [ -z "$COPE7" ]; then
COPE7=$TEMP;
 
elif [ -z "$COPE8" ]; then
COPE8=$TEMP;
 
elif [ -z "$COPE9" ]; then
COPE9=$TEMP;
 
elif [ -z "$COPE_10" ]; then
COPE_10=$TEMP;
 
elif [ -z "$COPE_11" ]; then
COPE_11=$TEMP;
 
elif [ -z "$COPE_12" ]; then
COPE_12=$TEMP;
 
elif [ -z "$COPE_13" ]; then
COPE_13=$TEMP;
 
elif [ -z "$COPE_14" ]; then
COPE_14=$TEMP;
 
elif [ -z "$COPE_15" ]; then
COPE_15=$TEMP;
 
fi
 
fi
done
 
 
 
for i in $EXPERIMENT/Analysis/'memory_L3.fsf'; do
sed -e 's@OUTPUT@'$OUTPUT'@g' \
    -e 's@NAME@'$NAME'@g' \
    -e 's@FSLDIR@'$FSLDIR'@g' \
    -e 's@COUNT@'$COUNT'@g' \
    -e 's@COPE1@'$COPE1'@g' \
    -e 's@COPE2@'$COPE2'@g' \
    -e 's@COPE3@'$COPE3'@g' \
    -e 's@COPE4@'$COPE4'@g' \
    -e 's@COPE5@'$COPE5'@g' \
    -e 's@COPE6@'$COPE6'@g' \
    -e 's@COPE7@'$COPE7'@g' \
    -e 's@COPE8@'$COPE8'@g' \
    -e 's@COPE9@'$COPE9'@g' \
    -e 's@COPE_10@'$COPE_10'@g' \
    -e 's@COPE_11@'$COPE_11'@g' \
    -e 's@COPE_12@'$COPE_12'@g' \
    -e 's@COPE_13@'$COPE_13'@g' \
    -e 's@COPE_14@'$COPE_14'@g' \
    -e 's@COPE_15@'$COPE_15'@g' <$i> ${OUT}/L3_model${MODEL}.fsf
done
 
#run the newly created fsf files
python ${FSLDATADIR}/run_job.py ${OUT}/L3_model${MODEL}.fsf
 
 
 
# -- END USER SCRIPT -- # 
 
 
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
