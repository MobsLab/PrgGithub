
load SleepScoring_OBGamma 
%load SleepScoring_OBGamma REMEpoch SWSEpoch Wake ThetaEpoch

disp('loading stim times')
        % Attention Digin2 pour ancien protocoles et Digin6 pour BCI protocol
        load('LFPData/DigInfo4.mat')
        TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
        % TTL = colonne de temps au dessus de 0.99 pour avoir les 1 = stim ON
        
        TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
        % merge tous les temps des stim plus proche de 1 sec pour éviter les créneaux et le remplacer par un step entier d'une min
        
        for k = 1:length(Start(TTLEpoch_merged));
            LittleEpoch = subset(TTLEpoch_merged,k);
            Freq_Stim(k) = round(1./(median(diff(Start(and(TTLEpoch,LittleEpoch),'s')))));
            Time_Stim(k) = min(Start(and(TTLEpoch,LittleEpoch)));
        end
        events=Start(TTLEpoch_merged)/1E4;

%%%%%%Theta%%%%%%

%load SleepScoring_OBGamma REMEpoch SWSEpoch Wake ThetaEpoch
load H_Low_Spectrum
SpectroH=Spectro;
freqH=Spectro{3};
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});


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
freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;

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

figure('color',[1 1 1]),
subplot(311), imagesc(temps,freq, SpectroREM), axis xy, caxis([0 5]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-10 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC REM')    
    set(gca,'FontSize', 12)
    
subplot(312),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Theta power')
    line([0 0], ylim,'color','k','linestyle',':')    
    set(gca,'FontSize', 12)    
    
figure('color',[1 1 1]),
subplot(311), imagesc(temps,freq, SpectroWake), axis xy, caxis([0 5]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-10 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC REM')    
    set(gca,'FontSize', 12)
    
 subplot(312),plot(temps,mean(SpectroWake(idx1,:),1)/facWake,'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWake(idx1,:),1)/facWake,runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Theta power')
    line([0 0], ylim,'color','k','linestyle',':')    
    set(gca,'FontSize', 12)    
        
        
%%%%%%%Gamma%%%%%%
load B_High_Spectrum
SpectroG=Spectro;
freqG=Spectro{3};
sptsdG= tsd(SpectroG{2}*1e4, SpectroG{1});
        

% ev=ts(events*1E4);
% evR=Range(Restrict(ev,REMEpochWiNoise),'s')
% evS=Range(Restrict(ev,SWSEpochWiNoise),'s')
% evW=Range(Restrict(ev,WakeWiNoise),'s')

% [MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),Wake),500,500,0);

%[MG_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),and(WakeWiNoise,LowThetaEpochMC)),500,500,0);
[MG_wake,SH_wake,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),WakeWiNoise),1000,1000,0);
[MG_REM,SH_REM,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),REMEpochWiNoise),1000,1000,0);
[MG_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),SWSEpochWiNoise),1000,1000,0);


SpectroREMG=MG_REM/median(MG_REM(:));
SpectroSWSG=MG_SWS/median(MG_SWS(:));
SpectroWakeG=MG_wake/median(MG_wake(:));

% SpectroREM=MH_REM/mean(MH_REM(1:floor(length(MH_REM))/2))*100;
% SpectroSWS=MH_SWS/mean(MH_SWS(1:floor(length(MH_SWS))/2))*100;
% SpectroWake=MH_wake/mean(MH_wake(1:floor(length(MH_wake))/2))*100;


runfac=4;
temps=tps/1E3;

freq=[1:size(SpectroREMG,1)]/size(SpectroREMG,1)*80;
freqS=[1:size(SpectroSWSG,1)]/size(SpectroSWSG,1)*80;
freqW=[1:size(SpectroWakeG,1)]/size(SpectroWakeG,1)*80;

idx1_gamma=find(freq>50&freq<65);
tpsidx_gamma=find(temps>-30&temps<0);

