%%NeuronsResponseToDown_KJ
% 18.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNeuronCrossCorr NeuronsResponseToRipples_KJ NeuronsResponseToTones_KJ
%   NeuronsResponseToDown_KJ2


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

Zpeth = zscore(AllPeth,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,id2rip] = sort(idmax);
Opeth_rip = Zpeth(id2rip,:);

clearvars -except Opeth_rip id2rip

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


%% All
%start
Zpeth = zscore(AllPeth.start,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,idsxall] = sort(idmax);
Ops_all = Zpeth(id2rip,:);
%end
Zpeth = zscore(AllPeth.end,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,idexall] = sort(idmax);
Ope_all = Zpeth(id2rip,:);

%% N2
%start
Zpeth = zscore(N2Peth.start,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,idsn2] = sort(idmax);
Ops_n2 = Zpeth(id2rip,:);
%end
Zpeth = zscore(N2Peth.end,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,iden2] = sort(idmax);
Ope_n2 = Zpeth(id2rip,:);

%% N3
%start
Zpeth = zscore(N3Peth.start,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,idsn3] = sort(idmax);
Ops_n3 = Zpeth(id2rip,:);
%end
Zpeth = zscore(N3Peth.end,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,iden3] = sort(idmax);
Ope_n3 = Zpeth(id2rip,:);

%% N2-N3
%start
Zpeth = zscore(N2N3Peth.start,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,idsn23] = sort(idmax);
Ops_n23 = Zpeth(id2rip,:);
%end
Zpeth = zscore(N2N3Peth.end,[],2);
[~,idmax] = max(Zpeth,[],2);
[~,iden23] = sort(idmax);
Ope_n23 = Zpeth(id2rip,:);



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

subtightplot(2,3,3, gap), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Ops_n2(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-3 1],'xlim', [-250 250]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h, 'perc 1', 'perc 2', 'perc 3', 'perc 4');
title('start down in N2')

subtightplot(2,3,6, gap),
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Ops_n3(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-3 1],'xlim', [-250 250]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('start down in N3')


%% PLOT response curve on end down
figure, hold on

subtightplot(2,3,[1 4], gap), hold on
imagesc(t_corr, 1:size(Opeth_rip,1), Opeth_rip);
xlim([-500 500]), ylim([1 size(Opeth_rip,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on ripples')

subtightplot(2,3,[2 5], gap), hold on 
imagesc(t_corr, 1:size(Ope_all,1), Ope_all);
xlim([-500 500]), ylim([1 size(Ope_all,1)])
line([0 0], get(gca,'ylim'), 'linewidth',2),
% caxis([-3.3 9.4]),
title('Neurons on end down')

subtightplot(2,3,3, gap), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Ope_n2(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-3 2],'xlim', [-250 250]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h, 'perc 1', 'perc 2', 'perc 3', 'perc 4');
title('end down in N2')

subtightplot(2,3,6, gap),
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Ope_n3(idx{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim', [-3 2],'xlim', [-250 250]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('end down in N3')



