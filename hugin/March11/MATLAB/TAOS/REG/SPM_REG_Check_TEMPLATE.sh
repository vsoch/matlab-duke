#!/bin/sh

# --------------SPM REG CHECK ----------------
# 
# This script takes the mask nii files from each single subject directory
# after an SPM analysis and prepares a reg_check.nii image that can be used 
# with any mask to check for signal loss for each subject.  The intensity 
# values in the reg_check.nii correspond with the subject in that particular
# order of the analysis.  The list of subjects used for the file can be
# found in the output text file.
#
# ----------------------------------------------------

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


# ------------------------------------------------------------------------------
#
#  Variables INPUT VARIABLES HERE
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=( 20100125_10274 20100125_10276 20100128_10293 20100129_10298 20100129_10299 )          # This is the full list of subjects we are reg
                             # checking.  The mask.img should be under Analysis/SPM/Analyzed/(Task)/
RUN="1"           # This is a run number, if applicable

# The variables below dictate which registrations are checked.  To check multiple at once, you MUST have
# equivalent subject IDs between the tasks!
FACESCHECK="yes"    # yes checks Faces coverage (we do just block since is same data as affect)
CARDSCHECK="yes"    # yes checks Cards coverage
RESTCHECK="yes"      # yes checks rest coverage

# ------------------------------------------------------------------------------
#
#  Variables Path Preparation
#
# ------------------------------------------------------------------------------

#Make the group specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check
  
# Initialize other variables to pass on to matlab template script
OUTDIR=$EXPERIMENT/Analysis/SPM/Second_Level         # This is the output directory top level

#===============================================================================
#
# Prepare Files for Registration Check for Faces
#
#===============================================================================

if [ $FACESCHECK == 'yes' ]; then

# Go to the output directory for Faces
cd $OUTDIR/Faces/Coverage_Check

# Set up faces text file log
echo 'Faces Check Reg Includes' >> Faces_$JOB_ID.txt

# Re-initialize count variable to 1
countVar=1;

# Cycle through each subject folder and copy the mask images over
for subject in ${SUBJ[@]}
do

# Return to the output directory with the log files
cd $OUTDIR/Faces/Coverage_Check

#Print subject ID and mask number ID to file
echo $countVar' '$subject >> Faces_$JOB_ID.txt
# need to add numbered list or line return?  check output and decide

#Copy mask image and rename to subject number
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/Faces/block/mask.img $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check/mask$countVar.img
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/Faces/block/mask.hdr $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check/mask$countVar.hdr

# Now navigate to where we copied the file to convert to nifti
cd $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check
bxhabsorb mask$countVar.img mask$countVar.bxh
bxh2analyze mask$countVar.bxh --nii -b -s mask$countVar

# Remove bxh file and original image and header, keep nifti
#rm mask$countVar.bxh
rm mask$countVar.img
rm mask$countVar.hdr

finalcountFaces=$countVar;
let "countVar +=1";

done

cd $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check
echo 'Total Faces Subjects '$finalcountFaces >> Faces_$JOB_ID.txt

fi

#===============================================================================
#
# Perform Registration Check for Faces
#
#===============================================================================

# First we prepare a list of all the mask niftis that we have
cd $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check

masklist="";

for m in mask*.nii
do

masklist=$masklist" "$m

done

echo "The list of masks is"$masklist

# Now we merge all these mask images into one subject mask:
fslmerge -t mask$masklist
fslmaths mask -mul $finalcountFaces -Tmean masksum -odt short
fslmaths masksum -thr $finalcountFaces -add masksum masksum

# -S means we sample every two slives, width is 750, output is the png
slicer masksum.nii.gz -S 2 750 masksum.png
fslmaths masksum -mul 0 uniquemask

# Now we add all the masks together to show the parts that aren't included in the group:
for (( i=1; i<=$finalcountFaces; i++ ))
do

fslmaths mask$i -mul -1 -add 1 -mul $i -add uniquemask uniquemask

done

thr=$finalcountFaces
let "thr -=1";
echo 'Thr variable is '$thr
fslmaths masksum -thr $thr -uthr $thr -bin -mul uniquemask uniquemask

# Lastly we go back and delete all the mask images, so the folder is empty if we do it again
cd $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check
rm mask*.nii
rm mask*.bxh 

#===============================================================================
#
# Prepare Files for Registration Check for Cards
#
#===============================================================================

if [ $CARDSCHECK == 'yes' ]; then

# Go to the output directory for Faces
cd $OUTDIR/Cards/Coverage_Check

# Set up faces text file log
echo 'Cards Check Reg Includes' >> Cards_$JOB_ID.txt

# Re-initialize count variable to 1
countVar=1;

# Cycle through each subject folder and copy the mask images over
for subject in ${SUBJ[@]}
do

