%-----------------------------------------------------------------------
% SPM BATCH ORDER 2 (NFSA) comes after spm_batch1.m
%
% These template scripts are filled in and run by a bash script,
% spm_preprocess_TEMPLATE.sh from the head node of BIAC
%
% Output contrasts are as follows:
%
% FACES: Faces > Shapes (1), Fearful Faces > Shapes (2), Neutral Faces >
% Shapes (3), Surprise Faces > Shapes (4) for both affect and block design.  
% CARDS: Positive Feedback > Negative Feedback (1), Negative Feedback > 
% Positive Feedback (2), Positive Feedback > Control (3), Negative 
% Feedback > Control (4).  For complete contrasts, please see DNS excel. 
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
addpath(genpath('SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Data/Func/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB'));

%Here we set some directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';
scriptdir='SUB_MOUNT_SUB/Scripts/';
datadir='SUB_MOUNT_SUB/Data/';

%-----------------------------------------------------------------------
% ANAT COPY
% 
% Here we are copying our anatomicals into each functional directory for
% registration.
% ----------------------------------------------------------------------

    
if strcmp('SUB_RUNFACES_SUB', 'yes')
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
end


if strcmp('SUB_RUNCARDS_SUB', 'yes')
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards');
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards');
end


if strcmp('SUB_RUNREST_SUB', 'yes')
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest');
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sdns01-0002-00001-000001-01.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest');
end



%-----------------------------------------------------------------------
% FACES PROCESSING
% 
% The first section does rewind & unwarp, cogregistration, normalization,
% and smoothing for the faces data.  If the user has not specified to
% process faces, this section is skipped.
%-----------------------------------------------------------------------

% Make sure that we are in the subjects faces output directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'));

%-----------------------------------------------------------------------
% FACES ~REALIGN AND UNWARP 
%-----------------------------------------------------------------------

% Check if the user wants to process faces data:
if strcmp('SUB_RUNFACES_SUB', 'yes')
    
spm('defaults','fmri')
spm_jobman('initcfg');
    
matlabbatch{1}.spm.spatial.realignunwarp.data.scans = {
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0001.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0002.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0003.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0004.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0005.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0006.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0007.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0008.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0009.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0010.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0011.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0012.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0013.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0014.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0015.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0016.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0017.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0018.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0019.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0020.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0021.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0022.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0023.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0024.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0025.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0026.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0027.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0028.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0029.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0030.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0031.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0032.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0033.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0034.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0035.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0036.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0037.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0038.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0039.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0040.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0041.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0042.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0043.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0044.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0045.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0046.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0047.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0048.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0049.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0050.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0051.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0052.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0053.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0054.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0055.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0056.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0057.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0058.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0059.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0060.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0061.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0062.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0063.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0064.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0065.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0066.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0067.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0068.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0069.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0070.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0071.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0072.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0073.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0074.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0075.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0076.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0077.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0078.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0079.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0080.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0081.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0082.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0083.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0084.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0085.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0086.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0087.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0088.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0089.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0090.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0091.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0092.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0093.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0094.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0095.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0096.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0097.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0098.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0099.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0100.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0101.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0102.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0103.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0104.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0105.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0106.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0107.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0108.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0109.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0110.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0111.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0112.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0113.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0114.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0115.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0116.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0117.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0118.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0119.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0120.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0121.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0122.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0123.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0124.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0125.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0126.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0127.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0128.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0129.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0130.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0131.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0132.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0133.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0134.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0135.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0136.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0137.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0138.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0139.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0140.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0141.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0142.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0143.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0144.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0145.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0146.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0147.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0148.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0149.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0150.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0151.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0152.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0153.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0154.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0155.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0156.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0157.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0158.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0159.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0160.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0161.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0162.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0163.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0164.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0165.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0166.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0167.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0168.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0169.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0170.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0171.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0172.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0173.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0174.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0175.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0176.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0177.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0178.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0179.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0180.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0181.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0182.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0183.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0184.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0185.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0186.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0187.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0188.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0189.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0190.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0191.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0192.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0193.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0194.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/V0195.img,1'
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
% FACES ~COGREGISTRATION
% Dependencies include c1* image copied into faces from anat in
% spm_batch1.m, and meanuV0001.img created during realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/meanuV0001.img,1'};
matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1sdns01-0002-00001-000001-01.img,1'};

matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];


