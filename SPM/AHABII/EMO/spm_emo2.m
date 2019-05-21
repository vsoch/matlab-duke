%-----------------------------------------------------------------------
% SPM BATCH EMO2 - includes spm_emo.m & spm_emo2.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_EMO.sh/.py from the head node of BIAC
%
%    The Laboratory of Neurogenetics, 2010
%       By Vanessa Sochat, Duke University
%       Patrick Fisher, University of Pittsburgh 
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
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB'));

% Here we set some directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';

%-----------------------------------------------------------------------
% COPY OVER ANATOMICAL OUTPUT TO FUNCTIONAL DIRECTORIES
% 
% Here we copy the anatomical images into each functional directory
% that the user has specified exists so that they can be integrated
% with the data set.
%
%-----------------------------------------------------------------------

%Only runs if we aren't manually segmenting
if strcmp('SUB_SEGMENT_SUB','no')
    if strcmp('SUB_RUNEMO_SUB', 'yes')
        copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1s02.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg');
        copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1s02.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg');
    end
end
%-----------------------------------------------------------------------
% EMOREG PROCESSING
% 
% The first section does rewind & unwarp, cogregistration, normalization,
% and smoothing for the emoreg data.  If the user has not specified to
% process faces, this section is skipped.
%-----------------------------------------------------------------------

% Make sure that we are in the subjects emoreg output directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg'));

%-----------------------------------------------------------------------
% EMOREG ~REALIGN AND UNWARP 
%-----------------------------------------------------------------------

% Check if the user wants to process Emotion Regulation data:
if strcmp('SUB_RUNEMO_SUB', 'yes')
    
spm('defaults','fmri')
spm_jobman('initcfg');

matlabbatch{1}.spm.spatial.realignunwarp.data.scans = {                                                      
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0001.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0002.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0003.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0004.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0005.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0006.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0007.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0008.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0009.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0010.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0011.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0012.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0013.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0014.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0015.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0016.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0017.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0018.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0019.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0020.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0021.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0022.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0023.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0024.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0025.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0026.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0027.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0028.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0029.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0030.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0031.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0032.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0033.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0034.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0035.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0036.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0037.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0038.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0039.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0040.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0041.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0042.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0043.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0044.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0045.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0046.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0047.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0048.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0049.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0050.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0051.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0052.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0053.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0054.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0055.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0056.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0057.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0058.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0059.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0060.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0061.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0062.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0063.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0064.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0065.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0066.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0067.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0068.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0069.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0070.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0071.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0072.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0073.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0074.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0075.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0076.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0077.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0078.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0079.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0080.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0081.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0082.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0083.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0084.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0085.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0086.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0087.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0088.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0089.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0090.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0091.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0092.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0093.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0094.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0095.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0096.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0097.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0098.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0099.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0100.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0101.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0102.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0103.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0104.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0105.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0106.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0107.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0108.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0109.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0110.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0111.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0112.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0113.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0114.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0115.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0116.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0117.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0118.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0119.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0120.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0121.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0122.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0123.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0124.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0125.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0126.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0127.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0128.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0129.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0130.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0131.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0132.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0133.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0134.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0135.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0136.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0137.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0138.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0139.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0140.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0141.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0142.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0143.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0144.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0145.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0146.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0147.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0148.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0149.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0150.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0151.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0152.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0153.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0154.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0155.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0156.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0157.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0158.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0159.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0160.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0161.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0162.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0163.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0164.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0165.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0166.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0167.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0168.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0169.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0170.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0171.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0172.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0173.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0174.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0175.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0176.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0177.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0178.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0179.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0180.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0181.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0182.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0183.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0184.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0185.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0186.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0187.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0188.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0189.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0190.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0191.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0192.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0193.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0194.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0195.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0196.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0197.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0198.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0199.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0200.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0201.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0202.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0203.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0204.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0205.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0206.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0207.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0208.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0209.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0210.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0211.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0212.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0213.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0214.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0215.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0216.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0217.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0218.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0219.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0220.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0221.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0222.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0223.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0224.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0225.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0226.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0227.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0228.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0229.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0230.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0231.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0232.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0233.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0234.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0235.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0236.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0237.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0238.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0239.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0240.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0241.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0242.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0243.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0244.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0245.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0246.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0247.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0248.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0249.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0250.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0251.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0252.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0253.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0254.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0255.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0256.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0257.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0258.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0259.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0260.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0261.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0262.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0263.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0264.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0265.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0266.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0267.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0268.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0269.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0270.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0271.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0272.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0273.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0274.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0275.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0276.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0277.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0278.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0279.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0280.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0281.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0282.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0283.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0284.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0285.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0286.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0287.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0288.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0289.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0290.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0291.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0292.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0293.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0294.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0295.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0296.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0297.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0298.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0299.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0300.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0301.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0302.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0303.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0304.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0305.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0306.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0307.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0308.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0309.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0310.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0311.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0312.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0313.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0314.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0315.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0316.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0317.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0318.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0319.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0320.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0321.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0322.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0323.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0324.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0325.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0326.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0327.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0328.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0329.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0330.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0331.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0332.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0333.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0334.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0335.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0336.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0337.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0338.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0339.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0340.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0341.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0342.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0343.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/V0344.img,1'
                                      };

matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = '';
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = {''};
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

%-----------------------------------------------------------------------
% EMOREG ~COGREGISTRATION
% Dependencies include c1* image copied into faces from anat in
% spm_batch1.m, and meanuV0001.img created during realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/meanuV0001.img,1'};
matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/c1s02.img,1'};

matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];


%-----------------------------------------------------------------------
% EMOREG ~NORMALIZATION
% Dependencies include c1* image copied into faces from anat in
% spm_batch1.m, and 195 uV00* images created after realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/c1s02.img,1'};
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.resample = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0001.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0002.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0003.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0004.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0005.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0006.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0007.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0008.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0009.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0010.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0011.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0012.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0013.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0014.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0015.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0016.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0017.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0018.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0019.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0020.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0021.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0022.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0023.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0024.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0025.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0026.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0027.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0028.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0029.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0030.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0031.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0032.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0033.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0034.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0035.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0036.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0037.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0038.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0039.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0040.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0041.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0042.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0043.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0044.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0045.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0046.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0047.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0048.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0049.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0050.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0051.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0052.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0053.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0054.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0055.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0056.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0057.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0058.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0059.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0060.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0061.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0062.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0063.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0064.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0065.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0066.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0067.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0068.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0069.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0070.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0071.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0072.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0073.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0074.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0075.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0076.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0077.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0078.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0079.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0080.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0081.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0082.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0083.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0084.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0085.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0086.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0087.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0088.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0089.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0090.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0091.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0092.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0093.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0094.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0095.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0096.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0097.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0098.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0099.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0100.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0101.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0102.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0103.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0104.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0105.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0106.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0107.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0108.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0109.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0110.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0111.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0112.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0113.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0114.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0115.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0116.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0117.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0118.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0119.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0120.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0121.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0122.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0123.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0124.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0125.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0126.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0127.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0128.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0129.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0130.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0131.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0132.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0133.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0134.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0135.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0136.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0137.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0138.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0139.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0140.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0141.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0142.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0143.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0144.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0145.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0146.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0147.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0148.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0149.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0150.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0151.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0152.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0153.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0154.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0155.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0156.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0157.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0158.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0159.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0160.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0161.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0162.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0163.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0164.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0165.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0166.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0167.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0168.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0169.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0170.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0171.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0172.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0173.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0174.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0175.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0176.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0177.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0178.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0179.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0180.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0181.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0182.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0183.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0184.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0185.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0186.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0187.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0188.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0189.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0190.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0191.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0192.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0193.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0194.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0195.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0196.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0197.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0198.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0199.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0200.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0201.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0202.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0203.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0204.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0205.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0206.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0207.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0208.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0209.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0210.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0211.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0212.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0213.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0214.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0215.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0216.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0217.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0218.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0219.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0220.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0221.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0222.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0223.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0224.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0225.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0226.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0227.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0228.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0229.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0230.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0231.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0232.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0233.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0234.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0235.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0236.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0237.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0238.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0239.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0240.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0241.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0242.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0243.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0244.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0245.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0246.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0247.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0248.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0249.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0250.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0251.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0252.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0253.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0254.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0255.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0256.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0257.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0258.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0259.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0260.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0261.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0262.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0263.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0264.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0265.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0266.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0267.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0268.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0269.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0270.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0271.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0272.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0273.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0274.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0275.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0276.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0277.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0278.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0279.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0280.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0281.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0282.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0283.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0284.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0285.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0286.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0287.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0288.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0289.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0290.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0291.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0292.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0293.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0294.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0295.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0296.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0297.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0298.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0299.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0300.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0301.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0302.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0303.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0304.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0305.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0306.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0307.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0308.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0309.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0310.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0311.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0312.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0313.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0314.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0315.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0316.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0317.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0318.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0319.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0320.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0321.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0322.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0323.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0324.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0325.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0326.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0327.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0328.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0329.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0330.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0331.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0332.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0333.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0334.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0335.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0336.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0337.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0338.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0339.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0340.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0341.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0342.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0343.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/uV0344.img,1'
                                       };


matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.template = {'/usr/local/packages/MATLAB/spm8/apriori/grey.nii,1'};
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50
                                                             78 76 85];
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';


%-----------------------------------------------------------------------
% EMOREG ~SMOOTHING
% Dependencies include wuV00* images created after normalization.  
%-----------------------------------------------------------------------

matlabbatch{4}.spm.spatial.smooth.data = {

                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0001.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0002.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0003.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0004.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0005.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0006.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0007.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0008.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0009.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0010.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0011.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0012.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0013.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0014.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0015.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0016.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0017.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0018.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0019.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0020.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0021.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0022.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0023.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0024.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0025.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0026.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0027.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0028.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0029.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0030.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0031.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0032.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0033.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0034.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0035.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0036.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0037.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0038.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0039.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0040.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0041.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0042.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0043.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0044.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0045.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0046.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0047.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0048.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0049.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0050.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0051.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0052.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0053.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0054.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0055.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0056.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0057.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0058.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0059.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0060.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0061.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0062.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0063.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0064.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0065.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0066.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0067.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0068.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0069.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0070.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0071.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0072.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0073.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0074.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0075.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0076.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0077.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0078.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0079.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0080.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0081.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0082.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0083.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0084.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0085.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0086.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0087.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0088.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0089.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0090.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0091.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0092.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0093.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0094.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0095.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0096.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0097.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0098.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0099.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0100.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0101.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0102.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0103.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0104.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0105.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0106.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0107.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0108.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0109.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0110.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0111.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0112.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0113.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0114.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0115.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0116.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0117.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0118.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0119.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0120.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0121.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0122.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0123.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0124.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0125.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0126.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0127.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0128.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0129.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0130.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0131.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0132.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0133.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0134.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0135.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0136.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0137.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0138.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0139.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0140.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0141.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0142.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0143.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0144.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0145.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0146.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0147.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0148.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0149.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0150.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0151.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0152.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0153.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0154.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0155.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0156.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0157.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0158.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0159.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0160.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0161.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0162.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0163.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0164.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0165.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0166.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0167.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0168.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0169.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0170.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0171.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0172.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0173.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0174.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0175.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0176.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0177.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0178.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0179.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0180.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0181.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0182.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0183.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0184.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0185.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0186.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0187.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0188.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0189.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0190.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0191.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0192.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0193.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0194.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0195.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0196.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0197.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0198.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0199.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0200.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0201.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0202.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0203.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0204.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0205.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0206.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0207.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0208.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0209.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0210.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0211.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0212.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0213.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0214.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0215.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0216.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0217.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0218.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0219.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0220.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0221.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0222.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0223.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0224.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0225.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0226.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0227.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0228.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0229.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0230.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0231.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0232.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0233.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0234.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0235.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0236.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0237.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0238.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0239.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0240.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0241.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0242.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0243.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0244.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0245.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0246.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0247.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0248.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0249.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0250.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0251.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0252.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0253.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0254.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0255.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0256.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0257.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0258.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0259.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0260.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0261.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0262.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0263.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0264.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0265.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0266.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0267.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0268.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0269.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0270.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0271.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0272.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0273.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0274.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0275.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0276.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0277.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0278.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0279.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0280.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0281.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0282.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0283.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0284.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0285.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0286.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0287.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0288.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0289.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0290.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0291.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0292.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0293.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0294.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0295.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0296.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0297.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0298.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0299.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0300.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0301.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0302.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0303.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0304.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0305.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0306.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0307.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0308.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0309.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0310.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0311.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0312.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0313.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0314.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0315.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0316.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0317.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0318.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0319.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0320.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0321.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0322.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0323.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0324.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0325.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0326.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0327.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0328.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0329.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0330.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0331.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0332.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0333.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0334.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0335.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0336.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0337.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0338.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0339.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0340.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0341.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0342.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0343.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/wuV0344.img,1'
                                       };

matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's';

%-----------------------------------------------------------------------
% EMOREG ~SINGLE SUBJECT PROCESSING
% Sets up the design and runs single subject processing.  Dependencies 
% include swuV00* images created after smoothing. Output goes to 
% faces_pfl under Analysis/SPM/Analyzed
%-----------------------------------------------------------------------

