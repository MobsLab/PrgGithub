clear all, close all
cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
load('Gamma_HR_Corr_Response_RangeOfTimeBins.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')
IsoLevels = {'08','10','12','15','18'};
StimLevels = {'0V','2V','4V','6V'};

% Average stim response at different levels
figure
clf
cols = jet(5);
for Stim = 1:4
    subplot(1,4,Stim)
    for exp = 2:6
        hold on
        clear AvResp
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AvResp(k,:) = nanmean(T.Mov{exp,k,Stim});
        end
        plot(Time.Mov,nanmean(AvResp),'color',cols(exp-1,:),'linewidth',2)
        ylim([0 4*1e8])
        title(StimLevels(Stim))
    end
            line([0 0],ylim,'color','k')
set(gca,'FontSize',18,'linewidth',2)
xlabel('time to stim (s)')
ylabel('Head Acc')
end
subplot(1,4,1)
legend(IsoLevels)


figure
clf
cols = lines(4);
for exp = 2:6
    subplot(1,5,exp-1)
    
    for Stim = 1:4
        
        hold on
        clear AvResp
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AvResp(k,:) = nanmean(T.Mov{exp,k,Stim});
        end
        plot(Time.Mov,nanmean(AvResp),'color',cols(Stim,:),'linewidth',2)
        
        
    end
    ylim([0 4*1e8])
    title(IsoLevels(exp-1))
    
    line([0 0],ylim,'color','k')
    set(gca,'FontSize',18,'linewidth',2)
    xlabel('time to stim (s)')
    ylabel('Head Acc')
end
subplot(1,5,1)
legend(StimLevels)

AllResp=[];
for exp = 2:6
    for Stim = 1:4        
        hold on
        for k = 1:4
            T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
            AllResp = [AllResp;naninterp((T.Mov{exp,k,Stim}))];
        end
       
    end
end

TimeWindow.Mov{1} = [find(Time.Mov<0.0,1,'last'):find(Time.Mov<0.1,1,'last')];
TimeWindow.Mov{2} = [find(Time.Mov<0.1,1,'last'):find(Time.Mov<0.3,1,'last')];

for timewin = 1:2
    for exp = 2:6
        for Stim = 1:4
            subplot(1,5,exp-1)
            
            hold on
            for k = 1:4
                T.Mov{exp,k,Stim}(T.Mov{exp,k,Stim}==0)=NaN;
                AccResp{timewin}(k,exp-1,Stim) = nanmean(nanmean(T.Mov{exp,k,Stim}(:,TimeWindow.Mov{timewin})));
            end
            
        end
    end
end
%% Figure for 668
colormap jet
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_',Vals{v}])
    load('behavResources.mat')
    UniqueVoltage = unique(StimVolt);
    StartTimes = Start(StimEpoch,'s');
    load('StateEpochSB.mat')
    MeanGamma{1}(v) = nanmean((Data(Restrict(smooth_ghi,BaselineEpoch))));
    StdGamma{1}(v) = std((Data(Restrict(smooth_ghi,BaselineEpoch))));
    [Y,X] =hist((Data(Restrict(smooth_ghi,BaselineEpoch))),100);
    HistGamma{1}{v}=[X;Y];
end

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPost/StateEpochSB.mat','smooth_ghi')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPre/StateEpochSB.mat','smooth_ghi','SWSEpoch')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];
[Y,X] =hist((AllDatSleepWake),100);
HistGammaSleepWake{1}{v}=[X;Y];
SleepAvGamma(1) = mean((Data(Restrict(smooth_ghi,SWSEpoch))));


%% Figure for 669
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    if v==2
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_10/Baseline/'])
    elseif v==5
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_18/Baseline/'])
    else
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M669/Isoflurane_',Vals{v}])
    end
    load('StateEpochSB.mat')
    MeanGamma{2}(v) = nanmean((Data(Restrict(smooth_ghi,BaselineEpoch))));
    StdGamma{2}(v) = std((Data(Restrict(smooth_ghi,BaselineEpoch))));
    [Y,X] =hist((Data(Restrict(smooth_ghi,BaselineEpoch))),100);
    HistGamma{2}{v}=[X;Y];
    
