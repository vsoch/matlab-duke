%-----------------------------------------------------------------------
% SPM BATCH ADOLREG.01 - includes spm_batch1.m & spm_order#.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_TEMPLATE.sh from the head node of BIAC
%
%    The Laboratory of Neurogenetics, 2010
%       By Vanessa Sochat, Duke University
%-----------------------------------------------------------------------

% Add necessary paths
BIACroot = 'SUB_BIACROOT_SUB';

startm=fullfile(BIACroot,'startup.m');
if exist(startm,'file')
  run(startm);
else
  warning(sprintf(['Unable to locate central BIAC startup.m file\n  (%s).\n' ...
      '  Connect to network or set BIACMATLABROOT environment variable.\n'],startm));
end
clear startm BIACroot
addpath(genpath('SUB_SCRIPTDIR_SUB'));
addpath(genpath('/usr/local/packages/MATLAB/spm8'));
addpath(genpath('SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Data/Func/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB'));

%Here we set some directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';
scriptdir='SUB_MOUNT_SUB/Scripts/';
datadir='SUB_MOUNT_SUB/Data/';

%-----------------------------------------------------------------------
% DIRECTORY CREATION
% 
% This part of the script creates the proper directories under Analysis/
% SPM/Processed and Analysis/SPM/Analyzed for the single subject
%
%-----------------------------------------------------------------------

spm('defaults','fmri')
spm_jobman('initcfg');

%First we make the anatomical output directory, "anat" under
%Analysis/SPM/Processed.
cd 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/';
mkdir anat;

%Next we make our Analyzed Data directories, if they don't exist

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'));

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('Faces')==0
        mkdir Faces
    end
end

%'pfl' stands for 'pseudo first-level'.  These design matrices are without
%regard to any individual outliers volumes flagged by ART.  The primary
%reason for the creation of these 'pfl' folders is the SPM.mat file can be
%used to execute art_batch.  These are legitimate design matrices and can
%be used for analyses.

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('faces_pfl')==0
        mkdir faces_pfl
    end
end

%-----------------------------------------------------------------------
% FUNCTIONAL DATA COPY
% 
% We copy the raw data from Data/Func into Analysis/Processed/(Subject)/
% faces, since we don't want to touch our original data.  At the end of
% processing in spm_order#.m, we delete the copied data and preprocessed
% files to conserve space.
%
%-----------------------------------------------------------------------

%We check whether task subfolders exist in the Processed folder.
%If the folder exists, the functional data is copied into it.  If it does not,
%the folder is created, and then the data is copied.  If also checks to see
%if the functional data exists.  At the end of the run, the preprocessed
%images will be deleted to save space.

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

