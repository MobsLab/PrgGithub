clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

WhichWay=[1,2;2,1];

%% Sessions
% Mice to use
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177/';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151113/';
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';
filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151119/Sleep/';

%%%
for mm=1:size(filename,1)
    mm
    for k=1:2
        cd(filename{mm,WhichWay(k,1)})
        load('StateEpochSB.mat')
        
        TotNoiseEpoch=Or(NoiseEpoch,GndNoiseEpoch);
        try
            TotNoiseEpoch=Or(TotNoiseEpoch,WeirdNoiseEpoch)
        end
%         try peak_gamma
%         catch
            [Y,X]=hist((Data(smooth_ghi)),1000);
            peak_gamma=X(find(Y==max(Y)));
            [Y,X]=hist((Data(Restrict(smooth_Theta,sleepper))),1000);
            peak_theta=X(find(Y==max(Y)));
%         end
%         
        r=Range(smooth_ghi);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=TotalEpoch-TotNoiseEpoch;
        gamma_thresh_temp=gamma_thresh-peak_gamma;
        theta_thresh_temp=theta_thresh-peak_theta;
        [REMEpoch,SWSEpoch,Wake,REMEpoch1,SWSEpoch1,Wake1,smooth_ghi]=FindBehavEpochsDiffDays(mindur,mw_dur,sl_dur,ms_dur,wa_dur,(filename{mm,WhichWay(k,2)}),gamma_thresh_temp,theta_thresh_temp,0);
        
        StateComp{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
        StateComp{2}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,SWSEpoch))),1); %SS
        StateComp{3}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,Wake))),1); %SW
        StateComp{4}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,REMEpoch))),1); %SR
        
        StateComp{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
        StateComp{6}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,REMEpoch))),1);%RR
        StateComp{7}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,Wake))),1); %RW
        StateComp{8}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,SWSEpoch))),1); %RS
        
        StateComp{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake1)),1);
        StateComp{10}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake,Wake1))),1); %WW
        StateComp{11}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake1,SWSEpoch))),1); %WS
        StateComp{12}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake1,REMEpoch))),1); %WR
        clear peak_gamma
    end
end

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffDaysEMGMiceGamma.mat','StateComp')

%%%
clear StateComp
for mm=1:size(filename,1)
    mm
    for k=1:2
        cd(filename{mm,WhichWay(k,1)})
        load('StateEpochEMGSB.mat')
        
        TotNoiseEpoch=Or(NoiseEpoch,GndNoiseEpoch);
        try
            TotNoiseEpoch=Or(TotNoiseEpoch,WeirdNoiseEpoch)
        end
%         try peak_gamma
%         catch
            [Y,X]=hist((Data(EMGData)),1000);
            peak_EMG=X(find(Y==max(Y)));
            [Y,X]=hist((Data(Restrict(smooth_Theta,sleepper))),1000);
            peak_theta=X(find(Y==max(Y)));
%         end
%         
        r=Range(smooth_ghi);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=TotalEpoch-TotNoiseEpoch;
        EMG_thresh_temp=EMG_thresh-peak_EMG;
        theta_thresh_temp=theta_thresh-peak_theta;
        [REMEpoch,SWSEpoch,Wake,REMEpoch1,SWSEpoch1,Wake1,smooth_ghi]=FindBehavEpochsDiffDaysEMG(mindur,mw_dur,sl_dur,ms_dur,wa_dur,(filename{mm,WhichWay(k,2)}),EMG_thresh_temp,theta_thresh_temp,0);
        
        StateComp{1}(mm,k)=size(Data(Restrict(smooth_ghi,SWSEpoch1)),1);
        StateComp{2}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,SWSEpoch))),1); %SS
        StateComp{3}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,Wake))),1); %SW
        StateComp{4}(mm,k)=size(Data(Restrict(smooth_ghi,And(SWSEpoch1,REMEpoch))),1); %SR
        
        StateComp{5}(mm,k)=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
        StateComp{6}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,REMEpoch))),1);%RR
        StateComp{7}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,Wake))),1); %RW
        StateComp{8}(mm,k)=size(Data(Restrict(smooth_ghi,And(REMEpoch1,SWSEpoch))),1); %RS
        
        StateComp{9}(mm,k)=size(Data(Restrict(smooth_ghi,Wake1)),1);
        StateComp{10}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake,Wake1))),1); %WW
        StateComp{11}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake1,SWSEpoch))),1); %WS
        StateComp{12}(mm,k)=size(Data(Restrict(smooth_ghi,And(Wake1,REMEpoch))),1); %WR
        clear peak_EMG peak_theta EMG_thresh_temp
    end
end

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffDaysEMGMiceEMG.mat','StateComp')


%
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffDaysEMGMiceGamma.mat')
figure
SWSprop=[mean(reshape(StateComp{2}./StateComp{1},[1],[])),mean(reshape(StateComp{4}./StateComp{1},[1],[])),...
    mean(reshape(StateComp{3}./StateComp{1},[1],[]))]
REMprop=[mean(reshape(StateComp{8}./StateComp{5},[1],[])),mean(reshape(StateComp{6}./StateComp{5},[1],[])),...
    mean(reshape(StateComp{7}./StateComp{5},[1],[]))]
Wakeprop=[mean(reshape(StateComp{11}./StateComp{9},[1],[])),mean(reshape(StateComp{12}./StateComp{9},[1],[])),...
    mean(reshape(StateComp{10}./StateComp{9},[1],[]))]

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'), hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
title('gamma')


load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/CompDiffDaysEMGMiceEMG.mat')
figure
SWSprop=[mean(reshape(StateComp{2}./StateComp{1},[1],[])),mean(reshape(StateComp{4}./StateComp{1},[1],[])),...
    mean(reshape(StateComp{3}./StateComp{1},[1],[]))]
REMprop=[mean(reshape(StateComp{8}./StateComp{5},[1],[])),mean(reshape(StateComp{6}./StateComp{5},[1],[])),...
    mean(reshape(StateComp{7}./StateComp{5},[1],[]))]
Wakeprop=[mean(reshape(StateComp{11}./StateComp{9},[1],[])),mean(reshape(StateComp{12}./StateComp{9},[1],[])),...
    mean(reshape(StateComp{10}./StateComp{9},[1],[]))]

g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'), hold on
colormap([[0.4 0.5 1];[1 0.2 0.2];[0.6 0.6 0.6]])
set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
xlim([0.5 3.5])
ylim([0 1.1])
box off
title('EMG')
