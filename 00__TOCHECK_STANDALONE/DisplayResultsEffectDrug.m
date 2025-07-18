function DisplayResultsEffectDrug(R,D,n,Ripl)

plo=0;

ratioREMSWS(1)=R{8}/(R{2}+R{8})*100;
ratioREMSWS(2)=R{11}/(R{5}+R{11})*100; 

PercSleep(1)=(R{2}+R{8})/R{13}*100;
PercSleep(2)=(R{5}+R{11})/R{14}*100;

meanDurationSWS(1)=R{3};
meanDurationSWS(2)=R{6}; 

meanDurationREM(1)=R{9};
meanDurationREM(2)=R{12}; 


smo=10;
if plo
figure('color',[1 1 1]), hold on, 
%plot(R{23}/1E3,smooth(R{22},smo),'b')
plot(R{25}/1E3,smooth(R{24},smo),'k')
plot(R{27}/1E3,smooth(R{26},smo),'r')
xlim([-75 75])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
end

% 
% figure('color',[1 1 1]), hold on, 
% plot(R{35}(:,1),R{35}(:,2),'b')
% plot(R{35}(:,1),R{35}(:,2)+R{35}(:,4),'b')
% plot(R{35}(:,1),R{35}(:,2)-R{35}(:,4),'b')



 try
     n;
 catch
     n=1;
 end
 st=Start(R{4},'s');
Spi=R{49};
Spi1=Spi(find(Spi(:,2)<st(1)),:);
Spi2=Spi(find(Spi(:,2)>st(1)),:);
try
M1s=PlotRipRaw(D{2}{n},Spi1,500);close
M2s=PlotRipRaw(D{2}{n},Spi2,500);close
end

Rip=R{50};
try
Rip1=Rip(find(Rip(:,2)<st(1)),:);
Rip2=Rip(find(Rip(:,2)>st(1)),:);
end
if plo

            try
        M1r=PlotRipRaw(D{3}{n},Rip1,80);close
        M2r=PlotRipRaw(D{3}{n},Rip2,80);close
        catch
            try
            M1r=PlotRipRaw(D{3}{n-1},Rip1,80);close
            M2r=PlotRipRaw(D{3}{n-1},Rip2,80);close        
            end

        end



        try
        figure('color',[1 1 1]), hold on, 
        plot(M1s(:,1),M1s(:,2),'k','linewidth',2)
        plot(M1s(:,1),M1s(:,2)+M1s(:,4),'b')
        plot(M1s(:,1),M1s(:,2)-M1s(:,4),'b')
        plot(M2s(:,1),M2s(:,2),'r','linewidth',2)
        plot(M2s(:,1),M2s(:,2)+M2s(:,4),'m')
        plot(M2s(:,1),M2s(:,2)-M2s(:,4),'m')
        end
        try
        figure('color',[1 1 1]), hold on, 
        plot(M1r(:,1),M1r(:,2),'k','linewidth',2)
        plot(M1r(:,1),M1r(:,2)+M1r(:,4),'b')
        plot(M1r(:,1),M1r(:,2)-M1r(:,4),'b')
        plot(M2r(:,1),M2r(:,2),'r','linewidth',2)
        plot(M2r(:,1),M2r(:,2)+M2r(:,4),'m')
        plot(M2r(:,1),M2r(:,2)-M2r(:,4),'m')
        end

end


% end

% [maps1,data1,stats1] = RippleStats([Range(D{3}{n},'s'),Data(D{3}{n})],Rip1);
% PlotRippleStats(Rip1,maps1,data1,stats1)
% [maps2,data2,stats2] = RippleStats([Range(D{3}{n},'s'),Data(D{3}{n})],Rip2);
% PlotRippleStats(Rip2,maps2,data2,stats2)
try
    Ripl;
catch
    Ripl=0;
end

if Ripl
    try
[M1,M2,maps,data,stats,maps2,data2,stats2,ripEvt,ripEvt2,ripples,ripples2]=CompTwoEpochRipples(D{3},n,R{1},R{4});
    catch
        try
        [M1,M2,maps,data,stats,maps2,data2,stats2,ripEvt,ripEvt2,ripples,ripples2]=CompTwoEpochRipples(D{3},n-1,R{1},R{4});
        end
        
    end
end
%M=PlotRipRaw(D{2},R{48},500)

disp('  ')
 disp(' Injection Drug')
 disp('  ')
 disp(['Duration SWS before Drug: ',num2str(R{2}),' s'])
 disp(['Duration SWS  after Drug: ',num2str(R{5}),' s'])
 disp('  ')
 disp(['Duration REM before Drug: ',num2str(R{8}),' s'])
 disp(['Duration REM  after Drug: ',num2str(R{11}),' s'])
  disp('  ')
   disp(['RatioSWS/REM before Drug: ',num2str(ratioREMSWS(1)),' %'])
 disp(['RatioSWS/REM  after Drug: ',num2str(ratioREMSWS(2)),' %'])
  disp('  ')
     disp(['Sleep (%) before Drug: ',num2str(PercSleep(1)),' %'])
 disp(['Sleep (%) after Drug: ',num2str(PercSleep(2)),' %'])
  disp('  ')
 disp(['Duration sleep before Drug: ',num2str(R{2}+R{8}),' s'])
 disp(['Duration sleep  after Drug: ',num2str(R{5}+R{11}),' s'])
  disp('  ')
 disp(['Duration recording before Drug: ',num2str(R{13}),' s'])
 disp(['Duration recording  after Drug: ',num2str(R{14}),' s'])
 disp('  ')
  disp(['Delay First REM after recording: ',num2str(R{15}),' s'])
 disp(['Delay First REM before Drug: ',num2str(R{16}(1)),' s'])
 disp(['Delay First REM  after Drug: ',num2str(R{17}(1)),' s'])
  disp('  ')
 disp(['Mean REM Duration before Drug: ',num2str(R{9}),' s'])
 disp(['Mean REM Duration  after Drug: ',num2str(R{12}),' s'])
 disp('  ')
  disp(['Ripples frequency  before Drug: ',num2str(R{18}),' Hz'])
 disp(['Ripples frequency   after Drug: ',num2str(R{19}),' Hz']) 
  disp('  ')
 disp(['Spindles frequency  before Drug: ',num2str(R{20}),' Hz'])
 disp(['Spindles frequency   after Drug: ',num2str(R{21}),' Hz']) 
 disp('  ')


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
%     a=a+1; R{a}=SpiC;              %53

%     a=a+1; D{a}=Filt_EEGd;;        %1
%     a=a+1; D{a}=LFPp;;             %2
%     a=a+1; D{a}=LFPh;;             %3