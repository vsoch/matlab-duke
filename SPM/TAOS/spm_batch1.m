%-----------------------------------------------------------------------
% SPM BATCH - FOR TAOS includes spm_batch1.m & spm_batch2.m
%
% These template scripts are filled in and run by a bash script,
% spm_preprocess_TEMPLATE.sh from the head node of BIAC
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
addpath(genpath('/usr/local/packages/MATLAB/NIFTI'));
addpath(genpath('/usr/local/packages/MATLAB/fslroi'));
addpath(genpath('SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB'));
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

%First we make our Analyzed Data directories, if they don't exist.  The
%functional directories are created by the bash script.

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'));

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('Faces')==0
        mkdir Faces
    end
end

if strcmp('SUB_RUNCARDS_SUB','yes')
    if isdir('Cards')==0
        mkdir Cards
    end
end

%'pfl' stands for 'pseudo first-level'.  These design matrices are without
%regard to any individual outliers volumes flagged by ART.  The primary
%reason for the creation of these 'pfl' folders is the SPM.mat file can be
%used to execute art_batch.  These are legitimate design matrices and can
%be used for analyses.

if strcmp('SUB_RUNCARDS_SUB','yes')
    if isdir('cards_pfl')==0
       mkdir cards_pfl
    end
end

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('faces_pfl')==0
        mkdir faces_pfl
    end
end

%-----------------------------------------------------------------------
% FUNCTIONAL DATA CHECK
% 
% We check for the existence of folders to affirm that the functional
% data exists. If a folder does not exist, the script cuts and notifies
% the user.
%
%-----------------------------------------------------------------------
cd(horzcat(datadir,'SUB_SUBJECT_SUB/'));

%If the user has specified running cards, we check cards
if strcmp('SUB_RUNCARDS_SUB', 'yes')
    if isdir('cards')==0
            sprintf('%s','Cards data for this subject does not exist.')
            return
    end
end
   
%If the user has specified running faces, we check faces
if strcmp('SUB_RUNFACES_SUB', 'yes')
    if isdir('faces')==0
            sprintf('%s','Faces data for this subject does not exist.')
            return
    end
end 

%-----------------------------------------------------------------------
% DICOM TO NIFTI CONVERSIONS, ANATOMICAL DATA
% 
% We import the dicom images for the anatomical used for functional
% registration as well as for the high rest T1.  The scan folder names
% are specified by the user, however the anatomical is usually
% T1 or T2, and the script assumes the anatomical has 30 images. 
% Output goes into Processed/anat
%
%-----------------------------------------------------------------------

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

Make sure that we are in the subjects raw anatomical data directory
foldertogoto=('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw');
cd(foldertogoto);

switch 'SUB_ANATIMAGES_SUB'
    case '30'
        matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0001.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0002.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0003.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0004.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0005.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0006.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0007.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0008.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0009.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0010.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0011.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0012.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0013.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0014.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0015.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0016.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0017.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0018.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0019.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0020.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0021.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0022.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0023.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0024.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0025.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0026.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0027.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0028.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0029.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0030.img'
                                      };
    case '34'
        matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0001.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0002.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0003.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0004.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0005.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0006.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0007.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0008.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0009.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0010.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0011.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0012.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0013.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0014.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0015.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0016.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0017.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0018.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0019.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0020.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0021.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0022.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0023.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0024.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0025.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0026.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0027.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0028.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0029.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0030.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0031.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0032.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0033.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0034.img'
                                      };
    otherwise
        error('Anatomical data does not have the correct number of images');
end

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

%Execute the job to process the anatomicals

spm_jobman('run_nogui',matlabbatch)
clear matlabbatch

%-----------------------------------------------------------------------
% DICOM TO NIFTI CONVERSIONS, FUNCTIONAL DATA
% 
% We import the dicom images for the functionals. The scan folder names
% are specified by the user, faces is usually "faces_34sli_384x384.16"
% oldfaces is "faces_old_384x384.11" cards is "cardtask_34sli_384x384.13"
% and rest is "rest_asl_1000ms_320x320.7".  The script assumes faces has 
% 274 images, oldfaces has 195, cards has 171 images, and rest has 80.
% Output goes into Processed/faces, oldfaces, rest, and cards
%-----------------------------------------------------------------------

% FACES
spm('defaults','fmri')
spm_jobman('initcfg');

