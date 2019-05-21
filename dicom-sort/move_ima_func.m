function move_ima_func(data)

flist = data.flist;
destination_dir = fullfile(data.writefile_dir_selected, 'ima_to_delete');
mkdir(destination_dir);
nfiles = data.total_number_of_files;
disp(['Moving IMA files to ' destination_dir]);
for n = 1:nfiles
    if (data.gui == 1)
        workbar((n)/nfiles, ['Moving ' int2str(nfiles) ' files to ' destination_dir], 'Progress');
    end
    source_dicom_file = fullfile(data.readfile_dir, flist(n).name);
    destination_dicom_file = fullfile(destination_dir, flist(n).name);
    try
        movefile(source_dicom_file, destination_dicom_file);
    catch
        disp(['Couldn''t move '  source_dicom_file]);
    end
end
disp('Done')
