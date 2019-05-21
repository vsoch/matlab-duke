#!/bin/sh

#----------simple_group_FEAT.sh-----------
# This script runs a higher level analysis for one run using a properly set up design file
# A properly set up design file includes all subject .feat folders put into the GUI (which
# we want to do to double check everything), the specification of COPES to use, and
# any covariates.
 
#----------SUBMISSION ON COMMAND LINE----------------

#>  [user@head ~]$ qsub -v EXPERIMENT=Dummy.01 simple_group_FEAT.sh  Faces      run01
#                                                                  design name  run name
  
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
 
#-------------LONG VARIABLES------------------
#ANATDIR is the name of the anatomical directory under DATA
#FUNCDIR is the name of the functional directory under DATA
#DESIGN is the folder that the .fsf file is in under first_level/Design/DesignName and also the EVs 
#under FEAT/EVs/DesignName
#so if the path to our file is EXPERIMENT/Analysis/FACES/First_level/4Block/design.fsf
#we would input 4Block/design.fsf
#SUBJ is the subject's folder name\
#RUN is the name of the run
 
#Need to input RUN NAME
DESIGN=$1
RUN=$2

#make directory to put the output Group FEAT
mkdir -p $EXPERIMENT/Analysis/FACES/GroupFEAT/$DESIGN/$RUN

#Set the directories
TEMPLATEDIR=$EXPERIMENT/Analysis/FACES/GroupFEAT/Design/$DESIGN
FEATDIR=$EXPERIMENT
# The FEATDir points to the experimental directory as it provides the path
# for each of the .feat folders in the .fsf file. 

OUTDIR=$EXPERIMENT/Analysis/FACES/GroupFEAT/$DESIGN/$RUN
OUTPUT=$EXPERIMENT/Analysis/FACES/GroupFEAT/$DESIGN/$RUN   
 
#Set some variables
cd $TEMPLATEDIR
 
#Makes the fsf file using the template
for i in 'design.fsf'; do
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@FEATDir@'$FEATDIR'@g' <$i> ${OUTDIR}/GFEAT_${RUN}.fsf
done
 
cd $OUTDIR
#Run feat analysis
feat ${OUTDIR}/GFEAT_${RUN}.fsf

#Run feat analysis using python script to submit
# python ${OUTDIR}run_job.py ${OUTDIR}/GFEAT_${RUN}.fsf 
 
 
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
