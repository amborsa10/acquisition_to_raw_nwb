%% This script generates an example tdt_config.mat file.
% The structure of the generated file is a prototype, although the fields
% may contain nonsensical values. (updated, Adriano 4/29/2022)

directory = 'Y:\stanley\Data\Adriano\NN64Chan_img-220304\';

blocks = {'march4th_1','march4th_2','march4th_3',...
    'march4th_4','march4th_5','march4th_6','march4th_7'};

ephys_var_names = {'Wav1'}; 

opto_var_names = {'LEDc'};

galvo_var_names = {'GaCV'};

save('eg_tdt_config.mat','directory','blocks','ephys_var_names','opto_var_names','galvo_var_names');