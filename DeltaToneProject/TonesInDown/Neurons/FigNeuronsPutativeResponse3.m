%%FigNeuronsPutativeResponse3
% 04.01.2019 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   FigNeuronsPutativeResponse1 FigNeuronsResponseRipples3
%


clear
night_tones = 1;


%% Response to all ripples
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))


%response
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
    Zpeth_rip{s} = zscore(AllPeth{s},[],2);
    [~,idmax{s}] = max(Zpeth_rip{s},[],2);
    [~,idx_rip{s}] = sort(idmax{s});
    Opeth_rip{s} = Zpeth_rip{s}(idx_rip{s},:);
end


%% Response to tones 
load(fullfile(FolderDeltaDataKJ,'ParcoursToneNeuronCrossCorr.mat'))
AllPeth = [];
N2Peth = [];
N3Peth = [];


for p=1:length(tonepeth_res.path)
    if strcmpi(tonepeth_res.manipe{p}, 'rdmtone') || night_tones==0
        AllPeth = [AllPeth ; tonepeth_res.MatTones{p}];
        N2Peth = [N2Peth ; tonepeth_res.MatN2{p}];
        N3Peth = [N3Peth ; tonepeth_res.MatN3{p}];
    end
end

%neuron info
AllNeuronClass = [];
AllNeuronLayer = [];
for p=1:length(tonepeth_res.path)
    if strcmpi(tonepeth_res.manipe{p}, 'rdmtone') || night_tones==0
        neuroninfo = tonepeth_res.infoneurons{p};
        AllNeuronClass = [AllNeuronClass ; neuroninfo.putative(strcmpi(neuroninfo.structure,'PFCx'))];
        AllNeuronLayer = [AllNeuronLayer ; neuroninfo.layer(strcmpi(neuroninfo.structure,'PFCx'))];
    end
end


%All
Zpeth_tones = zscore(AllPeth,[],2);
%N2
Zpeth_n2 = zscore(N2Peth,[],2);
%N3
Zpeth_n3 = zscore(N3Peth,[],2);


%% Classify
neuronClass{1} = find(AllNeuronClass<0);
neuronClass{2} = find(AllNeuronClass>0);

for l=1:5
    neuronLayer{l} = find(AllNeuronLayer==l);
end


%% Plot 1
s=6;
gap = [0.07 0.04];
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;

figure, hold on

subtightplot(5,5,[1 6 11 16],gap), hold on 
imagesc(t_corr, 1:size(Opeth_rip{s},1), Opeth_rip{s});
xlim([-400 400]), ylim([1 size(Opeth_rip{s},1)]),
xlabel('ms'), ylabel('#neurons'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('Neurons response on ripples')


%response ripples
subtightplot(5,5,[2 7],gap), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_rip{s}(neuronClass{i},:)),2),'color', colori_neur{i});
end
ylim([-1 2]),xlim([-400 400]),
set(gca,'ylim',[-1 2.3], 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'interneuron','pyramidal')
title('on ripples')

%response tones
subtightplot(5,5,[3 8],gap), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_tones(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subtightplot(5,5,[12 17],gap), hold on 
for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_n2(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subtightplot(5,5,[13 18],gap), hold on 
for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zpeth_n3(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')



%% Plot 2
s=6;
gap = [0.07 0.04];
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;

figure, hold on

subtightplot(5,5,[1 6 11 16],gap), hold on 
imagesc(t_corr, 1:size(Opeth_rip{s},1), Opeth_rip{s});
xlim([-400 400]), ylim([1 size(Opeth_rip{s},1)]),
xlabel('ms'), ylabel('#neurons'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('Neurons response on ripples')


%response ripples
subtightplot(5,5,[2 7],gap), hold on 

for i=2:length(neuronLayer)
    hold on, h(i-1) = plot(t_corr,runmean(mean(Zpeth_rip{s}(neuronLayer{i},:)),2),'color', colori_neur{i-1});
end
ylim([-1 2]),xlim([-400 400]),
set(gca,'ylim',[-1 2.3], 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'2','3','4','5')
title('on ripples')

%response tones
subtightplot(5,5,[3 8],gap), hold on 

for i=2:length(neuronLayer)
    hold on, h(i-1) = plot(t_corr,runmean(mean(Zpeth_tones(neuronLayer{i},:)),2),'color', colori_neur{i-1});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subtightplot(5,5,[12 17],gap), hold on 
for i=2:length(neuronLayer)
    hold on, h(i-1) = plot(t_corr,runmean(mean(Zpeth_n2(neuronLayer{i},:)),2),'color', colori_neur{i-1});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subtightplot(5,5,[13 18],gap), hold on 
for i=2:length(neuronLayer)
    hold on, h(i-1) = plot(t_corr,runmean(mean(Zpeth_n3(neuronLayer{i},:)),2),'color', colori_neur{i-1});
end
set(gca,'ylim',[-1 1], 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')



