%%% This code was used for 11th April draft
clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

WhichWay=[1,2;2,1];

%% Sessions
m=1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906/';
Filename{m,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913/';
Filename{m,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913/';
Filename{m,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913/';
Filename{m,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913/';
Filename{m,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night/';



%%%
for mm=1:size(Filename,1)
    mm
    for k=1:2
        cd(Filename{mm,WhichWay(k,1)})
        load('StateEpochSB.mat')
        
        TotNoiseEpoch=or(NoiseEpoch,GndNoiseEpoch);
        try
            TotNoiseEpoch=or(TotNoiseEpoch,WeirdNoiseEpoch)
        end
        r=Range(smooth_ghi);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=TotalEpoch-TotNoiseEpoch;
        gamma_thresh_temp=gamma_thresh;
        theta_thresh_temp=theta_thresh;
        [REMEpoch,SWSEpoch,Wake,REMEpoch1,SWSEpoch1,Wake1,smooth_ghi]=FindBehavEpochsDiffDaysNoPeakAlign(mindur,mw_dur,sl_dur,ms_dur,wa_dur,(Filename{mm,WhichWay(k,2)}),gamma_thresh_temp,theta_thresh_temp,0);
        
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
    end
end

save('/media/DataMOBSSlSc/SleepScoringMice/NightVsDay/CompDiffDays.mat','StateComp')

%%%
load('/media/DataMOBSSlSc/SleepScoringMice/NightVsDay/CompDiffDays.mat')
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

GenCorr=[(StateComp{2}(:,1)+StateComp{6}(:,1)+StateComp{10}(:,1))./(StateComp{1}(:,1)+StateComp{5}(:,1)+StateComp{9}(:,1))]