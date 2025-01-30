%ControlDetectionDeltaOnline

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback 

Generate=1;

if Generate
    
Dir=PathForExperimentsDeltaSleepNew('DeltaTone');
a=1;
for i=1:length(Dir.path)
% try
    eval(['cd(Dir.path{',num2str(i),'}'')'])
    disp('*****************************************************')
    pwd

            load EpochToAnalyse
            load DeltaSleepEvent
            detec=ts(DeltaDetect);
            
            if length(Range(Restrict(detec,EpochToAnalyse{1})))>100
            load DownSpk
            load DataPEaverageDeltaPFCx
            load StateEpochSB SWSEpoch REMEpoch Wake
            
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            
            load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP

            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP

            [Mq,Tq]=PlotRipRaw(Qt,Range(Restrict(detec,EpochToAnalyse{1}),'s'),800);close
            
            [Md,Td]=PlotRipRaw(LFPd,Range(Restrict(detec,EpochToAnalyse{1}),'s'),800);close
            [Ms,Ts]=PlotRipRaw(LFPs,Range(Restrict(detec,EpochToAnalyse{1}),'s'),800);close
       
            figure('color',[1 1 1]), 
            subplot(1,3,1), hold on
            plot(MPEaverageDeltaPFCxDeep(:,1),MPEaverageDeltaPFCxDeep(:,2),'k','linewidth',2)
            plot(MPEaverageDeltaPFCxSup(:,1),MPEaverageDeltaPFCxSup(:,2),'r','linewidth',2)
            subplot(1,3,2), hold on
            plot(Md(:,1),Md(:,2),'b','linewidth',2)
            plot(Ms(:,1),Ms(:,2),'m','linewidth',2)
            subplot(1,3,3), hold on
            plot(Md(:,1),Md(:,2),'b','linewidth',2)
            plot(Ms(:,1),Ms(:,2),'m','linewidth',2)
            plot(MPEaverageDeltaPFCxDeep(:,1),MPEaverageDeltaPFCxDeep(:,2),'k','linewidth',2)
            plot(MPEaverageDeltaPFCxSup(:,1),MPEaverageDeltaPFCxSup(:,2),'r','linewidth',2)

          
            DeltaEpoch=intervalSet(Range(Dpfc)-0.3E4,Range(Dpfc)+0.3E4);DeltaEpoch=mergeCloseIntervals(DeltaEpoch,1);
            DetectEpoch=intervalSet(Range(detec)-0.3E4,Range(detec)+0.3E4);DetectEpoch=mergeCloseIntervals(DetectEpoch,1);

            
            [Mdm,Tdm]=PlotRipRaw(LFPd,Range(Restrict(detec,EpochToAnalyse{1}-DeltaEpoch),'s'),800);close
            [Msm,Tsm]=PlotRipRaw(LFPs,Range(Restrict(detec,EpochToAnalyse{1}-DeltaEpoch),'s'),800);close
            
            
            do=ts((Start(Down)+End(Down))/2);
            Res(a,1)=length(Range(Restrict(do,DetectEpoch)))/length(Range(do))*100;
            Res(a,2)=length(Range(Restrict(Dpfc,DetectEpoch)))/length(Range(Dpfc))*100;
            Res(a,3)=length(Range(Restrict(detec,DeltaEpoch)))/length(Range(detec))*100;

            tps=MPEaverageDeltaPFCxDeep(:,1);
            tps2=Md(:,1);
            tps3=Mq(:,1);
            LFPAvDeltaD(a,:)=MPEaverageDeltaPFCxDeep(:,2);
            LFPAvDeltaS(a,:)=MPEaverageDeltaPFCxSup(:,2);
            LFPAvDetectD(a,:)=(Md(:,2));
            LFPAvDetectS(a,:)=(Ms(:,2)); 
            LFPAvDetectMissedD(a,:)=(Mdm(:,2));
            LFPAvDetectMissedS(a,:)=(Msm(:,2));            
            QtDetect(a,:)=(Mq(:,2));  
            
        MiceName{a}=Dir.name{i};
        PathOK{a}=Dir.path{i};

        a=a+1;
            end
            
% end
end

    save DataControlDetectionDeltaOnline

