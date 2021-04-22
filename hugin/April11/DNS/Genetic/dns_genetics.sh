#!/bin/bash

# ------dns_genetics----------------------------------------------------
# This script reads in new, raw genetic text data files downloaded from
# from 23andme in the Data/Genetic folder and first converts them all to 
# .ped/.map files, and then creates a new master .ped/.map file 
# (with all subjects) appended with the date.
#
# ------DNS Workflow and Organization------------------------------------- 
#
# 1) Spenser manually downloads, unzips, and renames .txt file from 23andme.com
# 2)   puts into Data/Genetic/raw_data folder. Name MUST begin with DNS ID!
# 3) DO NOT MODIFY FILES
# 4) Individual output goes to Analysis/Genetic/Individual/DNSXXXX.ped/.map
# 5) Group output goes to Analysis/Genetic/Group/YYYY_MM_DD_dns.ped/.map
# 6) Text files used to create group merges go to Analysis/Genetic/Group/Merge_Lists

# -------Instructions for Submission
# 
# 1) Add lists of new subjects to variables below under either male or female
# 2) The other variables do not need to be changed!
# 3) Save and submit on command line:
#
# qsub -v EXPERIMENT=DNS.01 dns_genetics.sh
#
# Output goes to $EXPERIMENT/Analysis/Genetic/Logs

#############################################################
# VARIABLES
# Formatting for individual IDs under male and female 
# should be ( DNS0001 DNS0002 )  #(see spaces)
maleID=( DNS0060 DNS0113 DNS0242 DNS0259 DNS0042 DNS0188 DNS0252 DNS0253 DNS0283 DNS0281 DNS0106 DNS0111 DNS0211 DNS0057 DNS0034 DNS0163 DNS0180 DNS0234 DNS0223 DNS0059 DNS0254 )  
femID=( DNS0260 DNS0107 DNS0208 DNS0072	DNS0261	DNS0027	DNS0257	DNS0015	DNS0201	DNS0270	DNS0177	DNS0083	DNS0264	DNS0263	DNS0144	DNS0268	DNS0168	DNS0284	DNS0060	DNS0113	DNS0242 )   
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

#-------------------------------------------------------------------
# make_plink
# gets called or each sex to make the .ped and .map files
#-------------------------------------------------------------------
function make_plink() {
# Check to make sure input file exists
cd $EXPERIMENT/Data/Genetic/raw_data/
filename=$1*.txt
filename=`echo $filename`

if [ -f "$EXPERIMENT/Data/Genetic/raw_data/$filename" ]; then
    # Go to individual output folder
    cd $EXPERIMENT/Analysis/Genetic/Individual/
    
    if [ ! -f "$EXPERIMENT/Analysis/Genetic/Individual/$1.ped" ]; then
	echo "Data " $filename" found. Creating plink files."
        
	# Give variables other names so that it doesnt get confused with awk
	dnsid=$1;famid=$2;patid=$3;matid=$4;gendr=$5;ptype=$6
	
    	# Create .tfam file
    	echo "$famid $dnsid $patid $matid $gendr $ptype" > $EXPERIMENT/Analysis/Genetic/Individual/$dnsid.tfam
   
    	# Make sure we don't have windows characters / carriage returns
    	dos2unix $EXPERIMENT/Data/Genetic/raw_data/$filename
    
    	# Read only the data after the comment
    	sed '/^\#/d' $EXPERIMENT/Data/Genetic/raw_data/$filename > $dnsid.nocomment
    
   	 # Print the tped file
    	awk '{ if (length($4)==1) print $2,$1,"0",$3,substr($4,1,1),substr($4,1,1); else
    	print $2,$1,"0",$3,substr($4,1,1),substr($4,2,1) }' $dnsid.nocomment > $dnsid.tped
    
    	# Print the csv file
    	awk '{ if (length($4)==1) print $2,",",$1,",","0",",",$3,",",substr($4,1,1),",",substr($4,1,1)","; else
    	print $2,",",$1,",","0",",",$3,",",substr($4,1,1),",",substr($4,2,1),","}' $dnsid.nocomment > $EXPERIMENT/Analysis/Genetic/csv/$dnsid"_"$7.csv
    
    	# Create Individual .ped/.map files - excluding tri-allelic SNPs in exclude_snp.txt
    	plink --tfile $dnsid --exclude $EXPERIMENT/Analysis/Genetic/exclude_snp.txt --out $dnsid --recode --allele1234 --missing-genotype - --output-missing-genotype 0
    else
    	echo "Data " $dnsid".ped already exists!  Skipping subject."
    fi
else
    echo "Cannot find " $dnsid".txt.  Exiting!"
    exit 32
fi    
}

# Format date variable
NOW=$(date +"%Y%b%d")

# Make sure that exclude_snp text file exists, exit if it doesn't
if [ ! -f "$EXPERIMENT/Analysis/Genetic/exclude_snp.txt" ]; then
	echo "exclude_snp.txt not found under " $EXPERIMENT"/Analysis/Genetic."
	echo " -- this is a single column text list of tri-allelic SNPs to not include"
	echo " -- please make this file and run again."
	exit 32
fi

# Cycle through the list of males and females

# MALES 
for idm in ${maleID[@]}
do 
    make_plink $idm $fid $pid $mid 1 $pheno $NOW
done
   
# FEMALES
for idf in ${femID[@]} 
do 
    make_plink $idf $fid $pid $mid 2 $pheno $NOW
done

# UNIDENTIFIED
for idu in ${uID[@]}
do 
    make_plink $idu $fid $pid $mid 0 $pheno $NOW
done

#-------------------------------------------------------------------
# make text file with all individual .ped/.maps and make merged file
#-------------------------------------------------------------------
cd $EXPERIMENT/Analysis/Genetic/Individual/
for file in *.ped; do 
    name=${file%\.*}
    echo $name.ped $name.map >> $EXPERIMENT/Analysis/Genetic/Merge_Lists/$NOW"_dns.txt"
done

# Create new master .ped/.map file
plink --merge-list $EXPERIMENT/Analysis/Genetic/Merge_Lists/$NOW"_dns.txt" --out $EXPERIMENT/Analysis/Genetic/Group/$NOW"_dns" --recode

# Check for the MISSNP file, meaning that there was a strand error.
if [ -f "$EXPERIMENT/Analysis/Genetic/Group/"$NOW"_dns.missnp" ]; then

	# If there was a strand error (ERROR: Stopping due to mis-matching SNPs-- check +/- strand?) try re-running with --flip
	plink --merge-list $EXPERIMENT/Analysis/Genetic/Merge_Lists/$NOW"_dns.txt" --flip $EXPERIMENT/Analysis/Genetic/Group/$NOW"_dns.missnp" --out $EXPERIMENT/Analysis/Genetic/Group/$NOW"_dns_missnp" --recode
fi

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
