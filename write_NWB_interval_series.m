function nwb = write_NWB_interval_series(nwb, metadata, block_triggers, trial_triggers, cam_triggers)
% WRITES INTERVAL/ANNOTATION DATA STREAMS TO NWB OBJECT
% This function has 5 inputs:
% 1. 'nwb' -- NWB file object
% 2. 'metadata' -- MATLAB struct with a specific structure, containing
% recording session metadata
% 3. 'block_triggers', 'trial_triggers', 'cam_triggers' -- outputs from
% 'read_TDT_session_triggers.m'

% COMMENTS:
% * TODO: change camera series to IndexSeries and link to an ImageSeries
% with videography data

    number_of_cameras = length(cam_triggers);
    number_of_galvos = length(metadata.galvo.galvos);
    
    % TEMPORARY -- NEEDS TO CHANGE TO INDEXSERIES
    for i=1:number_of_cameras
        camera_series = types.core.IntervalSeries(...
            'starting_time', 0.0,...
            'starting_time_rate', 0.0,...
            'data', ones(size(cam_triggers{i})),...
            'timestamps', cam_triggers{i});
        nwb.acquisition.set(['CamTriggersIndexSeries' num2str(i)], camera_series);
    end

    trigger_series = types.core.IntervalSeries(...
        'starting_time', 0.0,...
        'starting_time_rate', 0.0,...
        'data', ones(size(trial_triggers)),...
        'timestamps', trial_triggers...
        );
    nwb.acquisition.set('TrialTriggersIntervalSeries', trigger_series);
    
    for i=1:number_of_galvos
        galvo_annotation_series = types.core.AnnotationSeries(...
            'starting_time', 0.0,...
            'starting_time_rate', 0.0,...
            'data', {metadata.galvo.galvos(i).blocks.target_whisker},...
            'timestamps', block_triggers);
        nwb.acquisition.set(['GalvoAnnotationSeries' num2str(i)],galvo_annotation_series);
    end
    
    

end

