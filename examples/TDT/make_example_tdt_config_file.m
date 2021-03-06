%% This script generates an example tdt_config.mat file.
% The structure of the generated file is a prototype, although the fields
% may contain nonsensical values. (updated, Adriano 4/29/2022)

directory = 'Y:\stanley\Data\Adriano\NN64Chan_img-220304\';

blocks = {'march4th_1','march4th_2','march4th_3',...
    'march4th_4','march4th_5','march4th_6','march4th_7'};

% the number of datastreams provided by these variables should match the
% number of electrodes
ephys_var_names = {'Wav1'}; 

% the number of datastreams provided by these variables should match the
% number of LEDs
opto_var_names = {'LEDc','LEDc'};

% the number of datastreams provided by these variables should match the
% number of galvos
galvo_var_names = {'GaCV','GaCV'};

trial_trig_var_name = 'Tri1';

% the number of datastreams provided by these variables should match the
% number of cameras
cam_trig_var_names = {'Cam1'};

save('eg_tdt_config.mat','directory','blocks','ephys_var_names',...
    'opto_var_names','galvo_var_names','trial_trig_var_name',...
    'cam_trig_var_names');