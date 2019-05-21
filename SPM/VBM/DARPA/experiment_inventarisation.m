%%%%%%%%%%%inventarisation of processed data, exception notes from excel file not
%%%%%%%%%%%implemented yet. No manual verification of missing data via external
%%%%%%%%%%%hard disk not done yet. 

%%%%%%%%%%%


%%% whatch out! script, when rerunning this script, check 
%%% subjlist = dir(datadir) assumption that only the dir's raw, '.' & '..' have
%%% to be excluded from analysis.

%organisation according to [pre_hi1,pre_hi2, pre_inplane, pre_faces,
%post_hi1, post_hi2, post_inplane, post_facse]

datadir = 'Z:\DARPA.01\Data\';

%extract subjectlist from foldernames (exluding Raw, the last name and the first name (. & ..)
subjlist = dir(datadir);
% subjlist = subjlist(3:end-1).name;

inventarisation_matrix = zeros(length(subjlist)- 3,9);

%check every folder for existing data
for subj = 1:length(subjlist)-3
    inventarisation_matrix(subj,1) = str2double(subjlist(subj+2).name);
    
    dirnames = {'\pre\anat\highres1\','\pre\anat\highres2\','\pre\anat\inplane\','\pre\faces\','\post\anat\highres1\','\post\anat\highres2\','\post\anat\inplane\','\post\faces\'};
    %create variable with all dirnames
    subjdirs = strcat(datadir,subjlist(subj+2).name,dirnames);
        
    
    for i = 1:length(subjdirs)
        if exist(subjdirs{i},'dir')
            inventarisation_matrix(subj,i+1)= 1;
        else
            inventarisation_matrix(subj,i+1)= 0;
        end
    end                  
end

%%%%%%%%%%%%%% below is an inventarisation on what dat is available for
%%%%%%%%%%%%%% what subject. This is a true/false list. 
%%%%%%%%%%%%%% corresponding subjects id's can be obtained by typing
%%%%%%%%%%%%%% darpa_index('list_name',1) with 'list_name' being one of the
%%%%%%%%%%%%%% variables defined below. 


darpa_index = inventarisation_matrix;
%%%vbm possible (at least one highresimage from pre and post available)
vbm_pos = (darpa_index(:,2)|darpa_index(:,3))&(darpa_index(:,6)|darpa_index(:,7));
%%%vbm with both highres images available in both sessions
vbm_dub = (darpa_index(:,2)& darpa_index(:,3))&(darpa_index(:,6)& darpa_index(:,7));
%%%faces possible (faces & inplane available)
fac_inpl = (darpa_index(:,4)& darpa_index(:,5))&(darpa_index(:,8)& darpa_index(:,9));
%%%faces possible if highres can also be used for registering
fac_highres = ((darpa_index(:,2)|darpa_index(:,3))& darpa_index(:,5))& ((darpa_index(:,6)|darpa_index(:,7)) & darpa_index(:,9));
%%%faces possible when using highres | inplane
fac_high_inp = (fac_inpl | fac_highres);
%%% faces with at least one anatomical available, pre or post deploy
fac_anat = (darpa_index(:,5)& darpa_index(:,9))& (darpa_index(:,2)|darpa_index(:,3)|darpa_index(:,4)|darpa_index(:,6)|darpa_index(:,7)|darpa_index(:,8));
%%% faces with at least on inpl available
fac_single_inp = (darpa_index(:,5)& darpa_index(:,9))& (darpa_index(:,5)|darpa_index(:,9));


