clear all
%% EMG mice
% EMG
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
filename{m,2}=18;
figure
clear emg gam
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitions.mat','EMGthresh')

EpochSizes=[1:0.5:30];
for mm=1:m
    mm
    cd(filename{mm,1})
    clear Epoch
    load('StateEpochSB.mat','smooth_ghi','Epoch','gamma_thresh')
    load(['LFPData/LFP',num2str(filename{mm,2}),'.mat'])
    
    FilLFP=FilterLFP(LFP,[50 300],1024);
    smootime=3;
    EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    EMGData=Restrict(EMGData,Epoch);
    smooth_ghi=Restrict(smooth_ghi,Epoch);

    WakeEMG=thresholdIntervals(EMGData,exp(EMGthresh{mm}),'Direction','Above');
    WakeGamma=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    TempEp=Or((WakeGamma-WakeEMG),(WakeEMG-WakeGamma));
    denum=(size(Data(Restrict(smooth_ghi,Epoch)),1));
    for Ep=1:length(EpochSizes)
        TempEp2=dropShortIntervals(TempEp,EpochSizes(Ep)*1e4);    
        StateComp2(mm,Ep)=size(Data(Restrict(smooth_ghi,TempEp2)),1)./denum; 
    end
    
end

figure
StateComp3=StateComp2(1:2,:);
StateComp3(3,:)=mean(StateComp2([3,5],:));
StateComp3(4,:)=mean(StateComp2([4,6],:));
plot(EpochSizes,StateComp3,'linewidth',3), hold on
plot(EpochSizes,mean(StateComp3),'k','linewidth',3), hold on
errorbar(EpochSizes,mean(StateComp3),stdError(StateComp3),'k','linewidth',2)
xlabel('Epoch Duration')
ylabel('% disagreement')
xlim([0 31])
save('StateComp.mat','StateComp2')
