%-----------------------------------------------------------------------
% SPM BATCH EMO - FOR AHABII includes spm_emo.m & spm_emo2.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_EMO.sh/.py from the head node of BIAC
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

% First we make our Analyzed Data directories, if they don't exist.  The
% functional directories are created by the bash script. 'pfl' stands for 
% 'pseudo first-level'.  These design matrices are without regard to any 
% individual outliers volumes flagged by ART.  The primary reason for the 
% creation of these 'pfl' folders is the SPM.mat file can be
% used to execute art_batch.  These are legitimate design matrices and can
% be used for analyses.


cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'));

if strcmp('SUB_RUNEMO_SUB','yes')
    if isdir('EmoReg')==0
        mkdir EmoReg
    end
    if isdir('emoreg_pfl')==0
       mkdir emoreg_pfl
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

%If the user has specified running emoreg, we check emoreg
if strcmp('SUB_RUNEMO_SUB', 'yes')
    if isdir('emoreg')==0
            sprintf('%s','EmoReg data for this subject does not exist.')
            return
    end
end
   
%-----------------------------------------------------------------------
% DICOM TO NIFTI CONVERSIONS, ANATOMICAL DATA
% 
% We import the dicom images for the anatomical used for functional
% registration as well as for the high res T1.  The scan folder names
% are specified by the user, however the anatomical is usually 
% "inplanes_t2_256x256.6" and the highres is "axial_mprage_512x416.15."   
% The script assumes the highres has 181 images, and the anatomical 72. 
% Output goes into Processed/anat and Processed/highres.
%
%-----------------------------------------------------------------------

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

%Make sure that we are in the subject's raw anatomical data directory
%The paths below do not need to be changed because they are for the
%anatomical scan only and AHABII matches DNS for duration of anatomical
%scan.

foldertogoto=('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw');
cd(foldertogoto);

if strcmp('SUB_PROCESSANAT_SUB','yes')
    
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
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0035.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0036.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0037.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0038.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0039.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0040.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0041.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0042.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0043.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0044.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0045.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0046.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0047.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0048.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0049.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0050.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0051.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0052.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0053.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0054.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0055.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0056.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0057.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0058.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0059.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0060.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0061.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0062.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0063.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0064.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0065.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0066.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0067.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0068.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0069.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0070.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0071.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/raw/V0072.dcm'
                                      };
end

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

%Make sure that we are in the subject's top directory
foldertogoto=('SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB/');
cd(foldertogoto);


if strcmp('SUB_SEGMENT_SUB','no')
%Now we segment the anatomical image
matlabbatch{2}.spm.spatial.preproc.data = {horzcat('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/sSUB_SUBPRE_SUB-0006-00001-000072-02.img,1')};
matlabbatch{2}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{2}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{2}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{2}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{2}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{2}.spm.spatial.preproc.opts.tpm = {
                                               '/usr/local/packages/MATLAB/spm8/tpm/grey.nii'
                                               '/usr/local/packages/MATLAB/spm8/tpm/white.nii'
                                               '/usr/local/packages/MATLAB/spm8/tpm/csf.nii'
                                               };
matlabbatch{3}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{2}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{2}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{2}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{2}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{2}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{2}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{2}.spm.spatial.preproc.opts.msk = {''};

end

%Execute the job to process the anatomicals

spm_jobman('run_nogui',matlabbatch)
clear matlabbatch

end

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

spm('defaults','fmri')
spm_jobman('initcfg');

if strcmp('SUB_RUNEMO_SUB','yes')

cd('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw');
        matlabbatch{1}.spm.util.dicom.data = {                                           
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0001.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0002.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0003.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0004.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0005.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0006.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0007.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0008.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0009.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0010.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0011.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0012.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0013.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0014.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0015.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0016.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0017.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0018.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0019.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0020.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0021.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0022.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0023.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0024.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0025.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0026.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0027.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0028.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0029.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0030.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0031.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0032.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0033.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0034.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0035.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0036.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0037.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0038.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0039.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0040.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0041.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0042.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0043.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0044.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0045.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0046.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0047.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0048.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0049.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0050.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0051.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0052.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0053.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0054.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0055.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0056.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0057.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0058.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0059.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0060.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0061.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0062.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0063.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0064.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0065.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0066.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0067.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0068.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0069.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0070.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0071.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0072.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0073.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0074.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0075.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0076.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0077.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0078.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0079.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0080.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0081.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0082.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0083.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0084.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0085.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0086.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0087.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0088.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0089.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0090.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0091.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0092.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0093.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0094.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0095.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0096.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0097.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0098.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0099.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0100.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0101.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0102.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0103.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0104.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0105.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0106.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0107.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0108.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0109.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0110.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0111.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0112.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0113.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0114.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0115.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0116.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0117.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0118.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0119.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0120.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0121.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0122.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0123.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0124.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0125.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0126.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0127.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0128.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0129.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0130.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0131.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0132.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0133.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0134.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0135.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0136.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0137.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0138.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0139.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0140.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0141.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0142.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0143.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0144.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0145.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0146.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0147.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0148.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0149.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0150.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0151.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0152.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0153.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0154.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0155.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0156.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0157.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0158.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0159.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0160.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0161.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0162.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0163.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0164.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0165.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0166.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0167.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0168.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0169.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0170.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0171.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0172.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0173.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0174.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0175.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0176.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0177.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0178.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0179.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0180.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0181.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0182.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0183.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0184.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0185.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0186.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0187.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0188.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0189.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0190.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0191.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0192.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0193.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0194.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0195.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0196.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0197.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0198.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0199.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0200.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0201.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0202.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0203.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0204.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0205.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0206.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0207.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0208.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0209.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0210.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0211.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0212.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0213.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0214.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0215.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0216.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0217.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0218.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0219.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0220.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0221.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0222.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0223.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0224.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0225.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0226.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0227.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0228.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0229.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0230.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0231.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0232.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0233.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0234.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0235.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0236.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0237.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0238.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0239.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0240.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0241.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0242.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0243.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0244.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0245.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0246.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0247.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0248.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0249.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0250.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0251.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0252.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0253.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0254.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0255.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0256.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0257.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0258.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0259.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0260.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0261.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0262.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0263.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0264.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0265.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0266.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0267.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0268.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0269.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0270.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0271.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0272.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0273.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0274.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0275.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0276.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0277.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0278.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0279.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0280.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0281.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0282.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0283.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0284.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0285.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0286.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0287.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0288.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0289.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0290.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0291.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0292.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0293.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0294.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0295.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0296.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0297.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0298.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0299.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0300.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0301.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0302.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0303.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0304.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0305.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0306.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0307.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0308.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0309.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0310.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0311.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0312.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0313.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0314.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0315.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0316.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0317.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0318.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0319.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0320.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0321.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0322.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0323.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0324.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0325.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0326.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0327.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0328.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0329.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0330.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0331.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0332.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0333.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0334.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0335.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0336.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0337.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0338.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0339.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0340.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0341.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0342.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0343.dcm'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/raw/V0344.dcm'
                                      };

matlabbatch{1}.spm.util.dicom.root = 'flat';
matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/'};
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;

%Execute the job to process emoreg

spm_jobman('run_nogui',matlabbatch)
clear matlabbatch
end

%At this point we clear matlabbatch and exit spm, allowing the bash script
%to continue and set up spm_batch2.m

clear matlabbatch

exit