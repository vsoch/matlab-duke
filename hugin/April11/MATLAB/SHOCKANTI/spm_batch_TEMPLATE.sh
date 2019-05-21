#!/bin/sh

# --------------SPM BATCH TEMPLATE ---------------- 
# This script takes anatomical and functional data located under
# Data/fund and Data/anat and performs all preprocessing
# by creating and utilizing two matlab scripts, and running spm
# After this script is run, output should be visually checked
# ----------------------------------------------------

# Return Codes 
#     Successful completion: return 0
#     If you need to set another return code, set the RETURNCODE
#     variable in this section. To avoid conflict with system return 
#     codes, set a RETURNCODE higher than 100.
#     eg: RETURNCODE=110

# Change Log
# 12/15/2010: Added automatic generation of reg check .ps files
# 12/20/2010: Added Results report for Faces and Cards to 2nd .m, and conversion/relocation of .ps
# 2/09/2011:  Modified script to convert functional data as HEAD/BRIK for ShockAnti task

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
#  Variables and Path Preparation
# ------------------------------------------------------------------------------

# Initialize input variables (fed in via python script)
SUBJ=SUB_SUBNUM_SUB          # This is the full subject folder name under Data
RUN=SUB_RUNNUM_SUB           # This is a run number, if applicable
ANATFOLDER=SUB_ANATFOL_SUB   # This is the name of the anatomical folder
SHOCKFOLD=SUB_SHOCKFOLD_SUB  # This is the name of the shock functional folder
SHOCKRUN=SUB_SHOCKRUN_SUB    # yes runs, no skips processing shock task
JUSTFUNC=SUB_JUSTFUNC_SUB    # yes skips anatomical processing, to be used if you have manually
                             # set the origins of anatomical and need to re-run faces, cards, rest
PREONLY=SUB_PREONLY_SUB      # yes only prepares the images / folder for AC-PC realign
  
# Initialize path variables to pass on to matlab template script
FUNCDATA=$EXPERIMENT/Data/Func                          # This is the data directory
OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/$SUBJ         # This is the subject output directory top
ANALYZED=$EXPERIMENT/Analysis/SPM/Analyzed/$SUBJ        # This is the subject analyzed directory top
SCRIPTDIR=$EXPERIMENT/Scripts/SPM                       # This is the location of our MATLAB script templates
BIACROOT=/usr/local/packages/MATLAB/BIAC                # This is where matlab is installed on the custer

#Make the subject specific output directories
mkdir -p $OUTDIR
mkdir -p $ANALYZED
mkdir -p $OUTDIR/Scripts

if [ $JUSTFUNC == 'no' ]; then

# ------------------------------------------------------------------------------
#  Step 1: Copy and rename raw dicom images for anatomicals
# ------------------------------------------------------------------------------

# For this dataset, the anatomical prefix is I000*

# Go to single subject directory
cd $EXPERIMENT/Data/Anat/$SUBJ/

# Use regular expressions to match folder name in format #####_########
exam=`ls`
echo $exam
if [[ "$exam" =~ [0-9]{5}_[0-9]{8} ]]; then 
    cd $exam/anat 
    
        # Create anat output folders
        mkdir -p $OUTDIR/anat
        mkdir -p $OUTDIR/anat/raw
    
        countVar=1;
        #Prepare the anatomical images
        for file in I0*; do

            if (($countVar < 10)); then
	        cp $file $OUTDIR/anat/raw/V000$countVar.dcm
	    fi 

	    if (($countVar < 100)); then
                if (($countVar >= 10)); then
		    cp $file $OUTDIR/anat/raw/V00$countVar.dcm
	        fi 
            fi

            if (($countVar >= 100)); then
                cp $file $OUTDIR/anat/raw/V0$countVar.dcm
            fi

        let "countVar += 1";
        done
else
        echo "Anat data not found under " $ANATFOLDER". Exiting."
        exit 32
fi

##########################################################################
# ShockAnti AFNI file conversion to 3D nifti
##########################################################################

# Go to functional data folder and copy BRIK/HEAD file for subject
if [ $SHOCKRUN == 'yes' ]; then

    # Make shock functional directory
    mkdir -p $OUTDIR/shock

    BRIK=$FUNCDATA/$SUBJ"_ANT+orig.BRIK"
    HEAD=$FUNCDATA/$SUBJ"_ANT+orig.HEAD"
    if [ -e "$BRIK" ]; then
        cp $BRIK $OUTDIR/shock/
    else
        echo "Cannot find BRIK file " $BRIK ". Exiting."
	exit 32
    fi
    
    if [ -e "$HEAD" ]; then
        cp $HEAD $OUTDIR/shock/
    else
        echo "Cannot find HEAD file " $HEAD ". Exiting."
	exit 32
    fi
  
    # Go to the subject shock directory and convert BRIK/HEAD file combo to 3D nifti
    cd $OUTDIR/shock
    3dAFNItoNIFTI $SUBJ"_ANT+orig.HEAD"      # Use afni tool to convert to nii
    bxhabsorb $SUBJ"_ANT.nii" $SUBJ.bxh      # Fit with a bxh header
    bxh2analyze --niftihdr -s -b $SUBJ.bxh D       # Create nifti header (.img/.hdr) with prefix V*
    rm $SUBJ.bxh; rm $SUBJ"_ANT.nii"               # Clean up intermediate files
    rm $SUBJ"_ANT+orig.HEAD" $SUBJ"_ANT+orig.BRIK"


