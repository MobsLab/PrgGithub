%%ParcoursRipplesNoDownNeuronCrossCorrPlot 
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to ripples with no down before & after - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNoDownNeuronCrossCorr ParcoursRipplesNeuronCrossCorrPlot
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNoDownNeuronCrossCorr.mat'))


%% concatenate
AllPeth = [];
AllPethStart = [];

for p=1:length(ripnodown_res.path)
    AllPeth = [AllPeth ; ripnodown_res.MatRipples{p}];
    AllPethStart = [AllPethStart ; ripnodown_res.start.MatRipples{p}];
end

t_corr = ripnodown_res.t_corr{1};


%% zscore 
Zpeth = zscore(AllPeth,[],2);
ZpethStart = zscore(AllPethStart,[],2);

%ordered by time response
[~,idmax] = max(Zpeth,[],2);
[~,id2] = sort(idmax);
Ord_peth = Zpeth(id2,:);

%ordered by time response start
[~,idmax] = max(ZpethStart,[],2);
[~,id2] = sort(idmax);
Ord_pethStart = ZpethStart(id2,:);

%mean mua
y_mua = mean(Ord_peth,1);
y_mua_start = mean(Ord_pethStart,1);


%% plot

%ordered
figure, hold on
subplot(4,1,1), hold on
plot(t_corr, y_mua),
xlim([-500 500]), ylim([-0.4 0.4]),
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(t_corr, 1:size(Ord_peth,1), Ord_peth);
xlim([-500 500]), ylim([1 size(Ord_peth,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on ripples with no down before & after (all records)')


%% on start ripples

%ordered
figure, hold on
subplot(4,1,1), hold on
plot(t_corr, y_mua_start),
xlim([-500 500]), ylim([-0.4 1]),
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(t_corr, 1:size(Ord_pethStart,1), Ord_pethStart);
xlim([-500 500]), ylim([1 size(Ord_pethStart,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on ripples start with no down before & after (all records)')
