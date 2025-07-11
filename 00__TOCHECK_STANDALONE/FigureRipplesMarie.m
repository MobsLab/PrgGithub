
function [rTot,sTot,Pbrs,Pbsr,effecta,pa,effectf,pf,effectd,pd,matValsr,matValsnr,matValrs,matValrns]=FigureRipplesMarie(del,paramRip)

corr=-700;
limInf=2;
limSup=3;

try
    cd /media/DISK_1/Data1/ICSS-Sleep/Mouse017/20110622/ICSS-Mouse-17-22062011

catch
    
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/Mouse017/20110622
    
end


load SpikeData
load behavResources
load LFPData
 
delaiperiodripples=del*1E-3; % +/-50ms
try
    paramRip;
catch
    paramRip=[3 5];
end


Epoch=intervalSet(tpsEvt{17}*1E4,tpsEvt{31}*1E4);
st=Restrict(stim,Epoch);
l1=Restrict(LFP{1},Epoch);
l2=Restrict(LFP{2},Epoch);
lNoise=Restrict(LFP{3},Epoch);

% raw=tsd(data(:,1),data(:,2));
% ii=thresholdIntervals(raw,-10,'Direction','Above');
% spikes=Start(ii);
% spk=tsd(spikes,spikes);
% clear raw

Vm=[Range(l2) Data(l2)];
data=[Range(l2) Data(l2)];
rg=Range(st);

h = waitbar(0,'Please wait...');



for i=1:length(st)
    idx=find(data(:,1)>rg(i));
    ix(i)=idx(1);
    if ix(i)+limSup<length(data)&ix(i)-limInf>1
            Vm(ix(i)-limInf:ix(i)+3,:)=RemoveSpike(data(ix(i)-limInf:ix(i)+limSup,:));
    elseif ix(i)+limSup<length(data)&ix(i)-limInf<1
            Vm(1:ix(i)+limSup,:)=RemoveSpike(data(1:ix(i)+limSup,:));
    elseif ix(i)+limSup>length(data)
            Vm(ix(i)-limInf:end,:)=RemoveSpike(data(ix(i)-limInf:end,:));
    end
    waitbar(i/length(st),h)
end

close (h)

l2pre=l2;
l2=tsd(Vm(:,1),Vm(:,2));

FilRip=FilterLFP(l2,[130 200],96);
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];

FilRipPre=FilterLFP(l2pre,[130 200],96);
rgFilPre=Range(FilRipPre,'s');
filteredPre=[rgFilPre-rgFilPre(1) Data(FilRipPre)];

FilRipNoise=FilterLFP(lNoise,[130 200],96);
rgFilNoise=Range(FilRipNoise,'s');
filteredNoise=[rgFilNoise-rgFilNoise(1) Data(FilRipNoise)];

%[ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'noise',filteredNoise);
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);

%-------------------------------------------------------------------------
%pb-----------------------------------------------------------------------
%-------------------------------------------------------------------------

goodEpoch1=thresholdIntervals(l2,2*1E4,'Direction','Below');
goodEpoch2=thresholdIntervals(l2,-2*1E4,'Direction','Above');
goodEpoch=and(goodEpoch1,goodEpoch2);
%goodEpoch=mergeCloseIntervals(goodEpoch,100);
goodEpoch=dropShortIntervals(goodEpoch,1E3);

% l1=Restrict(l1,goodEpoch);
% l2=Restrict(l2,goodEpoch);
% l2pre=Restrict(l2pre,goodEpoch);
% lNoise=Restrict(lNoise,goodEpoch);
% st=Restrict(st,goodEpoch);

Ripples=tsd((ripples(:,2)+rgFil(1)-0.06)*1E4,ripples);
Ripples=Restrict(Ripples,goodEpoch);
ripples=Data(Ripples);

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


ripEvt=intervalSet((ripples(:,2)+rgFil(1)-delaiperiodripples)*1E4,(ripples(:,2)+rgFil(1)+delaiperiodripples)*1E4);
NoripEvt=Epoch-ripEvt;



riptps=(ripples(:,2)+rgFil(1))*1E4;

RipStim=[];
RipNoStim=[];
idxStim=[];
idxNoStim=[];

for i=1:length(riptps)
    subRipEvt=subset(ripEvt,i);
    if length(Range(Restrict(st,subRipEvt)))>0
        RipStim=[RipStim,Start(subRipEvt)+delaiperiodripples*1E4];
        idxStim=[idxStim,i];
    else
        RipNoStim=[RipNoStim,Start(subRipEvt)+delaiperiodripples*1E4];
        idxNoStim=[idxNoStim,i];
    end
end

%-------------------------------------------------------------------------
%pb-----------------------------------------------------------------------
%-------------------------------------------------------------------------

% try
% RipNoStim=RipNoStim(1:end-8);
% idxNoStim=idxNoStim(1:end-8);
% end

