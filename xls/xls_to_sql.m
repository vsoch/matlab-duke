function xls_to_sql(input,sheet,outfile,database,table)

% This script reads in an excel sheet and converts it into sql insert
% statements.  The first row is expected to be the titles for the tables,
% followed by rows of raw data.
%-------------------------------------------------------------------------
% INPUT
% input    ----- input excel file should be excel file, .xls or .xlsx
% sheet    ----- name of sheet to read from
% outfile  ----- name of output file (without extension)
% database ----- name of database to print to
% table    ----- name of table to print to

% Read in file with raw gm,wm,fa data
[~,~,DATA] = xlsread(input,sheet);

% Open file for writing
fid = fopen([ outfile '.txt' ],'w');

% Print the insert command
for i = 2:size(DATA,1)
    fprintf(fid,'%s%s%s%s%s','INSERT INTO  `',database,'`.`',table','` (');

    % Print the field names (the first row in the excel file)
    for t = 1:(size(DATA,2)-1); fprintf(fid,'%s','`',DATA{1,t},'`, '); end
    fprintf(fid,'%s%s%s\n','`',DATA{1,(size(DATA,2))},'`)');
    fprintf(fid,'%s\n','VALUES (');
    
    % Print the data values, and base the format string on the data type
    for j = 1:(size(DATA,2)-1); 
        if ~ischar(DATA{i,j}); 
            if ~isnan(DATA{i,j}); fprintf(fid,'%s%g%s','''',DATA{i,j},''', ');
            else  fprintf(fid,'%s',''''', '); end
        else fprintf(fid,'%s','''',DATA{i,j},''', '); end
    end
    
    % Print the last field followed by a ')' and a newline
    if ~ischar(DATA{i,j}); 
        if ~isnan(DATA{i,j}); fprintf(fid,'%s%g%s\n\n','''',DATA{i,(size(DATA,2)-1)},''');');
        else fprintf(fid,'%s\n\n',''''');'); end
    else fprintf(fid,'%s\n\n','''',DATA{i,(size(DATA,2))},''');'); end
    
end

% Close file for writing
fclose(fid);

end