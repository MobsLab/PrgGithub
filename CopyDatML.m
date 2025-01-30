function CopyDatML(fnameIn,fnameOut,duration,varargin)

% USAGE
%     CopyDat(fnameIn,fnameOut,duration,varargin)
% copy a given number of seconds of data from one dat file into another one    
%     
% INPUT    
%     - fnameIn: source file
%     - fnameOIut: target file
%     - duation: duration in seconds
% 
% Adrien Peyrache, 2012
    
fxml = [fnameIn(1:end-4) '.xml'];
if ~exist(fnameIn,'file') && ~exist(fxml,'file')
  error('Dat file and/or Xml file does not exist')
end
sizeInBytes = 2; % change it one day...
chunk = 1e5; % depends on the system... could be bigger I guess

syst = LoadXml(fxml);

fInfo = dir(fnameIn);


start=0;
if ~isempty(varargin)
    start=varargin{1};
    duration=(fInfo.bytes/syst.nChannels)/(syst.SampleRate*sizeInBytes)-start;
end


nBytes = syst.SampleRate*duration*sizeInBytes;
if fInfo.bytes<nBytes*syst.nChannels
    error('Duration longer than total duration of file')
end
    
nbChunks = floor(nBytes/(sizeInBytes*chunk));

fidO = fopen(fnameOut,'w');
fidI = fopen(fnameIn,'r');

start = floor(start*syst.SampleRate)*syst.nChannels*sizeInBytes;
status = fseek(fidI,start,'bof');
if status ~= 0,
		error('Could not start reading (possible reasons include trying to read a closed file or past the end of the file).');
end

for ii=1:nbChunks
    h=waitbar(ii/(nbChunks+1));
    dat = fread(fidI,syst.nChannels*chunk,'int16');
    fwrite(fidO,dat,'int16');
end

remainder = nBytes/sizeInBytes - nbChunks*chunk;
if ~isempty(remainder)
    dat = fread(fidI,syst.nChannels*remainder,'int16');
    fwrite(fidO,dat,'int16');
end
close(h);

fclose(fidI);
fclose(fidO);




