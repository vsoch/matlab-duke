function battdata_add()
%-------------------------------------------------------------------------
% battdata_add(): allows the user to input a list of subject (DNS) ID's 
% and have the subject data from DNSXXXX.DDT added to an excel file, to be
% used to add and score data in DDTSolverWithMacroDuke in the Analysis/
% Battery directory.  Upon being added, the subject data does not need to
% be deleted from the battdata_raw excel - it can serve as a backup.
%-------------------------------------------------------------------------
% DEPENDENCIES:
% - Raw data files must be located under Z:\ in folders of format DNS0001
% - Within each subject folder there must be a *.DDT file
% - BATTERY_RAW.xlsx must be located under N:\DNS.01\Analysis\Battery
%-------------------------------------------------------------------------

fprintf('\n%s\n%s\n%s\n','Raw Battery Data Import','Vanessa Sochat','December, 2010');

%--------------------------------------------------------------------------
% User Input DNS ID's
%--------------------------------------------------------------------------
if nargin ~= 0  % The number of arguments should always be zero.  Exit if it isn't
    error('battdata_add() does not take any arguments.  Please try again.');
end

ids = inputdlg('Format DNSXXX1 DNSXXX2','Please enter DNS IDs');    % Ask for DNS IDs from the user:
ids = deblank(ids);                                                 % Get rid of any empty space at the end
ids_temp = regexp(ids, '\s', 'split'); ids = ids_temp{1};           % Use regexp to split the ID string into the IDs, and put it back into ids

%--------------------------------------------------------------------------
% Write user data to excel file
%--------------------------------------------------------------------------

if exist('N:\DNS.01\Analysis\Battery\BATTERY_RAW.xlsx','file')      % Check that results file exists
    output = 'N:\DNS.01\Analysis\Battery\BATTERY_RAW.xlsx';
end
if exist('Z:\DNS0001','dir')==0                                     % Check for Z:\ drive
    error('Cannot find mapped Z drive with subject folders.  Exiting.');
end

for i=1:length(ids)                                                 
    subject = deblank(ids{i}); subject=upper(subject);       % Read in subject, rid of empty space, make uppercase
    if exist([ 'Z:\' subject ],'dir')                        % Check that user folder and data exists
        file=dir(fullfile('Z:\',subject,'*.DDT'));
        if isempty(file)
            error(['*.DDT data for ' subject 'cannot be found!  Exiting.' ]);
        end
        fid = fopen(fullfile('Z:\',subject,'\',file.name));  % Read data from text file and put into variable
        values = textscan(fid, '%s'); values=values{1}; fclose(fid);
        DATA{i}=struct('DNSID',subject,'DDTFile',file.name,'ONE',values{2},'TWO',values{3},'THREE',values{4},'FOUR',values{5},'FIVE',values{6},'SIX',values(7),'SEVEN',values{8},'date',date);
        clear values;
    end
end

save DATA.mat

%--------------------------------------------------------------------------
% Add New Data to Excel File
%--------------------------------------------------------------------------
% Read in the excel file to find the last row - this is the NUMERIC
% VARIABLE WITH 2 ADDED
[NUMERIC,TXT,RAW]=xlsread(output);  lastrow=length(NUMERIC)+2;
clear NUMERIC TXT RAW;

for i=1:size(DATA,2)
    array={ DATA{i}.DNSID DATA{i}.DDTFile DATA{i}.ONE DATA{i}.TWO DATA{i}.THREE DATA{i}.FOUR DATA{i}.FIVE DATA{i}.SIX DATA{i}.SEVEN DATA{i}.date };  % Prepare output array for each subject
    range = [ 'A' num2str(lastrow) ];
    [SUCCESS,MESSAGE]=xlswrite(output,array,'RAW',range); lastrow = lastrow+1;      % Write each user info to the next open row in the output file
    if (SUCCESS ~= 1)
        error([ 'Unable to write to file.  Error message is: ' MESSAGE ]);
    end; clear SUCCESS MESSAGE
end

fprintf('%s%s\n',num2str(size(DATA,2)),' subjects succesfully added to RAW_BATTERY.xlsx');
end