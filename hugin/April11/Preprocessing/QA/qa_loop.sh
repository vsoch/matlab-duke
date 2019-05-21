#!/bin/bash
# First input is exam number
 
#-------SUBMITTING ON COMMAND LINE--------------
# 
# qsub -v EXPERIMENT=FIGS.01 qa_loop.sh bxh_header 4 2

# You must change this script to include your subject folder names in the for loop!

 
INPUT=$1
FUNCFOLDER=$2
IMAGESTART=$3 

 
# Loop through the runs submitting a job to grid engine for each run
for i in 050810100247
do

SUBJ=$i
 
# Call qa_remove_images.sh
# Takes a bxh_header, starts running QA at image specified, and replaces old QA folder
# Four input arguments:  Functional FOlder, Image to start at 
qsub -v EXPERIMENT=FIGS.01 qa_remove_images.sh $INPUT $FUNCFOLDER $IMAGESTART $SUBJ
 
done
