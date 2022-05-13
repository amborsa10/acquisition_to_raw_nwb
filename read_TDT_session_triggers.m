function [block_triggers, trial_triggers, cam_triggers] = read_TDT_session_triggers(tdt_config)
% READS TRIGGER TIMESTAMPS FROM TDT PRORIETARY DATA FILES FOR ALL RECORDING
% BLOCKS
% This function requires one input:
% 1. 'tdt_config' -- MATLAB struct with a specific structure, containing
% metadata associated with the TDT data files (aka tanks)

% This function has three outputs:
% 1. 'block_triggers' -- matlab array with timestamps of block starts (s)
% 2. 'trial_triggers' -- matlab array with timstamps of trial starts (s)
% 3. 'cam_triggers' -- cell with a matlab array corresponding to each
% camera, with timestamps of camera triggers (s)

    number_of_blocks = length(tdt_config.blocks);
    number_of_cams = length(tdt_config.cam_trig_var_names);
    all_vars = [tdt_config.trial_trig_var_name,...
        tdt_config.cam_trig_var_names,...
        tdt_config.ephys_var_names{1}];
    
    
    t_current = 0;
    block_triggers = [t_current];
    tank_data = TDTbin2mat([tdt_config.directory tdt_config.blocks{1}],...
        'STORE',all_vars,'CHANNEL',1);
    trial_triggers = tank_data.scalars.(tdt_config.trial_trig_var_name).ts';
    for j=1:number_of_cams
        cam_triggers{j} = tank_data.scalars.(tdt_config.cam_trig_var_names{j}).ts';
    end
    block_samples = tank_data.streams.(tdt_config.ephys_var_names{1}).data';
    fs = tank_data.streams.(tdt_config.ephys_var_names{1}).fs;
    block_duration = length(block_samples)/fs;
    t_current = t_current + block_duration + 1/fs;
    
    
    for i=2:number_of_blocks
        
        block_triggers = [block_triggers; t_current];
        tank_data = TDTbin2mat([tdt_config.directory tdt_config.blocks{i}],...
            'STORE',all_vars,'CHANNEL',1);
        trial_triggers = [trial_triggers; ...
            tank_data.scalars.(tdt_config.trial_trig_var_name).ts' + t_current];
        for j=1:number_of_cams
            cam_triggers{j} = [cam_triggers{j};...
                tank_data.scalars.(tdt_config.cam_trig_var_names{j}).ts' + t_current];
        end
        block_samples = tank_data.streams.(tdt_config.ephys_var_names{1}).data';
        fs = tank_data.streams.(tdt_config.ephys_var_names{1}).fs;
        block_duration = length(block_samples)/fs;
        t_current = t_current + block_duration + 1/fs;
        
    end

end