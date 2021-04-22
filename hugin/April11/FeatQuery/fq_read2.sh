#!/bin/sh

#-------------fqread.sh---------------------------------------
 
# This script takes the report.txt files produced from fq.sh and inputs them all into a
# simple excel file for further analysisc

# ---------WHEN DO I RUN THIS?------------
# In the pipeline, you should run this script after you have completed running fq.sh and want to
# compile your results in a single file for analysis

# --------WHAT DO I NEED TO CHANGE?------------
# the email to direct the successful run of the script
# You also need to change the variable "COPES" to specify which copes you 
# want to create cluster_masks for!

#------------SUBMISSION ON COMMAND LINE---------------

# [vvs4@head ~]$ qsub -v EXPERIMENT=Dummy.01 fq_read.sh   Faces   Amygdala   2     20
#                                                        Design  ROIname   COPE   Mask


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
# echo "----JOB [$JOB_NAME.$JOB_ID] START [`date`] on HOST [$HOSTNAME]----" 
# -- END PRE-USER --
# **********************************************************
 
# -- BEGIN USER DIRECTIVE --
# Send notifications to the following address
#$ -M @vsoch
 
# -- END USER DIRECTIVE --
 
# -- BEGIN USER SCRIPT --
# User script goes here
    
# SET OUR VARIABLES

DESIGN=$1 #this is the design under the ROI folder
ROINAME=$2
COPE=$3  #this is the cope you want to concatenate report.txt files for
MASK=$4  #this is the number of the mask

SUBJECTS="040526133543 040527122743 040527142438 040602120431 040618113241 040622101350 040622114122 040624091727 040624110344 040628105838 040701113756 040706095946 040708090413 040716100908 040719095232 040722115006 040727095810 040727113755 040729103048 040802134001 040803095958 040805104736 040806101010 040824101541 040824120143 040831102621 040914102622 040914114855 040923101406 040928102206 040930121349 041006101326 041008131029 041011103017 041025102403 041201103916 041206102557 041208101154 041213173431 041215103009 041222101121 050110102116 050111093620 050202150100 050207145729 050209150934 050214155903 050216151319 050218151856 050221152458 050223151609 050302151219 050307100503 050321100358 050323100835 050328100510 050401102550 050411102046 050418095325 050420095947 050422100036 050711095229 050718093843 050720095721 050722095305 050727095852 050801095347 050803095628 050805094415 050810100247 050812095032 050826095906 050831095755 050909095227 050914095007 050916094210 050921100457 050928095743 051003092457 051007094359 051010095134 051019092455 051024095141 051026094437 051109092822 051111091053 051121092342 051123093015 051128091950 051205091232 051207091418 051216091830 051219092124 051221092121 060104093633 060109091820 060113090528 060118092853"
          #insert subjects in ONE SET of quotes, with a space between each one
 
COPEDIR=$EXPERIMENT/Analysis/ROI/$DESIGN/$ROINAME

FILEPATHS=""

echo " - - - - - - - - vox(fMRI space) - mm(standard_space)"
echo "- stats_image #voxels min 10% mean median 90% max x y z x y z" 

for SUBJ in $SUBJECTS; do

echo $SUBJ
PATHTOADD=$COPEDIR/cope$COPE/Cluster_$MASK/$SUBJ/fq_$MASK/report.txt
cat $PATHTOADD

FILEPATHS=""

done

echo " "
echo "The following subjects were used in this analysis:"
echo "$SUBJECTS"

# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/ROI/$DESIGN/$ROINAME/cope$COPE}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
