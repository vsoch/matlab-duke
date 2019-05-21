%%%%%%%%%%%Renaming of basefiles, needs multiple runs because struct-names
%%%%%%%%%%%mostly differ. Renaming into highres1, highres2, faces &
%%%%%%%%%%%inplane. Not shown is the multiple runs: original names varied
%%%%%%%%%%%for instance from hi_resstruct_3 to Hiresstruc1 and more. 
%%%%%%%%%%%Non-common name variations have been corrected manually.


basedir = 'Z:\DARPA.01\Data\Raw\' ;

dirlist = dir(basedir);

for i = 66:length(dirlist)-1
    subdir = strcat(basedir,dirlist(i).name,'\');
    %define pathnames to the folders
    struc1dir = strcat(subdir,'hi_resstructural_3');
    struc1dest = strcat(subdir,'highres1');
    
    struc2dir = strcat(subdir,'hi_resstructural_6');
    struc2dest = strcat(subdir,'highres2');
    
    inplanedir = strcat(subdir,'dst-ptsd-',dirlist(i).name,'-inplane');
    inplanedest = strcat(subdir,'inplane');
    
    facesdir = strcat(subdir,'dst-ptsd-',dirlist(i).name,'-run1');
    facesdest = strcat(subdir,'faces');
     
    %if the folder exists, it is renamed which can only be done with the movefile
    %command.
    if exist(struc1dir,'dir')
        movefile(struc1dir, struc1dest);
    end
    
    if exist(struc2dir,'dir')
        movefile(struc2dir, struc2dest);
    end
    
    if exist(inplanedir,'dir')
        movefile(inplanedir, inplanedest);
    end
    
    if exist(facesdir,'dir')
        movefile(facesdir, facesdest);
    end
    
end


%%%%%%%%%%%%%% placing files in the right folders, based on subject ID
%%%%%%%%%%%%%% instead of scansessions

%load excel file and extract ssid and pre and post scan ##
    [darpanum,darpatxt,raw] = xlsread('C:\Users\haririlab\Downloads\Pre-Post-Match_Demgraph_Darpa.xls');

    datadir = 'Z:\DARPA.01\Data\';
    basedir = 'Z:\DARPA.01\Data\Raw\';
    %per subject
    %create folderstructure, and fill with pre and post scandata
    for i = 1:length(darpanum)
                subjdir = strcat(datadir,num2str(darpanum(i,1)));


        predir = strcat(basedir,num2str(darpanum(i,2)),'\');
        postdir = strcat(basedir,num2str(darpanum(i,4)),'\');

        %copy existing pre-deploy data
        if exist(strcat(predir,'highres1'),'dir')&& ~exist(strcat(subjdir,'\pre\anat\highres1'),'dir')
            copyfile(strcat(predir,'highres1'),strcat(subjdir,'\pre\anat\highres1'),'f');
        end
        if exist(strcat(predir,'highres2'),'dir')&& ~exist(strcat(subjdir,'\pre\anat\highres2'),'dir')
            copyfile(strcat(predir,'highres2'),strcat(subjdir,'\pre\anat\highres2'),'f');
        end
        if exist(strcat(predir,'inplane'),'dir')&& ~exist(strcat(subjdir,'\pre\anat\inplane'),'dir')
            copyfile(strcat(predir,'inplane'),strcat(subjdir,'\pre\anat\inplane'),'f');
        end
        if exist(strcat(predir,'faces'),'dir')&& ~exist(strcat(subjdir,'\pre\faces'),'dir')
            copyfile(strcat(predir,'faces'),strcat(subjdir,'\pre\faces'),'f');
        end

        %copy existing post-deploment data
        if exist(strcat(postdir,'highres1'),'dir')&& ~exist(strcat(subjdir,'\post\anat\highres1'),'dir')
            copyfile(strcat(postdir,'highres1'),strcat(subjdir,'\post\anat\highres1'),'f');
        end
        if exist(strcat(postdir,'highres2'),'dir')&& ~exist(strcat(subjdir,'\post\anat\highres2'),'dir')
            copyfile(strcat(postdir,'highres2'),strcat(subjdir,'\post\anat\highres2'),'f');
        end
        if exist(strcat(postdir,'inplane'),'dir')&& ~exist(strcat(subjdir,'\post\anat\inplane'),'dir')
            copyfile(strcat(postdir,'inplane'),strcat(subjdir,'\post\anat\inplane'),'f');
        end
        if exist(strcat(postdir,'faces'),'dir')&& ~exist(strcat(subjdir,'\post\faces'),'dir')
            copyfile(strcat(postdir,'faces'),strcat(subjdir,'\post\faces'),'f');
        end
    end
  
    

