function [MatRemDelt,MatRemDeltStart,MatRemDeltEnd] = GetDeltasDensityOpto_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise)

try
    plo;
catch
    plo=0;
end


% REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
% SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
% WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load LFPData/LFP1 LFP
% %to get the EMG channel
% res=pwd;
% nam='EMG';
% eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
% chEMG=tempchEMG.channel;
% eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
% LFPemg=LFP;

% % square signal
% LFPemg=tsd(Range(LFPemg),Data(LFPemg).^2);
% [EEGf]=FilterLFP(LFPemg,[50 300]);

%to get opto stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;




%to compute triggered ripples spectro averaged accross stimulations


if exist('DeltaWaves.mat')
    load('DeltaWaves.mat')
else
end
    
    
[Y,X] = hist(Start(deltas_PFCx,'s'),[0:1:max(Range(LFP,'s'))]);
Deltas_tsd = tsd(X*1E4,Y');
[MatRemDelt,TpsRemDelt] = PlotRipRaw(Deltas_tsd, StimR, 60000, 0, 0);
[MatWakeDelt,TpsWakeDelt] = PlotRipRaw(Deltas_tsd, StimW, 60000, 0, 0);
[MatSwsDelt,TpsSwsEDelt] = PlotRipRaw(Deltas_tsd, StimS, 60000, 0, 0);

[MatRemDeltStart,TpsRemDeltStart] = PlotRipRaw(Deltas_tsd, Start(REMEpochWiNoise)/1e4, 60000, 0, 0);
[MatRemDeltEnd,TpsRemDeltEnd] = PlotRipRaw(Deltas_tsd, End(REMEpochWiNoise)/1e4, 60000, 0, 0);




end

