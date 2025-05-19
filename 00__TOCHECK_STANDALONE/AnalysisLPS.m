%AnalysisLPS


%Mouse�51
num=[2,1];
cd /media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013
[R51d1,D51d1]=AnalysisLPSSingleDay(num,'veh');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130221\BULB-Mouse-51-21022013
[R51d2,D51d2]=AnalysisLPSSingleDay(num,'LPS');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130222\BULB-Mouse-51-22022013
[R51d3,D51d3]=AnalysisLPSSingleDay(num,'non');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130223\BULB-Mouse-51-23022013
[R51d4,D51d4]=AnalysisLPSSingleDay(num,'non');close all

%Mouse�54
num=[1,1];
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130319\BULB-Mouse-54-19032013
[R54d1,D54d1]=AnalysisLPSSingleDay(num,'veh');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130320\BULB-Mouse-54-20032013
[R54d2,D54d2]=AnalysisLPSSingleDay(num,'LPS');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130321\BULB-Mouse-54-21032013
[R54d3,D54d3]=AnalysisLPSSingleDay(num,'non');close all
cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse054\20130322\BULB-Mouse-54-22032013
[R54d4,D54d4]=AnalysisLPSSingleDay(num,'non');close all


cd C:\Users\MOBs3
save -v7.3 DataAll

ratioREMSWS(1,1)=R51d1{8}/(R51d1{2}+R51d1{8})*100;
ratioREMSWS(1,2)=R51d1{11}/(R51d1{5}+R51d1{11})*100; 
ratioREMSWS(1,3)=R51d2{8}/(R51d2{2}+R51d2{8})*100;
ratioREMSWS(1,4)=R51d2{11}/(R51d2{5}+R51d2{11})*100;
ratioREMSWS(1,5)=R51d3{8}/(R51d3{2}+R51d3{8})*100;
ratioREMSWS(1,6)=R51d3{11}/(R51d3{5}+R51d3{11})*100;
ratioREMSWS(1,7)=R51d4{8}/(R51d4{2}+R51d4{8})*100;
ratioREMSWS(1,8)=R51d4{11}/(R51d4{5}+R51d4{11})*100;

ratioREMSWS(2,1)=R54d1{8}/(R54d1{2}+R54d1{8})*100;
ratioREMSWS(2,2)=R54d1{11}/(R54d1{5}+R54d1{11})*100;
ratioREMSWS(2,3)=R54d2{8}/(R54d2{2}+R54d2{8})*100;
ratioREMSWS(2,4)=R54d2{11}/(R54d2{5}+R54d2{11})*100;
ratioREMSWS(2,5)=R54d3{8}/(R54d3{2}+R54d3{8})*100;
ratioREMSWS(2,6)=R54d3{11}/(R54d3{5}+R54d3{11})*100;
ratioREMSWS(2,7)=R54d4{8}/(R54d4{2}+R54d4{8})*100;
ratioREMSWS(2,8)=R54d4{11}/(R54d4{5}+R54d4{11})*100;



PercSleep(1,1)=(R51d1{2}+R51d1{8})/R51d1{13}*100;
PercSleep(1,2)=(R51d1{5}+R51d1{11})/R51d1{14}*100;
PercSleep(1,3)=(R51d2{2}+R51d2{8})/R51d2{13}*100;
PercSleep(1,4)=(R51d2{5}+R51d2{11})/R51d2{14}*100;
PercSleep(1,5)=(R51d3{2}+R51d3{8})/R51d3{13}*100;
PercSleep(1,6)=(R51d3{5}+R51d3{11})/R51d3{14}*100;
PercSleep(1,7)=(R51d4{2}+R51d4{8})/R51d4{13}*100;
PercSleep(1,8)=(R51d4{5}+R51d4{11})/R51d4{14}*100;

