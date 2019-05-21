% DNS FREEZE 200 SUBJECTS
%
% This little script submits a bunch of jobs with dns_timeseries to create
% timeseries .csv tables for a variety of Tasks and Contrasts for the
% DNS 200 freeze.  You can modify this script to create a new batch of
% contrasts, or copy it and change variables to set up the creation of
% timeseries for a different freeze point!

% Add path to dns_timeseries script
addpath(genpath('N:\DNS.01\Scripts\MATLAB\Vanessa'))

% Setup global (nonchanging) variables for each run:
threshtype = 'FWE';
thresh = '.05';
extent = 0;
contrast = 1;
lookup = 'N:\DNS.01\Analysis\SPM\Second_level\TIMESERIES\dns_lookup.xls';
output = 'N:\DNS.01\Analysis\SPM\Second_level\TIMESERIES\200s';

%% FACES EXTRACTIONS
spmmat = 'N:\DNS.01\Analysis\SPM\Second_Level\BOLD\Faces\Block\200s\Faces_gr_Shapes\SPM.mat';

% Faces > Shapes RAmyDorsal
mask = 'N:\DNS.01\Analysis\SPM\ROI\Amygdala\spm8\Ventral_Dorsal\RAmyDorsal.nii';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% Faces > Shapes LAmyDorsal
mask = 'N:\DNS.01\Analysis\SPM\ROI\Amygdala\spm8\Ventral_Dorsal\LAmyDorsal.nii';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% Faces > Shapes LAmyVentral
mask = 'N:\DNS.01\Analysis\SPM\ROI\Amygdala\spm8\Ventral_Dorsal\LAmyVentral.nii';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% Faces > Shapes RAmyVentral
mask = 'N:\DNS.01\Analysis\SPM\ROI\Amygdala\spm8\Ventral_Dorsal\RAmyVentral.nii';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% Faces > Shapes Amygdala3DDilate0_Left
mask = 'N:\DNS.01\Analysis\SPM\Second_Level\BOLD\Faces\Coverage_Check\Masks\Amygdala3DDilate0_Left.img';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% Faces > Shapes Amygdala3DDilate0_Right
mask = 'N:\DNS.01\Analysis\SPM\Second_Level\BOLD\Faces\Coverage_Check\Masks\Amygdala3DDilate0_Right.img';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

%% CARDS EXTRACTIONS
spmmat = 'N:\DNS.01\Analysis\SPM\Second_Level\BOLD\Cards\200s\PosFeedback_gr_NegFeedback\SPM.mat';

% PosFbk > NegFbk right_VS
mask = 'N:\DNS.01\Analysis\SPM\ROI\VS\right_VS.img';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);

% PosFbk > NegFbk left_VS
mask = 'N:\DNS.01\Analysis\SPM\ROI\VS\left_VS.img';
dns_timeseries(spmmat,threshtype,thresh,extent,output,mask,contrast,lookup);