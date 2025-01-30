function [SleepCycle,Mat,CaracSlCy,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch,N1,N2,N3]=ComputeSleepCycle(lim,plo,DoAnlysisSB)


%[SleepCycle,Mat,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC,TotalNoiseEpoch]=ComputeSleepCycle(lim,plo) 
%
try
    DoAnlysisSB;
catch
    DoAnlysisSB=1;
end

try
    plo;
catch
    plo=0;
end

try
    lim;
catch
    lim=15;
end

if DoAnlysisSB
    numgcf=gcf;
    [SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=CleanSleepStages(lim); 
     try
        %need to load the substages of NREM sleep
        load NREMsubstages
        N1;
        N2;
        N3;
        catch
        try
        load StateEpochSB TotalNoiseEpoch
        catch
        load SleepScoring_OBGamma TotalNoiseEpoch
        end
        % dans un dossier particulier
        [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
        %NamesOp={'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'}
        [MATEP,nameEpochs]=DefineSubStages(op,TotalNoiseEpoch);
        N1=MATEP{1};
        N2=MATEP{2};
        N3=MATEP{3};
        save NREMsubstages N1 N2 N3 MATEP nameEpochs op NamesOp Dpfc Epoch noise TotalNoiseEpoch
     end
    if plo==0
        try
        close(numgcf+1)
        end
    end
else
    load StateEpochSB TotalNoiseEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch ThresholdedNoiseEpoch
    try
        ThresholdedNoiseEpoch;
    catch
        try
        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),or(WeirdNoiseEpoch,ThresholdedNoiseEpoch));
        catch
            try
                TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
            catch
                try
                        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),ThresholdedNoiseEpoch);
                catch
                    TotalNoiseEpoch=or(GndNoiseEpoch,NoiseEpoch);
                end
            end
        end
    save StateEpochSB -Append TotalNoiseEpoch
    end
    
    [Wake,REMEpoch,N1,N2,N3]=RunSubstages;
    REMEpoch=mergeCloseIntervals(REMEpoch,30*1E4);
    REMEpoch=dropShortIntervals(REMEpoch,15*1E4);
    
    WakeEpoch=Wake-REMEpoch;
    
    N1=N1-REMEpoch;
    N2=N2-REMEpoch;
    N3=N3-REMEpoch;
    SWSEpoch=or(or(N1,N2),N3);
    SWSEpoch=SWSEpoch-REMEpoch;
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
    TotalNoiseEpoch=or(TotalNoiseEpoch,thresholdIntervals(SleepStages,-0.5,'Direction','Below'));
    TotalNoiseEpoch=mergeCloseIntervals(TotalNoiseEpoch,1);
    [REMEpochC,WakeC,idbad]=CleanREMEpoch(SleepStages,REMEpoch,Wake);
    SleepStagesC=PlotSleepStage(WakeC,SWSEpoch,REMEpochC);close
    [WakeC2,TotalNoiseEpochC,Dur]=CleanWakeNoise(SleepStagesC,WakeC);
    SleepStagesC2=PlotSleepStage(WakeC2,SWSEpoch,REMEpochC);close
    [SWSEpochC3,REMEpochC3,WakeC3]=CleanSWSREM(SleepStagesC2,SWSEpoch,REMEpochC,WakeC2,lim);
    SleepStagesC3=PlotSleepStage(WakeC3,SWSEpochC3,REMEpochC3,0);
    NoiseC=TotalNoiseEpochC;
    SleepStagesC=SleepStagesC3;
    SWSEpochC=SWSEpochC3;
    REMEpochC=REMEpochC3;
    WakeC=WakeC3;
end

try
load behavResources PreEpoch TimeEndRec tpsdeb tpsfin
tfinR=TimeEndRec*[3600 60 1]';
catch
   tfinR=0; 
end

for ti=1:length(tpsdeb)
    try
    dur(ti)=tpsfin{ti}-tpsdeb{ti};
    tdebR(ti)=tfinR(ti)-dur(ti);
    if ti>1 && tdebR(ti)<=tfinR(ti-1)
        tdebR(ti)=tfinR(ti-1)+1;
    end
        
    end
end
            

EnRem=End(REMEpochC);
SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));

for i=1:length(Start(SleepCycle))
clear DurWAkeSleepCy
    WakeCsc=and(WakeC,subset(SleepCycle,i));
    for j=1:length(Start(WakeCsc))
                if length(Start(subset(WakeCsc,j)))>0
                        DurWAkeSleepCy(j)=(End(subset(WakeCsc,j),'s')-Start(subset(WakeCsc,j),'s'));     
                else
                        DurWAkeSleepCy(j)=0;       
                end
    end   
    try
    [BEw(i),idWake]=max(DurWAkeSleepCy);
    catch
      BEw(i)=0;  
    end
    if BEw(i)>120
    stSlCy(i)=End(subset(WakeC,idWake));        
    enSlCy(i)=End(subset(SleepCycle,i));    
    else
    stSlCy(i)=Start(subset(SleepCycle,i));
    enSlCy(i)=End(subset(SleepCycle,i));    
    end