else
    
    load DataControlDetectionDeltaOnline

    
end


temp1=LFPAvDeltaD;
temp2=LFPAvDetectD;
temp3=LFPAvDeltaS;
temp4=LFPAvDetectS;
temp1(isnan(temp1))=[];
temp2(isnan(temp2))=[];
temp3(isnan(temp3))=[];
temp4(isnan(temp4))=[];


[ht,p1]=ttest2(max(temp1'),max(temp2'));
[ht,p2]=ttest2(max(temp3'),max(temp4'));
[ht,p3]=ttest2(min(temp1'),min(temp2'));
[ht,p4]=ttest2(min(temp3'),min(temp4'));




figure('color',[1 1 1])
subplot(1,2,1), PlotErrorBar4(max(LFPAvDeltaD'),max(LFPAvDetectD'),max(LFPAvDeltaS'),max(LFPAvDetectS'),0), ylabel('Delta Wave Peak Amplitude'), xlabel('Offline vs Online'), title(['p= ',num2str(floor(p1*1000)/1000),', p= ',num2str(floor(p2*1000)/1000)])
subplot(1,2,2),PlotErrorBar4(min(LFPAvDeltaD'),min(LFPAvDetectD'),min(LFPAvDeltaS'),min(LFPAvDetectS'),0), ylabel('Delta Wave Through Amplitude'), xlabel('Offline vs Online'),title(['p= ',num2str(floor(p3*1000)/1000),', p= ',num2str(floor(p4*1000)/1000)])

PlotErrorBar3(Res(:,1),Res(:,2),Res(:,3),1,0); ylim([0 100]), xlim([0.3 3.7])
set(gca,'xtick',1:3)
set(gca,'xticklabel',{'Down State detectes' 'Delta detectees' '% Delta parmi detection'})

PlotErrorBar3(Res(:,1),Res(:,2),Res(:,3)); ylim([0 100]), xlim([0.3 3.7])
set(gca,'xtick',1:3)
set(gca,'xticklabel',{'Down State detectes' 'Delta detectees' '% Delta parmi detection'})

figure('color',[1 1 1]), hold on,
plot(tps,LFPAvDeltaD(3,:),'k')
plot(tps2-0.025,LFPAvDetectD(3,:),'b')
plot(tps,LFPAvDeltaS(3,:),'r')
plot(tps2-0.025,LFPAvDetectS(3,:),'m')
title(MiceName{3})
ylim([-1500 2000])
xlim([-0.8 0.8])


figure('color',[1 1 1])
for i=1:10
subplot(2,5,i), hold on,
plot(tps2,LFPAvDetectMissedD(i,:),'k')
plot(tps2,LFPAvDetectD(i,:),'b')
plot(tps2,LFPAvDetectMissedS(i,:),'r')
plot(tps2,LFPAvDetectS(i,:),'m')
title(MiceName{i})
ylim([-1500 2000])
xlim([-0.8 0.8])
end
subplot(2,5,1), ylabel('False positif versus detected')
set(gcf,'position',[ 104         151        1576         854])
 
figure('color',[1 1 1])
for i=1:10
subplot(2,5,i), hold on,
plot(tps,LFPAvDeltaD(i,:),'k')
plot(tps2,LFPAvDetectD(i,:),'b')
plot(tps,LFPAvDeltaS(i,:),'r')
plot(tps2,LFPAvDetectS(i,:),'m')
title(MiceName{i})
ylim([-1500 2000])
xlim([-0.8 0.8])
end
subplot(2,5,1), ylabel('Delta versus detected')
set(gcf,'position',[ 104         151        1576         854])

id=[1:161];
id(145)=[];
id(129)=[];
id(113)=[];
id(97)=[];
id(65)=[];
id(49)=[];
id(33)=[];
id(17)=[];

 figure('color',[1 1 1])
for i=1:10
subplot(1,2,1), hold on,
plot(tps3(id),QtDetect(i,id),'k')
xlim([-0.2 0.2])
subplot(1,2,2), hold on,
plot(tps3(id),QtDetect(i,id)/max(QtDetect(i,id)),'k')
yl=ylim;ylim([0 yl(2)])
end
xlim([-0.2 0.2])


