#!/bin/bash

# ------23andme_convert----------------------------------------------------
# This script reads in new, raw genetic text data files downloaded from
# from 23andme in the Data/Genetic folder and first converts them all to 
# .ped/.map files, and then creates a new master .ped/.map file 
# (with all subjects) appended with the date.
#
# ------DNS Workflow and Organization------------------------------------- 
#
# 1) Spenser manually downloads, unzips, and renames .txt file from 23andme.com
# 2)   puts into Data/Genetic folder
# 3) Individual output goes to Analysis/Genetic/Individual/DNSXXXX.ped/.map
# 4) Group output goes to Analysis/Genetic/Group/YYYY_MM_DD_dns.ped/.map
# 5) Text files used to create group merges go to Analysis/Genetic/Group/Merge_Lists

# -------Instructions for Submission
# 
# 1) Add lists of new subjects to variables below under either male or female
# 2) The other variables do not need to be changed!
# 3) Save and submit on command line:
#
# qsub -v EXPERIMENT=DNS.01 23andme_convert.sh
#
# Output goes to $EXPERIMENT/Analysis/Genetic/Logs

#############################################################
# VARIABLES
# Formatting for individual IDs under male and female 
# should be ( DNS0001 DNS0002 )  #(see spaces)
maleID=( DNS0060 DNS0113 DNS0242 DNS0259 )  
femID=( DNS0260 )   
uID=( )     # In the case of unidentified gender
fid=0       # Family ID
pid=0       # Paternal ID
mid=0	    # Maternal ID
pheno=0     # Phenotype
#############################################################


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
# Send notifications to the following address
#$ -M @vsoch

###################################################################
# SCRIPT START
###################################################################

# Add plink to path
export PATH=/usr/local/packages/plink-1.07/:$PATH

# Cycle through the list of males and females

# MALES 
for id in ${maleID[@]}; do 
    sex=1
    make_plink
done
   
# FEMALES
for id in ${femID[@]}; do 
    sex=2
    make_plink
done

# UNIDENTIFIED
for id in ${uID[@]}; do 
    sex=0
    make_plink
done

#-------------------------------------------------------------------
# make text file with all individual .ped/.maps and make merged file
#-------------------------------------------------------------------
# Format date variable
NOW=$(date +"%Y%b%d")

cd $EXPERIMENT/Analysis/Genetic/Individual/
for file in *.ped; do 
    name=${file%\.*}
    echo $name.ped $name.map >> $EXPERIMENT/Analysis/Genetic/Merge_Lists/$NOW"_dns.txt"
done

# Create new master .ped/.map file
plink --merge-list $EXPERIMENT/Analysis/Genetic/Merge_Lists/$NOW"_dns.txt" --out $EXPERIMENT/Analysis/Genetic/Group/$NOW"_dns" --recode

#-------------------------------------------------------------------
# make_plink
# gets called or each sex to make the .ped nd .map files
#-------------------------------------------------------------------
function make_plink() {

# Check to make sure input file exists
if [ -f "$EXPERIMENT/Data/Genetic/raw_text/$id.txt" ]; then
    # Go to individual output folder
    cd $EXPERIMENT/Analysis/Genetic/Individual/
    
    if [ ! -f "$EXPERIMENT/Analysis/Genetic/Individual/$id.ped" ]; then
	echo "Data " $id".txt found. Creating plink files."
    
    	# Create .tfam file
    	echo "$fid $id $pid $mid $sex $pheno" > $EXPERIMENT/Analysis/Genetic/Individual/$id.tfam
    
    	# Make sure we don't have windows characters / carriage returns
    	dos2unix $EXPERIMENT/Data/Genetic/raw_text/$id.txt
    
    	# Read only the data after the comment
    	sed '/^\#/d' $EXPERIMENT/Data/Genetic/raw_text/$id.txt > $id.nocomment
    
   	 # Print the tped file
    	awk '{ if (length($4)==1) print $2,$1,"0",$3,substr($4,1,1),substr($4,1,1); else
    	print $2,$1,"0",$3,substr($4,1,1),substr($4,2,1) }' $id.nocomment > $id.tped
    
    	# Print the csv file
    	awk '{ if (length($4)==1) print $2,",",$1,",","0",",",$3,",",substr($4,1,1),",",substr($4,1,1)","; else
    	print $2,",",$1,",","0",",",$3,",",substr($4,1,1),",",substr($4,2,1),"," }' $id.nocomment > $EXPERIMENT/Analysis/Genetic/csv/$id.csv
    
    	# Create Individual .ped/.map files
    	plink --tfile $id --out $id --recode --allele1234 --missing-genotype - --output-missing-genotype 0
    else
    	echo "Data " $id".ped already exists!  Skipping subject."
    fi
else
    echo "Cannot find " $id".txt.  Exiting!"
    exit 32
fi    
}

# -- END USER SCRIPT -- #
 
# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/Genetic/Logs}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