end

  
for i=1:length(Start(REMEpochC))
dur2(i)=End(subset(REMEpochC,i),'s')-Start(subset(REMEpochC,i),'s');
end

idREMOK=find(dur2>15);
EnRem2=End(subset(REMEpochC,idREMOK));
SleepCycle2=intervalSet(EnRem2(1:end-1),EnRem2(2:end));
idREMOKb=find(dur2>30);
EnRem3=End(subset(REMEpochC,idREMOKb));
SleepCycle3=intervalSet(EnRem3(1:end-1),EnRem3(2:end));
CaracSlCy(1,1)=mean(End(SleepCycle,'s')-Start(SleepCycle,'s'));
CaracSlCy(1,2)=length(Start(SleepCycle));
CaracSlCy(1,3)=mean(diff(Start(SleepCycle,'s')));
CaracSlCy(1,4)=mean(End(SleepCycle2,'s')-Start(SleepCycle2,'s'));
CaracSlCy(1,5)=length(Start(SleepCycle2));
CaracSlCy(1,6)=mean(diff(Start(SleepCycle2,'s')));
CaracSlCy(1,7)=mean(End(SleepCycle3,'s')-Start(SleepCycle3,'s'));
CaracSlCy(1,8)=length(Start(SleepCycle3));
CaracSlCy(1,9)=mean(diff(Start(SleepCycle3,'s')));

% %------------------------------------------------------------------------------------
% % remove short REM !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% REMEpochC=subset(REMEpochC,idREMOK);
% EnRem=End(REMEpochC);
% SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));
% %------------------------------------------------------------------------------------


rem=ts(Start(REMEpochC));
sws=ts(Start(SWSEpochC));
wak=ts(Start(WakeC));

for i=1:length(Start(SleepCycle))

    DurSleepCycle(i)=End(subset(SleepCycle,i),'s')-Start(subset(SleepCycle,i),'s');

    TotalTimeREMPerCycle(i)=(End(and(REMEpochC,subset(SleepCycle,i)),'s')-Start(and(REMEpochC,subset(SleepCycle,i)),'s'));
    RatioTimeREMPerCycle(i)=TotalTimeREMPerCycle(i)/DurSleepCycle(i);
    
    try
    TimeDebRecording(i)=tdebR(1);
    end
    TimeSleepCycle(i)=Start(subset(SleepCycle,i),'s');
    
    NbSWSPerCycle(i)=length(Restrict(sws,subset(SleepCycle,i)));
    if NbSWSPerCycle(i)>1
    MeanTimeSWSPerCycle(i)=nanmean(End(and(SWSEpochC,subset(SleepCycle,i)),'s')-Start(and(SWSEpochC,subset(SleepCycle,i)),'s'));
    TotalTimeSWSPerCycle(i)=nansum(End(and(SWSEpochC,subset(SleepCycle,i)),'s')-Start(and(SWSEpochC,subset(SleepCycle,i)),'s'));
    RatioTimeSWSPerCycle(i)=TotalTimeSWSPerCycle(i)/DurSleepCycle(i);
    elseif NbSWSPerCycle(i)==1
    MeanTimeSWSPerCycle(i)=(End(and(SWSEpochC,subset(SleepCycle,i)),'s')-Start(and(SWSEpochC,subset(SleepCycle,i)),'s'));
    TotalTimeSWSPerCycle(i)=(End(and(SWSEpochC,subset(SleepCycle,i)),'s')-Start(and(SWSEpochC,subset(SleepCycle,i)),'s'));
    RatioTimeSWSPerCycle(i)=TotalTimeSWSPerCycle(i)/DurSleepCycle(i);
    elseif NbSWSPerCycle(i)==0
    MeanTimeSWSPerCycle(i)=0;
    TotalTimeSWSPerCycle(i)=0;
    RatioTimeSWSPerCycle(i)=0;
    end

    NbWakePerCycle(i)=length(Restrict(wak,subset(SleepCycle,i)));
    if NbWakePerCycle(i)>1
    MeanTimeWakePerCycle(i)=nanmean(End(and(WakeC,subset(SleepCycle,i)),'s')-Start(and(WakeC,subset(SleepCycle,i)),'s'));
    TotalTimeWakePerCycle(i)=nansum(End(and(WakeC,subset(SleepCycle,i)),'s')-Start(and(WakeC,subset(SleepCycle,i)),'s'));
    RatioTimeWakePerCycle(i)=TotalTimeWakePerCycle(i)/DurSleepCycle(i);
    elseif NbWakePerCycle(i)==1
    MeanTimeWakePerCycle(i)=(End(and(WakeC,subset(SleepCycle,i)),'s')-Start(and(WakeC,subset(SleepCycle,i)),'s'));
    TotalTimeWakePerCycle(i)=(End(and(WakeC,subset(SleepCycle,i)),'s')-Start(and(WakeC,subset(SleepCycle,i)),'s'));
    RatioTimeWakePerCycle(i)=TotalTimeWakePerCycle(i)/DurSleepCycle(i);
    elseif NbWakePerCycle(i)==0 
    MeanTimeWakePerCycle(i)=0;
    TotalTimeWakePerCycle(i)=0;
    RatioTimeWakePerCycle(i)=0;
    end

