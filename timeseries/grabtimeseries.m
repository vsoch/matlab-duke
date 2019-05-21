%% GRAB TIMESERIES:
% Creates a matrix of average mean timeseries for each VOI in individual subject folders, separating out VOI name and number of subjects included
% This data is then formatted into a csv file to be used to create an interactive chart with Google Charts (Gapminder)


%% GET DATA TIMESERIES
% Get list of all subjects in Analyzed Folder
anadir = 'path/path/path'; cd(anadir); all = dir;

% These are set in advance so we have control over our charts
voi(1).name = 'Faces_gr_Shapes'; voi(2).name = 'Fear_gr_Shapes'; voi(3).name = 'Anger_gr_Shapes'; voi(4).name = 'Surprise_gr_Shapes'; voi(5).name = 'Neutral_gr_Shapes';

for k=1:length(voi); voi(k).size=0; voi(k).size=0; voi(k).task='Faces'; end

for i=3:length(all); if regexp(all(i).name,'\d{8}_\d{5}'); cd(horzcat(anadir,all(i).name)); if exist(horzcat(anadir,all(i).name,'\VOIs\'),'dir'); cd(horzcat(anadir,all(i).name,'\VOIs\'));
            for j=1:length(voi); if exist(horzcat(anadir,all(i).name,'\VOIs\',voi(j).name),'dir'); voi(j).size = voi(j).size+1; cd(horzcat(anadir,all(i).name,'\VOIs\',voi(j).name)); mats = what;
                    for l=1:length(mats.mat); current = load(mats.mat{1});  % MAT file name
                                                    
                        if isfield(voi(j),'con')==0; voi(j).con=''; end     % If we have no contrast fields, make the first
                        % Pull info from current .mat (in format name_subnum.mat)
                        marker = regexp(mats.mat{l},'\.'); matname = mats.mat{l}(5:marker-5); subnum = mats.mat{l}(marker-3:marker-1); found = 0;
                        
                        % Cycle through current con fields, if we have a match, add this data there.  If not, make a new one
                        for n = 1:length(voi(j).con); if strcmp(voi(j).con(n).name,matname); if (length(current.Y)==length(voi(j).con(n).val));
                                    if strcmp(voi(j).con(n).subnum,subnum); found = 1; voi(j).con(n).size = voi(j).con(n).size + 1;     % Add 1 to the size
                                        for m = 1:length(current.Y); voi(j).con(n).val(m) = current.Y(m)+voi(j).con(l).val(m); end; end; end; end; end;
                          
                        % If we didn't find it, then add a new one
                        if (found == 0); newspot = length(voi(j).con)+1; voi(j).con(newspot).val = current.Y; voi(j).con(newspot).size = 1; voi(j).con(newspot).name = matname;voi(j).con(newspot).subnum = subnum; end; end; end;end;end;end;end;
 
% Now calculate the mean of each summed value matrix, and replace the sum with the mean 
for i=1:length(voi);for j=1:length(voi(i).con); for k=1:length(voi(i).con(j).val); voi(i).con(j).val(k) = (voi(i).con(j).val(k))/voi(i).con(j).size; end; end; end;
keep voi;

%% WRITE TO CSV FILE

% Initialize and print to file
fed = fopen([ 'timeseries_' date '.csv' ], 'wt');
fprintf(fed,'%s\n','Contrast,Time,Value,Task,Mask,Subjects');

for i=1:numel(voi)
    for j=1:numel(voi(i).con)
    image_count = zeros(1,length(voi(i).con(j).val));
    for k = 1:(length(voi(i).con(j).val)), image_count(k) = 2000+ k; end
        for m=1:length(voi(i).con(j).val)
            fprintf(fed, '%s%s%i%s%5.4f%s%s%s%s%s%i\n',voi(i).name,',',image_count(m),',',voi(i).con(j).val(m),',',voi(i).task,',',voi(i).con(j).name,',',voi(i).con(j).size);
        end
    end
end

fclose(fed);

fprintf('%s\n','Done running grab_timeseries');
fprintf('%s\n','Thank you come again!');

