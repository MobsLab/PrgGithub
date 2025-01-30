function [index_dreem, index_psg, virtual_dreem, virtual_psg] = GetVirtualChannels(filereference)
%   [index_dreem, index_psg, virtual_dreem, virtual_psg] = GetVirtualChannels(filereference)
%
% INPUT:
% - filereference       Reference of the record
% 
%
%
% OUTPUT:
% - index_dreem:        vector - indicate which channel is used to compute virtual channel signal of dreem headband:
%                           -1: bad quality
%                            0: FP1-M1 (channel 1)
%                            1: FP2-M2 (channel 2)
% - index_psg:          vector - indicate which channel is used to compute virtual channel signal of atiwave device:
%                           -1: bad quality
%                            0: REF F3 (channel 7)
%                            1: REF F4 (channel 10)
% - virtual_dreem:      struct tsd - Virtual-channel Filtered EEG signals from Dreem headband                
% - virtual_psg:        struct tsd - Virtual-channel Filtered EEG signals from Actiwave device                
%
%
%       see 
%           GetRecordClinic ComputeDataVirtualChannel
%


%% CHECK INPUTS

if nargin < 1
  error('Incorrect number of parameters.');
end

if ~exist('fs_eeg','var')
    fs_eeg = 250;
end


%% load
filename = [FolderClinicVirtual num2str(filereference) '.h5'];


%% dreem data
virtual_dreem = double(h5read(filename,'/channel1/visualization/'));
x = (0:(length(virtual_dreem)-1))' / fs_eeg;
virtual_dreem = tsd(x*1E4, virtual_dreem);

index_dreem = double(h5read(filename,'/channel1/index_channel/'));


%% actiwave data
virtual_psg = double(h5read(filename,'/channel2/visualization/'));
x = (0:(length(virtual_psg)-1))' / fs_eeg;
virtual_psg = tsd(x*1E4, virtual_psg);

index_psg = double(h5read(filename,'/channel2/index_channel/'));



end
