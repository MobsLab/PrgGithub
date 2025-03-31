clear all
pathname='Figures'
pathname2='Figures/Average_Spectrums'
mkdir Figures
mkdir(fullfile(pathname,'Average_Spectrums'))

load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PFCx_spindle.mat')
LowSpectrumjulien([cd filesep],channel,'PFCx_sup');
%%Bulb_deep (à modifier si autres channels)
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrumjulien([cd filesep],channel,'Bulb_deep');
%%Pour les plots Spectre du dHPC_sup (à modifier si autres channels)
%load('ChannelsToAnalyse/dHPC_sup.mat')
%LowSpectrumjulien([cd filesep],channel,'dHPC_sup');
%%Pour les plots Spectre du VLPO
load('ChannelsToAnalyse/VLPO.mat')
LowSpectrumjulien([cd filesep],channel,'VLPO');
%%Pour les plots Spectre du dHPC_deep
load('ChannelsToAnalyse/dHPC_deep.mat')
LowSpectrumjulien([cd filesep],channel,'dHPC_deep');

load('ExpeInfo.mat')
load('SleepScoring_OBGamma.mat')

case 'yes'
        disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        load('LFPData/DigInfo4.mat')
        TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
        % TTL = colonne de temps au dessus de 0.99 pour avoir les 1 = stim ON
        
        TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
        % merge tous les temps des stim plus proche de 1 sec pour éviter les créneaux et le remplacer par un step entier d'une min
        
        for k = 1:length(Start(TTLEpoch_merged))
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;
        
    case 'no'
        disp('no stims - simulating')
        if exist('SimulatedStims.mat')==0
        StimulateStimsWithTheta_VLPO
        end
        load('SimulatedStims.mat')
        events = sort([Range(RemStim,'s');Range(WakeStim,'s')]);
        Freq_Stim = ones(1,length(events))*20;
        TTLEpoch_merged = intervalSet(events*1e4,events*1e4+30*1e4);
        end
        
        
%%%%%%%theta Power

minduration=3;
    LowThetaEpochMC = thresholdIntervals(SmoothTheta,2,'Direction','Above');
    LowThetaEpochMC = mergeCloseIntervals(LowThetaEpochMC, minduration*1E4);
    LowThetaEpochMC = dropShortIntervals(LowThetaEpochMC, minduration*1E4);
 
save('SleepScoring_OBGamma','LowThetaEpochMC','-append')

load SleepScoring_OBGamma REMEpoch SWSEpoch Wake LowThetaEpochMC
%load SleepScoring_OBGamma REMEpoch SWSEpoch Wake ThetaEpoch

load dHPC_deep_Low_Spectrum
SpectroH=Spectro;
freqH=Spectro{3};
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});

% [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch, LowThetaEpochMC); % to find optogenetic stimulations

stim=events;

ev=ts(events*1E4);
evR=Range(Restrict(ev,REMEpochWiNoise),'s')
evS=Range(Restrict(ev,SWSEpochWiNoise),'s')
evW=Range(Restrict(ev,WakeWiNoise),'s')
length(evR)
length(evS)
length(evW)

% [MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),Wake),500,500,0);

[MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),and(WakeWiNoise,LowThetaEpochMC)),500,500,0);
[MH_REM,SH_REM,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
[MH_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);


SpectroREM=MH_REM/median(MH_REM(:));
SpectroSWS=MH_SWS/median(MH_SWS(:));
SpectroWake=MH_wake/median(MH_wake(:));

% SpectroREM=MH_REM/mean(MH_REM(1:floor(length(MH_REM))/2))*100;
% SpectroSWS=MH_SWS/mean(MH_SWS(1:floor(length(MH_SWS))/2))*100;
% SpectroWake=MH_wake/mean(MH_wake(1:floor(length(MH_wake))/2))*100;


runfac=4;
temps=tps/1E3;

freq=[1:size(SpectroREM,1)]/size(SpectroREM,1)*20;
% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;

idx1=find(freq>6&freq<9);
tpsidx=find(temps>-30&temps<0);

% beforeStim=find(temps>-30&temps<0);
% duringStim=find(temps>0&temps<30);

% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valThetaREM=mean(SpectroREM(idx1,:),1);
valThetaSWS=mean(SpectroSWS(idx1,:),1);
valThetaWake=mean(SpectroWake(idx1,:),1);

facREM=mean(valThetaREM(tpsidx));
facSWS=mean(valThetaSWS(tpsidx));
facWake=mean(valThetaWake(tpsidx));

stdfacREM=std(valThetaREM(tpsidx));
stdfacSWS=std(valThetaSWS(tpsidx));
stdfacWake=std(valThetaWake(tpsidx));

if plo
    
    figure('color',[1 1 1]),
    subplot(231), imagesc(temps,freq, SpectroREM), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([0 4])
    title('HPC REM')
    
    subplot(232), imagesc(temps,freq, SpectroSWS), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([0 4])
    title('HPC NREM')
    
    subplot(233), imagesc(temps,freq, SpectroWake), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([0 4])
    title('HPC Wake')
    
    
    subplot(234),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle','-')
    
    subplot(235),plot(temps,mean(SpectroSWS(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroSWS(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle','-')
    
    subplot(236),plot(temps,mean(SpectroWake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle','-')
    suptitle ('M1055 Sham 200602 - 100150')
end
        
        
 %%%%%%%Beta Power
 
 
load SleepScoring_OBGamma REMEpoch SWSEpoch Wake 
load B_High_Spectrum
SpectroB=Spectro;
freqB=Spectro{3};

clear datOBnew
datOB = Spectro{1};
for k = 1:size(datOB,2)
    datOBnew(:,k) = runmean(datOB(:,k),500); % to smooth the high freq spectro
end

sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd
% sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});


[Stim, StimREM, StimSWS, StimWake] = FindOptoStim_TG(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations

Stim=events;


[MB_wake,SB_wake,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),WakeWiNoise),500,500,0);
[MB_REM,SB_REM,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
[MB_SWS,SB_SWS,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);


SpectroBrem=MB_REM;
SpectroBsws=MB_SWS;
SpectroBwake=MB_wake;

% SpectroBrem=MB_REM/median(MB_REM(:));
% SpectroBsws=MB_SWS/median(MB_SWS(:));
% SpectroBwake=MB_wake/median(MB_wake(:));


% SpectroBrem=MB_REM/mean(MB_REM(1:floor(length(MB_REM))/2))*100;
% SpectroBsws=MB_SWS/mean(MB_SWS(1:floor(length(MB_SWS))/2))*100;
% SpectroBwake=MB_wake/mean(MB_wake(1:floor(length(MB_wake))/2))*100;


runfac=4;
temps=tps/1E3;

% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;


% freqB=[1:size(SpectroBrem,1)]/size(SpectroBrem,1)*20;

idx1=find(freqB>21&freqB<25);
tpsidx=find(temps>-30&temps<0);



% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valBetaREM=mean(SpectroBrem(idx1,:),1);
valBetaSWS=mean(SpectroBsws(idx1,:),1);
valBetaWake=mean(SpectroBwake(idx1,:),1);

facREM=mean(valBetaREM(tpsidx));
facSWS=mean(valBetaSWS(tpsidx));
facWake=mean(valBetaWake(tpsidx));

stdfacREM=std(valBetaREM(tpsidx));
stdfacSWS=std(valBetaSWS(tpsidx));
stdfacWake=std(valBetaWake(tpsidx));

if plo
    
    figure('color',[1 1 1]),
    subplot(231), imagesc(temps,freqB, SpectroBrem), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB REM')
    subplot(232), imagesc(temps,freqB, SpectroBsws), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB NREM')
    subplot(233), imagesc(temps,freqB, SpectroBwake), axis xy,colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    caxis([200 7000])
    title('OB Wake')
    
    
    subplot(234),plot(temps,mean(SpectroBrem(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBrem(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-60 +60])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle','-')
    
    subplot(235),plot(temps,mean(SpectroBsws(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBsws(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle','-')
    
    subplot(236),plot(temps,mean(SpectroBwake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBwake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.2])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle','-')
    
end

        
%%%%%%Stage transitions
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),REMEpochWiNoise),-30:1:30,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),SWSEpochWiNoise),-30:1:30,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),WakeWiNoise),-30:1:30,2);

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),REMEpoch),-30:1:30,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),SWSEpoch),-30:1:30,2);
[h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages,Restrict(ts(stim*1E4),Wake),-30:1:30,2);
        
        