end

stsc=Start(SleepCycle);
TimeSleepCycleSec=stsc*1E4;
TimeSleepCycleMin=stsc*1E4/60;


Mat(:,1)=DurSleepCycle;
Mat(:,2)=TimeSleepCycleMin;
Mat(:,3)=TotalTimeREMPerCycle;
Mat(:,4)=RatioTimeREMPerCycle;
Mat(:,5)=NbSWSPerCycle;
Mat(:,6)=MeanTimeSWSPerCycle;
Mat(:,7)=TotalTimeSWSPerCycle;
Mat(:,8)=RatioTimeSWSPerCycle;
Mat(:,9)=NbWakePerCycle;
Mat(:,10)=MeanTimeWakePerCycle;
Mat(:,11)=TotalTimeWakePerCycle;
Mat(:,12)=RatioTimeWakePerCycle;
Mat(:,13)=TimeDebRecording;
Mat(:,14)=TimeSleepCycle;


if plo

    figure('color',[1 1 1])
    subplot(4,3,1), hist(NbWakePerCycle,50), title(num2str(mean(NbWakePerCycle))), xlabel('NbWakePerCycle')
    subplot(4,3,2), hist(NbSWSPerCycle,50), title(num2str(mean(NbSWSPerCycle))), xlabel('NbSWSPerCycle')
    subplot(4,3,3), hist(DurSleepCycle,50), title(num2str(mean(DurSleepCycle))), xlabel('DurSleepCycle')

    subplot(4,3,5), hist(MeanTimeSWSPerCycle,50), title(num2str(mean(MeanTimeSWSPerCycle))), xlabel('MeanTimeSWSPerCycle')
    subplot(4,3,6), hist(MeanTimeWakePerCycle,50), title(num2str(mean(MeanTimeWakePerCycle))), xlabel('MeanTimeWakePerCycle')

    subplot(4,3,7), hist(TotalTimeREMPerCycle,50), title(num2str(mean(TotalTimeREMPerCycle))), xlabel('TotalTimeREMPerCycle')
    subplot(4,3,8), hist(TotalTimeSWSPerCycle,50), title(num2str(mean(TotalTimeSWSPerCycle))), xlabel('TotalTimeSWSPerCycle')
    subplot(4,3,9), hist(TotalTimeWakePerCycle,50), title(num2str(mean(TotalTimeWakePerCycle))), xlabel('TotalTimeWakePerCycle')

    subplot(4,3,10), hist(RatioTimeREMPerCycle,50), title(num2str(mean(RatioTimeREMPerCycle))), xlabel('RatioTimeREMPerCycle')
    subplot(4,3,11), hist(RatioTimeSWSPerCycle,50), title(num2str(mean(RatioTimeSWSPerCycle))), xlabel('RatioTimeSWSPerCycle')
    subplot(4,3,12), hist(RatioTimeWakePerCycle,50), title(num2str(mean(RatioTimeWakePerCycle))), xlabel('RatioTimeWakePerCycle')


    figure('color',[1 1 1])
    subplot(4,3,1), plot(TimeSleepCycleMin,NbWakePerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(NbWakePerCycle))), ylabel('NbWakePerCycle')
    subplot(4,3,2), plot(TimeSleepCycleMin,NbSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(NbSWSPerCycle))), ylabel('NbSWSPerCycle')
    subplot(4,3,3), plot(TimeSleepCycleMin,DurSleepCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(DurSleepCycle))), ylabel('DurSleepCycle')

    subplot(4,3,5), plot(TimeSleepCycleMin,MeanTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(MeanTimeSWSPerCycle))), ylabel('MeanTimeSWSPerCycle')
    subplot(4,3,6), plot(TimeSleepCycleMin,MeanTimeWakePerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(MeanTimeWakePerCycle))), ylabel('MeanTimeWakePerCycle')

    subplot(4,3,7), plot(TimeSleepCycleMin,TotalTimeREMPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(TotalTimeREMPerCycle))), ylabel('TotalTimeREMPerCycle')
    subplot(4,3,8), plot(TimeSleepCycleMin,TotalTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(TotalTimeSWSPerCycle))), ylabel('TotalTimeSWSPerCycle')
    subplot(4,3,9), plot(TimeSleepCycleMin,TotalTimeWakePerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(TotalTimeWakePerCycle))), ylabel('TotalTimeWakePerCycle')

    subplot(4,3,10), plot(TimeSleepCycleMin,RatioTimeREMPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(RatioTimeREMPerCycle))), ylabel('RatioTimeREMPerCycle')
    subplot(4,3,11), plot(TimeSleepCycleMin,RatioTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(RatioTimeSWSPerCycle))), ylabel('RatioTimeSWSPerCycle')
    subplot(4,3,12), plot(TimeSleepCycleMin,RatioTimeWakePerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(RatioTimeWakePerCycle))), ylabel('RatioTimeWakePerCycle')

end

