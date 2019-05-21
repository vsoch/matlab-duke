%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%% spm8_FIGS.m is used for manual processing of FIGS data in spm8
%%%%%%%%%%%%%%%%%Vanessa Sochat
%%%%%%%%%%%%%%%%%June 08, 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Due to the huge variance in design type (many subjects have unique
% designs) I decided to create a manually run script, as opposed to
% processing FIGS on the cluster.  This script asks the user for the top of
% the Analyzed/Processed SPM directory, the Scripts directory, the subject
% ID, design type, and for the 195 swrf images.  The script first sets up
% individual design matrices and runs Model Estimation, and then uses these
% "pfu" (pseudo-first-level) matrices to run Art Batch and find motion
% outliers.  We then check registration by randomly printing 12 of the swrf
% images, and finally create a second level of single subject design
% matrices, this time incorporating the art regression outliers, and adding
% the following contrasts:
%
% 1) Faces > Shapes
% 2) Angry Faces > Shapes
% 3) Fearful Faces > Shapes
% 4) Angry Faces > Fearful Faces
% 5) Fearful Faces > Angry Faces
%
% The script will continue to prompt the user if he/she wants to process
% another subject.  The script depends on the following files:
%
% FIGS_pfl_4block.m
% FIGS_4block.m
% FIGS_pfl_4blockmixed.m
% FIGS_4blockmixed.m
% FIGS_pfl_(subjectID).m
% FIGS_(subjectID).m
%
% These scripts are located in the FIGS.01/Scripts/SPM directory.  The last
% two represent individual designs for the specified subject ID.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keepgoing = 0;

%Add the ART path to the script
addpath(genpath('N:/DNS.01/Scripts/SPM/Art'));

while keepgoing < 1;
clear    

%Top directory from which Processed and Analyzed
%homedir = spm_select(1,'dir','Select directory containing Processed and Analyzed folders');
homedir='N:\FIGS.01\Analysis\SPM\';

%scriptdir = spm_select(1,'dir','Select base of Script Directory');
scriptdir='N:\FIGS.01\Scripts\';
    
spm('defaults','fmri')
spm_jobman('initcfg'); 
    
%Enter subject ID as represented by the folder
subj = spm_input('Enter subject ID',1,'s','',1);

%Please choose the design type
design=spm_input('Design',1,'4Block|Mixed|Individual');

