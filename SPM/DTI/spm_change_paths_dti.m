function spm_change_paths_dti(oldpathswd,oldpath,newpath,slash)
%
% This function replaces portions of each path contained in SPM.mat, in
% variables SPM.swd, SPM.xY.P and SPM.xY.VY.fname.
% It was thought to be used wherever the files must be moved from one pc
% to another.
% If paths are not all the same or if you don't know the old path, you can
% use this function without arguments. Eventually you can change only some
% variables at a time.
%
% ----------SYNTAX----------
%
%   spm_change_paths(oldpath,newpath,slash) -> change automatically each path
%   spm_change_paths                        -> show paths and ask for
%                                              paths to be changed
%
% ---------IMPORTANT---------
%
%   - it works only if the portion of the path to be changed is located
%     at the beginning of the entire path
%   - SPM.mat must be located in the work directory
%   - oldpath is case sensitive
%   - slash defines what kind of slash (or backslash) is needed in the
%     new path (this is important when you are moving from a pc to a
%     server or viceversa)
%   - in order to avoid mistakes, it is better to change just essential
%     portions of the path, i.e. if you want to change
%     C:\Experiment\Example\...     in     G:\Test\Experiment\Example\...
%     you should write:
%                       spm_change_paths('C:','G:\Test','\')
%
% --------ATTENTION--------
%
%   Original SPM.mat will be overwritten, so it's better to make a copy,
%   for example SPM_oldpath.mat
%
% ---------EXAMPLES---------
%
%   spm_change_paths
%   spm_change_paths('C:','G:\Test','\')
%   spm_change_paths('C:\MyFolder','//SERVER/MyFolder','/')
%
% --
% Written by:        Pietro Santoro - pietro.santoro@hotmail.com
% Last modified:     06/10/2008


% General lines

if nargin == 0
   load SPM.mat SPM;
   disp(' ');
   disp(' Path in SPM.swd is:');
   disp(SPM.swd);
   disp(' ');
   disp(' First path in SPM.xY.P is:');
   disp(SPM.xY.P(1,:));
   disp(' ');
   disp(' First path in SPM.xY.VY.fname is: ');
   disp(SPM.xY.VY(1).fname);
   disp(' ');
   disp(' ');
   oldpath = input('Insert portion of path to be changed: ','s');
   newpath = input('Insert new portion of path: ','s');
   slash = input('Slash ''/'' or Backslash ''\\''?: ','s');
    if slash == '\'
       old_slash = '/';
    elseif slash == '/'
       old_slash = '\';
    else
       error('Incorrect slash or backslash, see ''help spm_change_paths''')
    end
   disp(' ');
   reply1 = input(' Change SPM.swd? Y/N [Y]: ','s');
    if isempty(reply1) | reply1 == 'Y' | reply1 == 'y'
       change_swd(oldpath,newpath,slash,old_slash);
    else
       disp(' ');
    end
   reply2 = input(' Change SPM.xY.P? Y/N [Y]: ','s');
    if isempty(reply2) | reply2 == 'Y' | reply2 == 'y'
       change_P(oldpath,newpath,slash,old_slash);    
    else
       disp(' ');
    end 
   reply3 = input(' Change SPM.xY.VY.fname? Y/N [Y]: ','s');
    if isempty(reply3) | reply3 == 'Y' | reply3 == 'y'
       change_VY(oldpath,newpath,slash,old_slash);
    else
       disp(' ');
    end

elseif nargin == 4
    if slash == '\'
       old_slash = '/';
    elseif slash == '/'
       old_slash = '\';
    else
       error('Incorrect slash or backslash, see ''help spm_change_paths''')
    end
   change_swd(oldpathswd,oldpath,newpath,slash,old_slash);
   %We aren't changing these paths at the moment because the paths in the
   %SPM.mat for DTI data are different than the paths for BOLD data, so
   %this particular script doesn't work for the DTI data.
   %change_P(oldpath,newpath,slash,old_slash);
   change_VY(oldpath,newpath,slash,old_slash);

elseif nargin ~= 0 &  nargin ~= 4
   error('Incorrect number of input arguments, see ''help spm_change_paths''')
   
end

disp(' Paths in SPM.mat modified as requested. ');


% Replace path contained in SPM.swd

function change_swd(oldpathswd,oldpath,newpath,slash,old_slash)
 load SPM.mat SPM;
 size_swd = size(SPM.swd);
 size_oldpathswd = length(oldpathswd);
 size_oldpath = length(oldpath);
 size_newpath = length(newpath);
 new_size_swd = size_swd(1,2) - size_oldpathswd + size_newpath;
   for i = 1:new_size_swd
      if i <= size_newpath
          temp(i) = newpath(i);
          if temp(i) == old_slash
              temp(i) = slash;
          end;
      else
          temp(i) = SPM.swd(size_oldpathswd-size_newpath+i);
          if temp(i) == old_slash
              temp(i) = slash;
          end;
      end
  end
 SPM.swd = temp;
 save -append SPM.mat SPM;
 disp(' SPM.swd changed successfully.');
 disp(' ');


% Replace paths contained in SPM.xY.P 

function change_P(oldpath,newpath,slash,old_slash)
 load SPM.mat SPM;
 size_P = size(SPM.xY.P);
  if size_P(1,2) == 1
    for i = 1:size_P
        SPM.xY.P(i) = strrep(SPM.xY.P(i),oldpath,newpath);
        SPM.xY.P(i) = strrep(SPM.xY.P(i),old_slash,slash);
    end
  else
   size_oldpath = length(oldpath);
   size_newpath = length(newpath);
   new_size_P = size_P(1,2) - size_oldpath + size_newpath;
    for i=1:size_P(1,1)
      for j = 1:new_size_P
          if j <= size_newpath
              temp2(i,j) = newpath(j);
              if temp2(i,j) == old_slash
                temp2(i,j) = slash;
              end;
          else
              k = size_oldpath-size_newpath+j;
              temp2(i,j) = SPM.xY.P(i,k);
              if temp2(i,j) == old_slash
                temp2(i,j) = slash;
              end;
          end
      end
    end
    SPM.xY.P = temp2;
  end
 save -append SPM.mat SPM;
 disp(' SPM.xY.P changed successfully.');
 disp(' ');


% Replace paths contained in SPM.xY.VY.fname

function change_VY(oldpath,newpath,slash,old_slash)
  load SPM.mat SPM;
  size_VY = size(SPM.xY.VY);
   for i = 1:size_VY(1,1)
       SPM.xY.VY(i).fname = strrep(SPM.xY.VY(i).fname,oldpath,newpath);
       SPM.xY.VY(i).fname = strrep(SPM.xY.VY(i).fname,old_slash,slash);
   end
  save -append SPM.mat SPM;
  disp(' SPM.xY.VY.fname changed successfully.');
  disp(' ');


% EOF