# Return to the output directory with the log files
cd $OUTDIR/Cards/Coverage_Check

#Print subject ID and mask number ID to file
echo $countVar' '$subject >> Cards_$JOB_ID.txt
# need to add numbered list or line return?  check output and decide

#Copy mask image and rename to subject number
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/Cards/mask.img $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check/mask$countVar.img
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/Cards/mask.hdr $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check/mask$countVar.hdr

# Now navigate to where we copied the file to convert to nifti
cd $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check
bxhabsorb mask$countVar.img mask$countVar.bxh
bxh2analyze mask$countVar.bxh --nii -b -s mask$countVar

# Remove bxh file and original image and header, keep nifti
rm mask$countVar.img
rm mask$countVar.hdr

finalcountCards=$countVar;
let "countVar +=1";

done

cd $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check
echo 'Total Cards Subjects '$finalcountCards >> Cards_$JOB_ID.txt

fi

#===============================================================================
#
# Perform Registration Check for Cards
#
#===============================================================================

# First we prepare a list of all the mask niftis that we have
cd $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check

masklist="";

for m in mask*.nii
do

masklist=$masklist" "$m

done

echo "The list of masks is"$masklist

# Now we merge all these mask images into one subject mask:
fslmerge -t mask$masklist
fslmaths mask -mul $finalcountCards -Tmean masksum -odt short
fslmaths masksum -thr $finalcountCards -add masksum masksum

# -S means we sample every two slives, width is 750, output is the png
slicer masksum.nii.gz -S 2 750 masksum.png
fslmaths masksum -mul 0 uniquemask

# Now we add all the masks together to show the parts that aren't included in the group:
for (( i=1; i<=$finalcountCards; i++ ))
do

fslmaths mask$i -mul -1 -add 1 -mul $i -add uniquemask uniquemask

done

thr=$finalcountCards
let "thr -=1";
fslmaths masksum -thr $thr -uthr $thr -bin -mul uniquemask uniquemask

# Lastly we go back and delete all the mask images, so the folder is empty if we do it again
cd $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check
rm mask*.nii
rm mask*.bxh 

#===============================================================================
#
# Prepare Files for Registration Check for Rest
#
#===============================================================================

if [ $RESTCHECK == 'yes' ]; then

# Go to the output directory for Faces
cd $OUTDIR/Rest/Coverage_Check

# Set up faces text file log
echo 'Rest Check Reg Includes' >> Rest_$JOB_ID.txt

# Re-initialize count variable to 1
countVar=1;

# Cycle through each subject folder and copy the mask images over
for subject in ${SUBJ[@]}
do

# Return to the output directory with the log files
cd $OUTDIR/Rest/Coverage_Check

#Print subject ID and mask number ID to file
echo $countVar' '$subject >> Rest_$JOB_ID.txt
# need to add numbered list or line return?  check output and decide

#Copy mask image and rename to subject number
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/rest_pfl/mask.img $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check/mask$countVar.img
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/rest_pfl/mask.hdr $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check/mask$countVar.hdr

# Now navigate to where we copied the file to convert to nifti
cd $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check
bxhabsorb mask$countVar.img mask$countVar.bxh
bxh2analyze mask$countVar.bxh --nii -b -s mask$countVar

# Remove bxh file and original image and header, keep nifti
rm mask$countVar.img
rm mask$countVar.hdr

finalcountRest=$countVar;
let "countVar +=1";

done

cd $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check
echo 'Total Rest Subjects '$finalcountRest >> Rest_$JOB_ID.txt

fi

#===============================================================================
#
# Perform Registration Check for Rest
#
#===============================================================================

# First we prepare a list of all the mask niftis that we have
cd $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check

masklist="";

for m in mask*.nii
do

masklist=$masklist" "$m

done

echo "The list of masks is"$masklist

# Now we merge all these mask images into one subject mask:
fslmerge -t mask$masklist
fslmaths mask -mul $finalcountRest -Tmean masksum -odt short
fslmaths masksum -thr $finalcountRest -add masksum masksum

# -S means we sample every two slives, width is 750, output is the png
slicer masksum.nii.gz -S 2 750 masksum.png
fslmaths masksum -mul 0 uniquemask

# Now we add all the masks together to show the parts that aren't included in the group:
for (( i=1; i<=$finalcountRest; i++ ))
do

fslmaths mask$i -mul -1 -add 1 -mul $i -add uniquemask uniquemask

done

thr=$finalcountRest
let "thr -=1";
echo 'Thr variable is '$thr
fslmaths masksum -thr $thr -uthr $thr -bin -mul uniquemask uniquemask

# Lastly we go back and delete all the mask images, so the folder is empty if we do it again
cd $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check
rm mask*.nii
rm mask*.bxh 
 
# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Second_Level}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
