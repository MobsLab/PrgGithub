%% Used for draft 11th april
clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% EMG
m=1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse573/20171221-BasalSleepDay';
% filename{m,2}=9;

figure
clear emg gam
EpochSizes=[1:0.5:30];
for mm=1:3
    mm
    cd(filename{mm})
    load('StateEpochEMGSB.mat','REMEpoch','SWSEpoch','Wake')
    REMEpoch1= REMEpoch;
    SWSEpoch1=SWSEpoch;
    Wake1= Wake;
    
    load('SleepScoring_Accelero.mat','REMEpoch','SWSEpoch','Wake')
    REMEpoch2= REMEpoch;
    SWSEpoch2=SWSEpoch;
    Wake2= Wake;
    
    
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch','smooth_ghi')
    k=1;
    Ep1={REMEpoch,SWSEpoch,Wake};
    Ep1={REMEpoch,SWSEpoch,Wake};
    Ep2={REMEpoch1,SWSEpoch1,Wake1};
    tsdcalc=smooth_ghi;
    Kap(mm)=CohenKappaSleepScoring(Ep1,Ep2,tsdcalc);
    
    StateComp_EMG_OB{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
    StateComp_EMG_OB{2}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,SWSEpoch))),1); %SS
    StateComp_EMG_OB{3}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,Wake))),1); %SW
    StateComp_EMG_OB{4}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,REMEpoch))),1); %SR
    StateComp_EMG_OB{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
    StateComp_EMG_OB{6}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1);%RR
    StateComp_EMG_OB{7}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,Wake))),1); %RW
    StateComp_EMG_OB{8}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,SWSEpoch))),1); %RS
    StateComp_EMG_OB{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake1)),1);
    StateComp_EMG_OB{10}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake,Wake1))),1); %WW
    StateComp_EMG_OB{11}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,SWSEpoch))),1); %WS
    StateComp_EMG_OB{12}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,REMEpoch))),1); %WR
    
    StateComp_Acc_OB{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch2)),1);
    StateComp_Acc_OB{2}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,SWSEpoch))),1); %SS
    StateComp_Acc_OB{3}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,Wake))),1); %SW
    StateComp_Acc_OB{4}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,REMEpoch))),1); %SR
    StateComp_Acc_OB{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch2)),1);
    StateComp_Acc_OB{6}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,REMEpoch))),1);%RR
    StateComp_Acc_OB{7}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,Wake))),1); %RW
    StateComp_Acc_OB{8}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,SWSEpoch))),1); %RS
    StateComp_Acc_OB{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake2)),1);
    StateComp_Acc_OB{10}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake,Wake2))),1); %WW
    StateComp_Acc_OB{11}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake2,SWSEpoch))),1); %WS
    StateComp_Acc_OB{12}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake2,REMEpoch))),1); %WR
    
    StateComp_Acc_EMG{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch2)),1);
    StateComp_Acc_EMG{2}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,SWSEpoch1))),1); %SS
    StateComp_Acc_EMG{3}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,Wake1))),1); %SW
    StateComp_Acc_EMG{4}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch2,REMEpoch1))),1); %SR
    StateComp_Acc_EMG{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch2)),1);
    StateComp_Acc_EMG{6}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,REMEpoch1))),1);%RR
    StateComp_Acc_EMG{7}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,Wake1))),1); %RW
    StateComp_Acc_EMG{8}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch2,SWSEpoch1))),1); %RS
    StateComp_Acc_EMG{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake2)),1);
    StateComp_Acc_EMG{10}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,Wake2))),1); %WW
    StateComp_Acc_EMG{11}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake2,SWSEpoch1))),1); %WS
    StateComp_Acc_EMG{12}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake2,REMEpoch1))),1); %WR
end

figure
subplot(131)
SWSprop=[nanmean(StateComp_EMG_OB{2}./StateComp_EMG_OB{1}),nanmean(StateComp_EMG_OB{4}./StateComp_EMG_OB{1}),...
    nanmean(StateComp_EMG_OB{3}./StateComp_EMG_OB{1})];
REMprop=[nanmean(StateComp_EMG_OB{8}./StateComp_EMG_OB{5}),nanmean(StateComp_EMG_OB{6}./StateComp_EMG_OB{5}),...
    nanmean((StateComp_EMG_OB{7}./StateComp_EMG_OB{5}))];
Wakeprop=[nanmean(StateComp_EMG_OB{11}./StateComp_EMG_OB{9}),nanmean(StateComp_EMG_OB{12}./StateComp_EMG_OB{9}),...
    nanmean(StateComp_EMG_OB{10}./StateComp_EMG_OB{9})];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
title('EMG vs OB')


subplot(132)
SWSprop=[nanmean(StateComp_Acc_OB{2}./StateComp_Acc_OB{1}),nanmean(StateComp_Acc_OB{4}./StateComp_Acc_OB{1}),...
    nanmean(StateComp_Acc_OB{3}./StateComp_Acc_OB{1})];
REMprop=[nanmean(StateComp_Acc_OB{8}./StateComp_Acc_OB{5}),nanmean(StateComp_Acc_OB{6}./StateComp_Acc_OB{5}),...
    nanmean((StateComp_Acc_OB{7}./StateComp_Acc_OB{5}))];
Wakeprop=[nanmean(StateComp_Acc_OB{11}./StateComp_Acc_OB{9}),nanmean(StateComp_Acc_OB{12}./StateComp_Acc_OB{9}),...
    nanmean(StateComp_Acc_OB{10}./StateComp_Acc_OB{9})];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
title('Acc vs OB')


subplot(133)
SWSprop=[nanmean(StateComp_Acc_EMG{2}./StateComp_Acc_EMG{1}),nanmean(StateComp_Acc_EMG{4}./StateComp_Acc_EMG{1}),...
    nanmean(StateComp_Acc_EMG{3}./StateComp_Acc_EMG{1})];
REMprop=[nanmean(StateComp_Acc_EMG{8}./StateComp_Acc_EMG{5}),nanmean(StateComp_Acc_EMG{6}./StateComp_Acc_EMG{5}),...
    nanmean((StateComp_Acc_EMG{7}./StateComp_Acc_EMG{5}))];
Wakeprop=[nanmean(StateComp_Acc_EMG{11}./StateComp_Acc_EMG{9}),nanmean(StateComp_Acc_EMG{12}./StateComp_Acc_EMG{9}),...
    nanmean(StateComp_Acc_EMG{10}./StateComp_Acc_EMG{9})];

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
title('Acc vs EMG')

