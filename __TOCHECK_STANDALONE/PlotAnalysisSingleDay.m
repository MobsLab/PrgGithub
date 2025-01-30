function PlotAnalysisSingleDay(R,D,i,structure,num)

delai=1;
smo=3;

try
    num;
catch
    try
    num=R{49};              %36
    catch
      num=[2,2];  
    end

end


tPeaksT=R{28};        %25
peakValue=R{29};      %26
zeroCrossT=R{30};     %27
reliab=R{31};         %28
Bilan=R{32};          %29
ST=R{33};               %30
freq=R{34};             %31
Filt_EEGd=D{1};        %32
LFPp=D{2};             %33
LFPh=D{3};             %34
Spi=R{47};              %35
Rip=R{48};              %36

%     a=a+1; R{a}=Epoch1;           %1 
%     a=a+1; R{a}=DurEpoch1;        %2
%     a=a+1; R{a}=MeanDurEpoch1;    %3
%     a=a+1; R{a}=Epoch2;           %4
%     a=a+1; R{a}=DurEpoch2;        %5
%     a=a+1; R{a}=MeanDurEpoch2;    %6
%     a=a+1; R{a}=Epoch1rem;        %7
%     a=a+1; R{a}=DurEpoch1rem;     %8
%     a=a+1; R{a}=MeanDurEpoch1rem; %9
%     a=a+1; R{a}=Epoch2rem;        %10
%     a=a+1; R{a}=DurEpoch2rem;     %11
%     a=a+1; R{a}=MeanDurEpoch2rem; %12
%     a=a+1; R{a}=sum(End(EpochT1,'s')-Start(EpochT1,'s'));  %13
%     a=a+1; R{a}=sum(End(EpochT2,'s')-Start(EpochT2,'s'));  %14 
%     a=a+1; R{a}=tdelayRemRecording; %15
%     a=a+1; R{a}=tdelayRem1;         %16 
%     a=a+1; R{a}=tdelayRem2;       %17
%     a=a+1; R{a}=befR;             %18
%     a=a+1; R{a}= aftR;            %19
%     a=a+1; R{a}= befS;           %20
%     a=a+1; R{a}=aftS;            %21
%     a=a+1; R{a}=C;;              %22
%     a=a+1; R{a}=B;;              %23
%     a=a+1; R{a}=C1;;             %24
%     a=a+1; R{a}=B1;;             %25
%     a=a+1; R{a}=C2;;             %26
%     a=a+1; R{a}=B2;;             %27
%     a=a+1; R{a}=tPeaksT;         %28
%     a=a+1; R{a}=peakValue;       %29
%     a=a+1; R{a}=peakMeanValue;     %30
%     a=a+1; R{a}=zeroCrossT;        %31
%     a=a+1; R{a}=zeroMeanValue;     %32
%     a=a+1; R{a}=reliab;;           %33
%     a=a+1; R{a}=Bilan;;            %34
%     a=a+1; R{a}=ST;;               %35
%     a=a+1; R{a}=freq;;             %36
%     a=a+1; R{a}=Mh1r;;             %37
%     a=a+1; R{a}=Mh2r;    ;         %38
%     a=a+1; R{a}=Mh3r;;             %39
%     a=a+1; R{a}=Mh1s;;          %40
%     a=a+1; R{a}=Mh2s;;          %41
%     a=a+1; R{a}=Mh3s;  ;        %42
%     a=a+1; R{a}=Mp1r;;          %43
%     a=a+1; R{a}=Mp2r;    ;      %44
%     a=a+1; R{a}=Mp3r;;          %45
%     a=a+1; R{a}=Mp1s;;          %46
%     a=a+1; R{a}=Mp2s;;          %47
%     a=a+1; R{a}=Mp3s;;          %48
%     a=a+1; R{a}=Spi;;           %49
%     a=a+1; R{a}=Rip;;              %50
%     a=a+1; R{a}=num;               %51
%     a=a+1; R{a}=params;            %52    

%     a=a+1; D{a}=Filt_EEGd;;        %1
%     a=a+1; D{a}=LFPp;;             %2
%     a=a+1; D{a}=LFPh;;             %3




try
    params=R{50}; 
catch
   
    params.tapers=[3 5];
params.Fs=1250;
params.fpass=[0 35];
end
% try
%     num=R{49};              %36
% end


if structure=='hpc'
    LFP=LFPh;
else
    LFP=LFPp;
end

