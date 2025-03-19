function [M_start, M_end, M_stim] = GetActivityAtStateTransition_MC(type, state)

% INPUT
% type : 'emg' or 'accelero'
% state : 'rem', 'sws', 'wake'
% or 'transREMSWS', 'transREMWake'

% OUTPUT
% the matrix M :   time, mean, std, stdError from PlotRipRaw
% triggered on start, end and stimulations of the choosen state

%% Get data
load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
REMEpoch  = mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
Wake =  mergeCloseIntervals(WakeWiNoise,1E4);

%==========================================================================
[aft_cell1,bef_cell1] = transEpoch(REMEpoch,SWSEpoch);
StartSWS_precededByREM = Start(bef_cell1{2,1});

[aft_cell2,bef_cell2] = transEpoch(REMEpoch,Wake);
StartWake_precededByREM = Start(bef_cell2{2,1});
%==========================================================================

if strcmp(lower(type),'emg')
    % to get the EMG channel
    res = pwd;
    nam = 'EMG';
    eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
    chEMG = tempchEMG.channel;
    eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
    LFP_emg = LFP;
    % resample + square signal
    SqurdActivity = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);
    
elseif strcmp(lower(type),'accelero')
    % get accelero
    load('behavResources.mat', 'MovAcctsd')
    SqurdActivity = tsd(Range(MovAcctsd),Data(MovAcctsd).^2);
end

% to get opto stimulations if exist
if exist('StimOpto.mat')
    load('StimOpto.mat');
elseif exist('StimOpto_sham.mat')
    load('StimOpto_sham.mat')
else
end

dur = 30000;

%% compute average activity for each transition and/or stimulations
if strcmp(lower(state),'wake')
    [M_start,T_start] = PlotRipRaw_MC(SqurdActivity, Start(Wake)/1E4, 60000, 0, 0); % (PlotRipRaw_MC computes median)
    [M_end,T_end] = PlotRipRaw_MC(SqurdActivity, End(Wake)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdActivity, StimWake/1E4, 60000, 0, 0); % to compute activity around stims (if exist)
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
    
elseif strcmp(lower(state),'sws')
    [M_start,T_start] = PlotRipRaw_MC(SqurdActivity, Start(SWSEpoch)/1E4, 60000, 0, 0);
    [M_end,T_end] = PlotRipRaw_MC(SqurdActivity, End(SWSEpoch)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdActivity, StimSWS/1E4, 60000, 0, 0);
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
    
elseif strcmp(lower(state),'rem')
    [M_start,T_start] = PlotRipRaw_MC(SqurdActivity, Start(REMEpoch)/1E4, 60000, 0, 0);
    [M_end,T_end] = PlotRipRaw_MC(SqurdActivity, End(REMEpoch)/1E4, 60000, 0, 0);
    if exist('StimOpto.mat') || exist('StimOpto_sham.mat')
        [M_stim,T_stim] = PlotRipRaw_MC(SqurdActivity, StimREM/1E4, 60000, 0, 0);
    else
        M_stim = zeros(1,4);
        M_stim(:,:) = NaN;
    end
    
%==========================================================================

elseif strcmp(state,'transREMSWS')
    if isempty(StartSWS_precededByREM)
        M_start = zeros(1201,4);
        M_start(:) = NaN;
    else
        [M_start,T_start] = PlotRipRaw_MC(SqurdActivity, Start(bef_cell1{2,1})/1E4, 60000, 0, 0);
    end
    M_end = NaN;
    M_stim = NaN;
    
elseif strcmp(state,'transREMWake')
    if isempty(StartWake_precededByREM)
        M_start = zeros(1201,4);
        M_start(:) = NaN;

    else
        [M_start,T_start] = PlotRipRaw_MC(SqurdActivity, Start(bef_cell2{2,1})/1E4, 60000, 0, 0);
    end
    M_end = NaN;
    M_stim = NaN;
    
    %==========================================================================
    
end

