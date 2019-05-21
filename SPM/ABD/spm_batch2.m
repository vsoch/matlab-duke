%-----------------------------------------------------------------------
% SPM BATCH ABD comes after spm_batch1.m
%
% These template scripts are filled in and run by a bash script,
% spm_batch_ABD_TEMPLATE.sh from the head node of BIAC
%
%    The Laboratory of Neurogenetics, 2010
%       By Vanessa Sochat, Duke University
%-----------------------------------------------------------------------

% Add necessary paths for BIAC, then SPM and data folders
BIACroot = 'SUB_BIACROOT_SUB'; startm=fullfile(BIACroot,'startup.m');
if exist(startm,'file'); run(startm); else warning(sprintf(['Unable to locate central BIAC startup.m file\n  (%s).\n Connect to network or set BIACMATLABROOT environment variable.\n'],startm)); end; clear startm BIACroot

addpath(genpath('SUB_SCRIPTDIR_SUB'));addpath(genpath('/usr/local/packages/MATLAB/spm8'));addpath(genpath('SUB_MOUNT_SUB/Data/Anat/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Data/Func/SUB_SUBJECT_SUB'));addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB'));addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB'));

%Here we set the home directory variables to make navigation easier
homedir='SUB_MOUNT_SUB/Analysis/SPM/';

%% ANAT COPY: Here we are copying our anatomicals into each functional directory for registration.
    
if strcmp('SUB_RUNFACES_SUB', 'yes')
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1mprage.img','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
    copyfile('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/anat/c1mprage.hdr','SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces');
end

%% FACES PROCESSING: realign & unwarp, cogregistration, normalization, and smoothing (new faces 273 images)

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces')); % Go to faces output directory

% FACES ~REALIGN AND UNWARP  
if strcmp('SUB_RUNFACES_SUB', 'yes')                    % Check if user wants to process cards    
    spm('defaults','fmri'); spm_jobman('initcfg');      % Initialize SPM JOBMAN

    % Get V000 images
    clear imagearray; V00img=dir(fullfile(homedir,'Processed/SUB_SUBJECT_SUB/faces/','V0*.img')); numimages = 273;
    for j=1:numimages; imagearray{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/',V00img(j).name,',1'); end; clear V00img;
    
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = imagearray;
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

    % FACES ~COGREGISTRATION: Dependencies include c1* image copied into cards from anat in
    matlabbatch{2}.spm.spatial.coreg.estimate.ref = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/meanuV0001.img,1'};
    matlabbatch{2}.spm.spatial.coreg.estimate.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1mprage.img,1'};
    matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

    % Create array of uV* image paths
    for j=1:numimages; imagename=imagearray{j}(regexp(imagearray{j},'V0'):end); holder{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/u',imagename); end;
    imagearray = holder; clear holder;
    
    % FACES ~NORMALIZATION: Dependencies include c1* image copied into cards from anat in spm_batch1.m, and 273 uV00* images created after realign & unwarp
    matlabbatch{3}.spm.spatial.normalise.estwrite.subj.source = {'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/faces/c1mprage.img,1'};
    matlabbatch{3}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
    matlabbatch{3}.spm.spatial.normalise.estwrite.subj.resample = imagearray;
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.template = {'/usr/local/packages/MATLAB/spm8/apriori/grey.nii,1'};
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
    matlabbatch{3}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50 78 76 85];
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.interp = 1;
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';

    % Create array of wuV* image paths
    for j=1:numimages; imagename=imagearray{j}(regexp(imagearray{j},'uV0'):end); holder{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/w',imagename); end;
    imagearray = holder; clear holder;
    
    % FACES ~SMOOTHING: Dependencies include wuV00* images created after normalization.  
    matlabbatch{4}.spm.spatial.smooth.data = imagearray;
    matlabbatch{4}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{4}.spm.spatial.smooth.dtype = 0;
    matlabbatch{4}.spm.spatial.smooth.prefix = 's';

    % FACES ~SINGLE SUBJECT PROCESSING: Sets up the design and runs single subject processing. Dependencies include swuV00* images created 
    % after smoothing. Output goes to faces_pfl under Analysis/SPM/Analyzed

    % Create array of swuV* image paths
    for j=1:numimages; imagename=imagearray{j}(regexp(imagearray{j},'wuV0'):end); holder{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/s',imagename); end;
    imagearray = holder; clear holder;
    
    matlabbatch{5}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/faces_pfl'};
    matlabbatch{5}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{5}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{5}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{5}.spm.stats.fmri_spec.sess.scans = imagearray;
    
    % Conditions
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).onset = [0 62 124 186 248];
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).duration = 25;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).name = 'Angry Faces';
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).onset = [27 44 56 94 113 120 152 155 180 230 232 241];
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).duration = 1;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).name = 'Fear Faces';
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).onset = [29 32 41 88 102 111 159 169 171 216 226 244];
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).duration = 1;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).name = 'Happy Faces';
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).onset = [36 52 59 91 96 98 150 166 173 221 224 236];
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).duration = 1;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).name = 'Neutral Faces';
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).onset = [38 48 50 106 109 116 162 177 182 212 218 239];
    matlabbatch{5}.spm.stats.fmri_spec.sess.cond(5).duration = 1;
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
    matlabbatch{6}.spm.stats.fmri_est.spmmat = {horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl/SPM.mat')};
    matlabbatch{6}.spm.stats.fmri_est.method.Classical = 1;

    % FACES JOB SUBMIT! Submit matlabbatch for cards and clear for rest
    spm_jobman('run_nogui',matlabbatch); clear matlabbatch;
end

%% SPM CHECK REGISTRATION
% After initial pre-processing batch file is completed Check Registration will be used to create visualizations of a random set of 12 smoothed
% functional images for each of the three tasks.  The reason for this is to approximate whether, across all scans, the smoothed image files are of
% good quality.  This can be incorporated into the batch stream, however, it is unclear to me within the batch editory how to print the output to the
% *.ps file that SPM8 creates when it compeltes other steps such as Realign&Unwarp.

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB'))

% Randomly generates 12 numbers between 1 and 273.  These 12 numbers correspond to the swuV* images that will be loaded with CheckReg to
% visualize 12 random smoothed images from the faces ProcessedData folder for this single subject.
if strcmp('SUB_RUNFACES_SUB','yes')
    %This allocates a spot in memory for the array so that it doesn't have to find a new spot for every iteration of the loop. 
    i=273; chreg_faces=char(12,93); f = ceil(i.*rand(12,1)); 
    for j = 1:12
        if f(j) < 10; chreg_faces(j,1:93) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV000',num2str(f(j)),'.img,1'); end;
        if f(j) >=10; if f(j) < 100; chreg_faces(j,1:93) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV00',num2str(f(j)),'.img,1'); end; end;
        if f(j) >=100; chreg_faces(j,1:93) = horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV0',num2str(f(j)),'.img,1'); end;
    end; spm_check_registration(chreg_faces); spm_print;
end

%% ART BATCH
% Calculates artifact detection for each functional run and creates single subject design matrices that include the outputs from art_batch
% The outputs from this art_batch will include a .mat file specifying particular volumes that are outliers.  This file can be loaded as a
% regressor into single subject designs to control for substantial variability of a single or set of images

addpath(genpath('SUB_MOUNT_SUB/Scripts/SPM/Art')); cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))

