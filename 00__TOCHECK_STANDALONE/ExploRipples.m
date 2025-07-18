
%ExploRipples
% 
try
    LoadD;
catch
    LoadD=1;
end

if LoadD
load LFPData
end


anadetail=1;

LowThRip=4;
HighThRip=7;


%debPeriodRip=0;
%finPeriodRip=100;

ComputNoise=1; 

%------------------------------------------------------------------
%------------------------------------------------------------------

try
    voieLFP;
    
catch
    voieLFP=3;

end

try
    voieNoise;
    
catch
    voieNoise=4;

end


try 
    voieLFP2;
catch
    voieLFP2=4;
    
end


if length(LFP)==4
    listGoodLFP=[1,2,3,4];
else
listGoodLFP=[2 3 4 5 7 8 11 12 13 14 15 16];
listGoodLFP=[1:length(LFP)];
end


%------------------------------------------------------------------
%------------------------------------------------------------------




figure('Color',[1 1 1]),hold on
for i=listGoodLFP
% for voieLFP=3:16    
plot(Range(LFP{i},'s'),i*1E4+Data(LFP{i}))
end


xlim([0 10])


plot(Range(LFP{voieLFP},'s'),voieLFP*1E4+Data(LFP{voieLFP}),'r')
try
    plot(Range(LFP{voieLFP2},'s'),voieCompLFP*1E4+Data(LFP{voieLFP2}),'g')
end

%FilRip=FilterLFP(LFP{voieLFP},[130 200],96);
pause(2)

Epoch1=intervalSet(0 ,600*1E4);
Epoch2=intervalSet(600*1E4,1900*1E4);
rg=Range(LFP{voieLFP});
Epoch3=intervalSet(rg(1),rg(end));

Epoch=Epoch3;


%----------------------------------------
%----------------------------------------
%Find Ripples
%----------------------------------------
%----------------------------------------



FilRip=FilterLFP(Restrict(LFP{voieLFP},Epoch),[130 200],96);
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];


try
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip],'restrict',[debPeriodRip finPeriodRip]);
catch
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip]);    
end



%----------------------------------------

if ComputNoise
    
        NoiseRip=FilterLFP(LFP{voieNoise},[130 200],96);
        rgNoise=Range(NoiseRip,'s');
        filteredNoise=[rgNoise-rgNoise(1) Data(NoiseRip)];
        
        FilTsd=tsd(filtered(:,1),filtered(:,2));
        FilNoiseTsd=tsd(filteredNoise(:,1),filteredNoise(:,2));
        
        FilNoiseTsd=Restrict(FilNoiseTsd,FilTsd);
        
        filteredNoise2(:,1)=Range(FilNoiseTsd);
        filteredNoise2(:,2)=Data(FilNoiseTsd);
        
        filteredNoise=filteredNoise2;
        
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip],'noise',filteredNoise,'show','off');

else  
        try
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip],'restrict',[debPeriodRip finPeriodRip]);
        catch
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[LowThRip HighThRip]);    
        end

end



%----------------------------------------
%----------------------------------------
%----------------------------------------


[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)

ripEvt=intervalSet((ripples(:,2)-0.1)*1E4,(ripples(:,2)+0.1)*1E4);

%----------------------------------------
%----------------------------------------
%----------------------------------------






samplingRate = 1250;
durations = [-50 50]/1000;
nBins = floor(samplingRate*diff(durations)/2)*2+1;


rg2=Range((Restrict(LFP{voieLFP},Epoch)),'s');

Ripp=[rg2-rg2(1) Data(Restrict(LFP{voieLFP},Epoch))];
[r,i] = Sync(Ripp,ripples(:,2),'durations',durations);
Ripples = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);



figure('Color',[1 1 1])
subplot(1,2,1), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),Ripples,'k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)+std(Ripples),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)-std(Ripples),'r--');
title(['Voie LFP ',num2str(voieLFP)])
subplot(1,2,2), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),zscore(Ripples')','k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')'),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')+std(zscore(Ripples')'),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')-std(zscore(Ripples')'),'r--');
title(['Voie LFP (Neuroscope) ',num2str(voieLFP)])



try
    
    rg2=Range((Restrict(LFP{voieLFP2},Epoch)),'s');

Ripp=[rg2-rg2(1) Data(Restrict(LFP{voieLFP2},Epoch))];
[r,i] = Sync(Ripp,ripples(:,2),'durations',durations);
Ripples = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);



figure('Color',[1 1 1])
subplot(1,2,1), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),Ripples,'k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)+std(Ripples),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)-std(Ripples),'r--');
title(['Voie LFP ',num2str(voieLFP2)])
subplot(1,2,2), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),zscore(Ripples')','k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')'),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')+std(zscore(Ripples')'),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')-std(zscore(Ripples')'),'r--');
title(['Voie LFP (Neuroscope) ',num2str(voieLFP2)])

end


%----------------------------------------
%----------------------------------------
%----------------------------------------


%---------------------------------------------------------------------------------------------------------------


try
    voieCompLFP;
    
rg2=Range((Restrict(LFP{voieCompLFP},Epoch)),'s');

Ripp=[rg2-rg2(1) Data(Restrict(LFP{voieCompLFP},Epoch))];
[r,i] = Sync(Ripp,ripples(:,2),'durations',durations);
Ripples = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);



figure('Color',[1 1 1])
subplot(1,2,1), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),Ripples,'k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)+std(Ripples),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(Ripples)-std(Ripples),'r--');
title(['Voie LFP ',num2str(voieCompLFP)])
subplot(1,2,2), hold on
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),zscore(Ripples')','k');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')'),'r','linewidth',2);
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')+std(zscore(Ripples')'),'r--');
plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(zscore(Ripples')')-std(zscore(Ripples')'),'r--');
title(['Voie LFP (Neuroscope) ',num2str(voieCompLFP-1)])

end


%---------------------------------------------------------------------------------------------------------------








if anadetail

figure('Color',[1 1 1]),
num=gcf;
for k=1:length(Start(ripEvt))
figure(num),clf
hold on, plot(Range(Restrict(FilRip,subset(ripEvt,k)),'s'),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
plot(Range(Restrict(LFP{voieLFP},subset(ripEvt,k)),'s'),Data(Restrict(LFP{voieLFP},subset(ripEvt,k))),'k','linewidth',3)

title(num2str(k))
pause(1)
end

k=input('Quelle ripples ');

figure('Color',[1 1 1]),

hold on, plot(Range(Restrict(FilRip,subset(ripEvt,k)),'s'),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
title(num2str(k))
plot(Range(Restrict(LFP{voieLFP},subset(ripEvt,k)),'s'),Data(Restrict(LFP{voieLFP},subset(ripEvt,k))),'k','linewidth',3)

if 0
saveFigure(4,'exempleRipples4','/media/DISK_1/Data/ICSS-Sleep/Mouse007/files.mat')
end


end



% try
%     wav;
%     
% catch
%     
%     filename='Mouse007_16022011sleep11';
%     filename='Mouse007_16022011sleep10';
%     filename='Mouse007_02022011';
% 
%     [wav,Nwav,mVal,midm,dt,times]=loadSMR(filename,[19:24],27);
% 
% 
%     for i=1:length(Nwav)
%     lfp=resample(wav{i},1250,round(1/median(diff(times/1E4))));
%     tps=[1:length(lfp)]/1250;
%     LFP{i}=tsd(tps*1E4,lfp);
%     lfpnames{i}=floor(i/4)+1;
%     end
% 
% 
%     try
%     LFP=tsdArray(LFP);
%     end
% 
% end