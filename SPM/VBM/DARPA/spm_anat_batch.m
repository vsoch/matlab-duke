%-----------------------------------------------------------------------
% SPM_ANAT_BATCH.m
% 
% This script processes the anatomical images for DARPA with the VBM
% toolbox. Output includes segmented and normalized (default modulated and
% spgr) anatomicals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. The script imports the DICOM of every existing structural of the selected subject
%(inplane, highres1, highres2) for pre- and postdeployment to their
%destination folder.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Then a copy of those imported images is renamed to
% subjectnum_pre/post_inplane/highres1/highres2 depending on the identity
% of the structural. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.The images are then automatically realigned to the ac/pc and copied to
% the their spgr and default folders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. These dicom-converted, renamed, realigned and copied images are then
% processed by the VBM8 toolbox using either spgr and default modulation.
% After which the grey and white matter segmentation images are smoothed with a 12mm kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Laboratory of NeuroGenetics November 2010
% Made by: Pieter van de Vijver, November 16, 2010
%-----------------------------------------------------------------------


%Add necessary paths
BIACroot = 'SUB_BIACROOT_SUB';

startm=fullfile(BIACroot,'startup.m');
if exist(startm,'file')
  run(startm);
else
  warning(sprintf(['Unable to locate central BIAC startup.m file\n  (%s).\n' ...
      '  Connect to network or set BIACMATLABROOT environment variable.\n'],startm));
end
clear startm BIACroot

addpath(genpath('/usr/local/packages/MATLAB/spm8'));

%addpath for scripts folder and spm
addpath(genpath('SUB_SCRIPTDIR_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB'));
addpath(genpath('SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB'));
addpath(genpath('/usr/local/packages/MATLAB/spm8'));

%load spm defaults and initiate job
spm('defaults','fmri')
spm_jobman('initcfg');

%load ac/pc realign function to set_acpc
set_acpc = @auto_reorient;


%%%%%%%%%%%%%%%%% convert dicom to hdr/img -> copy and rename file to the same directory, rename
%%%%%%%%%%%%%%%%% that file to a more suitable name 

raw_dir = 'SUB_MOUNT_SUB/Data/SUB_SUBJECT_SUB/';
proc_dir = 'SUB_MOUNT_SUB/Analysis/SPM/Processed/SUB_SUBJECT_SUB/';

% make folder shortcuts for origin and destination of the anatomicals for better overview in script
pre_hr1_raw = strcat(raw_dir,'pre/anat/highres1/');
pre_hr1_dir = strcat(proc_dir,'pre/anat/highres1/');

pre_hr2_raw = strcat(raw_dir,'pre/anat/highres2/');
pre_hr2_dir = strcat(proc_dir,'pre/anat/highres2/');

post_hr1_raw = strcat(raw_dir,'post/anat/highres1/'); 
post_hr1_dir = strcat(proc_dir,'post/anat/highres1/'); 

post_hr2_raw = strcat(raw_dir,'post/anat/highres2/');
post_hr2_dir = strcat(proc_dir,'post/anat/highres2/');

pre_inpl_raw = strcat(raw_dir,'pre/anat/inplane/');
pre_inpl_dir = strcat(proc_dir,'pre/anat/inplane/');

post_inpl_raw = strcat(raw_dir,'post/anat/inplane/');
post_inpl_dir = strcat(proc_dir,'post/anat/inplane/');

