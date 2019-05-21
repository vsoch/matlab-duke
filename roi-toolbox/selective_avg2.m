function timepoints=selective_avg2(params)
%
% selective averaging for FSL feat analysis
% read in a 4-d analyze file
% compute selective average on all in-mask voxels
%
% required arguments:
% params: a struct containing details about analysis:
%     params.featdir: FEAT directory for analysis
%     params.MakeStandardSpaceImage = (default=1) if set to 1,
%           then standard space versions of images are created
%           set to 0 to create only native space images
%     params.StandardSpaceImage = location of standard space reference
%           image (default = avg152T1 image from fsl/etc/standard)
%     params.ter - effective temporal resolution of analysis (default = TR)
%        - note: Image Processing  Toolbox is required for TER ~= TR
%     params.PosWindow - positive time window for averaging (default=24 s)
%     params.NegWindow - negative time window for averaging (default=4 s)
%     params.sed_converter - full path of designconvert.sed - if you are
%           not work on the UCLA Func system then you will need to set this
%     params.SaveVariance - set to 1 to save variance images (default=0)
%     params.UseSmoothFIR - set to 1 to use smooth FIR (default=1)
%     params.SmoothingParameter - determines amount of smoothing
%           (default = 1/sqrt(7/TR) as per Goutte et al., 2000)
%     
% outputs:
% within the original feat directory:
%  roi: directory will contain one image for each EV in the model, named by
%    EV name
%  reg/roi: same data as in roi directory, registered to standard space
%
% Required additional code:
%
% FSL: http://www.fmrib.ox.ac.uk/fsl/
% NIFTI MATLAB Tools: http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/
% designconvert.sed: http://www.poldracklab.org/software/designconvert.sed
%

% Copyright 2004, Russell Poldrack, poldrack@ucla.edu
% With additions by Chris Rorden and Jeanette Mumford
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
% Russ Poldrack, 1/29/08
% - added nii/nii.gz support
%   Assumes that all files are of the same type - i.e., mixing nii with img
%   will likely crash it
% 
% RP, 1/30/08
% - adding smooth FIR filter
% - make saving variance an option

warning off MATLAB:divideByZero

if ~exist('params'),
 help(mfilename)
 return;
end;

if ~isfield(params,'featdir')
  help(mfilename)
 return;
end;
featdir=params.featdir;

if ~isfield(params,'SaveVariance')
  params.SaveVariance=0;
end;

if ~isfield(params,'UseSmoothFIR')
  params.UseSmoothFIR=1;
end;

% check for nifti tools from http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/

if isempty(which('load_nii')),
    fprintf('This program requires the NIFTI tools for matlab:\n');
    fprintf('Available from: http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/\n');
    return;
end;

if ~isfield(params,'sed_converter'),
  SED_CONVERTER='/space/raid/fmri/bin/designconvert.sed';
else,
  SED_CONVERTER=params.sed_converter;
end;

% check that SED_CONVERTER exists
if ~exist(SED_CONVERTER,'file'),
  fprintf('%s does not exist!\n',SED_CONVERTER);
  return;
end;

% design: a cell matrix containing filenames for either SPM.mat file
% (for SPM analysis) or FSL 3-column onset files
% make sure featdir exists and has data in it

current_dir=pwd;
try,
  cd(featdir);
catch,
  fprintf('problem changing to featdir (%s)\n',featdir);
  return;
end;

% convert design.fsf to design.m

[s,w]=system(sprintf('sed -f %s design.fsf > design.m',SED_CONVERTER));
if s,
   fprintf('problem converting design.fsf to design.m\n');
   fprintf('make sure the program sed is in your path\n');
   fprintf(' e.g. click My Computer, Properties, Advanced, Environment Variables\n');
   fprintf('      then cdouble-lick on Path and add ;c:\cygwin\bin to end and press OK \n');
  return;
end;

design_file=which('design');
fprintf('Loading design from:\n%s\n',design_file);
try,
  design;
catch,
   fprintf('problem loading design.m\n');
  return;
end;

% set up params and check fields

