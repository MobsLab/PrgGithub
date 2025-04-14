function [tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFP,num,Spi,Filt_EEGd,params)

plo=1;
smo=2;

try
    num(2);
catch
    if num(1)+1<=length(LFP)
    num(2)=num+1;
    else
    num(2)=num-1;  
    end
    
end

lfp=LFP{num(1)};
SpiEpoch=intervalSet(Spi(:,1)*1E4,Spi(:,3)*1E4);
try
    Filt_EEGd;
catch
    Filt_EEGd = FilterLFP(lfp, [4 20], 1024);
end

try
    params;
catch
params.tapers=[3 5];
params.Fs=1250;
params.fpass=[0 35];
end

tPeaksT=[];
peakValue=[];
peakMeanValue=[];
zeroCrossT=[];
zeroMeanValue=[];
ST=[];
    
for i=1:length(Start(SpiEpoch))

    eegd=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)))';
    td=Range(Restrict(Filt_EEGd,subset(SpiEpoch,i)),'s')';

    de = diff(eegd);
    de1 = [de 0];
    de2 = [0 de]; 
    %finding peaks
    upPeaksIdx = find(de1 < 0 & de2 > 0);
    downPeaksIdx = find(de1 > 0 & de2 < 0); 
    PeaksIdx = [upPeaksIdx downPeaksIdx];
    PeaksIdx = sort(PeaksIdx);
    Peaks = eegd(PeaksIdx);
    tPeaks=td(PeaksIdx);
    peakMeanValuetemp=mean([eegd(PeaksIdx-1);eegd(PeaksIdx);eegd(PeaksIdx+1)]);
    tPeaksT=[tPeaksT,tPeaks];
    peakValue=[peakValue,Peaks];
    peakMeanValue=[peakMeanValue,peakMeanValuetemp];
   
       
    eegdplus1=[0 eegd];
    eegdplus0=[eegd 0];
    zeroCross1=find(eegdplus0<0 & eegdplus1>0);
    zeroCross2=find(eegdplus0>0 & eegdplus1<0);    
    zeroCrossIdx = [zeroCross1 zeroCross2];
    zeroCrossIdx = sort(zeroCrossIdx);
    zeroCross=td(zeroCrossIdx);
    zeroCrossT=[zeroCrossT,zeroCross];
    
    for ii=2:length(zeroCrossIdx)-1
%         try
       zeroMeanValuetemp(ii)=max(abs(eegd(zeroCrossIdx(ii-1):zeroCrossIdx(ii+1)))); 
%         end

    end
    zeroMeanValuetemp(length(zeroCrossIdx))=zeroMeanValuetemp(length(zeroCrossIdx)-1);
    zeroMeanValuetemp(1)=zeroMeanValuetemp(2);
    zeroMeanValue=[zeroMeanValue,zeroMeanValuetemp];
    clear zeroMeanValuetemp

    datatemp=Data(Restrict(lfp,subset(SpiEpoch,i)));
    datatemp=datatemp-mean(datatemp);
    datatemp2=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)));
    reliab(i)=floor(sqrt(sum(abs(datatemp.^2-datatemp2.^2)))/length(datatemp)); 
    
    [S,f]=mtspectrumc(datatemp,params);
