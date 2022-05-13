
%% DIRECTIONS
% * Change the directory of the TDT tanks in
% 'make_example_tdt_config_file.m' and run it to save an updated
% 'eg_tdt_config.mat' file. The data it points to is on the shared drive.
% (e.g., 'Y:\stanley\Data\Adriano\NN64Chan_img-220304\')

% * Download the latest release of MATNWB and generate the NWB core
% https://github.com/NeurodataWithoutBorders/matnwb/releases
% https://neurodatawithoutborders.github.io/matnwb/#setup

% * Download the TDT Software Development Kit
% https://www.tdt.com/docs/sdk/offline-data-analysis/offline-data-matlab/getting-started/

% * Update your MATLAB path variable to include the NWB, TDTSDK, and
% acquisition_to_raw_nwb directories

%% convert raw TDT files to NWB

% EDIT THIS - add all necessary directories to path
restoredefaultpath;
addpath(genpath('C:\Users\aborsa3\Documents\MATLAB'));

% get function inputs
metadata = load('eg_session_metadata.mat');
tdt_config = load('eg_tdt_config.mat');
save_directory = '.';

% call function
nwb = TDT_2_RAW_NWB(metadata,tdt_config,save_directory);