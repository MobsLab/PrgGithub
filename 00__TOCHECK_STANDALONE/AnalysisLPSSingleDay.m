function [R,D]=AnalysisLPSSingleDay(num,injectionType)

load behavResources
%num=[2,1];
numRef=num;

try 
    load SpindlesRipples
    Spi;
    LFPp;
    SWSEpoch;
    if num~=numRef
      num=numRef;
      FindSpindlesRipples
    save SpindlesRipples Spi Rip spits ripts LFPp LFPh SWSEpoch REMEpoch num
     [tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,Spi);
    save DataFineAnalysisSpindes tPeaksT peakValue peakMeanValue zeroCrossT zeroMeanValue reliab Bilan ST freq Filt_EEGd params num 
    end  
catch
    FindSpindlesRipples
    save SpindlesRipples Spi Rip spits ripts LFPp LFPh SWSEpoch REMEpoch num
     [tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,Spi);
    save DataFineAnalysisSpindes tPeaksT peakValue peakMeanValue zeroCrossT zeroMeanValue reliab Bilan ST freq Filt_EEGd params num 
 end

try 
    try
       tPeaks;
    catch
    cload DataFineAnalysisSpindes
    tPeaksT;
   
    if num~=numRef
    num=numRef;
     [tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,Spi);
    save DataFineAnalysisSpindes tPeaksT peakValue peakMeanValue zeroCrossT zeroMeanValue reliab Bilan ST freq Filt_EEGd params num 
    end
    
    end
    
catch  
    num=numRef;
     [tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,Spi);
    save DataFineAnalysisSpindes tPeaksT peakValue peakMeanValue zeroCrossT zeroMeanValue reliab Bilan ST freq Filt_EEGd params num 
end

     rg=Range(LFPp{1},'s');   
     st=rg(1);
     stTT=rg(1);
     en=rg(end);
     EpochT=intervalSet(st*1E4,en*1E4);
     SWSEpoch=and(SWSEpoch,EpochT);
     REMEpoch=and(REMEpoch,EpochT);
     
%----------------------------------------------
%Correction Spindles
%----------------------------------------------     
     
     
  id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20&Bilan(:,4)<20); 
SpiC=Spi(id,:);
save SpiCorrected SpiC Spi   
     
     
       spits=ts(SpiC(:,2)*1E4);
