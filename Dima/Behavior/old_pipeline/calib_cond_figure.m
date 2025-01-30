%%%%%% Script to plot parameters for calibration and conditioning sessions
% First plot is map of stimulations
% Second plot is freezing epochs
% Third plot is heart rate 10sec before and after first stumulations
% or all stimulations separated by more than a minute
% Fourth plot is ripples around stimulations

%% Housekeeping
res=pwd;
load ('behavResources.mat');
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

%% Number and place of stimulations

StimT_beh = find(PosMat(:,4)==1);

subplot(221)
imagesc(mask)
colormap gray
hold on
imagesc(Zone{1}, 'AlphaData', 0.3);
hold on
for i = 1:length(StimT_beh)
    plot(PosMat(StimT_beh(i),2)*Ratio_IMAonREAL, PosMat(StimT_beh(i),3)*Ratio_IMAonREAL, 'k*')
end
set(gca,'XTickLabel', [], 'YTickLabel', []);
title([num2str(length(StimT_beh)) ' stimulations'])

%% Stimulation-induced freezing
if isempty(Start(TTLInfo.StimEpoch))
    subplot(222)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else
    subplot(222)
    plot(Range(Imdifftsd,'s'), zeros(length(Imdifftsd), 1));
    ylim([0 1]); 
    hold on
    for k=1:length(Start(FreezeEpoch))
        h1 = plot(Range(Restrict(Imdifftsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeEpoch,k)))...
        *0+max(ylim)*0.5,'c','linewidth',2);
    end
    h2 = plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,1)*0+max(ylim)*0.6,'k*');
    if exist('ZoneEpoch')
        for k=1:length(Start(ZoneEpoch{1}))
            h3 = plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)))...
            *0+max(ylim)*0.65,'r','linewidth',2);
        end
        for k=1:length(Start(ZoneEpoch{2}))
            h4 = plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)))...
            *0+max(ylim)*0.65,'g','linewidth',2);
        end
    end
    legend([h1 h2 h3 h4], 'Freezing', 'Stims', 'Shock', 'NoShock', 'Location', 'NorthEast');
    xlabel('Time (s)');
    set(gca, 'YTickLabel', []);
    title('Stimulation-induced freezing');
end

%% Calculate and plot mean heart rate around the stimulatidir_outons (+/- 10 sec)
% Only the stimulations separated by a minute (or only the first one, if you don't have any)
load ('HeartBeatInfo.mat');

Stims = Start(TTLInfo.StimEpoch);
if isempty(Stims)
    subplot(223)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else
    ch = diff(Stims);
    idx = find(ch>60E4);
    if isempty(idx)
        EpochBefore = intervalSet(Stims(1)-10E4, Stims(1));
        EpochAfter = intervalSet(Stims(1), Stims(1)+10.2E4);
    else
        EpochBefore = intervalSet(Stims(idx)-10E4, Stims(idx));
        EpochAfter = intervalSet(Stims(idx), Stims(idx)+10.2E4);
    end
   
    RateBefore = Restrict(EKG.HBRate, EpochBefore);
    RateAfter = Restrict(EKG.HBRate, EpochAfter);
   
    avRateBefore = mean(Data(RateBefore));
    stdRateBefore = std(Data(RateBefore));
    avRateAfter = mean(Data(RateAfter));
    stdRateAfter = std(Data(RateAfter));

    subplot(223)
    bar([avRateBefore avRateAfter], 'FaceColor', 'k')
    hold on
    errorbar([avRateBefore avRateAfter], [stdRateBefore stdRateAfter],'.', 'Color', 'r');
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
    ylabel('Heart Rate (Hz)')
    xlim([0.5 2.5]);
    ylim([5 15]);
    title ('Heart Rate');
end

%% PETH Stim-Ripples
if isempty(Stims)
    subplot(224)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else

    load ('Ripples.mat');

    S = ts(ripples(:,2)*1E4);
    center = ts(Start(TTLInfo.StimEpoch));
    TStart = -3E4;
    TEnd = 3E4;

    is = intervalSet(Range(center)+TStart, Range(center)+TEnd);
    sweeps = intervalSplit(S, is, 'OffsetStart', TStart);

    rasterAx = subplot(224);
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontWeight', 'bold');
    set(gca, 'FontSize', 10);
    RasterPlot(sweeps,'AxHandle', rasterAx,'FigureHandle', fh, 'TStart', TStart, 'TEnd', TEnd, 'LineWidth', 2);
    xlim([-3000 3000]);
    xlabel('Time (ms)')

    title('Peri-stimulation ripples')
end

%% Save figure
saveas(fh, [res '/Stim_behavior_heart_ripples.fig']);
saveFigure(fh,'Stim_behavior_heart_ripples',res);