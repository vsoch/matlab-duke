#!/bin/sh

#-------------CREATE_RROI.sh---------------------------------------
 
# This script is intended to create a region of interest using the ROI tools
# starts from the output directory EXPERIMENT/FACES/Analysis/ROI and creates
# folders CORT and SUBCORT with the ROIs from a specified atlas under Scripts/Tools/Atlas

# ---------HOW DO I RUN THIS?------------
# 
# -qsub -v EXPERIMENT=FIGS.01 create_roi.sh AtlasName

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 create_roi.sh AtlasName SubjectID
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
 
ATLAS=$1

#extract individual ROIs for each structure in Harvard Oxford thr50 2mm atlas
#A.A.Scott June 2009
#STSI

#set paths!!
BASE_DIR=$EXPERIMENT/Scripts/Tools/$ATLAS
OUTPUT=$EXPERIMENT/Analysis/FACES/ROI

mkdir $OUTPUT
mkdir ${OUTPUT}/CORT
mkdir ${OUTPUT}/SUBCORT

# extract cortical bilateral regions
for (( i = 1 ;  i <= 48;  i++ )); do

 fslmaths ${BASE_DIR}/HarvardOxford-cort-maxprob-thr50-2mm.nii.gz -thr ${i} -uthr ${i} ${OUTPUT}/CORT/AT${i}
 
done;


#isolate LH and RH ROIs
for (( i = 1 ;  i <= 48;  i++ )); do
fslmaths ${OUTPUT}/CORT/AT${i} -mul ${BASE_DIR}/LH_roi ${OUTPUT}/ROI${i}
done;

#super clunky way to do it for RH but it works
fslmaths ${OUTPUT}/CORT/AT1 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI59
fslmaths ${OUTPUT}/CORT/AT2 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI60
fslmaths ${OUTPUT}/CORT/AT3 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI61
fslmaths ${OUTPUT}/CORT/AT4 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI62
fslmaths ${OUTPUT}/CORT/AT5 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI63
fslmaths ${OUTPUT}/CORT/AT6 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI64
fslmaths ${OUTPUT}/CORT/AT7 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI65
fslmaths ${OUTPUT}/CORT/AT8 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI66
fslmaths ${OUTPUT}/CORT/AT9 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI67
fslmaths ${OUTPUT}/CORT/AT10 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI68
fslmaths ${OUTPUT}/CORT/AT11 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI69
fslmaths ${OUTPUT}/CORT/AT12 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI70
fslmaths ${OUTPUT}/CORT/AT13 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI71
fslmaths ${OUTPUT}/CORT/AT14 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI72
fslmaths ${OUTPUT}/CORT/AT15 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI73
fslmaths ${OUTPUT}/CORT/AT16 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI74
fslmaths ${OUTPUT}/CORT/AT17 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI75
fslmaths ${OUTPUT}/CORT/AT18 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI76
fslmaths ${OUTPUT}/CORT/AT19 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI77
fslmaths ${OUTPUT}/CORT/AT20 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI78
fslmaths ${OUTPUT}/CORT/AT21 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI79
fslmaths ${OUTPUT}/CORT/AT22 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI80
fslmaths ${OUTPUT}/CORT/AT23 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI81
fslmaths ${OUTPUT}/CORT/AT24 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI82
fslmaths ${OUTPUT}/CORT/AT25 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI83
fslmaths ${OUTPUT}/CORT/AT26 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI84
fslmaths ${OUTPUT}/CORT/AT27 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI85
fslmaths ${OUTPUT}/CORT/AT28 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI86
fslmaths ${OUTPUT}/CORT/AT29 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI87
fslmaths ${OUTPUT}/CORT/AT30 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI88
fslmaths ${OUTPUT}/CORT/AT31 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI89
fslmaths ${OUTPUT}/CORT/AT32 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI90
fslmaths ${OUTPUT}/CORT/AT33 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI91
fslmaths ${OUTPUT}/CORT/AT34 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI92
fslmaths ${OUTPUT}/CORT/AT35 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI93
fslmaths ${OUTPUT}/CORT/AT36 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI94
fslmaths ${OUTPUT}/CORT/AT37 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI95
fslmaths ${OUTPUT}/CORT/AT38 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI96
fslmaths ${OUTPUT}/CORT/AT39 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI97
fslmaths ${OUTPUT}/CORT/AT40 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI98
fslmaths ${OUTPUT}/CORT/AT41 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI99
fslmaths ${OUTPUT}/CORT/AT42 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI100
fslmaths ${OUTPUT}/CORT/AT43 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI101
fslmaths ${OUTPUT}/CORT/AT44 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI102
fslmaths ${OUTPUT}/CORT/AT45 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI103
fslmaths ${OUTPUT}/CORT/AT46 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI104
fslmaths ${OUTPUT}/CORT/AT47 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI105
fslmaths ${OUTPUT}/CORT/AT48 -mul ${BASE_DIR}/RH_roi ${OUTPUT}/ROI106



#extract subcortical regions
for k in 2 3 4 10 11 12 13 16 17 18 41 42 43 49 50 51 52 53 54; do

 fslmaths ${BASE_DIR}/HarvardOxford-sub-maxprob-thr50-2mm.nii.gz -thr ${k} -uthr ${k} ${OUTPUT}/SUBCORT/AT${k}

done;

mkdir ${OUTPUT}/SUBCORT/LEFT
mkdir ${OUTPUT}/SUBCORT/RIGHT


for al in 2 3 4 10 11 12 13 16 17 18; do
mv ${OUTPUT}/SUBCORT/AT${al}.nii.gz ${OUTPUT}/SUBCORT/LEFT
done;

#rename a few files to make things easier
mv ${OUTPUT}/SUBCORT/LEFT/AT2.nii.gz ${OUTPUT}/SUBCORT/LEFT/AT02.nii.gz
mv ${OUTPUT}/SUBCORT/LEFT/AT3.nii.gz ${OUTPUT}/SUBCORT/LEFT/AT03.nii.gz
mv ${OUTPUT}/SUBCORT/LEFT/AT4.nii.gz ${OUTPUT}/SUBCORT/LEFT/AT04.nii.gz

for ar in 41 42 43 49 50 51 52 53 54; do
mv ${OUTPUT}/SUBCORT/AT${ar}.nii.gz ${OUTPUT}/SUBCORT/RIGHT
done;


cd ${OUTPUT}


#rename subcort into ROI files
#Order: Left Cort (1-48) Left Subcort (49-59) Right Cort (59-106) Right Subcort (107-115)

n=49
for s in `ls SUBCORT/LEFT`; do
   cp ${OUTPUT}/SUBCORT/LEFT/${s} ${OUTPUT}/ROI${n}.nii.gz
   n=`expr ${n} + 1`
 done;


q=107
for t in `ls SUBCORT/RIGHT`; do
   cp ${OUTPUT}/SUBCORT/RIGHT/${t} ${OUTPUT}/ROI${q}.nii.gz
   q=`expr ${q} + 1`
 done; 

#binarize all

mkdir ${OUTPUT}/BIN

for r in `ls *.nii.gz`; do
 fslmaths ${r} -bin ${OUTPUT}/BIN/${r}
done;
 
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