%If the user has specified running faces, we check faces
if strcmp('SUB_RUNFACES_SUB', 'yes')
    if isdir('faces')==0
        mkdir faces
        cd(horzcat(datadir,'Func/SUB_SUBJECT_SUB'))
        if isdir ('SUB_FACESFOLDER_SUB')==0
            sprintf('%s','Faces data for this subject does not exist.')
            return
        else
            copyfile(horzcat(datadir,'Func/SUB_SUBJECT_SUB/SUB_FACESFOLDER_SUB/*'),(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/')))
        end
    else
        cd(horzcat(datadir,'Func/SUB_SUBJECT_SUB'))
        if isdir ('SUB_FACESFOLDER_SUB')==0
            sprintf('%s','Faces data for this subject does not exist.')
            return
        else
            copyfile(horzcat(datadir,'Func/SUB_SUBJECT_SUB/SUB_FACESFOLDER_SUB/*'),(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/')))
        end
    end
end

%-----------------------------------------------------------------------
% DICOM TO NIFTI CONVERSIONS, ANATOMICAL DATA
% 
% We import the dicom images for the anatomical used for functional
% registration as well as for the high rest T1.  The scan folder names
% are specified by the user, however the anatomical is usually "series002"
% and the highres is "series005."  The script assumes the highres has 
% 162 images, and the anatomical 32. Output goes into Processed/anat.
%
%-----------------------------------------------------------------------

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

%Make sure that we are in the subjects raw anatomical data directory
foldertogoto=('SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB');
cd(foldertogoto);

% VANESSA - NEED TO PUT CORRECT FOLDER HERE FOR THE ADOLREG.01 STUDY
if strcmp('SUB_ANATFOLDER_SUB', 'series400')
matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00001.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00002.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00003.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00004.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00005.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00006.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00007.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00008.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00009.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00010.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00011.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00012.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00013.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00014.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00015.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00016.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00017.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00018.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00019.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00020.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00021.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00022.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00023.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00024.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00025.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00026.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00027.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00028.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00029.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00030.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00031.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00032.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00033.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_ANATFOLDER_SUB/SUB_DICOM_SUB_00034.dcm'
                                      };
end

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

%Now we are converting the T1 (mprage) from dicom to nifti

%Make sure that we are in the subject's top directory
foldertogoto=('SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/');
cd(foldertogoto);

%If the subject does not have a high-res 3D structural image, this step replaces
%the position within the SPM8 batch file normally occupied by the DICOM
%convert for the 3D structural with a second DICOM convert for the T1
%in-plane.  This is redudant, however, removing this component of the batch
%changes what number in the processing batch each step occupies (from n to
%n-1).  This would create errors downstream when the dependency function is
%instantiated.
if isdir('SUB_TFOLDER_SUB')==0
    matlabbatch{2}=matlabbatch{1};

else
    cd SUB_TFOLDER_SUB;
    
    if strcmp('SUB_TFOLDER_SUB', 'series300')
        matlabbatch{2}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00001.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00002.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00003.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00004.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00005.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00006.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00007.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00008.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00009.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00010.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00011.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00012.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00013.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00014.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00015.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00016.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00017.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00018.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00019.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00020.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00021.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00022.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00023.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00024.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00025.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00026.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00027.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00028.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00029.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00030.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00031.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00032.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00033.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00034.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00035.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00036.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00037.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00038.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00039.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00040.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00041.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00042.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00043.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00044.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00045.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00046.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00047.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00048.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00049.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00050.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00051.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00052.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00053.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00054.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00055.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00056.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00057.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00058.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00059.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00060.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00061.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00062.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00063.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00064.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00065.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00066.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00067.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00068.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00069.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00070.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00071.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00072.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00073.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00074.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00075.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00076.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00077.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00078.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00079.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00080.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00081.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00082.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00083.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00084.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00085.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00086.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00087.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00088.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00089.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00090.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00091.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00092.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00093.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00094.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00095.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00096.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00097.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00098.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00099.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00100.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00101.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00102.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00103.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00104.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00105.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00106.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00107.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00108.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00109.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00110.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00111.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00112.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00113.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00114.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00115.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00116.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00117.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00118.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00119.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00120.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00121.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00122.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00123.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00124.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00125.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00126.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00127.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00128.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00129.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00130.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00131.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00132.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00133.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00134.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00135.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00136.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00137.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00138.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00139.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00140.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00141.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00142.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00143.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00144.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00145.dcm'
                                      'SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB/SUB_TFOLDER_SUB/SUB_DICOMTWO_SUB_00146.dcm'
                                      };
    end

matlabbatch{2}.spm.util.dicom.root = 'flat';
matlabbatch{2}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
matlabbatch{2}.spm.util.dicom.convopts.format = 'img';
matlabbatch{2}.spm.util.dicom.convopts.icedims = 0;

end

% only segments the anatomical image if we aren't doing an ACPC realign
% (meaning we aren't running only preprocessing)  If we are doing an AC PC
% realign, the segmentation is done manually.

if strcmp('SUB_ONLYDOPRE_SUB','no')

%Now we segment the anatomical image
matlabbatch{3}.spm.spatial.preproc.data = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/sadolreg01-0400-00001-000001-01.img,1'};
matlabbatch{3}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{3}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{3}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{3}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{3}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{3}.spm.spatial.preproc.opts.tpm = {
                                               '/usr/local/packages/MATLAB/spm8/tpm/grey.nii'
                                               '/usr/local/packages/MATLAB/spm8/tpm/white.nii'
                                               '/usr/local/packages/MATLAB/spm8/tpm/csf.nii'
                                               };
matlabbatch{3}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{3}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{3}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{3}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{3}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{3}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{3}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{3}.spm.spatial.preproc.opts.msk = {''};

end

%Execute the job to process the anatomicals

spm_jobman('run_nogui',matlabbatch)

%At this point we clear matlabbatch and exit spm, allowing the bash script
%to continue and set up spm_batch2.m

clear matlabbatch

exit