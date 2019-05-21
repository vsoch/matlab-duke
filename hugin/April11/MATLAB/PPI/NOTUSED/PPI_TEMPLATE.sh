#!/bin/sh

# --------------PPI TEMPLATE ----------------
#
# This script works with it's partner python, PPI.py, and a MATLAB script 
# DNS_PPI (in Scripts folder on Munin) to run PPI analysis.  It
# uses the PPI "button" in SPM to first extract a timeseries from
# either faces or cards based on a user specified roi.  It takes in a matrix
# that represents the task specific connectivity that the user is interested in.
# It then moves into a single subject analysis, and uses the extracted values 
# (under PPI.P, PPI.ppi, and PPI.Y) as regressors.  Additionally, it uses the
# ART motion outliers from the subject's original BOLD preprocessing for the
# task of interest as an additional regressor.  Output goes into the user 
# specified folder name under Analysis/SPM/Analyzed/(Subject)
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

# -- BEGIN USER SCRIPT --
# User script goes here


# ------------------------------------------------------------------------------
#
#  Step 1: Variables and Path Preparation
#
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ="SUB_SUBNUM_SUB"                # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB                   # This is a run number, if applicable
OUTPUTFOL="SUB_OUTPUTFOL_SUB"        # This is the user specified name for the output folder under Analyzed/Subject
MATRIX="SUB_MAT_SUB"                 # this is the order number that specifies the matrices to be used:
                                     # [condition#1  1  weight;  condition#2  1  weight] etc.  
ATASK="SUB_ATASK_SUB"                # this is the task that the user is running - since the matrix is specific to the 
                                     # task, we can only run 1 at a time
VOIMASKTYPE="SUB_VMASKTYPE_SUB"      # the type of VOI mask to make (cube,sphere,mask)
VOINAME="SUB_NAMEOFVOI_SUB"          # name that we want our resulting VOI to have
CONTRASTNO=SUB_CONNUM_SUB            # this is the number of the contrast from the single subject SPM.mat that we want
                                     # to use to extract values from
SCENTERX=SUB_CENTERSPHEREX_SUB       # center voxels of sphere for VOI [x y z]
SCENTERY=SUB_CENTERSPHEREY_SUB  
SCENTERZ=SUB_CENTERSPHEREZ_SUB  
SRADIUS=SUB_RADIUSSPHERE_SUB         # radius of sphere for VOI
BOXDIMX=SUB_DIMBOXX_SUB              # Dimensions of the box for the VOI [2 2 2]
BOXDIMY=SUB_DIMBOXY_SUB
BOXDIMZ=SUB_DIMBOXZ_SUB
BOXCENTERX=SUB_CENTERBOXX_SUB        # Center of the box for the VOI [-10 -10 -10]
BOXCENTERY=SUB_CENTERBOXY_SUB
BOXCENTERZ=SUB_CENTERBOXZ_SUB
THEVOIMASK="SUB_THEMASKVOI_SUB"        # This is the name of a mask to use to make the VOI 
                                       # Mask name must include the extension!
VOIMASKTHRESH=SUB_MASKVOITHRESH_SUB    # The threshold to use for the VOI mask, should be 1?
CONTRAST="SUB_CONNAME_SUB"             # This is the name of the contrast we are interested in (Faces_gr_Shapes)
THRESHDESC="SUB_DESCOFTHRESH_SUB"      # This is either "FWE" or "none"
THRESHOLD=SUB_THRESH_SUB               # This is the threshold to use to create the individual VOI
EXTENT=SUB_VOXEXT_SUB                  # The extent threshold (0)
ADJUSTDATA=SUB_DATAADJUST_SUB          # Index of the F Contrast
SESSION=SUB_NUMSESS_SUB                # Choice of the session number - should be 1?
MASKOTHER="SUB_OTHERMASK_SUB"          # If the user wants to mask with another contrast (yes/no)
MASKOTHERCON="SUB_OTHERMASKCON_SUB"    # If yes, we need the contrast#, threshold, and inclusive
          
SUBINCLUDED="SUB_SUBINCLUDED_SUB"        # This is the number of subjects folder underROI/PPI/Task (125s)
MASKOTHERTHRESH=SUB_OTHERMASKTHRESH_SUB
MASKOTHERINCLUSIVE="SUB_OTHERMASKINCLUSIVE_SUB"

# Here we check the order number, and exit with error if it isn't 1,2,3, or 4.
if [ $MATRIX != "1" ] && [ $MATRIX != "2" ] && [ $MATRIX != "3" ] && [ $MATRIX != "4" ]
then
   echo $MATRIX " is not a valid order number, exiting."
   exit 32;
fi

