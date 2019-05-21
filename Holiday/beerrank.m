function beerrank()
%-------------------------------------------------------------------------
% beerrank(): takes in a list of beers, ranking criteria, and allows the
% user to enter rankings and produce a chart of averages and winners!
% Created on December 14, 2010 for the LoNG annual Tasting Party!
%-------------------------------------------------------------------------
% RUNNING:
% - should be run with no input arguments
% - will take in a number of beers, and output file name
%      if outfile already exists, will append data to next empty row
%      if does not exist, will create new file with appropriate headers
% - rankings should be separated by spaces, do not input non-numbers
%-------------------------------------------------------------------------
% OUTPUT
% RESULTS.mat: contains all variables used in matlab, updated as is running
% ___AVG.xlsx: is an excel file that contains averages for each beer
% ___RAW.xlsx: contains the raw data
% Beer names and winners for each category are output to the main window
% -------------------------------------------------------------------------
% FUTURE UPDATE IDEAS
% - Content validation of input (to check for non-numerical input)
% - Allow user to specify categories
% - Make entire thing more function based
% - Either truncate or round decimal averages
% - Allow for ties, and possibly a print out of all rankings
%--------------------------------------------------------------------------

fprintf('\n%s\n%s\n%s\n','Beer Ranking 1.0','Vanessa Sochat','December, 2010');

%--------------------------------------------------------------------------
% Ask for User Input:
%--------------------------------------------------------------------------
if nargin ~= 0  % The number of arguments should always be zero.  Exit if it isn't
    error('Beer Ranking() does not take any arguments.  Please try again.');
end