matlabbatch{5}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/emoreg_pfl'};
matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.scans = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0001.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0002.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0003.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0004.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0005.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0006.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0007.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0008.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0009.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0010.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0011.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0012.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0013.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0014.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0015.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0016.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0017.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0018.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0019.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0020.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0021.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0022.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0023.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0024.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0025.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0026.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0027.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0028.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0029.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0030.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0031.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0032.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0033.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0034.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0035.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0036.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0037.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0038.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0039.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0040.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0041.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0042.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0043.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0044.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0045.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0046.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0047.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0048.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0049.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0050.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0051.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0052.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0053.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0054.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0055.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0056.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0057.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0058.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0059.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0060.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0061.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0062.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0063.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0064.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0065.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0066.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0067.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0068.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0069.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0070.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0071.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0072.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0073.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0074.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0075.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0076.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0077.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0078.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0079.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0080.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0081.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0082.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0083.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0084.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0085.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0086.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0087.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0088.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0089.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0090.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0091.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0092.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0093.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0094.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0095.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0096.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0097.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0098.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0099.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0100.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0101.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0102.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0103.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0104.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0105.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0106.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0107.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0108.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0109.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0110.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0111.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0112.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0113.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0114.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0115.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0116.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0117.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0118.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0119.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0120.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0121.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0122.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0123.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0124.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0125.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0126.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0127.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0128.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0129.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0130.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0131.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0132.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0133.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0134.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0135.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0136.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0137.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0138.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0139.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0140.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0141.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0142.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0143.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0144.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0145.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0146.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0147.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0148.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0149.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0150.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0151.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0152.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0153.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0154.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0155.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0156.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0157.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0158.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0159.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0160.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0161.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0162.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0163.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0164.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0165.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0166.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0167.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0168.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0169.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0170.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0171.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0172.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0173.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0174.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0175.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0176.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0177.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0178.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0179.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0180.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0181.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0182.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0183.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0184.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0185.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0186.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0187.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0188.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0189.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0190.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0191.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0192.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0193.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0194.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0195.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0196.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0197.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0198.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0199.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0200.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0201.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0202.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0203.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0204.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0205.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0206.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0207.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0208.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0209.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0210.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0211.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0212.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0213.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0214.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0215.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0216.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0217.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0218.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0219.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0220.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0221.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0222.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0223.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0224.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0225.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0226.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0227.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0228.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0229.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0230.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0231.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0232.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0233.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0234.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0235.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0236.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0237.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0238.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0239.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0240.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0241.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0242.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0243.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0244.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0245.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0246.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0247.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0248.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0249.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0250.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0251.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0252.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0253.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0254.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0255.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0256.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0257.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0258.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0259.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0260.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0261.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0262.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0263.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0264.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0265.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0266.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0267.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0268.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0269.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0270.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0271.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0272.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0273.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0274.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0275.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0276.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0277.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0278.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0279.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0280.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0281.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0282.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0283.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0284.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0285.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0286.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0287.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0288.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0289.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0290.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0291.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0292.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0293.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0294.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0295.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0296.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0297.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0298.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0299.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0300.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0301.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0302.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0303.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0304.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0305.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0306.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0307.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0308.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0309.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0310.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0311.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0312.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0313.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0314.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0315.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0316.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0317.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0318.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0319.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0320.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0321.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0322.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0323.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0324.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0325.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0326.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0327.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0328.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0329.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0330.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0331.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0332.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0333.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0334.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0335.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0336.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0337.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0338.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0339.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0340.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0341.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0342.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0343.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0344.img,1'
                                       };

