function data = reformat_data_func(data)

%   if the 'Advanced' feature are selected in dicom_sort_convert_main, this
%   function reformats a dataset with 3 or 4 dimensions into one with up to
%   7.  The dimensions of these are specified by the ndims parameters, and
%   are, in order
%   [x][y][z][time][echos][channels][phase/mag]
%   The first 3 dimensions are always image x,y,z. After that, dimensions
%   are only used if variation in that dimension is present (more than one
%   time point, echo, channel, p/m)


% NON-MOSIAC
% odims(1) = x
% odims(2) = y
% odims(3) = time-echo-z-p/m-channels (changes least frequently -> changes most frequently)

% MOSIAC
% odims(1) = x
% odims(2) = y
% odims(3) = z
% odims(4) = ???time-echo-p/m-channels (changes least frequently -> changes most frequently)???

% ndims(1) = x
% ndims(2) = y
% ndims(3) = z
% ndims(4) = time
% ndims(5) = echos
% ndims(6) = channels
% ndims(7) = phase/magnitude

ndims(1:7) = 1;
odims = 0;
reformat = 'no';
datalabel = '[x,y,z';

convert_format = data.convert_format;
current_dir = data.current_dir;

if data.current_analyze_struct.hdr.dime.dim(1) == 4
    odims (1:4) = data.current_analyze_struct.hdr.dime.dim(2:5);
else
    odims (1:3) = data.current_analyze_struct.hdr.dime.dim(2:4);
end

z = data.current_header_pars.dim_nslices;

ndims (1) = odims(1);
ndims (2) = odims(2);
ndims (3) = z;
if data.current_header_pars.dim_nr > 1
    ndims (4) = data.current_header_pars.dim_nr;
    datalabel = [datalabel ',t'];
end
switch data.current_header_pars.sequence_type
    case 'ep2d_diff'
        if data.current_header_pars.dim_ngd > 1
            ndims (4) = data.current_header_pars.dim_ngd;
            datalabel = [datalabel ',diff_g'];
            if data.current_header_pars.dim_nr > 1 %DTI with multiple repetitions
                disp('!!! lRepetitions gives NR > 1 - assuming this is number of diffusion directions');
                ndims (4) = data.current_header_pars.dim_nr;
                data.warning_present = 'yes';
                this_warning_text = 'lRepetitions gives NR > 1 - assuming this is number of diffusion directions - check reformatted data';
                data.warning_text = sprintf('! %sScan: %s. %s\n', data.warning_text, data.current_scan, this_warning_text);
            end
        end
    otherwise
end

if (strcmp(data.current_mosaic_flag, 'mosaic') ~= 1 && (ndims(4) > 1)) %only reformat NR>1 data if not MOSAIC
    reformat = 'yes';
end
if (data.current_header_pars.nechos > 1)
    reformat = 'yes';
    ndims(5) = data.current_header_pars.nechos;
    datalabel = [datalabel ',echo'];
end
if strcmp(data.current_header_pars.sep_channels, 'yes')
    if z > 1 % only reformat if more than one slice
        reformat = 'yes';
    end
    ndims(6) = data.current_header_pars.n_channels;
    datalabel = [datalabel ',channel'];
end
if strcmp(data.current_header_pars.data_type, 'MP')
    reformat = 'yes';
    ndims(7) = 2;
    datalabel = [datalabel ',phase/mag'];
end
datalabel = [datalabel ']'];

