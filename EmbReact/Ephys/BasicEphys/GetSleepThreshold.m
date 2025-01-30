function [sd,dur,thresh] = GetSleepThreshold(SleepSession,dHPC_rip)

% Parameters to change manually
noise_thr = 13E3;
%%%%----------------------------------%%%
freq = [120 220]; % frequency range of ripples
dur = [15 20 200]; % Durations for FindRipples
sd = [];
%%%%----------------------------------%%%


%% Load data
res = pwd;
cd(res);
LFP_rip = load([ res '/LFPData/LFP' num2str(dHPC_rip) '.mat']);
LFPf=FilterLFP(LFP_rip.LFP,freq,1048);
LFPr=LFP_rip.LFP;
load('StateEpochSB.mat','SWSEpoch')
LFPr = Restrict(LFPr,SWSEpoch);
GoodTime=Range(LFPf, 's');
GoodData=Data(LFPf);
clear LFP_rip LFP_noise
%% Calculate standard deviation without noise
    load('behavResources.mat');
    AboveEpoch=thresholdIntervals(LFPr,noise_thr,'Direction','Above'); % Threshold on non-filtered data!!!
    NoiseEpoch=thresholdIntervals(LFPr,-noise_thr,'Direction','Below'); % Threshold on non-filtered data!!!
    CleanEpoch=or(AboveEpoch,NoiseEpoch);
    CleanEpoch=intervalSet(Start(CleanEpoch)-3E3,End(CleanEpoch)+5E3);
    if exist('TTLInfo')
        StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-1E3, End(TTLInfo.StimEpoch)+3E3);
        GoEpoch = or(CleanEpoch,StimEpoch);
    else
        GoEpoch=CleanEpoch;
    end
    rg=Range(LFPr);
    TotalEpoch=intervalSet(rg(1),rg(end));
    SCleanEpoch=mergeCloseIntervals(GoEpoch,1);
    GoodTime=Range(Restrict(LFPf,TotalEpoch-SCleanEpoch), 's');
    GoodData=Data(Restrict(LFPf,TotalEpoch-SCleanEpoch));
    if rmvnoise == 1
        NoiseTime=Range(Restrict(LFPfn,TotalEpoch-SCleanEpoch), 's');
        NoiseData=Data(Restrict(LFPfn,TotalEpoch-SCleanEpoch));
    end


end


