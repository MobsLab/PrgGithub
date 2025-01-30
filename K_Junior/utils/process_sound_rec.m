%process sound data

filename = 'Sound-Mouse-336-05072016.dat';
num_channels = 1; % ADC input info from header file 
fileinfo = dir(filename); 
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes 
fid = fopen(filename, 'r'); 
v = fread(fid, [num_channels, num_samples], 'uint16'); 
fclose(fid); 
v = v * 0.000050354; % convert to volts 


filename = 'Sound-Mouse-336-05072016.lfp';
num_channels = 1; % ADC input info from header file 
fileinfo = dir(filename); 
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes 
fid = fopen(filename, 'r'); 
v2 = fread(fid, [num_channels, num_samples], 'uint16'); 
fclose(fid); 
v2 = v2 * 0.000050354; % convert to volts 


filename = 'Testsound-Mouse-336-05062016_original.dat';
num_channels = 71; % ADC input info from header file 
fileinfo = dir(filename); 
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes 
fid = fopen(filename, 'r'); 
v3 = fread(fid, [num_channels, num_samples], 'uint16'); 
fclose(fid); 
v3 = v3 * 0.000050354; % convert to volts 

filename = 'Testsound-Mouse-336-05062016.dat';
num_channels = 71; % ADC input info from header file 
fileinfo = dir(filename); 
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes 
fid = fopen(filename, 'r'); 
v4 = fread(fid, [num_channels, num_samples], 'uint16'); 
fclose(fid); 
v4 = v4 * 0.000050354; % convert to volts 

filename = 'Testsound-Mouse-336-05062016.lfp';
num_channels = 71; % ADC input info from header file 
fileinfo = dir(filename); 
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes 
fid = fopen(filename, 'r'); 
v5 = fread(fid, [num_channels, num_samples], 'uint16'); 
fclose(fid); 
v5 = v5 * 0.000050354; % convert to volts