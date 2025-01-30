%%FigNeuronsResponseRipples
% 25.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursRipplesNeuronCrossCorr  NeuronsResponseToRipples_KJ
%   FigNeuronsResponseRipples2 FigNeuronsResponseRipples3
%


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
    Zpeth_rip{s} = zscore(AllPeth{s},[],2);
    [~,idmax{s}] = max(Zpeth_rip{s},[],2);
    [~,idx_rip{s}] = sort(idmax{s});
    Opeth_rip{s} = Zpeth_rip{s}(idx_rip{s},:);
end


%% Classify
s=6; 
neuronPeaks = t_corr(idmax{s});    
neuronClass{1} = find(neuronPeaks<=-130);
neuronClass{2} = find(neuronPeaks>-130 & neuronPeaks<=0);
neuronClass{3} = find(neuronPeaks>-0 & neuronPeaks<=70);
neuronClass{4} = find(neuronPeaks>70);


%% Response to tones 
load(fullfile(FolderDeltaDataKJ,'ParcoursToneNeuronCrossCorr.mat'))
AllPeth = [];
N2Peth = [];
N3Peth = [];


for p=1:length(tonepeth_res.path)
    AllPeth = [AllPeth ; tonepeth_res.MatTones{p}];
    N2Peth = [N2Peth ; tonepeth_res.MatN2{p}];
    N3Peth = [N3Peth ; tonepeth_res.MatN3{p}];
end

%All
Zpeth_tones = zscore(AllPeth,[],2);
%N2
Zpeth_n2 = zscore(N2Peth,[],2);
%N3
Zpeth_n3 = zscore(N3Peth,[],2);


%% Plot 1
s=6;
gap = [0.03 0.04];
colori_neur = {[0.13 0.54 0.13],'b','r',[1 0.55 0]};
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


for i=1:4
    k=5-i;
    subtightplot(5,5,2+5*(k-1),gap), hold on 

    hold on, h = plot(t_corr,runmean(mean(Zpeth_rip{s}(neuronClass{i},:)),2),'color', colori_neur{i},'linewidth',2);
    ylim([-1 2]),xlim([-400 400]),
    set(gca,'fontsize',fontsize),
    if k==4
        xlabel('ms'), 
    else
        set(gca,'xticklabel',{}),
    end
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    lgd = legend(h,['group ' num2str(i)]); lgd.Location='northwest';

end


% %% Plot 1
% s=6;
% gap = [0.05 0.04];
% colori_neur = {[0.13 0.54 0.13],'b','r',[1 0.55 0]};
% fontsize=15;
% 
% figure, hold on
% 
% subtightplot(5,5,[1 6 11 16],gap), hold on 
% imagesc(t_corr, 1:size(Opeth_rip{s},1), Opeth_rip{s});
% xlim([-400 400]), ylim([1 size(Opeth_rip{s},1)]),
% xlabel('ms'), ylabel('#neurons'),
% line([0 0], get(gca,'ylim'), 'linewidth',2),
% set(gca,'fontsize',fontsize),
% caxis([-3.3 9.4]),
% title('Neurons response on ripples')
% 
% 
% %response ripples
% subtightplot(5,5,2,gap), hold on 
% 
% for i=1:length(neuronClass)
%     hold on, h = plot(t_corr,runmean(mean(Zpeth_rip{s}(neuronClass{i},:)),2),'color', colori_neur{i});
% end
% ylim([-1 2]),xlim([-400 400]),
% set(gca,'ylim',[-1 2], 'xlim',[-400 400], 'fontsize',fontsize),
% line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
% legend(h,'1','2','3','4')
% title('on ripples')



