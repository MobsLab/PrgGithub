function [M1,M2,ripEvt,ripples]=CompTwoChannelsRipples(LFP,v,Epoch,v2,vnoise)

PloStat=1;

paramRip=[3 5];
samplingRate = 1/median(diff(Range(LFP{v},'s')));

dur=200;
dur=30;
durations = [-dur dur]/1000;

nBins = floor(samplingRate*diff(durations)/2)*2+1;

%LFP=Restrict(LFP,Epoch);

try
    vnoise;
    
catch
    vnoise=0;
end

try
    Start(Epoch);
catch
    rg=Range(LFP{v});
    Epoch=intervalSet(rg(1),rg(end));    
end

    
    
%----------------------------------------
%----------------------------------------
%Find Ripples
%----------------------------------------
%----------------------------------------


FilRip=FilterLFP(Restrict(LFP{v},Epoch),[130 200],96);
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];

FilRip2=FilterLFP(Restrict(LFP{v2},Epoch),[130 200],96);
rgFil2=Range(FilRip2,'s');
filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];

% try
% [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'restrict',[debPeriodRip finPeriodRip]);
% catch
% [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);    
% end



%----------------------------------------

if vnoise>0
    
        NoiseRip=FilterLFP(Restrict(LFP{vnoise},Epoch),[130 200],96);
        rgNoise=Range(Restrict(LFP{vnoise},Epoch),'s');
        filteredNoise=[rgNoise-rgNoise(1) Data(NoiseRip)];
        
        FilTsd=tsd(filtered(:,1),filtered(:,2));
        FilNoiseTsd=tsd(filteredNoise(:,1),filteredNoise(:,2));
        
        FilNoiseTsd=Restrict(FilNoiseTsd,FilTsd);
        
        filteredNoise2(:,1)=Range(FilNoiseTsd);
        filteredNoise2(:,2)=Data(FilNoiseTsd);
        
        filteredNoise=filteredNoise2;
        
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'noise',filteredNoise,'show','off');

else  
%         try
%         [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'restrict',[debPeriodRip finPeriodRip]);
%         catch
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);    
%         end

end



%----------------------------------------
%----------------------------------------
%----------------------------------------


[maps1,data1,stats1] = RippleStats(filtered,ripples);
[maps2,data2,stats2] = RippleStats(filtered2,ripples);
if PloStat
PlotRippleStats(ripples,maps1,data1,stats1)
PlotRippleStats(ripples,maps2,data2,stats2)

%ripEvt=intervalSet((ripples(:,2)-0.1)*1E4,(ripples(:,2)+0.1)*1E4);

 
     % Pre-post comparison
figure('color',[1 1 1]);PlotDistribution2({data1.peakAmplitude data2.peakAmplitude},{data1.peakFrequency data2.peakFrequency});
legend(['voie ',num2str(v)],['voie ',num2str(v2)]);xlabel('Amplitude');ylabel('Frequency');
title(['voie ',num2str(v),' vs. ',num2str(v2)])
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure('color',[1 1 1]);PlotDistribution2({data1.duration data2.duration},{data1.peakFrequency data2.peakFrequency});
legend(['voie ',num2str(v)],['voie ',num2str(v2)]);xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});
title(['voie ',num2str(v),' vs. ',num2str(v2)])

end

%----------------------------------------
%----------------------------------------
%----------------------------------------

ripples(:,1:3)=ripples(:,1:3)+rgFil(1);

M1=PlotRipRaw(LFP{v},ripples,dur);title(['Voie LFP ',num2str(v)])
    subplot(1,2,1), ylabel(['Ripples channel ', num2str(v), ', detected channel ', num2str(v)]) 
    
M2=PlotRipRaw(LFP{v2},ripples,dur);title(['Voie LFP ',num2str(v2)])
    subplot(1,2,1), ylabel(['Ripples channel ', num2str(v2), ', detected channel ', num2str(v)]) 

%----------------------------------------
%----------------------------------------

 ripEvt=intervalSet((ripples(:,2)+rgFil(1)-0.1)*1E4,(ripples(:,2)+rgFil(1)+0.1)*1E4);    




% 
% 
% rg2=Range((Restrict(LFP{v},Epoch)),'s');
% 
% Ripp=[rg2-rg2(1) Data(Restrict(LFP{v},Epoch))];
% [r,i] = Sync(Ripp,ripples(:,2),'durations',durations);
% Ripples = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);
% 
% 
% 
% figure('Color',[1 1 1])
% subplot(1,2,1), hold on
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),Ripples,'k');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples),'r','linewidth',2);
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)+std(Ripples),'r--');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)-std(Ripples),'r--');
% title(['Voie LFP ',num2str(v)])
% subplot(1,2,2), hold on
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),zscore(Ripples')','k');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')'),'r','linewidth',2);
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')+std(zscore(Ripples')'),'r--');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')-std(zscore(Ripples')'),'r--');
% title(['zscore, voie LFP ',num2str(v)])
% 
% 
% 
%     
% rg3=Range(Restrict(LFP{v2},Epoch),'s');
% 
% Ripp2=[rg3-rg3(1) Data(Restrict(LFP{v2},Epoch))];
% [r2,i2] = Sync(Ripp2,ripples(:,2),'durations',durations);
% Ripples2 = SyncMap(r2,i2,'durations',durations,'nbins',nBins,'smooth',0);
% 
% 
% figure('Color',[1 1 1])
% subplot(1,2,1), hold on
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),Ripples2,'k');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples2),'r','linewidth',2);
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples2)+std(Ripples2),'r--');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples2)-std(Ripples2),'r--');
% title(['Voie LFP ',num2str(v2)])
% subplot(1,2,2), hold on
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),zscore(Ripples2')','k');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples2')'),'r','linewidth',2);
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples2')')+std(zscore(Ripples2')'),'r--');
% plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples2')')-std(zscore(Ripples2')'),'r--');
% title(['zscore, voie LFP ',num2str(v2)])



%----------------------------------------
%----------------------------------------
%----------------------------------------



%---------------------------------------------------------------------------------------------------------------
