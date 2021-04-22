#!/bin/sh

# --------------SPM REG CHECK ----------------
# 
# This script takes the mask nii files from each single subject directory
# after an SPM analysis and prepares a uniquemask.nii image that can be used 
# with any mask to check for signal loss for each subject.  The intensity 
# values in the reg_check.nii correspond with the subject in that particular
# order of the analysis.  The list of subjects used for the file can be
# found in the output text file.
#
# ----------------------------------------------------

# **********************************************************
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

# Send notifications to the following address
#$ -M @vsoch

# -- BEGIN USER SCRIPT --

# ------------------------------------------------------------------------------
#
#  Variables INPUT VARIABLES HERE
#  Please specify subject IDs, and tasks to run
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=( 20100226_10405 20100125_10276 20100129_10300 20100128_10293 20100129_10299 20100125_10274 20100129_10298 20100219_10377 20100208_10327 20100212_10337 20100208_10325 20100211_10329 20100218_10369 20100215_10343 20100215_10342 20100215_10345 20100225_10391 20100219_10380 20100401_10619 20100409_10689 20100219_10376 20100301_10409 20100218_10367 20100218_10370 20100409_10688 20100301_10408 20100329_10593 20100226_10402 20100305_10445 20100225_10393 20100304_10434 20100226_10403 20100305_10444 20100225_10392 20100319_10541 20100305_10447 20100304_10433 20100305_10443 20100329_10595 20100415_10712 20100315_10505 20100322_10553 20100419_10740 20100325_10572 20100325_10573 20100318_10531 20100329_10594 20100325_10571 20100326_10584 20100426_10774 20100325_10569 20100401_10622 20100329_10592 20100325_10574 20100409_10691 20100416_10727 20100430_10808 20100405_10648 20100419_10737 20100415_10715 20100401_10617 20100329_10591 20100401_10618 20100402_10631 20100405_10646 20100409_10690 20100416_10725 20100416_10724 20100401_10621 20100219_10378 20100405_10650 20100503_10820 20100426_10772 20100429_10801 20100430_10810 20100426_10776 20100503_10822 20100430_10809 20100503_10819 20100429_10798 20100430_10811 20100319_10539 20100426_10773 )          # This is the full list of subjects we are reg
                             # checking.  The mask.img should be under Analysis/SPM/Analyzed/(Task)/
RUN="1"           # This is a run number, if applicable
		      
# The variables below dictate which registrations are checked.  To check multiple at once, you MUST have
# equivalent subject IDs between the tasks!
FACESCHECK="no"    # yes checks Faces coverage (we do just block since is same data as affect)
CARDSCHECK="yes"    # yes checks Cards coverage
RESTCHECK="no"     # yes checks rest coverage

# ------------------------------------------------------------------------------
#
#  Variables Path Preparation
#
# ------------------------------------------------------------------------------

mydate=$(date +"%B%d");

declare -a tasks
let arraycount=0;

if [ $FACESCHECK == 'yes' ]; then
tasks[$arraycount]=Faces
let "arraycount +=1";
fi

if [ $CARDSCHECK == 'yes' ]; then
tasks[$arraycount]=Cards
let "arraycount +=1";
fi

if [ $RESTCHECK == 'yes' ]; then
tasks[$arraycount]=Rest
let "arraycount +=1";
fi

#Make the group specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check/$mydate'_'$JOB_ID
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check/$mydate'_'$JOB_ID
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check/$mydate'_'$JOB_ID
  
# Initialize other variables to pass on to matlab template script
OUTDIR=$EXPERIMENT/Analysis/SPM/Second_Level         # This is the output directory top level

#===============================================================================
#
# Prepare Files for Registration Check
#
#===============================================================================

for task in ${tasks[@]}
do

# Go to the output directory for Faces
cd $OUTDIR/$task/Coverage_Check/$mydate'_'$JOB_ID

# Set up faces text file log
echo $task 'Check Reg Includes' >> $task'_'$JOB_ID.txt

# Re-initialize count variable to 1
countVar=1;

# Cycle through each subject folder and copy the mask images over
for subject in ${SUBJ[@]}
do

# Return to the output directory with the log files
cd $OUTDIR/$task/Coverage_Check/$mydate'_'$JOB_ID

#Print subject ID and mask number ID to file
echo $countVar' '$subject >>  $task'_'$JOB_ID.txt
# need to add numbered list or line return?  check output and decide

case $task in
    Faces)  pathvar=Faces/block;;
    Cards)  pathvar=Cards;;
    Rest)   pathvar=rest_pfl;;
    *)      echo "$task is not a valid faces task name.";;
esac


#Copy mask image and rename to subject number
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/$pathvar/mask.img $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID/mask$countVar.img
cp $EXPERIMENT/Analysis/SPM/Analyzed/$subject/$pathvar/mask.hdr $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID/mask$countVar.hdr

# Now navigate to where we copied the file to convert to nifti
cd $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID
bxhabsorb mask$countVar.img mask$countVar.bxh
bxh2analyze mask$countVar.bxh --nii -b -s mask$countVar

# Remove bxh file and original image and header, keep nifti
rm mask$countVar.img
rm mask$countVar.hdr

finalcount=$countVar;
let "countVar +=1";

done

cd $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID
echo 'Total ' $task ' Subjects '$finalcount >> $task'_'$JOB_ID.txt

#===============================================================================
#
# Perform Registration Check
#
#===============================================================================

# First we prepare a list of all the mask niftis that we have
cd $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID

masklist="";

for m in mask*.nii
do

masklist=$masklist" "$m

done

echo "The list of masks is"$masklist

# Now we merge all these mask images into one subject mask:
fslmerge -t mask$masklist
fslmaths mask -mul $finalcount -Tmean masksum -odt short
fslmaths masksum -thr $finalcount -add masksum masksum

# -S means we sample every two slives, width is 750, output is the png
slicer masksum.nii.gz -S 2 750 masksum.png
fslmaths masksum -mul 0 uniquemask

# Now we add all the masks together to show the parts that aren't included in the group:
for (( i=1; i<=$finalcount; i++ ))
do

fslmaths mask$i -mul -1 -add 1 -mul $i -add uniquemask uniquemask

done

thr=$finalcount
let "thr -=1";
echo 'Thr variable is '$thr
fslmaths masksum -thr $thr -uthr $thr -bin -mul uniquemask uniquemask

# Lastly we go back and delete all the mask images, so the folder is empty if we do it again
cd $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID
rm mask*.nii
rm mask*.bxh 

# Now we make a 3D nifti (.img and .hdr) with the output in case we want to view it in SPM
cd $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID
bxhabsorb uniquemask.nii.gz uniquemask.bxh
bxh2analyze uniquemask.bxh --niftihdr -b -s uniquemask
rm uniquemask.bxh

bxhabsorb masksum.nii.gz masksum.bxh
bxh2analyze masksum.bxh --niftihdr -b -s masksum
rm masksum.bxh 

done

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
