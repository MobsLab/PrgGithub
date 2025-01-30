clear all
% [file, path, filterindex] = ...
%     uigetfile('*.rhd', 'Select an RHD2000 Data File', 'MultiSelect', 'off');
path=pwd;
file='/info.rhd';
filterindex=1;
% Read most recent file automatically.
%path = 'C:\Users\Reid\Documents\RHD2132\testing\';
%d = dir([path '*.rhd']);
%file = d(end).name;

tic;
filename = [path,file];
fid = fopen(filename, 'r');

s = dir(filename);
filesize = s.bytes;

% Check 'magic number' at beginning of file to make sure this is an Intan
% Technologies RHD2000 data file.
magic_number = fread(fid, 1, 'uint32');
if magic_number ~= hex2dec('c6912702')
    error('Unrecognized file type.');
end

% Read version number.
data_file_main_version_number = fread(fid, 1, 'int16');
data_file_secondary_version_number = fread(fid, 1, 'int16');

fprintf(1, '\n');
fprintf(1, 'Reading Intan Technologies RHD2000 Data File, Version %d.%d\n', ...
    data_file_main_version_number, data_file_secondary_version_number);
fprintf(1, '\n');

% Read information of sampling rate and amplifier frequency settings.
sample_rate = fread(fid, 1, 'single');
dsp_enabled = fread(fid, 1, 'int16');
actual_dsp_cutoff_frequency = fread(fid, 1, 'single');
actual_lower_bandwidth = fread(fid, 1, 'single');
actual_upper_bandwidth = fread(fid, 1, 'single');

desired_dsp_cutoff_frequency = fread(fid, 1, 'single');
desired_lower_bandwidth = fread(fid, 1, 'single');
desired_upper_bandwidth = fread(fid, 1, 'single');

% This tells us if a software 50/60 Hz notch filter was enabled during
% the data acquisition.
notch_filter_mode = fread(fid, 1, 'int16');
notch_filter_frequency = 0;
if (notch_filter_mode == 1)
    notch_filter_frequency = 50;
elseif (notch_filter_mode == 2)
    notch_filter_frequency = 60;
end

desired_impedance_test_frequency = fread(fid, 1, 'single');
actual_impedance_test_frequency = fread(fid, 1, 'single');

% If data file is from GUI v1.1 or later, see if temperature sensor data
% was saved.
num_temp_sensor_channels = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 1) ...
    || (data_file_main_version_number > 1))
    num_temp_sensor_channels = fread(fid, 1, 'int16');
end

% If data file is from GUI v1.3 or later, load eval board mode.
eval_board_mode = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 3) ...
    || (data_file_main_version_number > 1))
    eval_board_mode = fread(fid, 1, 'int16');
end

% Place frequency-related information in data structure.
frequency_parameters = struct( ...
    'amplifier_sample_rate', sample_rate, ...
    'aux_input_sample_rate', sample_rate / 4, ...
    'supply_voltage_sample_rate', sample_rate / 60, ...
    'board_adc_sample_rate', sample_rate, ...
    'board_dig_in_sample_rate', sample_rate, ...
    'desired_dsp_cutoff_frequency', desired_dsp_cutoff_frequency, ...
    'actual_dsp_cutoff_frequency', actual_dsp_cutoff_frequency, ...
    'dsp_enabled', dsp_enabled, ...
    'desired_lower_bandwidth', desired_lower_bandwidth, ...
    'actual_lower_bandwidth', actual_lower_bandwidth, ...
    'desired_upper_bandwidth', desired_upper_bandwidth, ...
    'actual_upper_bandwidth', actual_upper_bandwidth, ...
    'notch_filter_frequency', notch_filter_frequency, ...
    'desired_impedance_test_frequency', desired_impedance_test_frequency, ...
    'actual_impedance_test_frequency', actual_impedance_test_frequency );
frequency_parameters

f = fopen('info.txt', 'w');
fprintf(f, '%s','amplifier_sample_rate: ',num2str(frequency_parameters.amplifier_sample_rate));
fprintf(f,'\n');
fprintf(f, '%s','aux_input_sample_rate: ',num2str(frequency_parameters.aux_input_sample_rate));
fprintf(f,'\n');
fprintf(f, '%s','supply_voltage_sample_rate: ',num2str(frequency_parameters.supply_voltage_sample_rate));
fprintf(f,'\n');
fprintf(f, '%s','board_adc_sample_rate: ',num2str(frequency_parameters.board_adc_sample_rate));
fprintf(f,'\n');
fprintf(f, '%s','board_dig_in_sample_rate: ',num2str(frequency_parameters.board_dig_in_sample_rate));
fprintf(f,'\n');
fprintf(f, '%s','desired_dsp_cutoff_frequency: ',num2str(frequency_parameters.desired_dsp_cutoff_frequency));
fprintf(f,'\n');
fprintf(f, '%s','actual_dsp_cutoff_frequency: ',num2str(frequency_parameters.actual_dsp_cutoff_frequency));
fprintf(f,'\n');
fprintf(f, '%s','dsp_enabled: ',num2str(frequency_parameters.dsp_enabled));
fprintf(f,'\n');
fprintf(f, '%s','desired_lower_bandwidth: ',num2str(frequency_parameters.desired_lower_bandwidth));
fprintf(f,'\n');
fprintf(f, '%s','actual_lower_bandwidth: ',num2str(frequency_parameters.actual_lower_bandwidth));
fprintf(f,'\n');
fprintf(f, '%s','actual_dsp_cutoff_frequency: ',num2str(frequency_parameters.actual_dsp_cutoff_frequmency));
fprintf(f,'\n');
fprintf(f, '%s','desired_upper_bandwidth: ',num2str(frequency_parameters.desired_upper_bandwidth));
fprintf(f,'\n');
fprintf(f, '%s','notch_filter_frequency: ',num2str(frequency_parameters.notch_filter_frequency));
fprintf(f,'\n');
fprintf(f, '%s','desired_upper_bandwidth: ',num2str(frequency_parameters.desired_upper_bandwidth));
fprintf(f,'\n');
fprintf(f, '%s','desired_impedance_test_frequency: ',num2str(frequency_parameters.desired_impedance_test_frequency));
fprintf(f,'\n');
fprintf(f, '%s','actual_impedance_test_frequency: ',num2str(frequency_parameters.actual_impedance_test_frequency));


fclose(f);