end
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPre/StateEpochSB.mat','smooth_ghi')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPost/StateEpochSB.mat','smooth_ghi','SWSEpoch')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];
[Y,X] =hist((AllDatSleepWake),100);
HistGammaSleepWake{2}{v}=[X;Y];
SleepAvGamma(2) = mean((Data(Restrict(smooth_ghi,SWSEpoch))));

%% Figure for 666
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    if v==1
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_08/baseline'])
    else
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M666/Isoflurane_',Vals{v}])
        
    end
    load('StateEpochSB.mat')
    MeanGamma{3}(v) = nanmean((Data(Restrict(smooth_ghi,BaselineEpoch))));
    StdGamma{3}(v) = std((Data(Restrict(smooth_ghi,BaselineEpoch))));
    [Y,X] =hist((Data(Restrict(smooth_ghi,BaselineEpoch))),100);
    HistGamma{3}{v}=[X;Y];
    
end
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_SleepPre/StateEpochSB.mat','smooth_ghi')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_SleepPost/StateEpochSB.mat','smooth_ghi','SWSEpoch')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];
[Y,X] =hist((AllDatSleepWake),100);
HistGammaSleepWake{3}{v}=[X;Y];
SleepAvGamma(3) = mean((Data(Restrict(smooth_ghi,SWSEpoch))));

%% Figure for 667
%
Vals = {'08','10','12','15','18'};
cols2 = jet(length(Vals));
cols = summer(length(UniqueVoltage));
BaselineEpoch = intervalSet(0,10*60*1e4);
for v = 1:length(Vals)
    clear MovAcctsd smooth_ghi
    if v==1
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_08/baseline'])
    else
        cd(['/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M667/Isoflurane_',Vals{v}])
        
    end
    load('StateEpochSB.mat')
    MeanGamma{4}(v) = nanmean((Data(Restrict(smooth_ghi,BaselineEpoch))));
    StdGamma{4}(v) = std((Data(Restrict(smooth_ghi,BaselineEpoch))));
    [Y,X] =hist((Data(Restrict(smooth_ghi,BaselineEpoch))),100);
    HistGamma{4}{v}=[X;Y];
    
end
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPre/StateEpochSB.mat','smooth_ghi')
AllDatSleepWake = [Data(smooth_ghi)];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPost/StateEpochSB.mat','smooth_ghi','SWSEpoch')
AllDatSleepWake = [AllDatSleepWake;Data(smooth_ghi)];
[Y,X] =hist((AllDatSleepWake),100);
HistGammaSleepWake{4}{v}=[X;Y];
SleepAvGamma(4) = mean((Data(Restrict(smooth_ghi,SWSEpoch))));

%% Make Figures
clf
for m= 1:4
plot([0.8,1,1.2,1.5,1.8],(MeanGamma{m}./SleepAvGamma(m)),'linewidth',1,'color',[0.6 0.6 0.6]), 
hold on
% scatter([0.8,1,1.2,1.5,1.8],(MeanGamma{m}./SleepAvGamma(m)),80,cols2,'filled')
RememberGamma(m,:)=MeanGamma{m}./SleepAvGamma(m);
xlabel('Isoflurane level')
ylabel('gamma power')
end
errorbar([0.8,1,1.2,1.5,1.8],nanmean(RememberGamma),stdError(RememberGamma),'linewidth',2,'color','k'),
scatter([0.8,1,1.2,1.5,1.8],nanmean(RememberGamma),80,cols2,'filled')
box off
xlim([0.6 2])

figure
clf
StimLevel = 2;
StimTime =2;
for m = 1:4
    RememberGamma(m,:)=MeanGamma{m}./SleepAvGamma(m);
end
scatter(nanmean(RememberGamma),nanmean(log(AccResp{StimTime}(:,:,StimLevel)),1),80,cols2,'filled'), hold on
box off
errorbarxy(nanmean(RememberGamma),nanmean(log(AccResp{StimTime}(:,:,StimLevel)),1),stdError(RememberGamma),stdError(log(AccResp{StimTime}(:,:,StimLevel))),'linewidth',2,'color','k'),
