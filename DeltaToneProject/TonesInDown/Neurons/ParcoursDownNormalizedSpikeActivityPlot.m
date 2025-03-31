%%ParcoursDownNormalizedSpikeActivityPlot
% 20.09.2018 KJ
%
%
%   Look at the spiking activity of neurons inside down states
%
% see
%   ParcoursDownNormalizedSpikeActivity NeuronsResponseToDown_KJ2
%


clear


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

% ordered ny firing before start of down
Opeth_rip = Zpeth_rip(idsxall,:);



%% Normalized activity in down state

load(fullfile(FolderDeltaDataKJ,'ParcoursDownNormalizedSpikeActivity.mat'))

edges_norm  = 0:0.1:1;

AllNormActivity = [];
for p=1:length(downspk_res.path)
    
    for k=1:length(downspk_res.st_bef{p})
        bef = downspk_res.st_bef{p}{k};
        aft = downspk_res.end_aft{p}{k};
        normActivity = bef ./ (bef+aft);
        
        [y_norm, x_norm] = histcounts(normActivity, edges_norm, 'Normalization','probability');
%         x_norm = x_norm(1:end-1) + diff(x_norm);
    
        AllNormActivity = [AllNormActivity ; y_norm];
    end
    
end

AllNormActivity = AllNormActivity(idsxall,:);


%% Plot option
idx{1}=1:300; idx{2}=300:700; idx{3}=800:1200; idx{4}=1200:size(Opeth_rip,1);
% id{1}=1:50; id{2}=50:120; id{3}=120:170; id{4}170:size(Opeth_rip,1);
gap = [0.08 0.04];


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

subtightplot(2,3,[3 6], gap), hold on 
imagesc(x_norm, 1:size(AllNormActivity,1), AllNormActivity);
xlim([-0.05 1.05]), ylim([1 size(AllNormActivity,1)])
% caxis([-3.3 9.4]),
title('Normalized activity in up states')