if strcmp(reformat,'yes')
    disp([' - scan ' data.current_scan ' is ' datalabel ', reformatting into those dimensions']);
    current_reform_dir = fullfile(current_dir,'reform');
    s = warning ('query', 'MATLAB:MKDIR:DirectoryExists') ;	    % get current state
    warning ('off', 'MATLAB:MKDIR:DirectoryExists') ;
    mkdir(current_reform_dir);
    warning (s) ;						    % restore state
    switch convert_format
        case 'nifti'
            extension = '.nii';
        case 'analyze'
            extension = '';
    end
    readfile = fullfile(current_dir, sprintf('Image%s', extension));
    try
        new_image = zeros(ndims(1),ndims(2),ndims(3),ndims(4),ndims(5),ndims(6),ndims(7),data.current_header_pars.precision);
    catch
        disp('!!! Could not create the image for reformatting');
        return;
    end
    try
        old_image_nii = load_nii(readfile);
    catch
        disp('!!! Could not load the old image to perform reformatting');
        data.warning_present = 'yes';
        this_warning_text = '!!! Image couldn''t be loaded prior to reformatting';
        data.warning_text = sprintf('! %sScan: %s. %s\n', data.warning_text, data.current_scan, this_warning_text);
        return;
    end
    if (strcmp(data.current_mosaic_flag, 'mosaic') ~= 1)
        try
            %         logical indexing slices
            for j = 1:ndims(4) % time
                for k = 1:ndims(5) % echos
                    for l = 1:ndims(6) % channels
                        for m = 1:ndims(7) % phase/magnitude
                            disp(['putting elements ' num2str((j-1)*ndims(5)*ndims(3)*ndims(7)*ndims(6)+(k-1)*ndims(3)*ndims(7)*ndims(6)+((1:1:ndims(3))-1)*ndims(7)*ndims(6)+(m-1)*ndims(6)+l) ' into ' num2str(k) ',' num2str(1:1:ndims(3)) ',' num2str(j) ',' num2str(m) ',' num2str(l)]);
                            new_image(:,:,1:1:ndims(3),j,k,l,m) = old_image_nii.img(:,:,(j-1)*ndims(5)*ndims(3)*ndims(7)*ndims(6)+(k-1)*ndims(3)*ndims(7)*ndims(6)+((1:1:ndims(3))-1)*ndims(7)*ndims(6)+(m-1)*ndims(6)+l);
                        end
                    end
                end
            end
            data.warning_present = 'yes';
            this_warning_text = ['was reformatted to ' datalabel ' in /reformat)' ];
            data.warning_text = sprintf('%sScan: %s. %s\n', data.warning_text, data.current_scan, this_warning_text);
        catch            
            disp(['!!!' data.current_scan ': Couldn''t reformat data into new matrix - in reformat_data_func.m']);
            data.warning_present = 'yes';
            this_warning_text = ['couldn''t be reformatted to ' datalabel];
            data.warning_text = sprintf('! %sScan: %s. %s\n', data.warning_text, data.current_scan, this_warning_text);
        end
    else
        for i = 1:ndims(3) %slices
            for j = 1:ndims(4) % time
                for k = 1:ndims(5) % echos
                    for l = 1:ndims(6) % channels
                        for m = 1:ndims(7) % phase/magnitude
                            disp(['Scan ' data.current_scan ': reformatting not yet programmed for MOSAIC format']); 
                            % disp(['putting element ' num2str((j-1)*ndims(5)*ndims(3)*ndims(7)*ndims(6)+(k-1)*ndims(3)*ndims(7)*ndims(6)+(i-1)*ndims(7)*ndims(6)+(m-1)*ndims(6)+l) ' into ' num2str(k) ',' num2str(i) ',' num2str(j) ',' num2str(m) ',' num2str(l)]);
                            %                  new_image(:,:,i,j,k,l,m) = old_image_nii.img(:,:,(m-1)*ndims(6)*ndims(5)*ndims(4)*ndims(3)+(l-1)*ndims(5)*ndims(4)*ndims(3)+(k-1)*ndims(4)*ndims(3)+(j-1)*ndims(3)+i);
                        end
                    end
                end
            end
        end
    end
    old_image_hdr = load_nii_hdr(readfile);
    new_image = squeeze(new_image);
    new_image_nii = make_nii_sr(new_image, 4);
    new_image_nii.hdr = centre_header(new_image_nii.hdr);
    new_image_nii.hdr.dime.pixdim(2:4) = old_image_hdr.dime.pixdim(2:4);
    save_nii(new_image_nii, fullfile(current_reform_dir, ['Image' extension]));

end

