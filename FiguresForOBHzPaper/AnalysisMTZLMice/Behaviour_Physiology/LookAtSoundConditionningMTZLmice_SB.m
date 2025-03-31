clear all
% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'

Sessions = {'SoundHab' ,'SoundTest', 'SoundTestPlethysmo'};

for ss = 1 :length(Sessions)
    
    Dir=PathForExperimentsMtzlProject(Sessions{ss});
    
    for d = 1:length(Dir.path)
        cd(Dir.path{d}{1})
        disp(Dir.path{d}{1})
        
        clear FreezeAccEpoch MovAcctsd
        load('behavResources.mat')
        %FreezeAccEpoch = thresholdIntervals(MovAcctsd, 5E7, 'Direction','Below');
        %FreezeAccEpoch = mergeCloseIntervals(FreezeAccEpoch, 0.1E4);
        %FreezeAccEpoch = dropShortIntervals(FreezeAccEpoch, 3E4);
        
        th_immob_Acc=3E7;% see EstablishAThresholdForFreezingFromAcceleration.m
        th_2merge_FreezAcc=0.5;
        thtps_immob_Acc=2;
        SmoothFactorAcc=3;
        MovAccSmotsd=tsd(Range(MovAcctsd),SmoothDec(Data(MovAcctsd),SmoothFactorAcc));
        FreezeAccEpoch=thresholdIntervals(MovAccSmotsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,th_2merge_FreezAcc*1E4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);
%         clf
%         plot(Range(MovAcctsd,'s'),Data(MovAcctsd))
%         hold on
%         plot(Range(MovAccSmotsd,'s'),Data(MovAccSmotsd))
%         plot(Range(Restrict(MovAccSmotsd,FreezeAccEpoch),'s'),Data(Restrict(MovAccSmotsd,FreezeAccEpoch)))
% pause


        % be permissive during the sounds
%         SoundTimes = intervalSet(sort([Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4));Start(mergeCloseIntervals(TTLInfo.CSplus,10e4))]),...
%             sort([Stop(mergeCloseIntervals(TTLInfo.CSMinus,10e4));Stop(mergeCloseIntervals(TTLInfo.CSplus,10e4))]));
%         FreezeAccEpochSounds = thresholdIntervals(MovAcctsd, 5E7, 'Direction','Below');
%         FreezeAccEpochSounds = mergeCloseIntervals(FreezeAccEpoch, 0.3E4);
%         FreezeAccEpochSounds = dropShortIntervals(FreezeAccEpoch, 3E4);
%         FreezeAccEpochSounds = and(FreezeAccEpochSounds,SoundTimes);
        