% Here are our conditions: name, onsets, and durations.
% CONDITION 1 - LOOK NEG REST
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).name = 'Look Neg Rest';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).onset = [9.5
                                                         24.5
                                                         62.5
                                                         69.5
                                                         84.5
                                                         99.5
                                                         106.5
                                                         128.5
                                                         143.5
                                                         158.5
                                                         202.5
                                                         226.5
                                                         233.5
                                                         263.5
                                                         317.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).duration = [1.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 2 - LOOK NEG CUE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).name = 'Look Neg Cue';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).onset = [3
                                                         18
                                                         56
                                                         63
                                                         78
                                                         93
                                                         100
                                                         122
                                                         137
                                                         152
                                                         196
                                                         220
                                                         227
                                                         257
                                                         311];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).duration = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 3 - LOOK NEG RATING
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).name = 'Look Neg Rating';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).onset = [7.5
                                                         22.5
                                                         60.5
                                                         67.5
                                                         82.5
                                                         97.5
                                                         104.5
                                                         126.5
                                                         141.5
                                                         156.5
                                                         200.5
                                                         224.5
                                                         231.5
                                                         261.5
                                                         315.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).duration = 2;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 4 - LOOK NEG PICTURE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).name = 'Look Neg Picture';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).onset = [4
                                                         19
                                                         57
                                                         64
                                                         79
                                                         94
                                                         101
                                                         123
                                                         138
                                                         153
                                                         197
                                                         221
                                                         228
                                                         258
                                                         312];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).duration = 3.5;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 5 - LOOK NEUTRAL REST
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).name = 'Look Neutral Rest';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).onset = [32.5
                                                         54.5
                                                         77.5
                                                         91.5
                                                         113.5
                                                         135.5
                                                         150.5
                                                         180.5
                                                         218.5
                                                         255.5
                                                         270.5
                                                         285.5
                                                         309.5
                                                         324.5
                                                         332.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).duration = [1.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            0.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 1 - LOOK NEUTRAL CUE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(6).name = 'Look Neutal Cue';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(6).onset = [26
                                                         48
                                                         71
                                                         85
                                                         107
                                                         129
                                                         144
                                                         174
                                                         212
                                                         249
                                                         264
                                                         279
                                                         303
                                                         318
                                                         326];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(6).duration = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 7 - LOOK NEUTRAL RATING
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(7).name = 'Look Neutral Rating';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(7).onset = [30.5
                                                         52.5
                                                         75.5
                                                         89.5
                                                         111.5
                                                         133.5
                                                         148.5
                                                         178.5
                                                         216.5
                                                         253.5
                                                         268.5
                                                         283.5
                                                         307.5
                                                         322.5
                                                         330.5];


matlabbatch{5}.spm.stats.fmri_spec.sess.cond(7).duration = [2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 8 - LOOK NEUTRAL PICTURE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(8).name = 'Look Neutral Picture';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(8).onset = [27
                                                         49
                                                         72
                                                         86
                                                         108
                                                         130
                                                         145
                                                         175
                                                         213
                                                         250
                                                         265
                                                         280
                                                         304
                                                         319
                                                         327];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(8).duration = 3.5;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 9 - REG NEG REST
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(9).name = 'Reg Neg Rest';

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(9).onset = [17.5
                                                         40.5
                                                         47.5
                                                         121.5
                                                         166.5
                                                         173.5
                                                         188.5
                                                         195.5
                                                         210.5
                                                         240.5
                                                         247.5
                                                         278.5
                                                         293.5
                                                         301.5
                                                         339.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(9).duration = [0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            1.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 10 - REG NEG CUE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(10).name = 'Reg Neg Cue';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(10).onset = [11
                                                          34
                                                          41
                                                          115
                                                          160
                                                          167
                                                          182
                                                          189
                                                          204
                                                          234
                                                          241
                                                          272
                                                          287
                                                          295
                                                          333];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(10).duration = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 11 - LOOK NEG RATING
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(11).name = 'Reg Neg Rating';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(11).onset = [15.5
                                                          38.5
                                                          45.5
                                                          119.5
                                                          164.5
                                                          171.5
                                                          186.5
                                                          193.5
                                                          208.5
                                                          238.5
                                                          245.5
                                                          276.5
                                                          291.5
                                                          299.5
                                                          337.5];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(11).duration = 2;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 12 - LOOK NEG PICTURE
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(12).name = 'Reg Neg Picture';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(12).onset = [12
                                                          35
                                                          42
                                                          116
                                                          161
                                                          168
                                                          183
                                                          190
                                                          205
                                                          235
                                                          242
                                                          273
                                                          288
                                                          296
                                                          334];

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(12).duration = 3.5;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});

matlabbatch{5}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.multi_reg = {''};
matlabbatch{5}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{5}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{5}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{5}.spm.stats.fmri_spec.volt = 1;
matlabbatch{5}.spm.stats.fmri_spec.global = 'None';
matlabbatch{5}.spm.stats.fmri_spec.mask = {''};
matlabbatch{5}.spm.stats.fmri_spec.cvi = 'AR(1)';

% Estimate the SPM.mat
matlabbatch{6}.spm.stats.fmri_est.spmmat = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/emoreg_pfl/SPM.mat'};
matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;

%-----------------------------------------------------------------------
% EMOREG JOB SUBMIT!
% After setting up the matlabbatch above, we finally run it for emoreg
%-----------------------------------------------------------------------
spm_jobman('run_nogui',matlabbatch)
%Now we clear matlabbatch to do the next group of files
clear matlabbatch
end

%-----------------------------------------------------------------------
% SPM CHECK REGISTRATION
% 
% After initial pre-processing batch file is completed Check Registration
% will be used to create visualizations of a random set of 12 smoothed
% functional images for each of the three tasks.  The reason for this is to
% approximate whether, across all scans, the smoothed image files are of
% good quality.  This can be incorporated into the batch stream, however, it
% is unclear to me within the batch editory how to print the output to the
% *.ps file that SPM8 creates when it compeltes other steps such as
% Realign&Unwarp.
%-----------------------------------------------------------------------

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

%Randomly generates 12 numbers between 1 and 344.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the cards ProcessedData folder
%for this single subject.
if strcmp('SUB_RUNEMO_SUB','yes')
    i = 344;

    % This takes into account the fact that the indexing of the
    % chreg_emoreg array must be referenced with the correct size to work.
    % Since we have various user IDs on the cluster, having a user ID with
    % 4 versus 5 characters will make the script end with error.  So we
    % calculate the length of the user ID, and add this number to the
    % length of the path without the user ID, and use this value as the
    % legnth of the array.
    length_index=SUB_LENGTH_SUB+101;
    
    %This allocates a spot in memory for the array so that it doesn't have
    %to find a new spot for every iteration of the loop. 
    chreg_emoreg=char(12,length_index);
    
    f = ceil(i.*rand(12,1));
    for j = 1:12
        if f(j) < 10
            chreg_emoreg(j,1:length_index) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg/swuV000',num2str(f(j)),'.img,1');
        end
        if f(j) >=10
            if f(j) < 100
                chreg_emoreg(j,1:length_index) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg/swuV00',num2str(f(j)),'.img,1');
            end
        end
        if f(j) >=100
            chreg_emoreg(j,1:length_index) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg/swuV0',num2str(f(j)),'.img,1');
        end
    end

spm_check_registration(chreg_emoreg)
%spm_print will print a *.ps of the 12 smoothed images files to the same
%*.ps file it created for the other components of the pre-processing
spm_print
clear chreg_emoreg length_index
end

%-----------------------------------------------------------------------
% ART BATCH
% Calculates artifact detection for each functional run and creates
% single subject design matrices that include the outputs from art_batch
%-----------------------------------------------------------------------

addpath(genpath('SUB_MOUNT_SUB/Scripts/SPM/Art'));
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))

