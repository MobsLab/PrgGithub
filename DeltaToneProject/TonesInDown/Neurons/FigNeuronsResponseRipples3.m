%%FigNeuronsResponseRipples3
% 25.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr (PLOT)
%
% see
%   FigNeuronsResponseRipples  FigNeuronsResponseRipples2
%


clear
night_tones = 1;
zscoring=2;  %0 for firing rate, 1 for zscore, 2 for zscore by the pre period 


%% Response to all ripples
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))

rip_data{1} = rippeth_res.MatN1; rip_data{2} = rippeth_res.MatN2; rip_data{3} = rippeth_res.MatN3; 
rip_data{4} = rippeth_res.MatREM; rip_data{5} = rippeth_res.MatWake; rip_data{6} = rippeth_res.MatRipples;
rip_data{7} = rippeth_res.MatN2N3;

t_corr = rippeth_res.t_corr{1};


%firing rates
neuronFR = [];
for p=1:length(rippeth_res.path)
    if strcmpi(rippeth_res.manipe{p}, 'rdmtone') || night_tones==0
        infoneurons = rippeth_res.infoneurons{p};
        neuronFR = [neuronFR ; infoneurons.firingrate(strcmpi(infoneurons.structure,'PFCx')' & infoneurons.ismua==0)];
    end
end

for s=1:7
    
    %pool
    AllPeth{s} = [];
    for p=1:length(rippeth_res.path)
        if strcmpi(rippeth_res.manipe{p}, 'rdmtone') || night_tones==0
            AllPeth{s} = [AllPeth{s} ; rip_data{s}{p}];
        end
    end
    
    %zscore and order
    if zscoring==1
        Zpeth_rip{s} = zscore(AllPeth{s},[],2);
    elseif zscoring==2
        Zpeth_rip{s} = (AllPeth{s}-mean(AllPeth{s}(:,t_corr<-200),2)) ./ std(AllPeth{s}(:,t_corr<-200),0,2);
    else
        Zpeth_rip{s} = AllPeth{s} ./ neuronFR;
    end
    
    
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


%zscore and order
if zscoring==1
    %All
    Zpeth_tones = zscore(AllPeth,[],2);
    %N2
    Zpeth_n2 = zscore(N2Peth,[],2);
    %N3
    Zpeth_n3 = zscore(N3Peth,[],2);
elseif zscoring==2
    %All
    Zpeth_tones = (AllPeth-mean(AllPeth(:,t_corr<-200),2)) ./ std(AllPeth(:,t_corr<-200),0,2);
    %N2
    Zpeth_n2 = (N2Peth-mean(N2Peth(:,t_corr<-200),2)) ./ std(N2Peth(:,t_corr<-200),0,2);
    %N3
    Zpeth_n3 = (N3Peth-mean(N3Peth(:,t_corr<-200),2)) ./ std(N3Peth(:,t_corr<-200),0,2);

else    
    %All
    Zpeth_tones = AllPeth ./ neuronFR;
    %N2
    Zpeth_n2 = N2Peth ./ neuronFR;
    %N3
    Zpeth_n3 = N3Peth ./ neuronFR;
end


%% Plot 1
s=6;
gap = [0.07 0.04];
colori_neur = {[0.13 0.54 0.13],'b','r',[1 0.55 0]};
fontsize=15;

figure, hold on

subtightplot(5,5,[1 6 11 16],gap), hold on 
imagesc(t_corr, 1:size(Opeth_rip{s},1), Opeth_rip{s});
xlim([-400 400]), ylim([1 size(Opeth_rip{s},1)]),
xlabel('ms'), ylabel('#neurons'),
line([0 0], get(gca,'ylim'), 'linewidth',2),
set(gca,'fontsize',fontsize),
% caxis([-3.3 9.4]),
title('Neurons response on ripples')


%response ripples
subtightplot(5,5,[2 7],gap), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zpeth_rip{s}(neuronClass{i},:)),2),'color', colori_neur{i});
end
ylim([-1 2]),xlim([-400 400]),
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
% set(gca, 'ylim',[-1 2.3]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'1','2','3','4')
title('on ripples')

%response tones
subtightplot(5,5,[3 8],gap), hold on 
clear h
for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zpeth_tones(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
% set(gca,'ylim',[-1 1]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subtightplot(5,5,[12 17],gap), hold on 
clear h
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zpeth_n2(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
% set(gca, 'ylim',[-1 1]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subtightplot(5,5,[13 18],gap), hold on 
clear h
for i=1:4
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zpeth_n3(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
% set(gca, 'ylim',[-1 1]),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')




