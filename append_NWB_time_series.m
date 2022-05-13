function nwb = append_NWB_time_series(nwb,ephys_raw,opto_raw,galvo_raw) % add trial trig raw, cam trig raw
% APPENDS RAW DATA STREAMS TO NWB OBJECT
% This function requires 4 inputs:
% 1. 'nwb' -- NWB object (already populated with time series data AND exported)
% 2. 'ephys_raw','opto_raw','galvo_raw' -- outputs from
% 'read_TDT_block.m'

    number_of_electrodes = size(ephys_raw,2);
    number_of_leds = size(opto_raw,2);
    number_of_galvos = size(galvo_raw,2);
    
    % ElectricalSeries
    nwb.acquisition.get('ElectricalSeries').data.append(ephys_raw);
    
    % OptogeneticSeries
    for i=1:number_of_leds
        nwb.acquisition.get(['OptogeneticSeries' num2str(i)]).data.append(opto_raw(:,i));
    end
    
    % GalvoTimeSeries
    for i=1:number_of_galvos
        nwb.acquisition.get(['GalvoTimeSeries' num2str(i)]).data.append(galvo_raw(:,i));
    end

end