if ~isfield(params,'ter'),
  params.ter=fmri.tr;
else,
    params.UseSmoothFIR=0;
    fprintf('turning off smooth FIR, not currently implemented for TR ~= TER\n');
end;

if ~isfield(params,'PosWindow'),
  params.PosWindow=24;
end;

if ~isfield(params,'NegWindow'),
  params.NegWindow=4;
end;


% load in analyze file
d=dir(featdir);
gzipped_data=0;
for i=1:length(d),
    if strfind(d(i).name,'filtered_func_data.img'),
        datafilename=d(i).name;
        data_file_ext='.img';
        if strfind(d(i).name,'.gz'),
            gzipped_data=1;
        end
    elseif strfind(d(i).name,'filtered_func_data.nii'),
        datafilename=d(i).name;
        data_file_ext='.nii';
        if strfind(d(i).name,'.gz'),
            gzipped_data=1;
        end
    end
end
datafile = [featdir filesep datafilename]; %CRorden: filesep works on Unix and Windows
if gzipped_data,
    fprintf('unzipping %s\n',datafile);
    system(sprintf('gunzip %s',datafile));
    datafile=strrep(datafile,'.gz','');
end

fprintf('Loading filtered data from:\n%s\n',datafile);


try,
  func_data=load_nii(datafile);
catch,
  fprintf('error reading datafile %s\n',datafile);
  return;
end;
if gzipped_data,
    fprintf('zipping %s\n',datafile);
    system(sprintf('gzip %s',datafile));
    datafile=[datafile '.gz'];
end
params.datafile=datafile;
% load in mask file

maskfile = [featdir filesep 'mask' data_file_ext]; %CRorden: filesep works on Unix and Windows
%maskfile=sprintf('%s/mask.img',featdir);
fprintf('Loading mask from:\n%s\n',maskfile);%CR

try,
  if gzipped_data,
    fprintf('unzipping %s\n',maskfile);
    system(sprintf('gunzip %s',maskfile));
    maskfile=strrep(maskfile,'.gz','');
  end
  mask_data=load_nii(maskfile);
  if gzipped_data,
    fprintf('zipping %s\n',maskfile);
    system(sprintf('gzip %s',maskfile));
    maskfile=[maskfile '.gz'];
  end  
catch,
  fprintf('error reading mask file %s\n',maskfile);
  return;
end;
params.maskfile=maskfile;
% set up the design

params.fmri=fmri;

TR=fmri.tr;

TER=params.ter;
%ntp=fmri.npts %<- Poldrack's original code
ntp=fmri.npts-fmri.ndelete;%Nov 2004: Ojango: original script failed to deduct deleted volumes
roidata=zeros(1,ntp);

% make sure image processing toolbox is available if needed

if isempty(which('resample')) & TER ~= TR,
  fprintf('Image Processing Toolbox is necessary for subsampling\n');
  fprintf('Setting TER = TR...\n');
  TER=TR;
end;

% if TER is shorter than TR, oversample data (with lowpass filtering)

if TER ~= TR,
  if mod(TR,TER),
    trmult=TR/TER;
    TER=TR/round(trmult);
    fprintf('TR must be an even multiple of TER: changing TER to %0.3f\n', ...
            TER);
    params.ter_actual=TER;
  end;
  fprintf('resampling data to TER\n');
%  roidata=resample(roidata,TR/TER,1);
end;

% set up FIR model

PosWindow=params.PosWindow;
NegWindow=params.NegWindow;
NPosEst=round(PosWindow/TER);
NNegEst=round(NegWindow/TER);
nHEst=NPosEst + NNegEst;
params.NPosEst=NPosEst;
params.NNegEst=NNegEst;

% determine how many conditions there are

nconds=fmri.evs_orig;
timepoints=zeros(nconds,nHEst);

% fix the structures so that the index is not in the name
fields_to_fix={ 'shape' 'convolve' 'convolve_phase' ...
    'tempfilt_yn' 'deriv_yn' 'custom' 'gammasigma' 'gammadelay' ...
    'ortho'};

