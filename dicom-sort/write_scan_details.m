function write_scan_details(data)

[res, dcminfo] = isdicomfile(data.current_readfile_example);

writefile_th = data.current_writefile_th;
dcminfo = data.current_dcminfo;
current_scan = data.current_scan;
dim_read = data.current_header_pars.dim_read;
dim_phase = data.current_header_pars.dim_phase;
dim_nslices = data.current_header_pars.dim_nslices;
NR = data.current_header_pars.dim_nr;
NGD = data.current_header_pars.dim_ngd;
NF = data.current_nfiles;
TE = data.current_header_pars.echo_times;
TR = data.current_header_pars.tr;
TI = data.current_header_pars.ti;
TA = data.current_header_pars.scan_time;
FA = data.current_header_pars.fa;
orientation = data.current_header_pars.orientation;
plane_angle = data.current_header_pars.plane_angle;
datalabel = data.current_header_pars.datalabel;
protocol_name = data.current_header_pars.protocol_name;
sequence_type = data.current_header_pars.sequence_type;

switch sequence_type
    case {'gre'}
        disp('')     ;
end

%   for multi-echo
try
    ne = data.current_header_pars.nechos;
    TEs = data.current_header_pars.echo_times;
    TE_string = '';
    for i=1:data.current_header_pars.nechos
        TE_string = [TE_string ' ' num2str(TEs(i))];
    end
catch
    ne = 0;
end


extra_info_string = '';
if findstr(dcminfo.ImageType, 'DICO')
    extra_info_string = [extra_info_string ', DiCo'];
