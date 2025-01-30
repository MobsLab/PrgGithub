clear all
%% Now use it
ToLoad = {'PAGAnalysis','EyeshockNotreatmentAnalysis','TempFLXProtPreDrugAnalysis','PreDrugAnalysis','PostDrugAnalysis',...
    'EyeshockExtNotreatmentAnalysis','TempFLXProtPostDrugExtAnalysis','PostDrugExtAnalysis'};

Split=[0,0,1,1,1,0,1,1];
Inj={[],[],[0,1,0,1],[0,4,0,1,1],[0,4,0,1,1],[],[0,1,0,1],[0,4,0,1,1]};

fig = figure;
ha = tight_subplot(2,length(ToLoad),0.03,0.05,0.05);
for t = 1%:length(ToLoad)
    load(ToLoad{t})
    clear  AllShockB AllSafeB AllShockH AllSafeH AllShockHLo AllSafeHLo
    for mm=1:size(SpecDataH,2)
        AllShockB(mm,:)=nanmean(SpecData{mm}.Shock);%./nanmean(nanmean(nanmean(SpecData{mm}.Shock)));
        AllSafeB(mm,:)=nanmean(SpecData{mm}.Safe);%./nanmean(nanmean(nanmean(SpecData{mm}.Safe)));
        AllShockH(mm,:)=nanmean(SpecDataH{mm}.Shock);%./nanmean(nanmean(nanmean(SpecDataH{mm}.Shock)));
        AllSafeH(mm,:)=nanmean(SpecDataH{mm}.Safe);%./nanmean(nanmean(nanmean(SpecDataH{mm}.Safe)));
        AllShockHLo(mm,:)=nanmean(SpecDataHLo{mm}.Shock);%./nanmean(nanmean(nanmean(SpecDataHLo{mm}.Shock)));
        AllSafeHLo(mm,:)=nanmean(SpecDataHLo{mm}.Safe);%./nanmean(nanmean(nanmean(SpecDataHLo{mm}.Safe)));
    end
    AllShock = (AllShockHLo);
    AllSafe = (AllSafeHLo);
    f = fLow;
    
    if Split(t) ==0
        axes(ha(t))
        %         subplot(2,length(ToLoad),t)
        [hl,hp]=boundedline( f,nanmean(AllShock),[stdError(AllShock);stdError(AllShock)]','r','alpha');hold on
        [hl,hp]=boundedline( f,nanmean(AllSafe),[stdError(AllSafe);stdError(AllSafe)]','b','alpha');
        title(ToLoad{t}(1:end-8))
        xlabel('Frequency(Hz)')
%         set(gca,'XTick',[0:5:20],'XTickLabel',{'0','5','10','15','20'})
        set(gca,'XTick',[0:50:200],'XTickLabel',{'0','50','100','150','200'})
%         line([6 6],ylim,'color','k')
%         line([3 3],ylim,'color','k')
    else
        axes(ha(t))
        %         subplot(2,length(ToLoad),t)
        try,[hl,hp]=boundedline( f,nanmean(AllShock(Inj{t}==0,:)),[stdError(AllShock(Inj{t}==0,:));stdError(AllShock(Inj{t}==0,:))]','r','alpha');hold on,end
        try,[hl,hp]=boundedline( f,nanmean(AllSafe(Inj{t}==0,:)),[stdError(AllSafe(Inj{t}==0,:));stdError(AllSafe(Inj{t}==0,:))]','b','alpha');,end
        title(ToLoad{t}(1:end-8))
        xlabel('Frequency(Hz)')
%         set(gca,'XTick',[0:5:20],'XTickLabel',{'0','5','10','15','20'})
        set(gca,'XTick',[0:50:200],'XTickLabel',{'0','50','100','150','200'})
%         line([6 6],ylim,'color','k')
%         line([3 3],ylim,'color','k')
        axes(ha(t+length(ToLoad)))
        %         subplot(2,length(ToLoad),t+length(ToLoad))
        try,[hl,hp]=boundedline( f,nanmean(AllShock(Inj{t}==1,:)),[stdError(AllShock(Inj{t}==1,:));stdError(AllShock(Inj{t}==1,:))]','r','alpha');hold on,end
        try,[hl,hp]=boundedline( f,nanmean(AllSafe(Inj{t}==1,:)),[stdError(AllSafe(Inj{t}==1,:));stdError(AllSafe(Inj{t}==1,:))]','b','alpha');,end
        xlabel('Frequency(Hz)')
%         set(gca,'XTick',[0:5:20],'XTickLabel',{'0','5','10','15','20'})
        set(gca,'XTick',[0:50:200],'XTickLabel',{'0','50','100','150','200'})
%         line([6 6],ylim,'color','k')
%         line([3 3],ylim,'color','k')
    end
end
axes(ha(13)),set(gca,'Color',[0.95 1 0.9])
axes(ha(15)),set(gca,'Color',[0.95 1 0.9])
axes(ha(16)),set(gca,'Color',[0.95 1 0.9])

saveas(fig,'HPCHiSPectraAllConditions.png')
saveas(fig,'HPCHiSPectraAllConditions.fig')

%% Time spent
figure
ha = tight_subplot(2,length(ToLoad),0.05,0.05,0.02);
for t = 1:length(ToLoad)
    load(ToLoad{t})
    FzTimeSk = nansum(FreezingTime.Shock');
    FzTimeSf = nansum(FreezingTime.Safe');

    if Split(t) ==0
        axes(ha(t))
        
        bar(1,nanmean(nanmean(FzTimeSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzTimeSk)),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzTimeSf'),(FzTimeSk')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 600])
        ylabel('Tot Time freezing')
        title(ToLoad{t}(1:end-8))
                line(xlim,[100 100])

        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    else
        
        axes(ha(t))
        bar(1,nanmean(nanmean(FzTimeSf(Inj{t}==0))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzTimeSk(Inj{t}==0))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzTimeSf(Inj{t}==0)'),(FzTimeSk(Inj{t}==0)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 600])
        ylabel('Tot Time freezing')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
                line(xlim,[100 100])

        axes(ha(t+length(ToLoad)))
        bar(1,nanmean(nanmean(FzTimeSf(Inj{t}==1))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzTimeSk(Inj{t}==1))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzTimeSf(Inj{t}==1)'),(FzTimeSk(Inj{t}==1)')},'distributionColors',[ 0 0 0;0 0 0;],'xValues',[1,2])
        ylim([0 600])
        line(xlim,[100 100])
        ylabel('Tot Time freezing')
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    end
end
axes(ha(13)),set(gca,'Color',[0.95 1 0.9])
axes(ha(15)),set(gca,'Color',[0.95 1 0.9])
axes(ha(16)),set(gca,'Color',[0.95 1 0.9])

saveas(fig,'TimeSpentFreezingAllConditions.png')
saveas(fig,'TimeSpentFreezingAllConditions.fig')



%% HB rate
figure
ha = tight_subplot(2,length(ToLoad),0.05,0.05,0.02);
for t = 1:length(ToLoad)
    load(ToLoad{t})
    clear  HRSk HRSf HRMv

     for mm = 1:size(HRInfo.Shk,1)
        for c=1:size(HRInfo.Shk,2)
            if isempty( HRInfo.Shk{mm,c})
                HRSk(mm,c) =NaN;
            else
                HRSk(mm,c) = HRInfo.Shk{mm,c}.MeanHR;
            end
            if isempty( HRInfo.Sf{mm,c})
                HRSf(mm,c) =NaN;
            else
                HRSf(mm,c) = HRInfo.Sf{mm,c}.MeanHR;
            end
            if isempty( HRInfo.Mv{mm,c})
                HRMv(mm,c) =NaN;
            else
                HRMv(mm,c) = HRInfo.Mv{mm,c}.MeanHR;
            end
            
        end
     end
    
    if Split(t) ==0
        axes(ha(t))
        bar(1,nanmean(nanmean(HRSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk)),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv)),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf'),nanmean(HRSk'),nanmean(HRMv')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})
        
    else
        
        axes(ha(t))
        bar(1,nanmean(nanmean(HRSf(Inj{t}==0,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj{t}==0,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj{t}==0,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj{t}==0,:)'),nanmean(HRSk(Inj{t}==0,:)'),nanmean(HRMv(Inj{t}==0,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        title(ToLoad{t})
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})

        axes(ha(t+length(ToLoad)))
        bar(1,nanmean(nanmean(HRSf(Inj{t}==1,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj{t}==1,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj{t}==1,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj{t}==1,:)'),nanmean(HRSk(Inj{t}==1,:)'),nanmean(HRMv(Inj{t}==1,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 14])
        ylabel('HR (Hz)')
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})
    end
end
axes(ha(13)),set(gca,'Color',[0.95 1 0.9])
axes(ha(15)),set(gca,'Color',[0.95 1 0.9])
axes(ha(16)),set(gca,'Color',[0.95 1 0.9])

saveas(fig,'HeartRateAllConditions.png')
saveas(fig,'HeartRateAllConditions.fig')

%% HB var
figure
ha = tight_subplot(2,length(ToLoad),0.05,0.05,0.02);
for t = 1:length(ToLoad)
    load(ToLoad{t})
    clear  HRSk HRSf HRMv

     for mm = 1:size(HRInfo.Shk,1)
        for c=1:size(HRInfo.Shk,2)
            if isempty( HRInfo.Shk{mm,c})
                HRSk(mm,c) =NaN;
            else
                HRSk(mm,c) = HRInfo.Shk{mm,c}.StdHR;
            end
            if isempty( HRInfo.Sf{mm,c})
                HRSf(mm,c) =NaN;
            else
                HRSf(mm,c) = HRInfo.Sf{mm,c}.StdHR;
            end
            if isempty( HRInfo.Mv{mm,c})
                HRMv(mm,c) =NaN;
            else
                HRMv(mm,c) = HRInfo.Mv{mm,c}.StdHR;
            end
            
        end
     end
    
    if Split(t) ==0
        axes(ha(t))
        bar(1,nanmean(nanmean(HRSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk)),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv)),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf'),nanmean(HRSk'),nanmean(HRMv')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})
        
    else
        
        axes(ha(t))
        bar(1,nanmean(nanmean(HRSf(Inj{t}==0,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj{t}==0,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj{t}==0,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj{t}==0,:)'),nanmean(HRSk(Inj{t}==0,:)'),nanmean(HRMv(Inj{t}==0,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        title(ToLoad{t})
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})

        axes(ha(t+length(ToLoad)))
        bar(1,nanmean(nanmean(HRSf(Inj{t}==1,:))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(HRSk(Inj{t}==1,:))),'FaceColor',[1 0.6 0.6]), hold on
        bar(3,nanmean(nanmean(HRMv(Inj{t}==1,:))),'FaceColor',[0.6 0.6 0.6]), hold on
        plotSpread({nanmean(HRSf(Inj{t}==1,:)'),nanmean(HRSk(Inj{t}==1,:)'),nanmean(HRMv(Inj{t}==1,:)')},'distributionColors',[ 0 0 0;0 0 0;0 0 0],'xValues',[1,2,3])
        ylim([0 2])
        ylabel('HR var')
        set(gca,'XTick',[1,2,3],'XTickLabel',{'Safe','Shock','Mov'})
    end
end
axes(ha(13)),set(gca,'Color',[0.95 1 0.9])
axes(ha(15)),set(gca,'Color',[0.95 1 0.9])
axes(ha(16)),set(gca,'Color',[0.95 1 0.9])

saveas(fig,'HeartRateVarAllConditions.png')
saveas(fig,'HeartRateAllConditions.fig')

%% ripples

figure
ha = tight_subplot(2,length(ToLoad),0.05,0.05,0.02);
for t = 1:length(ToLoad)
    load(ToLoad{t})
    
        RipSk = nansum(NumRip.Shock.Sleep')./nansum(DurPer.Shock.Sleep');
        RipSf = nansum(NumRip.Safe.Sleep')./nansum(DurPer.Safe.Sleep');

    if Split(t) ==0
        axes(ha(t))
        
        bar(1,nanmean(nanmean(RipSf)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk)),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf'),(RipSk')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripple /s')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    else
        
        axes(ha(t))
        bar(1,nanmean(nanmean(RipSf(Inj{t}==0))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk(Inj{t}==0))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf(Inj{t}==0)'),(RipSk(Inj{t}==0)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripple /s')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
        
        axes(ha(t+length(ToLoad)))
        bar(1,nanmean(nanmean(RipSf(Inj{t}==1))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(RipSk(Inj{t}==1))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(RipSf(Inj{t}==1)'),(RipSk(Inj{t}==1)')},'distributionColors',[ 0 0 0;0 0 0;],'xValues',[1,2])
        ylim([0 1])
        ylabel('Ripple /s')
        set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
    end
end
axes(ha(13)),set(gca,'Color',[0.95 1 0.9])
axes(ha(15)),set(gca,'Color',[0.95 1 0.9])
axes(ha(16)),set(gca,'Color',[0.95 1 0.9])

saveas(fig,'RippleNumberAllConditions.png')
saveas(fig,'RippleNumberAllConditions.fig')



figure
ToLoad = {'EyeshockExtNotreatmentAnalysis','TempFLXProtPostDrugExtAnalysis','PostDrugExtAnalysis'};
Split=[0,1,1];
Inj={[],[0,1,0,1],[0,4,0,1,1]};
ha = tight_subplot(2,length(ToLoad)*2,0.05,0.05,0.02);
for t = 1:length(ToLoad)
    load(ToLoad{t})
    clear FzCumSumToPlot NoFzCumSumToPlot FzMeanDur NoFzMeanDur
    for mm = 1:size(FzEpochLg,2)
        FzCumSumToPlot.Safe(mm,:) = cumsum(hist(FzEpochLg{mm}.Safe,[0:0.2:100])/length(FzEpochLg{mm}.Safe));
        FzCumSumToPlot.Shock(mm,:) = cumsum(hist(FzEpochLg{mm}.Shock,[0:0.2:100])/length(FzEpochLg{mm}.Shock));
        FzMeanDur.Safe(mm) = nansum(FzEpochLg{mm}.Safe);
        FzMeanDur.Shock(mm) = nansum(FzEpochLg{mm}.Shock);
        
        NoFzCumSumToPlot.Safe(mm,:) = cumsum(hist(NoFzEpochLg{mm}.Safe,[0:0.2:100])/length(NoFzEpochLg{mm}.Safe));
        NoFzCumSumToPlot.Shock(mm,:) = cumsum(hist(NoFzEpochLg{mm}.Shock,[0:0.2:100])/length(NoFzEpochLg{mm}.Shock));
        NoFzMeanDur.Safe(mm) = nansum(NoFzEpochLg{mm}.Safe);
        NoFzMeanDur.Shock(mm) = nansum(NoFzEpochLg{mm}.Shock);
    end
    
    if Split(t) ==0
        axes(ha((t-1)*2+1))
        bar(1,nanmean(nanmean(FzMeanDur.Safe)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzMeanDur.Shock)),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzMeanDur.Safe'),(FzMeanDur.Shock')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylabel('Mean Fz EpDur')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeFz','ShockFz'})
        ylim([0 50])

        axes(ha((t-1)*2+2))
        bar(1,nanmean(nanmean(NoFzMeanDur.Safe)),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(NoFzMeanDur.Shock)),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(NoFzMeanDur.Safe'),(NoFzMeanDur.Shock')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 350])
        ylabel('Mean NoFz EpDur')
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeNoFz','ShockNoFz'})
        
    else
      
        axes(ha((t-1)*2+1))
        bar(1,nanmean(nanmean(FzMeanDur.Safe(Inj{t}==0))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzMeanDur.Shock(Inj{t}==0))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzMeanDur.Safe(Inj{t}==0)'),(FzMeanDur.Shock(Inj{t}==0)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylabel('Mean Fz EpDur')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeFz','ShockFz'})
        ylim([0 50])

        axes(ha((t-1)*2+2))
        bar(1,nanmean(nanmean(NoFzMeanDur.Safe(Inj{t}==0))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(NoFzMeanDur.Shock(Inj{t}==0))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(NoFzMeanDur.Safe(Inj{t}==0)'),(NoFzMeanDur.Shock(Inj{t}==0)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 350])
        ylabel('Mean NoFz EpDur')
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeNoFz','ShockNoFz'})
        
        axes(ha((t-1)*2+1+length(ToLoad)*2))
        bar(1,nanmean(nanmean(FzMeanDur.Safe(Inj{t}==1))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(FzMeanDur.Shock(Inj{t}==1))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(FzMeanDur.Safe(Inj{t}==1)'),(FzMeanDur.Shock(Inj{t}==1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylabel('Mean Fz EpDur')
        title(ToLoad{t}(1:end-8))
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeFz','ShockFz'})
        ylim([0 50])

        axes(ha((t-1)*2+2+length(ToLoad)*2))
        bar(1,nanmean(nanmean(NoFzMeanDur.Safe(Inj{t}==1))),'FaceColor',[0.6 0.6 1]), hold on
        bar(2,nanmean(nanmean(NoFzMeanDur.Shock(Inj{t}==1))),'FaceColor',[1 0.6 0.6]), hold on
        plotSpread({(NoFzMeanDur.Safe(Inj{t}==1)'),(NoFzMeanDur.Shock(Inj{t}==1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[1,2])
        ylim([0 350])
        ylabel('Mean NoFz EpDur')
        set(gca,'XTick',[1,2],'XTickLabel',{'SafeNoFz','ShockNoFz'})
    end
end