PercSleep(2,1)=(R54d1{2}+R54d1{8})/R54d1{13}*100;
PercSleep(2,2)=(R54d1{5}+R54d1{11})/R54d1{14}*100;
PercSleep(2,3)=(R54d2{2}+R54d2{8})/R54d2{13}*100;
PercSleep(2,4)=(R54d2{5}+R54d2{11})/R54d2{14}*100;
PercSleep(2,5)=(R54d3{2}+R54d3{8})/R54d3{13}*100;
PercSleep(2,6)=(R54d3{5}+R54d3{11})/R54d3{14}*100;
PercSleep(2,7)=(R54d4{2}+R54d4{8})/R54d4{13}*100;
PercSleep(2,8)=(R54d4{5}+R54d4{11})/R54d4{14}*100;

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
%     a=a+1; R{a}=befR;             %15
%     a=a+1; R{a}= aftR;            %16
%     a=a+1; R{a}= befS;            %17
%     a=a+1; R{a}=aftS;             %18

meanDurationSWS(1,1)=R51d1{3};
meanDurationSWS(1,2)=R51d1{6}; 
meanDurationSWS(1,3)=R51d2{3};
meanDurationSWS(1,4)=R51d2{6};
meanDurationSWS(1,5)=R51d3{3};
meanDurationSWS(1,6)=R51d3{6};
meanDurationSWS(1,7)=R51d4{3};
meanDurationSWS(1,8)=R51d4{6};

meanDurationSWS(2,1)=R54d1{3};
meanDurationSWS(2,2)=R54d1{6}; 
meanDurationSWS(2,3)=R54d2{3};
meanDurationSWS(2,4)=R54d2{6};
meanDurationSWS(2,5)=R54d3{3};
meanDurationSWS(2,6)=R54d3{6};
meanDurationSWS(2,7)=R54d4{3};
meanDurationSWS(2,8)=R54d4{6};

meanDurationREM(1,1)=R51d1{9};
meanDurationREM(1,2)=R51d1{12}; 
meanDurationREM(1,3)=R51d2{9};
meanDurationREM(1,4)=R51d2{12};
meanDurationREM(1,5)=R51d3{9};
meanDurationREM(1,6)=R51d3{12};
meanDurationREM(1,7)=R51d4{9};
meanDurationREM(1,8)=R51d4{12};

meanDurationREM(2,1)=R54d1{9};
meanDurationREM(2,2)=R54d1{12}; 
meanDurationREM(2,3)=R54d2{9};
meanDurationREM(2,4)=R54d2{12};
meanDurationREM(2,5)=R54d3{9};
meanDurationREM(2,6)=R54d3{12};
meanDurationREM(2,7)=R54d4{9};
meanDurationREM(2,8)=R54d4{12};

PlotErrorBar(ratioREMSWS),title('Ratio REM/SWS')
PlotErrorBar(meanDurationSWS),title('Mean duration SWS')
PlotErrorBar(meanDurationREM),title('Mean duration REM')
PlotErrorBar(PercSleep),title('Percentacle Sleep')

% FindSpindlesRipples
% 
% [d1tPeaksT,d1peakValue,d1zeroCrossT,d1reliab,d1Bilan,d1ST,d1freq,d1Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num(1),Spi);
% 
%  st=Start(VEHEpoch,'s');
%  en=End(VEHEpoch,'s');
%  
%  d1ripts=ripts;
%  d1spits=spits;
%   d1Spi=Spi;
%  d1Epoch1=and(intervalSet(0,st(1)*1E4),SWSEpoch);
%  d1DurEpoch1=sum(End(d1Epoch1,'s')-Start(d1Epoch1,'s'));
%  
%  d1Epoch2=and(VEHEpoch,SWSEpoch);
%  d1DurEpoch2=sum(End(d1Epoch2,'s')-Start(d1Epoch2,'s'));
%  
%  d1befR=length(Restrict(d1ripts,d1Epoch1))/d1DurEpoch1;
%  d1aftR=length(Restrict(d1ripts,d1Epoch2))/d1DurEpoch2;
% 
%  d1befS=length(Restrict(d1spits,d1Epoch1))/d1DurEpoch1;
%  d1aftS=length(Restrict(d1spits,d1Epoch2))/d1DurEpoch2;
%  
%  
%        
% [d1C,d1B]=CrossCorr(Range(d1spits),Range(d1ripts),1000,500);
% figure, plot(d1B/1E3,smooth(d1C,10))
% [d1C1,d1B1]=CrossCorr(Range(Restrict(d1spits,d1Epoch1)),Range(Restrict(d1ripts,d1Epoch1)),1000,500);
% hold on, plot(d1B1/1E3,smooth(d1C1,10),'r')
% xlim([-150 150])
% [d1C2,d1B2]=CrossCorr(Range(Restrict(d1spits,d1Epoch2)),Range(Restrict(d1ripts,d1Epoch2)),1000,500);
% hold on, plot(d1B2/1E3,smooth(d1C2,10),'k')
% line([0 0],[0.12 0.3],'color','k')   
%        title('Cross Corr Spindles ripples vehicule')
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130221\BULB-Mouse-51-21022013
% 
% 
% R2=AnalysisLPSSingleDay(num,'LPS');

