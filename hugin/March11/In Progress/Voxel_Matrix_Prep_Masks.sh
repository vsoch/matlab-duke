#!/bin/sh

#-------------Voxel_Matrix_Prep_Masks-----------------------------------

# This script is intended to prepare the Preprocessed SPM5 functional data
# in order to create a matrix with all of the voxel intensities in MATLAB with SPM5
# This script is different from Voxel_Matrix_Prep because it uses more than one mask,
# resulting in THREE niftis to create three matrices from.

# This script first makes the 3D swrf images into one 4D image
# It next uses the subject's standard space mask to clean up the 4D image
# and saves it as nifti to create a matrix from.  It then applies an SPM
# standard space mask to the nifti to create a second image, and lastly,
# it applies a ROI mask, (specified by the user)

# It then runs a brain extraction on the first 4D image to remove the eyeballs
# Next, these images are ready for processing in MATLAB

# ***********OUTPUT IS THE FOLLOWING************
#
# faces_4D_swrf_submasked_noeyes.nii  --- the image with only the subject mask applied
# faces_4D_swrf_stanmasked.nii --- the image with the subject and standard mask
# faces_4D_swrf_ROI.nii --- the image with the subject, standard, and ROI mask
#

# ---------WHEN DO I RUN THIS?------------
# You should use this script AFTER you have preprocessed the SPM5 data

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# the BET value
# It is expected that the data is located under Data/SPMFaces/SPM2Processed/$SUBJECT/Faces
# The SPM standard mask is coded in to be Analysis/ROI/Masks/SPM_Mask.nii
# change these if necessary

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 Voxel_Matrix_Prep.sh  SPMFaces   ROIname
#                                                                 data name   name of mask ROI
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

DATANAME=$1
ROI=$2 #this is the name of the ROI mask to apply, located under Analysis/ROI/Masks

SUBJECTS="040526133543 040527122743 040527142438 040602120431 040618113241 040622101350 040622114122 040624091727 040624110344 040628105838 040701113756 040706095946 040708090413 040716100908 040719095232 040722115006 040727095810 040727113755 040729103048 040802134001 040803095958 040805104736 040806101010 040824101541 040824120143 040831102621 040914102622 040914114855 040923101406 040928102206 040930121349 041004102307 041006101326 041008131029 041011103017 041025102403 041027101530 041201103916 041206102557 041208101154 041213173431 041215103009 041220102525 041222101121 050110102116 050111093620 050202150100 050204155746 050207145729 050209150934 050214155903 050216151319 050218151856 050221152458 050223151609 050225152312 050302151219 050307100503 050316095809 050318143714 050321100358 050323100835 050328100510 050401102550 050411102046 050418095325 050420095947 050422100036 050711095229 050718093843 050720095721 050722095305 050725095601 050727095852 050801095347 050803095628 050805094415 050810100247 050812095032 050826095906 050829100253 050831095755 050909095227 050914095007 050916094210 050921100457 050928095743 051003092457 051007094359 051010095134 051019092455 051024095141 051026094437 051104093739 051109092822 051111091053 051121092342 051123093015 051128091950 051205091232 051207091418 051216091830 051219092124 051221092121 060104093633 060109091820 060113090528 060118092853"

SUBJDIR=$EXPERIMENT/Data/$DATANAME/SPM2Processed
ROIMASK=$EXPERIMENT/Analysis/ROI/Masks/Amygdala/$ROI.nii
SPM_MASK=$EXPERIMENT/Analysis/ROI/Masks/Standard/SPM_brain_mask_smaller.nii
  
for SUBJ in $SUBJECTS; do

cd $SUBJDIR/$SUBJ/Faces

SUBMASK=$EXPERIMENT/Data/$DATANAME/SPM5Processed/$SUBJ/mask.img
COMMANDLINE="faces_4D_swrf swrf*.img"

fslmerge -t $COMMANDLINE
# create the 4D image from the 195 3D images

fslmaths faces_4D_swrf.* -mas $SUBMASK faces_4D_swrf_submasked
# apply the subject mask to the 4D image to clean it up, create faces_4D_swrf_submasked

fslmaths faces_4D_swrf_submasked.* -mas $SPM_MASK faces_4D_swrf_stanmasked
# apply the standard space mask to the subject mask, create faces_4D_swrf_stanmasked

fslmaths faces_4D_swrf_stanmasked.* -mas $ROIMASK faces_4D_swrf_ROI
# apply the ROI mask, create faces_4D_swrf_ROI

BETVALUE=0.225
#INFILE=$SUBJDIR/faces_4D_swrf_masked.nii
#OUTPRE=$SUBJDIR/faces_4D_swrf_masked_noeyes
bet faces_4D_swrf_submasked.nii faces_4D_swrf_submasked_noeyes -f $BETVALUE
# brain extraction on the nifti to remove the eyeballs

fslchfiletype NIFTI faces_4D_swrf_stanmasked.nii.gz
fslchfiletype NIFTI faces_4D_swrf_ROI.nii.gz
fslchfiletype NIFTI faces_4D_swrf_submasked_noeyes.nii.gz
# uncompress the niftis so they work in matlab with SPM
  
done
 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Data/SPMFaces}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