for c=1:nconds,
 for f=1:length(fields_to_fix),
   if isfield(fmri,sprintf('%s%d',fields_to_fix{f},c)),
     cmd=sprintf('fmri.%s(%d)={fmri.%s%d};',fields_to_fix{f},c,fields_to_fix{f},c);
    eval(cmd);
  end;
 end;
end;



% load in the onsets
% right now assume single-column input, deal with 3-column files later

ons=cell(1,nconds);
for c=1:nconds,
  if fmri.shape{c}==2, % single-column file
    fprintf('Loading condition %d onsets (single-column format):\n%s\n',...
            c,fmri.custom{c});
    [p1,p2,p3]=fileparts(fmri.custom{c});
    fmri.condname{c}=p2;
    fmri.sf(c)={load(fmri.custom{c})};
    % need to subtract off TR to get back to zero time origin
    fmri.ons{c}=find(fmri.sf{c})*fmri.tr - fmri.tr;
  elseif fmri.shape{c}==3, % 3-column format
    fprintf('Loading condition %d onsets (3-column format):\n%s\n',c,fmri.custom{c});
    tmp=load(fmri.custom{c});
    tmp=tmp(find(tmp(:,3)~=0),:);  % RP - added to deal with onset files
                                   % including zero-values lines
    %tmp = tmp';
    %ncolumns = length(tmp);
    %ncolumns = floor(ncolumns / 3);
    %tmp = reshape(tmp, 3, ncolumns); %LXB-
    %tmp = tmp'; %LXB -
    fmri.ons{c} = tmp(:,1);
    
    [p1,p2,p3]=fileparts(fmri.custom{c});
    fmri.condname{c}=p2;
  end;
end;

SCM=[];
ntp=round(ntp*(TR/TER));

for conds=1:nconds,
    % this code is based on spm_roi_fir_desmtx.m, which was in turn based on
    % from from Doug Greve at MGH

    rounded_onsets=round(fmri.ons{conds}/TER)*TER; % find nearest TR for each onset
    Par=zeros(ntp,2);
    Par(:,1)=[0:TER:(ntp-1)*TER]';
    for trial=1:length(rounded_onsets),
      Par(find(Par(:,1)==rounded_onsets(trial)),2)=1;
    end;
    tMax=(ntp-1)*TER;
    nPreStim=floor(NegWindow/TER);
    tTR = [0:TER:tMax];
    iStimIndex = find( Par(:,2) == 1 ); % get indices for this condition
    tPres = Par(iStimIndex,1);
    iok = find(tPres >= 0 & tPres <= tMax);
    tPres = tPres(iok);
    nPres = hist(tPres,tTR);
    % construct the conv mtx for this Stimulus Type %
    c1 = zeros(1,nHEst);
    Pulses = [nPres zeros(1,nPreStim) ];
    c1(1) = Pulses(1);
    E = toeplitz(Pulses,c1);
    X=[];
    % add to global conv mtx %
    X = cat(2,X,E);

    if(nPreStim ~= 0)
      X = X(1+nPreStim:ntp+nPreStim,:);
    end
    SCM=[SCM X];
    p=Par(:,2);
    save(sprintf('c%d_fsl.txt',conds),'p','-ASCII');

end;

% add column of ones to model non-zero mean
%Jmumford took this out.  You don't need an intercept if the data
%and design are demeaned and it looks like this is done below...
%SCM=[SCM ones(length(SCM),1)];

% normalize non-unit columns in desmtx

for r=1:size(SCM,2)-1,
    SCM(:,r)=SCM(:,r)-mean(SCM(:,r));
end;

% set up penalty matrix for smooth FIR
if isfield(params,'SmoothingParameter'),
             h=params.SmoothingParameter;
else,
             h=1/sqrt(7/TR);
end;
params.SmoothingParameter=h;

% estimate the model for each voxel in the mask
d_dims=size(func_data.img);

timepoints=zeros(d_dims(1),d_dims(2),d_dims(3),nconds,nHEst);

%Jmumford Need a second structure to hold var_est_b_est info
timepoints2=zeros(d_dims(1),d_dims(2),d_dims(3),nconds,nHEst);

