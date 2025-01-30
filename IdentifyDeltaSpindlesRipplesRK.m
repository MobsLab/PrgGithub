function [tDeltaT2,tDeltaP2,spiPeaks,ripts]=IdentifyDeltaSpindlesRipplesRK(LFP,ch,ch2,th,plo)



try
    plo;
catch
    plo=0;
end


if length(ch2)==0
    
    ch2=0;
end
  
if length(th)==0
    
    th=1500;
end

        EEGsleep=LFP{ch};
        
        
if ch2
    EEGsleepD=tsd(Range(LFP{ch}),Data(LFP{ch})-Data(LFP{ch2}));
else
    EEGsleepD=LFP{ch};
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%lfp=CleanLFP(EEGsleep,[-2500 2500]);

badEpoch1=thresholdIntervals(EEGsleep,th,'Direction','Above');
badEpoch2=thresholdIntervals(EEGsleep,-th,'Direction','Below');

badEpoch=or(badEpoch1,badEpoch2);
badEpoch=dropShortIntervals(badEpoch,0.01E4);
badEpoch=mergeCloseIntervals(badEpoch,4E4);
badEpoch=dropShortIntervals(badEpoch,4E4);

rg=Range(EEGsleep);
Epoch=intervalSet(rg(1),rg(end));
deb=rg(1);
goodEpoch=Epoch-badEpoch;



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

thspindles1=3;
thspindles2=1.5;

clear spiPeaks
spiPeaks=[];

for i=1:length(Start(goodEpoch))
    try
    lfp=Restrict(EEGsleep,subset(goodEpoch,i));
% [spiStarts, spiEnds, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);

% length(Range(spiPeakstemp))
spiPeaks=[spiPeaks; Range(spiPeakstemp)];
    end
end
spiPeaks=ts(sort(spiPeaks));

try
det=Range(spiPeaks,'s')-movingwin(1)/2;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


thD=2; %2.5


clear tDelta
tDeltaP=[];
tDeltaT=[];
for i=1:length(Start(goodEpoch))
    try
lfp=Restrict(EEGsleepD,subset(goodEpoch,i));

Filt_EEGd = FilterLFP(lfp, [1 5], 1024);

eegd=Data(Filt_EEGd)';
td=Range(Filt_EEGd,'s')';

 de = diff(eegd);
  de1 = [de 0];
  de2 = [0 de];
  
  
  %finding peaks
  upPeaksIdx = find(de1 < 0 & de2 > 0);
  downPeaksIdx = find(de1 > 0 & de2 < 0);
  
  PeaksIdx = [upPeaksIdx downPeaksIdx];
  PeaksIdx = sort(PeaksIdx);
  
  Peaks = eegd(PeaksIdx);
%   Peaks = abs(Peaks);
  
 tDeltatemp=td(PeaksIdx);

  
DetectThresholdP=+mean(Data(Filt_EEGd))+thD*std(Data(Filt_EEGd));
DetectThresholdT=mean(Data(Filt_EEGd))-thD*std(Data(Filt_EEGd));

% length(tDeltatemp)

idsT=find((Peaks<DetectThresholdT));
idsP=find((Peaks>DetectThresholdP));

tDeltatempT=tDeltatemp(idsT);
tDeltatempP=tDeltatemp(idsP);

tDeltaT=[tDeltaT,tDeltatempT];
tDeltaP=[tDeltaP,tDeltatempP];
    end
end



tDeltaT=ts(sort(tDeltaT)*1E4);
tDeltaP=ts(sort(tDeltaP)*1E4);


tdeltaT=Range(tDeltaT);
tdeltaP=Range(tDeltaP);



idd=find(tdeltaT+1E4<rg(end)&tdeltaT-1E4>0);
tDeltaT2=tdeltaT(idd);
tDeltaT2=ts(tDeltaT2);


idd=find(tdeltaP+1E4<rg(end)&tdeltaP-1E4>0);
tDeltaP2=tdeltaP(idd);
tDeltaP2=ts(tDeltaP2);





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%paramRip=[3 5];

paramRip=[5 7];

samplingRate = 1250;

dur=200;
dur=30;
durations = [-dur dur]/1000;

nBins = floor(samplingRate*diff(durations)/2)*2+1;


try
    vnoise;
    
catch
    vnoise=0;
end


%----------------------------------------
%----------------------------------------
%Find Ripples
%----------------------------------------
%----------------------------------------


if ch2>0
FilRip=FilterLFP(Restrict(LFP{ch2},Epoch),[130 200],96);

else
    
    FilRip=FilterLFP(Restrict(LFP{ch},Epoch),[130 200],96);
end
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];



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

        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);    

end



%----------------------------------------
%----------------------------------------
%----------------------------------------


[maps,data,stats] = RippleStats(filtered,ripples);
if plo
PlotRippleStats(ripples,maps,data,stats);
end
 ripEvt=intervalSet((ripples(:,2)+rgFil(1)-0.1)*1E4,(ripples(:,2)+rgFil(1)+0.1)*1E4);

 
 
%----------------------------------------
%----------------------------------------
%----------------------------------------

ripples(:,1:3)=ripples(:,1:3)+rgFil(1);


ripts=ts(ripples(:,2)*1E4);

% M1=PlotRipRaw(LFP{ch},ripples,dur);title(['Voie LFP ',num2str(ch)])    
% M2=PlotRipRaw(LFP{ch2},ripples,dur);title(['Voie LFP ',num2str(ch2)])



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------




if plo



figure('color',[1 1 1]), 

% figure(2), clf

subplot(5,1,1), hold on
tbins=4;nbbins=300;
for i=1:length(LFP)
[ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
if i==ch
    plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
else
plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
end

end
%i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaT2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')




subplot(5,1,2), hold on
tbins=4;nbbins=300;
for i=1:length(LFP)
[ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
if i==ch
    plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
else
plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
end
end
% i=5; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins); plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma,sa,tpsa]=mETAverage(Range(tDeltaP2), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')


subplot(5,1,3), hold on
tbins=4;nbbins=300;
for i=1:length(LFP)
[ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
if i==ch
    plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
else
plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
end
end

% i=5; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
% i=10; [ma,sa,tpsa]=mETAverage(Range(spiPeaks), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);plot(tpsa,smooth(ma,3),'color',[i/15 0 (15-i)/15],'linewidth',2)
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','k')

xlim([-250 250])







subplot(5,1,4), hold on

tbins=4;nbbins=300;
for i=1:length(LFP)
[ma,sa,tpsa]=mETAverage(Range(ripts), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
if i==ch
    plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
else
plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
end
end


    subplot(4,1,4), ylabel(['Ripples detected channel ', num2str(ch)]) 

    

    xlim([-250 250])   
    

    subplot(5,1,5), hold on

tbins=1;nbbins=300;
for i=1:length(LFP)
[ma,sa,tpsa]=mETAverage(Range(ripts), Range(LFP{i}),Data(LFP{i}),tbins,nbbins);
if i==ch
    plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)],'linewidth',2)
else
plot(tpsa,smooth(ma,3),'color',[i/length(LFP) 0 (length(LFP)-i)/length(LFP)])
end
end


    subplot(5,1,5), ylabel(['Ripples detected channel ', num2str(ch)]) 

    

    xlim([-40 40])   
    
    
    

set(gcf, 'position', [912 -15 548 946])

end
