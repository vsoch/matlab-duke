#!/bin/sh

# -------- Check Runs ---------

# This script can be used as an easy way to check if a file, or many files,
# exist for a large group of subjects. This script is not meant to be submit 
# to run on the cluster, but instead can be run manually on the command line,
# as it takes in user choices.
.
# --- LONG VARIABLE DEFINITIONS ---

# COMMAND TO LIST ls TEST/anat/*.img | grep -c .img
# VANESSA NEED TO DO:  find command to bring GUI to front of screen
# Need to decide where output file is going to go?
# Can the user run the script from anywhere?

# ------------------------------------------------------------------------------
#  1) Get user selection for Search Type, Output Name, and Top Directory
# ------------------------------------------------------------------------------

searchopt=`kdialog --menu "Select a search option:" 1 "Count Files of Type/Name" 2 "List Files of Type/Name"`
outputfile=`kdialog --menu "Output file for results?" 1 "Yes" 2 "No"`

# if user selects yes for output file, get the desired name and place to save to:
if [ $outputfile == "1" ]
name=`kdialog --title "Output Name" --inputbox "What would you like to call your output file"`
fi

# Get the expression or file that the user wants to look for
searchfile=`kdialog --title "Search File or Expression" --inputbox "Enter the name of the file or expression to find or
count (*.img or name.txt, for example).  Separate multiple files or expressions with spaces."`

# Use the file selector to select the top directory with subject folders
directory=`kdialog --title="Select Top Directory with Subject Folders" --getexistingdirectory pwd`

# ------------------------------------------------------------------------------
#  2) Subject Folders and Subfolder Selection
# ------------------------------------------------------------------------------

# Ask the user if it is desired to search a specific subfolder, or all subfolders
searchdepth=`kdialog --title "Search Depth" --yesno "Would you like to search subfolders?"`

# If we are searching subfolders, ask if we want all subfolders or a specific one
if [ searchdepth == "yes" ]
specificfolder=`kdialog --menu "Subfolders" 1 "Search a Specific Subfolder" 2 "Search All Subfolders"`

# Go to the top of the subject directory
cd $directory
# Get the list of subject folders, which will be used to navigate into each directory
subjects=`ls --directory *`


# ------------------------------------------------------------------------------
#  3) Subfolder(s) Selection
# ------------------------------------------------------------------------------

# If we are searching specific folders, take in a list from the user in the format: folder1 folder2 folder3
# Multiple levels can be represented by: folder1/sublevel 
if [ specificfolder == "1" ]
searchlist=`kdialog --title "Please enter subfolders name(s) to search, separated by spaces --inputbox`
else
# If we are searching all subfolders, go into the first directory and get the list of folders
cd *
searchlist=`ls --directory *`
fi


# ------------------------------------------------------------------------------
#  4) Setup the output file, if applicable
# ------------------------------------------------------------------------------
if [ $outputfile == "1" ]

# Where should this output directory be?  In the same place as script directory?
# Can I set up script to call from anywhere?

# Print date to top of file

# Print search option to file?

# Print search files to file 

# Print Subfolder Names to file

# Print list of subjects to file?

fi


# ------------------------------------------------------------------------------
#  SEARCH SUBDIRECTORIES
# ------------------------------------------------------------------------------
if [ specificfolder == "1" ]

# For each subject, if the subfolder and specific folder exist, navigate in and look for expression
for sub in $subjects; do

if [ -e "$sub" ]; then

for subfolder in $specificfolder

if [ -e "$sub/$subfolder" ]

# If the user selects to count files of type/name
if [ $searchopt == "1" ]

for file in $searchfile
# perform grep command looking for count
output= ls $sub/$subfolder/$file | grep -c $file
# Add the subject ID in front of the output
# print to output file, if specified
if [ $outputfile == "1" ]
echo $output $name.txt
fi

done

fi

# If the user selects to list files of a type/name
if [ $searchopt == "2" ]
# perform grep command looking for count

# print to output file, if specified
if [ $outputfile == "1" ]
cat $infohere $name.txt
fi

fi


# ------------------------------------------------------------------------------
#  SEARCH WITHOUT SUBDIRECTORIES
# ------------------------------------------------------------------------------
# if we are NOT searching subfolders, we just look in each individual directory
else

fi
fi

# This code adds a variable to the output file
cat $info $name.txt


# If the user selects to list files of a type/name
if [ $searchopt == "2" ]
# Use the file selector to select the top directory with subject folders

# Insert the folder or path within subject folders to search to:

# Insert the string that we want to search for

# Do the search, and if the user has selected to use an output file,
# add the results to this file with the subject ID

# This code adds a variable to the output file
cat $info $name.txt

fi

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
