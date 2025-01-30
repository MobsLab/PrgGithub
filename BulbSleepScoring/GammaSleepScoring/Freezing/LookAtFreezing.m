%% Figrues used for final Fig5

clear all, close all
% Look at Freezing-related activity
m=1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150429/Breath-Mouse-243-29042015/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150430/Breath-Mouse-244-30042015/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/';
Filename{m,2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150630-SLEEPbasal/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150630-SLEEPbasal/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC/';
Filename{m,2}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';
smootime=3;
figure
clear GammAll
for mm=m
    
    mm
    %%Trigger Gamma on freezing
    
    % Load files and calculate gamma power
    cd(Filename{mm,1})
    load('ChannelsToAnalyse/Bulb_deep.mat','channel')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=tsd(Range(LFP),H);
    smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    load('behavResources.mat')
    
    if mm==m
        
        cd(Filename{mm,1})
        load('LFPData/LFP3.mat')
        FilLFP=FilterLFP(LFP,[50 300],1024);
        EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
        figure
        cd(Filename{mm,2})
        Var=load('StateEpochSB.mat','smooth_ghi','gamma_thresh');
        subplot(3,4,[1:3])
        hold on
        line([0 max(Range(smooth_ghi,'s'))],[Var.gamma_thresh Var.gamma_thresh],'color','r','linewidth',5)
        plot(Range(smooth_ghi,'s'),runmean(Data(smooth_ghi),500),'k')
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(smooth_ghi,subset(FreezeEpoch,k)),'s'),Data(Restrict(smooth_ghi,subset(FreezeEpoch,k)))*0+900,'c','linewidth',3)
        end
        xlim([0 1300])
        box off
        dat=Data(Movtsd);
        dat(1:8)=dat(9);
        dat(end-12:end)=dat(end-13);
        
        subplot(3,4,[5:7])
        plot(Range(Movtsd,'s'),runmean(dat,10),'k')
        hold on
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(smooth_ghi,subset(FreezeEpoch,k)),'s'),Data(Restrict(smooth_ghi,subset(FreezeEpoch,k)))*0+25,'c','linewidth',3)
        end
        xlim([0 1300])
        box off
        subplot(4,4,[4,8])
        [Y,X]=hist(log(Data(Var.smooth_ghi)),200);
        plot(X,Y/sum(Y),'color',[0.5 0.5 0.5],'linewidth',3),hold on
        [Y,X]=hist(log(Data(smooth_ghi)),200); hold on
        plot(X,runmean(Y/sum(Y),5),'k','linewidth',3)
        line([log(Var.gamma_thresh) log(Var.gamma_thresh)],[0 0.09],'color','r','linewidth',3)
        box off
        subplot(3,4,[9:11])
        cd(Filename{mm,2})
        Var2=load('StateEpochEMGSB.mat','EMG_thresh','EMGData');
        line([0 max(Range(smooth_ghi,'s'))],[Var2.EMG_thresh Var2.EMG_thresh],'color','r','linewidth',3)
        hold on
        plot(Range(EMGData,'s'),Data(EMGData),'k')
        for k=1:length(Start(FreezeEpoch))
            plot(Range(Restrict(smooth_ghi,subset(FreezeEpoch,k)),'s'),Data(Restrict(smooth_ghi,subset(FreezeEpoch,k)))*0+3*1E5,'c','linewidth',3)
        end
        box off
        xlim([0 1300])
        subplot(4,4,[12,16])
        [Y,X]=hist(log(Data(Var2.EMGData)),200);
        plot(X,(Y/sum(Y)),'color',[0.5 0.5 0.5],'linewidth',3),hold on
        [Y,X]=hist(log(Data(EMGData)),200); hold on
        plot(X,runmean(Y/sum(Y),5),'k','linewidth',3)
        line([log(Var2.EMG_thresh) log(Var2.EMG_thresh)],[0 0.09],'color','r','linewidth',3)
        box off
        
        
    end
    
    
    GammTriggered=[];
    St=Start(FreezeEpoch);
    for k=1:length(St)
        GammTriggered=[GammTriggered,Data(Restrict(smooth_ghi,intervalSet(St(k)-2e4,St(k)+2e4)))];
    end
    GammAll{1,mm}=mean(GammTriggered,2);
    
    cd(Filename{mm,2})
    load('StateEpochSB.mat','smooth_ghi','SWSEpoch','wakeper')
    GammTriggered=[];
    [aft_cell,bef_cell]=transEpoch(wakeper,SWSEpoch);
    St=Start(bef_cell{2,1});
    for k=1:min(100,length(St))
        try
            GammTriggered=[GammTriggered,Data(Restrict(smooth_ghi,intervalSet(St(k)-2e4,St(k)+2e4)))];
        end
        ends
    GammAll{2,mm}=mean(GammTriggered,2);
    
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