function [emg_wake, emg_sws, emg_rem] = GetEMGForEachState_MC

load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');

% to get the EMG channel
res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFP_emg = LFP;
% resample + square signal
SqurdActivity = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);

% restrict to each epoch
emg_wake = Data(Restrict(SqurdActivity, Wake));
emg_sws = Data(Restrict(SqurdActivity, SWSEpoch));
emg_rem = Data(Restrict(SqurdActivity, REMEpoch));

end