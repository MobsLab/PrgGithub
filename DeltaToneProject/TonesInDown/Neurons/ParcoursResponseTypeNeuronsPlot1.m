%%ParcoursResponseTypeNeuronsPlot1
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursResponseTypeNeurons
%


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseTypeNeurons.mat'))


%% concatenate and zscore

MatRipples = [];
MatRipplesBef = [];
MatRipplesCorr = [];
MatTonesUpUP = [];
MatTonesUpDown = [];
MatTonesDownUp = [];

InfoNeuronClass = [];
InfoNeuronLayer = [];
InfoNeuronFR = [];

t_corr = resp_res.t_corr{1};

for p=1:length(resp_res.path)
    MatRipples     = [MatRipples ; resp_res.MatRipples{p}];
    MatRipplesBef  = [MatRipplesBef ; resp_res.MatRipplesBef{p}];
    MatRipplesCorr = [MatRipplesCorr ; resp_res.MatRipplesCorr{p}];
    
    MatTonesUpUP   = [MatTonesUpUP ; resp_res.MatTonesUpUP{p}];
    MatTonesUpDown = [MatTonesUpDown ; resp_res.MatTonesUpDown{p}];
    MatTonesDownUp = [MatTonesDownUp ; resp_res.MatTonesDownUp{p}];
    
    
    InfoNeuronClass = [InfoNeuronClass ; resp_res.InfoNeuronClass{p}];
    InfoNeuronLayer = [InfoNeuronLayer ; resp_res.InfoNeuronLayer{p}];
    InfoNeuronFR = [InfoNeuronFR ; resp_res.InfoNeuronFR{p}];
    
end

zscoring = 0;
%normalisation
if zscoring==1
    Zripples = zscore(MatRipples,[],2);
    ZripplesBef = zscore(MatRipplesBef,[],2);
    ZripplesCorr = zscore(MatRipplesCorr,[],2);
    ZtonesUpUp = zscore(MatTonesUpUP,[],2);
    ZtonesUpDown = zscore(MatTonesUpDown,[],2);
    ZtonesDownUp = zscore(MatTonesDownUp,[],2);
    
else
    Zripples = MatRipples ./ InfoNeuronFR;
    ZripplesBef = MatRipplesBef ./ InfoNeuronFR;
    ZripplesCorr = MatRipplesCorr ./ InfoNeuronFR;
    ZtonesUpUp = MatTonesUpUP ./ InfoNeuronFR;
    ZtonesUpDown = MatTonesUpDown ./ InfoNeuronFR;
    ZtonesDownUp = MatTonesDownUp ./ InfoNeuronFR;
end




%% Neuron info

%class
neuronClass{1} = find(InfoNeuronClass>0);
neuronClass{2} = find(InfoNeuronClass<0);
%class
neuronClassCorrected{1} = find(InfoNeuronClass>0 & InfoNeuronFR>2);
neuronClassCorrected{2} = find(InfoNeuronClass<0 & InfoNeuronFR>2);
%layer
for l=1:5
    neuronLayer{l} = find(InfoNeuronLayer==l);
end
%firing rate
neuronFR{1} = find(InfoNeuronFR<=7);
neuronFR{2} = find(InfoNeuronFR>7);

    
    
%% Plot - Int/Pyr
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


%response tones up>up
subplot(2,3,4), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,3,5), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,3,6), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')

%% Plot - Int/Pyr for neurons over 1Hz
colori_neur = {'b','r'};
fontsize=13;

figure, hold on

%response ripples
subplot(2,3,1), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'pyramidal','interneuron')
title('on ripples')

%response ripples no down before
subplot(2,3,2), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,3), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')


%response tones up>up
subplot(2,3,4), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,3,5), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,3,6), hold on 

for i=1:length(neuronClassCorrected)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronClassCorrected{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')


%% Plot 2 - Layers
colori_neur = rdmColorsKJ(length(neuronLayer));
fontsize=13;
layers = find(~cellfun(@isempty,neuronLayer));

figure, hold on

%response ripples
subplot(2,3,1), hold on 

for i=1:length(layers)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
    leg{i} = num2str(layers(i));
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg), clear leg
title('on ripples')

%response ripples no down before
subplot(2,3,2), hold on 
for i=1:length(layers) 
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,3), hold on 

for i=1:length(layers) 
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')


%response tones up>up
subplot(2,3,4), hold on 
for i=1:length(layers) 
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,3,5), hold on 
for i=1:length(layers) 
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,3,6), hold on 
for i=1:length(layers) 
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronLayer{layers(i)},:)),2),'color', colori_neur{layers(i)});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')







