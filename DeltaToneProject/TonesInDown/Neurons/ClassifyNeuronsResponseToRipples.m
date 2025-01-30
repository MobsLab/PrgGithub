%%ClassifyNeuronsResponseToRipples
% 18.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNeuronCrossCorr NeuronsResponseToRipples_KJ




%% Response to all ripples

clear

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

AllPeth = [];
NeuronsPath = [];

for p=1:length(rippeth_res.path)
    AllPeth = [AllPeth ; rippeth_res.MatRipples{p}];
    NeuronsPath = [NeuronsPath ; p*ones(size(rippeth_res.MatRipples{p},1),1)];
end
t_corr = rippeth_res.t_corr{1};

%% All
Zpeth = zscore(AllPeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[idmax,id2xall] = sort(idmax);
Opeth_all = Zpeth(id2xall,:);


%% Classify
neuronPeaks = t_corr(idmax);

neuronClass{1} = id2xall(neuronPeaks<=-130);
neuronClass{2} = id2xall(neuronPeaks>-130 & neuronPeaks<=0);
neuronClass{3} = id2xall(neuronPeaks>-0 & neuronPeaks<=70);
neuronClass{4} = id2xall(neuronPeaks>70);

for i=1:length(neuronClass)
    NeuronsPath(neuronClass{i},2) = i;
end

%save
for p=1:length(rippeth_res.path)
    rippeth_res.neuronClass{p} = NeuronsPath(NeuronsPath(:,1)==p,2);
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursRipplesNeuronCrossCorr.mat rippeth_res binsize_cc nbins_cc



%% PLOT response curve
%color
colori = distinguishable_colors(4);
for i=1:4
    colori_neur{i} = colori(i,:);
end

figure, hold on

subplot(1,2,1), hold on 
imagesc(t_corr, 1:size(Opeth_all,1), Opeth_all);
xlim([-500 500]), ylim([1 size(Opeth_all,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on ripples')

subplot(1,2,2), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth(neuronClass{i},:)),2), 'color', colori_neur{i});
end
set(gca,'ylim', [-0.6 1.8],'xlim', [-400 400]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('all ripples')

