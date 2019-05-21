featdir='/space/raid4/data/poldrack/roi_test/series4_run1.feat';

% get mean timecourse from each region in HarvardOxford atlas

% check for nifti tools from http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/

if isempty(which('load_nii')),
    fprintf('This program requires the NIFTI tools for matlab:\n');
    fprintf('Available from: http://www.rotman-baycrest.on.ca/~jimmy/NIFTI/\n');
    return;
end;

gzipped=0;
if strcmp(getenv('FSLOUTPUTTYPE'),'NIFTI_GZ'),
    file_ext='.nii.gz';
    gzipped=1;
elseif strcmp(getenv('FSLOUTPUTTYPE'),'NIFTI'),
    file_ext='.nii';
elseif strcmp(getenv('FSLOUTPUTTYPE'),'ANALYZE_GZ'),
    file_ext='.img.gz';
    gzipped=1;
else,
    file_ext='.img';
end;

design_file=which('design');
fprintf('Loading design from:\n%s\n',design_file);
try,
  design;
catch,
   fprintf('problem loading design.m\n');
  return;
end;

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


for c=1:nconds,
    [p1,p2,p3]=fileparts(fmri.custom{c});
    fmri.condname{c}=p2;
end;

nconds=fmri.evs_orig;
for c=1:nconds,
  %outfile=sprintf('roi/%s.img',fmri.condname{c});
  outfile(c) = {[featdir filesep 'reg/roi' filesep fmri.condname{c} file_ext]}; %CRorden: filesep works on Unix and Windows
end;

atlasdir='/space/raid/fmri/atlases/HarvardOxford/HarvardOxford-combo-maxprob-thr25-2mm';
atlasimg='HarvardOxford-combo-maxprob-thr25-2mm.nii';
labelinfo='/space/raid/fmri/atlases/HarvardOxford/HarvardOxford-combo-labels.mat';

load(labelinfo);

% make sprintf command depending upon # of timepoints
[a,b]=unix(sprintf('fslinfo %s| grep ^dim4| awk ''{print $2}''',outfile{1}));
ntpest=str2num(b);
scancmd='';
for x=1:ntpest,
    scancmd=[scancmd '%f'];
end

data=cell(length(labels),nconds);

for x=1:length(labels),
    for c=1:nconds,
        cmd=sprintf('fslmeants -i %s -m %s/roi%03d',...
            outfile{c},atlasdir,x);
        fprintf('%s\n',cmd);
        [a,b]=unix(cmd);
        data(x,c)={sscanf(b,scancmd)};
    end;
end;
    
save('reg/roi/atlas_timeseries.mat','data','labels');