%The outputs from this art_batch will include a .mat file specifying
%particular volumes that are outliers.  This file can be loaded as a
%regressor into single subject designs to control for substantial
%variability of a single or set of images

if strcmp('SUB_RUNEMO_SUB', 'yes')
    
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/emoreg_pfl'))
art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/emoreg_pfl/SPM.mat'));

end

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))
%Check whether the folder 'emoreg' exists within the
%single subject Analyzed Data folder.  If not, it create it.  The single
%subject design matrices with these folders will incorporate the art output
%when necessary.
if strcmp('SUB_RUNEMO_SUB','yes')
    if isdir('EmoReg')==0
        sprintf('%s','Currently no emoreg folder exists.  Creating emoreg within single subject AnalyzedData folder.')
        mkdir EmoReg
    end
end

%-----------------------------------------------------------------------
% ART for EMOREG
% Calculates artifact detection for cards and creates a single
% subject design matrix that include the outputs from art_batch
%-----------------------------------------------------------------------

% Check if the user is processing emoreg data:
if strcmp('SUB_RUNEMO_SUB', 'yes')
    
% Here we initialize the spm jobman to prepare to run higher level
% processing for emoreg
spm('defaults','fmri')
spm_jobman('initcfg');

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/EmoReg'))

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg'))

matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/EmoReg'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0001.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0002.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0003.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0004.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0005.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0006.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0007.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0008.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0009.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0010.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0011.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0012.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0013.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0014.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0015.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0016.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0017.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0018.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0019.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0020.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0021.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0022.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0023.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0024.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0025.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0026.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0027.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0028.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0029.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0030.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0031.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0032.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0033.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0034.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0035.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0036.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0037.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0038.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0039.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0040.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0041.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0042.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0043.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0044.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0045.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0046.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0047.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0048.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0049.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0050.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0051.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0052.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0053.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0054.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0055.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0056.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0057.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0058.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0059.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0060.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0061.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0062.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0063.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0064.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0065.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0066.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0067.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0068.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0069.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0070.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0071.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0072.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0073.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0074.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0075.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0076.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0077.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0078.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0079.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0080.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0081.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0082.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0083.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0084.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0085.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0086.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0087.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0088.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0089.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0090.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0091.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0092.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0093.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0094.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0095.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0096.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0097.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0098.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0099.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0100.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0101.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0102.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0103.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0104.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0105.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0106.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0107.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0108.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0109.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0110.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0111.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0112.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0113.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0114.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0115.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0116.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0117.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0118.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0119.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0120.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0121.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0122.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0123.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0124.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0125.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0126.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0127.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0128.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0129.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0130.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0131.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0132.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0133.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0134.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0135.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0136.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0137.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0138.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0139.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0140.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0141.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0142.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0143.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0144.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0145.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0146.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0147.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0148.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0149.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0150.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0151.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0152.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0153.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0154.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0155.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0156.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0157.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0158.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0159.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0160.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0161.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0162.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0163.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0164.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0165.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0166.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0167.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0168.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0169.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0170.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0171.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0172.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0173.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0174.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0175.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0176.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0177.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0178.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0179.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0180.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0181.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0182.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0183.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0184.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0185.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0186.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0187.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0188.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0189.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0190.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0191.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0192.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0193.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0194.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0195.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0196.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0197.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0198.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0199.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0200.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0201.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0202.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0203.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0204.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0205.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0206.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0207.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0208.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0209.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0210.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0211.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0212.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0213.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0214.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0215.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0216.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0217.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0218.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0219.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0220.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0221.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0222.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0223.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0224.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0225.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0226.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0227.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0228.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0229.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0230.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0231.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0232.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0233.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0234.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0235.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0236.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0237.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0238.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0239.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0240.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0241.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0242.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0243.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0244.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0245.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0246.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0247.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0248.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0249.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0250.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0251.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0252.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0253.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0254.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0255.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0256.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0257.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0258.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0259.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0260.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0261.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0262.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0263.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0264.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0265.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0266.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0267.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0268.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0269.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0270.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0271.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0272.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0273.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0274.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0275.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0276.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0277.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0278.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0279.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0280.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0281.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0282.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0283.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0284.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0285.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0286.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0287.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0288.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0289.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0290.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0291.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0292.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0293.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0294.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0295.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0296.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0297.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0298.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0299.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0300.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0301.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0302.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0303.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0304.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0305.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0306.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0307.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0308.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0309.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0310.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0311.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0312.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0313.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0314.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0315.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0316.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0317.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0318.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0319.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0320.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0321.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0322.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0323.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0324.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0325.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0326.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0327.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0328.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0329.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0330.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0331.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0332.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0333.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0334.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0335.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0336.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0337.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0338.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0339.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0340.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0341.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0342.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0343.img,1'
                                      'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/swuV0344.img,1'
                                       };


