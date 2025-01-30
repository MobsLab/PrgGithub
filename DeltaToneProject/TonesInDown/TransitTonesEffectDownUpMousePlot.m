%%TransitTonesEffectDownUpMousePlot
% 04.06.2018 KJ
%
% Assess the effect of a failed tones on the activity
%   -> plot
%
% see
%   TransitTonesEffectDownUp FailedTonesEffectUpDownMousePlot
% 


%load
clear
load(fullfile(FolderDeltaDataKJ,'TransitTonesEffectDownUp.mat'))



%% PLOT
smoothing = 1;

all_curves = [];

figure, hold on
for p=1:4% length(failed_res.path)
    subplot(2,2,p), hold on
    
    tones.x_corr = transit_res.tones.corr.x{p};
    tones.y_corr = transit_res.tones.corr.y{p};
    
    sham.x_corr = transit_res.sham.corr.x{p};
    sham.y_corr = transit_res.sham.corr.y{p};
    
    
    %plot
    h(1) = plot(tones.x_corr, tones.y_corr, 'color', 'k', 'LineWidth',2); hold on,
    h(2) = plot(sham.x_corr, sham.y_corr, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,
    xlabel('time (ms) from tones/sham'), ylabel('probability')
    line([0 0], ylim,'Linewidth',2,'color','w'), hold on
    title(transit_res.name{p})
    legend(h,'Tones','Sham')
    
end
suplabel('Correlogram on tones/sham at the down>up vs down states','t');


%% PLOT Mean FR on tones/sham
smoothing = 2;

figure, hold on
for p=1:4%length(failed_res.path)
    subplot(2,2,p), hold on
    
    tones.x_mua = transit_res.tones.mua{p}(:,1);
    tones.y_mua = Smooth(transit_res.tones.mua{p}(:,2), smoothing);
    tones.sem_mua = transit_res.tones.mua{p}(:,4);
    
    sham.x_mua = transit_res.sham.mua{p}(:,1);
    sham.y_mua = Smooth(transit_res.sham.mua{p}(:,2), smoothing);
    sham.sem_mua = transit_res.sham.mua{p}(:,4); 
    
    %plot
    h(1) = plot(tones.x_mua, tones.y_mua, 'color', 'k', 'LineWidth',2); hold on,
    h(2) = plot(sham.x_mua, sham.y_mua, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,
    xlabel('time (ms) from tones/sham'), ylabel('firing rate')
    line([0 0], ylim,'Linewidth',2,'color','w'), hold on
    title(transit_res.name{p})
    legend(h,'Tones','Sham')
        
end

suplabel('Mean FR on tones/sham at the down>up','t');

