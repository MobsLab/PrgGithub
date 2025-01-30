clear all,
%close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% EMG
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';



clear emg gam
EpochSizes=[1:0.5:30];
for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi')
    k=1;
    Ep1={REMEpoch,SWSEpoch,Wake};
    Ep1={REMEpoch,SWSEpoch,Wake};
    Ep2={REMEpoch1,SWSEpoch1,Wake1};
    tsdcalc=smooth_ghi;
    Kap(mm)=CohenKappaSleepScoring(Ep1,Ep2,tsdcalc);
    
    StateComp{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
    StateComp{2}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,SWSEpoch))),1); %SS
    StateComp{3}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,Wake))),1); %SW
    StateComp{4}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,REMEpoch))),1); %SR
    StateComp{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
    StateComp{6}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1);%RR
    StateComp{7}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,Wake))),1); %RW
    StateComp{8}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,SWSEpoch))),1); %RS
    StateComp{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake1)),1);
    StateComp{10}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake,Wake1))),1); %WW
    StateComp{11}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,SWSEpoch))),1); %WS
    StateComp{12}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,REMEpoch))),1); %WR
    
    Dur_disagree_S_W{mm} = Stop((and(SWSEpoch,Wake1)),'s')-Start((and(SWSEpoch,Wake1)),'s');
    Dur_disagree_W_S{mm} = Stop((and(SWSEpoch1,Wake)),'s')-Start((and(SWSEpoch1,Wake)),'s');
    
    load('B_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,Spectro{1});
     Spec.Wake.Log(mm,:) = nanmean(log(Data(Restrict(sptsd,Wake1))));
     Spec.REM.Log(mm,:) = nanmean(log(Data(Restrict(sptsd,REMEpoch1))));
     Spec.NREM.Log(mm,:) = nanmean(log(Data(Restrict(sptsd,SWSEpoch1))));

     Spec.Wake.Lin(mm,:) = nanmean((Data(Restrict(sptsd,Wake1))));
     Spec.REM.Lin(mm,:) = nanmean((Data(Restrict(sptsd,REMEpoch1))));
     Spec.NREM.Lin(mm,:) = nanmean((Data(Restrict(sptsd,SWSEpoch1))));
end

fH = Spectro{3};
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview/NewMiceStrains
save('OverlapStateByState_C57Bl6.mat','StateComp','Spec','Kap','fH','Dur_disagree_S_W','Dur_disagree_W_S')

figure

SWSprop=[mean(StateComp{2}./StateComp{1}),mean(StateComp{4}./StateComp{1}),...
    mean(StateComp{3}./StateComp{1})];
REMprop=[mean(StateComp{8}./StateComp{5}),mean(StateComp{6}./StateComp{5}),...
    mean((StateComp{7}./StateComp{5}))];
Wakeprop=[mean(StateComp{11}./StateComp{9}),mean(StateComp{12}./StateComp{9}),...
    mean(StateComp{10}./StateComp{9})];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off

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
