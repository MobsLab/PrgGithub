%%FigNeuronsResponseRipples2
% 25.09.2018 KJ
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   FigNeuronsResponseRipples  NeuronsResponseToRipples2_KJ
%   FigNeuronsResponseRipples3


clear
night_tones = 0;


%% Response to all ripples
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

rip_data{1} = rippeth_res.MatN1; rip_data{2} = rippeth_res.MatN2; rip_data{3} = rippeth_res.MatN3; 
rip_data{4} = rippeth_res.MatREM; rip_data{5} = rippeth_res.MatWake; rip_data{6} = rippeth_res.MatRipples;
rip_data{7} = rippeth_res.MatN2N3;

t_corr = rippeth_res.t_corr{1};

for s=1:7
    
    %pool
    AllPeth{s} = [];
    for p=1:length(rippeth_res.path)
        if strcmpi(rippeth_res.manipe{p}, 'rdmtone') || night_tones==0
            AllPeth{s} = [AllPeth{s} ; rip_data{s}{p}];
        end
    end
    
    %zscore and order
    Zpeth_all{s} = zscore(AllPeth{s},[],2);
    [~,idmax{s}] = max(Zpeth_all{s},[],2);
    [~,idx_all{s}] = sort(idmax{s});
    Opeth_all{s} = Zpeth_all{s}(idx_all{s},:);
end

%% Classify
for s=1:7
    neuronPeaks = t_corr(idmax{s});
    
    neuronClass{s,1} = find(neuronPeaks<=-130);
    neuronClass{s,2} = find(neuronPeaks>-130 & neuronPeaks<=0);
    neuronClass{s,3} = find(neuronPeaks>-0 & neuronPeaks<=70);
    neuronClass{s,4} = find(neuronPeaks>70);
end


%% Response to ripples no down bef
clearvars -except night_tones t_corr neuronClass Opeth_all Zpeth_all idx_all

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNoDownbefNeuronCrossCorr.mat'))
rip_data{1} = ripcor_res.MatN1; rip_data{2} = ripcor_res.MatN2; rip_data{3} = ripcor_res.MatN3; 
rip_data{4} = ripcor_res.MatREM; rip_data{5} = ripcor_res.MatWake; rip_data{6} = ripcor_res.MatRipples;
rip_data{7} = ripcor_res.MatN2N3;

for s=1:7
    
    %pool
    AllPeth{s} = [];
    for p=1:length(ripcor_res.path)
        if strcmpi(ripcor_res.manipe{p}, 'rdmtone') || night_tones==0
            AllPeth{s} = [AllPeth{s} ; rip_data{s}{p}];
        end
    end
    
    %zscore and order
    Zpeth_bef{s} = zscore(AllPeth{s},[],2);
    Opeth_bef{s} = Zpeth_bef{s}(idx_all{s},:);
end


%% Response to ripples with no down around
clearvars -except night_tones t_corr neuronClass Opeth_all Zpeth_all idx_all Opeth_bef Zpeth_bef 

load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNoDownNeuronCrossCorr.mat'))
rip_data{1} = ripnodown_res.MatN1; rip_data{2} = ripnodown_res.MatN2; rip_data{3} = ripnodown_res.MatN3; 
rip_data{4} = ripnodown_res.MatREM; rip_data{5} = ripnodown_res.MatWake; rip_data{6} = ripnodown_res.MatRipples;
rip_data{7} = ripnodown_res.MatN2N3;

for s=1:7
    
    %pool
    AllPeth{s} = [];
    for p=1:length(ripnodown_res.path)
        if strcmpi(ripnodown_res.manipe{p}, 'rdmtone') || night_tones==0
            AllPeth{s} = [AllPeth{s} ; rip_data{s}{p}];
        end
    end
    
    %zscore and order
    Zpeth_nodown{s} = zscore(AllPeth{s},[],2);
    Opeth_nodown{s} = Zpeth_nodown{s}(idx_all{s},:);
end


%% Plot

gap = [0.04 0.04];
%color
colori_neur = {[0.13 0.54 0.13],'b','r',[1 0.55 0]};
fontsize = 13;

%for whole night
s=6
figure, hold on

subtightplot(5,5,[1 6 11 16], gap), hold on 
imagesc(t_corr, 1:size(Opeth_all{s},1), Opeth_all{s});
xlim([-500 500]), ylim([1 size(Opeth_all{s},1)]),
set(gca,'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]), ylabel('#neurons'),xlabel('ms'),
title('Neurons on ripples in')

subtightplot(5,5,[2 7 12 17], gap), hold on 
imagesc(t_corr, 1:size(Opeth_bef{s},1), Opeth_bef{s});
xlim([-500 500]), ylim([1 size(Opeth_bef{s},1)])
set(gca, 'yticklabel',{},'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),xlabel('ms'),
title('ripples with no down before')

subtightplot(5,5,[3 8 13 18], gap), hold on 
imagesc(t_corr, 1:size(Opeth_nodown{s},1), Opeth_nodown{s});
xlim([-500 500]), ylim([1 size(Opeth_nodown{s},1)])
set(gca, 'yticklabel',{},'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
caxis([-3.3 9.4]),xlabel('ms'),
title('ripples with no down around')


subtightplot(5,5,4, gap), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_all{s}(neuronClass{s,i},:)),2),'color', colori_neur{i});
end
set(gca, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h, 'group 1', 'group 2', 'group 3', 'group 4');
title('all ripples'),

subtightplot(5,5,9, gap), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_bef{s}(neuronClass{s,i},:)),2),'color', colori_neur{i});
end
set(gca, 'fontsize',fontsize),
line([0 0], ylim, 'color',[0.7 0.7 0.7], 'linewidth',1),
title('no down before')

subtightplot(5,5,14, gap), hold on 
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_nodown{s}(neuronClass{s,i},:)),2),'color', colori_neur{i});
end
set(gca, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('no down before and after'), xlabel('ms'),





