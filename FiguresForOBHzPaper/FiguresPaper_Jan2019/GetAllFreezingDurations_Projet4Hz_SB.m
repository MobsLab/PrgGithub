clear all

% bulbectomy experiment
Dir_All.All{1} = PathForExperimentFEAR('FearCBNov15','fear');
Dir_All.Ext{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','EXT-24h-envC');

Dir_All.All{2} = PathForExperimentFEAR('ManipFeb15Bulbectomie','fear');
Dir_All.Ext{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','EXT-24h-envC');

% these mice extinguished in the plethysmograph so we're using 48hrs
Dir_All.All{3} = PathForExperimentFEAR('ManipDec14Bulbectomie','fear');
Dir_All.Ext{3} = RestrictPathForExperiment(Dir_All.All{3},'Session','EXT-48h-envB');

SessionTypes = {'Ext'};

mousenum = 0;
for ss = 1
    clear FzPerc CSEpoch
    Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){1},Dir_All.(SessionTypes{ss}){2});
    Dir = MergePathForExperiment(Dir,Dir_All.(SessionTypes{ss}){3});
    
    for mm=1:length(Dir.path)
        if strcmp(Dir.group{mm},'CTRL')
            mousenum = mousenum+1;
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            Fz.(SessionTypes{ss}){mousenum} = Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
            NoFz.(SessionTypes{ss}){mousenum} = Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
            SessType(mousenum) = 1;
        end
    end
end


clear Dir
Dir = PathForExperimentFEAR('Fear-electrophy');
Dir = RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');

for mm=1:length(Dir.path)
    if strcmp(Dir.group{mm},'CTRL')
        mousenum = mousenum+1;
        cd(Dir.path{mm})
        clear Movtsd FreezeEpoch
        try, load('behavResources.mat');catch,load('Behavior.mat'); end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
        FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
        Fz.(SessionTypes{ss}){mousenum} = Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
        NoFz.(SessionTypes{ss}){mousenum} = Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
        SessType(mousenum) = 2;
    end
end


clear Dir
Dir = PathForExperimentFEAR('Fear-electrophy-opto');
Dir = RestrictPathForExperiment(Dir,'Session','EXT-24h-NaN');

for mm=1:length(Dir.path)
    if strcmp(Dir.group{mm},'CTRL') | strcmp(Dir.group{mm},'GADgfp')
        mousenum = mousenum+1;
        cd(Dir.path{mm})
        clear Movtsd FreezeEpoch
        try, load('behavResources.mat');catch,load('Behavior.mat'); end
        FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
        FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        Fz.(SessionTypes{ss}){mousenum} = Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
        NoFz.(SessionTypes{ss}){mousenum} = Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
        SessType(mousenum) = 3;
    end
end


XFz = [0:1:90];
XNoFz = [0:1:120];
AllFzPer = [];AllNoFzPer=[];
clear AllCtrlFz AllCtrlNoFz
for k = 1:length(SessType)
    [Y,X] = hist(Fz.Ext{k},XFz);
    AllCtrlFz(k,:) = (Y/sum(Y));
    MeanCtrlFz(k,:) = nanmean(Fz.Ext{(k)});
    AllFzPer = [AllFzPer;Fz.Ext{k}];

    [Y,X] = hist(NoFz.Ext{(k)},XNoFz);
    AllCtrlNoFz(k,:) = (Y/sum(Y));
    MeanCtrlNoFz(k,:) = nanmean(NoFz.Ext{(k)});
    AllNoFzPer = [AllNoFzPer;Fz.Ext{k}];

end

clf
subplot(231)
plot(XFz,nanmean(AllCtrlFz(SessType==1,:)),'color','r','linewidth',3), hold on
plot(XFz,nanmean(AllCtrlFz(SessType==2,:)),'color','b','linewidth',3), hold on
plot(XFz,nanmean(AllCtrlFz(SessType==3,:)),'color','g','linewidth',3), hold on
plot(XFz,AllCtrlFz(SessType==1,:)','color','r'), hold on
plot(XFz,AllCtrlFz(SessType==2,:)','color','b'), hold on
plot(XFz,AllCtrlFz(SessType==3,:)','color','g'), hold on
legend('CTRLMice-BBXexp','AllEphysMice','CTRLMice-Opto')
ylabel('Freezing period duration','FontSize',20)
title('histogram')
xlabel('Dur - s')

subplot(232)
plot(XFz,cumsum(AllCtrlFz(SessType==1,:)'),'color','r'), hold on
plot(XFz,cumsum(AllCtrlFz(SessType==2,:)'),'color','b'), hold on
plot(XFz,cumsum(AllCtrlFz(SessType==3,:)'),'color','g'), hold on
plot(XFz,nanmean(cumsum(AllCtrlFz(SessType==2,:)')'),'color','b','linewidth',3), hold on
plot(XFz,nanmean(cumsum(AllCtrlFz(SessType==1,:)')'),'color','r','linewidth',3), hold on
plot(XFz,nanmean(cumsum(AllCtrlFz(SessType==3,:)')'),'color','g','linewidth',3), hold on
title('cumulative histogram')
xlabel('Dur - s')

subplot(233)
hist(AllFzPer(AllFzPer<100), XFz)
title('histogram-all periods together')
xlabel('Dur - s')

subplot(234)
plot(XNoFz,nanmean(AllCtrlNoFz(SessType==1,:)),'color','r','linewidth',3), hold on
plot(XNoFz,nanmean(AllCtrlNoFz(SessType==2,:)),'color','b','linewidth',3), hold on
plot(XNoFz,nanmean(AllCtrlNoFz(SessType==3,:)),'color','g','linewidth',3), hold on
plot(XNoFz,AllCtrlNoFz(SessType==1,:)','color','r'), hold on
plot(XNoFz,AllCtrlNoFz(SessType==2,:)','color','b'), hold on
plot(XNoFz,AllCtrlNoFz(SessType==3,:)','color','g'), hold on
ylabel('NON Freezing period duration','FontSize',20)
title('histogram')
xlabel('Dur - s')

subplot(235)
plot(XNoFz,cumsum(AllCtrlNoFz(SessType==1,:)'),'color','r'), hold on
plot(XNoFz,cumsum(AllCtrlNoFz(SessType==2,:)'),'color','b'), hold on
plot(XNoFz,cumsum(AllCtrlNoFz(SessType==3,:)'),'color','g'), hold on
plot(XNoFz,nanmean(cumsum(AllCtrlNoFz(SessType==2,:)')'),'color','b','linewidth',3), hold on
plot(XNoFz,nanmean(cumsum(AllCtrlNoFz(SessType==1,:)')'),'color','r','linewidth',3), hold on
plot(XNoFz,nanmean(cumsum(AllCtrlNoFz(SessType==3,:)')'),'color','g','linewidth',3), hold on
title('cumulative histogram')
xlabel('Dur - s')

subplot(236)
hist(AllNoFzPer(AllNoFzPer<200), XNoFz)
title('histogram-all periods together')
xlim([0 100])
xlabel('Dur - s')