%-------------------------------------------------------------------------

StimRip=Range(Restrict(st,ripEvt));
StimNoRip=Range(Restrict(st,NoripEvt));

ripStimEvt=intervalSet((ripples(idxStim,2)+rgFil(1)-delaiperiodripples)*1E4,(ripples(idxStim,2)+rgFil(1)+delaiperiodripples)*1E4);
ripNostimEvt=Epoch-ripStimEvt;


if 0
    
figure('Color',[1 1 1]),
    num=gcf;
    for k=1:2:length(Start(ripEvt))
        
        figure(num), clf
        subplot(2,1,1),
        rgg1=Range(Restrict(FilRip,subset(ripEvt,k)),'s');
        hold on, plot(rgg1-rgg1(1),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
        rgg2=Range(Restrict(l2,subset(ripEvt,k)),'s');
        plot(rgg2-rgg2(1),Data(Restrict(l2,subset(ripEvt,k))),'k','linewidth',3)
%	ca=caxis;
%	xl=xlim;
%	yl=ylim;
%	line([Range(Restrict(stim,Epoch))-rgg1(1)-rgFil(1) Range(Restrict(stim,Epoch))-rgg1(1)-rgFil(1)], yl,'color','k')
%	xlim(xl)
if ismember(k,idxStim)
    ti='stim';
else
    ti='no stim';
end
        title([num2str(k),' ',ti])

        subplot(2,1,2),
        rgg3=Range(Restrict(FilRipPre,subset(ripEvt,k)),'s');
        hold on, plot(rgg3-rgg3(1),5*Data(Restrict(FilRipPre,subset(ripEvt,k))),'b','linewidth',2)
        rgg4=Range(Restrict(l2pre,subset(ripEvt,k)),'s');
        plot(rgg4-rgg4(1),Data(Restrict(l2pre,subset(ripEvt,k))),'k','linewidth',3)
        
        pause(1)

        
%    	ca=caxis;
%	xl=xlim;
%	yl=ylim;
%	line([Range(Restrict(stim,Epoch))-rgg3(1)-rgFil(1) Range(Restrict(stim,Epoch))-rgg3(1)-rgFil(1)], yl,'color','k')
%	xlim(xl)
        
    %ripStim(k)=input('No Ripples (0), Ripples sans stim (1), ou avec Stim (2) : ');
        
    end
    
end


%-------------------------------------------------------------------------

PlotRipRaw(l2pre,ripples(idxStim,:))
PlotRipRaw(l2,ripples(idxStim,:))
PlotRipRaw(l1,ripples(idxStim,:))
PlotRipRaw(l2,ripples(idxNoStim,:))
PlotRipRaw(l1,ripples(idxNoStim,:))

figure, [fh, rasterAx, histAx, matValrs] = ImagePETH(l2, ts(RipStim), -1500, +1500,'BinSize',1); title('Ripples with stimulation')
figure, [fh, rasterAx, histAx, matValrns] = ImagePETH(l2, ts(RipNoStim), -1500, +1500,'BinSize',1);title('Ripples without stimulation')

figure, [fh, rasterAx, histAx, matVals] = ImagePETH(l2, ts(Range(st)), -1500, +1500,'BinSize',1);title('Stimulation')

figure, [fh, rasterAx, histAx, matValsr] = ImagePETH(l2, ts(StimRip), -1500, +1500,'BinSize',1);title('Stimulation with ripples')
figure, [fh, rasterAx, histAx, matValsnr] = ImagePETH(l2, ts(StimNoRip), -1500, +1500,'BinSize',1);title('Stimulation without ripples')


% 
% figure('color',[1 1 1]),hold on
% plot(Range(matValr,'ms'),mean(Data(matValr)'),'k','linewidth',2)
% plot(Range(matValr,'ms'),mean(Data(matValr)')+stdError(Data(matValr)'),'k','linewidth',1)
% plot(Range(matValr,'ms'),mean(Data(matValr)')-stdError(Data(matValr)'),'k','linewidth',1)
% title('ripples')
% 
% 
% 
% figure('color',[1 1 1]),hold on
% plot(Range(matVals,'ms'),mean(Data(matVals)'),'r','linewidth',2)
% plot(Range(matVals,'ms'),mean(Data(matVals)')+stdError(Data(matVals)'),'r','linewidth',1)
% plot(Range(matVals,'ms'),mean(Data(matVals)')-stdError(Data(matVals)'),'r','linewidth',1)
% title('stimulation during ripples')


figure('color',[1 1 1]),hold on
plot(Range(matValsr,'ms'),mean(Data(matValsr)'),'r','linewidth',2)
plot(Range(matValsr,'ms'),mean(Data(matValsr)')+stdError(Data(matValsr)'),'r','linewidth',1)
plot(Range(matValsr,'ms'),mean(Data(matValsr)')-stdError(Data(matValsr)'),'r','linewidth',1)
plot(Range(matValsnr,'ms'),mean(Data(matValsnr)'),'k','linewidth',2)
plot(Range(matValsnr,'ms'),mean(Data(matValsnr)')+stdError(Data(matValsnr)'),'k','linewidth',1)
plot(Range(matValsnr,'ms'),mean(Data(matValsnr)')-stdError(Data(matValsnr)'),'k','linewidth',1)
title('stimulation inside (red) and outside ripples (black)')

figure('color',[1 1 1]),hold on
plot(Range(matValrs,'ms'),mean(Data(matValrs)'),'r','linewidth',2)
plot(Range(matValrs,'ms'),mean(Data(matValrs)')+stdError(Data(matValrs)'),'r','linewidth',1)
plot(Range(matValrs,'ms'),mean(Data(matValrs)')-stdError(Data(matValrs)'),'r','linewidth',1)
plot(Range(matValrns,'ms'),mean(Data(matValrns)'),'k','linewidth',2)
plot(Range(matValrns,'ms'),mean(Data(matValrns)')+stdError(Data(matValrns)'),'k','linewidth',1)
plot(Range(matValrns,'ms'),mean(Data(matValrns)')-stdError(Data(matValrns)'),'k','linewidth',1)
title('ripples with (red) and without stimulation (black)')


figure('color',[1 1 1]),hold on
plot(Range(matValrs,'ms'),corr+mean(Data(matValrs)'),'r','linewidth',2)
plot(Range(matValrs,'ms'),corr+mean(Data(matValrs)')+stdError(Data(matValrs)'),'r','linewidth',1)
plot(Range(matValrs,'ms'),corr+mean(Data(matValrs)')-stdError(Data(matValrs)'),'r','linewidth',1)
plot(Range(matValrns,'ms'),mean(Data(matValrns)'),'k','linewidth',2)
plot(Range(matValrns,'ms'),mean(Data(matValrns)')+stdError(Data(matValrns)'),'k','linewidth',1)
plot(Range(matValrns,'ms'),mean(Data(matValrns)')-stdError(Data(matValrns)'),'k','linewidth',1)
title('ripples with (red) and without stimulation (black)')
xlim([-100 150])

[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)

[maps1,data1,stats1] = RippleStats(filtered,ripples(idxStim,:));
PlotRippleStats(ripples(idxStim,:),maps1,data1,stats1)

[maps2,data2,stats2] = RippleStats(filtered,ripples(idxNoStim,:));
PlotRippleStats(ripples(idxNoStim,:),maps2,data2,stats2)

close
close
close
close
close
close

% Pre-post comparison
figure;PlotDistribution2({data1.peakAmplitude data2.peakAmplitude},{data1.peakFrequency data2.peakFrequency});
legend('With Stimulation','Without Stimulation');xlabel('Amplitude');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data1.duration data2.duration},{data1.peakFrequency data2.peakFrequency});
legend('With Stimulation','Without Stimulation');xlabel('Duration');ylabel('Frequency');
%DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});



lsr=length(StimRip);
lsnr=length(StimNoRip);


lrs=length(RipStim);
lrns=length(RipNoStim);

rTot=lrs+lrns;
sTot=lsr+lsnr;

Pbrs=lrs/rTot*100;
Pbsr=lsr/sTot*100;
disp(['Number of ripples ',num2str(rTot)])
disp(['Percentage of ripples with stimulation ',num2str(lrs/rTot*100),'%'])
disp(' ')
disp(['Number of stimulation ',num2str(sTot)])
disp(['Percentage of stimulation inside ripples ',num2str(lsr/sTot*100),'%'])


[h,pa]=ttest2(data1.peakAmplitude,data2.peakAmplitude);
effecta=(mean(data1.peakAmplitude)-mean(data2.peakAmplitude))/mean(data2.peakAmplitude)*100;
effecta=floor(effecta*100)/100;
PlotErrorBar2(data1.peakAmplitude,data2.peakAmplitude);title(['Ripples Amplitude, effect =',num2str(effecta),'%, p=',num2str(pa)])

[h,pf]=ttest2(data1.peakFrequency,data2.peakFrequency);
effectf=(mean(data1.peakFrequency)-mean(data2.peakFrequency))/mean(data2.peakFrequency)*100;
effectf=floor(effectf*100)/100;
PlotErrorBar2(data1.peakFrequency,data2.peakFrequency);title(['Ripples Frequency, effect =',num2str(effectf),'%, p=',num2str(pf)])


[h,pd]=ttest2(data1.duration,data2.duration);
effectd=(mean(data1.duration)-mean(data2.duration))/mean(data2.duration)*100;
effectd=floor(effectd*100)/100;
PlotErrorBar2(data1.duration,data2.duration);title(['Ripples Duration, effect =',num2str(effectd),'% , p=',num2str(pd)])

keyboard




