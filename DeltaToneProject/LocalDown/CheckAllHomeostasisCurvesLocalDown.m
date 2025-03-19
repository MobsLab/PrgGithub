%%CheckAllHomeostasisCurvesLocalDown
% 22.11.2019 KJ
%
% Infos
%   plot homeostasis for local global
%
% see
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisLocalGlobalDown.mat'))


%params
linewidt = 1.5;
fontsize = 20;

color_curve = [0.2 0.2 0.2];
color_peaks = [1 0 0];
color_fit = [0 0 1];



for p=1:length(homeo_res.path)
    
    figure, hold on
    %% Global Down
    subplot(2,3,1), hold on
   
    Hstat = homeo_res.global.rescaled.Hstat{p};

    plot(Hstat.x_intervals, Hstat.y_density*100, 'color', color_curve, 'linewidth',2), 
    scatter(Hstat.x_peaks, Hstat.y_peaks*100, 20,color_peaks,'filled') 
    plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_fit,'linewidth',2);
    title([homeo_res.name{p} ' - ' homeo_res.date{p}])
    
    %% Local Down
    
    for tt=1:length(homeo_res.tetrodes{p})
        
        subplot(2,3,1+tt), hold on

        Hstat = homeo_res.local.rescaled.Hstat{p,tt};

        plot(Hstat.x_intervals, Hstat.y_density*100, 'color', color_curve, 'linewidth',2), 
        scatter(Hstat.x_peaks, Hstat.y_peaks*100, 20,color_peaks,'filled') 
        plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_fit,'linewidth',2);
        title(['Tet ' num2str(homeo_res.tetrodes{p}(tt))])

    end
    
end