%-----------------------------------------------------------------------
% FACES ~NORMALIZATION
% Dependencies include c1* image copied into faces from anat in
% spm_batch1.m, and 195 uV00* images created after realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1sdns01-0002-00001-000001-01.img,1'};
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.resample = {
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0001.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0002.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0003.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0004.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0005.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0006.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0007.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0008.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0009.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0010.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0011.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0012.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0013.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0014.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0015.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0016.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0017.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0018.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0019.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0020.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0021.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0022.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0023.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0024.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0025.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0026.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0027.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0028.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0029.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0030.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0031.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0032.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0033.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0034.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0035.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0036.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0037.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0038.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0039.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0040.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0041.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0042.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0043.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0044.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0045.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0046.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0047.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0048.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0049.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0050.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0051.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0052.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0053.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0054.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0055.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0056.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0057.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0058.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0059.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0060.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0061.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0062.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0063.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0064.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0065.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0066.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0067.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0068.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0069.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0070.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0071.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0072.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0073.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0074.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0075.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0076.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0077.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0078.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0079.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0080.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0081.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0082.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0083.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0084.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0085.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0086.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0087.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0088.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0089.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0090.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0091.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0092.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0093.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0094.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0095.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0096.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0097.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0098.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0099.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0100.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0101.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0102.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0103.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0104.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0105.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0106.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0107.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0108.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0109.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0110.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0111.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0112.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0113.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0114.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0115.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0116.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0117.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0118.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0119.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0120.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0121.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0122.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0123.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0124.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0125.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0126.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0127.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0128.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0129.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0130.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0131.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0132.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0133.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0134.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0135.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0136.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0137.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0138.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0139.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0140.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0141.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0142.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0143.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0144.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0145.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0146.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0147.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0148.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0149.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0150.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0151.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0152.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0153.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0154.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0155.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0156.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0157.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0158.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0159.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0160.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0161.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0162.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0163.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0164.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0165.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0166.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0167.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0168.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0169.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0170.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0171.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0172.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0173.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0174.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0175.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0176.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0177.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0178.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0179.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0180.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0181.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0182.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0183.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0184.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0185.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0186.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0187.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0188.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0189.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0190.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0191.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0192.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0193.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0194.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/uV0195.img,1'
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
% FACES ~SMOOTHING
% Dependencies include wuV00* images created after normalization.  
%-----------------------------------------------------------------------
matlabbatch{4}.spm.spatial.smooth.data = {
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0001.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0002.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0003.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0004.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0005.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0006.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0007.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0008.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0009.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0010.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0011.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0012.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0013.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0014.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0015.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0016.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0017.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0018.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0019.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0020.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0021.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0022.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0023.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0024.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0025.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0026.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0027.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0028.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0029.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0030.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0031.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0032.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0033.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0034.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0035.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0036.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0037.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0038.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0039.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0040.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0041.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0042.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0043.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0044.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0045.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0046.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0047.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0048.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0049.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0050.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0051.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0052.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0053.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0054.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0055.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0056.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0057.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0058.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0059.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0060.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0061.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0062.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0063.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0064.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0065.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0066.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0067.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0068.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0069.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0070.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0071.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0072.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0073.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0074.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0075.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0076.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0077.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0078.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0079.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0080.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0081.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0082.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0083.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0084.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0085.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0086.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0087.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0088.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0089.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0090.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0091.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0092.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0093.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0094.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0095.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0096.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0097.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0098.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0099.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0100.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0101.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0102.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0103.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0104.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0105.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0106.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0107.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0108.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0109.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0110.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0111.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0112.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0113.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0114.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0115.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0116.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0117.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0118.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0119.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0120.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0121.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0122.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0123.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0124.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0125.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0126.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0127.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0128.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0129.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0130.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0131.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0132.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0133.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0134.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0135.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0136.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0137.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0138.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0139.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0140.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0141.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0142.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0143.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0144.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0145.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0146.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0147.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0148.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0149.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0150.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0151.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0152.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0153.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0154.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0155.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0156.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0157.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0158.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0159.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0160.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0161.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0162.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0163.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0164.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0165.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0166.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0167.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0168.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0169.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0170.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0171.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0172.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0173.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0174.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0175.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0176.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0177.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0178.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0179.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0180.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0181.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0182.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0183.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0184.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0185.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0186.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0187.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0188.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0189.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0190.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0191.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0192.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0193.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0194.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/wuV0195.img,1'
                                          };

matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's';

%-----------------------------------------------------------------------
% FACES ~SINGLE SUBJECT PROCESSING
% Sets up the design and runs single subject processing.  Dependencies 
% include swuV00* images created after smoothing. Output goes to 
% faces_pfl under Analysis/SPM/Analyzed
%-----------------------------------------------------------------------

matlabbatch{5}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/faces_pfl'};
matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0128.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0129.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0130.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0131.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0132.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0133.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0134.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0135.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0136.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0137.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0138.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0139.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0140.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0141.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0142.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0143.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0144.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0145.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0146.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0147.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0148.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0149.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0150.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0151.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0152.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0153.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0154.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0155.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0156.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0157.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0158.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0159.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0160.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0161.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0162.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0163.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0164.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0165.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0166.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0167.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0168.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0169.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0170.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0171.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0172.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0173.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0174.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0175.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0176.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0177.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0178.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0179.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0180.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0181.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0182.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0183.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0184.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0185.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0186.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0187.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0188.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0189.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0190.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0191.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0192.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0193.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0194.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0195.img,1'
                                                 };

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).onset = [0
                                                          44
                                                          88
                                                          132
                                                          176];
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).duration = 19;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).name = 'Faces1';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).onset = 19;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).duration = 25;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).name = 'Faces2';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).onset = 63;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).duration = 25;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).name = 'Faces3';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).onset = 107;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).duration = 25;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).name = 'Faces4';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).onset = 151;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).duration = 25;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
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
matlabbatch{6}.spm.stats.fmri_est.spmmat = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/faces_pfl/SPM.mat'};
matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;


%-----------------------------------------------------------------------
% FACES JOB SUBMIT!
% After setting up the matlabbatch above, we finally run it for faces
%-----------------------------------------------------------------------
spm_jobman('run_nogui',matlabbatch)

%Now we clear matlabbatch to do cards
clear matlabbatch

end

%-----------------------------------------------------------------------
% CARDS PROCESSING
% 
% The section section does rewind & unwarp, cogregistration, normalization,
% and smoothing for the cards data.  If the user has not specified to
% process cards, this section is skipped.
%-----------------------------------------------------------------------

% Make sure that we are in the subjects cards output directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards'));

%-----------------------------------------------------------------------
% CARDS ~REALIGN AND UNWARP 
%-----------------------------------------------------------------------

% Check if the user wants to process cards data:
if strcmp('SUB_RUNCARDS_SUB', 'yes')

