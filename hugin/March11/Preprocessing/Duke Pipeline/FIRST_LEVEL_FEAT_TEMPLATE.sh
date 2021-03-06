#!/bin/sh

#----------first_level_FEAT_TEMPLATE.sh-----------
# This script runs level 1 feat via the python script first_level_FEAT.py.
# All of the variables are input there as opposed to on the command line, so to run
# you need to edit the python script, then submit with "python first_level_FEAT.py

# This script assumes the brain extraction (BET) to be in a folder called BET within the anatomical
# directory.  If this is not the case, you must change ANAT= in the script!
# The path to the template must be specified after the design directory, so if the 
# path is FACES/First_level/Design/4Block/design.fsf, you need to specify "4Block"
# The script assumes that the name of the design is design.fsf
 
#                                                                  
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
 
#-------------LONG VARIABLES------------------
# Variables filled in by the python script 

ANAT_FOLDER=SUB_ANATFOLDER_SUB   # this is the anatomical series folder name
FUNC_FOLDER=SUB_FUNCFOLDER_SUB   # this is the functional series folder name
VOLUME=SUB_VOLUME_SUB            # this is the volume to remove in the format "196" (three places
SUBJECT=SUB_SUBNUM_SUB           # this is the subject ID
BETVALUE=SUB_BETVALUE_SUB        # this is the bet value
ANAT_FILE=SUB_ANATFILE_SUB       # this is the name of the nifti to be used for the anatomical
DESIGN=SUB_DESIGN_SUB            # this is the design name / type (Block or Event)
ORDER=SUB_ORDER_SUB              # this is the design order, 1,2,3,4 for Faces, or 1 for Cards
RUN=SUB_RUNNAME_SUB              # this is the runname, usually run01
TASK=SUB_TASK_SUB                # this is the task name, either FACES or CARDS

ANAT_OUTDIR=$EXPERIMENT/Data/Anat/$SUBJECT/$ANAT_FOLDER
FUNC_OUTDIR=$EXPERIMENT/Data/Func/$SUBJECT/$FUNC_FOLDER

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
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/NEWFACES/First_level}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
