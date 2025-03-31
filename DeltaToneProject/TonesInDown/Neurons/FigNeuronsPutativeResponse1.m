%%FigNeuronsPutativeResponse1
% 04.01.2019 KJ
%
%
%   Look at the response of neurons to ripples, start-end of down - PETH Cross-Corr (PLOT)
%   Comparing putative interneurons and pyramidal
%
% see
%   ParcoursRipplesNeuronCrossCorr  FigNeuronsResponseRipples
%


clear
night_tones = 0;


%% Response to all ripples
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

%neuron info
AllNeuronClass = [];
AllNeuronLayer = [];
for p=1:length(rippeth_res.path)
    if strcmpi(rippeth_res.manipe{p}, 'rdmtone') || night_tones==0
        neuroninfo = rippeth_res.infoneurons{p};
        AllNeuronClass = [AllNeuronClass ; neuroninfo.putative(strcmpi(neuroninfo.structure,'PFCx'))];
        AllNeuronLayer = [AllNeuronLayer ; neuroninfo.layer(strcmpi(neuroninfo.structure,'PFCx'))];
    end
end


%responses
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
    OneuronClass{s} = AllNeuronClass(idx_rip{s},:);
    OneuronLayer{s} = AllNeuronLayer(idx_rip{s},:);
    
    
    %int and pyr
    IntPeth_rip{s} = Opeth_rip{s}(OneuronClass{s}<0,:);
    PyrPeth_rip{s} = Opeth_rip{s}(OneuronClass{s}>0,:);
    
    %layer
    for l=1:5
        LayerPeth_rip{s,l} = Opeth_rip{s}(OneuronLayer{s}==l,:);
    end
end




%% Plot 1
s=5;
gap = [0.03 0.04];
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;

figure, hold on

subtightplot(4,4,[1 5 9 13],gap), hold on 
imagesc(t_corr, 1:size(IntPeth_rip{s},1), IntPeth_rip{s});
xlim([-400 400]), ylim([1 size(IntPeth_rip{s},1)]),
xlabel('ms'), ylabel('#neurons'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('interneurons on ripples')

subtightplot(4,4,[2 6 10 14],gap), hold on 
imagesc(t_corr, 1:size(PyrPeth_rip{s},1), PyrPeth_rip{s});
xlim([-400 400]), ylim([1 size(PyrPeth_rip{s},1)]),
xlabel('ms'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('Pyramidal')

subtightplot(4,4,[3 7 11 15],gap), hold on 
imagesc(t_corr, 1:size(LayerPeth_rip{s,2},1), LayerPeth_rip{s,2});
xlim([-400 400]), ylim([1 size(LayerPeth_rip{s,2},1)]),
xlabel('ms'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('layer 2')

subtightplot(4,4,[4 8 12 16],gap), hold on 
imagesc(t_corr, 1:size(LayerPeth_rip{s,5},1), LayerPeth_rip{s,5});
xlim([-400 400]), ylim([1 size(LayerPeth_rip{s,5},1)]),
xlabel('ms'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
caxis([-3.3 9.4]),
title('layer 5')