end
if findstr(dcminfo.ImageType, '\P\')
    extra_info_string = [extra_info_string ', Phase'];
end
if isvar('dcminfo.ScanOptions') == 1
    if strcmp(dcminfo.ScanOptions,'FS')
        extra_info_string = [extra_info_string ', FS'];
    end
end
if strcmp(datalabel,'') ~= 1
    extra_info_string = [extra_info_string ', ' datalabel];
end

coil_string = '';
if strcmp(data.current_header_pars.raw_flag, 'raw') ~= 1
    if isvar('dcminfo.TransmitCoilName')
        switch dcminfo.TransmitCoilName
            case 'Head'
                coil_string = 'Coil: Birdcage';
            case '8_Channel_Head'
                coil_string = 'Coil: 8-channel';
            case 'TEM_Head'
                coil_string = 'Coil: TEM';
            case '8Ch_Head_7T'
                coil_string = 'Coil: 7T 8-channel';
            case '24Ch_Head_7T'
                coil_string = 'Coil: 7T 24-channel';
            otherwise
                coil_string = sprintf('Coil: Unknown: %s', dcminfo.TransmitCoilName);
        end
    else
        coil_string = sprintf('Coil: Unkown: Not in DICOM');
    end
end

%Write useful details to a scanner log
switch sequence_type
    case {'localizer'}
        fprintf(data.fp_scanlog, 'Scan %s: Localiser. %s \n', current_scan, coil_string);
    case {'gre_circle'}
        fprintf(data.fp_scanlog, 'Scan %s: Circle Localiser. %s  \n', current_scan, coil_string);
    case {'AAScout'}
        fprintf(data.fp_scanlog, 'Scan %s: AAScout.  \n', current_scan);
    case {'mz_ep2d_psf'}
        dim_phase=int16(dim_read*(dcminfo.PercentPhaseFieldOfView/100));
        fprintf(data.fp_scanlog, 'Scan %s: EPI %s %ix%ix%i\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices);
    case {'mz_ep2d_psf_DiCo'}
        dim_phase=int16(dim_read*(dcminfo.PercentPhaseFieldOfView/100));
        fprintf(data.fp_scanlog, 'Scan %s: PSF %s %ix%ix%i\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices);
    case {'lnif_epi_exp','lnif_epi_devel','ep2d_bold','ep2d_pace','ep2d_fid','ep2d_pasl','mz_ep2d_bold_dc','lnif_epi_bold_dc_1','mz_ep2d_bold_dc_DiCo'}
        dim_phase=int16(dim_read*(dcminfo.PercentPhaseFieldOfView/100));
        fprintf(data.fp_scanlog, 'Scan %s: EPI %s. %ix%ix%i, %s(%.1f%c), TE/TR=(%.0f/%.0f), FA=%.1f%c, NR=%i%s, TA=%ss, %i files\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, orientation, plane_angle, char(176), TE, TR, FA, char(176), NR, extra_info_string, TA, NF);
    case {'ep_seg_fid_devel'} % can be segmented and 3D
        scan_time = data.current_header_pars.scan_time;
        EPI_factor = num2str(data.current_header_pars.EPI_factor);
        dimension = data.current_header_pars.dimension;
        dim_phase=int16(dim_read*(dcminfo.PercentPhaseFieldOfView/100));
        fprintf(data.fp_scanlog, 'Scan %s: %s seg-EPI %s. %ix%ix%i, %s(%.1f%c), TE/TR=(%.0f/%.0f), EPI_f=%s, NR=%i%s, %ss, %i files\n', current_scan, dimension, protocol_name, dim_read, dim_phase, dim_nslices, orientation, plane_angle, char(176), TE, TR, EPI_factor, NR, extra_info_string, scan_time, NF);
    case {'ep2d_diff'}
        dim_phase=int16(dim_read*(dcminfo.PercentPhaseFieldOfView/100));
        fprintf(data.fp_scanlog, 'Scan %s: DTI %s. %ix%ix%i, TE/TR=(%.0f/%.0f), NGD=%i%s, %i files\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, TE, TR, NGD, extra_info_string, NF);
    case {'gre_field_mapping'}
        if (strcmp(data.reco_option, 'Reconstruct All Raw Scans') == 1) || (strcmp(data.reco_option, 'Reconstruct This Scan') == 1)
            data.convert_to_3d = 'no';
            this_warning_text = '!!!Warning: Reconstructing data from two echo times.  Leaving as separate images';
            data.warning_present = 'yes';
            data.warning_text = sprintf('%sScan: %s. %s\n', current_scan, data.warning_text, data.current_scan, this_warning_text);
        end
    case {'gre'}
        if size(strfind(protocol_name, 'localizer'),1) ~= 0
            fprintf(data.fp_scanlog, 'Scan %s: Localiser. %s \n', current_scan, coil_string);
        else
            if ne == 0
                fprintf(data.fp_scanlog, 'Scan %s: GE %s. %ix%ix%i\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices);
            else
                fprintf(data.fp_scanlog, 'Scan %s: MGE %s. %ix%ix%i, %s(%.1f%c), FA=%.1f%c, %i echos at %s ms%s, %i files\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, orientation, plane_angle, char(176), FA, char(176), ne, TE_string, extra_info_string, NF);
            end
        end
    case {'os_mepi2d'}
        fprintf(data.fp_scanlog, 'Scan %s: EPI %s. %ix%ix%i, NR=%i, %iHz/pix%s \n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, NF, data.current_dcminfo.PixelBandwidth, extra_info_string);
    case {'sp2d'}
        fprintf(data.fp_scanlog, 'Scan %s: Spiral %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'tse'}
        fprintf(data.fp_scanlog, 'Scan %s: TSE %s. %ix%ix%i%s,TE/TI/TR=%i/%i/%i\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string, TE, TI, TR);
    case {'tfl'}
        fprintf(data.fp_scanlog, 'Scan %s: MPRAGE(TFL) %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'se'}
        fprintf(data.fp_scanlog, 'Scan %s: SE %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'fl_tof'}
        fprintf(data.fp_scanlog, 'Scan %s: FL_TOF %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'ralf_mdeft_distrib_trio'}
        fprintf(data.fp_scanlog, 'Scan %s: MDEFT %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'tse_vfl'}
        fprintf(data.fp_scanlog, 'Scan %s: TSE %s. %ix%ix%i%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, extra_info_string);
    case {'gre_mgh_multiecho'}
        fprintf(data.fp_scanlog, 'Scan %s: MGE %s. %ix%ix%i, %s(%.1f%c), FA=%.1f%c, %i echos at %s ms%s\n', current_scan, protocol_name, dim_read, dim_phase, dim_nslices, orientation, plane_angle, char(176), FA, char(176), ne, TE_string, extra_info_string);
    otherwise
        if strcmp(data.raw_data, 'no') == 1
            disp(['Never tried to convert ' sequence_type ' before.  Check images and view log. Will continue. ']);
        end
        this_warning_text = sprintf('!!!Warning!!! Never tried to convert a %s, check images carefully!!!\n', sequence_type);
        data.warning_present = 'yes';
        data.warning_text = sprintf('%s Scan: %s. %s\n', data.warning_text, data.current_scan, this_warning_text);
        fprintf(data.fp_scanlog, 'Scan %s: Unknown scan type %s %s\n', current_scan, sequence_type, protocol_name);
end
