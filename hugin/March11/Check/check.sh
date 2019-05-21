#!/bin/sh

# -------- Check ---------

# This script can be used as an easy way to check if a file, or many files,
# exist for a large group of subjects. This script is not meant to be submit 
# to run on the cluster, but instead can be run manually on the command line,
# as it takes in user choices.

# --- LONG VARIABLE DEFINITIONS ---

# COMMAND TO LIST ls TEST/anat/*.img | grep -c .img
# VANESSA NEED TO DO:  find command to bring GUI to front of screen
# Need to decide where output file is going to go?
# Can the user run the script from anywhere?

# ------------------------------------------------------------------------------
#  1) Get user selection for Search Type, Output Name, and Top Directory
# ------------------------------------------------------------------------------

# Get the starting directory, where the user will put output
outputdir= pwd

echo ''
echo 'Check.sh'
echo 'This script will can check for the existence of files(s) for an experiment'
echo 'Have you mapped the experiment folder with lnexp NAME.01 [Y/N] then press [ENTER]?'
read mapped

case $mapped in
"N") 
    echo 'Please map the experiment and run the script again'
    exit
    ;;
"n") 
    echo 'Please map the experiment and run the script again'
    exit
    ;;
"Y")
    break
    ;;
"y")
    break
    ;;     
*)
    echo $mapped 'is not a valid choice'
    exit
    ;;
esac

# If the user has indicated that the experiment is mapped, then we continue
echo ''
echo 'Please select a search option:'
echo ''
echo '1) Count Files of Type/Name [1] then press [ENTER]'
echo '2) List Files of Type/Name [2] then press [ENTER]'
read searchopt

case $searchopt in
"1") 
    echo 'You have selected to Count Files.'
    ;;
"2")
    echo 'You have selected to List Files.'
    ;;
*) 
    echo 'That is not a valid choice, exiting.'
    exit
    ;;
esac

# Now we ask if the user wants an outut file, which will get saved to (WRITE SPOT HERE?)
echo ''
echo 'Would you like to create an output file for the results? [Y/N] then press [ENTER]'
read outputfile
case $outputfile in
"Y")
    echo 'You have selected to create an output file.'
    echo ''
    ;;
"y")    
    echo 'You have selected to create an output file.'
    echo ''
    ;;
"N")
    echo 'You have selected to NOT create an output file.'
    echo ''
    ;; 
"n")
    echo 'You have selected to NOT create an output file.'
    echo ''
    ;;
*) 
    echo 'That is not a valid choice, exiting.'
    exit
    ;;
esac


# if user selects yes for output file, get the desired name and place to save to:
if [ $outputfile == "Y" ] || [ $outputfile == "y" ]; then
echo ''
echo 'What would you like to call your output file? Type name then press [ENTER]'
echo 'Please note that this file will be located in the same directory that you are running the script from.'
read name
fi

# Get the expression or file that the user wants to look for
echo ''
echo 'Enter the name of the file or expression to find or count, then press [ENTER]'
echo 'Examples are: *.img   or   name.txt'
echo 'Separate multiple files or expressions with spaces'
read -a searchfile

# Use the file selector to select the top directory with subject folders
echo ''
echo 'Please use the file selector to select the top directory with subject
folders.'
echo 'AFTER SELECTING THE FILE, THERE WILL BE A DELAY.'
echo 'PLEASE WAIT FOR THE NEXT PROMPT'
directory=`kdialog --title="Select Top Directory with Subject Folders" --getexistingdirectory pwd`

# ------------------------------------------------------------------------------
#  2) Subject Folders and Subfolder Selection
# ------------------------------------------------------------------------------

# Ask the user if it is desired to search a specific subfolder, or all subfolders
echo 'Would you like to search subfolders? [Y/N] then press [ENTER]'
read searchdepth
case $searchdepth in
"Y")
    ;; 
"y")
    ;;
"N")
    ;; 
"n")
    ;;
*) 
    echo 'That is not a valid choice, exiting.'
    exit
    ;;
esac


# If we are searching subfolders, ask if we want all subfolders or a specific one
if [ $searchdepth == "y" ] || [ $searchdepth == "Y" ]; then
echo 'Please select a subfolder search option:'
echo ''
echo '1) Search a Specific Subfolder [1] then press [ENTER]'
echo '2) Search All Subfolders [2] then press [ENTER]'
read specificfolder

case $specificfolder in
"1");;
"2");;
*) 
    echo 'That is not a valid choice, exiting.'
    exit
esac

# Go to the top of the subject directory

