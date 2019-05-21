#!/bin/sh

#-------------PRECPROCESS.sh---------------------------------------
 
# This script is intended to create a region of interest using the ROI tools
# it puts output in the EXPERIMENT/Analysis/FACES/TIMESERIES directory by
# subject folder!

# ---------WHEN DO I RUN THIS?------------
#  make sure you have run create_roi FIRST
#


#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 preprocess.sh 3 4 0503104045
#                                                        anatdir  funcdir  subjectID

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
 
# inputs are 4D ANALYZE, NIFTI_GZ or NIFTI func and coplanar T2 high-res
# spatially and temporally smooth func data with FSL defaults
# extract mean CSF and WM timeseries for use in nuisance model
# extract 154 mean structural ROI timeseries


# set various paths here
SCAN_DIR=$EXPERIMENT/Data
OUT_DIR=$EXPERIMENT/Analysis/FACES/TIMESERIES
ROI_DIR=$EXPERIMENT/Analysis/FACES/ROI/BIN


#USAGE="
#USAGE: preprocess -s <subject_ID> [options]
#Required arguments:
#  -s subject_id: subject ID

#Optional arguments:
#  -b:    don't run BET
#  -f:	 don't segment

#"
#if [ $# -eq 0 ]
#then
#  echo "$USAGE"
#  exit
#fi


# set up arguments here
#while getopts s:tb o 
#do  case "$o" in
#   s)    SUBJECT="$OPTARG";;
#   t)    TESTMODE=1;;
#   b)    NOBET=1;;
#   f)	 NOFAST=1;;
#   [?])  print >&2 "$USAGE"
#         exit 1;;
# esac
#done

ANATDIR=$1
FUNCDIR=$2
SUBJECT=$3

mkdir ${OUT_DIR}/$SUBJECT
mkdir ${OUT_DIR}/$SUBJECT/BET

cd ${OUT_DIR}/$SUBJECT

echo "Starting $SUBJECT"

echo "performing brain extraction..."

bet ${SCAN_DIR}/$SUBJECT/$ANATDIR/*.nii ${OUT_DIR}/$SUBJECT/BET/anat_brain -f .225 -m -R

echo "motion correction..."

/usr/local/fsl/bin/fslroi ${SCAN_DIR}/$SUBJECT/$FUNCDIR/*.nii ${OUT_DIR}/$SUBJECT/example_func 87 1

/usr/local/fsl/bin/mcflirt -in ${SCAN_DIR}/$SUBJECT/$FUNCDIR/*.nii -out ${OUT_DIR}/$SUBJECT/prefiltered_func_data_mcf -mats -plots -refvol 87 -rmsrel -rmsabs

/bin/mkdir -p mc ; /bin/mv -f prefiltered_func_data_mcf.mat prefiltered_func_data_mcf.par prefiltered_func_data_mcf_abs.rms prefiltered_func_data_mcf_abs_mean.rms prefiltered_func_data_mcf_rel.rms prefiltered_func_data_mcf_rel_mean.rms mc

cd mc

/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o rot.png 

/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o trans.png 

/usr/local/fsl/bin/fsl_tsplot -i prefiltered_func_data_mcf_abs.rms,prefiltered_func_data_mcf_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a absolute,relative -o disp.png 

cd ${OUT_DIR}/$SUBJECT

echo "making filtered func data..."

/usr/local/fsl/bin/bet prefiltered_func_data_mcf prefiltered_func_data_bet -F


/usr/local/fsl/bin/fslmaths prefiltered_func_data_bet -thrp 10 -Tmin -bin mask -odt char

/usr/local/fsl/bin/fslmaths prefiltered_func_data_bet -mas mask prefiltered_func_data_bet

/usr/local/fsl/bin/fslmaths mask -kernel gauss 2.12314225053 -fmean mask_weight -odt float

/usr/local/fsl/bin/fslmaths prefiltered_func_data_bet -kernel gauss 2.12314225053 -fmean -div mask_weight -mas mask ${OUT_DIR}/$SUBJECT/filtered_func_data -odt float


/usr/local/fsl/bin/fslmaths ${OUT_DIR}/$SUBJECT/filtered_func_data -ing 10000 ${OUT_DIR}/$SUBJECT/filtered_func_data -odt float

/usr/local/fsl/bin/fslmaths ${OUT_DIR}/$SUBJECT/filtered_func_data -bptf 30.0 -1 ${OUT_DIR}/$SUBJECT/filtered_func_data -odt float

/usr/local/fsl/bin/fslhd -x ${OUT_DIR}/$SUBJECT/filtered_func_data | sed 's/  dt = .*/  dt = '3.0'/g' | /usr/local/fsl/bin/fslcreatehd - filtered_func_data

/usr/local/fsl/bin/fslmaths ${OUT_DIR}/$SUBJECT/filtered_func_data -Tmean ${OUT_DIR}/$SUBJECT/mean_func

/bin/rm -rf prefiltered_func_data*

