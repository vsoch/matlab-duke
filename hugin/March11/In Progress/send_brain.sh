#!/bin/sh

# --------------SPM REG CHECK ----------------
# 
# KDialog Test! 
#
# ----------------------------------------------------

# **********************************************************
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
#$ -M vsochat@gmail.com

# -- BEGIN USER SCRIPT --

# ------------------------------------------------------------------------------
#
#  Process Subject Brain Image
#
# ------------------------------------------------------------------------------

FOLDERS=`kdialog --title "New Subjects" --inputbox "Please enter a list of new subjects,\n Use full folder names
separated by spaces\n 201005_12345 201005_22345..."`

for subj in $FOLDERS


#input all new subject IDs with a prompt, and then loop through each one to send email
#First need to convert to nifti
#Get exam number from end of subject ID
#Then need to run slicer, save as exam number under Graphics / Brain Images



# ------------------------------------------------------------------------------
#
#  Send Email
#
# ------------------------------------------------------------------------------

SUBJECT="Laboratory of Neurogenetics - Brain Image"

for exam in $SUBJECTS

#first check if the brain image exists.  If it doesn't, send error message to user!  If it does, then
# we want to send a brain image.

# Email To ?
EMAIL=`kdialog --title "Email Exam #$exam" --inputbox "Please enter the subject email:"`

# Email text/message
EMAILMESSAGE="/tmp/brainemail.txt"
echo "Attached, please find an image of your brain.  This image is intended for personal use only."> $EMAILMESSAGE
echo "The image is NOT intended as and should NOT be used as a substitute for medical evaluation." >> $EMAILMESSAGE
echo "" >> $EMAILMESSAGE
echo "Best," >> $EMAILMESSAGE
echo "Haririlab" >> $EMAILMESSAGE

# send an email using /bin/mail
/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE




name=`kdialog --title "Input dialog" --inputbox "What name would you like to
use"` > info.txt
cat $name info.txt


password=`kdialog --title "Password Boxie-poo" --password "Please enter the secret password"` >
info.txt
cat $password info.txt

if [ $? = 0 ]; then
echo " you selected: OK"
else
echo " you selected: Cancel"
fi

kdialog --menu "Select a color:" a "Red" b Blue d "Purple"

kdialog --title "Woohoo Boxie-poo!" --msgbox "Password correct.\n How could it not be?"
kdialog --title "Hypocrite Boxie-poo" --sorry "Password NOT correct.\n I changed my mind. \n Sorry!"
kdialog --title "Error Boxie-poo" --error "ERROR: Francis has left the building!"

kdialog ${WINDOWID:+--attach $WINDOWID} --msgbox "I'm attached"

kdialog --title "Get me out of here!" --yesno "I'm getting bored. \
Do you want to \n stop this nonsense?"

kdialog --title "Review" --msgbox "Please verify your information!"
kdialog --textbox info.txt 440 220

# -- END USER SCRIPT -- #

# **********************************************************
# -- BEGIN POST-USER -- 
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----" 
OUTDIR=${OUTDIR:-$EXPERIMENT/Analysis/SPM/Second_Level}
mv $HOME/$JOB_NAME.$JOB_ID.out $OUTDIR/$JOB_NAME.$JOB_ID.out	 
RETURNCODE=${RETURNCODE:-0}
exit $RETURNCODE
fi
# -- END POST USER-- 
