#!/bin/sh

# --------------RAFFLE WINNERS----------------
# 
# This script takes in a list of subject IDs and picks 5 random winners
# for the DNS raffle.  Subjects are selected without replacement into
# the pool
#
# ----------------------------------------------------

# Log
# July 1, 2010 (1 winner - DNS0072 / 34) 
# October 1, 2010 (1 winner - DNS0205)
# January 1, 2010 (1 winner / 46 - DNS0117)

SUBJ=( DNS0091 DNS0005 DNS0010 DNS0132 DNS0102 DNS0094 DNS0077 DNS0096 DNS0098 DNS0110 DNS0097 DNS0116 DNS0106 DNS0107 DNS0008 DNS0072 DNS0003 DNS0205 DNS0042 DNS0015 DNS0085 DNS0099 DNS0105 DNS0127 DNS0009 DNS0126 DNS0027 DNS0044 DNS0035 DNS0022 DNS0028 DNS0128 DNS0117 DNS0142 DNS0155 DNS0144 DNS0057 DNS0152 DNS0063 DNS0047 DNS0171 DNS0156 DNS0164 DNS0073 DNS0145 DNS0060 DNS0072 DNS0173 DNS0168 );



# Count the number of participants
count=0;
for person in ${SUBJ[@]}
do
let "count += 1";
done

rnumber=0;
while [ $rnumber == 0 ]; do
# Generate a random number
rnumber=$((RANDOM%$count));
done

# Select the winner
winner=${SUBJ[$rnumber]}
echo 'The winner is '$winner




