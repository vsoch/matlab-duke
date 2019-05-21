#!/bin/sh

# -------- PREPROCESSING TEMPLATE ---------

# This script is intended for converting raw dicom images into a 4D nifti file
# through use of the bxhtools and bxh header provided by BIAC
# This script is run with a python script, dicom2nifti.py

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
 
# -- BEGIN USER SCRIPT --
# User script goes here

# --- LONG VARIABLE DEFINITIONS ---

ANAT_FOLDER=SUB_ANATFOLDER_SUB   # this is the anatomical series folder name
FUNC_FOLDER=SUB_FUNCFOLDER_SUB   # this is the functional series folder name
OUTPRE=SUB_OUTPRE_SUB            # this is the name you want for the resulting nifti
VOLUME=SUB_VOLUME_SUB            # this is the volume to remove in the format "196" (three places
SUBJECT=SUB_SUBNUM_SUB           # this is the subject ID
BETVALUE=SUB_BETVALUE_SUB        # this is the bet value
ANATFILE=SUB_ANATFILE_SUB        # this is the name to give the BET anatomical
DESIGN=SUB_DESIGN_SUB            # this is the design name / type (Block or Event)
ORDER=SUB_ORDER_SUB              # this is the design order, 1,2,3,4 for Faces, or 1 for Cards
RUN=SUB_RUNNAME_SUB              # this is the runname, usually run01
TASK=SUB_TASK_SUB                # this is the task name, either FACES or CARDS

ANAT_OUTDIR=$EXPERIMENT/Data/Anat/$SUBJECT/$ANAT_FOLDER/
FUNC_OUTDIR=$EXPERIMENT/Data/Func/$SUBJECT/$FUNC_FOLDER/
 
# ------- LONG SCRIPT ------------------

# FIRST WE WILL PREPROCESS THE ANATOMICALS
# 1. Reorient from LPS to LAS
# 2. Convert from dicom to nifti
# 3. Perform brain extraction

cd $ANAT_OUTDIR
# here we navigate to the folder with the dicoms to run the command

bxhreorient --orientation=LAS $ANAT_FOLDER.bxh reoriented_LAS.bxh
# here we are changing the orientation from LPS to LAS, (TO Radiological) for use in FSL
                    
bxh2analyze --nii -b -s reoriented_LAS.bxh Anat_LAS
# -nii indicates that we want an uncompressed nifti
# -b suppresses the output of a second bxh file 
# -s suppressed the writing of a SPM .mat file for each imagee
# -Anat_LAS is the name of the anatomical to be used for BET

# BRAIN EXTRACTION ANATOMICALS
# First we make the BET directory in the anatomical directory
mkdir -p BET

# Now we print the command, in case we need to check it in the output
echo "bet Anat_LAS.nii BET/$ANATFILE -f $BETVALUE"
bet Anat_LAS.nii BET/$ANATFILE -f $BETVALUE

# NEXT WE WILL PREPROCESS THE FUNCTIONAL DATA
# 1. Create header file for images for SPM use
# 2. Re-orient from LPS to LAS
# 3. Create nifti, remove last image
# 4. Create final, correctly oriented nifti

cd $FUNC_OUTDIR
# here we navigate to the folder with the raw analyze files to run the commands

# Here we create the SPM header for Pittsburgh processing
# INSERT CODE HERE VANESSA! (when we figure out format off of scanner)

# First we delete the last nifti image volume
# the user specifies "0" if there is no volume to delete
VOLUME_REMOVE="vol0"$VOLUME".nii.gz"
rm $VOLUME_REMOVE.img
rm $VOLUME_REMOVE.hdr

# Now we fit the nifti images with a new bxh header
bxhabsorb VO*.img volume_removed_func.bxh 

# Now we reorient the newly created header
bxhreorient --orientation=LAS $FUNC_FOLDER.bxh reoriented_$FUNC_FOLDER.bxh
# here we reorient the data from LPS to LAS format for analysis within FSL

bxh2analyze --preferanalyzetypes --niigz reoriented_$FUNC_FOLDER.bxh reoriented_func
# here we create a 4D nifti from the reoriented data

#NOW WE WILL RUN THE FIRST LEVEL FEAT

#make directory to put the output FEAT
mkdir -p $EXPERIMENT/Analysis/$TASK/First_level/$DESIGN/$SUBJECT

#Set the directories
ANAT=$ANAT_OUTDIR/BET/$ANAT_FILE.nii
EVDIR=$EXPERIMENT/Analysis/$TASK/First_level/Design/$DESIGN/$ORDER
OUTDIR=$EXPERIMENT/Analysis/$TASK/First_level/$DESIGN/$SUBJECT
 
#Set some variables
OUTPUT=$OUTDIR/$RUN
DATA=$FUNC_OUTDIR/Func_LAS.nii.gz

# make the output directory and go to the template directory
mkdir -p $OUTDIR
cd $EVDIR

#Makes the fsf file using the template
for i in 'design.fsf'; do
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@ANAT@'$ANAT'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
-e 's@DATA@'$DATA'@g' <$i> ${OUTDIR}/FEAT_${RUN}.fsf
done
 
cd $OUTDIR
#Run feat analysis
feat ${OUTDIR}/FEAT_${RUN}.fsf

# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Data/Anat/$SUBJECT}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