% ARTBATCH - FACES
if strcmp('SUB_RUNFACES_SUB', 'yes'); cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl'));art_batch(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl/SPM.mat')); end;

%% FOLDER CHECK
% Check whether the 'faces' folders exist within the single subject Analyzed Data folder.  If not, it creates it.  The single
% subject design matrices with these folders will incorporate the art output when necessary.
cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB'))
if strcmp('SUB_RUNFACES_SUB','yes'); if isdir('Faces')==0; sprintf('%s','Currently no faces folder exists.  Creating faces within single subject Analyzed folder.'); mkdir Faces; end; end; 
    

%% FACES WITH ART SINGLE SUBJECT ANALYSIS
% Creates a single subject design matrix that include the outputs from art_batch

if strcmp('SUB_RUNFACES_SUB', 'yes')                    % Check if the user is processing faces data:
    spm('defaults','fmri'); spm_jobman('initcfg');      % Initialize SPM JOBMAN
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/'));   % Go to Analyzed directory
    mkdir Faces; cd Faces; mkdir affect; mkdir block    % Make affect and block directories
    cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

    % Get swuV000 images
    clear imagearray; V00img=dir(fullfile(homedir,'Processed/SUB_SUBJECT_SUB/faces/swuV0*.img')); numimages = 273;
    for j=1:numimages; imagearray{j}=horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/',V00img(j).name,',1'); end; clear V00img;

    %% Faces AFFECT single subject analysis
    matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/Faces/affect'};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = imagearray;
    
    % Faces Affect Conditions
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [0 62 124 186 248];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 25;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Angry Faces';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = [27 44 56 94 113 120 152 155 180 230 232 241];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Fear Faces';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = [29 32 41 88 102 111 159 169 171 216 226 244];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Happy Faces';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = [36 52 59 91 96 98 150 166 173 221 224 236];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'Neutral Faces';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = [38 48 50 106 109 116 162 177 182 212 218 239];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 1;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [-4 1 1 1 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Angry Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Fear Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [-1 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Happy Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Neutral Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [-1 0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Fear + Angry Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [-1 .5 .5];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none'; 
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Fear + Angry + Happy Faces > Shapes';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [-1 .3333 .3333 .3333];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none'; 
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    % FACES AFFECT JOB SUBMIT: Run matlabbatch job and clear for block
    spm_jobman('run_nogui',matlabbatch); clear matlabbatch; 

    %% Faces Block Single Subject Analysis

    spm('defaults','fmri'); spm_jobman('initcfg');      % Initialize SPM JOBMAN
    cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))

    matlabbatch{1}.spm.stats.fmri_spec.dir = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/Faces/block'};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = imagearray;
    
    % Faces Block Conditions
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Shapes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = [0 62 124 186 248];
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 25;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Faces1';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = 25;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 37;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Faces2';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = 87;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 37;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'Faces3';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = 149;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 37;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'Faces4';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = 211;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 37;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [-4 1 1 1 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Faces1 > Shapes';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Faces2 > Shapes';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [-1 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Faces3 > Shapes';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Faces4 > Shapes';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [-1 0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Faces4 > Shapes';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [-1 0 0 0 1];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Block 1+2 > Block 3+4';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 0.5 0.5 -0.5 -0.5];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Block 3+4 > Block 1+2';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 -0.5 -0.5 0.5 0.5];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Block 1 > Block 2';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 1 -1];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Block 3 > Block 4';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 0 0 1 -1];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Block 4 > Block 3';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 -1 1];
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Block 2 > Block 1';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 -1 1];
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Block 2 > Block 3';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 0 1 -1];
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = '';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Block 3 > Block 2';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.convec = [0 0 -1 1];
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Block 1 > 2 > 3 > 4';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.convec = [0  0.75 0.25 -0.25 -0.75];
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Block 4 > 3 > 2 > 1';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.convec = [0 -.75 -.25 .25 .75];
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'Shapes > Faces';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.convec = [1 -.25 -.25 -.25 -.25];
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{18}.fcon.name = 'Effects of Interest';
    matlabbatch{3}.spm.stats.con.consess{18}.fcon.convec = {
                                                            [1 0 0 0 0
                                                            0 1 0 0 0
                                                            0 0 1 0 0
                                                            0 0 0 1 0
                                                            0 0 0 0 1]
                                                            }';
    matlabbatch{3}.spm.stats.con.consess{18}.fcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    % FACES BLOCK JOB SUBMIT: Run matlabbatch job and clear
    spm_jobman('run_nogui',matlabbatch); clear matlabbatch; 
