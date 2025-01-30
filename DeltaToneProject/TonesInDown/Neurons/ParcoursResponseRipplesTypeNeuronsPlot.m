%%ParcoursResponseRipplesTypeNeuronsPlot
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursResponseRipplesTypeNeurons
%


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseRipplesTypeNeurons.mat'))


%% concatenate and zscore

MatRipples = [];
MatRipplesBef = [];
MatRipplesCorr = [];

InfoNeuronClass = [];
InfoNeuronLayer = [];
InfoNeuronFR = [];

t_corr = resprip_res.t_corr{1};

for p=1:length(resprip_res.path)
    MatRipples     = [MatRipples ; resprip_res.MatRipples{p}];
    MatRipplesBef  = [MatRipplesBef ; resprip_res.MatRipplesBef{p}];
    MatRipplesCorr = [MatRipplesCorr ; resprip_res.MatRipplesCorr{p}];
    
    InfoNeuronClass = [InfoNeuronClass ; resprip_res.InfoNeuronClass{p}];
    InfoNeuronLayer = [InfoNeuronLayer ; resprip_res.InfoNeuronLayer{p}];
    InfoNeuronFR = [InfoNeuronFR ; resprip_res.InfoNeuronFR{p}];
    
end

Zripples = zscore(MatRipples,[],2);
ZripplesBef = zscore(MatRipplesBef,[],2);
ZripplesCorr = zscore(MatRipplesCorr,[],2);


%% Neuron info

%class
neuronClass{1} = find(InfoNeuronClass>0);
neuronClass{2} = find(InfoNeuronClass<0);
%layer
for l=1:5
    neuronLayer{l} = find(InfoNeuronLayer==l);
end
%firing rate
neuronFR{1} = find(InfoNeuronFR<=7);
neuronFR{2} = find(InfoNeuronFR>7);

    
    
%% Plot 1 - Int/Pyr
colori_neur = {'b','r'};
fontsize=13;

figure, hold on

%response ripples
subplot(2,3,1), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'pyramidal','interneuron')
title('on ripples')

%response ripples no down before
subplot(2,3,2), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,3), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')


%Plot 2 - Layers
colori_neur = {'g',[0.13 0.54 0.13],'b','r','k'};

%response ripples
subplot(2,3,4), hold on 

for i=1:length(neuronLayer)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronLayer{i},:)),2),'color', colori_neur{i});
    leg{i} = num2str(i);
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg), clear leg
title('on ripples')

%response ripples no down before
subplot(2,3,5), hold on 
for i=1:length(neuronLayer)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronLayer{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,6), hold on 

for i=1:length(neuronLayer)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronLayer{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')




