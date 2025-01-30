function [MatSwsRip,MatRemRipStart,MatRemRipEnd] = GetRipplesDensityOpto_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise)

try
    plo;
catch
    plo=0;
end


REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

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
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;




%to compute triggered ripples spectro averaged accross stimulations


if exist('SWR.mat')
    load('SWR.mat')
elseif exist('Ripples.mat')
    load('Ripples');
else
end
    
    
[Y,X] = hist(Start(RipplesEpoch,'s'),[0:1:max(Range(LFP,'s'))]);
Ripples_tsd = tsd(X*1E4,Y');
[MatRemRip,TpsRemRip] = PlotRipRaw(Ripples_tsd, StimR, 60000, 0, 0);
[MatWakeRip,TpsWakeRip] = PlotRipRaw(Ripples_tsd, StimW, 60000, 0, 0);
[MatSwsRip,TpsSwsERip] = PlotRipRaw(Ripples_tsd, StimS, 60000, 0, 0);
[MatRemRipStart,TpsRemRipStart] = PlotRipRaw(Ripples_tsd, Start(REMEp)/1e4, 60000, 0, 0);
[MatRemRipEnd,TpsRemRipEnd] = PlotRipRaw(Ripples_tsd, End(REMEp)/1e4, 60000, 0, 0);




end