# Here we figure out which task to set yes to based on the user specification
# Currently, the matlab script is only configured to run faces, but other
# tasks will be added as needed!.
case $ATASK in
    'faces')      echo 'Task selected for PPI analysis is faces.'
    FACESRUN='yes'    # yes runs, no skips processing faces task
    CARDSRUN='no'     # yes runs, no skips processing cards task
    RESTRUN='no'      # yes runs, no skips processing rest task
    ;;

    'cards')    echo 'Task selected for PPI analysis is cards'
    FACESRUN='no'    # yes runs, no skips processing faces task
    CARDSRUN='yes'   # yes runs, no skips processing cards task
    RESTRUN='no'     # yes runs, no skips processing rest task
    ;;
    
    'rest')  echo 'Task selected for PPI analysis is rest.'
    FACESRUN='no'    # yes runs, no skips processing faces task
    CARDSRUN='no'    # yes runs, no skips processing cards task
    RESTRUN='yes'    # yes runs, no skips processing rest task
    ;;
    *)      echo "$ATASK is not a valid task name."
    echo "...must be faces, cards, or rest.";;
esac

#Make the subject's VOI folder and Contrast folder
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/VOIs/$CONTRAST
#Make the subject specific output directory
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$CONTRAST
mkdir -p $EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$CONTRAST/$OUTPUTFOL
  
# Initialize other variables to pass on to matlab template script
OUTDIR=$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ/PPI/$CONTRAST/$OUTPUTFOL       # This is the output directory
SCRIPTDIR=$EXPERIMENT/Scripts/                                  # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC                        # This is where matlab is installed on the custer

# ------------------------------------------------------------------------------
#
#  Step 2: Creation and run of DNS_PPI subject script
#
# ------------------------------------------------------------------------------


cd $SCRIPTDIR/MATLAB/PPI

# Loop through template script replacing keywords
for i in 'DNS_PPI.m'; do
sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_RUNFACES_SUB@'$FACESRUN'@g' \
 -e 's@SUB_RUNCARDS_SUB@'$CARDSRUN'@g' \
 -e 's@SUB_RUNREST_SUB@'$RESTRUN'@g' \
 -e 's@SUB_OUTPUT_SUB@'$OUTPUTFOL'@g' \
 -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_CONTRASTNO_SUB@'$CONTRASTNO'@g' \
 -e 's@SUB_TASK_SUB@'$ATASK'@g' \
 -e 's@SUB_MATRIX_SUB@'$MATRIX'@g' \
 -e 's@SUB_VOINAME_SUB@'$VOINAME'@g' \
 -e 's@SUB_EXTENT_SUB@'$EXTENT'@g' \
 -e 's@SUB_CONTRAST_SUB@'$CONTRAST'@g' \
 -e 's@SUB_THETHRESHOLD_SUB@'$THRESHOLD'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_ADJUSTDATA_SUB@'$ADJUSTDATA'@g' \
 -e 's@SUB_SESSION_SUB@'$SESSION'@g' \
 -e 's@SUB_THRESHDESC_SUB@'$THRESHDESC'@g' \
 -e 's@SUB_MASKOTHER_SUB@'$MASKOTHER'@g' \
 -e 's@SUB_MASKOTHERCON_SUB@'$MASKOTHERCON'@g' \
 -e 's@SUB_INCLUDEDSUB_SUB@'$SUBINCLUDED'@g' \
 -e 's@SUB_MASKOTHERTHRESH_SUB@'$MASKOTHERTHRESH'@g' \
 -e 's@SUB_MASKOTHERINCLUSIVE_SUB@'$MASKOTHERINCLUSIVE'@g' \
 -e 's@SUB_VOIMASK_SUB@'$THEVOIMASK'@g' \
 -e 's@SUB_SPHERERADIUS_SUB@'$SRADIUS'@g' \
 -e 's@SUB_SPHERECENTERX_SUB@'$SCENTERX'@g' \
 -e 's@SUB_SPHERECENTERY_SUB@'$SCENTERY'@g' \
 -e 's@SUB_SPHERECENTERZ_SUB@'$SCENTERZ'@g' \
 -e 's@SUB_BOXCENTERX_SUB@'$BOXCENTER'@g' \
 -e 's@SUB_BOXCENTERY_SUB@'$BOXCENTER'@g' \
 -e 's@SUB_BOXCENTERZ_SUB@'$BOXCENTER'@g' \
 -e 's@SUB_VOIMASKTHRESH_SUB@'$VOIMASKTHRESH'@g' \
 -e 's@SUB_VOIMASKTYPE_SUB@'$VOIMASKTYPE'@g' \
 -e 's@SUB_BOXDIM_SUB@'$BOXDIMX'@g' \
 -e 's@SUB_BOXDIM_SUB@'$BOXDIMY'@g' \
 -e 's@SUB_BOXDIM_SUB@'$BOXDIMZ'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/DNS_PPI_${RUN}.m
 done
 
 
# Change to output directory and run matlab on input script
cd $OUTDIR

# ------------------------------------------------------------------------------
#
#  Step 3: Preparing Virtual Display
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
      RANDINT=$[( $RANDOM % ($[500 - 100] + 1)) + 100 ]
      echo "the random integer for Xvfb is ${RANDINT}";
done

#Initialize Xvfb, put buffer output in TEMP directory
Xvfb :$RANDINT -fbdir $TMPDIR &
/usr/local/bin/matlab -display :$RANDINT < DNS_PPI_${RUN}.m;

echo "Done running DNS_PPI.m in matlab"

If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi
fi

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Processed/$SUBJ}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
