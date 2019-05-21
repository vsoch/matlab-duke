#!/bin/bash

# ------run_group1.sh-----------
#
# This script runs a loop of multiple FEAT analysis!
 
#-------SUBMITTING ON COMMAND LINE--------------
# 
# ./run_group1.sh
# only includes rest subjects

EXP_NAME=AHABII.01

# Loop through the subjects to delete old run data
for i in 30694_scandata 31014_scandata 37491_scandata 39751_scandata 45475_scandata 53797_scandata 45460_scandata 33016_scandata 34570_scandata 35661_scandata 35829_scandata 36789_scandata 37519_scandata 38718_scandata 39433_scandata 42917_scandata 43161_scandata 43379_scandata 44275_scandata 45634_scandata 47341_scandata 47600_scandata 48484_scandata 49342_scandata 49529_scandata 50127_scandata 52388_scandata 54895_scandata 54922_scandata 57063_scandata 57255_scandata 58513_scandata 30337_scandata 30407_scandata 30487_scandata 31002_scandata 31592_scandata 31663_scandata 32080_scandata 32473_scandata 33004_scandata 33881_scandata 34394_scandata 34506_scandata 34987_scandata 35106_scandata 35115_scandata 35577_scandata 35726_scandata 35822_scandata 35851_scandata35864_scandata 36228_scandata 36240_scandata 36354_scandata 36514_scandata 36524_scandata 36729_scandata 37027_scandata 38081_scandata 38687_scandata 39375_scandata 40054_scandata 40571_scandata 40661_scandata 41102_scandata 41361_scandata 42086_scandata 43039_scandata 43767_scandata 44266_scandata 44665_scandata 45666_scandata 46042_scandata 46153_scandata 46181_scandata 46198_scandata 46281_scandata 46822_scandata 47103_scandata 48143_scandata 48213_scandata 48337_scandata 49124_scandata 49229_scandata 49310_scandata 49438_scandata 49476_scandata 49992_scandata 50403_scandata 50946_scandata 51091_scandata 51377_scandata 51707_scandata 51726_scandata 51754_scandata 52117_scandata 52307_scandata 52327_scandata 52655_scandata 52803_scandata 52897_scandata 53065_scandata 53217_scandata 53782_scandata 54233_scandata 54628_scandata 57147_scandata 57221_scandata 57266_scandata 57506_scandata57536_scandata 57994_scandata 58056_scandata
do

SUBJ=$i
 
qsub -v EXPERIMENT=$EXP_NAME AHABII_rest_del.sh $SUBJ
 
done
