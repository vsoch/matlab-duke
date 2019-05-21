function loc=mk_sphere_mask2(loc,radius,img,outfilename,coordspace)
% creates a mask containing a single sphere
% input arguments:
% loc: a 3x1 vector with x/y/z coordinates
% radius: radius of sphere in mm
% img: an image from which to obtain the space for the images
% coordspace: 'mm' for mm coords, 'vox' for vox coords (default: mm)
%
% this new version uses the avw/fsltools instead of going through matlab

% Copyright 2004, Russell Poldrack, poldrack@ucla.edu
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% For a copy of the GNU Public License, see <http://www.gnu.org/licenses/>.
%

% Change log:
% 1/16/08 - updated to work with fsl3 or 4

VERBOSE=1;

if ~isnumeric(loc) | length(loc)~=3,
    fprint('Bad location or no location specified\n\nUSAGE:\n');
    help(mfilename);
    return
end;

if ~exist('img'),
    fprint('No base image specified\n\nUSAGE:\n');
    help(mfilename);
    return
end;

if ~exist('coordspace'),
    coordspace='mm';
end;

% get FSL version and check for executables

fsldir=getenv('FSLDIR');
if isempty(fsldir),
  fsldir='/space/raid/fmri/fsl';
end;

fslversion=load([fsldir '/etc/fslversion']);

if fslversion < 4,
    fprintf('%s requires FSL version 4\n',mfilename);
    return
end;

fsl_directory = [fsldir '/bin/'];
if exist([fsl_directory 'fslmaths'])==0,
       disp(sprintf('Warning- FSL executables not found:  %s', fsl_directory ));  
       disp(sprintf('  FSL binaries [e.g. flirt, fslmaths] must be in your path.'));  
       return
end %if directory exists


% first get the voxel-space coordinate


if strcmp(coordspace,'mm'),
    loc_mm=loc;
    cmd=sprintf('echo "%d %d %d" | std2imgcoord -img %s -vox -',...
        loc_mm,img);
    if VERBOSE, fprintf('%s\n',cmd);end;
    [foo,locstr]=unix(cmd);
    loc_vox=sscanf(locstr,'%d %d %d')
    if isempty('outfilename'),
        sphmsk=sprintf('sphmsk_mm_%dx_%dy_%dy_r%d',loc_mm,radius);
    else,
        sphmsk=outfilename;
    end;
else,
    loc_vox=loc;
    
    cmd=sprintf('echo "%d %d %d" | img2stdcoord -img %s -vox -| grep -v WARNING',...
        loc_vox,img);
    if VERBOSE, fprintf('%s\n',cmd);end;
    [foo,locstr]=unix(cmd);
    locstr=strrep(locstr,'WARNING:: standard coordinates not set in image','');
    loc_mm=sscanf(locstr,'%f %f %f')
    
    if isempty('outfilename'),
        sphmsk=sprintf('sphmsk_vox_%.0fx_%.0fy_%.0fy_r%d',loc_mm,radius);
    else,
        sphmsk=outfilename;
    end;
end;


cmd=sprintf('fslmaths %s -abs -add 1 -roi %d 1 %d 1 %d 1 0 1 -bin %s',...
    img,loc_vox,sphmsk);
if VERBOSE, fprintf('%s\n',cmd);end;
unix(cmd);

cmd= sprintf('fslmaths %s -kernel sphere %d -dilF %s',...
    sphmsk,radius,sphmsk);
if VERBOSE,fprintf('%s\n',cmd);end;
unix(cmd);
