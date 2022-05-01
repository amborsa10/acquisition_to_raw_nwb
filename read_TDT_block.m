function [fs,ephys_raw,opto_raw,galvo_raw] = read_TDT_block(tdt_config,block_number)

    % load in tank data
    all_vars = [tdt_config.ephys_var_names, ...
        tdt_config.opto_var_names,...
        tdt_config.galvo_var_names];
%     tank_data = TDTbin2mat([tdt_config.directory tdt_config.blocks{block_number}],...
%         'STORE',all_vars);
    tank_data = TDTbin2mat([tdt_config.directory tdt_config.blocks{block_number}],...
        'STORE',all_vars,'T1', 0, 'T2', 5);
    
    % store ephys raw traces
    number_ephys_vars = length(tdt_config.ephys_var_names);
    ephys_var_name = tdt_config.ephys_var_names{1};
    ephys_raw = tank_data.streams.(ephys_var_name).data';
    fs = tank_data.streams.(ephys_var_name).fs;
    for i=2:number_ephys_vars
        ephys_var_name = tdt_config.ephys_var_names{i};
        ephys_append = tank_data.streams.(ephys_var_name).data';
        ephys_raw = [ephys_raw, ephys_append];
    end 
    
    % store opto raw traces
    number_opto_vars = length(tdt_config.opto_var_names);
    opto_var_name = tdt_config.opto_var_names{1};
    opto_raw = tank_data.streams.(opto_var_name).data';
    for i=2:number_opto_vars
        opto_var_name = tdt_config.opto_var_names{i};
        opto_append = tank_data.streams.(opto_var_name).data';
        opto_raw = [opto_raw, opto_append];
    end
    
    % store galvo raw traces
    number_galvo_vars = length(tdt_config.galvo_var_names);
    galvo_var_name = tdt_config.galvo_var_names{1};
    galvo_raw = tank_data.streams.(galvo_var_name).data';
    for i=2:number_galvo_vars
        galvo_var_name = tdt_config.galvo_var_names{i};
        galvo_append = tank_data.streams.(galvo_var_name).data';
        galvo_raw = [galvo_raw, galvo_append];
    end
    

end