function [SpectroREM,SpectroSWS,SpectroWake,facREM,facSWS,facWake,valThetaREM,valThetaSWS,valThetaWake,freq,temps] = PlotThetaPowerOverTime_Septum_SingleMouse_TG(plo)

try
    plo;
catch
    plo=0;
end


load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
%load SleepScoring_OBGamma REMEpoch SWSEpoch Wake ThetaEpoch
load B_High_Spectrum
SpectroG=Spectro;
freqG=Spectro{3};
sptsdG= tsd(SpectroG{2}*1e4, SpectroG{1});

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

if plo
    
    figure('color',[1 1 1]),
    subplot(231), imagesc(temps,freq, SpectroREM), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([40 +80])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    
    subplot(232), imagesc(temps,freq, SpectroSWS), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([40 +80])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    
    subplot(233), imagesc(temps,freq, SpectroWake), axis xy, caxis([0 1]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    ylim([40 +80])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    
    subplot(234),plot(temps,mean(SpectroREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    
    subplot(235),plot(temps,mean(SpectroSWS(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroSWS(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('Gamma power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(236),plot(temps,mean(SpectroWake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.2])
    ylabel('Gamma power')
    line([0 0], ylim,'color','k','linestyle',':')
    savefig(fullfile(pathname2,'GammaPowerStim'))
end


pathname='Figures'
pathname2='Figures'
mkdir Figures
mkdir(fullfile(pathname,'Figures'))
