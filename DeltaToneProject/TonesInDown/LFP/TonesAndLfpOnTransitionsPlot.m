%%TonesAndLfpOnTransitionsPlot
% 03.10.2018 KJ
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


%% pool
for c=1:nb_clusters
    
    met_tones.up.down{c} = [];
    met_tones.up.up{c} = [];
    met_tones.down.up{c} = [];
    met_tones.down.down{c} = [];
    
    met_tones.st_down{c} = [];
    met_tones.end_down{c} = [];
    
    for p=1:length(tones_res.path)
        for ch=1:length(tones_res.clusters{p})
            if tones_res.clusters{p}(ch)==c
                met_tones.up.down{c}    = [met_tones.up.down{c} ; tones_res.up.down{p}{ch}(:,2)'];
                met_tones.up.up{c}      = [met_tones.up.up{c} ; tones_res.up.up{p}{ch}(:,2)'];
                met_tones.down.up{c}    = [met_tones.down.up{c} ; tones_res.down.up{p}{ch}(:,2)'];
                met_tones.down.down{c}  = [met_tones.down.down{c} ; tones_res.down.down{p}{ch}(:,2)'];
                
                met_tones.st_down{c}    = [met_tones.st_down{c} ; tones_res.st_down{p}{ch}(:,2)'];
                met_tones.end_down{c}   = [met_tones.end_down{c} ; tones_res.end_down{p}{ch}(:,2)'];
            end
        end
    end
    
    
    %mean
    mean_tones.up.down{c}   = mean(met_tones.up.down{c}, 1);
    mean_tones.up.up{c}     = mean(met_tones.up.up{c}, 1);
    mean_tones.down.down{c} = mean(met_tones.down.down{c}, 1);
    mean_tones.down.up{c}   = mean(met_tones.down.up{c}, 1);
    
    mean_tones.st_down{c}   = mean(met_tones.st_down{c}, 1);
    mean_tones.end_down{c}  = mean(met_tones.end_down{c}, 1);
    
    %mean
    std_tones.up.down{c}   = std(met_tones.up.down{c}, 1) / sqrt(size(met_tones.up.down{c}, 1));
    std_tones.up.up{c}     = std(met_tones.up.up{c}, 1) / sqrt(size(met_tones.up.up{c}, 1));
    std_tones.down.down{c} = std(met_tones.down.down{c}, 1) / sqrt(size(met_tones.down.down{c}, 1));
    std_tones.down.up{c}   = std(met_tones.down.up{c}, 1) / sqrt(size(met_tones.down.up{c}, 1));
    
    std_tones.st_down{c}   = std(met_tones.st_down{c}, 1) / sqrt(size(met_tones.st_down{c}, 1));
    std_tones.end_down{c}  = std(met_tones.end_down{c}, 1) / sqrt(size(met_tones.end_down{c}, 1));
    
end

%x
x_met = tones_res.st_down{1}{1}(:,1)';


%% plot 2
figure, hold on
labels_curve = {'down>up', 'End down', 'up>up'};
colors_curve = {'b', 'r', [1 0.27 0]};
gap = [0.08 0.05];

for c=1:nb_clusters
    subtightplot(2,3,c,gap), hold on
    try
        h(1) = plot(x_met, mean_tones.down.up{c} , 'color', colors_curve{1}); hold on
        h(2) = plot(x_met, mean_tones.end_down{c} , 'color', colors_curve{2}); hold on
        h(3) = plot(x_met, mean_tones.up.up{c} , 'color', colors_curve{3}); hold on
    end
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
    xlabel('time from tones'), xlim([-400 600]),
    title(['layer ' num2str(c)])
end
legend(h, labels_curve);
clear h

%% plot 1
figure, hold on
labels_cl = {'1','2','3','4','5'};
colors_cl = {'b', [1 0.27 0], 'g', 'k', [1 0.08 0.58]};
gap = [0.08 0.05];

%PFC down>up
subtightplot(2,3,1,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.down.up{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('Tones down>up')

%PFC down>down
subtightplot(2,3,2,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.down.down{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('Tones down>down')
 
%PFC on start of down
subtightplot(2,3,3,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.st_down{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from start of down'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('start down')

%PFC up>up
subtightplot(2,3,4,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.up.up{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('Tones up>up')

%PFC up>down
subtightplot(2,3,5,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.up.down{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from tones'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('Tones up>down')


%PFC on end of down
subtightplot(2,3,6,gap), hold on
for c=1:nb_clusters
    try
        h(c) = plot(x_met, mean_tones.end_down{c} , 'color', colors_cl{c}); hold on
    end
end
xlabel('time from end of down'), xlim([-400 600]), ylim([-1200 2000])
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
try, legend(h, labels_cl); end
title('end down')









