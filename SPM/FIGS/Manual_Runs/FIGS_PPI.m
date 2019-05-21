%Top directory from which Processed and Analyzed
%homedir = spm_select(1,'dir','Select directory containing Processed and Analyzed folders');
homedir='N:\FIGS.01\Analysis\SPM\Analyzed\';

%scriptdir = spm_select(1,'dir','Select base of Script Directory');
scriptdir='N:\FIGS.01\Scripts\';
    
spm('defaults','fmri')
spm_jobman('initcfg'); 

% Here the user specifies the number of subjects:
subj_count = spm_input('Number of subjects',1,'','',1);

% Here the user specifies the subjects to be included in the coverage check
subjects = spm_select(subj_count,'dir','Select subjects to check coverage for','',homedir);

%Select correct scripts based on design type
scriptname1='Cards_PPI.mat';

for su=1:subj_count
    s=subjects(su,:);        
    cd(horzcat(s,'Cards_PPI'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%RUN IT!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spm_jobman('run','Cards_PPI.mat');

end


