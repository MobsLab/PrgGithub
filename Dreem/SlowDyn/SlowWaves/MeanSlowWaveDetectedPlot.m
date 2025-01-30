% MeanSlowWaveDetectedPlot
% 03.10.2018 KJ
%
% Infos
%   for each night :
%       - mean slow wave detected
%       
%
% SEE 
%   MeanSlowWaveDetected
% 


clear
load(fullfile(FolderSlowDynData,'MeanSlowWaveDetected.mat'))


%% pool
for ch =1:4
    all_sw{ch} = [];

    for p=1:length(curve_res.filereference)
        all_sw{ch} = [all_sw{ch} ; curve_res.met_slowwave{p,ch}(:,2)'];
    end
    
    
    %x, y & std
    mean_curves{ch} = median(all_sw{ch},1);
    std_curves{ch} = std(all_sw{ch},1) / sqrt(size(all_sw{ch},1));
    x_curves{ch} = curve_res.met_slowwave{p,ch}(:,1);
    
end

labels = labels_eeg(channels_frontal);


%% plot
figure, hold on

for ch=1:4
    subplot(2,2,ch), hold on
    for i=1:size(all_sw{ch},1)
        plot(x_curves{ch}, all_sw{ch}(i,:), 'linewidth',1), hold on
    end
    plot(x_curves{ch}, mean_curves{ch}, 'k', 'linewidth',3), hold on
    set(gca, 'ylim', [-100 100], 'fontsize', 18)
    line([0 0], ylim,'color',[0.5 0.5 0.5], 'linewidth',1), hold on
    title(labels{ch})
end
% legend(h, labels),


for ch=1:4
    subplot(2,2,ch), hold on
    set(gca, 'xtick', -1000:500:1000, 'ytick', -100:50:100)
end