spm('defaults','fmri')
spm_jobman('initcfg');

    
matlabbatch{1}.spm.spatial.realignunwarp.data.scans = {
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0001.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0002.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0003.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0004.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0005.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0006.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0007.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0008.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0009.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0010.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0011.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0012.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0013.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0014.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0015.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0016.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0017.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0018.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0019.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0020.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0021.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0022.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0023.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0024.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0025.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0026.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0027.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0028.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0029.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0030.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0031.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0032.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0033.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0034.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0035.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0036.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0037.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0038.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0039.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0040.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0041.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0042.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0043.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0044.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0045.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0046.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0047.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0048.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0049.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0050.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0051.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0052.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0053.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0054.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0055.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0056.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0057.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0058.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0059.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0060.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0061.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0062.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0063.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0064.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0065.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0066.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0067.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0068.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0069.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0070.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0071.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0072.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0073.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0074.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0075.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0076.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0077.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0078.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0079.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0080.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0081.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0082.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0083.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0084.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0085.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0086.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0087.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0088.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0089.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0090.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0091.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0092.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0093.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0094.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0095.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0096.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0097.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0098.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0099.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0100.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0101.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0102.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0103.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0104.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0105.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0106.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0107.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0108.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0109.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0110.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0111.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0112.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0113.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0114.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0115.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0116.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0117.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0118.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0119.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0120.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0121.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0122.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0123.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0124.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0125.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0126.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0127.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0128.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0129.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0130.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0131.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0132.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0133.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0134.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0135.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0136.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0137.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0138.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0139.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0140.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0141.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0142.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0143.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0144.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0145.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0146.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0147.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0148.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0149.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0150.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0151.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0152.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0153.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0154.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0155.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0156.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0157.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0158.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0159.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0160.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0161.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0162.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0163.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0164.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0165.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0166.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0167.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0168.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0169.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0170.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/V0171.img,1'
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
% CARDS ~COGREGISTRATION
% Dependencies include c1* image copied into cards from anat in
% spm_batch1.m, and meanuV0001.img created during realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/meanuV0001.img,1'};
matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/c1sdns01-0002-00001-000001-01.img,1'};

matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];


%-----------------------------------------------------------------------
% CARDS ~NORMALIZATION
% Dependencies include c1* image copied into cards from anat in
% spm_batch1.m, and 171 uV00* images created after realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/c1sdns01-0002-00001-000001-01.img,1'};
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.resample = {
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0001.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0002.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0003.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0004.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0005.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0006.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0007.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0008.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0009.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0010.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0011.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0012.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0013.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0014.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0015.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0016.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0017.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0018.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0019.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0020.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0021.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0022.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0023.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0024.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0025.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0026.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0027.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0028.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0029.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0030.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0031.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0032.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0033.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0034.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0035.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0036.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0037.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0038.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0039.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0040.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0041.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0042.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0043.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0044.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0045.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0046.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0047.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0048.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0049.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0050.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0051.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0052.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0053.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0054.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0055.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0056.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0057.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0058.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0059.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0060.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0061.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0062.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0063.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0064.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0065.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0066.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0067.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0068.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0069.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0070.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0071.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0072.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0073.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0074.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0075.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0076.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0077.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0078.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0079.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0080.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0081.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0082.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0083.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0084.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0085.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0086.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0087.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0088.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0089.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0090.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0091.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0092.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0093.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0094.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0095.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0096.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0097.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0098.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0099.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0100.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0101.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0102.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0103.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0104.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0105.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0106.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0107.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0108.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0109.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0110.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0111.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0112.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0113.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0114.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0115.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0116.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0117.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0118.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0119.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0120.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0121.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0122.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0123.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0124.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0125.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0126.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0127.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0128.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0129.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0130.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0131.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0132.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0133.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0134.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0135.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0136.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0137.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0138.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0139.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0140.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0141.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0142.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0143.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0144.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0145.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0146.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0147.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0148.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0149.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0150.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0151.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0152.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0153.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0154.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0155.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0156.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0157.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0158.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0159.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0160.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0161.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0162.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0163.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0164.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0165.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0166.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0167.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0168.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0169.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0170.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/uV0171.img,1'
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
% CARDS ~SMOOTHING
% Dependencies include wuV00* images created after normalization.  
%-----------------------------------------------------------------------
matlabbatch{4}.spm.spatial.smooth.data = {
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0001.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0002.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0003.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0004.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0005.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0006.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0007.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0008.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0009.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0010.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0011.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0012.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0013.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0014.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0015.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0016.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0017.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0018.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0019.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0020.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0021.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0022.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0023.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0024.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0025.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0026.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0027.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0028.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0029.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0030.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0031.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0032.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0033.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0034.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0035.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0036.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0037.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0038.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0039.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0040.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0041.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0042.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0043.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0044.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0045.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0046.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0047.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0048.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0049.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0050.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0051.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0052.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0053.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0054.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0055.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0056.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0057.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0058.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0059.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0060.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0061.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0062.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0063.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0064.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0065.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0066.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0067.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0068.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0069.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0070.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0071.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0072.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0073.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0074.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0075.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0076.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0077.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0078.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0079.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0080.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0081.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0082.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0083.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0084.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0085.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0086.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0087.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0088.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0089.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0090.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0091.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0092.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0093.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0094.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0095.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0096.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0097.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0098.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0099.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0100.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0101.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0102.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0103.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0104.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0105.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0106.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0107.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0108.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0109.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0110.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0111.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0112.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0113.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0114.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0115.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0116.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0117.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0118.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0119.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0120.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0121.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0122.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0123.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0124.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0125.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0126.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0127.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0128.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0129.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0130.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0131.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0132.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0133.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0134.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0135.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0136.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0137.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0138.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0139.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0140.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0141.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0142.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0143.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0144.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0145.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0146.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0147.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0148.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0149.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0150.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0151.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0152.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0153.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0154.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0155.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0156.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0157.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0158.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0159.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0160.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0161.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0162.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0163.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0164.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0165.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0166.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0167.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0168.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0169.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0170.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/wuV0171.img,1'
                                          };

matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's';

%-----------------------------------------------------------------------
% CARDS ~SINGLE SUBJECT PROCESSING
% Sets up the design and runs single subject processing.  Dependencies 
% include swuV00* images created after smoothing. Output goes to 
% cards_pfl under Analysis/SPM/Analyzed
%-----------------------------------------------------------------------

matlabbatch{5}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/cards_pfl'};
matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0128.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0129.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0130.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0131.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0132.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0133.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0134.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0135.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0136.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0137.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0138.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0139.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0140.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0141.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0142.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0143.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0144.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0145.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0146.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0147.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0148.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0149.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0150.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0151.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0152.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0153.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0154.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0155.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0156.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0157.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0158.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0159.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0160.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0161.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0162.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0163.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0164.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0165.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0166.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0167.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0168.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0169.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0170.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0171.img,1'
                                                 };

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).name = 'Control';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).onset = [38
                                                         95
                                                         152];
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).duration = 19;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).name = 'Positive Feedback';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).onset = [0
                                                         57
                                                         114];
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).duration = 19;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).name = 'Negative Feedback';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).onset = [19
                                                         76
                                                         133];
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).duration = 19;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
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
matlabbatch{6}.spm.stats.fmri_est.spmmat = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/cards_pfl/SPM.mat'};
matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;

