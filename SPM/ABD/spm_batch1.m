%-----------------------------------------------------------------------
% SPM BATCH - includes spm_batch1.m & spm_batch2.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_ABD_TEMPLATE.sh from the head node of BIAC
%
%    The Laboratory of Neurogenetics, 2011
%       By Vanessa Sochat, Duke University
%-----------------------------------------------------------------------

% Add necessary paths for BIAC, then SPM and data folders
BIACroot = 'SUB_BIACROOT_SUB';
startm=fullfile(BIACroot,'startup.m'); if exist(startm,'file'); run(startm); else; warning(sprintf(['Unable to locate central BIAC startup.m file\n  (%s).\n Connect to network or set BIACMATLABROOT environment variable.\n'],startm)); end; clear startm BIACroot;
addpath(genpath('SUB_SCRIPTDIR_SUB')); addpath(genpath('/usr/local/packages/MATLAB/spm8'));
addpath(genpath('SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB')); addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB'));

%Here we set some directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';

%% DIRECTORY CREATION: creates the proper directories under Analysis/SPM/Processed and Analysis/SPM/Analyzed

spm('defaults','fmri');spm_jobman('initcfg');                                                         % Initialize SPM JOBMAN
cd('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/'); if isdir('anat')==0; mkdir anat; end;    % Make "anat" under Analysis/SPM/Processed
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'));                                                      % Make Analyzed Data directories, if they don't exist
if strcmp('SUB_RUNFACES_SUB','yes'); if isdir('Faces')==0; mkdir Faces; end; end;

%'pfl' stands for 'pseudo first-level'.  These design matrices are without regard to any individual outliers volumes flagged by ART.  The primary
% reason for the creation of these 'pfl' folders is the SPM.mat file can be used to execute art_batch.  These are legitimate design matrices and can be used for analyses.

if strcmp('SUB_RUNFACES_SUB','yes'); if isdir('faces_pfl')==0; mkdir faces_pfl; end; end;
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'));

%% DICOM TO NIFTI CONVERSIONS, FUNCTIONAL AND ANATOMICAL DATA
% We import the dicom images for the anatomical used for functional registration as well as for the high rest T1.  The scan folder names
% are specified by the user, however the anatomical is usually "axial_mprage."  The script assumes the anatomical has 
% 192 images, and the faces has 273. Output goes into Processed/anat and Processed/faces

%Make sure that we are in the subjects raw anatomical data directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/anat/raw/'));

%% Anatomical Import for Functional Data
if strcmp('SUB_ANATFOLDER_SUB', 'axial_mprage')
    % Get DICOM images
    V00img=dir(fullfile(homedir,'Processed/SUB_SUBJECT_SUB/anat/raw/','V*.dcm')); numimages = 192;
    for j=1:numimages; imagearray{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/anat/raw/',V00img(j).name); end; clear V00img;
    matlabbatch{1}.spm.util.dicom.data = imagearray;
    matlabbatch{1}.spm.util.dicom.root = 'flat';
    matlabbatch{1}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/'};
    matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
end; clear imagearray;

%% Functional Import
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/raw/'));
if strcmp('SUB_RUNFACES_SUB', 'yes')
        V00img=dir(fullfile(homedir,'Processed/SUB_SUBJECT_SUB/faces/raw/','V*.dcm')); numimages = 273;
        for j=1:numimages; imagearray{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/raw/',V00img(j).name); end; clear V00img;
        matlabbatch{2}.spm.util.dicom.data = imagearray;
        matlabbatch{2}.spm.util.dicom.root = 'flat';
        matlabbatch{2}.spm.util.dicom.outdir = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/'};
        matlabbatch{2}.spm.util.dicom.convopts.format = 'img';
        matlabbatch{2}.spm.util.dicom.convopts.icedims = 0;    
end


%% Segmentation
% only segments the anatomical image if we aren't doing an ACPC realign (meaning we aren't running only preprocessing)  If we are doing an AC PC realign, the segmentation is done manually.

if strcmp('SUB_SEGMENT_SUB','no')
    matlabbatch{3}.spm.spatial.preproc.data = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/sSUB_SUBJECT_SUB-0006-00001-000192-01.img'};
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
    matlabbatch{3}.spm.spatial.preproc.opts.ngaus = [2 2 2 4];
    matlabbatch{3}.spm.spatial.preproc.opts.regtype = 'mni';
    matlabbatch{3}.spm.spatial.preproc.opts.warpreg = 1;
    matlabbatch{3}.spm.spatial.preproc.opts.warpco = 25;
    matlabbatch{3}.spm.spatial.preproc.opts.biasreg = 0.0001;
    matlabbatch{3}.spm.spatial.preproc.opts.biasfwhm = 60;
    matlabbatch{3}.spm.spatial.preproc.opts.samp = 3;
    matlabbatch{3}.spm.spatial.preproc.opts.msk = {''};
end

spm_jobman('run_nogui',matlabbatch);  clear matlabbatch     %Execute the job to process the anatomicals and clear matlabbatch

exit