%Select swrf images and format for the script
scans_dir = horzcat(homedir,'Processed\',subj,'\Faces');
scans_pre = cellstr(spm_select(195,'.img','Select 195 swrf images for Faces','',scans_dir));

for i = 1:195
scans{i,:}=horzcat(scans_pre{i,:},',1');
end

cd (horzcat(scriptdir,'SPM/'))

%Select correct scripts based on design type
switch design
 case 'Mixed'
    scriptname1='FIGS_pfl_4blockmixed';
    scriptname2='FIGS_4blockmixed';
  case '4Block'
    scriptname1='FIGS_pfl_4block';
    scriptname2='FIGS_4block';
  case 'Individual'
    scriptname1=horzcat(subj,'_pfl');
    scriptname2=subj;
  otherwise
  disp('Design name not valid.  Exiting')
  exit
end

load(scriptname1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%matlabbatch{1} - fmri model specification of faces_pfl
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Creates single subject design matrix with condition parameters for faces
%task.  The images used are the 195 selected by the user, which have been
%realigned & unwarped, smoothed, and normalized.
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(horzcat(homedir,'Analyzed\',subj,'\faces_pfl\'));
matlabbatch{1}.spm.stats.fmri_spec.sess.scans={};

for i = 1:195
matlabbatch{1}.spm.stats.fmri_spec.sess.scans{i} = scans{i};
end

matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(horzcat(homedir,'Analyzed\',subj,'\faces_pfl\SPM.mat'));

%Check to see if the individual subject directory exists.  If it does not,
%create the subfolders for each functional task's data
cd (horzcat(homedir,'Analyzed'))
if isdir(subj)==0
mkdir (subj)
cd (subj)
mkdir faces
mkdir faces_pfl
end

%Saves a copy of the single subject pre-processing batch within single
%subject folder under Analyzed
cd(horzcat(homedir,'Analyzed/',subj))
save(scriptname1,'matlabbatch')

%Runs the single subject pre-processing batch file.
switch design
 case '4Block'
    spm_jobman('run','FIGS_pfl_4block.mat');
    case 'Mixed'
    spm_jobman('run','FIGS_pfl_4blockmixed.mat');
  case 'Individual'
    spm_jobman('run',[ subj '_pfl.mat' ])
  otherwise
  error('Design name not valid.  Exiting')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%SPM check registration
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%After initial pre-processing batch file is completed Check Registration
%will be used to create visualizations of a random set of 12 smoothed
%functional images for each of the three tasks.  The reason for this is to
%approximate whether, across all scans, the smoothed image files are of
%good quality.
%Randomly generates 12 numbers between 1 and 195.  These 12 numbers
%correspond to the swuV* images that will be loaded with CheckReg to
%visualize 12 random smoothed images from the faces ProcessedData folder
%for this single subject.
i = 195;
f = ceil(i.*rand(12,1));
for j = 1:12 
    chreg_faces(j,:)=scans{f(j)};
end
spm_check_registration(chreg_faces)
%spm_print will print a *.ps of the 12 smoothed images files to the same
%*.ps file it created for the other components of the pre-processing
spm_print

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%SPM Art Batch
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(horzcat(homedir,'Analyzed/',subj))

%The outputs from this art_batch will include a .mat file specifying
%particular volumes that are outliers.  This file can be loaded as a
%regressor into single subject designs to control for substantial
%variability of a single or set of images
cd faces_pfl
art_batch('./SPM.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%matlabbatch{1} - fmri model specification of faces
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd (horzcat(scriptdir,'SPM/'))
%%%%second level analysis with art outliers
%creates single subject design matrices that include the output
%from art_batch
load(scriptname2);

%Sets the directory to which the single subject design matrix will be
%saved.
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(horzcat(homedir,'Analyzed\',subj,'\faces\'));
matlabbatch{1}.spm.stats.fmri_spec.sess.scans={};
for i = 1:195
matlabbatch{1}.spm.stats.fmri_spec.sess.scans{i} = scans{i};
end

%Figure art_regression_path
tell_user=0;
if exist(horzcat(homedir,'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0004-00001-000001.mat'),'file')
artreg=horzcat(homedir,'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0004-00001-000001.mat');
tell_user=tell_user+1;
end

if exist(horzcat(homedir,'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0005-00001-000001.mat'),'file')
artreg=horzcat(homedir,'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0005-00001-000001.mat');
tell_user=tell_user+1;
end

if exist(horzcat(homedir,'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0006-00001-000001.mat'),'file')
artreg=horzcat(homedir, 'Processed\',subj,'\Faces\art_regression_outliers_swrf',subj,'-0006-00001-000001.mat');
tell_user=tell_user+1;
end

if (tell_user==3)
    disp('Art Regression File Not Found.  Check the subject folder under processed to view name.');
    disp('Valid named are art_regression_outliers_swrf(subject_ID)-0004... -0005... and -.0006...');
    error('Exiting script');
end

%Loads the subject specific ART output file for the cards images.
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(artreg);
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(horzcat(homedir,'Analyzed\',subj,'\faces\SPM.mat'));
matlabbatch{3}.spm.stats.con.spmmat = cellstr(horzcat(homedir,'Analyzed\',subj,'\faces\SPM.mat'));

%Saves the scriptname2 file in the same location as the scriptname1 file.
cd(horzcat(homedir,'Analyzed\',subj))
save(scriptname2,'matlabbatch')

%Runs the single subject pre-processing batch file.
switch design
 case '4Block'
    spm_jobman('run','FIGS_4block.mat');
    case 'Mixed'
    spm_jobman('run','FIGS_4blockmixed.mat');
  case 'Individual'
    spm_jobman('run',[ subj '.mat' ]); 
    otherwise
  disp('Design name not valid.  Exiting')
  exit
end

%Allows the user to select whether or not to run another subject
keepgoing = spm_input('Process another subject?','-1','y/n',[0,1],2);

end