%-----------------------------------------------------------------------
% CARDS JOB SUBMIT!
% After setting up the matlabbatch above, we finally run it for cards
%-----------------------------------------------------------------------
spm_jobman('run_nogui',matlabbatch)

%Now we clear matlabbatch to do cards
clear matlabbatch

end

%-----------------------------------------------------------------------
% RESTING BOLD PROCESSING
% 
% The section section does rewind & unwarp, cogregistration, normalization,
% and smoothing for the rest data.  If the user has not specified to
% process resting bold, this section is skipped.
%-----------------------------------------------------------------------

% Make sure that we are in the subjects rest output directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/rest'));

%-----------------------------------------------------------------------
% REST ~REALIGN AND UNWARP 
%-----------------------------------------------------------------------

% Check if the user wants to process rest data:
if strcmp('SUB_RUNREST_SUB', 'yes')

spm('defaults','fmri')
spm_jobman('initcfg');
    
matlabbatch{1}.spm.spatial.realignunwarp.data.scans = {
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0001.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0002.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0003.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0004.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0005.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0006.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0007.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0008.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0009.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0010.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0011.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0012.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0013.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0014.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0015.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0016.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0017.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0018.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0019.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0020.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0021.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0022.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0023.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0024.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0025.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0026.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0027.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0028.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0029.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0030.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0031.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0032.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0033.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0034.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0035.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0036.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0037.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0038.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0039.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0040.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0041.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0042.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0043.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0044.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0045.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0046.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0047.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0048.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0049.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0050.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0051.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0052.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0053.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0054.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0055.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0056.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0057.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0058.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0059.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0060.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0061.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0062.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0063.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0064.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0065.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0066.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0067.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0068.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0069.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0070.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0071.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0072.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0073.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0074.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0075.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0076.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0077.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0078.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0079.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0080.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0081.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0082.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0083.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0084.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0085.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0086.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0087.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0088.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0089.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0090.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0091.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0092.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0093.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0094.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0095.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0096.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0097.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0098.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0099.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0100.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0101.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0102.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0103.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0104.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0105.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0106.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0107.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0108.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0109.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0110.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0111.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0112.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0113.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0114.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0115.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0116.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0117.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0118.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0119.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0120.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0121.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0122.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0123.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0124.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0125.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0126.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0127.img,1'
                                                       'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/V0128.img,1'
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
% REST ~COGREGISTRATION
% Dependencies include c1* image copied into rest from anat in
% spm_batch1.m, and meanuV0001.img created during realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{2}.spm.spatial.coreg.estimate.ref = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/meanuV0001.img,1'};
matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/c1sdns01-0002-00001-000001-01.img,1'};

matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];