SpiEpoch2=intervalSet((Spi(:,1)-delai)*1E4,(Spi(:,3)+delai)*1E4);
SpiEpoch=intervalSet((Spi(:,1))*1E4,(Spi(:,3))*1E4);

 
    clf, subplot(1,4,1:3), hold on
    plot(Range(Restrict(LFP{num(1)},subset(SpiEpoch2,i)),'s'),Data(Restrict(LFP{num(1)},subset(SpiEpoch2,i))))
         try
            plot(Range(Restrict(LFP{num(1)+1},subset(SpiEpoch2,i)),'s'),Data(Restrict(LFP{num(1)+1},subset(SpiEpoch2,i)))-4000,'k')
         end
                try
            plot(Range(Restrict(LFP{num(1)+2},subset(SpiEpoch2,i)),'s'),Data(Restrict(LFP{num(1)+2},subset(SpiEpoch2,i)))-4300,'k')
                end
        
        try
            plot(Range(Restrict(LFP{num(1)-1},subset(SpiEpoch2,i)),'s'),Data(Restrict(LFP{num(1)-1},subset(SpiEpoch2,i)))-4500,'k')
        end
         try
            plot(Range(Restrict(LFP{num(1)-2},subset(SpiEpoch2,i)),'s'),Data(Restrict(LFP{num(1)-2},subset(SpiEpoch2,i)))-4600,'k')
        end
    plot(Range(Restrict(Filt_EEGd,subset(SpiEpoch2,i)),'s'),Data(Restrict(Filt_EEGd,subset(SpiEpoch2,i))),'r')
    hold on, plot(tPeaksT,500+zeros(length(tPeaksT),1),'ko','markerfacecolor','r')
    hold on, plot(zeroCrossT,zeros(length(zeroCrossT),1),'ko','markerfacecolor','k')    
    
    hold on, plot(Rip(:,2),2000+zeros(length(Rip),1),'ko','markerfacecolor','y')   
    
    xlim([Start(subset(SpiEpoch2,i),'s') End(subset(SpiEpoch2,i),'s')])
    title(['spectrum: ',num2str(floor(Bilan(i,2))),',   derivate: ',num2str(Bilan(i,3)),',   zero cross: ',num2str(Bilan(i,4))])
    
    tPeakstemp=tPeaksT(find(tPeaksT>Start(subset(SpiEpoch,i),'s') & tPeaksT<End(subset(SpiEpoch,i),'s')));
    zeroCrosstemp=zeroCrossT(find(zeroCrossT>Start(subset(SpiEpoch,i),'s') & zeroCrossT<End(subset(SpiEpoch,i),'s')));
    freq=[0:0.5:38]; 
    h1=hist(1./(diff(tPeakstemp)*2),freq);
    h2=hist(1./(diff(zeroCrosstemp)*2),freq);    
   
%     subplot(1,4,4),hold on
%     bar([0:1:38],h2,1,'k')
%     plot([0:1:38],h1,'r','linewidth',2)
%     xlim([1 35])
%
%-------------------------------------------------------------     
    subplot(1,4,4),hold on
    bar(freq,smooth(h2,smo),1,'k')
    plot(freq,smooth(h1,smo),'r','linewidth',2)
    xlim([1 35])

    [BE,id]=max(smooth(h1,smo));
    fmax2=freq(id)
    [BE,id]=max(smooth(h2,smo));
    fmax3=freq(id)
 %------------------------------------------------------------- 
 
 
    datatemp=Data(Restrict(LFP{num(1)},subset(SpiEpoch,i)));
    datatemp2=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)));
    title(num2str(floor(100*reliab(i)/mean(reliab))))
    [S,f]=mtspectrumc(datatemp,params);
    
    
%-------------------------------------------------------------      
%     subplot(1,4,4),plot(f,10*S/max(S),'b','linewidth',2),xlim([1 35])
    subplot(1,4,4),plot(f,smooth(10*S/max(S),smo),'b','linewidth',2),xlim([1 35])
     [BE,id]=max(smooth(S(find(f>3.5&f<25):end),smo));
    ftemp=f(find(f>3.5&f<25):end);
    fmax=ftemp(id);
    
    Stemp=smooth(S/max(S)*10,smo);
    Stemp=Stemp(find(f>3.5&f<25));
    de = diff(Stemp)';
    de1 = [de 0];
    de2 = [0 de]; 
    %finding peaks
    upPeaksIdx = find(de1 < 0 & de2 > 0);
%     length(upPeaksIdx)
%     ftemp(upPeaksIdx)
    [BE,id]=max(Stemp(upPeaksIdx));
    fpeaks=ftemp(upPeaksIdx(id));
    
    plot(fpeaks,Stemp(upPeaksIdx(id)),'ko','markerfacecolor','k')
    
    if length(fpeaks)>0
    fmax=fpeaks;
    end
    fmax
    
  %-------------------------------------------------------------       