fprintf('Percent done: ');


%roidata -> ROIdata is 492 bins, e.g. 1 per volume
for x=1:d_dims(1),
  fprintf('%d.',round(100*x/d_dims(1)));
  for y=1:d_dims(2),
    for z=1:d_dims(3),

      if ~mask_data.img(x,y,z),
        continue;
      end;
%       if true,
%          continue;
%      end;
      
      % normalize to mean 100
      
      tmp=double(func_data.img(x,y,z,:));
      
      roidata=(tmp - mean(tmp))/mean(tmp); 
      roidata=squeeze(roidata);
      if TER ~=TR,
          roidata=resample(roidata,TR/TER,1);
      end
      
      zero_check=SCM==0;
      dim_SCM=size(SCM);
      %if all zeros the sum of zero_check with = the # of rows
      all_zero=sum(zero_check)==dim_SCM(1);
      equal_cols=sum(round(corrcoef(SCM)*10000)/10000==1);
      equal_cols=equal_cols>1;
      
      leave_out=(all_zero==1 | equal_cols==1);

      %remove bad columns
      SCM2=SCM(:,leave_out==0);
          
      if params.UseSmoothFIR==1,
         % use smooth FIR method to estimate timepoints
         v=var(roidata);

         n_basis=size(SCM2,2)/nconds;
         for i=1:n_basis,
            for j = 1:n_basis,
                sigma_ij(i,j)=v*exp(-1*h/2*((i-j)^2));
            end
         end
         penalty_single=v*pinv(sigma_ij);
         penalty=penalty_single;
         if nconds>1,
            for c=2:nconds,
                penalty=blkdiag(penalty,penalty_single);
            end;
         end;
        else,
          penalty=zeros(size(SCM2,2));
      end
          
      b_est_tmp=inv(SCM2'*SCM2 + penalty)*SCM2'*roidata; %CRorden: do not transpose roidata

      %fill in blanks with obviously wrong number (-10000)
      b_est=-10000*ones(dim_SCM(2),1);
      b_est(leave_out==0)=b_est_tmp;
 
      if params.SaveVariance,
        %Jmumford adding a variance estimate to be used for proper weighting
        %dim_SCM=size(SCM);
        var_est_b_est_tmp=diag(inv(SCM2'*SCM2)*var(roidata-SCM2*b_est_tmp)*(dim_SCM(1)-1)/(dim_SCM(1)-dim_SCM(2)));

        %fill in blanks with obviously wrong number (-10000)
        var_est_b_est=-10000*ones(dim_SCM(2),1);
        var_est_b_est(leave_out==0)=var_est_b_est_tmp;
      end;
      
      for c=1:nconds,
             range_st=(c-1)*nHEst + 1;
             range_end=c*nHEst;
             timepoints(x,y,z,c,:)=b_est(range_st:range_end)';

            if params.SaveVariance,
                %Jmumford:  Add variance estimates as well(I actually am
                %unclear what this loop does)
                timepoints2(x,y,z,c,:)=var_est_b_est(range_st:range_end)';
            end
      end;
  end;
 end;
end;

% save the data
if ~exist('roi','dir'),
  mkdir(featdir,'roi');
end;
if ~exist('reg/roi','dir'),
  mkdir([featdir '/reg'],'roi');
end;

if params.SaveVariance,
%JMumford: Add new directories for new variance data
    if ~exist('roi_var','dir'),
      mkdir(featdir,'roi_var');
    end;
    if ~exist('reg/roi_var','dir'),
      mkdir([featdir '/reg'],'roi_var');
    end;
end;

save([featdir '/roi/roi_params.mat'],'params');

fsldir=getenv('FSLDIR');
if isempty(fsldir),
  fsldir='/space/raid/fmri/fsl';
end;

fslversion=load([fsldir '/etc/fslversion']);
params.fslversion=fslversion;

if fslversion >= 4,
    cmdprefix='fsl';
else
    cmdprefix='avw';
end;

% get output file extension

if strfind(getenv('FSLOUTPUTTYPE'),'ANALYZE'),
    file_ext='.img';
else,
    file_ext='.nii';
end;

fsl_directory = [fsldir '/bin/'];
if exist([fsl_directory 'flirt'])==0,
       disp(sprintf('Warning- FSL executables not found:  %s', fsl_directory ));  
       disp(sprintf('  FSL binaries [e.g. flirt, %sorient] must be in your path.',cmdprefix));  
       fsl_directory = '';
end %if directory exists

if ~isfield(params,'MakeStandardSpaceImage') %CRorden: reference 
    %RP - changed this from ClusterInStandardSpace to
    %MakeStandardSpaceImage 
    % if this flag is set (which is the default), then the deconvolved
    % image is registered to standard space
    % The avg152T1 template from the fsl/etc/standard directory is the
    % default standard space target - set below
    params.MakeStandardSpaceImage = 1; 
end;

if ~isfield(params,'StandardSpaceReference') %CRorden: reference 
    if fslversion >=4,
        params.StandardSpaceReference=[fsldir '/etc/standard/avg152T1.nii.gz'];
    else
        params.StandardSpaceReference=[fsldir '/etc/standard/avg152T1.img'];
    end
end;

nii=func_data;
nii.img=[];
nii.hdr.dime.dim(5)=size(timepoints,5);
nii.hdr.dime.datatype=16;
nii.hdr.dime.bitpix=32;

fprintf('\nSaving data (including registered versions)\n');
for c=1:nconds,
  %outfile=sprintf('roi/%s.img',fmri.condname{c});
  outfile = [featdir filesep 'roi' filesep fmri.condname{c} file_ext]; %CRorden: filesep works on Unix and Windows
  
  nii.img=squeeze(timepoints(:,:,:,c,:));
  fprintf('saving %s\n',outfile);
  save_nii(nii,outfile);
  cmd=sprintf('%sorient -forceradiological %s',cmdprefix,outfile);
  fprintf('%s\n',cmd);
  unix(cmd);
  
  %Jmumford added to save variance estimate file
  outfile2 = [featdir filesep 'roi_var' filesep fmri.condname{c} file_ext];
  if params.SaveVariance,
      nii.img=squeeze(timepoints2(:,:,:,c,:));
      fprintf('saving %s\n',outfile2);
      save_nii(nii,outfile2,'f');
      cmd=sprintf('%sorient -forceradiological %s',cmdprefix,outfile2);
      fprintf('%s\n',cmd);
      unix(cmd);
  end
  
  % create registered version
  %normalisedfolder = [featdir filesep 'reg_standard']; %CRorden: filesep works on Unix and Windows
  regMatrix = [featdir filesep 'reg' filesep 'example_func2standard.mat']; %CRorden: filesep works on Unix and Windows
  if params.MakeStandardSpaceImage & exist(regMatrix,'file'),
      fprintf('Creating a normalized image - This is a slow procedure.\n');
      cmd=sprintf('%sflirt -sincwindow rectangular -in %s -ref %s -applyxfm -init %s -out %s/reg/roi/%s',...
      fsl_directory, outfile, params.StandardSpaceReference, regMatrix, featdir,fmri.condname{c});
      cmd = strrep(cmd,'\','/'); %even for Windows, applyxfm4D requires '/' as filesep
      fprintf('%s\n',cmd);
      [s,w]=unix(cmd);
      if s~=0,
          fprintf('PROBLEM:\n%d: %s\n',s,w);
      end

      %Jmumford:  adding the registration code for the variance
      %files 
      if params.SaveVariance,
        cmd2=sprintf('%sflirt -sincwindow rectangular -in %s -ref %s -applyxfm -init %s -out %s/reg/roi_var/%s',...
            fsl_directory, outfile2, params.StandardSpaceReference, regMatrix, featdir,fmri.condname{c});

        cmd2 = strrep(cmd2,'\','/')
        fprintf('%s\n',cmd2);
        [s,w]=unix(cmd2);
        if s~=0,
            fprintf('PROBLEM:\n%d: %s\n',s,w);
        end
      end
      
  end;
end;
fprintf('\n\n');