%         FreezeAccEpoch = FreezeAccEpoch-SoundTimes;
%         FreezeAccEpoch = or(FreezeAccEpoch,FreezeAccEpochSounds);
%         
%         FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,th_2merge_FreezAcc*1E4);
%         FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob_Acc*1E4);

        
        TotEpoch = intervalSet(0,max(Range(MovAcctsd)));
        
        
        if ss==1
            FreezeAccEpoch = and(FreezeAccEpoch,intervalSet(0,800*1E4));
            TotEpoch = and(TotEpoch,intervalSet(0,800*1E4));
        elseif ss==2
            FreezeAccEpoch = and(FreezeAccEpoch,intervalSet(0,1600*1E4));
            TotEpoch = and(TotEpoch,intervalSet(0,1600*1E4));
        elseif ss==3
            FreezeAccEpoch = and(FreezeAccEpoch,intervalSet(0,1600*1E4));
            TotEpoch = and(TotEpoch,intervalSet(0,1600*1E4));
        end
        
        
        % freezing episode durations
        MeanNoFzEp{ss}(d) = nanmean(Stop(TotEpoch-FreezeAccEpoch,'s')-Start(TotEpoch-FreezeAccEpoch,'s'));
        MenanFzEp{ss}(d) = nanmean(Stop(FreezeAccEpoch,'s')-Start(FreezeAccEpoch,'s'));
        [Y,X] = hist(Stop(FreezeAccEpoch,'s')-Start(FreezeAccEpoch,'s'),[0:1:50]);
        Y = Y/sum(Y);
        HistogramFzDur{ss}(d,:) = cumsum(Y);
        [Y,X] = hist(Stop(TotEpoch-FreezeAccEpoch,'s')-Start(TotEpoch-FreezeAccEpoch,'s'),[0:1:50]);
        Y = Y/sum(Y);
        HistogramNoFzDur{ss}(d,:) = cumsum(Y);
        
        % time spent freezing
        TotFzDur{ss}(d) = nansum(Stop(FreezeAccEpoch,'s')-Start(FreezeAccEpoch,'s'))./nansum(Stop(TotEpoch,'s')-Start(TotEpoch,'s'));
        

        % time spent freezing csminus
        CSStartTimes = Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4));
        CSStartTimes = CSStartTimes(1:4);
        CSEpoch = intervalSet(CSStartTimes,...
            CSStartTimes+60*1E4);
        TotFzDurCsMinus{ss}(d) = nansum(Stop(and(FreezeAccEpoch,CSEpoch),'s')-Start(and(FreezeAccEpoch,CSEpoch),'s'))./nansum(Stop(CSEpoch,'s')-Start(CSEpoch,'s'));
        MeanNoFzEpCSMinus{ss}(d) = nanmean(Stop(and(TotEpoch-FreezeAccEpoch,CSEpoch),'s')-Start(and(TotEpoch-FreezeAccEpoch,CSEpoch),'s'));
        MenanFzEpCSMinus{ss}(d) = nanmean(Stop(and(FreezeAccEpoch,CSEpoch),'s')-Start(and(FreezeAccEpoch,CSEpoch),'s'));
        % startle
        [M,T] = PlotRipRaw(MovAcctsd,Start(CSEpoch,'s'),1000,0,0);
        TriggerAccOnBeepCSMoins{ss}(d,:) = M(:,2);

        % time spent freezing csplus
        CSStartTimes = Start(mergeCloseIntervals(TTLInfo.CSplus,10e4));
        CSStartTimes = CSStartTimes(1:4);
        CSEpoch = intervalSet(CSStartTimes,...
            CSStartTimes+60*1E4);
        TotFzDurCsPlus{ss}(d) = nansum(Stop(and(FreezeAccEpoch,CSEpoch),'s')-Start(and(FreezeAccEpoch,CSEpoch),'s'))./nansum(Stop(CSEpoch,'s')-Start(CSEpoch,'s'));
        MeanNoFzEpCSPlus{ss}(d) = nanmean(Stop(and(TotEpoch-FreezeAccEpoch,CSEpoch),'s')-Start(and(TotEpoch-FreezeAccEpoch,CSEpoch),'s'));
        MenanFzEpCSPlus{ss}(d) = nanmean(Stop(and(FreezeAccEpoch,CSEpoch),'s')-Start(and(FreezeAccEpoch,CSEpoch),'s'));
        % startle
        [M,T] = PlotRipRaw(MovAcctsd,Start(CSEpoch,'s'),1000,0,0);
        TriggerAccOnBeepCSPlus{ss}(d,:) = M(:,2);
        
        
        try,TriggerAccOnBeepFzCSPlus{ss}(d,:) = M(:,2);
        catch TriggerAccOnBeepFzCSPlus{ss}(d,:) = nan(101,1);
        end
        [M,T] = PlotRipRaw(MovAcctsd,Start(and(TTLInfo.CSMinus,FreezeAccEpoch),'s'),1000,0,0);
        try,TriggerAccOnBeepFzCSMoins{ss}(d,:) = M(:,2);
        catch,TriggerAccOnBeepFzCSMoins{ss}(d,:) = nan(101,1);
        end

    end
end

%% Nice figures 
ValsCSMin = {[TotFzDurCsMinus{1}(6:end);TotFzDurCsMinus{2}(6:end);TotFzDurCsMinus{3}(6:end)]'; [TotFzDurCsMinus{1}(1:5);TotFzDurCsMinus{2}(1:5);TotFzDurCsMinus{3}(1:5)]'};
ValsCSPlu = {[TotFzDurCsPlus{1}(6:end);TotFzDurCsPlus{2}(6:end);TotFzDurCsPlus{3}(6:end)]'; [TotFzDurCsPlus{1}(1:5);TotFzDurCsPlus{2}(1:5);TotFzDurCsPlus{3}(1:5)]'};