# echo "CSF and WM segmentation..."
# 
# /usr/local/fsl/bin/fast -t2 -c 3 -n -os -a -od ${OUT_DIR}/${SUBID}/${SUBID} ${OUT_DIR}/${SUBID}/${SUBID}_HR_brain
# 
# #renaming tissues
# cp ${OUT_DIR}/${SUBID}/${SUBID}_seg_0.nii.gz ${OUT_DIR}/${SUBID}/${SUBID}_CSF_mask.nii.gz
# 
# 
# cp ${OUT_DIR}/${SUBID}/${SUBID}_seg_2.nii.gz ${OUT_DIR}/${SUBID}/${SUBID}_WM_mask.nii.gz
# 

echo "registration..."

#  FLIRT func to HR to std 
## hires2std
 /usr/local/fsl/bin/flirt -in ${OUT_DIR}/$SUBJECT/BET/anat_brain.nii -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -omat ${OUT_DIR}/$SUBJECT/hires2std.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 

## func2hires 
 /usr/local/fsl/bin/flirt -in ${OUT_DIR}/$SUBJECT/example_func* -ref ${OUT_DIR}/$SUBJECT/BET/anat_brain.nii -omat ${OUT_DIR}/$SUBJECT/func2hires.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 

## concat hires2std and func2hires to make func2std
/usr/local/fsl/bin/convert_xfm -concat ${OUT_DIR}/$SUBJECT/hires2std.mat -omat ${OUT_DIR}/$SUBJECT/func2std.mat ${OUT_DIR}/$SUBJECT/func2hires.mat

## func2std
/usr/local/fsl/bin/flirt -in ${OUT_DIR}/$SUBJECT/example_func* -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -out ${OUT_DIR}/$SUBJECT/func2std -applyxfm -init ${OUT_DIR}/$SUBJECT/func2std.mat -interp trilinear

# invert matrix to get std2func
/usr/local/fsl/bin/convert_xfm -omat ${OUT_DIR}/$SUBJECT/std2func.mat -inverse ${OUT_DIR}/$SUBJECT/func2std.mat

# invert matrix to get hires2func
/usr/local/fsl/bin/convert_xfm -omat ${OUT_DIR}/$SUBJECT/hires2func.mat -inverse ${OUT_DIR}/$SUBJECT/func2hires.mat

# if [ $NOBET -eq 1]
# else
# transform WM & CSF masks to mean_func using HR2func
#   -in ${OUT_DIR}/${SUBID}/${SUBID}_WM_m.nii.gz -ref ${OUT_DIR}/${SUBID}/example_func.hdr -applyxfm -init ${OUT_DIR}/${SUBID}/hires2func.mat -out ${OUT_DIR}/${SUBID}/${SUBID}_WM_func
#  fslmaths ${OUT_DIR}/${SUBID}/${SUBID}_WM_func -thr 0.3 -bin ${OUT_DIR}/${SUBID}/${SUBID}_WM_mask
#  
#  flirt -in ${OUT_DIR}/${SUBID}/${SUBID}_CSF_mask.nii.gz -ref ${OUT_DIR}/${SUBID}/example_func.hdr -applyxfm -init ${OUT_DIR}/${SUBID}/hires2func.mat -out ${OUT_DIR}/${SUBID}/${SUBID}_CSF_func
#  fslmaths ${OUT_DIR}/${SUBID}/${SUBID}_CSF_func -thr 0.3 -bin ${OUT_DIR}/${SUBID}/${SUBID}_CSF_mask
#  exit
# fi
# 
# if [ $NOFAST -eq 1]
# then
#  else
#  echo "extracting mean CSF and WM timeseries"
#  
#  # extract mean timeseries from filtered_func for CSF and WM
#  fslmeants -i ${OUT_DIR}/${SUBID}/filtered_func_data -o ${OUT_DIR}/${SUBDIR}/WM_meants.txt -m ${OUT_DIR}/${SUBID}/${SUBID}_WM_mask
#  fslmeants -i ${OUT_DIR}/${SUBID}/filtered_func_data -o ${OUT_DIR}/${SUBDIR}/CSF_meants.txt -m ${OUT_DIR}/${SUBID}/${SUBID}_CSF_mask
# #  exit
# # fi
# # 

# transform ROI masks into mean_func using std2func
echo "transforming ROI masks..."
mkdir ${OUT_DIR}/$SUBJECT/ROI

for (( r=1; r<=115; r++ )); do
  flirt -in ${ROI_DIR}/ROI${r} -ref ${OUT_DIR}/$SUBJECT/example_func.nii.gz -applyxfm -init ${OUT_DIR}/$SUBJECT/std2func.mat -out ${OUT_DIR}/$SUBJECT/ROI/ROI${r}  
  fslmaths ${OUT_DIR}/$SUBJECT/ROI/ROI${r} -thr 0.3 -bin ${OUT_DIR}/$SUBJECT/ROI/ROI${r}
done;
 
# extract mean timeseries from each ROI
echo "extracting ROI timeseries..."
mkdir ${OUT_DIR}/$SUBJECT/TS

for ((t=1; t<=115; t++ )); do
  fslmeants -i ${OUT_DIR}/$SUBJECT/filtered_func_data -o ${OUT_DIR}/$SUBJECT/TS/ROI${t}.txt -m ${OUT_DIR}/$SUBJECT/ROI/ROI${t}
done;

echo "Done! ROI timeseries in TS directory"
 
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
