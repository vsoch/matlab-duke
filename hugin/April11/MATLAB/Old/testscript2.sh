#!/bin/sh

# --------------SPM BATCH TEMPLATE ----------------
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
#$ -M vsochat@gmail.com

# -- END USER DIRECTIVE --

# -- BEGIN USER SCRIPT --
# User script goes here


# ------------------------------------------------------------------------------
#
#  Step 2.1: Preparing Virtual Display
#
# ------------------------------------------------------------------------------

#Prepare folder to put graphical output while running on cluster

cd $EXPERIMENT/Analysis/SPM
mkdir -p Gui
GUI=$EXPERIMENT/Analysis/SPM/GUI

#First we choose an int at random from 100-500, which will be the location in
#memory to allocate the display
RANDINT=$(( 100+(`od -An -N2 -i /dev/random` )%(500-100+1) ));
echo "the random integer for Xvfb is ${RANDINT}\n";

#Now we need to see if this number is already being used for Xvfb on the node.  We can
#tell because when it is active, it will have a "lock file"

if [ -e "/tmp/.X${RANDINT}-lock" ]
then
      echo "lock file was already created for $RANDINT\n";
      echo "Trying a new number...\n";
      RANDINT=$(( 100+(`od -An -N2 -i /dev/random` )%(500-100+1) ));
      echo "the random integer for Xvfb is ${RANDINT}\n";
fi

#Initialize Xvfb, put buffer output in "GUI" directory
Xvfb :$RANDINT -fbdir $GUI &
/usr/local/matlab2009a/bin/matlab -display :$RANDINT

cd $EXPERIMENT/Analysis/SPM/Analyzed/cards_pfl/

load('SPM.mat');

for i=1:171
    if i<10
        SPM(1).xY.P(i,1:96)=(horzcat($EXPERIMENT'/Analysis/SPM/Processed/'$SUBJ'/cards/swuV000',num2str(i),'.img,1'));
    end
    if i>=10
        if i<100
            SPM(1).xY.P(i,1:96)=(horzcat($EXPERIMENT'/Analysis/SPM/Processed/'$SUBJ'/cards/swuV00',num2str(i),'.img,1'));
        end
    end
    if i>=100
        SPM(1).xY.P(i,1:96)=(horzcat($EXPERIMENT'/Analysis/SPM/Processed/'$SUBJ'/cards/swuV0',num2str(i),'.img,1'));
    end
end

save ('SPM_ART.mat','SPM');
art_batch(homeAnalyzed/SUB_SUBJECT_SUB/rest_pfl/SPM_ART.mat');

exit

echo "Done running spm_batch2.m in matlab\n"

#If the lock was created, delete it
if [ -e "/tmp/.X${RANDINT}-lock" ]
      then
      echo "lock file was created\n";
      echo "cleaning up my lock file\n";
      rm "/tmp/.X${RANDINT}-lock";
      rm "/tmp/.X11-unix/.X${RANDINT}";
      echo "lock file was deleted\n";
fi

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
