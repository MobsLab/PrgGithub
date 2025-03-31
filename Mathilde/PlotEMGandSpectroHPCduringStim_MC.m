function [MatRemEMG,MatWakeEMG,MatSwsEMG,MatSpHPC,FreqSpHPC,TpsSpHPC] = PlotEMGandSpectroHPCduringStim_MC(plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise 
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

%to get the EMG channel
res=pwd;
nam='EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG=tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])

LFPemg=LFP;
% square signal
LFPemg=tsd(Range(LFPemg),Data(LFPemg).^2);

[EEGf]=FilterLFP(LFPemg,[50 300]);

%to get opto stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeEp,SWSEp,REMEp); %to get opto stimulations
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

%to get EMG LFP signal around the stims
[MatRemEMG,TpsRemEMG] = PlotRipRaw_MC(LFPemg, StimR, 60000, 0, 0);
[MatWakeEMG,TpsWakeEMG] = PlotRipRaw_MC(LFPemg, StimW, 60000, 0, 0);
[MatSwsEMG,TpsSwsEMG] = PlotRipRaw_MC(LFPemg, StimS, 60000, 0, 0);

%to compute HPC spectro averaged accross stimulations
load H_Low_Spectrum
SpectroH=Spectro;
FreqSpHPC=Spectro{3};
[MatSpHPC,SH,TpsSpHPC]=AverageSpectrogram(tsd(SpectroH{2}*1E4,10*log10(SpectroH{1})),SpectroH{3},Restrict(ts(Stim*1E4),REMEp),500,300);
clf

if plo
    figure,
    suptitle(['Spectro&EMG',' ','M',num2str(ExpeInfo.nmouse)]),
    subplot(511),imagesc(TpsSpHPC/1E3,FreqSpHPC,MatSpHPC), xlim([-60 60]),axis xy
    line([0 0], ylim,'color','w','linestyle',':')
    subplot(512),plot(MatRemEMG(:,1),MatRemEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
    subplot(514),plot(MatSwsEMG(:,1),MatSwsEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
    subplot(515),plot(MatWakeEMG(:,1),MatWakeEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
    
    
end


% else
%     disp('no EMG channel found')
% end


end

