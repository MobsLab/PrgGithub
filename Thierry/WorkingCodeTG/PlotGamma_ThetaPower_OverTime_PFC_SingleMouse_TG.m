
load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
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

%%ChangeThetaThresh_MC pour changer le seuil theta pendant eveil
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
    
subplot(312),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
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
[MG_wake,SH_wake,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),WakeWiNoise),500,500,0);
[MG_REM,SH_REM,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
[MG_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);


SpectroREM=MG_REM/median(MG_REM(:));
SpectroSWS=MG_SWS/median(MG_SWS(:));
SpectroWake=MG_wake/median(MG_wake(:));

% SpectroREM=MH_REM/mean(MH_REM(1:floor(length(MH_REM))/2))*100;
% SpectroSWS=MH_SWS/mean(MH_SWS(1:floor(length(MH_SWS))/2))*100;
% SpectroWake=MH_wake/mean(MH_wake(1:floor(length(MH_wake))/2))*100;


runfac=4;
temps=tps/1E3;

freq=[1:size(SpectroREM,1)]/size(SpectroREM,1)*80;
freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*80;
freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*80;

idx1=find(freq>50&freq<65);
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

subplot(313),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0.5 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 12)

    
%%%%%%EMG%%%%%

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
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeEp,SWSEp,REMEp); %to get opto stimulations
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

%to get EMG LFP signal around the stims
[MatRemEMG,TpsRemEMG] = PlotRipRaw_MC(LFPemg, StimR, 60000, 0, 0);
[MatWakeEMG,TpsWakeEMG] = PlotRipRaw_MC(LFPemg, StimW, 60000, 0, 0);
[MatSwsEMG,TpsSwsEMG] = PlotRipRaw_MC(LFPemg, StimS, 60000, 0, 0);

figure
subplot(311),plot(MatRemEMG(:,1),MatRemEMG(:,2),'k'),ylim([0 1e7]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('REM EMG')    
set(gca,'FontSize', 12)

subplot(312),plot(MatSwsEMG(:,1),MatSwsEMG(:,2),'k'),ylim([0 1e7]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('NREM EMG')    
set(gca,'FontSize', 12)

subplot(313),plot(MatWakeEMG(:,1),MatWakeEMG(:,2),'k'),ylim([0 1e7]),line([0 0], ylim,'color','k','linestyle',':')
xlim([-10 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Wake EMG')    
set(gca,'FontSize', 12)

    

   
    