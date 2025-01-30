%%TonesAndLfpOnTransitionsPlot2
% 18.04.2019 KJ
%
%
%
%
% see
%   ScriptTonesOnDeltaWavesEffect TonesAndLfpOnTransitions
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'TonesAndLfpOnTransitions.mat'))

%params
nb_clusters = 5;
%x
x_met = tones_res.st_down{1}{1}(:,1)';

%% pool
for c=1:nb_clusters
    
    figure, hold on
    labels_curve = {'down>up', 'End down', 'up>up'};
    colors_curve = {'b', 'r', [1 0.27 0]};
    gap = [0.08 0.05];
    
    %Down>Up
    subplot(2,3,1), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.down.up{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('Down>Up'),
    
    %Down>Down
    subplot(2,3,2), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.down.down{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('Down>Down'),
    
    %Start Down
    subplot(2,3,3), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.st_down{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('Start down'),
    
    %Up>Down
    subplot(2,3,4), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.up.down{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('Up>Down'),
    
    
    %Up>Up
    subplot(2,3,5), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.up.up{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('Up>Up'),
    
    %End Down
    subplot(2,3,6), hold on
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                plot(x_met, tones_res.end_down{p}{ch}(:,2));
            end
        end
    end
    xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    title('End down'),
    
    
    suplabel(['cluster' num2str(c)], 't');
    
end
    
    
    
    










