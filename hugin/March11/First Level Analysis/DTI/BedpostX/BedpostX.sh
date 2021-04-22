dit#!/bin/sh

#-------------BedpostX---------------------------------------
 
# This script is intended to perform BedpostX on DTI data, after
# DTI.py has been run.  The script first sets up the required input 
# files, and then puts results in a folder called "BedpostX" within the DTI directory
# There must be a data_corrected.nii file under Subject/DTI_FOLDER/DTI, and a .bvec
# and .bval file under Subject/DTI_FOLDER
# Output goes under Analysis/FACES/DTI (do we want it here?)

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should first run the data through QA to eliminate any bad apples, 
# then convert functional and anatomicals to nifti, and then BET with McFlirt before FEAT
#

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# check if you want a different OUTDIR path (if not in folder 3, etc)
# the BET value

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 BedpostX.sh   10         0405174398
#                                                        DTIfolder      Subject
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

# BedpostX requires the following input files, located in the same input directory:
# 
# nodif_brain_mask.nii  ----- The brain mask created from the corrected data
# data.nii              ----- A 4D series of data volumes. This will include diffusion-weighted volumes and volume(s) with no diffusion weighting.
# bvals                 ----- A text file w/ list of gradient directions applied
#                             during diffusion weighted volumes - created in dicom-->nifti conversion

# bvecs                 ----- A text file containing a list of gradient directions applied during diffusion weighted volumes (also
#                             is created during dicom --> nifti conversion

# Here are our variables from command line:
DTI_FOLDER=$1 # This is the name of the DTI directory under Data/$SUBJECT
SUBJECT=$2

# Set locations of files needed for BedpostX
DTI_DIR=$EXPERIMENT/Data/$SUBJECT/$DTI_FOLDER
BVEC=$DTI_DIR/.bvec
BVAL=$DTI_DIR/.bval
DATA=$DTI_DIR/DTI/data_corrected*
MASK=$DTI_DIR/BET/nodif_brain_mask.*

# First we must create the input directory
cd $DTI_DIR           # Go to the DTI directory
mkdir -p $SUBJECT     # Make the BedpostX input directory

# Now we copy the files we need into that directory
cp $BVEC -t $DTI_DIR/$SUBJECT
cp $BVAL -t $DTI_DIR/$SUBJECT
cp $MASK -t $DTI_DIR/$SUBJECT

cd $DTI_DIR/DTI
cp $DATA -t $DTI_DIR/$SUBJECT 

# Now we rename these files to the correct names
cd $DTI_DIR/$SUBJECT
rm data_corrected.ecclog
mv .bvec bvecs
mv .bval bvals
DATA=$DTI_DIR/$SUBJECT/data_corrected.*

mv $DATA data.nii.gz

cd $DTI_DIR
# check that the input directory has all the correct files
bedpostx_datacheck $SUBJECT

# run bedpostX
bedpostx $SUBJECT -n "2" -w "1" -b "1000"
# -n is number of fibers, -w is weight, and -b is the burnin, or number of iterations before starting the sampling

# move BedpostX directory to proper location
mv $SUBJECT.bedpostX $EXPERIMENT/Analysis/DTI/BedpostX

 
# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Data/$SUBJECT/$DTI_DIR/$SUBJECT}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
