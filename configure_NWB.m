function output = configure_NWB(NWB_path,generate_core,version)
% ADDS NWB DIRECTORY TO MATLAB PATH (AND GENERATES CORE IF REQUESTED)
% https://neurodatawithoutborders.github.io/matnwb/#setup

% FIRST: DOWNLOAD the latest version of MATNWB from
% (https://github.com/NeurodataWithoutBorders/matnwb/releases)

% COMMENT: some NWB errors may occur if the MATLAB path contains multiple
% paths to different NWB directories. If this is the case, it is worth
% reseting the MATLAB path variable with 'restoredefaultpath'.

    if (~exist('version','var'))
        version = '2.4.0';
    end

    addpath(genpath(NWB_path));
    
    if generate_core == true
        curr_dir = cd(NWB_path);
        generateCore(version);
        cd(curr_dir);
    end
    
    output=1;

end

