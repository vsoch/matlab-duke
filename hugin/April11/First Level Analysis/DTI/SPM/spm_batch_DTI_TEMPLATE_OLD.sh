#!/bin/sh

# --------------SPM BATCH DTI TEMPLATE ----------------
# 
# This script takes anatomical and functional data located under
# Data/fund and Data/anat and performs all preprocessing
# by creating and utilizing two matlab scripts, and running spm
# After this script is run, output should be visually checked
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
#$ -M SUB_USEREMAIL_SUB

# -- END USER DIRECTIVE --

# ------------------------------------------------------------------------------
#
#  Variables and Path Preparation
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=SUB_SUBNUM_SUB          # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB           # This is a run number, if applicable

TWODATASETS=SUB_TWODATASETS_SUB  # yes indicates that the group of subjects has 2 DTI runs

#Make the subject specific output directories
mkdir -p $EXPERIMENT/Analysis/DTI/SPM/$SUBJ
mkdir -p $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/FA
mkdir -p $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw  #here we put the raw DTI images


DTIFOLDER1=SUB_DTIFOLDER1_SUB      # This is the name of the first DTI folder (series008)
DTIFOLDER2=SUB_DTIFOLDER2_SUB      # This is the name of the second DTI folder (series009)

SUBPRE=$(echo $SUBJ | cut -c1-5)   # This is just the exam number, extracted from the full name

# Initialize other variables to pass on to matlab template script
OUTDIR=$EXPERIMENT/Analysis/DTI/SPM/$SUBJ         # This is the location of the subject's output directory
FAOUTPUT=$EXPERIMENT/Analysis/DTI/SPM/$SUBJ/FA    # This is the location of the FA output folder
FOLDERPATH1=$EXPERIMENT/Data/Anat/$DTIFOLDER1     # This is the full path of DTI folder 1
FOLDERPATH2=$EXPERIMENT/Data/Anat/$DTIFOLDER2     # This is the full path of DTI folder 2

# Cluster / BIAC variables
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                     # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC              # This is where matlab is installed on the cluster

# ------------------------------------------------------------------------------
#
#  Step 1: Image Renaming and Moving
#
# ------------------------------------------------------------------------------

##########################################################################
#
# DTI Folder One
#
##########################################################################

cd $EXPERIMENT/Data/Anat/$SUBJ

# Go to the subject DTI data directory to rename and move images
cd $DTIFOLDER1

countVar=1;

#Prepare the DTI images
for file in bia5*.*
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V1000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V100$countVar.dcm
fi
fi


if (($countVar < 1000)); then
if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V10$countVar.dcm
fi
fi

if ((countVar >= 1000)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V1$countVar.dcm
fi

let "countVar += 1";

done


##########################################################################
#
# DTI Folder Two
#
##########################################################################

if [ $TWODATASETS == 'yes' ]; then

cd $EXPERIMENT/Data/Anat/$SUBJ/$DTIFOLDER2

countVar=1;

for file in bia5*.*
do

if (($countVar < 10)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V2000$countVar.dcm
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V200$countVar.dcm
fi 
fi

if (($countVar < 1000)); then
if (($countVar >= 100)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V20$countVar.dcm
fi
fi

if ((countVar >= 1000)); then
cp $file $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/raw/V2$countVar.dcm
fi

let "countVar += 1";

done

fi

# ------------------------------------------------------------------------------
#
#  Step 2: Dicom Conversion to Output Folders
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_DTI_1.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_SUBPRE_SUB@'$SUBPRE'@g' \
 -e 's@SUB_TWORUNS_SUB@'$TWODATASETS'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' <$i> $OUTDIR/spm_DTI_1_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

/usr/local/matlab2009b/bin/matlab -nodisplay < spm_DTI_1_${RUN}.m

echo "Done running spm_DTI_1.m in matlab"


# ------------------------------------------------------------------------
#
# Step 3: Rename dicoms for processing
#
# ------------------------------------------------------------------------

cd $EXPERIMENT/Analysis/DTI/SPM/$SUBJ

#Rename the processed dicoms to a consistent format 

countVar=1;

#In the case of two datasets, the first DTI folder will be images 1-16, and the second 17-32
for imgfile in sdns01*.img
do

if (($countVar < 10)); then
cp $imgfile $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/V00$countVar.img
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $imgfile $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/V0$countVar.img
fi 
fi

let "countVar += 1";

done

countVar=1; 

for imgfile in sdns01*.hdr
do

if (($countVar < 10)); then
cp $imgfile $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/V00$countVar.hdr
fi 

if (($countVar < 100)); then
if (($countVar >= 10)); then
cp $imgfile $EXPERIMENT/Analysis/DTI/SPM/$SUBJ/V0$countVar.hdr
fi 
fi

let "countVar += 1";

done

# ------------------------------------------------------------------------------
#
#  Step 4: DTI Single Subject Processing
#
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_DTI_2.m'; do
sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_TWORUNS_SUB@'$TWODATASETS'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/spm_DTI_2_${RUN}.m
done
 
# Change to output directory and run matlab on input script
cd $OUTDIR
echo "Changed to output directory";

# ------------------------------------------------------------------------------
#
#  Step 5. Preparing Virtual Display
#
# ------------------------------------------------------------------------------

#First we choose an int at random from 100-500, which will be the location in
#memory to allocate the display
RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
echo "the random integer for Xvfb is ${RANDINT}";

#Now we need to see if this number is already being used for Xvfb on the node.  We can
#tell because when it is active, it will have a "lock file"

while [ -e "/tmp/.X11-unix/X${RANDINT}" ]
do
      echo "lock file was already created for $RANDINT";
      echo "Trying a new number...";
      RANDINT=$(( 100+(`od -An -N2 -i /dev/random` )%(500-100+1) ));
      echo "the random integer for Xvfb is ${RANDINT}";
done

#Initialize Xvfb, put buffer output in TEMP directory
Xvfb :$RANDINT -fbdir $TMPDIR &
/usr/local/matlab2009b/bin/matlab -display :$RANDINT < spm_DTI_2_${RUN}.m

echo "Done running spm_DTI_2.m in matlab";

# ------------------------------------------------------------------------------
#
#  Step 6. Cleanup!
#
# ------------------------------------------------------------------------------

#If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi

# once script is working perfectly, enable these to get rid of raw files
#cd $OUTDIR/raw
#rm V*.img
#rm V*.hdr

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/DTI/SPM/$SUBJ}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER--
