%% This script generates an example session_metadata.mat file.
% The structure of the generated file is a prototype, although the fields
% may contain nonsensical values. (updated, Adriano 4/29/2022)

%% Animal metadata
% This will eventually come from experimenter's notes
animal.id = 'AB000'; %char array
animal.species = 'Mus musculus'; %char array
animal.sex = 'F'; %char array
animal.dob = convertStringsToChars(datetime(2021,04,20)); %datetime array
animal.strain = 'Ai32xNR133'; %char array
animal.virus = ''; %char array
animal.pharmacology = ''; %char array
animal.lesions = ''; %char array
animal.description = ...
    'Transgenic line expressing ChR2 in VPm.'; %char array, human-readable

%% Trial structure metadata
% This will eventually come from experimenter's notes (and stim files).

session.iacuc_protocol = 'A100223'; %char array
session.experimenter = 'Adriano'; %char array
session.institution = 'Georgia Tech'; %char array
session.recording_day = convertStringsToChars(datetime(2022,05,06)); %datetime char array
session.recording_session = '1'; %char array (# of the session on this animal)
session.number_of_blocks = 7; %float

%% Ephys metadata
% This will eventually come from a combination of experimenter's notes and a
% probe 'datasheet' with the right electrode mappings, relative locations,
% and measured impedances

ephys.recording_type = 'awake,head-fixed'; %char array
ephys.recording_targets = 'S1,VPm'; %char array
ephys.number_of_electrodes = 64; %float
ephys.description = 'Dual recording in VPm/S1 in an awake mouse.';
ephys.probes = struct('name',{'AB_Poly3_1','AB_Linear_1'},...
    'type',{'A1x32-Poly3-10mm-50-177','A1x32-Linear'},...
    'manufacturer',{'Neuronexus','Neuronexus'});
ephys.electrode_groups = struct(...
    'name',{'AB_Poly3_1_shank1','AB_Linear_1_shank1'},...
    'assigned_probe',{'AB_Poly3_1','AB_Linear_1'},...
    'location',{'S1','VPm'});

assigned_electrode_group(1:32) = {'AB_Poly3_1_shank1'};
assigned_electrode_group(33:64) = {'AB_Linear_1_shank1'};
impedance(1:64) = num2cell(1:64); %float (M-Ohms)
xcoords(1:64) = num2cell(zeros(1,64)); %float (um)
ycoords(1:64) = num2cell(ones(1,64)); %float (um)
zcoords(1:64) = num2cell((1:64)*100); %float (um)

ephys.electrodes = struct('assigned_electrode_group',assigned_electrode_group,...
    'impedance',impedance,...
    'xcoords',xcoords,...
    'ycoords',ycoords,...
    'zcoords',zcoords);


% 
% ephys.all_probe_types = {'A1x32-Poly3-10mm-50-177','A1x32-Linear'};
% ephys.all_electrode_groups = {'A1x32-Poly3-10mm-50-177_1','A1x32-Linear_1'};
% 
% 
% groupname(1:32) = {'A1x32-Poly3-10mm-50-177_1'}; groupname(33:64) = {'A1x32-Linear_1'}; %char array
% target_location(1:32) = {'S1'}; target_location(33:64) = {'VPm'}; %char array
% target_whisker(1:32) = {'B1'}; target_whisker(33:64) = {'Beta'}; %char array
% probe_type(1:32) = {'A1x32-Poly3-10mm-50-177'};
% probe_type(33:64) = {'A1x32-Linear'}; %char array
% impedance(1:64) = num2cell(1:64); %float (M-Ohms)
% xcoords(1:64) = num2cell(zeros(1,64)); %float (um)
% ycoords(1:64) = num2cell(ones(1,64)); %float (um)
% zcoords(1:64) = num2cell((1:64)*100); %float (um)
% 
% ephys.electrodes = struct('groupname',groupname,...
%     'target_location',target_location,...
%     'target_whisker',target_whisker,...
%     'probe_type',probe_type,...
%     'impedance',impedance,...
%     'xcoords',xcoords,...
%     'ycoords',ycoords,...
%     'zcoords',zcoords);

clear groupname target_location target_whisker probe_type ...
    impedance xcoords ycoords zcoords assigned_electrode_group

%% Opto metadata
% This will eventually come from experimenter's notes.

opto.number_of_leds = 2; %float
opto.description = 'Stimulating with blue light in VPm; yellow light in S1.';

opto.leds = struct('wavelength',{590,470},... %float (nm)
    'tip_diameter',{400,100},... %float (um)
    'target_location',{'S1','VPm'},... %char array
    'fiber_name', {'generic_1','generic_2'},...
    'fiber_type', {'free', 'probe-affixed'},...
    'conversion_factor',{1.7,1.8}); %float (V->mW/mm^2)

%% Galvo metadata
% This will eventually come from experimenter's notes.

galvo.number_of_galvos = 2; %float
galvo.description = 'Different whiskers threaded on different blocks.';

blocks1 = struct('target_whisker',{'B1','Beta','','','','',''});
blocks2 = struct('target_whisker',{'','','','','iB1','',''});

galvo.galvos = struct('blocks',{blocks1,blocks2});

clear blocks1 blocks2

%% save the metadata
save('eg_session_metadata.mat','animal','session','ephys','opto','galvo')