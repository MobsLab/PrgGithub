% ParcoursCompareDeltaWaveformsAllEpoch2016

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
exp='Basal';
err=4;

for mouse=[293 294 296 243 244 251];
    Dir=PathForExperimentsDeltaSleepKJ_062016(exp);
    disp(' ')
    disp('**********************************************************************************************')
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    disp('**********************************************************************************************')
    disp(' ')

    a=1;
    figure('color',[1 1 1]),
    for i=1:length(Dir.path)
        siz=length(Dir.path);
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(' ')
        disp('**********************************************************************************************')
        disp(pwd)
        disp('**********************************************************************************************')
        disp(' ')
        
        load newDeltaPFCx
        Dpfc=ts(tDelta);
        DeltaEpoch1=0;
        DeltaEpoch5=0;
        
        load StateEpochSB
        load EpochToAnalyse
        for i=1:5
            EpochToAnalyseSWS{i}=and(EpochToAnalyse{i},SWSEpoch);
        end
 
        % Delta Quantity during 5 Time Epoch
        QtDelta(1)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{1})));
        QtDelta(2)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{2})));
        QtDelta(3)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{3})));
        QtDelta(4)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{4})));
        QtDelta(5)=length(Range(Restrict(Dpfc,EpochToAnalyseSWS{5})));
        % SWS Quantity  during 5 Time Epoch
        QtSWS(1)=sum(End(and(EpochToAnalyse{1},SWSEpoch),'s')-Start(and(EpochToAnalyse{1},SWSEpoch),'s'));
        QtSWS(2)=sum(End(and(EpochToAnalyse{2},SWSEpoch),'s')-Start(and(EpochToAnalyse{2},SWSEpoch),'s'));
        QtSWS(3)=sum(End(and(EpochToAnalyse{3},SWSEpoch),'s')-Start(and(EpochToAnalyse{3},SWSEpoch),'s'));
        QtSWS(4)=sum(End(and(EpochToAnalyse{4},SWSEpoch),'s')-Start(and(EpochToAnalyse{4},SWSEpoch),'s'));
        QtSWS(5)=sum(End(and(EpochToAnalyse{5},SWSEpoch),'s')-Start(and(EpochToAnalyse{5},SWSEpoch),'s'));
        % Delta Occurence during 5 Time Epoch
        FqDelta(1)=QtDelta(1)./QtSWS(1);
        FqDelta(2)=QtDelta(2)./QtSWS(2);
        FqDelta(3)=QtDelta(3)./QtSWS(3);
        FqDelta(4)=QtDelta(4)./QtSWS(4);
        FqDelta(5)=QtDelta(5)./QtSWS(5);
        
        
        % Data genesis for Delta Waveform during 5 Time Epoch
        try
            load DeltaPFCxWaveforms_AllEpoch
        catch
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            eegDeep=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            eegSup=LFP;
            clear LFP
            
            t1=Range(Restrict(Dpfc,EpochToAnalyse{1}),'s');
            t2=Range(Restrict(Dpfc,EpochToAnalyse{2}),'s');
            t3=Range(Restrict(Dpfc,EpochToAnalyse{3}),'s');
            t4=Range(Restrict(Dpfc,EpochToAnalyse{4}),'s');
            t5=Range(Restrict(Dpfc,EpochToAnalyse{5}),'s');
            
            [MPEAverageDeltaPFCxDeep_Epoch1,TPEAverageDeltaPFCxDeep_Epoch1]=PlotRipRaw(eegDeep,t1,1000);close
            [MPEAverageDeltaPFCxSup_Epoch1,TPEAverageDeltaPFCxSup_Epoch1]=PlotRipRaw(eegSup,t1,1000);close
            [MPEAverageDeltaPFCxDeep_Epoch2,TPEAverageDeltaPFCxDeep_Epoch2]=PlotRipRaw(eegDeep,t2,1000);close
            [MPEAverageDeltaPFCxSup_Epoch2,TPEAverageDeltaPFCxSup_Epoch2]=PlotRipRaw(eegSup,t2,1000);close
            [MPEAverageDeltaPFCxDeep_Epoch3,TPEAverageDeltaPFCxDeep_Epoch3]=PlotRipRaw(eegDeep,t3,1000);close
            [MPEAverageDeltaPFCxSup_Epoch3,TPEAverageDeltaPFCxSup_Epoch3]=PlotRipRaw(eegSup,t3,1000);close
            [MPEAverageDeltaPFCxDeep_Epoch4,TPEAverageDeltaPFCxDeep_Epoch4]=PlotRipRaw(eegDeep,t4,1000);close
            [MPEAverageDeltaPFCxSup_Epoch4,TPEAverageDeltaPFCxSup_Epoch4]=PlotRipRaw(eegSup,t4,1000);close
            [MPEAverageDeltaPFCxDeep_Epoch5,TPEAverageDeltaPFCxDeep_Epoch5]=PlotRipRaw(eegDeep,t5,1000);close
            [MPEAverageDeltaPFCxSup_Epoch5,TPEAverageDeltaPFCxSup_Epoch5]=PlotRipRaw(eegSup,t5,1000);close
            
            save DeltaPFCxWaveforms_AllEpoch MPEAverageDeltaPFCxDeep_Epoch1 TPEAverageDeltaPFCxDeep_Epoch1  MPEAverageDeltaPFCxSup_Epoch1 TPEAverageDeltaPFCxSup_Epoch1
            save DeltaPFCxWaveforms_AllEpoch -append MPEAverageDeltaPFCxDeep_Epoch2 TPEAverageDeltaPFCxDeep_Epoch2 MPEAverageDeltaPFCxSup_Epoch2 TPEAverageDeltaPFCxSup_Epoch2
            save DeltaPFCxWaveforms_AllEpoch -append MPEAverageDeltaPFCxDeep_Epoch3 TPEAverageDeltaPFCxDeep_Epoch3 MPEAverageDeltaPFCxSup_Epoch3 TPEAverageDeltaPFCxSup_Epoch3
            save DeltaPFCxWaveforms_AllEpoch -append MPEAverageDeltaPFCxDeep_Epoch4 TPEAverageDeltaPFCxDeep_Epoch4 MPEAverageDeltaPFCxSup_Epoch4 TPEAverageDeltaPFCxSup_Epoch4
            save DeltaPFCxWaveforms_AllEpoch -append MPEAverageDeltaPFCxDeep_Epoch5 TPEAverageDeltaPFCxDeep_Epoch5 MPEAverageDeltaPFCxSup_Epoch5 TPEAverageDeltaPFCxSup_Epoch5
        end
        
