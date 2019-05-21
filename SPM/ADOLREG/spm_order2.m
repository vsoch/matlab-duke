%-----------------------------------------------------------------------
% SPM BATCH ADOLREG.01 ORDER 2 (NFSA) comes after spm_batch1.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_TEMPLATE.sh from the head node of BIAC
%
% Output contrasts are as follows:
%
% FACES: Faces > Shapes (1), Fearful Faces > Shapes (2), Neutral Faces >
% Shapes (3), Surprise Faces > Shapes (4) for both affect and block design.  
% For complete contrasts, please see ADOLREG excel. 
%
%    The Laboratory of Neurogenetics, 2010
%       By Vanessa Sochat, Duke University
%
% 5/24/11: Modified by Annchen to include 'pathlength' variable to
% allow for different users
%-----------------------------------------------------------------------

% Suppress 'beep.m' name confict warning, beware that this might suppress something relevant!!
warning('off', 'MATLAB:dispatcher:nameConflict');
fprintf('\n**Note: MATLAB:dispatcher:nameConflict warnings have been suppressed**\n');

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
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB'));

%Here we set some directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';

%-----------------------------------------------------------------------
% ANAT COPY
% 
% Here we are copying our anatomicals into each functional directory for
% registration.
% ----------------------------------------------------------------------

    
if strcmp('SUB_RUNFACES_SUB', 'yes')
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sadolreg01-0400-00001-000001-01.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1sadolreg01-0400-00001-000001-01.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
end

%-----------------------------------------------------------------------
% FACES PROCESSING
% 
% The first section does rewind & unwarp, cogregistration, normalization,
% and smoothing for the faces data.  If the user has not specified to
% process faces, this section is skipped.
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
% FACES ~REALIGN AND UNWARP 
%-----------------------------------------------------------------------

% Check if the user wants to process faces data:
if strcmp('SUB_RUNFACES_SUB', 'yes')

% Make sure that we are in the subjects faces output directory
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'));

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
matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1sadolreg01-0400-00001-000001-01.img,1'};

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
matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1sadolreg01-0400-00001-000001-01.img,1'};
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
matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50;
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
pathlength = 100 + SUB_USRNAMELEN_SUB; % needed to allocate correct amount of array space

%Randomly generates 12 numbers between 1 and 195.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the faces ProcessedData folder
%for this single subject.
if strcmp('SUB_RUNFACES_SUB','yes')
    
    %This allocates a spot in memory for the array so that it doesn't have
    %to find a new spot for every iteration of the loop. 
    chreg_faces=char(12,pathlength);
    
    i = 195;
    f = ceil(i.*rand(12,1));
    for j = 1:12
        if f(j) < 10
            chreg_faces(j,1:pathlength) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV000',num2str(f(j)),'.img,1');
        end
        if f(j) >=10
            if f(j) < 100
                chreg_faces(j,1:pathlength) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV00',num2str(f(j)),'.img,1');
            end
        end
        if f(j) >=100
            chreg_faces(j,1:pathlength) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV0',num2str(f(j)),'.img,1');
        end
    end
spm_check_registration(chreg_faces)
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
% ARTBATCH - FACES
%-----------------------------------------------------------------------

if strcmp('SUB_RUNFACES_SUB', 'yes')
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl'))
art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl/SPM.mat'));

end

cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))
%Check whether the folders 'cards', 'faces', or 'rest' exist within the
%single subject Analyzed Data folder.  If not, it creates them.  The single
%subject design matrices with these folders will incorporate the art output
%when necessary.

if strcmp('SUB_RUNFACES_SUB','yes')
    if isdir('Faces')==0
        sprintf('%s','Currently no faces folder exists.  Creating faces within single subject AnalyzedData folder.')
        mkdir Faces
    end
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

if strcmp('SUB_RUNFACES_SUB', 'yes')
    
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

delete V0*
delete uV0*
delete wuV0*

% Fixing paths for faces_pfl
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl'))
spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','F:/AdolReg.01/','/');

% Fixing paths for Faces/block
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block'))
spm_change_paths('SUB_MOUNT_SUB/','F:/AdolReg.01/','/');

% Fixing paths for Faces/affect
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/affect'))
spm_change_paths('SUB_MOUNT_SUB/','F:/AdolReg.01/','/');

end

exit