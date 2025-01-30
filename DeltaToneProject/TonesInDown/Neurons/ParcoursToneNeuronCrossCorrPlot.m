cd%%ParcoursToneNeuronCrossCorrPlot
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to tones - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursToneNeuronCrossCorr 
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursToneNeuronCrossCorr.mat'))


%% concatenate
AllPeth = [];
for p=1:4%length(tonepeth_res.path)
    AllPeth = [AllPeth ; tonepeth_res.MatTones{p}];
end

t_corr = tonepeth_res.t_corr{1};


%% zscore
Zpeth = zscore(AllPeth,[],2);

%ordered by a
[mean_after] = mean(Zpeth(:,100:130),2);
[~,id2] = sort(mean_after);
Ord_peth = Zpeth(id2,:);

%ordered by time response
[~,idmax] = max(Zpeth,[],2);
[~,id2] = sort(idmax);
Ord_peth = Zpeth(id2,:);

y_mua = mean(Ord_peth,1);

%% plot

%ordered
figure, hold on
subplot(4,1,1), hold on
plot(t_corr, y_mua),
xlim([-500 500]), ylim([-1.1 1.1])
line([0 0], get(gca,'ylim'), 'linewidth',2),

subplot(4,1,2:4), hold on
imagesc(t_corr, 1:size(Ord_peth,1), Ord_peth);
xlim([-500 500]), ylim([1 size(Ord_peth,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),
title('Neurons on tones')

