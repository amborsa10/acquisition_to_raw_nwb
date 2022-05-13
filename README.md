# acquisition_to_raw_nwb
Functions for saving ephys acquisition data from proprietary file formats as a 'raw' NWB file according to the Stanley Lab acute ephys data standard

Instructions for Elaida (5/13/2022): go to the examples/TDT directory and follow the directions in the script 'working_script.m'. 
After modifying a few things as described in the comments, you should be able to run the script and generate a very light raw NWB file.
The TDT tanks for the example reside on the shared drive in 'Y:\stanley\Data\Adriano\NN64Chan_img-220304'.

Ideally, there would be a Cerebus/Blackrock version of the 'tdt_config.mat' file, the 'read_TDT_block.m' function, and the 'read_TDT_session_triggers.m' function.