% idx1=find(freq>21&freq<25);
% tpsidx=find(temps>-30&temps<0);


% beforeStim=find(temps>-30&temps<0);
% duringStim=find(temps>0&temps<30);

% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valThetaREMG=mean(SpectroREMG(idx1_gamma,:),1);
valThetaSWSG=mean(SpectroSWSG(idx1_gamma,:),1);
valThetaWakeG=mean(SpectroWakeG(idx1_gamma,:),1);

facREMG=mean(valThetaREMG(tpsidx_gamma));
facSWSG=mean(valThetaSWSG(tpsidx_gamma));
facWakeG=mean(valThetaWakeG(tpsidx_gamma));

stdfacREMG=std(valThetaREMG(tpsidx_gamma));
stdfacSWSG=std(valThetaSWSG(tpsidx_gamma));
stdfacWakeG=std(valThetaWakeG(tpsidx_gamma));

subplot(313),plot(temps,mean(SpectroREMG(idx1_gamma,:),1)/facREMG,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREMG(idx1_gamma,:),1)/facREMG,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREMG facREMG]/facREMG,'linewidth',1)
    line([temps(1) temps(end)],[facREMG+stdfacREMG facREM+stdfacREMG]/facREMG,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREMG-stdfacREMG facREMG-stdfacREMG]/facREMG,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 12)
    
subplot(313),plot(temps,mean(SpectroWakeG(idx1_gamma,:),1)/facWakeG,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWakeG(idx1_gamma,:),1)/facWakeG,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWakeG facWakeG]/facWakeG,'linewidth',1)
    line([temps(1) temps(end)],[facWakeG+stdfacWakeG facWakeG+stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWakeG-stdfacWakeG facWakeG-stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 12)

    
    
%%%%%%Beta%%%%%%

% load Bulb_deep_Low_Spectrum
% SpectroB=Spectro;
% freqB=Spectro{3};
% sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});
        
% ev=ts(events*1E4);
% evR=Range(Restrict(ev,REMEpochWiNoise),'s')
% evS=Range(Restrict(ev,SWSEpochWiNoise),'s')
% evW=Range(Restrict(ev,WakeWiNoise),'s')

% [MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),Wake),500,500,0);
%[MG_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),and(WakeWiNoise,LowThetaEpochMC)),500,500,0);

idx1=find(freq>21&freq<25);
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


subplot(414),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Beta power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 12)
    
pathname2='Figures'
mkdir Figures
savefig(fullfile(pathname2,'Theta_Gamma_duringStim_Stages'))
    
%%%%%%EMG%%%%%%%

load ExpeInfo
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
% [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeEp,SWSEp,REMEp); %to get opto stimulations

Stim = Start(TTLEpoch_merged)/1E4;  % to find opto stimulations
Stimts = ts(Stim*1e4);
% Stimts_1s =ts((Stim-1)*1e4);


StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

%to get EMG LFP signal around the stims
[MatRemEMG,TpsRemEMG] = PlotRipRaw_MC(LFPemg, StimR, 60000, 0, 0);
[MatWakeEMG,TpsWakeEMG] = PlotRipRaw_MC(LFPemg, StimW, 60000, 0, 0);
[MatSwsEMG,TpsSwsEMG] = PlotRipRaw_MC(LFPemg, StimS, 60000, 0, 0);

figure
subplot(311),plot(MatRemEMG(:,1),MatRemEMG(:,2),'k'),ylim([0 5e6]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('REM EMG')    
set(gca,'FontSize', 12)

subplot(312),plot(MatSwsEMG(:,1),MatSwsEMG(:,2),'k'),ylim([0 1e6]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('NREM EMG')    
set(gca,'FontSize', 12)

subplot(313),plot(MatWakeEMG(:,1),MatWakeEMG(:,2),'k'),ylim([0 1e6]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Wake EMG')    
set(gca,'FontSize', 12)

savefig(fullfile(pathname2,'EMGduringStim_Stages'))

   
    