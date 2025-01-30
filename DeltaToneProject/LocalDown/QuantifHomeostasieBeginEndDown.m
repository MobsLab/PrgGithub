%%QuantifHomeostasieBeginEndDown
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaOccupancy.mat'))


% local global sync
for p=1:length(homeo_res.path)

    
    %% epoch for comparison
    
    homeo_start = homeo_res.down.global.x_peaks{p}(1);
    homeo_end = homeo_res.down.global.x_peaks{p}(end);
    
    firstEpoch = [homeo_start, homeo_start+2];
    lastEpoch = [homeo_end-2, homeo_end];
        
    quarter_night = (homeo_end - homeo_start) / 4;
    for i=1:4
        Quarters{i} = homeo_start + [quarter_night*(i-1), quarter_night*i];
    end

    
    %% quantif first and last two hours
    firstEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>firstEpoch(1) & ratio.x_density<=firstEpoch(2)));
    lastEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>lastEpoch(1) & ratio.x_density<=lastEpoch(2)));
    
    for i=1:4
        quartersEp_ratio{i}(p,1) = nanmean(ratio.y_density(ratio.x_density>Quarters{i}(1) & ratio.x_density<=Quarters{i}(2)));
    end
end









