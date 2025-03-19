%%PlotAllHomeostasisCurvesFakeRealDelta2
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
linewidt = 2;
filterFactor = 1;
color_peaks = [1 0 0];
color_expfit = [0 0.5 0];
path_exclude = [3 7 12 13 16 17];

Down.all_x = []; Down.all_y = [];
Realdt.all_x = []; Realdt.all_y = [];
FakeDt.all_x = []; FakeDt.all_y = [];


for p=1:length(homeo_res.path)
    
    if ismember(p,path_exclude)
        continue
    end

    %Down
    Hstat = homeo_res.down.rescaled.Hstat{p};
    x_peaks = Hstat.x_peaks;
    y_peaks = Hstat.y_peaks*100;
    Sdown.x = Hstat.x_intervals(Hstat.x_intervals>=x_peaks(1) & Hstat.x_intervals<=x_peaks(end));
    Sdown.y = interp1(x_peaks, y_peaks, Sdown.x, 'pchip'); 
    Down.all_x = [Down.all_x ; Sdown.x];
    Down.all_y = [Down.all_y ; Sdown.y];
    
    %Real delta
    Hstat = homeo_res.delta.rescaled.Hstat{p};
    x_peaks = Hstat.x_peaks;
    y_peaks = Hstat.y_peaks*100;
    Sdelta.x = Hstat.x_intervals(Hstat.x_intervals>=x_peaks(1) & Hstat.x_intervals<=x_peaks(end));
    Sdelta.y = interp1(x_peaks, y_peaks, Sdelta.x, 'pchip'); 
    Realdt.all_x = [Realdt.all_x ; Sdelta.x];
    Realdt.all_y = [Realdt.all_y ; Sdelta.y];
    
    %Fake delta
    Hstat = homeo_res.other.rescaled.Hstat{p};
    x_peaks = Hstat.x_peaks;
    y_peaks = Hstat.y_peaks*100;
    Sfake.x = Hstat.x_intervals(Hstat.x_intervals>=x_peaks(1) & Hstat.x_intervals<=x_peaks(end));
    Sfake.y = interp1(x_peaks, y_peaks, Sfake.x, 'pchip'); 
    FakeDt.all_x = [FakeDt.all_x ; Sfake.x];
    FakeDt.all_y = [FakeDt.all_y ; Sfake.y];

end


%% Plot

figure, hold on

%Down
subplot(1,3,1), hold on
densityScatter([Down.all_x Down.all_y]',{'filterFactor',filterFactor,'markerSize',sz});
%fit
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.down.rescaled.Hstat{p};
    h(1) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit,'linewidth',linewidt);
end
set(gca, 'ylim', [0 350]),
legend(h, 'exponential fit')
ylabel('Down occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Down states')


%Real dt
subplot(1,3,2), hold on
densityScatter([Realdt.all_x Realdt.all_y]',{'filterFactor',filterFactor});
%fit
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.delta.rescaled.Hstat{p};
    h(1) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit,'linewidth',linewidt);
end
set(gca, 'ylim', [0 350]),
legend(h, 'exponential fit')
ylabel('Delta occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Delta with down')


%Fake Dt
subplot(1,3,3), hold on
densityScatter([FakeDt.all_x FakeDt.all_y]',{'filterFactor',filterFactor});
%fit
for p=1:length(homeo_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = homeo_res.other.rescaled.Hstat{p};
    h(1) = plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_expfit,'linewidth',linewidt);
end
set(gca, 'ylim', [0 350]),
legend(h, 'exponential fit')
ylabel('Delta occupancy (% of NREM average)'), xlabel('Time (hour)')
title('Fake Delta')