end

%% DATA CHECK (SAVE TO OUTPUT FOLDER?)
% For QA checks, we produce a PDF printout of each subject's data for Faces > Shapes, block design, Positive Feedback > Negative Feedback
% for Cards, and display a T1. In the bash script we then move all files to Graphics / Data_Check /, where Ahmad can click through maps to 
% get an overall idea of data quality.

% Faces Data Check
if strcmp('SUB_RUNFACES_SUB','yes')
    spm('defaults','fmri'); spm_jobman('initcfg');
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block'));
    matlabbatch{1}.spm.stats.results.spmmat = {'SUB_MOUNT_SUB/Analysis/SPM/Analyzed/SUB_SUBJECT_SUB/Faces/block/SPM.mat'};
    matlabbatch{1}.spm.stats.results.conspec.titlestr = 'SUB_SUBJECT_SUB Faces > Shapes';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
    matlabbatch{1}.spm.stats.results.conspec.extent = 10;
    matlabbatch{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.print = true;
    spm_jobman('run_nogui',matlabbatch);clear matlabbatch
end


%% CLEANUP and SPM.mat path changing
% Here we go back to the Processed directory, and delete the copied over V000* images, the uV00*, and wuV00* images, to save space.  We
% also go to the output directories and change the SPM.mat paths so they will work on the local machine!

% FACES
if strcmp('SUB_RUNFACES_SUB', 'yes')          
    cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces'))
    delete V0*.img; delete V0*.hdr; delete uV0*; delete wuV0*;
    % Fixing paths for faces_pfl
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/faces_pfl')); spm_change_paths_swd('/ramSUB_MOUNT_SUB/','SUB_MOUNT_SUB/','N:/ABD.01/','/');
    % Fixing paths for Faces/block
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/block')); spm_change_paths('SUB_MOUNT_SUB/','N:/ABD.01/','/');
    % Fixing paths for Faces/affect
    cd(horzcat(homedir,'Analyzed/SUB_SUBJECT_SUB/Faces/affect')); spm_change_paths('SUB_MOUNT_SUB/','N:/ABD.01/','/');
end

cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/raw')); delete V0*.dcm;
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/faces/')); rmdir raw;
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/anat/raw')); delete V0*.dcm;
cd(horzcat(homedir,'Processed/SUB_SUBJECT_SUB/anat/')); rmdir raw;

exit