
%ExploRipples
% 
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

listGoodLFP=[2 3 4 5 7 8 11 12 13 14 15 16];

figure('Color',[1 1 1]),hold on
for numLFP=listGoodLFP
% for numLFP=3:16    
plot(Range(LFP{numLFP},'s'),numLFP*1E4+Data(LFP{numLFP}))
end


xlim([0 10])

numLFP=15;
plot(Range(LFP{numLFP},'s'),numLFP*1E4+Data(LFP{numLFP}),'r')

%FilRip=FilterLFP(LFP{numLFP},[130 200],96);
pause(2)

Epoch1=intervalSet(0 ,600*1E4);
Epoch2=intervalSet(600*1E4,1900*1E4);
rg=Range(LFP{numLFP});
Epoch3=intervalSet(rg(1),rg(end));

Epoch=Epoch3;

FilRip=FilterLFP(Restrict(LFP{numLFP},Epoch),[130 200],96);

filtered=[Range(FilRip,'s') Data(FilRip)];
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[4 7]);
[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)
ripEvt=intervalSet((ripples(:,2)-0.1)*1E4,(ripples(:,2)+0.1)*1E4);

figure('Color',[1 1 1]),
for k=1:length(Start(ripEvt))
clf
hold on, plot(Range(Restrict(FilRip,subset(ripEvt,k)),'ms'),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
plot(Range(Restrict(LFP{numLFP},subset(ripEvt,k)),'ms'),Data(Restrict(LFP{numLFP},subset(ripEvt,k))),'k','linewidth',3)

title(num2str(k))
pause(1)
end



k=6;

figure('Color',[1 1 1]),

hold on, plot(Range(Restrict(FilRip,subset(ripEvt,k)),'ms'),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
title(num2str(k))
plot(Range(Restrict(LFP{numLFP},subset(ripEvt,k)),'ms'),Data(Restrict(LFP{numLFP},subset(ripEvt,k))),'k','linewidth',3)

if 0
saveFigure(4,'exempleRipples4','/media/DISK_1/Data/ICSS-Sleep/Mouse007/files.mat')
end


