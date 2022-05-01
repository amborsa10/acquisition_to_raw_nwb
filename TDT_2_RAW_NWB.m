function nwb = TDT_2_RAW_NWB(metadata,tdt_config,save_directory,NWB_path,TDTSDK_path)

    addpath(genpath(NWB_path)); addpath(genpath(TDTSDK_path));
    file_save_name = [metadata.animal.id '_' metadata.session.recording_session...
        '_Raw.nwb'];
    
    nwb = write_NWB_metadata(metadata);
    
    [fs,ephys_raw,opto_raw,galvo_raw] = read_TDT_block(tdt_config,1);
    
    nwb = write_NWB_time_series(nwb,fs,ephys_raw,opto_raw,galvo_raw);
    nwbExport(nwb,fullfile(save_directory,file_save_name));
    
    for i=2:length(tdt_config.blocks)
        [fs,ephys_raw,opto_raw,galvo_raw] = read_TDT_block(tdt_config,i);
        nwb = append_NWB_time_series(nwb,ephys_raw,opto_raw,galvo_raw);
    end
    
    nwbExport(nwb, fullfile(save_directory,file_save_name));

end