# Get rid of first four images
rm D0001* D0002* D0003* D0004*

# rename the remaining images 1 through 442
        
    #Prepare the anatomical images
    for ext in hdr img; do    
	countVar=1;
	for file in D0*.$ext; do

            if (($countVar < 10)); then
	        mv $file V000$countVar.$ext
	    fi 

	    if (($countVar < 100)); then
                if (($countVar >= 10)); then
		    mv $file V00$countVar.$ext
	        fi 
            fi

            if (($countVar >= 100)); then
                mv $file V0$countVar.$ext
            fi

        let "countVar += 1";
        done
    done

fi



# ------------------------------------------------------------------------------
#  Step 2: Image Format Conversions and Segmentation
# ------------------------------------------------------------------------------

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

# Loop through template script replacing keywords
for i in 'spm_anat.m'; do
sed -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
 -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
 -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' \
 -e 's@SUB_ONLYDOPRE_SUB@'$PREONLY'@g' \
 -e 's@SUB_RUNSHOCK_SUB@'$SHOCKRUN'@g' \
 -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
 -e 's@SUB_ANATFOLDER_SUB@'$ANATFOLDER'@g' <$i> $OUTDIR/spm_anat.m
done
 
    # Change to output directory and run matlab on input script
    cd $OUTDIR
    /usr/local/bin/matlab -nodisplay < spm_anat.m
    echo "Done running spm_anat.m in matlab\n"
fi

# ------------------------------------------------------------------------------
#  Step 3: Realign and Unwarp, Normalization, Smoothing
# ------------------------------------------------------------------------------

if [ $PREONLY == 'no' ]; then

cd $OUTDIR/anat

#Rename the sc1 image and header (it will be copied into functional
#directories in spm_batch2.m

anatfile=c1*.img
cp $anatfile $OUTDIR/anat/c1anat.img

anatfile=c1*.hdr
cp $anatfile $OUTDIR/anat/c1anat.hdr


# Now we want to perform the realign and unwarp steps with spm_func.m

# Change into directory where template exists, save subject specific script
cd $SCRIPTDIR

    # Loop through template script replacing keywords
    for i in 'spm_func.m'; do
    sed -e 's@SUB_MOUNT_SUB@'$EXPERIMENT'@g' \
    -e 's@SUB_RUNSHOCK_SUB@'$SHOCKRUN'@g' \
    -e 's@SUB_ONLYDOFUNC_SUB@'$JUSTFUNC'@g' \
    -e 's@SUB_BIACROOT_SUB@'$BIACROOT'@g' \
    -e 's@SUB_SCRIPTDIR_SUB@'$SCRIPTDIR'@g' \
    -e 's@SUB_SUBJECT_SUB@'$SUBJ'@g' <$i> $OUTDIR/spm_func.m
    done
 
# Change to output directory and run matlab on input script
cd $OUTDIR

# ------------------------------------------------------------------------------
#  Step 4: Preparing Virtual Display
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
/usr/local/bin/matlab -display :$RANDINT < spm_func.m

echo "Done running spm_func.m in matlab"

#If the lock was created, delete it
if [ -e "/tmp/.X11-unix/X${RANDINT}" ]
      then
      echo "lock file was created";
      echo "cleaning up my lock file";
      rm /tmp/.X${RANDINT}-lock;
      rm /tmp/.X11-unix/X${RANDINT};
      echo "lock file was deleted";
fi

# ------------------------------------------------------------------------------
#  Step 5: File Conversion and Cleanup
# ------------------------------------------------------------------------------
# If we have done second level analysis and checked reg, convert .ps file to PDF
cd $OUTDIR
NOW=$(date +"%Y%b%d")
PSFILE=spm_$NOW.ps
if [ -e "$PSFILE" ]; then
ps2pdf $PSFILE
fi

# Lastly, if it was created, move the .ps files for each task into Graphics/Data_Check/shock, and delete .ps
cd $ANALYZED/Shock
PSFILE=spm_$NOW
if [ -e "$PSFILE.ps" ]; then
ps2pdf $PSFILE.ps
cp $PSFILE.pdf $EXPERIMENT/Graphics/Data_Check/Shock/$SUBJ"_"$NOW".pdf"
rm $PSFILE.pdf
rm $PSFILE.ps
fi

cd $OUTDIR/anat
PSFILE=spm_$NOW
if [ -e "$PSFILE.ps" ]; then
ps2pdf $PSFILE.ps
cp $PSFILE.pdf $EXPERIMENT/Graphics/Data_Check/anat/$SUBJ"_"$NOW".pdf"
rm $PSFILE.pdf
rm $PSFILE.ps
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