if [ -e $directory ]; then
cd $directory
# Get the list of subject folders, which will be used to navigate into each directory
subjects=`ls --directory *`
echo ''
echo 'Subjects included are: ' $subjects

else 
echo $directory 'cannot be found.  Perhaps you forgot to mount the experiment? Exiting.'
fi


# ------------------------------------------------------------------------------
#  3) Subfolder(s) Selection
# ------------------------------------------------------------------------------

# If we are searching specific folders, take in a list from the user in the format: folder1 folder2 folder3
# Multiple levels can be represented by: folder1/sublevel 
if [ $specificfolder == 1 ]; then
echo 'Please enter subfolders name(s) to search, separated by spaces, then press [ENTER]'
echo 'Example: folder1 folder2 folder3/internalfolder/'
read -a searchlist

else
# If we are searching all subfolders, go into the first directory and get the list of folders
cd *
searchlist=`ls --directory *`
fi


# ------------------------------------------------------------------------------
#  4) Setup the output file, if applicable
# ------------------------------------------------------------------------------
if [ $outputfile == 1 ]; then

# Print date to top of file
echo 'File Checking and Counting Script' > $name.txt
echo 'Date: ' date > $outputdir/$name.txt
echo 'Directory with Subject Folders: ' $directory > $outputdir/$name.txt
echo 'Folders Searched in Each Subject Folder: '$searchlist > $outputdir/$name.txt
echo 'Subjects Included: '$subjects > $outputdir/$name.txt
echo '' > $outputdir/$name.txt

if [ $searchopt == 1 ]; then
echo 'Count    Subject    Folder    File_Name'
else
echo 'Subject    Folder    File_Name' 
fi
fi

# ------------------------------------------------------------------------------
#  SEARCH SUBDIRECTORIES
# ------------------------------------------------------------------------------
if [ $specificfolder == 1 ]; then
# For each subject, if the subfolder and specific folder exist, navigate in and look for expression
for sub in $subjects; do

if [ -e $sub ]; then
echo 'Currently looking in subject ' $sub 's folders'

for subfolder in $specificfolder
do

echo 'Checking ' $specificfolder
if [ -e $sub/$subfolder ]; then

# If the user selects to count files of type/name
if [ $searchopt == 1 ]; then

for file in $searchfile
do
echo 'Checking ' $searchfile '...'
# perform grep command looking for count
count= ls $sub/$subfolder/$file | grep -c $file
# Add the subject ID in front of the output
# print to output file, if specified
if [ $outputfile == 1 ]; then
echo $count ' ' $sub ' ' $subfolder ' ' $file ' ' > $name.txt
echo $count ' ' $sub ' ' $subfolder ' ' $file ' written to file.'
fi
done
fi

# If the user selects to list files of a type/name
if [ $searchopt == 2 ]; then
# perform grep command looking for type/name

for file in $searchfile
do
# perform grep command looking for count
filelist= ls $sub/$subfolder/$file | grep $file
# Add the subject ID in front of the output
# print to output file, if specified
if [ $outputfile == "1" ]; then
echo $filelist ' ' $sub ' ' $subfolder ' ' $file ' ' > $name.txt
fi
done
fi
done
fi

# ------------------------------------------------------------------------------
#  SEARCH WITHOUT SUBDIRECTORIES
# ------------------------------------------------------------------------------
# if we are NOT searching subfolders, we just look in each individual directory
else

subfolder= 'none'

for sub in $subjects 
do

if [ -e $sub ]; then
echo 'Current subject is ' $sub

# If the user selects to count files of type/name
if [ $searchopt == 1 ]; then

for file in $searchfile
do
echo 'Checking for ' $searchfile

# perform grep command looking for count
count= ls $sub/$file | grep -c $file
# Add the subject ID in front of the output
# print to output file, if specified
if [ $outputfile == 1 ]; then
echo $count ' ' $sub ' ' $subfolder ' ' $file ' ' > $name.txt
echo $count ' ' $sub ' ' $subfolder ' ' $file ' written to file'

fi
done
fi

# If the user selects to list files of a type/name
if [ $searchopt == "2" ]
# perform grep command looking for type/name

for file in $searchfile
do
echo 'Checking for ' $searchfile
# perform grep command looking for count
filelist= ls $sub/$file | grep $file
# Add the subject ID in front of the output
# print to output file, if specified
if [ $outputfile == "1" ]; then
echo $filelist ' ' $sub ' ' $subfolder ' ' $file ' ' > $name.txt
echo $filelist ' ' $sub ' ' $subfolder ' ' $file ' written to file'

fi
done
fi
done
fi
fi