%%%initiate count, to make sure the numbers of the matlabbatch match the
%%%data
count = 1;
%%%if folder with dicoms exists for the selected structural, convert to
%%%destination dir. Then copy and rename the file with a prefix that is
%%%specific for that structural to the same folder.
if exist(pre_hr1_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms
       
    %switch to folder with dicoms
    cd(pre_hr1_raw);
    dcmfile_pre_hr1 = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_pre_hr1)            
            dicom_files{i,1} = strcat(pre_hr1_raw,dcmfile_pre_hr1(i).name);
    end

    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {pre_hr1_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {pre_hr1_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_pre_hr1_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    count = count+1;
    clear dicom_files
end


%if folder with dicoms exists for the selected structural, go on
if exist(pre_hr2_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms

    
    %switch to folder with dicoms
    cd(pre_hr2_raw);
    dcmfile_pre_hr2 = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_pre_hr2)            
            dicom_files{i,1} = strcat(pre_hr2_raw,dcmfile_pre_hr2(i).name);
    end
    
    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {pre_hr2_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {pre_hr2_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_pre_hr2_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    count = count+1;
    clear dicom_files
end

%if folder with dicoms exists for the selected structural, go on
if exist(post_hr1_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms
  
    
    %switch to folder with dicoms
    cd(post_hr1_raw);
    dcmfile_post_hr1 = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_post_hr1)            
            dicom_files{i,1} = strcat(post_hr1_raw,dcmfile_post_hr1(i).name);
    end
    
    
    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {post_hr1_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {post_hr1_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_post_hr1_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    count = count+1;
    clear dicom_files
end


%if folder with dicoms exists for the selected structural, go on
if exist(post_hr2_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms
    

    
    %switch to folder with dicoms
    cd(post_hr2_raw);
    dcmfile_post_hr2 = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_post_hr2)            
            dicom_files{i,1} = strcat(post_hr2_raw,dcmfile_post_hr2(i).name);
    end
    
    
    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {post_hr2_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {post_hr2_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_post_hr2_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    count = count+1;
    clear dicom_files
end

%if folder with dicoms exists for the selected structural, go on
if exist(pre_inpl_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms

    
    %switch to folder with dicoms
    cd(pre_inpl_raw);
    dcmfile_pre_inpl = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_pre_inpl)            
            dicom_files{i,1} = strcat(pre_inpl_raw,dcmfile_pre_inpl(i).name);
    end
    
    
    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {pre_inpl_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {pre_inpl_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_pre_inpl_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    count = count+1;
    clear dicom_files
end

%if folder with dicoms exists for the selected structural, go on
if exist(post_inpl_raw,'dir')

    %%%%%%%%%%%%%make filelist for dicoms

    
    %switch to folder with dicoms
    cd(post_inpl_raw);
    dcmfile_post_inpl = dir('*.dcm*');

    %%%%insert error message: if number of files > 172
    
    for i = 1:length(dcmfile_post_inpl)            
            dicom_files{i,1} = strcat(post_inpl_raw,dcmfile_post_inpl(i).name);
    end
    
    
    %convert to nifti
    matlabbatch{count}.spm.util.dicom.data = dicom_files;
    matlabbatch{count}.spm.util.dicom.root = 'flat';
    matlabbatch{count}.spm.util.dicom.outdir = {post_inpl_dir};
    matlabbatch{count}.spm.util.dicom.convopts.format = 'img';
    matlabbatch{count}.spm.util.dicom.convopts.icedims = 0;
    count = count+1;
    
    %replicate file with charactaristic prepend
    matlabbatch{count}.cfg_basicio.file_move.files(1) = cfg_dep;
    matlabbatch{count}.cfg_basicio.file_move.files(1).tname = 'Files to move/copy/delete';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{count}.cfg_basicio.file_move.files(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{count}.cfg_basicio.file_move.files(1).sname = 'DICOM Import: Converted Images';
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{count}.cfg_basicio.file_move.files(1).src_output = substruct('.','files');
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.copyto = {post_inpl_dir};
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.pattern = 's'; 
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.patrep.repl = 'SUB_SUBJECT_SUB_post_inpl_';
    matlabbatch{count}.cfg_basicio.file_move.action.copyren.unique = false;
    clear dicom_files
end

%%% run the job and remove the batch afterwards
spm_jobman('run_nogui',matlabbatch)
clear matlabbatch

%%%Rename the copied structural with the image-specific prefix files to
%%%more convenient name and realign that structural to ac/pc using the
%%%set_acpc command
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pre_hr1_img = strcat(pre_hr1_dir,'SUB_SUBJECT_SUB_pre_highres1.img');
pre_hr1_hdr = strcat(pre_hr1_dir,'SUB_SUBJECT_SUB_pre_highres1.hdr');
if exist(pre_hr1_dir,'dir')
    cd(pre_hr1_dir);
    pre_hr1_temp1 = dir('SUB_SUBJECT_SUB_pre_hr1_*.img');
    pre_hr1_temp1 = strcat(pre_hr1_dir,pre_hr1_temp1.name);    
    movefile(pre_hr1_temp1,pre_hr1_img);

    pre_hr1_temp2 = dir('SUB_SUBJECT_SUB_pre_hr1_*.hdr');
    pre_hr1_temp2 = strcat(pre_hr1_dir,pre_hr1_temp2.name);    
    movefile(pre_hr1_temp2,pre_hr1_hdr);
    %set origin near ac/pc
    set_acpc(pre_hr1_img);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pre_hr2_img = strcat(pre_hr2_dir,'SUB_SUBJECT_SUB_pre_highres2.img');
pre_hr2_hdr = strcat(pre_hr2_dir,'SUB_SUBJECT_SUB_pre_highres2.hdr');
if exist(pre_hr2_dir,'dir')
    cd(pre_hr2_dir);
    pre_hr2_temp1 = dir('SUB_SUBJECT_SUB_pre_hr2_*.img');
    pre_hr2_temp1 = strcat(pre_hr2_dir,pre_hr2_temp1.name);
    
    movefile(pre_hr2_temp1,pre_hr2_img);

    pre_hr2_temp2 = dir('SUB_SUBJECT_SUB_pre_hr2_*.hdr');
    pre_hr2_temp2 = strcat(pre_hr2_dir,pre_hr2_temp2.name);
    
    movefile(pre_hr2_temp2,pre_hr2_hdr);
    %set origin near ac/pc
    set_acpc(pre_hr2_img);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
post_hr1_img = strcat(post_hr1_dir,'SUB_SUBJECT_SUB_post_highres1.img');
post_hr1_hdr = strcat(post_hr1_dir,'SUB_SUBJECT_SUB_post_highres1.hdr');
if exist(post_hr1_dir,'dir')
    cd(post_hr1_dir);
    post_hr1_temp1 = dir('SUB_SUBJECT_SUB_post_hr1_*.img');
    post_hr1_temp1 = strcat(post_hr1_dir,post_hr1_temp1.name);    
    movefile(post_hr1_temp1,post_hr1_img);

    post_hr1_temp2 = dir('SUB_SUBJECT_SUB_post_hr1_*.hdr');
    post_hr1_temp2 = strcat(post_hr1_dir,post_hr1_temp2.name);    
    movefile(post_hr1_temp2,post_hr1_hdr);
    %set origin near ac/pc
    set_acpc(post_hr1_img);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
post_hr2_img = strcat(post_hr2_dir,'SUB_SUBJECT_SUB_post_highres2.img');
post_hr2_hdr = strcat(post_hr2_dir,'SUB_SUBJECT_SUB_post_highres2.hdr');
if exist(post_hr2_dir,'dir')
    cd(post_hr2_dir);
    post_hr2_temp1 = dir('SUB_SUBJECT_SUB_post_hr2_*.img');
    post_hr2_temp1 = strcat(post_hr2_dir,post_hr2_temp1.name);
    movefile(post_hr2_temp1,post_hr2_img);

    post_hr2_temp2 = dir('SUB_SUBJECT_SUB_post_hr2_*.hdr');
    post_hr2_temp2 = strcat(post_hr2_dir,post_hr2_temp2.name);
    movefile(post_hr2_temp2,post_hr2_hdr);
    %set origin near ac/pc
    set_acpc(post_hr2_img);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pre_inpl_img = strcat(pre_inpl_dir,'SUB_SUBJECT_SUB_pre_inplane.img');
pre_inpl_hdr = strcat(pre_inpl_dir,'SUB_SUBJECT_SUB_pre_inplane.hdr');
if exist(pre_inpl_dir,'dir')
    cd(pre_inpl_dir);
    pre_inpl_temp1 = dir('SUB_SUBJECT_SUB_pre_inpl_*.img');
    pre_inpl_temp1 = strcat(pre_inpl_dir,pre_inpl_temp1.name);
    movefile(pre_inpl_temp1,pre_inpl_img);

    pre_inpl_temp2 = dir('SUB_SUBJECT_SUB_pre_inpl_*.hdr');
    pre_inpl_temp2 = strcat(pre_inpl_dir,pre_inpl_temp2.name);
    movefile(pre_inpl_temp2,pre_inpl_hdr);
    %set origin near ac/pc
    set_acpc(pre_inpl_img);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
post_inpl_img = strcat(post_inpl_dir,'SUB_SUBJECT_SUB_post_inplane.img');
post_inpl_hdr = strcat(post_inpl_dir,'SUB_SUBJECT_SUB_post_inplane.hdr');
if exist(post_inpl_dir,'dir')
    cd(post_inpl_dir);
    post_inpl_temp1 = dir('SUB_SUBJECT_SUB_post_inpl_*.img');
    post_inpl_temp1 = strcat(post_inpl_dir,post_inpl_temp1.name);

    movefile(post_inpl_temp1,post_inpl_img);

    post_inpl_temp2 = dir('SUB_SUBJECT_SUB_post_inpl_*.hdr');
    post_inpl_temp2 = strcat(post_inpl_dir,post_inpl_temp2.name);
    
    movefile(post_inpl_temp2,post_inpl_hdr);
    %set origin near ac/pc
    set_acpc(post_inpl_img);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Now it's time to segment the images for vbm and smooth the outcome
%define paths to dirs and images for enabling loop function
struct_dirs = {pre_hr1_dir,pre_hr2_dir,post_hr1_dir,post_hr2_dir,pre_inpl_dir,post_inpl_dir};
struct_img = {pre_hr1_img,pre_hr2_img,post_hr1_img,post_hr2_img,pre_inpl_img,post_inpl_img};
struct_hdr = {pre_hr1_hdr,pre_hr2_hdr,post_hr1_hdr,post_hr2_hdr,pre_inpl_hdr,post_inpl_hdr};
struct_imgname = {'SUB_SUBJECT_SUB_pre_highres1.img','SUB_SUBJECT_SUB_pre_highres2.img','SUB_SUBJECT_SUB_post_highres1.img','SUB_SUBJECT_SUB_post_highres2.img','SUB_SUBJECT_SUB_pre_inplane.img','SUB_SUBJECT_SUB_post_inplane.img'};


count = 1;
for struct = 1:length(struct_img)
    %if the selected structural exists (so if the subjects has that
    %structural and it has been processed so far then inplement it in the
    %batch.
    if exist(struct_img{struct},'file')
    
        %%% copy the renamed, realigned structural to the the spgr and
        %%% default folders
        spgr_dir = strcat(struct_dirs{struct},'spgr/');
        copyfile(struct_img{struct},spgr_dir);
        copyfile(struct_hdr{struct},spgr_dir);

        default_dir = strcat(struct_dirs{struct},'default/');
        copyfile(struct_img{struct},default_dir);
        copyfile(struct_hdr{struct},default_dir);
        
        %%% create shortcuts for the image to be processed by the vbm batch
        spgr_name = strcat(spgr_dir,struct_imgname{struct});
        default_name = strcat(default_dir,struct_imgname{struct});
        
        %%%% vbm: non-linear modulation only  (spgr)      
        matlabbatch2{count}.spm.tools.vbm8.estwrite.data = {spgr_name};
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.tpm = {'/usr/local/packages/MATLAB/spm8/toolbox/Seg/TPM.nii'};
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.affreg = 'mni';
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.samp = 3;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.dartelwarp = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.sanlm = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.mrf = 0.15;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.cleanup = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.print = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.modulated = 2;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.modulated = 2;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.modulated = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.warped = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.warps = [0 0];
        count = count+1;

        %%%%vbm: default modulation (default)
        matlabbatch2{count}.spm.tools.vbm8.estwrite.data = {default_name};
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.tpm = {'/usr/local/packages/MATLAB/spm8/toolbox/Seg/TPM.nii'};
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.affreg = 'mni';
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.opts.samp = 3;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.dartelwarp = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.sanlm = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.mrf = 0.15;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.cleanup = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.extopts.print = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.modulated = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.modulated = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.modulated = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.warped = 1;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.native = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
        matlabbatch2{count}.spm.tools.vbm8.estwrite.output.warps = [0 0];
        count = count+1;

        %%%This part smooths the images. The images are defined as dependancies of the
        %%%previous batch and are smoothed with an 12mm kernel
        matlabbatch2{count}.spm.spatial.smooth.data(1) = cfg_dep;
        matlabbatch2{count}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
        matlabbatch2{count}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch2{count}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
        matlabbatch2{count}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch2{count}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
        matlabbatch2{count}.spm.spatial.smooth.data(1).sname = 'VBM8: Estimate & Write: m0wp1 Images';
        matlabbatch2{count}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{count-2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch2{count}.spm.spatial.smooth.data(1).src_output = substruct('.','tiss', '()',{1}, '.','m0wc', '()',{':'});
        matlabbatch2{count}.spm.spatial.smooth.data(2) = cfg_dep;
        matlabbatch2{count}.spm.spatial.smooth.data(2).tname = 'Images to Smooth';
        matlabbatch2{count}.spm.spatial.smooth.data(2).tgt_spec{1}(1).name = 'filter';
        matlabbatch2{count}.spm.spatial.smooth.data(2).tgt_spec{1}(1).value = 'image';
        matlabbatch2{count}.spm.spatial.smooth.data(2).tgt_spec{1}(2).name = 'strtype';
        matlabbatch2{count}.spm.spatial.smooth.data(2).tgt_spec{1}(2).value = 'e';
        matlabbatch2{count}.spm.spatial.smooth.data(2).sname = 'VBM8: Estimate & Write: m0wp2 Images';
        matlabbatch2{count}.spm.spatial.smooth.data(2).src_exbranch = substruct('.','val', '{}',{count-2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch2{count}.spm.spatial.smooth.data(2).src_output = substruct('.','tiss', '()',{2}, '.','m0wc', '()',{':'});
        matlabbatch2{count}.spm.spatial.smooth.data(3) = cfg_dep;
        matlabbatch2{count}.spm.spatial.smooth.data(3).tname = 'Images to Smooth';
        matlabbatch2{count}.spm.spatial.smooth.data(3).tgt_spec{1}(1).name = 'filter';
        matlabbatch2{count}.spm.spatial.smooth.data(3).tgt_spec{1}(1).value = 'image';
        matlabbatch2{count}.spm.spatial.smooth.data(3).tgt_spec{1}(2).name = 'strtype';
        matlabbatch2{count}.spm.spatial.smooth.data(3).tgt_spec{1}(2).value = 'e';
        matlabbatch2{count}.spm.spatial.smooth.data(3).sname = 'VBM8: Estimate & Write: mwp1 Images';
        matlabbatch2{count}.spm.spatial.smooth.data(3).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch2{count}.spm.spatial.smooth.data(3).src_output = substruct('.','tiss', '()',{1}, '.','mwc', '()',{':'});
        matlabbatch2{count}.spm.spatial.smooth.data(4) = cfg_dep;
        matlabbatch2{count}.spm.spatial.smooth.data(4).tname = 'Images to Smooth';
        matlabbatch2{count}.spm.spatial.smooth.data(4).tgt_spec{1}(1).name = 'filter';
        matlabbatch2{count}.spm.spatial.smooth.data(4).tgt_spec{1}(1).value = 'image';
        matlabbatch2{count}.spm.spatial.smooth.data(4).tgt_spec{1}(2).name = 'strtype';
        matlabbatch2{count}.spm.spatial.smooth.data(4).tgt_spec{1}(2).value = 'e';
        matlabbatch2{count}.spm.spatial.smooth.data(4).sname = 'VBM8: Estimate & Write: mwp2 Images';
        matlabbatch2{count}.spm.spatial.smooth.data(4).src_exbranch = substruct('.','val', '{}',{count-1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch2{count}.spm.spatial.smooth.data(4).src_output = substruct('.','tiss', '()',{2}, '.','mwc', '()',{':'});
        matlabbatch2{count}.spm.spatial.smooth.fwhm = [12 12 12];
        matlabbatch2{count}.spm.spatial.smooth.dtype = 0;
        matlabbatch2{count}.spm.spatial.smooth.im = 0;
        matlabbatch2{count}.spm.spatial.smooth.prefix = 's';
        count = count+1;        
   end
end

%%%Run the vbm-smooth job
spm_jobman('run_nogui',matlabbatch2)

clear matlabbatch2

%%%exit matlab
exit





   
