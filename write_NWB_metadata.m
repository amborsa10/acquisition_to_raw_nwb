function nwb = write_NWB_metadata(metadata)
% CREATES AN NWB FILE OBJECT AND SAVES RECORDING SESSION METADATA
% This function requires a single input:
% 1. 'metadata' -- MATLAB struct with a specific structure, containing
% recording session metadata

% COMMENT: The way I store the ephys metadata is confusing. Each
% electrode has an 'assigned_electrode_group', each electrode group has a
% (unique) 'name' and an 'assigned_probe', and each probe has a (unique)
% 'name'. 

    % set NWB session and animal metadata
    session_description = [metadata.animal.description,' ',...
        metadata.ephys.description,' ',...
        metadata.opto.description,' ',...
        metadata.galvo.description];
    session_identifier = [metadata.animal.id,'_',...
        metadata.session.recording_session];

    nwb = NwbFile( ...
        'identifier',session_identifier,...
        'session_description', session_description);

    nwb.general_experimenter = metadata.session.experimenter;
    nwb.general_protocol = metadata.session.iacuc_protocol;
    nwb.general_institution = metadata.session.institution;
    nwb.session_start_time = metadata.session.recording_day;
    nwb.general_session_id = metadata.session.recording_session;
    nwb.general_virus = metadata.animal.virus;
    nwb.general_pharmacology = metadata.animal.pharmacology;
    nwb.general_surgery = metadata.animal.lesions;
    nwb.general_keywords = [metadata.ephys.recording_type,',',...
        metadata.ephys.recording_targets];

    subject = types.core.Subject( ...
        'subject_id', metadata.animal.id,...
        'description', metadata.animal.description,...
        'species', metadata.animal.species,...
        'sex', metadata.animal.sex,...
        'date_of_birth', metadata.animal.dob,...
        'strain', metadata.animal.strain...
        );
    nwb.general_subject = subject;

    % set NWB ephys metadata
    % add probes
    number_of_probes = length(metadata.ephys.probes);
    for i=1:number_of_probes
        device_name = ['Probe' num2str(i)];
        device = types.core.Device(...
            'description', metadata.ephys.probes(i).type,...
            'manufacturer',metadata.ephys.probes(i).manufacturer);
        nwb.general_devices.set(device_name,device);
    end

    % add electrode groups
    number_of_groups = length(metadata.ephys.electrode_groups);
    for i=1:number_of_groups
        group_name = ['Group' num2str(i)];
        probe_index = find(strcmp(metadata.ephys.electrode_groups(i).assigned_probe,{metadata.ephys.probes.name}),1);
        nwb.general_extracellular_ephys.set(group_name,...
            types.core.ElectrodeGroup(...
            'description', 'N/A',...
            'location', metadata.ephys.electrode_groups(i).location,...
            'device',types.untyped.SoftLink(['/general/devices/' 'Probe' num2str(probe_index)])));
    end

    % add electrodes
    variables = {'x', 'y', 'z', 'impedance', 'group'};
    tbl = cell2table(cell(0,length(variables)), 'VariableNames', variables);
    number_of_electrodes = length(metadata.ephys.electrodes);

    for i=1:number_of_electrodes
        %group_name = metadata.ephys.electrodes(i).assigned_electrode_group;
        group_index = find(strcmp(metadata.ephys.electrodes(i).assigned_electrode_group,...
            {metadata.ephys.electrode_groups.name}),1);
        group_object_view = types.untyped.ObjectView(['/general/extracellular_ephys/' 'Group' num2str(group_index)]);
        new_row = {metadata.ephys.electrodes(i).xcoords,...
            metadata.ephys.electrodes(i).ycoords,...
            metadata.ephys.electrodes(i).zcoords,...
            metadata.ephys.electrodes(i).impedance,...
            group_object_view};
        tbl = [tbl; new_row];
    end

    electrode_table = util.table2nwb(tbl,'all electrodes');
    nwb.general_extracellular_ephys_electrodes = electrode_table;

    % set NWB opto metadata
    number_of_leds = length(metadata.opto.leds);
    for i=1:number_of_leds

        device = types.core.Device(...
            'description', metadata.opto.leds(i).fiber_type);
        device_name = ['Fiber' num2str(i)];
        nwb.general_devices.set(device_name,device);

        opto_site_name = ['Site' num2str(i)];

        opto_site = types.core.OptogeneticStimulusSite(...
            'description', 'N/A',...
            'device', types.untyped.SoftLink(['/general/devices/' device_name]),...
            'excitation_lambda', metadata.opto.leds(i).wavelength,...
            'location', metadata.opto.leds(i).target_location);

        nwb.general_optogenetics.set(opto_site_name, opto_site);

    end

end

