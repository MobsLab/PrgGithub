function [DurS,DurR,DurW,StateBefS,StateBefR,StateBefW,SpS1,SpS2,SpS3,SpR1,SpR2,SpR3,SpW1,SpW2,SpW3,freq,rS,pS,rR,pR,rW,pW,NbSpi,NbSpiR,NbSpiW]=AnalyseEvolMarie(RemovePreEpoch,ref,plo)

tic
try
    plo;
catch
    plo=0;
end

try
    ref;
catch
    ref='Sps';
end

try
    RemovePreEpoch;
catch
    RemovePreEpoch=1;
end


freqSlow=[2 4];


 switch ref
                case 'Rip'
            load RipplesdHPC25
            rip=ts(dHPCrip(:,2)*1E4);
            tpsref=rip;
            
                case 'Dpf'
            load DeltaPFCx
            tpsref=tDeltaT2;
            
                case 'Dpa'
            load DeltaPaCx
            tpsref=tDeltaT2;
            
                case 'Sad'
            load SpindlesPaCxDeep
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tpsref=spiH;
            
                case 'Sas'
            load SpindlesPaCxSup
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tpsref=spiH;
            
                case 'Spd'
            load SpindlesPFCxDeep
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tpsref=spiH;
            
                case 'Sps'
            load SpindlesPFCxSup
            spiH=ts(SpiHigh(:,2)*1E4);
            spiL=ts(SpiLow(:,2)*1E4);
            tpsref=spiH;
            
 end
            

clear TimeEndRec
load behavResources Movtsd PreEpoch DPCPXEpoch TimeEndRec tpsdeb tpsfin
try
TimeEndRec;
durRec1=(tpsfin{1}-tpsdeb{1})/3600;
catch
    
    disp('No timeRec')
	TimeEndRec;
end


load StateEpochSB SWSEpoch REMEpoch Wake wakeper TotalNoiseEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch ThresholdedNoiseEpoch

if RemovePreEpoch
    try
        SWSEpoch=and(SWSEpoch,PreEpoch);
        Wake=and(Wake,PreEpoch);
        REMEpoch=and(REMEpoch,PreEpoch);
    end
else
        try
        SWSEpoch=and(SWSEpoch,DPCPXEpoch);
        Wake=and(Wake,DPCPXEpoch);
        REMEpoch=and(REMEpoch,DPCPXEpoch);
    end
    
end

try
    
%     res=pwd;
%     tempchBulb=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
%     chBulb=tempchBulb.channel;
%     eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
%     disp(' ')
%     disp('*****************  PFC *********************')

    res=pwd;
    disp(' ')
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    disp('*****************  Bulb *********************')
    

end


    


try
TotalNoiseEpoch;
catch
try
TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),or(WeirdNoiseEpoch,ThresholdedNoiseEpoch));
catch
    try
        try
            TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
    catch 
        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),ThresholdedNoiseEpoch);
        end
    catch
        TotalNoiseEpoch=or(GndNoiseEpoch,NoiseEpoch);
    end


end
end

TotalNoiseEpoch=mergeCloseIntervals(TotalNoiseEpoch,400);

Sle=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,10); close
Sptsd=tsd(t*1E4,Sp);
Slowtsd=tsd(t*1E4,mean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));



stS=Start(SWSEpoch);
stR=Start(REMEpoch);
stW=Start(Wake);   
stN=Start(TotalNoiseEpoch);
clear StateBefS
clear StateBefR
clear StateBefW
clear StateBefN

for i=1:length(Start(SWSEpoch))
    clear temp
    temp=(Data(Restrict(Sle,intervalSet(stS(i)-350,stS(i)+350))));
    try
        StateBefS(i,1)=temp(1);
    catch
        StateBefS(i,1)=-1;
    end
    StateBefS(i,2)=i;
    
    ctrl=(Data(Restrict(Sle,intervalSet(stS(i)-10*60E4,stS(i)))));
    StateBefS(i,3)=length(find(ctrl==3))/length(ctrl)*100;
    StateBefS(i,4)=length(find(ctrl==4))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(stS(i)-2*60E4,stS(i)))));
    StateBefS(i,5)=length(find(ctrl==3))/length(ctrl)*100;
    StateBefS(i,6)=length(find(ctrl==4))/length(ctrl)*100;
    