%     [BE,id]=max(smooth(S(find(f>3.5):end),smo));
%     ftemp=f(find(f>3.5):end);
%     fmax=ftemp(id);
    freq=[0:0.5:38];
    Stsd=tsd(f,S);
    Sh=Restrict(Stsd,freq);
    ST=[ST;Data(Sh)']; 
    
    [BE,id]=max(smooth(S(find(f>3.5&f<25):end),smo));
    ftemp=f(find(f>3.5&f<25):end);
    fmax=ftemp(id);
    
    Stemp=smooth(S/max(S)*10,smo);
    Stemp=Stemp(find(f>3.5&f<25));
    de = diff(Stemp)';
    de1 = [de 0];
    de2 = [0 de]; 
    upPeaksIdx = find(de1 < 0 & de2 > 0);
    [BE,id]=max(Stemp(upPeaksIdx));
    fpeaks=ftemp(upPeaksIdx(id));
    
    if length(fpeaks)>0
    fmax=fpeaks;
    end
    
    tPeakstemp=tPeaksT(find(tPeaksT>Start(subset(SpiEpoch,i),'s') & tPeaksT<End(subset(SpiEpoch,i),'s')));
    zeroCrosstemp=zeroCrossT(find(zeroCrossT>Start(subset(SpiEpoch,i),'s') & zeroCrossT<End(subset(SpiEpoch,i),'s')));
    
    h1=hist(1./(diff(tPeakstemp)*2),freq);
    h2=hist(1./(diff(zeroCrosstemp)*2),freq);  
    [BE,id]=max(smooth(h1,smo));
    fmax2=freq(id);
    [BE,id]=max(smooth(h2,smo));
    fmax3=freq(id);
    
    Bilan(i,1)=reliab(i);
    Bilan(i,2)=fmax;
    Bilan(i,3)=fmax2; 
    Bilan(i,4)=fmax3;
    
    clear tPeaks
    clear Peaks
    clear zeroCross
end
  
zeroCrossT = sort(zeroCrossT);

%tPeaksT=sort(tPeaksT);
figure('color',[1 1 1]),
subplot(2,2,1),hist(1./(diff(tPeaksT)*2),freq),xlim([1 35])
subplot(2,2,3),hist(1./(diff(zeroCrossT)*2),freq),xlim([1 35])

subplot(2,2,2)
plot(1./(1./diff(tPeaksT*2)),abs(diff(peakValue)),'k.')
xlim([1 35])
subplot(2,2,4)
hist(reliab,100)



if plo
    i=1;
    figure('color',[1 1 1]), hold on
    
    i=i+1; clf, subplot(1,4,1:3), hold on
    plot(Range(Restrict(LFP{num(1)},subset(SpiEpoch,i)),'s'),Data(Restrict(LFP{num(1)},subset(SpiEpoch,i))))
        try
            plot(Range(Restrict(LFP{num(1)+1},subset(SpiEpoch,i)),'s'),Data(Restrict(LFP{num(1)+1},subset(SpiEpoch,i)))-4000,'k')
        end
        try
            plot(Range(Restrict(LFP{num(1)-1},subset(SpiEpoch,i)),'s'),Data(Restrict(LFP{num(1)-1},subset(SpiEpoch,i)))-4500,'k')
        end
    plot(Range(Restrict(Filt_EEGd,subset(SpiEpoch,i)),'s'),Data(Restrict(Filt_EEGd,subset(SpiEpoch,i))),'r')
    hold on, plot(tPeaksT,500+zeros(length(tPeaksT),1),'ko','markerfacecolor','r')
    hold on, plot(zeroCrossT,zeros(length(zeroCrossT),1),'ko','markerfacecolor','k')    
    xlim([Start(subset(SpiEpoch,i),'s') End(subset(SpiEpoch,i),'s')])
    title(['spectrum: ',num2str(floor(Bilan(i,2))),',   derivate: ',num2str(Bilan(i,3)),',   zero corss: ',num2str(Bilan(i,4))])
    
    tPeakstemp=tPeaksT(find(tPeaksT>Start(subset(SpiEpoch,i),'s') & tPeaksT<End(subset(SpiEpoch,i),'s')));
    zeroCrosstemp=zeroCrossT(find(zeroCrossT>Start(subset(SpiEpoch,i),'s') & zeroCrossT<End(subset(SpiEpoch,i),'s')));
    h1=hist(1./(diff(tPeakstemp)*2),[0:1:38]);
    h2=hist(1./(diff(zeroCrosstemp)*2),[0:1:38]);    
    
    subplot(1,4,4),hold on
    bar([0:1:38],h2,1,'k')
    plot([0:1:38],h1,'r','linewidth',2)
    xlim([1 35])
    
    datatemp=Data(Restrict(LFP{num(1)},subset(SpiEpoch,i)));
    datatemp2=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)));
    title(num2str(floor(100*reliab(i)/mean(reliab))))
    [S,f]=mtspectrumc(datatemp,params);
    
    subplot(1,4,4),plot(f,10*S/max(S),'b','linewidth',2),xlim([1 35])
    
end

keyboard
