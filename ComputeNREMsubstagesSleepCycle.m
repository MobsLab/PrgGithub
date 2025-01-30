% ComputeNREMsubstagesSleepCycle

plo=1;

if 0
    
   % load Sleep244
    
else
    
        [SleepCycle,Mat,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=ComputeSleepCycle(15,1);


        DurSleepCycle=Mat(:,1);
        TimeSleepCycleMin=Mat(:,2);
        TotalTimeREMPerCycle=Mat(:,3);
        RatioTimeREMPerCycle=Mat(:,4);
        NbSWSPerCycle=Mat(:,5);
        MeanTimeSWSPerCycle=Mat(:,6);
        TotalTimeSWSPerCycle=Mat(:,7);
        RatioTimeSWSPerCycle=Mat(:,8);
        NbWakePerCycle=Mat(:,9);
        MeanTimeWakePerCycle=Mat(:,10);
        TotalTimeWakePerCycle=Mat(:,11);
        RatioTimeWakePerCycle=Mat(:,12);


        try
            %need to load the substages of NREM sleep
            load NREMsubstages
            N1;
            N2;
            N3;
        catch
        load StateEpochSB TotalNoiseEpoch
        % dans un dossier particulier
        [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
        %NamesOp={'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'}
        [MATEP,nameEpochs]=DefineSubStages(op,TotalNoiseEpoch);
        N1=MATEP{1};
        N2=MATEP{2};
        N3=MATEP{3};
        save NREMsubstages N1 N2 N3 MATEP nameEpochs op NamesOp Dpfc Epoch noise TotalNoiseEpoch
        end



        rem=ts(Start(REMEpochC));
        wak=ts(Start(WakeC));
        sws=ts(Start(SWSEpochC));
        n1=ts(Start(N1));
        n2=ts(Start(N2));
        n3=ts(Start(N3));




        for i=1:length(Start(SleepCycle))


            NbN1PerCycle(i)=length(Restrict(n1,subset(SleepCycle,i)));
            if NbN1PerCycle(i)>1
            MeanTimeN1PerCycle(i)=nanmean(End(and(N1,subset(SleepCycle,i)),'s')-Start(and(N1,subset(SleepCycle,i)),'s'));
            TotalTimeN1PerCycle(i)=nansum(End(and(N1,subset(SleepCycle,i)),'s')-Start(and(N1,subset(SleepCycle,i)),'s'));
            RatioTimeN1PerCycle(i)=TotalTimeN1PerCycle(i)/DurSleepCycle(i);
            elseif NbN1PerCycle(i)==1
            MeanTimeN1PerCycle(i)=(End(and(N1,subset(SleepCycle,i)),'s')-Start(and(N1,subset(SleepCycle,i)),'s'));
            TotalTimeN1PerCycle(i)=(End(and(N1,subset(SleepCycle,i)),'s')-Start(and(N1,subset(SleepCycle,i)),'s'));
            RatioTimeN1PerCycle(i)=TotalTimeN1PerCycle(i)/DurSleepCycle(i);
            elseif NbN1PerCycle(i)==0
            MeanTimeN1PerCycle(i)=0;
            TotalTimeN1PerCycle(i)=0;
            RatioTimeN1PerCycle(i)=0;
            end

            NbN2PerCycle(i)=length(Restrict(n2,subset(SleepCycle,i)));
            if NbN2PerCycle(i)>1
            MeanTimeN2PerCycle(i)=nanmean(End(and(N2,subset(SleepCycle,i)),'s')-Start(and(N2,subset(SleepCycle,i)),'s'));
            TotalTimeN2PerCycle(i)=nansum(End(and(N2,subset(SleepCycle,i)),'s')-Start(and(N2,subset(SleepCycle,i)),'s'));
            RatioTimeN2PerCycle(i)=TotalTimeN2PerCycle(i)/DurSleepCycle(i);
            elseif NbN2PerCycle(i)==1
            MeanTimeN2PerCycle(i)=(End(and(N2,subset(SleepCycle,i)),'s')-Start(and(N2,subset(SleepCycle,i)),'s'));
            TotalTimeN2PerCycle(i)=(End(and(N2,subset(SleepCycle,i)),'s')-Start(and(N2,subset(SleepCycle,i)),'s'));
            RatioTimeN2PerCycle(i)=TotalTimeN2PerCycle(i)/DurSleepCycle(i);
            elseif NbN2PerCycle(i)==0
            MeanTimeN2PerCycle(i)=0;
            TotalTimeN2PerCycle(i)=0;
            RatioTimeN2PerCycle(i)=0;
            end

            NbN3PerCycle(i)=length(Restrict(n3,subset(SleepCycle,i)));
            if NbN3PerCycle(i)>1
            MeanTimeN3PerCycle(i)=nanmean(End(and(N3,subset(SleepCycle,i)),'s')-Start(and(N3,subset(SleepCycle,i)),'s'));
            TotalTimeN3PerCycle(i)=nansum(End(and(N3,subset(SleepCycle,i)),'s')-Start(and(N3,subset(SleepCycle,i)),'s'));
            RatioTimeN3PerCycle(i)=TotalTimeN3PerCycle(i)/DurSleepCycle(i);
            elseif NbN3PerCycle(i)==1
            MeanTimeN3PerCycle(i)=(End(and(N3,subset(SleepCycle,i)),'s')-Start(and(N3,subset(SleepCycle,i)),'s'));
            TotalTimeN3PerCycle(i)=(End(and(N3,subset(SleepCycle,i)),'s')-Start(and(N3,subset(SleepCycle,i)),'s'));
            RatioTimeN3PerCycle(i)=TotalTimeN3PerCycle(i)/DurSleepCycle(i);
            elseif NbN3PerCycle(i)==0
            MeanTimeN3PerCycle(i)=0;
            TotalTimeN3PerCycle(i)=0;
            RatioTimeN3PerCycle(i)=0;
            end

        end



    
end

if plo

    figure('color',[1 1 1])
    subplot(4,6,1), plot(TimeSleepCycleMin,DurSleepCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(DurSleepCycle))), ylabel('DurSleepCycle')
    subplot(4,6,2), plot(TimeSleepCycleMin,NbSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(NbSWSPerCycle))), ylabel('NbSWSPerCycle')
    subplot(4,6,3), plot(TimeSleepCycleMin,NbN1PerCycle,'.','color',[0.6 0.6 0.6]), title(num2str(nanmean(NbN1PerCycle))), ylabel('NbN1PerCycle')
    subplot(4,6,4), plot(TimeSleepCycleMin,NbN2PerCycle,'.','color',[0.4 0.4 0.4]), title(num2str(nanmean(NbN2PerCycle))), ylabel('NbN2PerCycle')
    subplot(4,6,5), plot(TimeSleepCycleMin,NbN3PerCycle,'.','color',[0.2 0.3 0.3]), title(num2str(nanmean(NbN3PerCycle))), ylabel('NbN3PerCycle')
    subplot(4,6,6), plot(TimeSleepCycleMin,NbWakePerCycle,'b.','markerfacecolor','b'), title(num2str(nanmean(NbWakePerCycle))), ylabel('NbWakePerCycle')
    
    subplot(4,6,8), plot(TimeSleepCycleMin,MeanTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(MeanTimeSWSPerCycle))), ylabel('MeanTimeSWSPerCycle')
    subplot(4,6,9), plot(TimeSleepCycleMin,MeanTimeN1PerCycle,'.','color',[0.6 0.6 0.6]), title(num2str(nanmean(MeanTimeN1PerCycle))), ylabel('MeanTimeN1PerCycle')
    subplot(4,6,10), plot(TimeSleepCycleMin,MeanTimeN2PerCycle,'.','color',[0.4 0.4 0.4]), title(num2str(nanmean(MeanTimeN2PerCycle))), ylabel('MeanTimeN2PerCycle')
    subplot(4,6,11), plot(TimeSleepCycleMin,MeanTimeN3PerCycle,'.','color',[0.2 0.2 0.2]), title(num2str(nanmean(MeanTimeN3PerCycle))), ylabel('MeanTimeN3PerCycle')
    subplot(4,6,12), plot(TimeSleepCycleMin,MeanTimeWakePerCycle,'b.','markerfacecolor','b'), title(num2str(nanmean(MeanTimeWakePerCycle))), ylabel('MeanTimeWakePerCycle')

    subplot(4,6,13), plot(TimeSleepCycleMin,TotalTimeREMPerCycle,'r.','markerfacecolor','r'), title(num2str(nanmean(TotalTimeREMPerCycle))), ylabel('TotalTimeREMPerCycle')
    subplot(4,6,14), plot(TimeSleepCycleMin,TotalTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(TotalTimeSWSPerCycle))), ylabel('TotalTimeSWSPerCycle')
    subplot(4,6,15), plot(TimeSleepCycleMin,TotalTimeN1PerCycle,'.','color',[0.6 0.6 0.6]), title(num2str(nanmean(TotalTimeN1PerCycle))), ylabel('TotalTimeN1PerCycle')
    subplot(4,6,16), plot(TimeSleepCycleMin,TotalTimeN2PerCycle,'.','color',[0.4 0.4 0.4]), title(num2str(nanmean(TotalTimeN2PerCycle))), ylabel('TotalTimeN2PerCycle')
    subplot(4,6,17), plot(TimeSleepCycleMin,TotalTimeN3PerCycle,'.','color',[0.2 0.2 0.2]), title(num2str(nanmean(TotalTimeN3PerCycle))), ylabel('TotalTimeN3PerCycle')
    subplot(4,6,18), plot(TimeSleepCycleMin,TotalTimeWakePerCycle,'b.','markerfacecolor','b'), title(num2str(nanmean(TotalTimeWakePerCycle))), ylabel('TotalTimeWakePerCycle')

    subplot(4,6,19), plot(TimeSleepCycleMin,RatioTimeREMPerCycle,'r.','markerfacecolor','r'), title(num2str(nanmean(RatioTimeREMPerCycle))), ylabel('RatioTimeREMPerCycle')
    subplot(4,6,20), plot(TimeSleepCycleMin,RatioTimeSWSPerCycle,'k.','markerfacecolor','k'), title(num2str(nanmean(RatioTimeSWSPerCycle))), ylabel('RatioTimeSWSPerCycle')
    subplot(4,6,21), plot(TimeSleepCycleMin,RatioTimeN1PerCycle,'.','color',[0.6 0.6 0.6]), title(num2str(nanmean(RatioTimeN1PerCycle))), ylabel('RatioTimeN1PerCycle')
    subplot(4,6,22), plot(TimeSleepCycleMin,RatioTimeN2PerCycle,'.','color',[0.4 0.4 0.4]), title(num2str(nanmean(RatioTimeN2PerCycle))), ylabel('RatioTimeN2PerCycle')
    subplot(4,6,23), plot(TimeSleepCycleMin,RatioTimeN3PerCycle,'.','color',[0.2 0.2 0.2]), title(num2str(nanmean(RatioTimeN3PerCycle))), ylabel('RatioTimeN3PerCycle')
    subplot(4,6,24), plot(TimeSleepCycleMin,RatioTimeWakePerCycle,'b.','markerfacecolor','b'), title(num2str(nanmean(RatioTimeWakePerCycle))), ylabel('RatioTimeWakePerCycle')

end

    
    