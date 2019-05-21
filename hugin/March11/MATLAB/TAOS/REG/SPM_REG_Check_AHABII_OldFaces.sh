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
#$ -M vsochat@gmail.com

# -- BEGIN USER SCRIPT --

# ------------------------------------------------------------------------------
#
#  Variables INPUT VARIABLES HERE
#  Please specify subject IDs, and tasks to run
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=( 30337_scandata 30407_scandata 30435_scandata 30487_scandata 30634_scandata 30966_scandata 31002_scandata 31592_scandata 31663_scandata 31668_scandata 31684_scandata 31754_scandata 31881_scandata 32080_scandata 32366_scandata 32473_scandata 32543_scandata 32719_scandata 32794_scandata 32802_scandata 32950_scandata 33004_scandata 33031_scandata 33047_scandata 33054_scandata 33218_scandata 33405_scandata 33597_scandata 33760_scandata 33881_scandata 34394_scandata 34506_scandata 34987_scandata 35106_scandata 35115_scandata 35577_scandata 35726_scandata 35822_scandata 35851_scandata 35864_scandata 36228_scandata 36240_scandata 36354_scandata 36514_scandata 36524_scandata 36729_scandata 36746_scandata 36767_scandata 36893_scandata 36900_scandata 36998_scandata 37027_scandata 37795_scandata 38058_scandata 38081_scandata 38677_scandata 38687_scandata 38694_scandata 38720_scandata 39277_scandata 39375_scandata 39399_scandata 40054_scandata 40409_scandata 40423_scandata 40571_scandata 40661_scandata 40822_scandata 40897_scandata 40948_scandata 41102_scandata 41246_scandata 41361_scandata 41673_scandata 41762_scandata 41940_scandata 42069_scandata 42086_scandata 42267_scandata 42470_scandata 42663_scandata 43039_scandata 43470_scandata 43767_scandata 43855_scandata 43959_scandata 44116_scandata 44179_scandata 44266_scandata 44448_scandata 44665_scandata 44755_scandata 44963_scandata 45370_scandata 45666_scandata 45900_scandata 46003_scandata 46042_scandata 46153_scandata 46181_scandata 46198_scandata 46246_scandata 46281_scandata 46492_scandata 46507_scandata 46531_scandata 46609_scandata 46822_scandata 46825_scandata 47019_scandata 47103_scandata 47169_scandata 47363_scandata 47402_scandata 47521_scandata 47658_scandata 47686_scandata 47700_scandata 47971_scandata 48143_scandata 48213_scandata 48337_scandata 48406_scandata 48508_scandata 49124_scandata 49131_scandata 49229_scandata 49310_scandata 49438_scandata 49458_scandata 49476_scandata 49544_scandata 49576_scandata 49992_scandata 50403_scandata 50567_scandata 50946_scandata 51091_scandata 51180_scandata 51227_scandata 51361_scandata 51377_scandata 51707_scandata 51726_scandata 51754_scandata 51862_scandata 51948_scandata 52117_scandata 52145_scandata 52212_scandata 52307_scandata 52327_scandata 52614_scandata 52655_scandata 52803_scandata 52897_scandata 53006_scandata 53065_scandata 53217_scandata 53782_scandata 54154_scandata 54233_scandata 54286_scandata 54581_scandata 54628_scandata 54642_scandata 54742_scandata 55064_scandata 55435_scandata 55674_scandata 55874_scandata 56153_scandata 56160_scandata 56216_scandata 56218_scandata 56250_scandata 56515_scandata 57037_scandata 57147_scandata 57221_scandata 57266_scandata 57447_scandata 57506_scandata 57536_scandata 57677_scandata 57994_scandata 58030_scandata 58056_scandata 58112_scandata 58322_scandata 58908_scandata 58920_scandata 59751_scandata 59946_scandata )          # This is the full list of subjects we are reg
                  # checking.  The mask.img should be under Analysis/SPM/Analyzed/(Task)/
RUN="1"           # This is a run number, if applicable
		      
# The variables below dictate which registrations are checked.  To check multiple at once, you MUST have
# equivalent subject IDs between the tasks!
FACESCHECK="no"    # yes checks Faces coverage (we do just block since is same data as affect)
OLDFACESCHECK="yes" # yes checks oldFaces coverage (block as well)
CARDSCHECK="no"    # yes checks Cards coverage
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

if [ $OLDFACESCHECK == 'yes' ]; then
tasks[$arraycount]=OldFaces
let "arraycount +=1";
fi

#Make the group specific output directories
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Faces/Coverage_Check/$mydate'_'$JOB_ID
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Cards/Coverage_Check/$mydate'_'$JOB_ID
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/Rest/Coverage_Check/$mydate'_'$JOB_ID
mkdir -p $EXPERIMENT/Analysis/SPM/Second_Level/OldFaces/Coverage_Check/$mydate'_'$JOB_ID
  
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
    Faces)    pathvar=Faces/block;;
    Cards)    pathvar=Cards;;
    Rest)     pathvar=rest_pfl;;
    OldFaces) pathvar=OldFaces/block;;
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
