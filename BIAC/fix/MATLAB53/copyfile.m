function varargout=copyfile(SourceFile,DestinationFile,flag)
%COPYFILE Copy file.
%   COPYFILE(SOURCE,DEST) will copy the file SOURCE to the new file DEST.
%   SOURCE and DEST may be an absolute pathname or a pathname relative to the
%   current directory. 
%
%   COPYFILE(SOURCE,DEST,'writable') will make sure DEST is writable.
%
%   STATUS = COPYFILE(...) will return 1 if the file is copied
%   successfully and 0 otherwise.
%
%   [STATUS,MSG] = COPYFILE(...) will return a non-empty error
%   message string if an error occurred.
%
%   See also DELETE, MKDIR.

%   Loren Dean
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   Revision: 1.8  Date: 1998/10/06 18:39:38

% Duke-UNC Brain Imaging and Analysis Center modifications:
%   dos() returns an error if current directory is UNC path
%   Added try-catch to handle the error properly.

% BIAC Revision: $Id: copyfile.m,v 1.5 2004/07/27 03:52:01 michelich Exp $

ErrorMessage='';
Status = 1;
error(nargchk(2,3,nargin));

if nargin<3, flag = ''; end

[SourceDir,SourceFile]=GetDirFile(SourceFile);
[DestDir,DestFile]=GetDirFile(DestinationFile);

% For the PC and UNIX, add double quotes around the source and
% destination files so that file names with spaces can be supported.
if (strncmp(computer,'PC',2) | isunix)
  Src = ['"' fullfile(SourceDir,SourceFile) '"'];
  Dest = ['"' fullfile(DestDir,DestFile) '"'];
else
  Src =fullfile(SourceDir,SourceFile);
  Dest=fullfile(DestDir,DestFile);
end

%% Check to see if the parent directory exists
if ~exist(SourceDir,'dir'), 
 % The directory does not exist
 Status = 0;
 ErrorMessage = ['Source directory, ' SourceDir ', does not exist or ' ...
                 'is unreadable.'];
 
elseif ~exist(DestDir,'dir'),
 Status = 0;
 ErrorMessage = ['Destination directory, ' DestDir ', does not exist ' ...
                 'or is unreadable.'];
 
elseif ~exist(fullfile(SourceDir,SourceFile),'file')
 Status = 0;
 ErrorMessage = ['Source file, ' fullfile(SourceDir,SourceFile) ...
                 ', does not exist or is unreadable.'];
	   
elseif exist(fullfile(SourceDir,SourceFile),'dir')
 Status = 0;
 ErrorMessage = ['Source file, ' fullfile(SourceDir,SourceFile) ...
                 ', is a directory and can''t be copied.'];
	   
end % if ~exist

% if Status is 1 then everything is good up to this point.
if Status == 1,
  c=computer;
  if isunix | isvms,
    [Status, result] = unix(['cp ' Src ' ' Dest]);

    if Status==0 & strcmp(flag,'writable')
      [Status, result] = unix(['chmod +w ' Dest]);
    end
  elseif strncmp(c,'PC',2),
% This is to check and see if the dos command is working.  In Win95
% if the current directory is a deeply nested directory or sometimes
% for TAS served file systems, the output pipe does not work.  The 
% solution is to make the current directory safe, %windir% and put it back
% when we are done.  The test is the cd command, which should always
% return something.
    try
      [Status, result] = dos('cd');
    catch
      result='';
    end
    if isempty(result)
        OldDir = pwd;
		cd(getenv('windir'))
    else
        OldDir = [];
    end
    [Status, result] = dos(['copy ' Src ' '  Dest]);
    if Status==0 & strcmp(flag,'writable')
      [Status, result] = dos(['attrib -r ' Dest]);
    end
    if ~isempty(OldDir)
        cd(OldDir);
    end
  elseif strncmp(c,'MAC',3),
    Status = 1-cpfile(Src,Dest);
    
  end % if computer type
  Status=(Status==0);
  
  % Need to flip Status of 0 and 1 because they mean the opposite
  % thing for the output of this function.
  
end % if Status == 1

if Status==0,
  ErrorMessage = ['Cannot copy file, ' Src ' to ' Dest];
end

if nargout == 0,
  error(ErrorMessage)
  
else,
  varargout{1} = Status;
  varargout{2} = ErrorMessage;
  
end % if nargout

%------------------------------------------------------
function [Directory,FileName]=GetDirFile(OrigFile)
  Loc = find(OrigFile==filesep);
  if isempty(Loc),
    Directory = pwd;
    FileName=OrigFile;
  else
    Directory = OrigFile(1:Loc(end));
    FileName = OrigFile(Loc(end)+1:end);
  end