%-----------------------------------------------------------------------
% REST ~NORMALIZATION
% Dependencies include c1* image copied into faces from anat in
% spm_batch1.m, and 128 uV00* images created after realign & unwarp
%-----------------------------------------------------------------------
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/c1sdns01-0002-00001-000001-01.img,1'};
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.resample = {
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0001.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0002.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0003.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0004.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0005.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0006.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0007.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0008.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0009.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0010.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0011.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0012.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0013.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0014.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0015.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0016.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0017.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0018.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0019.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0020.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0021.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0022.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0023.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0024.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0025.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0026.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0027.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0028.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0029.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0030.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0031.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0032.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0033.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0034.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0035.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0036.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0037.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0038.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0039.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0040.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0041.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0042.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0043.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0044.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0045.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0046.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0047.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0048.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0049.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0050.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0051.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0052.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0053.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0054.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0055.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0056.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0057.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0058.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0059.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0060.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0061.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0062.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0063.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0064.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0065.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0066.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0067.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0068.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0069.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0070.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0071.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0072.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0073.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0074.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0075.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0076.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0077.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0078.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0079.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0080.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0081.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0082.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0083.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0084.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0085.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0086.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0087.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0088.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0089.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0090.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0091.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0092.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0093.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0094.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0095.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0096.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0097.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0098.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0099.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0100.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0101.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0102.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0103.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0104.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0105.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0106.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0107.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0108.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0109.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0110.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0111.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0112.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0113.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0114.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0115.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0116.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0117.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0118.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0119.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0120.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0121.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0122.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0123.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0124.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0125.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0126.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0127.img,1'
                                                               'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/uV0128.img,1'
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
% REST ~SMOOTHING
% Dependencies include wuV00* images created after normalization.  
%-----------------------------------------------------------------------
matlabbatch{4}.spm.spatial.smooth.data = {
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0001.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0002.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0003.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0004.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0005.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0006.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0007.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0008.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0009.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0010.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0011.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0012.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0013.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0014.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0015.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0016.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0017.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0018.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0019.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0020.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0021.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0022.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0023.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0024.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0025.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0026.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0027.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0028.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0029.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0030.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0031.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0032.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0033.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0034.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0035.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0036.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0037.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0038.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0039.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0040.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0041.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0042.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0043.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0044.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0045.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0046.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0047.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0048.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0049.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0050.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0051.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0052.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0053.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0054.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0055.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0056.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0057.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0058.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0059.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0060.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0061.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0062.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0063.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0064.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0065.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0066.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0067.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0068.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0069.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0070.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0071.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0072.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0073.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0074.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0075.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0076.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0077.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0078.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0079.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0080.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0081.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0082.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0083.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0084.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0085.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0086.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0087.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0088.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0089.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0090.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0091.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0092.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0093.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0094.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0095.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0096.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0097.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0098.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0099.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0100.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0101.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0102.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0103.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0104.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0105.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0106.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0107.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0108.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0109.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0110.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0111.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0112.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0113.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0114.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0115.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0116.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0117.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0118.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0119.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0120.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0121.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0122.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0123.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0124.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0125.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0126.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0127.img,1'
                                          'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/wuV0128.img,1'
                                          };

matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{4}.spm.spatial.smooth.dtype = 0;
matlabbatch{4}.spm.spatial.smooth.prefix = 's';

%-----------------------------------------------------------------------
% REST ~SINGLE SUBJECT PROCESSING
% Sets up the design and runs single subject processing.  Dependencies 
% include swuV00* images created after smoothing. Output goes to 
% rest_pfl under Analysis/SPM/Analyzed
%-----------------------------------------------------------------------

matlabbatch{5}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/rest_pfl'};
matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{5}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/rest/swuV0128.img,1'
                                                 };

matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).name = 'First Half';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).onset = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).duration = 64;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).name = 'Second Half';
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).onset = 64;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).duration = 64;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
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
matlabbatch{6}.spm.stats.fmri_est.spmmat = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/rest_pfl/SPM.mat'};
matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;

%-----------------------------------------------------------------------
% REST JOB SUBMIT!
% After setting up the matlabbatch above, we finally run it for rest
%-----------------------------------------------------------------------
spm_jobman('run_nogui',matlabbatch)

%Now we clear matlabbatch
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

