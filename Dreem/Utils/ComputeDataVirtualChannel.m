function [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPsg] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel)
%   [signals_dreem_vc, signals_psg_vc, badEpochsDreem, badEpochsPSG] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel))
%
% INPUT:
% - signals                 struct tsd - EEG or LFP signals
% - index_dreem:            vector - indicate which channel is used to compute virtual channel signal of dreem headband:
%                               -1: bad quality
%                               0: FP1-M1 (channel 1)
%                               1: FP2-M2 (channel 2)
% - index_psg:              vector - indicate which channel is used to compute virtual channel signal of atiwave device:
%                               -1: bad quality
%                               0: REF F3 (channel 7)
%                               1: REF F4 (channel 10)
% - name_channel:           cell strings - name of the channels in signals
%
%
% OUTPUT:
%
% - signals_dreem_vc:       tsd - Virtual-channel EEG signals from Dreem headband                
% - signals_psg_vc:         tsd - Virtual-channel EEG signals from Actiwave device                
% - badEpochsDreem:         intervalSet - intervals of bad quality for Dreem headband
% - badEpochsPsg:           intervalSet - intervals of bad quality for Actiwave device
%
%
%       see 
%           GetRecordClinic GetVirtualChannels
%

%% CHECK INPUTS

if nargin < 4
  error('Incorrect number of parameters.');
end



%% VIRTUAL CHANNEL SIGNAL
% Dreem 
dreem_ch1 = strcmpi(name_channel,'FP1-M1');
dreem_ch2 = strcmpi(name_channel,'FP2-M2');

sig_f1 = Data(signals{dreem_ch1}) .* (index_dreem==0);
sig_f2 = Data(signals{dreem_ch2}) .* (index_dreem==1);

signals_dreem_vc = sig_f1 + sig_f2;
signals_dreem_vc = tsd(Range(signals{dreem_ch1}), signals_dreem_vc);


% Actiwave
psg_ch1 = strcmpi(name_channel,'REF F3');
psg_ch2 = strcmpi(name_channel,'REF F4');

sig_f3 = Data(signals{psg_ch1}) .* (index_psg==0);
sig_f4 = Data(signals{psg_ch2}) .* (index_psg==1);

signals_psg_vc = sig_f3 + sig_f4;
signals_psg_vc = tsd(Range(signals{psg_ch1}), signals_psg_vc);


%% BAD EPOCHS
% Dreem 
start_bad_epoch = [];
end_bad_epoch = [];
bad_index = (index_dreem==-1);
if bad_index(1)==1
    start_bad_epoch = [start_bad_epoch;1];
end
start_bad_epoch = [start_bad_epoch;find(diff(bad_index)==1)-1];
end_bad_epoch = [end_bad_epoch;find(diff(bad_index)==-1)];
if bad_index(end)==1
    end_bad_epoch = [end_bad_epoch;length(bad_index)];
end

rg = Range(signals_dreem_vc);
start_bad_epoch = rg(start_bad_epoch);
end_bad_epoch = rg(end_bad_epoch);

badEpochsDreem = intervalSet(start_bad_epoch,end_bad_epoch);


% Actiwave 
start_bad_epoch = [];
end_bad_epoch = [];
bad_index = (index_psg==-1);
if bad_index(1)==1
    start_bad_epoch = [start_bad_epoch;1];
end
start_bad_epoch = [start_bad_epoch;find(diff(bad_index)==1)-1];
end_bad_epoch = [end_bad_epoch;find(diff(bad_index)==-1)];
if bad_index(end)==1
    end_bad_epoch = [end_bad_epoch;length(bad_index)];
end

rg = Range(signals_psg_vc);
start_bad_epoch = rg(start_bad_epoch);
end_bad_epoch = rg(end_bad_epoch);

badEpochsPsg = intervalSet(start_bad_epoch,end_bad_epoch);


end



