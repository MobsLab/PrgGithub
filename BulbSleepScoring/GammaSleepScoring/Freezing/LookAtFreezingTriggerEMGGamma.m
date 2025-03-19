%% Figrues used for final Fig5

clear all, close all
% Look at Freezing-related activity
m=1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160810/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160810/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160818/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160818/Sleep/';

smootime=3;
figure
clear GammAll
for mm=1:m
    mm
    clear StimEpoch
    
    % sleeping part
    cd(Filename{mm,2})
    % Gamma
    
    load('StateEpochSB.mat','gamma_thresh')
%     Wake=dropShortIntervals(Wake,5*1e4);
%     Sleep=dropShortIntervals(Sleep,5*1e4);
%     [bef_cell,aft_cell]=transEpoch(Sleep,Wake);
%     Times=round(Start(bef_cell{1,2})/1000)/10;
%     [M,T]=PlotRipRaw(smooth_ghi,Times,5000);close;
%     GammTriggeredSl(mm,:)=M(:,2)';
%     GammThresh(mm)=gamma_thresh;
    load('StateEpochEMGSB.mat','EMG','EMG_thresh')
%     Wake=dropShortIntervals(Wake,5*1e4);
%     Sleep=dropShortIntervals(Sleep,5*1e4);
%     [bef_cell,aft_cell]=transEpoch(SWSEpoch,Wake);
%     Times=round(Start(bef_cell{1,2})/1000)/10;
%     [M,T]=PlotRipRaw(EMGData,Times,5000);close;
%     EMGTriggeredSl(mm,:)=M(:,2)';
    EMGThresh(mm)=EMG_thresh;
    
    % freezing part
    cd(Filename{mm,1})
    load('behavResources.mat')
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,5*1e4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
    Times=round(Start(FreezeEpoch)/1000)/10;
    %%Trigger Gamma on freezing
    % Load files and calculate gamma power
    load('ChannelsToAnalyse/Bulb_deep.mat','channel')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=tsd(Range(LFP),H);
    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    smooth_ghi=Restrict(smooth_ghi,intervalSet(0,750*1e4));
%     %Trigger
%     [M,T]=PlotRipRaw(smooth_ghi,Times,5000);close;
%     GammTriggeredFr(mm,:)=M(:,2)';
    
    
    %%Trigger EMG on freezing
    % Load files and calculate gamma power
    load(['LFPData/LFP',num2str(chE),'.mat'])
    FilLFP=FilterLFP(LFP,[50 300],1024);
    EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    EMGData=Restrict(EMGData,intervalSet(0,750*1e4));

%     %Tigger
%     [M,T]=PlotRipRaw(EMGData,Times,5000);close;
%     EMGTriggeredFr(mm,:)=M(:,2)';
    
    subplot(4,2,(mm*2)-1)
    hist(Data(smooth_ghi),1000), hold on, line([gamma_thresh gamma_thresh],ylim)
    subplot(4,2,(mm*2))
    hist(Data(EMGData),1000), hold on, line([EMG_thresh EMG_thresh],ylim)
    
    
    
end

SlWk=[];
for mm=1:m
    SlWk(mm,:)=(GammAll{2,mm}-mean(GammAll{2,mm}))./mean(GammAll{2,mm});
end


FrNoFr=[];
for mm=1:m
    FrNoFr(mm,:)=(GammAll{1,mm}-mean(GammAll{2,mm}))./mean(GammAll{1,mm});
end

figure
g=shadedErrorBar([1:5000]/2500-1,mean(SlWk),[stdError(SlWk);stdError(SlWk)],'b')
hold on
g=shadedErrorBar([1:5000]/2500-1,mean(FrNoFr),[stdError(FrNoFr);stdError(FrNoFr)])
line([0 0],[-80 90],'color','k','linestyle','--','linewidth',3)
line([0 1],[80 80],'color','c','linewidth',10)
ylim([-75 85])
xlim([-1.05 1.05])