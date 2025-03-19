%%RipplesAndLfpOnTransitionsPlot
% 03.10.2018 KJ
%
%
%
% see
%   RipplesAndLfpOnTransitions RipplesAndLfpOnTransitionsPlot
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesAndLfpOnTransitions.mat'))

%params
nb_clusters = 5;


%% pool
for c=1:nb_clusters
    
    met_ripples.up.down{c} = [];
    met_ripples.up.up{c} = [];
    met_ripples.down.up{c} = [];
    met_ripples.down.down{c} = [];
    
    met_ripples.st_down{c} = [];
    met_ripples.end_down{c} = [];
    
    for p=1:length(ripples_res.path)
        for ch=1:length(ripples_res.clusters{p})
            if ripples_res.clusters{p}(ch)==c
                met_ripples.up.down{c}    = [met_ripples.up.down{c} ; ripples_res.up.down{p}{ch}(:,2)'];
                met_ripples.up.up{c}      = [met_ripples.up.up{c} ; ripples_res.up.up{p}{ch}(:,2)'];
                met_ripples.down.up{c}    = [met_ripples.down.up{c} ; ripples_res.down.up{p}{ch}(:,2)'];
                met_ripples.down.down{c}  = [met_ripples.down.down{c} ; ripples_res.down.down{p}{ch}(:,2)'];
                
                met_ripples.st_down{c}    = [met_ripples.st_down{c} ; ripples_res.st_down{p}{ch}(:,2)'];
                met_ripples.end_down{c}   = [met_ripples.end_down{c} ; ripples_res.end_down{p}{ch}(:,2)'];
            end
        end
    end
    
    
    %mean
    mean_ripples.up.down{c}   = mean(met_ripples.up.down{c}, 1);
    mean_ripples.up.up{c}     = mean(met_ripples.up.up{c}, 1);
    mean_ripples.down.down{c} = mean(met_ripples.down.down{c}, 1);
    mean_ripples.down.up{c}   = mean(met_ripples.down.up{c}, 1);
    
    mean_ripples.st_down{c}   = mean(met_ripples.st_down{c}, 1);
    mean_ripples.end_down{c}  = mean(met_ripples.end_down{c}, 1);
    
    %mean
    std_ripples.up.down{c}   = std(met_ripples.up.down{c}, 1) / sqrt(size(met_ripples.up.down{c}, 1));
    std_ripples.up.up{c}     = std(met_ripples.up.up{c}, 1) / sqrt(size(met_ripples.up.up{c}, 1));
    std_ripples.down.down{c} = std(met_ripples.down.down{c}, 1) / sqrt(size(met_ripples.down.down{c}, 1));
    std_ripples.down.up{c}   = std(met_ripples.down.up{c}, 1) / sqrt(size(met_ripples.down.up{c}, 1));
    
    std_ripples.st_down{c}   = std(met_ripples.st_down{c}, 1) / sqrt(size(met_ripples.st_down{c}, 1));
    std_ripples.end_down{c}  = std(met_ripples.end_down{c}, 1) / sqrt(size(met_ripples.end_down{c}, 1));
    
end

%x
x_met = ripples_res.st_down{1}{1}(:,1)';


%% plot
figure, hold on
labels_cl = {'1','2','3','4','5'};
colors_cl = {'b', [1 0.27 0], 'g', 'k', [1 0.08 0.58]};
gap = [0.08 0.05];

%PFC down>up
subtightplot(2,3,1,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.down.up{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from ripples'), xlim([-400 800]),
legend(h, labels_cl);
title('Ripples down>up')

%PFC down>down
subtightplot(2,3,2,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.down.down{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from ripples'), xlim([-400 800]),
legend(h, labels_cl);
title('Ripples down>down')
 
%PFC on start of down
subtightplot(2,3,3,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.st_down{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from start of down'), xlim([-400 800]),
legend(h, labels_cl);
title('start down')

%PFC up>up
subtightplot(2,3,4,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.up.up{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from ripples'), xlim([-400 800]),
legend(h, labels_cl);
title('Ripples up>up')

%PFC up>down
subtightplot(2,3,5,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.up.down{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from ripples'), xlim([-400 800]),
legend(h, labels_cl);
title('Ripples up>down')


%PFC on end of down
subtightplot(2,3,6,gap), hold on
for c=1:nb_clusters
    h(c) = plot(x_met, mean_ripples.end_down{c} , 'color', colors_cl{c}); hold on
end
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
xlabel('time from end of down'), xlim([-400 800]),
legend(h, labels_cl);
title('end down')