XPos = [1;4]
Colors_Boxplot = [0.6,1,0.6;0.6,0.6,1];
Colors_Points= Colors_Boxplot *0.8;
Titles = {'Habituation','Test+24h','Test+48h(plethysmo)'}
clf
for k = 1:3
    subplot(1,3,k)
    for grp = 1:2
        X = ValsCSMin{grp}(:,k)*100;
        a=iosr.statistics.boxPlot(XPos(grp),X,'boxColor',Colors_Boxplot(grp,:),'lineColor',Colors_Boxplot(grp,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(grp),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',30)
        handlesplot=plotSpread(X,'distributionColors',Colors_Points(grp,:),'xValues',XPos(grp),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',20)
        
        X = ValsCSPlu{grp}(:,k)*100;
        a=iosr.statistics.boxPlot(XPos(grp)+0.8,X,'boxColor',Colors_Boxplot(grp,:),'lineColor',Colors_Boxplot(grp,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(grp)+0.8,'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',30)
        handlesplot=plotSpread(X,'distributionColors',Colors_Points(grp,:),'xValues',XPos(grp)+0.8,'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',20)
        
        % stats
        X1 = ValsCSMin{grp}(:,k)*100;
        X2 = ValsCSPlu{grp}(:,k)*100;
        [p,h] = ranksum(X1,X2);
        if p<0.05
            H = sigstar({[XPos(grp),XPos(grp)+0.8]},p);
            set(H(2),'FontSize',12)
        end
        
        xlim([0 6])
        ylim([-10 110])
        ylabel('% time spent freezing')
        set(gca,'XTick',[1,1.8,4,4.8],'XTickLabel',{'CS-','CS+','CS-','CS+'},'Linewidth',1.5,'FontSize',12)
        title(Titles{k})
    end
    
    % stats
    X1 = ValsCSMin{1}(:,k)*100;
    X2 = ValsCSMin{2}(:,k)*100;
    [p,h] = ranksum(X1,X2);
    if p<0.05
        H = sigstar({[XPos(1),XPos(2)]},p);
        set(H(2),'FontSize',12)
    end
    
    X1 = ValsCSPlu{1}(:,k)*100;
    X2 = ValsCSPlu{2}(:,k)*100;
    [p,h] = ranksum(X1,X2);
    if p<0.05
        H = sigstar({[XPos(1)+0.8,XPos(2)]+0.8},p);
        set(H(2),'FontSize',12)
    end   

end

% For paper
figure
clf
XPos = [1 2];
k=2; % test session
Colors_Boxplot = [[0.8 0.8 0.8];[1 0.4 0.4]];
Colors_Points= Colors_Boxplot *0.8;

for grp = 1:2
    X = ValsCSPlu{grp}(:,k)*100;
    a=iosr.statistics.boxPlot(XPos(grp),X,'boxColor',Colors_Boxplot(grp,:),'lineColor',Colors_Boxplot(grp,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(grp),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',30)
    handlesplot=plotSpread(X,'distributionColors',Colors_Points(grp,:),'xValues',XPos(grp),'spreadWidth',0.7), hold on;
    set(handlesplot{1},'MarkerSize',20)
    
end
xlim([0 3])
[p,h] = ranksum(ValsCSPlu{1}(:,k),ValsCSPlu{2}(:,k));


% the probabilities
clf
ValsNoFzEp = {[MeanNoFzEp{1}(6:end);MeanNoFzEp{2}(6:end);MeanNoFzEp{3}(6:end)]'; [MeanNoFzEp{1}(1:5);MeanNoFzEp{2}(1:5);MeanNoFzEp{3}(1:5)]'};
ValsFzEp = {[MenanFzEp{1}(6:end);MenanFzEp{2}(6:end);MenanFzEp{3}(6:end)]'; [MenanFzEp{1}(1:5);MenanFzEp{2}(1:5);MenanFzEp{3}(1:5)]'};

XPos = [1,4,7];XPos = [XPos;XPos+0.8];
Colors_Boxplot = [0.6,1,0.6;0.6,0.6,1];
Colors_Points= Colors_Boxplot *0.8;
subplot(211)
for k = 1:3
    for grp = 1:2
        X = ValsNoFzEp{grp}(:,k);
        a=iosr.statistics.boxPlot(XPos(grp,k),X,'boxColor',Colors_Boxplot(grp,:),'lineColor',Colors_Boxplot(grp,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(grp,k),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',30)
        handlesplot=plotSpread(X,'distributionColors',Colors_Points(grp,:),'xValues',XPos(grp,k),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',20)
    end
    X1 = ValsNoFzEp{1}(:,k);
    X2 = ValsNoFzEp{2}(:,k);
    [p,h] = ranksum(X1,X2);
    H = sigstar({[XPos(1,k),XPos(2,k)]},p);
    set(H(2),'FontSize',12)
    
    
end
xlim([0 10])
set(gca,'XTick',nanmean(XPos),'XTickLabel',{'Hab','Test24','Test48h'})
ylabel('Mean ep. dur NOFZ (s)')
title('Prop to 1-P(init Fz)')

subplot(212)
for k = 1:3
    for grp = 1:2
        X = ValsFzEp{grp}(:,k);
        a=iosr.statistics.boxPlot(XPos(grp,k),X,'boxColor',Colors_Boxplot(grp,:),'lineColor',Colors_Boxplot(grp,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
        a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        a.handles.medianLines.LineWidth = 5;
        handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(grp,k),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',30)
        handlesplot=plotSpread(X,'distributionColors',Colors_Points(grp,:),'xValues',XPos(grp,k),'spreadWidth',0.7), hold on;
        set(handlesplot{1},'MarkerSize',20)
    end
    X1 = ValsFzEp{1}(:,k);
    X2 = ValsFzEp{2}(:,k);
    [p,h] = ranksum(X1,X2);
        H = sigstar({[XPos(1,k),XPos(2,k)]},p);
        set(H(2),'FontSize',12)
    
end
xlim([0 10])
set(gca,'XTick',nanmean(XPos),'XTickLabel',{'Hab','Test24','Test48h'})
ylabel('Mean ep. dur FZ (s)')
title('Prop to P(maint Fz)')


%% trigger on beep
figure
ss=2;
subplot(221)
hold on
line([-1 0],[-1 0],'color',Colors_Boxplot(1,:),'linewidth',2)
line([-1 0],[-1 0],'color',Colors_Boxplot(2,:),'linewidth',2)
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepCSMoins{ss}(6:10,:)),stdError(TriggerAccOnBeepCSMoins{ss}(6:10,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepCSMoins{ss}(1:5,:)),stdError(TriggerAccOnBeepCSMoins{ss}(1:5,:)),'alpha','b','transparency',0.2);
title('CS- Beep')
xlabel('time to beep (s)')
ylabel('accelero value')
ylim([0 5e8])
legend('Saline','Methimazole')
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(222)
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepCSPlus{ss}(6:10,:)),stdError(TriggerAccOnBeepCSPlus{ss}(6:10,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepCSPlus{ss}(1:5,:)),stdError(TriggerAccOnBeepCSPlus{ss}(1:5,:)),'alpha','b','transparency',0.2);
title('CS+ Beep')
xlabel('time to beep (s)')
ylim([0 5e8])
set(gca,'Linewidth',1.5,'FontSize',12)

subplot(223)
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepFzCSMoins{ss}(6:10,:)),stdError(TriggerAccOnBeepFzCSMoins{ss}(6:10,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepFzCSMoins{ss}(1:5,:)),stdError(TriggerAccOnBeepFzCSMoins{ss}(1:5,:)),'alpha','b','transparency',0.2);
title('CS- Beep-Fz only')
xlabel('time to beep (s)')
ylabel('accelero value')
ylim([0 5e8])
set(gca,'Linewidth',1.5,'FontSize',12)
subplot(224)
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepFzCSPlus{ss}(6:10,:)),stdError(TriggerAccOnBeepFzCSPlus{ss}(6:10,:)),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(TriggerAccOnBeepFzCSPlus{ss}(1:5,:)),stdError(TriggerAccOnBeepFzCSPlus{ss}(1:5,:)),'alpha','b','transparency',0.2);
title('CS+ Beep-Fz only')
xlabel('time to beep (s)')
ylim([0 5e8])
set(gca,'Linewidth',1.5,'FontSize',12)














%%%%%%%%

      

figure
subplot(221)
PlotErrorBarN_KJ([TotFzDurCsMinus{1}(6:end);TotFzDurCsMinus{2}(6:end);TotFzDurCsMinus{3}(6:end)]','paired',0,'newfig',0,'barcolors','g')
ylim([0 1])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('CS- : saline')
subplot(222)
PlotErrorBarN_KJ([TotFzDurCsPlus{1}(6:end);TotFzDurCsPlus{2}(6:end);TotFzDurCsPlus{3}(6:end)]','paired',0,'newfig',0,'barcolors','g')
ylim([0 1])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('CS+ : saline')
subplot(223)
PlotErrorBarN_KJ([TotFzDurCsMinus{1}(1:5);TotFzDurCsMinus{2}(1:5);TotFzDurCsMinus{3}(1:5)]','paired',0,'newfig',0,'barcolors','b')
ylim([0 1])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('CS- : MTZL')
subplot(224)
PlotErrorBarN_KJ([TotFzDurCsPlus{1}(1:5);TotFzDurCsPlus{2}(1:5);TotFzDurCsPlus{3}(1:5)]','paired',0,'newfig',0,'barcolors','b')
ylim([0 1])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('CS+ : MTZL')

figure
subplot(221)
PlotErrorBarN_KJ([MeanNoFzEpCSPlus{1}(6:end);MeanNoFzEpCSPlus{2}(6:end);MeanNoFzEpCSPlus{3}(6:end)]','paired',0,'newfig',0,'barcolors','g')
ylim([0 50])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('No Fz EpDur : saline')
subplot(223)
PlotErrorBarN_KJ([MenanFzEpCSPlus{1}(6:end);MenanFzEpCSPlus{2}(6:end);MenanFzEpCSPlus{3}(6:end)]','paired',0,'newfig',0,'barcolors','g')
ylim([0 40])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('Fz Ep Dur : saline')
subplot(222)
PlotErrorBarN_KJ([MeanNoFzEpCSPlus{1}(1:5);MeanNoFzEpCSPlus{2}(1:5);MeanNoFzEpCSPlus{3}(1:5)]','paired',0,'newfig',0,'barcolors','b')
ylim([0 50])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('No Fz EpDur : MTZL')
subplot(224)
PlotErrorBarN_KJ([MenanFzEpCSPlus{1}(1:5);MenanFzEpCSPlus{2}(1:5);MenanFzEpCSPlus{3}(1:5)]','paired',0,'newfig',0,'barcolors','b')
ylim([0 40])
set(gca,'XTick',[1:3],'XTickLabel',{'Hab','Test24h','Test48h'})
title('Fz Ep Dur : MTZL')



figure(1)
clf
for ss = 1:3
    
    subplot(3,3,1+(ss-1)*3)
    PlotErrorBarN_KJ([MeanNoFzEpCSPlus{ss}(6:end);MeanNoFzEpCSPlus{ss}(1:5)]','newfig',0,'paired',0)
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
    title('MeanNonFz ep dur')
    if ss==1
        ylabel('Hab')
    elseif ss==2
        ylabel('Test24h')
    elseif ss==3
        ylabel('Test48h')
    end
    subplot(3,3,2+(ss-1)*3)
    PlotErrorBarN_KJ([MenanFzEpCSPlus{ss}(6:end);MenanFzEpCSPlus{ss}(1:5)]','newfig',0,'paired',0)
    title('MeanFz ep dur')
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
    subplot(3,3,3+(ss-1)*3)
    PlotErrorBarN_KJ([TotFzDurCsPlus{ss}(6:end);TotFzDurCsPlus{ss}(1:5)]','newfig',0,'paired',0)
    title('Tot Fz')
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})

end

figure
clf
for ss = 1:3
    
    subplot(3,3,1+(ss-1)*3)
    PlotErrorBarN_KJ([MeanNoFzEp{ss}(6:end);MeanNoFzEp{ss}(1:5)]','newfig',0,'paired',0)
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
    title('MeanNonFz ep dur')
    if ss==1
        ylabel('Hab')
    elseif ss==2
        ylabel('Test24h')
    elseif ss==3
        ylabel('Test48h')
    end
    subplot(3,3,2+(ss-1)*3)
    PlotErrorBarN_KJ([MenanFzEp{ss}(6:end);MenanFzEp{ss}(1:5)]','newfig',0,'paired',0)
    title('MeanFz ep dur')
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})
    subplot(3,3,3+(ss-1)*3)
    PlotErrorBarN_KJ([TotFzDur{ss}(6:end);TotFzDur{ss}(1:5)]','newfig',0,'paired',0)
    title('Tot Fz')
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Mtzl'})

end


figure(2)
clf
for ss = 1:3
    
    subplot(3,2,1+(ss-1)*2)
    plot([0:1:50],HistogramNoFzDur{ss}(6:end,:),'g')
    hold on
    plot([0:1:50],HistogramNoFzDur{ss}(1:5,:),'b')
    title('NonFz ep dur')
    ylim([0 1.1])
    subplot(3,2,2+(ss-1)*2)
    plot([0:1:50],HistogramFzDur{ss}(6:end,:),'g')
    hold on
    plot([0:1:50],HistogramFzDur{ss}(1:5,:),'b')
    title('Fz ep dur')
    ylim([0 1.1])
    
end