%         % Mean amplitude superficial and deep layer for Tone vs NoTone Delta Waves
%         Mean_dPFCxDeep_BegSleep=nanmean(TPEAverageDeltaPFCxDeep_Epoch2(:,:));
%         Mean_dPFCxDeep_EndSleep=nanmean(TPEAverageDeltaPFCxDeep_Epoch5(:,:));
%         Mean_dPFCxSup_BegSleep=nanmean(TPEAverageDeltaPFCxSup_Epoch2(:,:));
%         Mean_dPFCxSup_EndSleep=nanmean(TPEAverageDeltaPFCxSup_Epoch5(:,:));
%         
        
        
        %-------------------------------------------------------------------------------------------------------------------------------------
        %-------------------------------------------------------------------------------------------------------------------------------------
        
        % Plotting of Delta Waveform during 5 Time Epoch (sup layer)
        subplot(4,siz,a), hold on
        if ~isempty(MPEAverageDeltaPFCxSup_Epoch1)
            DeltaEpoch1=1;
            plot(MPEAverageDeltaPFCxSup_Epoch1(:,1),MPEAverageDeltaPFCxSup_Epoch1(:,2),'r','linewidth',2)
            plot(MPEAverageDeltaPFCxSup_Epoch1(:,1),MPEAverageDeltaPFCxSup_Epoch1(:,2)+MPEAverageDeltaPFCxSup_Epoch1(:,err),'r','linewidth',1)
            plot(MPEAverageDeltaPFCxSup_Epoch1(:,1),MPEAverageDeltaPFCxSup_Epoch1(:,2)-MPEAverageDeltaPFCxSup_Epoch1(:,err),'r','linewidth',1)
            ymax=max(MPEAverageDeltaPFCxSup_Epoch1(:,2))+200; ymin=min(MPEAverageDeltaPFCxSup_Epoch1(:,2)-200);
            hold on, axis([-0.75 0.75 ymin ymax])
        end
        plot(MPEAverageDeltaPFCxSup_Epoch2(:,1),MPEAverageDeltaPFCxSup_Epoch2(:,2),'m','linewidth',2)
        plot(MPEAverageDeltaPFCxSup_Epoch2(:,1),MPEAverageDeltaPFCxSup_Epoch2(:,2)+MPEAverageDeltaPFCxSup_Epoch2(:,err),'m','linewidth',1)
        plot(MPEAverageDeltaPFCxSup_Epoch2(:,1),MPEAverageDeltaPFCxSup_Epoch2(:,2)-MPEAverageDeltaPFCxSup_Epoch2(:,err),'m','linewidth',1)
        plot(MPEAverageDeltaPFCxSup_Epoch3(:,1),MPEAverageDeltaPFCxSup_Epoch3(:,2),'c','linewidth',2)
        plot(MPEAverageDeltaPFCxSup_Epoch3(:,1),MPEAverageDeltaPFCxSup_Epoch3(:,2)+MPEAverageDeltaPFCxSup_Epoch3(:,err),'c','linewidth',1)
        plot(MPEAverageDeltaPFCxSup_Epoch3(:,1),MPEAverageDeltaPFCxSup_Epoch3(:,2)-MPEAverageDeltaPFCxSup_Epoch3(:,err),'c','linewidth',1)
        plot(MPEAverageDeltaPFCxSup_Epoch4(:,1),MPEAverageDeltaPFCxSup_Epoch4(:,2),'b','linewidth',2)
        plot(MPEAverageDeltaPFCxSup_Epoch4(:,1),MPEAverageDeltaPFCxSup_Epoch4(:,2)+MPEAverageDeltaPFCxSup_Epoch4(:,err),'b','linewidth',1)
        plot(MPEAverageDeltaPFCxSup_Epoch4(:,1),MPEAverageDeltaPFCxSup_Epoch4(:,2)-MPEAverageDeltaPFCxSup_Epoch4(:,err),'b','linewidth',1)
        hold on, title(['Sup Layer - M#',num2str(mouse)])
        if ~isempty(MPEAverageDeltaPFCxSup_Epoch5)
            DeltaEpoch5=1;            
            plot(MPEAverageDeltaPFCxSup_Epoch5(:,1),MPEAverageDeltaPFCxSup_Epoch5(:,2),'k','linewidth',2)
            plot(MPEAverageDeltaPFCxSup_Epoch5(:,1),MPEAverageDeltaPFCxSup_Epoch5(:,2)+MPEAverageDeltaPFCxSup_Epoch5(:,err),'k','linewidth',1)
            plot(MPEAverageDeltaPFCxSup_Epoch5(:,1),MPEAverageDeltaPFCxSup_Epoch5(:,2)-MPEAverageDeltaPFCxSup_Epoch5(:,err),'k','linewidth',1)
            ymax=max(MPEAverageDeltaPFCxSup_Epoch5(:,2))+200; ymin=min(MPEAverageDeltaPFCxSup_Epoch5(:,2)-200);
            hold on, axis([-0.75 0.75 ymin ymax])
        end
        
        % Plotting of Delta Waveform during 5 Time Epoch (deep layer)
        subplot(4,siz,a+siz), hold on
        if ~isempty(MPEAverageDeltaPFCxDeep_Epoch1)
            plot(MPEAverageDeltaPFCxDeep_Epoch1(:,1),MPEAverageDeltaPFCxDeep_Epoch1(:,2),'r','linewidth',2)
            plot(MPEAverageDeltaPFCxDeep_Epoch1(:,1),MPEAverageDeltaPFCxDeep_Epoch1(:,2)+MPEAverageDeltaPFCxDeep_Epoch1(:,err),'r','linewidth',1)
            plot(MPEAverageDeltaPFCxDeep_Epoch1(:,1),MPEAverageDeltaPFCxDeep_Epoch1(:,2)-MPEAverageDeltaPFCxDeep_Epoch1(:,err),'r','linewidth',1)
            ymax=max(MPEAverageDeltaPFCxDeep_Epoch1(:,2))+200; ymin=min(MPEAverageDeltaPFCxDeep_Epoch1(:,2)-200);
            hold on, axis([-0.75 0.75 ymin ymax])
        end
        plot(MPEAverageDeltaPFCxDeep_Epoch2(:,1),MPEAverageDeltaPFCxDeep_Epoch2(:,2),'m','linewidth',2)
        plot(MPEAverageDeltaPFCxDeep_Epoch2(:,1),MPEAverageDeltaPFCxDeep_Epoch2(:,2)+MPEAverageDeltaPFCxDeep_Epoch2(:,err),'m','linewidth',1)
        plot(MPEAverageDeltaPFCxDeep_Epoch2(:,1),MPEAverageDeltaPFCxDeep_Epoch2(:,2)-MPEAverageDeltaPFCxDeep_Epoch2(:,err),'m','linewidth',1)
        plot(MPEAverageDeltaPFCxDeep_Epoch3(:,1),MPEAverageDeltaPFCxDeep_Epoch3(:,2),'c','linewidth',2)
        plot(MPEAverageDeltaPFCxDeep_Epoch3(:,1),MPEAverageDeltaPFCxDeep_Epoch3(:,2)+MPEAverageDeltaPFCxDeep_Epoch3(:,err),'c','linewidth',1)
        plot(MPEAverageDeltaPFCxDeep_Epoch3(:,1),MPEAverageDeltaPFCxDeep_Epoch3(:,2)-MPEAverageDeltaPFCxDeep_Epoch3(:,err),'c','linewidth',1)
        plot(MPEAverageDeltaPFCxDeep_Epoch4(:,1),MPEAverageDeltaPFCxDeep_Epoch4(:,2),'b','linewidth',2)
        plot(MPEAverageDeltaPFCxDeep_Epoch4(:,1),MPEAverageDeltaPFCxDeep_Epoch4(:,2)+MPEAverageDeltaPFCxDeep_Epoch4(:,err),'b','linewidth',1)
        plot(MPEAverageDeltaPFCxDeep_Epoch4(:,1),MPEAverageDeltaPFCxDeep_Epoch4(:,2)-MPEAverageDeltaPFCxDeep_Epoch4(:,err),'b','linewidth',1)
        hold on, title(['Deep Layer - M#',num2str(mouse)])
        if ~isempty(MPEAverageDeltaPFCxDeep_Epoch5)
            plot(MPEAverageDeltaPFCxDeep_Epoch5(:,1),MPEAverageDeltaPFCxDeep_Epoch5(:,2),'k','linewidth',2)
            plot(MPEAverageDeltaPFCxDeep_Epoch5(:,1),MPEAverageDeltaPFCxDeep_Epoch5(:,2)+MPEAverageDeltaPFCxDeep_Epoch5(:,err),'k','linewidth',1)
            plot(MPEAverageDeltaPFCxDeep_Epoch5(:,1),MPEAverageDeltaPFCxDeep_Epoch5(:,2)-MPEAverageDeltaPFCxDeep_Epoch5(:,err),'k','linewidth',1)
            ymax=max(MPEAverageDeltaPFCxDeep_Epoch5(:,2))+200; ymin=min(MPEAverageDeltaPFCxDeep_Epoch5(:,2)-200);
            hold on, axis([-0.75 0.75 ymin ymax])
        end
        
        % Plotting of Delta Waveform Difference during 5 Time Epoch (deep layer)
        subplot(4,siz,a+(2*siz))
        if DeltaEpoch1==1 && DeltaEpoch5==1
            hold on, plot(MPEAverageDeltaPFCxDeep_Epoch1(:,1),abs(((MPEAverageDeltaPFCxDeep_Epoch1(:,2)-MPEAverageDeltaPFCxDeep_Epoch5(:,2))/MPEAverageDeltaPFCxDeep_Epoch1(:,2))*100),'k','linewidth',2)
            hold on, plot(MPEAverageDeltaPFCxSup_Epoch1(:,1),abs(((MPEAverageDeltaPFCxSup_Epoch1(:,2)-MPEAverageDeltaPFCxSup_Epoch5(:,2))/MPEAverageDeltaPFCxSup_Epoch1(:,2))*100),'r','linewidth',2)
            hold on, title('Deep (k) & Sup(r) Diff Start/End Sleep')
            hold on, ylabel('Start - End (% Amplitude)')
        end
        if DeltaEpoch1==0 && DeltaEpoch5==1
            hold on, plot(MPEAverageDeltaPFCxDeep_Epoch5(:,1),abs(((MPEAverageDeltaPFCxDeep_Epoch2(:,2)-MPEAverageDeltaPFCxDeep_Epoch5(:,2))/MPEAverageDeltaPFCxDeep_Epoch2(:,2))*100),'k','linewidth',2)
            hold on, plot(MPEAverageDeltaPFCxSup_Epoch5(:,1),abs(((MPEAverageDeltaPFCxSup_Epoch2(:,2)-MPEAverageDeltaPFCxSup_Epoch5(:,2))/MPEAverageDeltaPFCxSup_Epoch2(:,2))*100),'r','linewidth',2)
            hold on, title('Deep (k) & Sup(r) Diff Start/End Sleep')
            hold on, ylabel('Start - End (% Amplitude)')
        end
        if DeltaEpoch1==1 && DeltaEpoch5==0
            hold on, plot(MPEAverageDeltaPFCxDeep_Epoch1(:,1),abs(((MPEAverageDeltaPFCxDeep_Epoch1(:,2)-MPEAverageDeltaPFCxDeep_Epoch4(:,2))/MPEAverageDeltaPFCxDeep_Epoch1(:,2))*100),'k','linewidth',2)
            hold on, plot(MPEAverageDeltaPFCxSup_Epoch1(:,1),abs(((MPEAverageDeltaPFCxSup_Epoch1(:,2)-MPEAverageDeltaPFCxSup_Epoch4(:,2))/MPEAverageDeltaPFCxSup_Epoch1(:,2))*100),'r','linewidth',2)
            hold on, title('Deep (k) & Sup(r) Diff Start/End Sleep')
            hold on, ylabel('Start - End (% Amplitude)')
        end
        
        % Plotting of Delta Waveform during 5 Time Epoch (deep layer)
        subplot(4,siz,a+(3*siz)), PlotErrorBarN(FqDelta,0);title('Fq Delta Pfc'),

        a=a+1;
    end