%Randomly generates 12 numbers between 1 and 171.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the cards ProcessedData folder
%for this single subject.
if strcmp('SUB_RUNCARDS_SUB','yes')
    i = 171;
    
    %This allocates a spot in memory for the array so that it doesn't have
    %to find a new spot for every iteration of the loop. 
    chreg_cards=char(12,104);
    
    f = ceil(i.*rand(12,1));
    for j = 1:12
        if f(j) < 10
            chreg_cards(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards/swuV000',num2str(f(j)),'.img,1');
        end
        if f(j) >=10
            if f(j) < 100
                chreg_cards(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards/swuV00',num2str(f(j)),'.img,1');
            end
        end
        if f(j) >=100
            chreg_cards(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards/swuV0',num2str(f(j)),'.img,1');
        end
    end

spm_check_registration(chreg_cards)
%spm_print will print a *.ps of the 12 smoothed images files to the same
%*.ps file it created for the other components of the pre-processing
spm_print
end

%Randomly generates 12 numbers between 1 and 195.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the faces ProcessedData folder
%for this single subject.
if strcmp('SUB_RUNFACES_SUB','yes')
    
    %This allocates a spot in memory for the array so that it doesn't have
    %to find a new spot for every iteration of the loop. 
    chreg_faces=char(12,104);
    
    i = 195;
    f = ceil(i.*rand(12,1));
    for j = 1:12
        if f(j) < 10
            chreg_faces(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV000',num2str(f(j)),'.img,1');
        end
        if f(j) >=10
            if f(j) < 100
                chreg_faces(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV00',num2str(f(j)),'.img,1');
            end
        end
        if f(j) >=100
            chreg_faces(j,1:104) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV0',num2str(f(j)),'.img,1');
        end
    end
spm_check_registration(chreg_faces)
%spm_print will print a *.ps of the 12 smoothed images files to the same
%*.ps file it created for the other components of the pre-processing
spm_print
end

%Randomly generates 12 numbers between 1 and 128.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the rest ProcessedData folder
%for this single subject.
if strcmp('SUB_RUNREST_SUB','yes')
    i = 128;
    
    %This allocates a spot in memory for the array so that it doesn't have
    %to find a new spot for every iteration of the loop.
    chreg_rest=char(12,103);
    
    f = ceil(i.*rand(12,1));
    for j = 1:12
        if f(j) < 10
            chreg_rest(j,1:103) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/rest/swuV000',num2str(f(j)),'.img,1');
        end
        if f(j) >=10
            if f(j) < 100
                chreg_rest(j,1:103) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/rest/swuV00',num2str(f(j)),'.img,1');
            end
        end
        if f(j) >=100
            chreg_rest(j,1:103) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/rest/swuV0',num2str(f(j)),'.img,1');
        end
    end

spm_check_registration(chreg_rest)
%spm_print will print a *.ps of the 12 smoothed images files to the same
%*.ps file it created for the other components of the pre-processing
spm_print
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

%-----------------------------------------------------------------------
% ARTBATCH - CARDS
%-----------------------------------------------------------------------

if strcmp('SUB_RUNCARDS_SUB', 'yes')
    
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/cards_pfl'))
art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/cards_pfl/SPM.mat'));

end


%-----------------------------------------------------------------------
% ARTBATCH - FACES
%-----------------------------------------------------------------------

if strcmp('SUB_RUNFACES_SUB', 'yes')
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl'))
art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl/SPM.mat'));

end

%-----------------------------------------------------------------------
% ARTBATCH - REST
%-----------------------------------------------------------------------

if strcmp('SUB_RUNREST_SUB', 'yes')
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/rest_pfl'))
art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/rest_pfl/SPM.mat'));

end

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))
%Check whether the folders 'cards', 'faces', or 'rest' exist within the
%single subject Analyzed Data folder.  If not, it creates them.  The single
%subject design matrices with these folders will incorporate the art output
%when necessary.
if strcmp('SUB_RUNCARDS_SUB','yes')
    if isdir('cards')==0
        sprintf('%s','Currently no cards folder exists.  Creating cards within single subject AnalyzedData folder.')
        mkdir cards
    end
end

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('Faces')==0
        sprintf('%s','Currently no faces folder exists.  Creating faces within single subject AnalyzedData folder.')
        mkdir Faces
    end
end

if strcmp('SUB_RUNREST_SUB','yes')
    if isdir('rest')==0
        sprintf('%s','Currently no rest folder exists.  Creating rest within single subject AnalyzedData folders.')
        mkdir rest
    end
end


%-----------------------------------------------------------------------
% ART for CARDS
% Calculates artifact detection for cards and creates a single
% subject design matrix that include the outputs from art_batch
%-----------------------------------------------------------------------

% Check if the user is processing cards data:
if strcmp('SUB_RUNCARDS_SUB', 'yes')
    
spm('defaults','fmri')
spm_jobman('initcfg');

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards'))

matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/cards/'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0128.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0129.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0130.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0131.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0132.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0133.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0134.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0135.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0136.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0137.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0138.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0139.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0140.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0141.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0142.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0143.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0144.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0145.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0146.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0147.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0148.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0149.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0150.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0151.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0152.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0153.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0154.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0155.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0156.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0157.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0158.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0159.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0160.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0161.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0162.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0163.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0164.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0165.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0166.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0167.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0168.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0169.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0170.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/cards/swuV0171.img,1'
                                                 };

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Control';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [38
                                                         95
                                                         152];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Positive Feedback';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = [0
                                                         57
                                                         114];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Negative Feedback';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = [19
                                                         76
                                                         133];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards/art_regression_outliers_swuV0001.mat')};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/cards/SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/cards/SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Positive Feedback > Negative Feedback';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Negative Feedback > Positive Feedback';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Positive Feedback > Control';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [-1 1 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Negative Feedback > Control';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 0 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%We submit the job
spm_jobman('run_nogui',matlabbatch)
%and clear matlabbatch for the next job
clear matlabbatch

end

%-----------------------------------------------------------------------
% ART for FACES
% Calculates artifact detection for cards and creates a single
% subject design matrix that include the outputs from art_batch
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
% Faces BLOCK design
%-----------------------------------------------------------------------

% Check if the user is processing faces data:
if strcmp('SUB_RUNFACES_SUB', 'yes')

spm('defaults','fmri')
spm_jobman('initcfg');

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/'))
mkdir Faces
cd Faces
mkdir block

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/Faces/block'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0128.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0129.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0130.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0131.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0132.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0133.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0134.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0135.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0136.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0137.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0138.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0139.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0140.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0141.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0142.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0143.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0144.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0145.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0146.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0147.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0148.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0149.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0150.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0151.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0152.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0153.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0154.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0155.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0156.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0157.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0158.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0159.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0160.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0161.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0162.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0163.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0164.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0165.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0166.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0167.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0168.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0169.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0170.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0171.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0172.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0173.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0174.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0175.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0176.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0177.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0178.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0179.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0180.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0181.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0182.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0183.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0184.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0185.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0186.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0187.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0188.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0189.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0190.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0191.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0192.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0193.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0194.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0195.img,1'
                                                 };

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [0
                                                         44
                                                         88
                                                         132
                                                         176];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Neutral Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 25;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Fearful Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = 63;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 25;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Surprise Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = 107;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 25;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'Angry Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = 151;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 25;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/art_regression_outliers_swuV0001.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block/SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block/SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [-1 .25 .25 .25 .25];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Fearful Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 0 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Angry Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [-1 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Neutral Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Surprise Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [-1 0 0 1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Fearful Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 1 0 -1];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Fearful Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Fearful Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Angry Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 0 -1 0 1];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Angry Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 -1 0 0 1];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Angry Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Neutral Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Neutral Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 1 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Neutral Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.convec = [0 1 0 -1];
matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Surprise Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.convec = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Surprise Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.convec = [0 0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'Surprise Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.convec = [0 -1 0 1];
matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'Block 1+2 > Block 3+4';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.convec = [0 .5 .5 -.5 -.5];
matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'Block 3+4 > Block 1+2';
matlabbatch{3}.spm.stats.con.consess{19}.tcon.convec = [0 -.5 -.5 .5 .5];
matlabbatch{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'Block 1 > Block 2';
matlabbatch{3}.spm.stats.con.consess{20}.tcon.convec = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'Block 3 > Block 4';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.convec = [0 0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'Block 4 > Block 3';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.convec = [0 0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'Block 2 > Block 1';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.convec = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{24}.tcon.name = 'Block 2 > Block 3';
matlabbatch{3}.spm.stats.con.consess{24}.tcon.convec = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.name = 'Block 3 > Block 2';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.convec = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.name = 'Block 1 > 2 > 3 > 4';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.convec = [0 .75 .25 -.25 -.75];
matlabbatch{3}.spm.stats.con.consess{26}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.name = 'Block 4 > 3 > 2 > 1';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.convec = [0 -.75 -.25 .25 .75];
matlabbatch{3}.spm.stats.con.consess{27}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.name = 'Angry+Fearful > Shapes';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.convec = [-1 0 .5 0 .5];
matlabbatch{3}.spm.stats.con.consess{28}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{29}.tcon.name = 'Surprise+Neutral > Shapes';
matlabbatch{3}.spm.stats.con.consess{29}.tcon.convec = [-1 .5 0 .5 0];
matlabbatch{3}.spm.stats.con.consess{29}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.name = 'Angry+Fearful > Surprise+Neutral';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.convec = [0 -.5 .5 -.5 .5];
matlabbatch{3}.spm.stats.con.consess{30}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.name = 'Surprise+Neutral > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.convec = [0 .5 -.5 .5 -.5];
matlabbatch{3}.spm.stats.con.consess{31}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{32}.tcon.name = 'Angry+Fearful > Neutral';
matlabbatch{3}.spm.stats.con.consess{32}.tcon.convec = [0 -1 .5 0 .5];
matlabbatch{3}.spm.stats.con.consess{32}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.name = 'Neutral > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.convec = [0 1 -.5 0 -.5];
matlabbatch{3}.spm.stats.con.consess{33}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.name = 'Angry+Fearful > Surprise';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.convec = [0 0 .5 -1 .5];
matlabbatch{3}.spm.stats.con.consess{34}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{35}.tcon.name = 'Surprise > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{35}.tcon.convec = [0 0 -.5 1 -.5];
matlabbatch{3}.spm.stats.con.consess{35}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.name = 'Shapes > Faces';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.convec = [1 -.25 -.25 -.25 -.25];
matlabbatch{3}.spm.stats.con.consess{36}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%We submit the job
spm_jobman('run_nogui',matlabbatch)
%and clear matlabbatch for the next job
clear matlabbatch

%-----------------------------------------------------------------------
% Faces AFFECT design
%-----------------------------------------------------------------------

spm('defaults','fmri')
spm_jobman('initcfg');

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/'))
cd Faces
mkdir affect

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/Faces/affect'};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0001.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0002.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0003.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0004.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0005.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0006.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0007.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0008.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0009.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0010.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0011.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0012.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0013.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0014.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0015.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0016.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0017.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0018.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0019.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0020.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0021.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0022.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0023.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0024.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0025.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0026.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0027.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0028.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0029.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0030.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0031.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0032.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0033.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0034.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0035.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0036.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0037.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0038.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0039.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0040.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0041.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0042.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0043.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0044.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0045.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0046.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0047.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0048.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0049.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0050.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0051.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0052.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0053.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0054.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0055.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0056.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0057.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0058.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0059.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0060.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0061.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0062.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0063.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0064.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0065.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0066.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0067.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0068.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0069.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0070.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0071.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0072.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0073.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0074.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0075.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0076.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0077.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0078.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0079.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0080.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0081.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0082.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0083.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0084.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0085.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0086.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0087.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0088.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0089.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0090.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0091.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0092.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0093.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0094.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0095.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0096.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0097.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0098.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0099.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0100.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0101.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0102.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0103.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0104.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0105.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0106.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0107.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0108.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0109.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0110.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0111.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0112.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0113.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0114.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0115.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0116.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0117.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0118.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0119.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0120.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0121.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0122.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0123.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0124.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0125.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0126.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0127.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0128.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0129.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0130.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0131.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0132.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0133.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0134.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0135.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0136.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0137.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0138.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0139.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0140.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0141.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0142.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0143.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0144.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0145.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0146.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0147.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0148.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0149.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0150.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0151.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0152.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0153.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0154.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0155.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0156.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0157.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0158.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0159.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0160.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0161.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0162.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0163.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0164.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0165.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0166.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0167.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0168.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0169.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0170.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0171.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0172.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0173.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0174.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0175.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0176.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0177.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0178.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0179.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0180.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0181.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0182.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0183.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0184.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0185.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0186.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0187.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0188.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0189.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0190.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0191.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0192.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0193.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0194.img,1'
                                                 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/swuV0195.img,1'
                                                 };

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [0
                                                         44
                                                         88
                                                         132
                                                         176];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 19;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Neutral Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = [20
                                                         23
                                                         27
                                                         32
                                                         36
                                                         41];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Fearful Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = [64
                                                         67
                                                         72
                                                         76
                                                         81
                                                         85];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Surprise Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = [108
                                                         112
                                                         117
                                                         121
                                                         124
                                                         129];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'Angry Faces';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = [152
                                                         155
                                                         159
                                                         164
                                                         169
                                                         172];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 2;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/art_regression_outliers_swuV0001.mat'};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/affect/SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/affect/SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [-1 .25 .25 .25 .25];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Fearful Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 0 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Angry Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [-1 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Neutral Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 1];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Surprise Faces > Shapes';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [-1 0 0 1];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Fearful Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 1 0 -1];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Fearful Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Fearful Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Angry Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 0 -1 0 1];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Angry Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 -1 0 0 1];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Angry Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Neutral Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Neutral Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 1 0 0 -1];
matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Neutral Faces > Surprise Faces';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.convec = [0 1 0 -1];
matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Surprise Faces > Fearful Faces';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.convec = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Surprise Faces > Angry Faces';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.convec = [0 0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'Surprise Faces > Neutral Faces';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.convec = [0 -1 0 1];
matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'Block 1+2 > Block 3+4';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.convec = [0 .5 .5 -.5 -.5];
matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'Block 3+4 > Block 1+2';
matlabbatch{3}.spm.stats.con.consess{19}.tcon.convec = [0 -.5 -.5 .5 .5];
matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'Block 1 > Block 2';
matlabbatch{3}.spm.stats.con.consess{20}.tcon.convec = [0 1 -1];
matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'Block 3 > Block 4';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.convec = [0 0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'Block 4 > Block 3';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.convec = [0 0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'Block 2 > Block 1';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.convec = [0 -1 1];
matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{24}.tcon.name = 'Block 2 > Block 3';
matlabbatch{3}.spm.stats.con.consess{24}.tcon.convec = [0 0 1 -1];
matlabbatch{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.name = 'Block 3 > Block 2';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.convec = [0 0 -1 1];
matlabbatch{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.name = 'Block 1 > 2 > 3 > 4';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.convec = [0 .75 .25 -.25 -.75];
matlabbatch{3}.spm.stats.con.consess{26}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.name = 'Block 4 > 3 > 2 > 1';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.convec = [0 -.75 -.25 .25 .75];
matlabbatch{3}.spm.stats.con.consess{27}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.name = 'Angry+Fearful > Shapes';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.convec = [-1 0 .5 0 .5];
matlabbatch{3}.spm.stats.con.consess{28}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{29}.tcon.name = 'Surprise+Neutral > Shapes';
matlabbatch{3}.spm.stats.con.consess{29}.tcon.convec = [-1 .5 0 .5 0];
matlabbatch{3}.spm.stats.con.consess{29}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.name = 'Angry+Fearful > Surprise+Neutral';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.convec = [0 -.5 .5 -.5 .5];
matlabbatch{3}.spm.stats.con.consess{30}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.name = 'Surprise+Neutral > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.convec = [0 .5 -.5 .5 -.5];
matlabbatch{3}.spm.stats.con.consess{31}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{32}.tcon.name = 'Angry+Fearful > Neutral';
matlabbatch{3}.spm.stats.con.consess{32}.tcon.convec = [0 -1 .5 0 .5];
matlabbatch{3}.spm.stats.con.consess{32}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.name = 'Neutral > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.convec = [0 1 -.5 0 -.5];
matlabbatch{3}.spm.stats.con.consess{33}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.name = 'Angry+Fearful > Surprise';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.convec = [0 0 .5 -1 .5];
matlabbatch{3}.spm.stats.con.consess{34}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{35}.tcon.name = 'Surprise > Angry+Fearful';
matlabbatch{3}.spm.stats.con.consess{35}.tcon.convec = [0 0 -.5 1 -.5];
matlabbatch{3}.spm.stats.con.consess{35}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.name = 'Shapes > Faces';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.convec = [1 -.25 -.25 -.25 -.25];
matlabbatch{3}.spm.stats.con.consess{36}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%We submit the job
spm_jobman('run_nogui',matlabbatch)
%and clear matlabbatch for the next job
clear matlabbatch


end

%-----------------------------------------------------------------------
% CLEANUP and SPM.mat path changing
% Here we go back to the Processed directory, and delete the copied
% over V000* images, the uV00*, and wuV00* images, to save space.  We
% also go to the output directories and change the SPM.mat paths so they
% will work on the local machine!
%-----------------------------------------------------------------------

if strcmp('SUB_RUNCARDS_SUB', 'yes')
    
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/cards'))

%if we are only processing functionals, then we don't want to delete the
%original V00 images, because we probably had to manually re-set the origin
%and re-align these images to that setting, so we don't want to delete them
%in case we need them again.

if strcmp('SUB_ONLYDOFUNC_SUB','no')
delete V0*
end

delete uV0*
delete wuV0*

% Fixing paths for cards_pfl SPM.mat
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/cards_pfl'))
spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','N:/DNS.01/','/');

% Fixing paths for Cards SPM.mat
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Cards'))
spm_change_paths('SUB_MOUNT_SUB/','N:/DNS.01/','/');

end

if strcmp('SUB_RUNFACES_SUB', 'yes')
    
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

if strcmp('SUB_ONLYDOFUNC_SUB','no')
delete V0*
end

delete uV0*
delete wuV0*

% Fixing paths for faces_pfl
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl'))
spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','N:/DNS.01/','/');

% Fixing paths for Faces/block
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block'))
spm_change_paths('SUB_MOUNT_SUB/','N:/DNS.01/','/');

% Fixing paths for Faces/affect
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/affect'))
spm_change_paths('SUB_MOUNT_SUB/','N:/DNS.01/','/');

end


if strcmp('SUB_RUNREST_SUB', 'yes')
    
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/rest'))

if strcmp('SUB_ONLYDOFUNC_SUB','no')
delete V0*
end

delete uV0*
delete wuV0*

% Fixing paths for rest_pfl
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/rest_pfl'))
spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','N:/DNS.01/','/');

end

exit