prompt = {'Enter number of beers:','Enter output file name (sans extension):'};
dlg_title = 'BEER RANKING INPUT';
num_lines = 1;
def = {'10','beer_rankings'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
% answer(1) is the number of beers, and answer(2) is the output file name
output=strcat(pwd,'\',answer{2});

% Take in beer names
for i=1:str2double(answer{1})
    BEERS(i) = inputdlg([ 'Beer Number ' num2str(i) ],'ENTER BEER NAME',1);
end

%--------------------------------------------------------------------------
% Rankings Specified in Advance:
%--------------------------------------------------------------------------
RANKINGS{1}='Holiday Cheer (Seasonal Quality) [1-10]';
RANKINGS{2}='Drinkability (Can I drink more than 3?) [1-10]';
RANKINGS{3}='Viscosity (Texture) [1-10]';
RANKINGS{4}='Taste [1-10]';
RANKINGS{5}='Perceptual Appeal (Nose, Color) [1-10]';
RANKINGS{6}='COMMENTS';


%--------------------------------------------------------------------------
% Collect Rankings for Each Beer
%--------------------------------------------------------------------------

for i=1:length(BEERS)
    prompt={RANKINGS{1},RANKINGS{2},RANKINGS{3},RANKINGS{4},RANKINGS{5},RANKINGS{6}};
    %       answer{1}    answer{2}   answer{3}  answer{4}   answer{5}   answer{6}
    dlg_title = [ 'RANKING FOR BEER ' num2str(i) ];
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    for j=1:length(answer)-1 % We subtract 1 because we don't calculate for comments
        % Calculate the average for each Ranking, and save into Structure, and
        % save structure in case we error out!
        numbers=regexp(strtrim(answer{j}),' ','split');
        % Reset the sum and add up numbers for current selection:
        sum = 0;
        num_count = 0;
        for k=1:length(numbers)
            if isempty(numbers{k})==0
                sum=sum+str2double(strtrim(numbers{k}));
                num_count = num_count + 1;
            end
        end
        average(j)=(sum/num_count);
    end
 
%--------------------------------------------------------------------------
% Create Data structures
%--------------------------------------------------------------------------
    % Create a structure to hold average data
    RESULTS{i}=struct('BEER_NAME',BEERS{i},'Holiday_Cheer',average(1),'Drinkability',average(2),'Viscosity',average(3),'Taste',average(4),'Perceptual_Appeal',average(5),'Comments',answer{6});
    
    % Create a structure to hold raw_ratings data
    RESULTS_RAW{i}=struct('BEER_NAME',BEERS{i},'Holiday_Cheer_raw',answer(1),'Drinkability_raw',answer(2),'Viscosity_raw',answer(3),'Taste_raw',answer(4),'Perceptual_Appeal_raw',answer(5),'Comments',answer{6});

    % save .mat in case the script is accidentally stopped
    clear answer average; save RESULTS.mat
end

%--------------------------------------------------------------------------
% Prepare Results Files
%--------------------------------------------------------------------------
% Prepare AVERAGE results file
% If the file exists, append to it, and read in the excel file to find the last row - this is the NUMERIC VARIABLE WITH 2 ADDED
if exist([ output '_AVG.xlsx' ],'file')==1
    [NUMERIC,TXT,RAW]=xlsread([ output '_AVG.xlsx' ]);  lastrowa=length(NUMERIC)+2;
    clear NUMERIC TXT RAW;
else % if it doesn't exist, we can just write the heading to a new file.
    header={ 'BEER_NAME' 'Holiday_Cheer' 'Drinkability' 'Viscosity' 'Taste' 'Perceptual_Appeal' 'Comments' };
    lastrowa=1; range = [ 'A' num2str(lastrowa) ];
    [SUCCESS,MESSAGE]=xlswrite([ output '_AVG.xlsx' ],header,'RAW',range); lastrowa = lastrowa+1;
    clear SUCCESS MESSAGE header;
end

% Prepare RAW results file
if exist([ output '_RAW.xlsx' ],'file')==1
    [NUMERIC,TXT,RAW]=xlsread([ output '_RAW.xlsx' ]);  lastrowr=length(NUMERIC)+2;
    clear NUMERIC TXT RAW;
else % if it doesn't exist, we can just write the heading to a new file.
    header={ 'BEER_NAME' 'Holiday_Cheer_raw' 'Drinkability_raw' 'Viscosity_raw' 'Taste_raw' 'Perceptual_Appeal_raw' 'Comments' };
    lastrowr=1; range = [ 'A' num2str(lastrowr) ];
    [SUCCESS,MESSAGE]=xlswrite([ output '_RAW.xlsx' ],header,'RAW',range); lastrowr = lastrowr+1;
    clear SUCCESS MESSAGE header;
end
    
% Write all AVERAGE results to file
for i=1:size(RESULTS,2)
    array={ BEERS{i} RESULTS{i}.Holiday_Cheer RESULTS{i}.Drinkability RESULTS{i}.Viscosity RESULTS{i}.Taste RESULTS{i}.Perceptual_Appeal RESULTS{i}.Comments };
    range = [ 'A' num2str(lastrowa) ];
    [SUCCESS,MESSAGE]=xlswrite([ output '_AVG.xlsx' ],array,'RAW',range); lastrowa = lastrowa+1;      % Write each user info to the next open row in the output file
    if (SUCCESS ~= 1)
        error([ 'Unable to write to file.  Error message is: ' MESSAGE ]);
    end; clear SUCCESS MESSAGE
end

% Write all RAW results to file
for i=1:size(RESULTS_RAW,2)
    array={ BEERS{i} RESULTS_RAW{i}.Holiday_Cheer_raw RESULTS_RAW{i}.Drinkability_raw RESULTS_RAW{i}.Viscosity_raw RESULTS_RAW{i}.Taste_raw RESULTS_RAW{i}.Perceptual_Appeal_raw RESULTS_RAW{i}.Comments };
    range = [ 'A' num2str(lastrowr) ];
    [SUCCESS,MESSAGE]=xlswrite([ output '_RAW.xlsx' ],array,'RAW',range); lastrowr = lastrowr+1;      % Write each user info to the next open row in the output file
    if (SUCCESS ~= 1)
        error([ 'Unable to write to file.  Error message is: ' MESSAGE ]);
    end; clear SUCCESS MESSAGE
end

%--------------------------------------------------------------------------
% Calculate Rankings
%--------------------------------------------------------------------------

fprintf('%s%s\n',num2str(size(RESULTS,2)),' beers succesfully rated and recorded');
fprintf('%s\n','Calculating rankings...');

% Put the average value and beer name into each structure
for l=1:size(RESULTS,2)
    cheer_rankings{l}=struct('Beer_Name',BEERS{l},'Average',RESULTS{l}.Holiday_Cheer);
    drink_rankings{l}=struct('Beer_Name',BEERS{l},'Average',RESULTS{l}.Drinkability);
    vis_rankings{l}=struct('Beer_Name',BEERS{l},'Average',RESULTS{l}.Viscosity);
    taste_rankings{l}=struct('Beer_Name',BEERS{l},'Average',RESULTS{l}.Taste);
    percep_rankings{l}=struct('Beer_Name',BEERS{l},'Average',RESULTS{l}.Perceptual_Appeal);
end

% Calculate the "winner"
[winner_cheer,average_cheer]=calcWinner(cheer_rankings);
[winner_drink,average_drink]=calcWinner(drink_rankings);
[winner_vis,average_vis]=calcWinner(vis_rankings);
[winner_taste,average_taste]=calcWinner(taste_rankings);
[winner_percep,average_percep]=calcWinner(percep_rankings);

% Write the winning beers to file
array={ 'WINNERS' winner_cheer winner_drink winner_vis winner_taste winner_percep };
range = [ 'A' num2str(lastrowr) ];
[SUCCESS,MESSAGE]=xlswrite([ output '_AVG.xlsx' ],array,'RAW',range);
if (SUCCESS ~= 1)
    error([ 'Unable to write to file.  Error message is: ' MESSAGE ]);
end; clear SUCCESS MESSAGE


%--------------------------------------------------------------------------
% Present Rankings to User
%--------------------------------------------------------------------------
fprintf('\n%s\n\n','BEER NAMES')
for v=1:length(BEERS)
    fprintf('%d%s%s\n',v,': ',BEERS{v})
end

fprintf('\n%s\n\n','WINNERS FOR CATEGORIES')
fprintf('%s%s%s%d\n','Holiday Cheer: ',winner_cheer,' Average: ',average_cheer);
fprintf('%s%s%s%d\n','Drinkability: ',winner_drink,' Average: ',average_drink);
fprintf('%s%s%s%d\n','Visual Appeal: ',winner_vis,' Average: ',average_vis);
fprintf('%s%s%s%d\n','Taste: ',winner_taste,' Average: ',average_taste);
fprintf('%s%s%s%d\n','Perceptual Appeal: ', winner_percep,' Average: ',average_percep);

fprintf('\n%s','Thank you for running beerrank.m!')
fprintf('\n%s\n','For full results please see the output excel files.');

save RESULTS.mat

%--------------------------------------------------------------------------
% calcWinner returns the highest average for a group
%--------------------------------------------------------------------------
function [w,avg] = calcWinner(input_matrix)
avg=0;
    for m=1:size(input_matrix,2)
        current_avg=input_matrix{m}.Average;
            if (current_avg > avg) 
                avg=current_avg; w=input_matrix{m}.Beer_Name;
            end
    end
end

end
