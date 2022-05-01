function nwb = write_NWB_metadata(metadata)

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

    nwb.general_experimenter = 'Adriano Borsa';
    nwb.general_protocol = metadata.session.iacuc_protocol;
    nwb.general_institution = 'Georgia Tech';
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
        device_name = metadata.ephys.probes(i).name;
        device = types.core.Device(...
            'description', metadata.ephys.probes(i).type,...
            'manufacturer',metadata.ephys.probes(i).manufacturer);
        nwb.general_devices.set(device_name,device);
    end

    % add electrode groups
    number_of_groups = length(metadata.ephys.electrode_groups);
    for i=1:number_of_groups
        group_name = metadata.ephys.electrode_groups(i).name;
        nwb.general_extracellular_ephys.set(group_name,...
            types.core.ElectrodeGroup(...
            'description', 'N/A',...
            'location', metadata.ephys.electrode_groups(i).location,...
            'device',types.untyped.SoftLink(['/general/devices/' metadata.ephys.electrode_groups(i).assigned_probe])));
    end

    % add electrodes
    variables = {'x', 'y', 'z', 'impedance', 'group'};
    tbl = cell2table(cell(0,length(variables)), 'VariableNames', variables);
    number_of_electrodes = length(metadata.ephys.electrodes);

    for i=1:number_of_electrodes
        group_name = metadata.ephys.electrodes(i).assigned_electrode_group;
        group_object_view = types.untyped.ObjectView(['/general/extracellular_ephys/' group_name]);
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
    % add optical fibers
    number_of_leds = length(metadata.opto.leds);
    for i=1:number_of_leds

        device = types.core.Device(...
            'description', metadata.opto.leds(i).fiber_type);
        device_name = metadata.opto.leds(i).fiber_name;
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

