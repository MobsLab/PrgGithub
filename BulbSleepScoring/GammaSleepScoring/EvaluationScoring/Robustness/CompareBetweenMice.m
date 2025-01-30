clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% m=1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130729/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/01042015/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
% m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/22052015/';

AllSlScoringMice

for mm=9:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    
    TotNoiseEpoch=or(NoiseEpoch,GndNoiseEpoch);
    try
        TotNoiseEpoch=or(TotNoiseEpoch,WeirdNoiseEpoch)
    end
    r=Range(smooth_ghi);
    TotalEpoch=intervalSet(0*1e4,r(end));
    TotalEpoch=TotalEpoch-TotNoiseEpoch;
    gamma_thresh_temp=gamma_thresh-peak_gamma;
    theta_thresh_temp=theta_thresh-peak_theta;
    k=1;
    for kk=mod([mm:mm+2],length(filename2))+1
        kk
        [REMEpoch,SWSEpoch,Wake,REMEpoch1,SWSEpoch1,Wake1,smooth_ghi]=FindBehavEpochsDiffDays(mindur,mw_dur,sl_dur,ms_dur,wa_dur,(filename2{kk}),gamma_thresh_temp,theta_thresh_temp,k,0);
        Ep1={REMEpoch,SWSEpoch,Wake};
        Ep1={REMEpoch,SWSEpoch,Wake};
        Ep2={REMEpoch1,SWSEpoch1,Wake1};
        tsdcalc=smooth_ghi;
        Kap(mm,k)=CohenKappaSleepScoring(Ep1,Ep2,tsdcalc);
k=k+1;
%         StateComp{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
%         StateComp{2}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,SWSEpoch))),1); %SS
%         StateComp{3}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,Wake))),1); %SW
%         StateComp{4}(mm,k)=size(Data(Restrict(smooth_ghi,and(SWSEpoch1,REMEpoch))),1); %SR
%         StateComp{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
%         StateComp{6}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1);%RR
%         StateComp{7}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,Wake))),1); %RW
%         StateComp{8}(mm,k)=size(Data(Restrict(smooth_ghi,and(REMEpoch1,SWSEpoch))),1); %RS
%         StateComp{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake1)),1);
%         StateComp{10}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake,Wake1))),1); %WW
%         StateComp{11}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,SWSEpoch))),1); %WS
%         StateComp{12}(mm,k)=size(Data(Restrict(smooth_ghi,and(Wake1,REMEpoch))),1); %WR
%         k=k+1;
    end
    
    
end

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffMice.mat','StateComp')


load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffMice.mat')
figure
SWSprop=[mean(reshape(StateComp{2}./StateComp{1},[1],[])),mean(reshape(StateComp{4}./StateComp{1},[1],[])),...
    mean(reshape(StateComp{3}./StateComp{1},[1],[]))]
REMprop=[mean(reshape(StateComp{8}./StateComp{5},[1],[])),mean(reshape(StateComp{6}./StateComp{5},[1],[])),...
    mean(reshape(StateComp{7}./StateComp{5},[1],[]))]
Wakeprop=[mean(reshape(StateComp{11}./StateComp{9},[1],[])),mean(reshape(StateComp{12}./StateComp{9},[1],[])),...
    mean(reshape(StateComp{10}./StateComp{9},[1],[]))]

mean((StateComp{2}(:)+StateComp{6}(:)+StateComp{10}(:))./(StateComp{1}(:)+StateComp{5}(:)+StateComp{9}(:)))



g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'), hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off

