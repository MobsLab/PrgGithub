%%NeuronsResponseToTones_KJ
% 18.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursToneNeuronCrossCorr ParcoursToneNeuronCrossCorrPlot
%   ParcoursRipplesNeuronCrossCorr  NeuronsResponseToRipples_KJ
%




clear

%% Response to all ripples

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

AllPeth = [];
for p=1:length(rippeth_res.path)
    if strcmpi(rippeth_res.manipe{p}, 'rdmtone')
        AllPeth = [AllPeth ; rippeth_res.MatN2N3{p}];
    end
end
t_corr = rippeth_res.t_corr{1};

Zpeth = zscore(AllPeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2rip] = sort(idmax);
Opeth_rip = Zpeth(id2rip,:);


%% Response to tones 
clearvars -except Opeth_rip id2rip

load(fullfile(FolderDeltaDataKJ,'ParcoursToneNeuronCrossCorr.mat'))
AllPeth = [];
N1Peth = [];
N2Peth = [];
N3Peth = [];
N2N3Peth = [];
RemPeth = [];
WakePeth = [];

for p=1:length(tonepeth_res.path)
    AllPeth = [AllPeth ; tonepeth_res.MatTones{p}];
    N1Peth = [N1Peth ; tonepeth_res.MatN1{p}];
    N2Peth = [N2Peth ; tonepeth_res.MatN2{p}];
    N3Peth = [N3Peth ; tonepeth_res.MatN3{p}];
    N2N3Peth = [N2N3Peth ; tonepeth_res.MatN2N3{p}];
    RemPeth = [RemPeth ; tonepeth_res.MatREM{p}];
    WakePeth = [WakePeth ; tonepeth_res.MatWake{p}];
end
t_corr = tonepeth_res.t_corr{1};


%% All
Zpeth = zscore(AllPeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2xall] = sort(idmax);
Opeth_all = Zpeth(id2rip,:);

%% N1
Zpeth = zscore(N1Peth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2n1] = sort(idmax);
Opeth_n1 = Zpeth(id2rip,:);

%% N2
Zpeth = zscore(N2Peth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2n2] = sort(idmax);
Opeth_n2 = Zpeth(id2rip,:);
%% N3
Zpeth = zscore(N3Peth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2n3] = sort(idmax);
Opeth_n3 = Zpeth(id2rip,:);

%% N2-N3
Zpeth = zscore(N2N3Peth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2n23] = sort(idmax);
Opeth_n23 = Zpeth(id2rip,:);

%% REM
Zpeth = zscore(RemPeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2rem] = sort(idmax);
Opeth_rem = Zpeth(id2rip,:);

%% Wake
Zpeth = zscore(WakePeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2wake] = sort(idmax);
Opeth_wake = Zpeth(id2rip,:);



%% Plot option
idx{1}=1:50; idx{2}=51:120; idx{3}=121:170; idx{4}=171:size(Opeth_all,1);
gap = [0.08 0.04];

colori = distinguishable_colors(4);
for i=1:4
    colori_neur{i} = colori(i,:);
end


%% PLOT response curve
figure, hold on

subtightplot(2,3,[1 4], gap), hold on 
imagesc(t_corr, 1:size(Opeth_rip,1), Opeth_rip);
xlim([-500 500]), ylim([1 size(Opeth_rip,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on ripples')

subtightplot(2,3,[2 5], gap), hold on 
imagesc(t_corr, 1:size(Opeth_all,1), Opeth_all);
xlim([-500 500]), ylim([1 size(Opeth_all,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on tones (all tones)')

subtightplot(2,3,3, gap), hold on
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Opeth_n2(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-1 0.8],'xlim', [-400 400]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h, 'perc 1', 'perc 2', 'perc 3', 'perc 4');
title('tones in N2')

subtightplot(2,3,6, gap),
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Opeth_n3(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-1 0.8],'xlim', [-400 400]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('tones in N3')



