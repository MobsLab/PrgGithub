% ParcoursCompareDeltaBurstNoBurst2016

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  

% exp='DeltaTone';
% exp='RdmTone';
exp='Basal';

Generate=1;

if Generate
    
    Dir=PathForExperimentsDeltaSleep2016(exp);
    
    a=1;
    for i=1:length(Dir.path)

        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        
        
        
        load newDeltaPFCx
        Dpfc=ts(tDelta);
        
        try
            load DataPEaverageDeltaPFCx
            MPEaverageDeltaPFCxDeep;
        catch
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP
            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP
            [MPEaverageDeltaPFCxDeep,TPEaverageDeltaPFCxDeep]=PlotRipRaw(LFPd,Range(Dpfc)/1E4,1000);close
            [MPEaverageDeltaPFCxSup,TPEaverageDeltaPFCxSup]=PlotRipRaw(LFPs,Range(Dpfc)/1E4,1000);close
            save DataPEaverageDeltaPFCx MPEaverageDeltaPFCxDeep TPEaverageDeltaPFCxDeep MPEaverageDeltaPFCxSup TPEaverageDeltaPFCxSup
        end
        
        
        tps=MPEaverageDeltaPFCxDeep(:,1);
        
        load StateEpochSB SWSEpoch
        limIntDown=0.6;
        [BurstDeltaEpochB,NbDB]=FindDeltaBurst2(Dpfc,limIntDown,1);
        
        [BE,dpfcBurst]=Restrict(Dpfc,BurstDeltaEpochB);
        [BE,dpfcNoBurst]=Restrict(Dpfc,SWSEpoch-BurstDeltaEpochB);
        
        figure('color',[1 1 1]), hold on
        plot(tps,nanmean(TPEaverageDeltaPFCxDeep(dpfcNoBurst,:)),'k')
        plot(tps,nanmean(TPEaverageDeltaPFCxSup(dpfcNoBurst,:)),'r')
        plot(tps,nanmean(TPEaverageDeltaPFCxDeep(dpfcBurst,:)),'b')
        plot(tps,nanmean(TPEaverageDeltaPFCxSup(dpfcBurst,:)),'m')
        title([Dir.name{i},' No Burst vs Burst'])
        
        TPEaverageDeltaPFCxDeepNoBurst(a,:)=nanmean(TPEaverageDeltaPFCxDeep(dpfcNoBurst,:));
        TPEaverageDeltaPFCxSupNoBurst(a,:)=nanmean(TPEaverageDeltaPFCxSup(dpfcNoBurst,:));
        TPEaverageDeltaPFCxDeepBurst(a,:)=nanmean(TPEaverageDeltaPFCxDeep(dpfcBurst,:));
        TPEaverageDeltaPFCxSupBurst(a,:)=nanmean(TPEaverageDeltaPFCxSup(dpfcBurst,:));
        
        
        
        MiceName{a}=Dir.name{i};
        PathOK{a}=Dir.path{i};
        
        a=a+1;
        
    end
    
      
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback    
eval(['save DataParcoursCompareDeltaBurstNoBurst2016',exp])

else
    
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
    eval(['load DataParcoursCompareDeltaBurstNoBurst2016',exp])
end

temp1=TPEaverageDeltaPFCxDeepNoBurst(:,1050:end);
temp2=TPEaverageDeltaPFCxDeepBurst(:,1050:end);
temp3=TPEaverageDeltaPFCxSupNoBurst(:,1050:end);
temp4=TPEaverageDeltaPFCxSupBurst(:,1050:end);

temp1(isnan(temp1))=[];
temp2(isnan(temp2))=[];
temp3(isnan(temp3))=[];
temp4(isnan(temp4))=[];

[ht,p1]=ttest2(max(temp1'),max(temp2'));
[ht,p2]=ttest2(max(temp3'),max(temp4'));
[ht,p3]=ttest2(min(temp1'),min(temp2'));
[ht,p4]=ttest2(min(temp3'),min(temp4'));


figure('color',[1 1 1])
subplot(1,2,1), PlotErrorBar4(max(TPEaverageDeltaPFCxDeepNoBurst'),max(TPEaverageDeltaPFCxDeepBurst'),max(TPEaverageDeltaPFCxSupNoBurst'),max(TPEaverageDeltaPFCxSupBurst'),0), ylabel('Delta Wave Peak Amplitude'), xlabel('No Burst vs Burst'), title(['p= ',num2str(floor(p1*100)/100),', p= ',num2str(floor(p2*100)/100)])
subplot(1,2,2),PlotErrorBar4(min(TPEaverageDeltaPFCxDeepNoBurst'),min(TPEaverageDeltaPFCxDeepBurst'),min(TPEaverageDeltaPFCxSupNoBurst'),min(TPEaverageDeltaPFCxSupBurst'),0), ylabel('Delta Wave Through Amplitude'), xlabel('No Burst vs Burst'),title(['p= ',num2str(floor(p3*100)/100),', p= ',num2str(floor(p4*100)/100)])


