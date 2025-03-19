%%PlotAllHomeostasisCurvesFakeRealDelta
% 24.09.2019 KJ
%
% Infos
%   plot homeostasis for real and fake delta waves
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta QuantifHomeostasisPFCdeepFakeDeltaPlotAll
%    QuantifHomeostasisPFCdeepFakeDeltaPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCdeepFakeDelta.mat'))


%params
sz = 2;
linewidt = 1.5;
color_peaks = [0.6 0.6 0.6];
color_expfit = {'k','b','r'};
path_exclude = [3 7 12 13 16 17];
fontsize = 20;

figure, hold on

%% Down Homeo
subplot(1,3,1), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.down.rescaled.Hstat{p};
    h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);    
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.down.rescaled.Hstat{p};
    %fit
    h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{1},'linewidth',linewidt);
end


set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
legend(h, 'Occupancy', 'exponential fit')
ylabel('Down Occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Down states')


%% Real Delta Homeo
subplot(1,3,2), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.delta.rescaled.Hstat{p,ch};
        if any(Hstat.reg_exp*100>300)
            continue
        end
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.delta.rescaled.Hstat{p,ch};
        if any(Hstat.reg_exp*100>300)
            continue
        end
        %fit
        h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{2},'linewidth',linewidt);
    end
end
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
ylabel('Real SW occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Real Slow Wave')

%% fake delta
subplot(1,3,3), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other.rescaled.Hstat{p,ch};
        if any(Hstat.reg_exp*100>250) || any(Hstat.reg_exp*100==0)
            continue
        end
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other.rescaled.Hstat{p,ch};
        if any(Hstat.reg_exp*100>250) || any(Hstat.reg_exp*100==0)
            continue
        end
        %fit
        h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{3},'linewidth',linewidt);
    end
end
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
ylabel('Fake SW occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Fake Slow Wave')




