#!/bin/bash
# First input is exam number

# ------FEAT_loop.sh-----------
#
# This script runs a loop of multiple FEAT analysis!
 
#-------SUBMITTING ON COMMAND LINE--------------
# 
# ./FEAT_loop.sh 3 4 4Block run01

# You must change this script to include your subject folder names in the for loop!

ANATFOLDER=$1
FUNCFOLDER=$2
DESIGN=$3
RUN=$4 

 
# Loop through the runs submitting a job to grid engine for each run
for i in 040526121358 040526133543 040527122743 040527142438 040602120431 040618113241 040622114122 040624091727 040624110344 040628105838 040701113756 040706095946 040708090413 040716100908 040722115006 040727095810 040727113755 040729103048 040802134001 040803095958 040805104736 040824101541 040824120143 040831102621 040914102622 040914114855 040923101406 040928102206 040930121349
do

SUBJ=$i
 
# Call first_level_FEAT.sh
# Takes an individual and runs first level FEAT analysis
# Four input arguments:  Functional Folder, anatomical folder, design, and run. 
qsub -v EXPERIMENT=FIGS.01 first_level_FEAT.sh $ANATFOLDER $FUNCFOLDER $DESIGN $RUN $SUBJ
 
done
