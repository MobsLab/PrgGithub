%%PlotAllHomeostasisCurvesLocalGlobal2
% 24.09.2019 KJ
%
% Infos
%   plot homeostasis for real and fake delta waves
%
% see
%    PlotAllHomeostasisCurvesFakeRealDelta PlotAllHomeostasisCurvesLocalGlobal
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisLocalGlobalDown.mat'))


%params
sz = 2;
linewidt = 1.5;
color_peaks = [0.6 0.6 0.6];
color_expfit = {[0 0.5 0], [0 0 1], [0.3 0.3 0.3], [0.78 0.08 0.52]};
path_exclude = [2 5 12 13 16:18];
fontsize = 20;

figure, hold on

%% Global Down
subplot(1,3,1), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.global.rescaled.Hstat{p};
    if any(Hstat.reg_exp*100>300)
        continue
    end
    h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);    
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.global.rescaled.Hstat{p};
    if any(Hstat.reg_exp*100>300)
        continue
    end
    %fit
    h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{1},'linewidth',linewidt);
end


set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
legend(h, 'Occupancy', 'exponential fit')
ylabel('Global Down Occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Global Down states')


%% Local Down
subplot(1,3,2), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
        if any(Hstat.reg_exp*100>300) || any(Hstat.reg_exp==0)
            continue
        end
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
        if any(Hstat.reg_exp*100>300) || any(Hstat.reg_exp==0)
            continue
        end
        %fit
        h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{2},'linewidth',linewidt);
    end
end
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
ylabel('Local Down occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Local Down states')




figure, hold on

%% Global Down
subplot(1,3,1), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.union.rescaled.Hstat{p};
    if any(Hstat.reg_exp*100>250)
        continue
    end
    h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);    
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.union.rescaled.Hstat{p};
    if any(Hstat.reg_exp*100>250)
        continue
    end
    %fit
    h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{3},'linewidth',linewidt);
end


set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
legend(h, 'Occupancy', 'exponential fit')
ylabel('Occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Union of down states')


%% Local Down
subplot(1,3,2), hold on
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.all_local.rescaled.Hstat{p,tt};
        if any(Hstat.reg_exp*100>250) || any(Hstat.reg_exp==0)
            continue
        end
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.all_local.rescaled.Hstat{p,tt};
        if any(Hstat.reg_exp*100>250) || any(Hstat.reg_exp==0)
            continue
        end
        %fit
        h(2) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit{4},'linewidth',linewidt);
    end
end
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
ylabel('Occupancy (% of NREM average)'), xlabel('Time (hour)')
title('All local Down (by tetrode)')


