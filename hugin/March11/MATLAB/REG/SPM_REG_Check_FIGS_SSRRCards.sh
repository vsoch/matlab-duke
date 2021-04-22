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
SUBJ=( 040708090413 060113090528 051205091232 051207091418 060109091820 051216091830 051219092124 051121092342 051019092455 051003092457 051109092822 060118092853 051123093015 050111093620 060104093633 051104093739 050718093843 050916094210 050805094415 051026094437 050914095007 050812095032 051010095134 051024095141 050909095227 050711095229 050722095305 050418095325 050801095347 050803095628 050720095721 050928095743 050831095755 050316095809 050727095852 050826095906 050420095947 040803095958 050422100036 050810100247 050321100358 050307100503 050328100510 050323100835 041222101121 041208101154 040824101541 050411102046 050110102116 040928102206 041025102403 041220102525 041206102557 040831102621 040914102622 041215103009 041201103916 0400805104736 040727113755 040701113756 040914114855 040824120143 040930121349 041008131029 050207145729 050202150100 050209150934 050302151219 050216151319 050223151609 050218151856 050221152458 050214155903 041213173431 )          # This is the full list of subjects we are reg
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
#mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check/$mydate'_'$JOB_ID
#mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/OldFaces/Coverage_Check/$mydate'_'$JOB_ID
  
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
    Faces)    pathvar=Faces;;
    Cards)    pathvar=Cards;;
    Rest)     pathvar=rest_pfl;;
    OldFaces) pathvar=OldFaces/block;;
    *)      echo "$task is not a valid faces task name.";;
esac


#Copy mask image and rename to subject number
cp $EXPERIMENT/Analysis/SPM/Processed/$subject/$pathvar/mask.img $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID/mask$countVar.img
cp $EXPERIMENT/Analysis/SPM/Processed/$subject/$pathvar/mask.hdr $EXPERIMENT/Analysis/SPM/Second_Level/$task/Coverage_Check/$mydate'_'$JOB_ID/mask$countVar.hdr

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

#Multiplying by -1 -add 1 reverses the mask, so the empty space has a value of 1, mask = 0
#Multiplying by the number gives the empty space that value
#-add puts them all together in an image called uniquemask
fslmaths mask$i -mul -1 -add 1 -mul $i -add uniquemask uniquemask

done

thr=$finalcount
let "thr -=1";
echo 'Thr variable is '$thr
fslmaths masksum -thr $thr -uthr $thr -bin -mul uniquemask uniquemaskfini

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