end

%         DataDeep_BegSleep=[TPEAverageDeltaPFCxDeep_Epoch1(:,1050:end);TPEAverageDeltaPFCxDeep_Epoch2(:,1050:end)];
%         DataDeep_EndSleep=TPEAverageDeltaPFCxDeep_Epoch5(:,1050:end);
%         DataSup_BegSleep=[TPEAverageDeltaPFCxSup_Epoch1(:,1050:end);TPEAverageDeltaPFCxSup_Epoch2(:,1050:end)];
%         DataSup_EndSleep=TPEAverageDeltaPFCxSup_Epoch5(:,1050:end);
%         temp1(isnan(DataDeep_BegSleep))=[];
%         temp2(isnan(DataDeep_EndSleep))=[];
%         temp3(isnan(DataSup_BegSleep))=[];
%         temp4(isnan(DataSup_EndSleep))=[];
%         
%         [ht,p1]=ttest2(max(temp1'),max(temp2'));
%         [ht,p2]=ttest2(max(temp3'),max(temp4'));
%         [ht,p3]=ttest2(min(temp1'),min(temp2'));
%         [ht,p4]=ttest2(min(temp3'),min(temp4'));
       
%         %  Mean amplitude superficial and deep layer
%         subplot(5,siz,a+(3*siz))
%         hold on, PlotErrorBar4(max(Mean_dPFCxDeep_BegSleep'),max(Mean_dPFCxDeep_EndSleep'),max(Mean_dPFCxDeep_BegSleep'),max(Mean_dPFCxDeep_EndSleep'),0), ylabel('Delta Wave Peak'), xlabel('Start vs End'), 
%         subplot(5,siz,a+(4*siz))
%         hold on, PlotErrorBar4(min(Mean_dPFCxDeep_BegSleep'),min(Mean_dPFCxDeep_EndSleep'),min(Mean_dPFCxDeep_BegSleep'),min(Mean_dPFCxDeep_EndSleep'),0), ylabel('Delta Wave Through'), xlabel('Start vs End')

