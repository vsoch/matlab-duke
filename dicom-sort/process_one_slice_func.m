function [vol] = process_one_slice_func(data, example_image)

mosaic_flag = data.current_mosaic_flag;
dim_phase = data.current_header_pars.dim_phase;
dim_read = data.current_header_pars.dim_read;
dim_nslices = data.current_header_pars.dim_nslices;

%   do the conversion
if strcmp(mosaic_flag, 'mosaic')
    %   mosaic images allocate even numbers of pixels in each dimension
    if isodd(dim_phase)
        mdim_phase = dim_phase + 1;
    else
        mdim_phase = dim_phase;
    end
    if isodd(dim_read)
        mdim_read = dim_read + 1;
    else
        mdim_read = dim_read;
    end
    %   new, SR, setting the same number of pixels in read and phase if the matrix size is asymmetric - is this always the case ?
    if dim_phase < dim_read
        mdim_phase = mdim_read;
    end
    n_mosaic_slices = (size(example_image,1)/mdim_phase)*(size(example_image,2)/mdim_read); 
    switch data.current_header_pars.PE_dir
        case 'COL'
                vol = mos2vol(example_image,double([mdim_phase,mdim_read,n_mosaic_slices]));
        case 'ROW'
            vol = mos2vol(example_image,double([mdim_read,mdim_phase,n_mosaic_slices]));
    end
        vol(:,:,dim_nslices+1:end) = [];
else
    vol=example_image;
end
clear example_image;

%rotate
try
    temp = imrotate(vol(:,:,1:end), -90);
    third_dimension = size(temp,3);
    vol = temp;
    if third_dimension > 1
        for i=1:third_dimension
%             vol(:,:,i) = fliplr(temp(:,:,i));
        end
    else
%         vol = fliplr(temp);
    end
    clear temp;
catch
    error('could not rotate');
end
