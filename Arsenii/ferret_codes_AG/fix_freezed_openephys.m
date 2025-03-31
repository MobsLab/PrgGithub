fileID = fopen('continuous.dat');
ephysRaw = fread(fileID, 'int16=>int16');

%check the number of channels
nChannels = 43;

ephysRaw = ephysRaw(1:floor(length(ephysRaw)/nChannels)*nChannels);

fileID = fopen('continuous_new.dat','w');
% fwrite(fileID,ephysRaw,'int16=>int16');
fwrite(fileID,ephysRaw,'int16');
fclose(fileID);


% to check if everything is alright
fileID = fopen('continuous.dat');
ephysRaw = fread(fileID, 'int16=>int16');
dat = reshape(ephysRaw, [], 43);