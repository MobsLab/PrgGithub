function lfp = LoadLfp(fbasename,nchannels,channels,varargin)
% 
% lfp = LoadLfp(fbasename,nchannels,channels)
% wrapper which returns a tsd object (uses LoadBinary)
% Adrien Peyrache 2012


lfp = LoadBinary([fbasename '.eeg'],'nchannels',nchannels,'channels',channels);
t = 10000*[0:length(lfp)-1]/1250;

lfp = tsd(t',lfp);