% num=[2,1];
% FindSpindlesRipples
% 
%  d2ripts=ripts;
%  d2spits=spits;
%   d2Spi=Spi;
% [d2tPeaksT,d2peakValue,d2zeroCrossT,d2reliab,d2Bilan,d2ST,d2freq,d2Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num(1),Spi);
% 
%  d2Epoch1=and(intervalSet(0,st(1)*1E4),SWSEpoch);
%  d2DurEpoch1=sum(End(d2Epoch1,'s')-Start(d2Epoch1,'s'));
%  
%  d2Epoch2=and(LPSEpoch,SWSEpoch);
%  d2DurEpoch2=sum(End(d2Epoch2,'s')-Start(d2Epoch2,'s'));
%  
%  d2befR=length(Restrict(d2ripts,d2Epoch1))/d2DurEpoch1;
%  d2aftR=length(Restrict(d2ripts,d2Epoch2))/d2DurEpoch2;
% 
%  d2befS=length(Restrict(d2spits,d2Epoch1))/d2DurEpoch1;
%  d2aftS=length(Restrict(d2spits,d2Epoch2))/d2DurEpoch2;
%  
%  
%        
% [d2C,d2B]=CrossCorr(Range(d2spits),Range(d2ripts),1000,500);
% figure, plot(d2B/1E3,smooth(d2C,10))
% [d2C1,d2B1]=CrossCorr(Range(Restrict(d2spits,d2Epoch1)),Range(Restrict(d2ripts,d2Epoch1)),1000,500);
% hold on, plot(d2B1/1E3,smooth(d2C1,10),'r')
% xlim([-150 150])
% [d2C2,d2B2]=CrossCorr(Range(Restrict(d2spits,d2Epoch2)),Range(Restrict(d2ripts,d2Epoch2)),1000,500);
% hold on, plot(d2B2/1E3,smooth(d2C2,10),'k')
% line([0 0],[0.12 0.3],'color','k')  
% 
%        title('Cross Corr Spindles ripples LPS injection')
       
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130222\BULB-Mouse-51-22022013
% 
% 
% R3=AnalysisLPSSingleDay(num,'non');

% num=[2,1];
% FindSpindlesRipples
%  d3ripts=ripts;
%  d3spits=spits;
%  d3Spi=Spi;
% [d3tPeaksT,d3peakValue,d3zeroCrossT,d3reliab,d3Bilan,d3ST,d3freq,d3Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num(1),Spi);
% 
%  d3Epoch1=SWSEpoch;
%  d3DurEpoch1=sum(End(d3Epoch1,'s')-Start(d3Epoch1,'s'));
%  
%  
%  d3aftR=length(Restrict(d3ripts,d3Epoch1))/d3DurEpoch1;
%  
%  d3aftS=length(Restrict(d3spits,d3Epoch1))/d3DurEpoch1;
%  
%  
%        
% [d3C,d3B]=CrossCorr(Range(d3spits),Range(d3ripts),1000,500);
% figure, plot(d3B/1E3,smooth(d3C,10))
% 
% line([0 0],[0.12 0.3],'color','k') 
%        title('Cross Corr Spindles ripples LPS injection Day 1')
       
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse051\20130223\BULB-Mouse-51-23022013
% 
% R4=AnalysisLPSSingleDay(num,'non');

