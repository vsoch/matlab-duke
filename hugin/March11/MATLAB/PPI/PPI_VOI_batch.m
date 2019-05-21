%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.voi.spmmat = {'SPM.mat'};
matlabbatch{1}.spm.util.voi.adjust = 1;
matlabbatch{1}.spm.util.voi.session = 1;
matlabbatch{1}.spm.util.voi.name = 'RAmy_cluster';
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {'SPM.mat'};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 3;
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'FWE';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask.contrast = 3;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask.thresh = 0.001;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask.mtype = 0;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [-10 -10 -10];
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 5;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{1}.spm.util.voi.roi{3}.box.centre = [-10 -10 -10];
matlabbatch{1}.spm.util.voi.roi{3}.box.dim = [2 2 2];
matlabbatch{1}.spm.util.voi.roi{3}.box.move.fixed = 1;
matlabbatch{1}.spm.util.voi.roi{4}.mask.image = {'maskimagefile.nii'};
matlabbatch{1}.spm.util.voi.roi{4}.mask.threshold = 0.5;
matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';
