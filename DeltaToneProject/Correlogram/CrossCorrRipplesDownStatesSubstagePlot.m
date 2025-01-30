%%CrossCorrRipplesDownStatesSubstagePlot
% 18.09.2018 KJ
%
%   Look at the response of neurons to ripples - PETH Cross-Corr
%
% see
%   CrossCorrRipplesDownStatesSubstage
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'CrossCorrRipplesDownStatesSubstage.mat'))


%% Pool

CC.start.all = [];
CC.end.all = [];
for p=1:length(ripdown_res.path)
    CC.start.all = [CC.start.all ; ripdown_res.startdown{p}'];
    CC.end.all = [CC.end.all ; ripdown_res.startdown{p}'];
end


for s=1:5
    CC.startdown{s} = [];
    CC.enddown{s}   = [];
    for p=1:length(ripdown_res.path)
        %start down
        CC.startdown{s} = [CC.startdown{s}; ripdown_res.substage.startdown{p,s}'];
        %end down
        CC.enddown{s} = [CC.enddown{s} ; ripdown_res.substage.enddown{p,s}'];
    end
end
t_corr = ripdown_res.t_corr{1};


%% average
for s=1:5
    mean_cc.start{s} = mean(CC.startdown{s}, 1);
    std_cc.start{s} = stdError(CC.startdown{s}) / sqrt(size(CC.startdown{s},1));
    
    mean_cc.end{s} = mean(CC.enddown{s}, 1);
    std_cc.end{s} = stdError(CC.enddown{s}) / sqrt(size(CC.enddown{s},1));
end


%% Plot
fontsize = 13;

figure, hold on

subplot(2,2,1), hold on
plot(t_corr, mean_cc.start{2},'color','b','linewidth',2), hold on
% shadedErrorBar(t_corr, mean_cc.start{2}, std_cc.start{2}, 'k'); hold on
set(gca,'Fontsize',fontsize);
line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
xlabel('time from Ripples (ms)'),
title('Ripples vs Down starts in N2'),

subplot(2,2,2), hold on
plot(t_corr, mean_cc.end{2},'color','b','linewidth',2), hold on
set(gca,'Fontsize',fontsize);
line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
xlabel('time from Ripples (ms)'),
title('Ripples vs Down ends in N2')

subplot(2,2,3), hold on
plot(t_corr, mean_cc.start{3},'color','b','linewidth',2), hold on
set(gca,'Fontsize',fontsize);
line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
xlabel('time from Ripples (ms)'),
title('Ripples vs Down starts in N3')

subplot(2,2,4), hold on
plot(t_corr, mean_cc.end{3},'color','b','linewidth',2), hold on
set(gca,'Fontsize',fontsize);
line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
xlabel('time from Ripples (ms)'),
title('Ripples vs Down ends in N3')