%----------------------------------------------        
     
     
if injectionType=='veh'
    
    VEHEpoch=and(VEHEpoch,EpochT);
     st=Start(VEHEpoch,'s');
     en=End(VEHEpoch,'s');
     
     EpochT1=(EpochT-VEHEpoch);
     EpochT2=and(EpochT,VEHEpoch);
     
     Epoch1=and(intervalSet(stTT*1E4,st(1)*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(VEHEpoch,SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(stTT*1E4,st(1)*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(VEHEpoch,REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;

 
 
elseif injectionType=='LPS'
   
    LPSEpoch=and(LPSEpoch,EpochT);
     st=Start(LPSEpoch,'s');
     en=End(LPSEpoch,'s');
     
     EpochT1=(EpochT-LPSEpoch);
     EpochT2=and(EpochT,LPSEpoch);
     
     Epoch1=and(intervalSet(stTT*1E4,st(1)*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(LPSEpoch,SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(stTT*1E4,st(1)*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(LPSEpoch,REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;
 
elseif injectionType=='Can'
    
    CPEpoch=and(CPEpoch,EpochT);
     st=Start(CPEpoch,'s');
     en=End(CPEpoch,'s');

     EpochT1=(EpochT-CPEpoch);
     EpochT2=and(EpochT,CPEpoch);
     
     Epoch1=and(intervalSet(stTT*1E4,st(1)*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(CPEpoch,SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(stTT*1E4,st(1)*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(CPEpoch,REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;
 
elseif injectionType=='DPC'
    
    DPCPXEpoch=and(DPCPXEpoch,EpochT);
     st=Start(DPCPXEpoch,'s');
     en=End(DPCPXEpoch,'s');

     EpochT1=(EpochT-DPCPXEpoch);
     EpochT2=and(EpochT,DPCPXEpoch);
     
     Epoch1=and(intervalSet(stTT*1E4,st(1)*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(DPCPXEpoch,SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(stTT*1E4,st(1)*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(DPCPXEpoch,REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;
     
     
elseif injectionType=='non'
    
     st=rg(1);
     en=rg(end);

     EpochT1=intervalSet(st*1E4,en*1E4);
     EpochT2=intervalSet(st*1E4,en*1E4);
     
     Epoch1=and(intervalSet(st*1E4,en*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(intervalSet(st*1E4,en*1E4),SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(st*1E4,en*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(intervalSet(st*1E4,en*1E4),REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;
 
     
     elseif injectionType=='com'
    
     st=rg(1);
     en=rg(end);

     EpochT1=intervalSet(st*1E4,en/2*1E4);
     EpochT2=intervalSet(en/2*1E4,en*1E4);
     
     Epoch1=and(intervalSet(st*1E4,en/2*1E4),SWSEpoch);
     DurEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
     MeanDurEpoch1=mean(End(Epoch1,'s')-Start(Epoch1,'s'));

     Epoch2=and(intervalSet(en/2*1E4,en*1E4),SWSEpoch);
     DurEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
     MeanDurEpoch2=mean(End(Epoch2,'s')-Start(Epoch2,'s'));

     Epoch1rem=and(intervalSet(st*1E4,en/2*1E4),REMEpoch);
     DurEpoch1rem=sum(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));
     MeanDurEpoch1rem=mean(End(Epoch1rem,'s')-Start(Epoch1rem,'s'));

     Epoch2rem=and(intervalSet(en/2*1E4,en*1E4),REMEpoch);
     DurEpoch2rem=sum(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));
     MeanDurEpoch2rem=mean(End(Epoch2rem,'s')-Start(Epoch2rem,'s'));

     befR=length(Restrict(ripts,Epoch1))/DurEpoch1;
     aftR=length(Restrict(ripts,Epoch2))/DurEpoch2;

     befS=length(Restrict(spits,Epoch1))/DurEpoch1;
     aftS=length(Restrict(spits,Epoch2))/DurEpoch2;
     
     
end
 
    
[C,B]=CrossCorr(Range(spits),Range(ripts),100,100);
figure('color',[1 1 1]), hold on, plot(B/1E3,smooth(C,10))

[C1,B1]=CrossCorr(Range(Restrict(spits,Epoch1)),Range(Restrict(ripts,Epoch1)),100,100);
hold on, plot(B1/1E3,smooth(C1,10),'k')
%xlim([-150 150])

[C2,B2]=CrossCorr(Range(Restrict(spits,Epoch2)),Range(Restrict(ripts,Epoch2)),100,100);
hold on, plot(B2/1E3,smooth(C2,10),'r')
line([0 0],[0.12 0.3],'color','r')   
title('Cross Corr Spindles ripples Drug')
       
Mh1r=PlotRipRaw(LFPh{1},Rip,100);
Mh2r=PlotRipRaw(LFPh{2},Rip,100);
try
Mh3r=PlotRipRaw(LFPh{3},Rip,100);
catch
Mh3r=[]; 
end

Mp1r=PlotRipRaw(LFPp{1},Rip,300);
try
Mp2r=PlotRipRaw(LFPp{2},Rip,300);
catch
    Mp2r=[];
end

try
Mp3r=PlotRipRaw(LFPp{3},Rip,300);
catch
Mp3r=[]; 
end

Mh1s=PlotRipRaw(LFPh{1},SpiC,500);
Mh2s=PlotRipRaw(LFPh{2},SpiC,500);
try
Mh3s=PlotRipRaw(LFPh{3},SpiC,500);
catch
 Mh3s=[]; 
end

Mp1s=PlotRipRaw(LFPp{1},SpiC,500);
try
Mp2s=PlotRipRaw(LFPp{2},SpiC,500);
catch
Mp2s=[];
end

try
Mp3s=PlotRipRaw(LFPp{3},SpiC,500);
catch
Mp3s=[]; 
end

st1=Start(Epoch1,'s');
strem1=Start(Epoch1rem,'s');
st2=Start(Epoch2,'s');
strem2=Start(Epoch2rem,'s');
stT=Start(EpochT,'s');
try
    tdelayRemRecording=strem1(1)-stT(1);
catch
    tdelayRemRecording=nan;
end


try
tdelayRem1=strem1(1)-st1(1);
catch
    tdelayRem1=nan;
end
try
tdelayRem2=strem2(1)-st2(1);
catch     
     tdelayRem2=nan;
end

    a=0; 
    a=a+1; R{a}=Epoch1;           %1
    a=a+1; R{a}=DurEpoch1;        %2
    a=a+1; R{a}=MeanDurEpoch1;    %3
    a=a+1; R{a}=Epoch2;           %4
    a=a+1; R{a}=DurEpoch2;        %5
    a=a+1; R{a}=MeanDurEpoch2;    %6
    a=a+1; R{a}=Epoch1rem;        %7
    a=a+1; R{a}=DurEpoch1rem;     %8
    a=a+1; R{a}=MeanDurEpoch1rem; %9
    a=a+1; R{a}=Epoch2rem;        %10
    a=a+1; R{a}=DurEpoch2rem;     %11
    a=a+1; R{a}=MeanDurEpoch2rem; %12
    a=a+1; R{a}=sum(End(EpochT1,'s')-Start(EpochT1,'s'));  %13
    a=a+1; R{a}=sum(End(EpochT2,'s')-Start(EpochT2,'s'));  %14   
    a=a+1; R{a}=tdelayRemRecording; %15
    a=a+1; R{a}=tdelayRem1;         %16 
    a=a+1; R{a}=tdelayRem2;       %17
    a=a+1; R{a}=befR;             %18
    a=a+1; R{a}=aftR;            %19
    a=a+1; R{a}=befS;            %20
    a=a+1; R{a}=aftS;             %21
    a=a+1; R{a}=C;
    a=a+1; R{a}=B;
    a=a+1; R{a}=C1;
    a=a+1; R{a}=B1;
    a=a+1; R{a}=C2;
    a=a+1; R{a}=B2;
    a=a+1; R{a}=tPeaksT;
    a=a+1; R{a}=peakValue;
    a=a+1; R{a}=peakMeanValue;
    a=a+1; R{a}=zeroCrossT;
    a=a+1; R{a}=zeroMeanValue;
    a=a+1; R{a}=reliab;
    a=a+1; R{a}=Bilan;
    a=a+1; R{a}=ST;
    a=a+1; R{a}=freq;
    a=a+1; R{a}=Mh1r;
    a=a+1; R{a}=Mh2r;    
    a=a+1; R{a}=Mh3r;
    a=a+1; R{a}=Mh1s;
    a=a+1; R{a}=Mh2s;
    a=a+1; R{a}=Mh3s;  
    a=a+1; R{a}=Mp1r;
    a=a+1; R{a}=Mp2r;    
    a=a+1; R{a}=Mp3r;
    a=a+1; R{a}=Mp1s;
    a=a+1; R{a}=Mp2s;
    a=a+1; R{a}=Mp3s;
    a=a+1; R{a}=Spi;
    a=a+1; R{a}=Rip;
    a=a+1; R{a}=num; 
    a=a+1; R{a}=params;  
    a=a+1; R{a}=SpiC;  
    a=0;
    a=a+1; D{a}=Filt_EEGd;
    a=a+1; D{a}=LFPp;
    a=a+1; D{a}=LFPh; 

% close all
          %50 

    