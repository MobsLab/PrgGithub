function [MSws,MRem,MWake,BetaSWS,BetaREM,BetaWake,freqB,tps] = QuantifBeta_SingleMouse_MC(Wake,REMEpoch,SWSEpoch,plo)
% outputs : OB spectrogram values matrices during REM,NREM,Wake
%           beta power REM,NREM,Wake
%           freq and time (of the spectro)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load Bulb_deep_High_Spectrum
SpectroB=Spectro;

clear datOBnew
datOB = Spectro{1};
for k = 1:size(datOB,2)
    datOBnew(:,k) = runmean(datOB(:,k),200); % to smooth the high freq spectro
end

sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd
freqB=SpectroB{3};

[Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to get optogenetic stimulations

[MSws,SSws,TPS]=AverageSpectrogram(sptsdB,freqB,(Restrict(ts(Stim*1E4),SWSEpoch)),500,500,0); % compute spectro averaged on events/stims
[MRem,SRem,TPS]=AverageSpectrogram(sptsdB,freqB,(Restrict(ts(Stim*1E4),REMEpoch)),500,500,0);
[MWake,SWake,TPS]=AverageSpectrogram(sptsdB,freqB,(Restrict(ts(Stim*1E4),Wake)),500,500,0);

% trigger each line (frequency) of the spectro on events/stims
for f=1:length(freqB)
    for evS=1:length(StimSWS)
        [MatSWS(f,evS,:),S_SWS(f,evS,:),tps]=mETAverage(StimSWS(evS),Range(sptsdB),SpectroB{1}(:,f),1000,1000);
    end
    for evR=1:length(StimREM)
        [MatREM(f,evR,:),S_REM(f,evR,:),tps]=mETAverage(StimREM(evR),Range(sptsdB),SpectroB{1}(:,f),1000,1000); 
    end
    for evW=1:length(StimWake)
        [MatWake(f,evW,:),S_wake(f,evW,:),tps]=mETAverage(StimWake(evW),Range(sptsdB),SpectroB{1}(:,f),1000,1000);
    end
end


BetaSWS=squeeze(nanmean(MatSWS(find(freqB<30&freqB>21),:,:),1)); % frequency band average to get the beta power
BetaREM=squeeze(nanmean(MatREM(find(freqB<30&freqB>21),:,:),1));
BetaWake=squeeze(nanmean(MatWake(find(freqB<30&freqB>21),:,:),1));

T=tps/1E3;  % to define time window before and during the stims
BeforeStim=find(T>-10&T<0);
DuringStim=find(T>0&T<10);

if plo
    % zscore spectro centered on events/stims during REM,NREM and wake
    figure, subplot(4,5,[1,5]),  imagesc(TPS/1E3,freqB,MRem), axis xy
%     imagesc(TPS/1E3,freqB,zscore(MRem')'), axis xy
    colormap(jet)
%     caxis([-2 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-50 +50])
    ylim([20 90])
    ylabel('Frequency (Hz)')
    title('OB REM')
    colorbar
    subplot(4,5,[6,10]), imagesc(TPS/1E3,freqB,MSws), axis xy
%     imagesc(TPS/1E3,freqB,zscore(MSws')'), axis xy
    colormap(jet)
%     caxis([-2 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-50 +50])
    ylim([20 90])
    ylabel('Frequency (Hz)')
    title('OB NREM')
    colorbar
    subplot(4,5,[11,15]), imagesc(TPS/1E3,freqB,MWake), axis xy
%     imagesc(TPS/1E3,freqB,zscore(MWake')'), axis xy
    colormap(jet)
%     caxis([-2 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-50 +50])
    ylim([20 90])
    ylabel('Frequency (Hz)')
    title('OB Wake')
    xlabel('Time (s)')
    colorbar
    
    % Beta power during the stims (REM,NREM,Wake)
    subplot(4,5,[16,17]),shadedErrorBar(tps/1E3,BetaWake,{@mean,@stdError},'-b',1);
    hold on
    shadedErrorBar(tps/1E3,BetaSWS,{@mean,@stdError},'-r',1);
    shadedErrorBar(tps/1E3,BetaREM,{@mean,@stdError},'-g',1);
    line([0 0], ylim,'color','k','linestyle',':')
    ylabel('Beta power')
    xlabel('Times (s)')
%     ylim([0 1.5e+04])
    % ylim([500 6000])
    xlim([-10 +10])
    
    % Beta power quantification before 10s before stims and 10s during
    % stims
    subplot(4,5,18),PlotErrorBar2(mean(BetaREM(:,BeforeStim),2),mean(BetaREM(:,DuringStim),2),0);
    ylabel('Beta power')
%     ylim([0 1.5e+04])
    xticks(1:2)
    xticklabels({'Before ','During '});
    title('REM')
    subplot(4,5,19), PlotErrorBar2(mean(BetaSWS(:,BeforeStim),2),mean(BetaSWS(:,DuringStim),2),0);
    ylabel('Beta power')
%     ylim([0 1.5e+04])
    xticks(1:2)
    xticklabels({'Before ','During '});
    title('NREM')
    subplot(4,5,20), PlotErrorBar2(mean(BetaWake(:,BeforeStim),2),mean(BetaWake(:,DuringStim),2),0);
    ylabel('Beta power')
%     ylim([0 1.5e+04])
    xticks(1:2)
    xticklabels({'Before ','During '});
    title('Wake')
    
    suptitle([' ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
end
