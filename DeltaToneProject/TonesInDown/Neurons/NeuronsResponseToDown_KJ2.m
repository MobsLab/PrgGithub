%%NeuronsResponseToDown_KJ2
% 20.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNeuronCrossCorr NeuronsResponseToRipples_KJ NeuronsResponseToTones_KJ
%


clear

%% Response to all ripples

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

AllPeth = [];
for p=1:length(rippeth_res.path)
%     if strcmpi(rippeth_res.manipe{p}, 'rdmtone')
%         AllPeth = [AllPeth ; rippeth_res.MatN2N3{p}];
%     end
    AllPeth = [AllPeth ; rippeth_res.MatN2N3{p}];
end
t_corr = rippeth_res.t_corr{1};

Zpeth_rip = zscore(AllPeth,[],2);
[~,idmax] = max(Zpeth_rip,[],2);
[~,id2rip] = sort(idmax);
Opeth_rip = Zpeth_rip(id2rip,:);

clearvars -except Opeth_rip id2rip Zpeth_rip

%% Response to all down states (start and end)

load(fullfile(FolderDeltaDataKJ,'ParcoursDownNeuronCrossCorr.mat'))

%start
AllPeth.start = [];
N2Peth.start = [];
N3Peth.start = [];
N2N3Peth.start = [];
%end
AllPeth.end = [];
N2Peth.end = [];
N3Peth.end = [];
N2N3Peth.end = [];


for p=1:length(downpeth_res.path)
    %start
    AllPeth.start = [AllPeth.start ; downpeth_res.MatStartDown{p}];
    N2Peth.start = [N2Peth.start ; downpeth_res.MatStartN2{p}];
    N3Peth.start = [N3Peth.start ; downpeth_res.MatStartN3{p}];
    N2N3Peth.start = [N2N3Peth.start ; downpeth_res.MatStartN2N3{p}];
    %end
    AllPeth.end = [AllPeth.end ; downpeth_res.MatEndDown{p}];
    N2Peth.end = [N2Peth.end ; downpeth_res.MatEndN2{p}];
    N3Peth.end = [N3Peth.end ; downpeth_res.MatEndN3{p}];
    N2N3Peth.end = [N2N3Peth.end ; downpeth_res.MatEndN2N3{p}];

end
t_corr = downpeth_res.t_corr{1};


%% start down
%ordered by spike before
Zpeth = zscore(AllPeth.start,[],2);
m_before = mean(Zpeth(:,t_corr>=-40&t_corr<=-20),2);
[~,idsxall] = sort(m_before);
Ops_all = Zpeth(idsxall,:);

%ripples
Opeth_rip = Zpeth_rip(idsxall,:);


%% Plot option
idx{1}=1:300; idx{2}=300:700; idx{3}=800:1200; idx{4}=1200:size(Opeth_rip,1);
% id{1}=1:50; id{2}=50:120; id{3}=120:170; id{4}170:size(Opeth_rip,1);
gap = [0.08 0.04];

colori = distinguishable_colors(4);
for i=1:4
    colori_neur{i} = colori(i,:);
end




%% PLOT response curve on start down
figure, hold on

subtightplot(2,3,[1 4], gap), hold on 
imagesc(t_corr, 1:size(Opeth_rip,1), Opeth_rip);
xlim([-500 500]), ylim([1 size(Opeth_rip,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on ripples')

subtightplot(2,3,[2 5], gap), hold on 
imagesc(t_corr, 1:size(Ops_all,1), Ops_all);
xlim([-500 500]), ylim([1 size(Ops_all,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on start down')
% 
% subtightplot(2,3,3, gap), hold on 
% for i=1:4
%     hold on, h(i) = plot(t_corr,runmean(mean(Ops_n2(idx{i},:)),2),'color', colori_neur{i});
% end
% set(gca,'ylim', [-3 1],'xlim', [-250 250]),
% line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
% legend(h, 'perc 1', 'perc 2', 'perc 3', 'perc 4');
% title('start down in N2')
% 
% subtightplot(2,3,6, gap),
% for i=1:4
%     hold on, h(i) = plot(t_corr,runmean(mean(Ops_n3(idx{i},:)),2),'color', colori_neur{i});
% end
% set(gca,'ylim', [-3 1],'xlim', [-250 250]),
% line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
% title('start down in N3')



