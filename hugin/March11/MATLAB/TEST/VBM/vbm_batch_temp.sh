#!/bin/sh

# --------------SPM VBM TEST TEMPLATE ----------------
#
# 
# ----------------------------------------------------

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


OUTDIR=$EXPERIMENT/Analysis/SPM/Processed/test/pre/anat/highres1/spgr/vbm8_batch_py
# Change to output directory and run matlab on input script
cd $OUTDIR

########################################################
# global parameters
########################################################
# $Id: cg_vbm8_batch.sh 333 2010-05-18 14:11:23Z gaser $

matlab=/usr/local/bin/matlab   # you can use other matlab versions by changing the matlab parameter
matlab_spm="/usr/local/packages/MATLAB/spm8"
writeonly=0
defaults_file=$EXPERIMENT/Scripts/vbm/cg_vbm8_defaults_spgr_no_dartel.m
run_VBM_DIR=$EXPERIMENT/Scripts/vbm
CPUINFO=/proc/cpuinfo
ARCH=`uname`
#NUMBER_OF_JOBS=1


########################################################
# run main
########################################################

main ()
{
  check_matlab
  get_no_of_cpus
  run_vbm
  post_user
}


########################################################
# get # of cpus
########################################################
# modified code from
# PPSS, the Parallel Processing Shell Script
# 
# Copyright (c) 2009, Louwrentius
# All rights reserved.

get_no_of_cpus () {

  if [ -z "$NUMBER_OF_JOBS" ];
  then
    if [ "$ARCH" == "Linux" ]
    then
      NUMBER_OF_JOBS=`grep ^processor $CPUINFO | wc -l`

    elif [ "$ARCH" == "Darwin" ]
    then
      NUMBER_OF_JOBS=`sysctl -a hw | grep -w logicalcpu | awk '{ print $2 }'`

    elif [ "$ARCH" == "FreeBSD" ]
    then
      NUMBER_OF_JOBS=`sysctl hw.ncpu | awk '{ print $2 }'`

    else
      NUMBER_OF_JOBS=`grep ^processor $CPUINFO | wc -l`

    fi
    echo "Found $NUMBER_OF_JOBS processors."

    if [ -z "$NUMBER_OF_JOBS" ]
    then
        echo "$FUNCNAME ERROR - number of CPUs not obtained. Use -p to define number of processes."
        exit 1
    fi
  fi
}

########################################################
# run vbm tool
########################################################

run_vbm ()
{
    
    cwd=$matlab_spm
    echo "cwd is " $cwd
    pwd=$PWD
    echo "pwd is " $pwd
    
    # we have to go into toolbox folder to find matlab files
    cd $cwd
    
    spm8=$cwd
    echo $spm8

    export MATLABPATH=$spm8
    echo $MATLABPATH

    ARRAY=( $OUTDIR/test_pre_highres1.img )
    SIZE_OF_ARRAY="${#ARRAY[@]}"
    echo "Size of array is " $SIZE_OF_ARRAY
    echo "ARRAY is " $ARRAY   
    BLOCK=$((10000* $SIZE_OF_ARRAY / $NUMBER_OF_JOBS ))
    
    # argument empty?
    if [ ! "${defaults_file}" == "" ]; then
        # check wether absolute or relative names were given
        if [ ! -f ${defaults_file} ];  then
            defaults_file=${pwd}/${defaults_file}
        fi
    
        # check whether defaults file exist
        if [ ! -f ${defaults_file} ];  then
            echo $defaults_file not found.
        fi
    fi

    # split files and prepare tmp-file with filenames
    TMP=/tmp/vbm8_$$
    i=0
    while [ "$i" -lt "$SIZE_OF_ARRAY" ]
    do
        count=$((10000* $i / $BLOCK ))
        
        # check wether absolute or relative names were given
        if [ ! -f ${ARRAY[$i]} ];  then
            FILE=${pwd}/${ARRAY[$i]}
	    echo "FILE one variable is " $FILE
	    echo ${ARRAY[$i]}
        else
            FILE=${ARRAY[$i]}
	    echo "FILE two variable is " $FILE
	    echo ${ARRAY[$i]}
        fi
        if [ -z "${ARG_LIST[$count]}" ]; then
            ARG_LIST[$count]="$FILE"
	    echo "ARG_LIST one is " ${ARG_LIST[$count]}
        else
            ARG_LIST[$count]="${ARG_LIST[$count]} $FILE"
	    echo "ARG_LIST two is " ${ARG_LIST[$count]}
        fi
        echo ${FILE} >> ${TMP}${count}
        ((i++))
    done
    time=`date "+%Y%b%d_%H%M"`
    vbmlog=${pwd}/vbm8_${time}
    
    i=0
    echo "Number of jobs is " $NUMBER_OF_JOBS
    while [ "$i" -lt "$NUMBER_OF_JOBS" ]
    do
    echo "ARG LIST is " ${ARG_LIST[$i]}
        if [ ! "${ARG_LIST[$i]}" == "" ]; then
            j=$(($i+1))
	    echo "j is " $j
            COMMAND1="cg_vbm8_batch('${TMP}${i}',${writeonly},'${defaults_file}')"
	    COMMAND2=$run_VBM_DIR"/run_VBM('$COMMAND1')"
	    echo "COMMAND1 is " $COMMAND1
	    echo "COMMAND2 is " $COMMAND2
            echo Calculate ${ARG_LIST[$i]}
            echo ---------------------------------- >> ${vbmlog}_${j}.log
            date >> ${vbmlog}_${j}.log
            echo ---------------------------------- >> ${vbmlog}_${j}.log
            echo >> ${vbmlog}_${j}.log
            echo $0 $file >> ${vbmlog}_${j}.log
            echo >> ${vbmlog}_${j}.log
            #echo ${matlab} -nodisplay -nojvm -nosplash -r $COMMAND >> ${vbmlog}_${j}.log 2>&1 &
	    #${matlab} -nodisplay -nojvm -nosplash -r $COMMAND >> ${vbmlog}_${j}.log 2>&1
	    ${matlab} -nodisplay -nojvm -nosplash -r $COMMAND2 >> ${vbmlog}_${j}.log 2>&1
            echo ${matlab} -nodisplay -nojvm -nosplash -r $COMMAND2 >> ${vbmlog}_${j}.log 2>&1
	    echo Check ${vbmlog}_${j}.log for logging information
            echo
        fi
        ((i++))
    done
}

########################################################
# check if matlab exist
########################################################

check_matlab ()
{
  found=`which ${matlab} 2>/dev/null`
  if [ ! -n "$found" ];then
    echo $matlab not found.
    exit 1
  fi
}

########################################################
# help
########################################################

help ()
{
cat <<__EOM__

INPUT:
   analyze or nifti files

OUTPUT:
   segmented images according to settings in cg_vbm8_defaults.m
   vbm8_log_$time.txt for log information

USED FUNCTIONS:
   cg_vbm8_batch.m
   VBM8 toolbox
   SPM8

SETTINGS
   matlab command: $matlab
   
This script was written by Christian Gaser (christian.gaser@uni-jena.de).
Modified by Vanessa Sochat for LoNG (vvs4@duke.edu)

__EOM__
}

########################################################
# post_user
########################################################

post_user() {
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----"
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
}

########################################################
# call main program
########################################################

main ${1+"$@"}

fi