end

for i=1:length(Start(REMEpoch))
    clear temp
    temp=(Data(Restrict(Sle,intervalSet(stR(i)-350,stR(i)+350))));
    try
        StateBefR(i,1)=temp(1);
    catch
        StateBefR(i,1)=-1;
    end
    StateBefR(i,2)=i;
    
    ctrl=(Data(Restrict(Sle,intervalSet(stR(i)-10*60E4,stR(i)))));
    StateBefR(i,3)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefR(i,4)=length(find(ctrl==4))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(stR(i)-2*60E4,stR(i)))));
    StateBefR(i,5)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefR(i,6)=length(find(ctrl==4))/length(ctrl)*100;
    
    
end


for i=1:length(Start(Wake))
    clear temp
    temp=(Data(Restrict(Sle,intervalSet(stW(i)-350,stW(i)+350))));
    try
        StateBefW(i,1)=temp(1);
    catch
        StateBefW(i,1)=-1;
    end
    StateBefW(i,2)=i;
        
    ctrl=(Data(Restrict(Sle,intervalSet(stW(i)-10*60E4,stW(i)))));
    StateBefW(i,3)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefW(i,4)=length(find(ctrl==3))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(stW(i)-2*60E4,stW(i)))));
    StateBefW(i,5)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefW(i,6)=length(find(ctrl==3))/length(ctrl)*100;
    
end

for i=1:length(Start(TotalNoiseEpoch))
    clear temp
    temp=(Data(Restrict(Sle,intervalSet(stN(i)-350,stN(i)+350))));
    try
        StateBefN(i,1)=temp(1);
    catch
        StateBefN(i,1)=-1;
    end
    
        StateBefN(i,2)=i;
    ctrl=(Data(Restrict(Sle,intervalSet(stN(i)-10*60E4,stN(i)))));
    StateBefN(i,3)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefN(i,4)=length(find(ctrl==4))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(stN(i)-2*60E4,stN(i)))));
    StateBefN(i,5)=length(find(ctrl==1))/length(ctrl)*100;
    StateBefN(i,6)=length(find(ctrl==4))/length(ctrl)*100;
    
end



% 
% idS=find(StateBefS(:,1)>-1);
% SWSepoch=subset(SWSEpoch,idS);