if strcmp('SUB_RUNFACES_SUB','yes')
    
cd SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw;
        matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0001.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0002.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0003.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0004.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0005.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0006.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0007.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0008.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0009.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0010.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0011.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0012.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0013.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0014.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0015.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0016.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0017.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0018.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0019.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0020.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0021.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0022.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0023.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0024.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0025.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0026.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0027.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0028.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0029.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0030.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0031.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0032.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0033.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0034.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0035.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0036.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0037.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0038.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0039.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0040.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0041.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0042.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0043.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0044.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0045.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0046.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0047.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0048.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0049.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0050.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0051.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0052.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0053.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0054.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0055.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0056.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0057.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0058.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0059.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0060.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0061.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0062.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0063.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0064.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0065.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0066.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0067.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0068.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0069.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0070.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0071.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0072.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0073.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0074.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0075.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0076.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0077.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0078.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0079.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0080.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0081.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0082.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0083.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0084.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0085.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0086.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0087.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0088.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0089.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0090.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0091.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0092.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0093.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0094.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0095.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0096.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0097.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0098.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0099.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0100.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0101.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0102.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0103.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0104.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0105.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0106.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0107.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0108.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0109.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0110.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0111.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0112.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0113.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0114.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0115.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0116.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0117.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0118.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0119.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0120.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0121.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0122.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0123.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0124.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0125.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0126.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0127.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0128.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0129.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0130.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0131.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0132.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0133.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0134.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0135.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0136.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0137.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0138.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0139.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0140.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0141.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0142.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0143.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0144.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0145.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0146.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0147.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0148.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0149.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0150.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0151.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0152.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0153.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0154.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0155.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0156.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0157.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0158.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0159.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0160.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0161.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0162.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0163.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0164.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0165.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0166.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0167.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0168.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0169.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0170.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0171.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0172.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0173.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0174.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0175.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0176.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0177.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0178.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0179.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0180.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0181.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0182.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0183.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0184.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0185.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0186.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0187.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0188.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0189.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0190.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0191.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0192.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0193.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0194.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0195.img'
                                      };

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

end

%Execute the job to process faces

spm_jobman('run_nogui',matlabbatch)
clear matlabbatch

% CARDS
spm('defaults','fmri')
spm_jobman('initcfg');

if strcmp('SUB_RUNCARDS_SUB','yes')
    
cd SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw;
        matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0001.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0002.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0003.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0004.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0005.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0006.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0007.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0008.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0009.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0010.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0011.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0012.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0013.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0014.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0015.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0016.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0017.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0018.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0019.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0020.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0021.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0022.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0023.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0024.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0025.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0026.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0027.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0028.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0029.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0030.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0031.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0032.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0033.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0034.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0035.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0036.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0037.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0038.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0039.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0040.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0041.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0042.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0043.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0044.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0045.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0046.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0047.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0048.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0049.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0050.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0051.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0052.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0053.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0054.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0055.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0056.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0057.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0058.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0059.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0060.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0061.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0062.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0063.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0064.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0065.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0066.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0067.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0068.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0069.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0070.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0071.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0072.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0073.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0074.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0075.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0076.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0077.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0078.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0079.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0080.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0081.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0082.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0083.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0084.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0085.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0086.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0087.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0088.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0089.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0090.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0091.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0092.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0093.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0094.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0095.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0096.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0097.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0098.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0099.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0100.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0101.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0102.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0103.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0104.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0105.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0106.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0107.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0108.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0109.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0110.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0111.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0112.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0113.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0114.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0115.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0116.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0117.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0118.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0119.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0120.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0121.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0122.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0123.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0124.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0125.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0126.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0127.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0128.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0129.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0130.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0131.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0132.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0133.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0134.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0135.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0136.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0137.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0138.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0139.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0140.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0141.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0142.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0143.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0144.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0145.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0146.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0147.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0148.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0149.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0150.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0151.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0152.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0153.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0154.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0155.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0156.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0157.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0158.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0159.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0160.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0161.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0162.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0163.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0164.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0165.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0166.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0167.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0168.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0169.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0170.img'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0171.img'
                                      };

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

end

%Execute the job to process cards

spm_jobman('run_nogui',matlabbatch)
clear matlabbatch

%At this point we clear matlabbatch and exit spm, allowing the bash script
%to continue and set up spm_batch2.m

clear matlabbatch

exit