%-----------------------------------------------------------------------
% SPM BATCH - FOR FIGS includes spm_batch1.m & spm_batch2.m
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

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'));

%-----------------------------------------------------------------------
% FUNCTIONAL DATA CHECK
% 
% We check for the existence of folders to affirm that the functional
% data exists. If a folder does not exist, the script cuts and notifies
% the user.
%
%-----------------------------------------------------------------------

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
% "inplanes_t2_256x256.6" and the highres is "axial_mprage_512x416.15."   
% The script assumes the highres has 181 images, and the anatomical 72. 
% Output goes into Processed/anat and Processed/highres.
%
%-----------------------------------------------------------------------

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

%Make sure that we are in the subjects raw anatomical data directory
foldertogoto=('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw');
cd(foldertogoto);

if strcmp('SUB_ANATFOLDER_SUB', 'anat')
matlabbatch{1}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0001.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0002.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0003.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0004.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0005.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0006.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0007.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0008.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0009.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0010.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0011.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0012.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0013.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0014.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0015.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0016.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0017.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0018.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0019.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0020.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0021.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0022.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0023.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0024.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0025.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0026.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0027.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0028.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0029.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0030.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0031.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0032.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0033.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0034.dcm'
                                      };

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

end

%Now we are converting the T1 (mprage) from dicom to nifti

%Make sure that we are in the subject's top directory
foldertogoto=('SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB/');
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
    cd SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw;
    if strcmp('SUB_TFOLDER_SUB', 'highres')
        matlabbatch{2}.spm.util.dicom.data = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0001.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0002.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0003.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0004.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0005.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0006.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0007.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0008.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0009.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0010.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0011.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0012.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0013.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0014.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0015.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0016.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0017.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0018.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0019.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0020.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0021.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0022.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0023.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0024.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0025.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0026.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0027.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0028.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0029.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0030.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0031.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0032.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0033.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0034.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0035.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0036.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0037.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0038.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0039.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0040.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0041.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0042.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0043.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0044.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0045.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0046.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0047.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0048.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0049.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0050.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0051.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0052.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0053.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0054.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0055.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0056.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0057.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0058.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0059.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0060.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0061.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0062.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0063.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0064.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0065.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0066.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0067.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0068.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0069.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0070.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0071.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0072.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0073.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0074.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0075.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0076.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0077.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0078.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0079.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0080.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0081.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0082.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0083.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0084.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0085.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0086.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0087.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0088.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0089.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0090.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0091.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0092.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0093.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0094.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0095.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0096.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0097.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0098.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0099.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0100.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0101.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0102.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0103.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0104.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0105.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0106.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0107.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0108.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0109.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0110.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0111.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0112.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0113.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0114.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0115.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0116.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0117.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0118.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0119.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0120.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0121.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0122.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0123.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0124.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0125.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0126.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0127.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0128.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0129.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0130.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0131.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0132.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0133.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0134.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0135.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0136.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0137.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0138.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0139.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0140.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0141.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0142.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0143.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0144.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0145.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0146.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0147.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0148.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0149.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0150.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0151.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0152.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0153.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0154.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0155.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0156.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0157.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0158.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0159.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0160.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0161.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0162.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0163.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0164.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0165.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0166.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0167.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0168.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0169.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0170.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0171.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/raw/V0172.dcm'
                                      };
   
matlabbatch{2}.spm.util.dicom.root = 'flat';
matlabbatch{2}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/highres/'};
matlabbatch{2}.spm.util.dicom.convopts.format = 'img';
matlabbatch{2}.spm.util.dicom.convopts.icedims = 0;

    end
end

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
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0001.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0002.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0003.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0004.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0005.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0006.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0007.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0008.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0009.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0010.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0011.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0012.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0013.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0014.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0015.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0016.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0017.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0018.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0019.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0020.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0021.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0022.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0023.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0024.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0025.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0026.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0027.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0028.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0029.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0030.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0031.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0032.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0033.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0034.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0035.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0036.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0037.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0038.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0039.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0040.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0041.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0042.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0043.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0044.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0045.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0046.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0047.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0048.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0049.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0050.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0051.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0052.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0053.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0054.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0055.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0056.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0057.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0058.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0059.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0060.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0061.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0062.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0063.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0064.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0065.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0066.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0067.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0068.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0069.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0070.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0071.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0072.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0073.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0074.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0075.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0076.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0077.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0078.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0079.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0080.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0081.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0082.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0083.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0084.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0085.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0086.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0087.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0088.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0089.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0090.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0091.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0092.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0093.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0094.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0095.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0096.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0097.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0098.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0099.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0100.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0101.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0102.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0103.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0104.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0105.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0106.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0107.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0108.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0109.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0110.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0111.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0112.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0113.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0114.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0115.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0116.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0117.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0118.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0119.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0120.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0121.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0122.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0123.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0124.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0125.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0126.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0127.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0128.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0129.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0130.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0131.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0132.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0133.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0134.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0135.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0136.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0137.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0138.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0139.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0140.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0141.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0142.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0143.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0144.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0145.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0146.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0147.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0148.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0149.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0150.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0151.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0152.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0153.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0154.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0155.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0156.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0157.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0158.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0159.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0160.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0161.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0162.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0163.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0164.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0165.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0166.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0167.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0168.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0169.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0170.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0171.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0172.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0173.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0174.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0175.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0176.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0177.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0178.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0179.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0180.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0181.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0182.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0183.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0184.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0185.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0186.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0187.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0188.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0189.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0190.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0191.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0192.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0193.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0194.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/raw/V0195.dcm'
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
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0001.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0002.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0003.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0004.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0005.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0006.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0007.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0008.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0009.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0010.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0011.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0012.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0013.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0014.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0015.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0016.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0017.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0018.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0019.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0020.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0021.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0022.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0023.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0024.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0025.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0026.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0027.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0028.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0029.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0030.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0031.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0032.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0033.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0034.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0035.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0036.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0037.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0038.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0039.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0040.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0041.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0042.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0043.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0044.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0045.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0046.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0047.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0048.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0049.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0050.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0051.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0052.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0053.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0054.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0055.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0056.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0057.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0058.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0059.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0060.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0061.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0062.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0063.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0064.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0065.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0066.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0067.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0068.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0069.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0070.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0071.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0072.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0073.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0074.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0075.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0076.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0077.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0078.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0079.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0080.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0081.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0082.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0083.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0084.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0085.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0086.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0087.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0088.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0089.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0090.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0091.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0092.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0093.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0094.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0095.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0096.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0097.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0098.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0099.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0100.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0101.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0102.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0103.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0104.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0105.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0106.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0107.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0108.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0109.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0110.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0111.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0112.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0113.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0114.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0115.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0116.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0117.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0118.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0119.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0120.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0121.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0122.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0123.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0124.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0125.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0126.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0127.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0128.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0129.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0130.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0131.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0132.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0133.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0134.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0135.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0136.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0137.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0138.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0139.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0140.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0141.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0142.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0143.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0144.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0145.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0146.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0147.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0148.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0149.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0150.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0151.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0152.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0153.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0154.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0155.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0156.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0157.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0158.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0159.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0160.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0161.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0162.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0163.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0164.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0165.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0166.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0167.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0168.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0169.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0170.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/raw/V0171.dcm'
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