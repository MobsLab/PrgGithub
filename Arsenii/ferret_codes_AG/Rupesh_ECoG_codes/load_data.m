% Example: Convert a .continuous file to a .dat file
for i = 1:40
    inputFile = ['100_' num2str(i) '.continuous'];
    outputFile = ['100_' num2str(i) '.dat'];
    
    fid_in = fopen(inputFile, 'rb');
    if fid_in == -1, error('Could not open file: %s', inputFile); end
    
    % Skip header (adjust header_size if needed)
    header_size = 1024;
    fread(fid_in, header_size, 'uint8');
    
    % Read data (assuming int16; adjust if necessary)
    data = fread(fid_in, inf, 'int16');
    fclose(fid_in);
    
    fid_out = fopen(outputFile, 'wb');
    if fid_out == -1, error('Could not open file for writing: %s', outputFile); end
    fwrite(fid_out, data, 'int16');
    fclose(fid_out);
    
end

for i = 1:40
    channels{i} = ['100_' num2str(i) '.dat']
end
nChannels = length(channels);
dataMatrix = [];

for ch = 1:nChannels
    fid = fopen(channels{ch}, 'rb');
    if fid == -1
        error('Error opening file: %s', channels{ch});
    end
    data = fread(fid, Inf, 'int16');  % adjust the data type if needed
    fclose(fid);
    
    % For the first channel, record the number of samples
    if ch == 1
        nSamples = length(data);
    elseif length(data) ~= nSamples
        error('Channel %d has a different number of samples.', ch);
    end
    
    % Store each channel's data as a column in the matrix
    dataMatrix(:, ch) = data;
end

% Write the interleaved multi-channel data
fid_out = fopen('combined_multichannel.dat', 'wb');
if fid_out == -1
    error('Error opening output file for writing.');
end
% Transpose the matrix so that data is written interleaved
fwrite(fid_out, dataMatrix', 'int16');
fclose(fid_out);

disp('Multi-channel files have been combined successfully.');
