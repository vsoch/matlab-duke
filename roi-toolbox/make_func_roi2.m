function make_func_roi2(zstat,mask,thresh,radius,nmax)
% 
% USAGE: make_func_roi(zstat,thresh,radius,nmax)
% make functional rois from a statistical map
% should be performed on a zstat map from a higher-level
% anlaysis, which is in standard space
%
% 

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
% 1/16/08 (RP) - updated to deal properly with nii/img formats using NIFTI tools

% first check for nifti tools from http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/

if isempty(which('load_nii')),
    fprintf('This program requires the NIFTI tools for matlab:\n');
    fprintf('Available from: http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/\n');
    return;
end;

% get FSL version and check for executables

fsldir=getenv('FSLDIR');
if isempty(fsldir),
  fsldir='/space/raid/fmri/fsl';
end;

fslversion=load([fsldir '/etc/fslversion']);

if fslversion >= 4,
    cmdprefix='fsl';
else
    cmdprefix='avw';
end;

fsl_directory = [fsldir '/bin/'];
if exist([fsl_directory 'flirt'])==0,
       disp(sprintf('Warning- FSL executables not found:  %s', fsl_directory ));  
       disp(sprintf('  FSL binaries [e.g. flirt, %sorient] must be in your path.',cmdprefix));  
       fsl_directory = '';
end %if directory exists



% check for nmax arg

additional_args='';
if exist('nmax'),
    if isnumeric(nmax),
            additional_args=sprintf('-n %d',nmax);
    end;
end;

% get zstat file info

[zstat_dir,zstat_stem,zstat_type]=fileparts(zstat);

if isempty(zstat_dir),
  zstat_dir=pwd
end;

% run FSL cluster program
cluster_tmp_file=sprintf('/tmp/roi_tmp_%.0f',fix(rand*2^20));
lmax_tmp_file=sprintf('%s_lmax',cluster_tmp_file);
cmd=sprintf('cluster -i %s -t %0.3f --olmax=%s -o %s %s',...
	    zstat,thresh,lmax_tmp_file,cluster_tmp_file,additional_args);
fprintf('%s\n',cmd);
unix(cmd);
cmd=sprintf('cat %s | grep -v Cluster > %s',lmax_tmp_file,[lmax_tmp_file '2']);
unix(cmd);
cmd=sprintf('mv -f %s %s',[lmax_tmp_file '2'], lmax_tmp_file);
unix(cmd);
cmd=sprintf('%sinfo %s |grep -v file_type |grep -v filename | grep -v data_type > %s',cmdprefix,zstat,[cluster_tmp_file '_hdrinfo']);
unix(cmd);
cluster_tmp_file;

warning off MATLAB:MKDIR:DirectoryExists

mkdir(zstat_dir,'roi');

% read header info

[hdr_fields hdr_data]=textread([cluster_tmp_file '_hdrinfo'],'%s%f');

for h=1:length(hdr_fields),
  eval(sprintf('hdr.%s=%f;',hdr_fields{h},hdr_data(h)));
end;
unix(sprintf('rm %s_hdrinfo',cluster_tmp_file));

% load temp files then delete them
lmax=load(lmax_tmp_file);
unix(sprintf('rm %s',lmax_tmp_file));


% cycle through the local maxima and create the roi images

n_maxima=size(lmax,1);
for m=1:n_maxima,

    fprintf('roi %d\n',m);
    fname=sprintf('%s/roi/%s_clust03%d',zstat_dir,zstat_stem,m);
    mk_sphere_mask2(lmax(m,3:5),radius,zstat,fname,'vox');
end;  

matfilename=sprintf('%s/roi/cluster_info_%s.mat',zstat_dir,zstat_stem);
save(matfilename,'lmax');
