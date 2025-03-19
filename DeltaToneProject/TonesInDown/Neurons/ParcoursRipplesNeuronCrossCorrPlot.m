%%ParcoursRipplesNeuronCrossCorrPlot
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNeuronCrossCorr NeuronsResponseToRipples_KJ
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))


%% concatenate
AllPeth = [];
AllPethStart = [];
for p=1:length(rippeth_res.path)
    if strcmpi(rippeth_res.manipe{p}, 'tone')
        AllPeth = [AllPeth ; rippeth_res.MatRipples{p}];
        AllPethStart = [AllPethStart ; rippeth_res.start.MatRipples{p}];
    end
end

t_corr = rippeth_res.t_corr{1};


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

figure, hold on
subplot(4,1,1), hold on
plot(t_corr, y_mua),
xlim([-500 500]), ylim([-0.5 1.2]),
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(t_corr, 1:size(Ord_peth,1), Ord_peth);
xlim([-500 500]), ylim([1 size(Ord_peth,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on ripples (all records)')


%% on start ripples

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
title('Neurons on ripples start (all records)')



