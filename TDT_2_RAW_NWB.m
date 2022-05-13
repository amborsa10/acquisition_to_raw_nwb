function nwb = TDT_2_RAW_NWB(metadata,tdt_config,save_directory)
% CREATES A RAW NWB FILE FROM TDT PROPRIETARY DATA FILES
% This function requires 3 inputs:
% 1. 'metadata' -- MATLAB struct with a specific structure, containing
% recording session metadata
% 2. 'tdt_config' -- MATLAB struct with a specific structure, containing
% metadata associated with the TDT data files (aka tanks)
% 3. 'save_directory' -- string with the path for where the raw NWB file
% should be saved

    file_save_name = [metadata.animal.id '_' metadata.session.recording_session...
        '_Raw.nwb'];
    
    nwb = write_NWB_metadata(metadata);
    
    [fs,ephys_raw,opto_raw,galvo_raw] = read_TDT_block(tdt_config,1);
    nwb = write_NWB_time_series(nwb,fs,ephys_raw,opto_raw,galvo_raw);
    
    [block_triggers, trial_triggers, cam_triggers] = read_TDT_session_triggers(tdt_config);
    nwb = write_NWB_interval_series(nwb,metadata,block_triggers,trial_triggers,cam_triggers);
    
    nwbExport(nwb,fullfile(save_directory,file_save_name));
    
    for i=2:length(tdt_config.blocks)
        [fs,ephys_raw,opto_raw,galvo_raw] = read_TDT_block(tdt_config,i);
        nwb = append_NWB_time_series(nwb,ephys_raw,opto_raw,galvo_raw);
    end
    
    nwbExport(nwb, fullfile(save_directory,file_save_name));

end