% num=[2,1];
% FindSpindlesRipples
%  d4ripts=ripts;
%  d4spits=spits;
%   d4Spi=Spi;
% [d4tPeaksT,d4peakValue,d4zeroCrossT,d4reliab,d4Bilan,d4ST,d4freq,d4Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num(1),Spi);
% 
%  d4Epoch1=SWSEpoch;
%  d4DurEpoch1=sum(End(d4Epoch1,'s')-Start(d4Epoch1,'s'));
%  
%  d4aftR=length(Restrict(d4ripts,d4Epoch1))/d4DurEpoch1;
%  d4aftS=length(Restrict(d4spits,d4Epoch1))/d4DurEpoch1;
%       
% [d4C,d4B]=CrossCorr(Range(d4spits),Range(d4ripts),1000,500);
% figure, plot(d4B/1E3,smooth(d4C,10))
%        title('Cross Corr Spindles ripples LPS injection Day 2')
% line([0 0],[0.12 0.3],'color','k') 



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%  disp(' ')
%  disp(' Injection Vehicule')
%  disp(['Duration SWS before Veh: ',num2str(d1DurEpoch1),' s'])
%  disp(['Duration SWS  after Veh: ',num2str(d1DurEpoch2),' s']) 
%  disp(['Ripples frequency  before Veh: ',num2str(d1befR),' Hz'])
%  disp(['Ripples frequency   after Veh: ',num2str(d1aftR),' Hz']) 
%  disp(['Spindles frequency  before Veh: ',num2str(d1befS),' Hz'])
%  disp(['Spindles frequency   after Veh: ',num2str(d1aftS),' Hz']) 
%  
%  disp(' ')
%  disp(' Injection LPS')
%  disp(['Duration SWS before LPS: ',num2str(d2DurEpoch1),' s'])
%  disp(['Duration SWS  after LPS: ',num2str(d2DurEpoch2),' s'])
%  disp(['Ripples frequency  before LPS: ',num2str(d2befR),' Hz'])
%  disp(['Ripples frequency   after LPS: ',num2str(d2aftR),' Hz']) 
%  disp(['Spindles frequency  before LPS: ',num2str(d2befS),' Hz'])
%  disp(['Spindles frequency   after LPS: ',num2str(d2aftS),' Hz']) 
%  
%  disp(' ')
%  disp(' Injection LPS Day1')
%  disp(['Duration SWS  after LPS day1 : ',num2str(d3DurEpoch1),' s']) 
%  disp(['Ripples frequency   after LPS day1 : ',num2str(d3aftR),' Hz'])     
%  disp(['Spindles frequency  after LPS day1 : ',num2str(d3aftS),' Hz']) 
%  
%  disp(' ')
%  disp(' Injection LPS Day2')
%  disp(['Duration SWS  after LPS day2 : ',num2str(d4DurEpoch1),' s'])  
%  disp(['Ripples frequency   after LPS day2 : ',num2str(d4aftR),' Hz'])   
%  disp(['Spindles frequency  after LPS day2 : ',num2str(d4aftS),' Hz'])
%  
%  disp(' ') 
%  
 
 
 
%  Injection Vehicule
% Duration SWS before Veh: 4714.8296 s
% Duration SWS  after Veh: 3746.4797 s
% Ripples frequency  before Veh: 0.25049 Hz
% Ripples frequency   after Veh: 0.23008 Hz
% Spindles frequency  before Veh: 0.050691 Hz
% Spindles frequency   after Veh: 0.066996 Hz
%  
%  Injection LPS
% Duration SWS before LPS: 4645.2591 s
% Duration SWS  after LPS: 5209.5437 s
% Ripples frequency  before LPS: 0.1903 Hz
% Ripples frequency   after LPS: 0.21019 Hz
% Spindles frequency  before LPS: 0.033583 Hz
% Spindles frequency   after LPS: 0.023802 Hz
%  
%  Injection LPS Day1
% Duration SWS  after LPS day1 : 5870.3206 s
% Ripples frequency   after LPS day1 : 0.18687 Hz
% Spindles frequency  after LPS day1 : 0.035773 Hz
%  
%  Injection LPS Day2
% Duration SWS  after LPS day2 : 4686.7155 s
% Ripples frequency   after LPS day2 : 0.20163 Hz
% Spindles frequency  after LPS day2 : 0.054196 Hz
 
 