% Here are our conditions: name, onsets, and durations.
% CONDITION 1 - LOOK NEG REST
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Look Neg Rest';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [9.5
                                                         24.5
                                                         62.5
                                                         69.5
                                                         84.5
                                                         99.5
                                                         106.5
                                                         128.5
                                                         143.5
                                                         158.5
                                                         202.5
                                                         226.5
                                                         233.5
                                                         263.5
                                                         317.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = [1.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 2 - LOOK NEG CUE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Look Neg Cue';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = [3
                                                         18
                                                         56
                                                         63
                                                         78
                                                         93
                                                         100
                                                         122
                                                         137
                                                         152
                                                         196
                                                         220
                                                         227
                                                         257
                                                         311];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 3 - LOOK NEG RATING
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Look Neg Rating';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = [7.5
                                                         22.5
                                                         60.5
                                                         67.5
                                                         82.5
                                                         97.5
                                                         104.5
                                                         126.5
                                                         141.5
                                                         156.5
                                                         200.5
                                                         224.5
                                                         231.5
                                                         261.5
                                                         315.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 4 - LOOK NEG PICTURE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Look Neg Picture';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = [4
                                                         19
                                                         57
                                                         64
                                                         79
                                                         94
                                                         101
                                                         123
                                                         138
                                                         153
                                                         197
                                                         221
                                                         228
                                                         258
                                                         312];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 3.5;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 5 - LOOK NEUTRAL REST
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'Look Neutral Rest';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = [32.5
                                                         54.5
                                                         77.5
                                                         91.5
                                                         113.5
                                                         135.5
                                                         150.5
                                                         180.5
                                                         218.5
                                                         255.5
                                                         270.5
                                                         285.5
                                                         309.5
                                                         324.5
                                                         332.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = [1.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            1.5
                                                            0.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 1 - LOOK NEUTRAL CUE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'Look Neutal Cue';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = [26
                                                         48
                                                         71
                                                         85
                                                         107
                                                         129
                                                         144
                                                         174
                                                         212
                                                         249
                                                         264
                                                         279
                                                         303
                                                         318
                                                         326];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 7 - LOOK NEUTRAL RATING
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'Look Neutral Rating';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = [30.5
                                                         52.5
                                                         75.5
                                                         89.5
                                                         111.5
                                                         133.5
                                                         148.5
                                                         178.5
                                                         216.5
                                                         253.5
                                                         268.5
                                                         283.5
                                                         307.5
                                                         322.5
                                                         330.5];


matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = [2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2
                                                            2];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 8 - LOOK NEUTRAL PICTURE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'Look Neutral Picture';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = [27
                                                         49
                                                         72
                                                         86
                                                         108
                                                         130
                                                         145
                                                         175
                                                         213
                                                         250
                                                         265
                                                         280
                                                         304
                                                         319
                                                         327];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 3.5;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 9 - REG NEG REST
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'Reg Neg Rest';

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = [17.5
                                                         40.5
                                                         47.5
                                                         121.5
                                                         166.5
                                                         173.5
                                                         188.5
                                                         195.5
                                                         210.5
                                                         240.5
                                                         247.5
                                                         278.5
                                                         293.5
                                                         301.5
                                                         339.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = [0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            0.5
                                                            1.5
                                                            1.5
                                                            1.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 10 - REG NEG CUE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'Reg Neg Cue';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = [11
                                                          34
                                                          41
                                                          115
                                                          160
                                                          167
                                                          182
                                                          189
                                                          204
                                                          234
                                                          241
                                                          272
                                                          287
                                                          295
                                                          333];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 11 - LOOK NEG RATING
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'Reg Neg Rating';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = [15.5
                                                          38.5
                                                          45.5
                                                          119.5
                                                          164.5
                                                          171.5
                                                          186.5
                                                          193.5
                                                          208.5
                                                          238.5
                                                          245.5
                                                          276.5
                                                          291.5
                                                          299.5
                                                          337.5];

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});

% CONDITION 12 - LOOK NEG PICTURE
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'Reg Neg Picture';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = [12
                                                          35
                                                          42
                                                          116
                                                          161
                                                          168
                                                          183
                                                          190
                                                          205
                                                          235
                                                          242
                                                          273
                                                          288
                                                          296
                                                          334];
                                   
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 3.5;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});

matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/emoreg/art_regression_outliers_swuV0001.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/EmoReg/SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/EmoReg/SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Look Negative > Look Neutral';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0 0 0 1 0 0 0 -1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Regulate Negative > Look Negative';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 0 -1 0 0 0 0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Look Negative > Regulate Negative';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 0 1 0 0 0 0 0 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Regulate Negative > Look Neutral';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 0 0 0 0 0 0 -1 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Look Neutral > Regulate Negative';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0 0 0 0 0 0 0 1 0 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Look Neutral > Look Negative';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 0 -1 0 0 0 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%We submit the job
spm_jobman('run_nogui',matlabbatch)
%and clear matlabbatch for the next job
clear matlabbatch
end



%-----------------------------------------------------------------------
% CLEANUP
% Here we go back to the Processed directory, and delete the copied
% over V000* images, the uV00*, and wuV00* images, to save space.
%-----------------------------------------------------------------------

if strcmp('SUB_RUNEMO_SUB', 'yes')
    
    cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg/raw'))
    delete V*

    cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/emoreg'))

    delete V0*
    delete uV0*
    delete wuV0*
    rmdir raw

    % Fixing paths for emoreg_pfl SPM.mat
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/emoreg_pfl'))
    spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','N:/AHABII.01/','/');

    % Fixing paths for EmoReg SPM.mat
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/EmoReg'))
    spm_change_paths('SUB_MOUNT_SUB/','N:/AHABII.01/','/');

end


%Delete anatomical raw images
if strcmp('SUB_PROCESSANAT_SUB','yes')
    if strcmp('SUB_ANATFOLDER_SUB', 'anat')
        cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/anat/raw'))
        delete V*
    end
end

exit