if plo
figure('color',[1 1 1]), 
subplot(1,4,1), hist(StateBefS(:,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
title('SWS')
subplot(1,4,2), hist(StateBefR(:,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
title('REM')
subplot(1,4,3), hist(StateBefW(:,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
title('Wake')
subplot(1,4,4), hist(StateBefN(:,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
title('Noise')

end



[SlowSWS,valSWS,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[10 12]);close
[SlowWake,valWake,val2]=FindSlowOscBulb(Sp,t,f,Wake,1,[10 12]);close
[SlowREM,valREM,val2]=FindSlowOscBulb(Sp,t,f,REMEpoch,1,[10 12]);close       

SpS1=mean(Data(Restrict(Sptsd,SWSEpoch)));
SpS2=mean(Data(Restrict(Sptsd,SlowSWS{1})));                    
SpS3=mean(Data(Restrict(Sptsd,SlowSWS{5})));                    

SpR1=mean(Data(Restrict(Sptsd,SWSEpoch)));
SpR2=mean(Data(Restrict(Sptsd,SlowSWS{1})));                    
SpR3=mean(Data(Restrict(Sptsd,SlowSWS{5})));      

SpW1=mean(Data(Restrict(Sptsd,SWSEpoch)));
SpW2=mean(Data(Restrict(Sptsd,SlowSWS{1})));                    
SpW3=mean(Data(Restrict(Sptsd,SlowSWS{5})));      


freq=0:0.1:20;
Sp1tsd=tsd(f,SpS1');
SpS1=Data(Restrict(Sp1tsd,freq'));
Sp2tsd=tsd(f,SpS2');
SpS2=Data(Restrict(Sp2tsd,freq'));                    
Sp3tsd=tsd(f,SpS3');
SpS3=Data(Restrict(Sp3tsd,freq'));   

Sp1tsd=tsd(f,SpR1');
SpR1=Data(Restrict(Sp1tsd,freq'));
Sp2tsd=tsd(f,SpR2');
SpR2=Data(Restrict(Sp2tsd,freq'));                    
Sp3tsd=tsd(f,SpR3');
SpR3=Data(Restrict(Sp3tsd,freq'));                       


for i=1:length(Start(SWSEpoch))
DurS(i,1)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
try
DurS(i,2)=sum(End(and(subset(SWSEpoch,i),SlowSWS{1}),'s')-Start(and(subset(SWSEpoch,i),SlowSWS{1}),'s'));
catch
DurS(i,2)=0;   
end
DurS(i,3)=DurS(i,2)/DurS(i,1)*100;
DurS(i,4)=Start(subset(SWSEpoch,i),'s');
try
    DurS(i,5)=TimeEndRec(1,1)+TimeEndRec(1,2)/60+Start(subset(SWSEpoch,i),'s')/3600-durRec1;  
catch
    DurS(i,5)=nan;
end

DurS(i,6)=mean(Data(Restrict(Slowtsd,subset(SWSEpoch,i))));
DurS(i,7)=mean(Data(Restrict(Slowtsd,and(subset(SWSEpoch,i),SlowSWS{1}))));
DurS(i,8)=mean(Data(Restrict(Slowtsd,subset(SWSEpoch,i)-SlowSWS{1})));



end

for i=1:length(Start(REMEpoch))
DurR(i,1)=sum(End(subset(REMEpoch,i),'s')-Start(subset(REMEpoch,i),'s'));
try
DurR(i,2)=sum(End(and(subset(REMEpoch,i),SlowREM{1}),'s')-Start(and(subset(REMEpoch,i),SlowREM{1}),'s'));
catch
DurR(i,2)=0;
end
DurR(i,3)=DurR(i,2)/DurR(i,1)*100;
DurR(i,4)=Start(subset(REMEpoch,i),'s');
try
DurR(i,5)=TimeEndRec(1,1)+TimeEndRec(1,2)/60+Start(subset(REMEpoch,i),'s')/3600-durRec1;
catch
 DurR(i,5)=nan;
end
    DurR(i,6)=mean(Data(Restrict(Slowtsd,subset(REMEpoch,i))));
DurR(i,7)=mean(Data(Restrict(Slowtsd,and(subset(REMEpoch,i),SlowREM{1}))));
DurR(i,8)=mean(Data(Restrict(Slowtsd,subset(REMEpoch,i)-SlowREM{1})));
end

for i=1:length(Start(Wake))
DurW(i,1)=sum(End(subset(Wake,i),'s')-Start(subset(Wake,i),'s'));
try
DurW(i,2)=sum(End(and(subset(Wake,i),SlowWake{1}),'s')-Start(and(subset(Wake,i),SlowWake{1}),'s'));
catch
DurW(i,2)=0;
end
DurW(i,3)=DurW(i,2)/DurW(i,1)*100;
DurW(i,4)=Start(subset(Wake,i),'s');
try
DurW(i,5)=TimeEndRec(1,1)+TimeEndRec(1,2)/60+Start(subset(Wake,i),'s')/3600-durRec1;
catch
  DurW(i,5)=nan;  
end
DurW(i,6)=mean(Data(Restrict(Slowtsd,subset(Wake,i))));
DurW(i,7)=mean(Data(Restrict(Slowtsd,and(subset(Wake,i),SlowWake{1}))));
DurW(i,8)=mean(Data(Restrict(Slowtsd,subset(Wake,i)-SlowWake{1})));                    
end

[rS,pS]=corrcoef(DurS(:,4),DurS(:,3));rS=rS(2,1); pS=pS(2,1);
[rR,pR]=corrcoef(DurR(:,4),DurR(:,3));rR=rR(2,1); pR=pR(2,1);
[rW,pW]=corrcoef(DurW(:,4),DurW(:,3));rW=rW(2,1); pW=pW(2,1);








load behavResources Movtsd


clear NbSpi
clear NbSpiR
clear NbSpiW

rg=Range(Movtsd);
TotalEpoch=intervalSet(0,rg(end));
try
TotalEpoch=TotalEpoch-TotalNoiseEpoch;
end

if RemovePreEpoch
    try
        TotalEpoch=and(TotalEpoch,PreEpoch);
    end
end
EpochTest=SWSEpoch;

NbSpi(1,1)=length(Range(Restrict(tpsref,TotalEpoch)));
NbSpi(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpi(1,3)=NbSpi(1,1)/NbSpi(1,2);
NbSpi(1,4)=nan;
NbSpi(1,5)=nan;
NbSpi(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpi(2,1)=length(Range(Restrict(tpsref,EpochTest)));
NbSpi(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpi(2,3)=NbSpi(2,1)/NbSpi(2,2);
NbSpi(2,4)=nan;
NbSpi(2,5)=nan;
NbSpi(2,6)=nan;

for i=1:9
NbSpi(i+2,1)=length(Range(Restrict(tpsref,Epoch{i})));
NbSpi(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpi(i+2,3)=NbSpi(i+2,1)/NbSpi(i+2,2);

NbSpi(i+2,4)=length(Range(Restrict(tpsref,EpochTest-Epoch{i})));
NbSpi(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpi(i+2,6)=NbSpi(i+2,4)/NbSpi(i+2,5);
end


EpochTest=Wake;

NbSpiW(1,1)=length(Range(Restrict(tpsref,TotalEpoch)));
NbSpiW(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpiW(1,3)=NbSpiW(1,1)/NbSpiW(1,2);
NbSpiW(1,4)=nan;
NbSpiW(1,5)=nan;
NbSpiW(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpiW(2,1)=length(Range(Restrict(tpsref,EpochTest)));
NbSpiW(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpiW(2,3)=NbSpi(2,1)/NbSpi(2,2);
NbSpiW(2,4)=nan;
NbSpiW(2,5)=nan;
NbSpiW(2,6)=nan;

for i=1:9
NbSpiW(i+2,1)=length(Range(Restrict(tpsref,Epoch{i})));
NbSpiW(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpiW(i+2,3)=NbSpiW(i+2,1)/NbSpiW(i+2,2);

NbSpiW(i+2,4)=length(Range(Restrict(tpsref,EpochTest-Epoch{i})));
NbSpiW(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpiW(i+2,6)=NbSpi(i+2,4)/NbSpi(i+2,5);

end




EpochTest=REMEpoch;

NbSpiR(1,1)=length(Range(Restrict(tpsref,TotalEpoch)));
NbSpiR(1,2)=sum(End(TotalEpoch,'s')-Start(TotalEpoch,'s'));
NbSpiR(1,3)=NbSpiR(1,1)/NbSpiR(1,2);
NbSpiR(1,4)=nan;
NbSpiR(1,5)=nan;
NbSpiR(1,6)=nan;

clear Epoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,EpochTest,1,[10 12]);close

NbSpiR(2,1)=length(Range(Restrict(tpsref,EpochTest)));
NbSpiR(2,2)=sum(End(EpochTest,'s')-Start(EpochTest,'s'));
NbSpiR(2,3)=NbSpiR(2,1)/NbSpiR(2,2);
NbSpiR(2,4)=nan;
NbSpiR(2,5)=nan;
NbSpiR(2,6)=nan;

for i=1:9
NbSpiR(i+2,1)=length(Range(Restrict(tpsref,Epoch{i})));
NbSpiR(i+2,2)=sum(End(Epoch{i},'s')-Start(Epoch{i},'s'));
NbSpiR(i+2,3)=NbSpiR(i+2,1)/NbSpiR(i+2,2);
NbSpiR(i+2,4)=length(Range(Restrict(tpsref,EpochTest-Epoch{i})));
NbSpiR(i+2,5)=sum(End(EpochTest-Epoch{i},'s')-Start(EpochTest-Epoch{i},'s'));
NbSpiR(i+2,6)=NbSpiR(i+2,4)/NbSpiR(i+2,5);

end








toc
