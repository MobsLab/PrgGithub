%%ParcoursResponseTypeNeuronsPlot2
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursResponseTypeNeurons ParcoursResponseTypeNeuronsPlot1
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

for p=1:4%length(resp_res.path)
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

Zripples = zscore(MatRipples,[],2);
ZripplesBef = zscore(MatRipplesBef,[],2);
ZripplesCorr = zscore(MatRipplesCorr,[],2);
ZtonesUpUp = zscore(MatTonesUpUP,[],2);
ZtonesUpDown = zscore(MatTonesUpDown,[],2);
ZtonesDownUp = zscore(MatTonesDownUp,[],2);


%% Neuron info

%class
neuronClass{1} = find(InfoNeuronClass>0);
neuronClass{2} = find(InfoNeuronClass<0);
%layer
for l=1:5
    neuronLayer{l} = find(InfoNeuronLayer==l);
end
%firing rate
neuronFR{1} = find(InfoNeuronFR<=2);
neuronFR{2} = find(InfoNeuronFR>2 & InfoNeuronFR<=5);
neuronFR{3} = find(InfoNeuronFR>5 & InfoNeuronFR<=15);    
neuronFR{4} = find(InfoNeuronFR>15);    


%ordering
[~,id_fr] = sort(InfoNeuronFR);

Oripples = Zripples(id_fr,:);
OripplesBef = ZripplesBef(id_fr,:);
OripplesCorr = ZripplesCorr(id_fr,:);
OtonesUpUp = ZtonesUpUp(id_fr,:);
OtonesUpDown = ZtonesUpDown(id_fr,:);
OtonesDownUp = ZtonesDownUp(id_fr,:);



%% Color plot

fontsize = 13;
gap = [0.04 0.04];
figure, hold on

%response ripples
subtightplot(2,3,1, gap), hold on 
imagesc(t_corr, 1:size(Oripples,1), Oripples);
xlim([-300 300]), ylim([1 size(Oripples,1)]),
set(gca,'fontsize',fontsize,'xticklabel',{}),
line([0 0], get(gca,'ylim'), 'linewidth',2),
 ylabel('#neurons'),
title('Neurons on ripples')

%response ripples no down before
subtightplot(2,3,2, gap), hold on 
imagesc(t_corr, 1:size(OripplesBef,1), OripplesBef);
xlim([-300 300]), ylim([1 size(OripplesBef,1)]),
set(gca,'fontsize',fontsize,'xticklabel',{}),
line([0 0], get(gca,'ylim'), 'linewidth',2),

title('ripples no down before')

%response ripples no down around
subtightplot(2,3,3, gap), hold on 
imagesc(t_corr, 1:size(OripplesCorr,1), OripplesCorr);
xlim([-300 300]), ylim([1 size(OripplesCorr,1)]),
set(gca,'fontsize',fontsize,'xticklabel',{}),
line([0 0], get(gca,'ylim'), 'linewidth',2),

title('ripples no down around')

%response tones up>up
subtightplot(2,3,4, gap), hold on 
imagesc(t_corr, 1:size(OtonesUpUp,1), OtonesUpUp);
xlim([-300 300]), ylim([1 size(OtonesUpUp,1)]),
set(gca,'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
 ylabel('#neurons'),xlabel('ms'),
title('on tones up>up')

%response tones up>down
subtightplot(2,3,5, gap), hold on 
imagesc(t_corr, 1:size(OtonesUpDown,1), OtonesUpDown);
xlim([-300 300]), ylim([1 size(OtonesUpDown,1)]),
set(gca,'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
xlabel('ms'),
title('on tones up>down')

%response tones down>up
subtightplot(2,3,6, gap), hold on 
imagesc(t_corr, 1:size(OtonesDownUp,1), OtonesDownUp);
xlim([-300 300]), ylim([1 size(OtonesDownUp,1)]),
set(gca,'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'linewidth',2),
xlabel('ms'),
title('on tones down>up')




%% Plot 1 - Firing rates
colori_neur = rdmColorsKJ(length(neuronFR)+1);

fontsize=13;

figure, hold on

%response ripples
subplot(2,3,1), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'<2Hz','2-5Hz','5-15Hz','>15Hz')
title('on ripples')

%response ripples no down before
subplot(2,3,2), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,3), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')


%response tones up>up
subplot(2,3,4), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,3,5), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,3,6), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')


%% Plot 2 - subgroup

neuronGroup{1} = find(InfoNeuronClass>0 & InfoNeuronFR<=5);
neuronGroup{2} = find(InfoNeuronClass>0 & InfoNeuronFR>5);
neuronGroup{3} = find(InfoNeuronClass<0 & InfoNeuronFR<=5);
neuronGroup{4} = find(InfoNeuronClass<0 & InfoNeuronFR>5);
leg = {'Pyr < 5Hz', 'Pyr > 5Hz', 'Int < 5Hz', 'Int > 5Hz'};
colori_neur = rdmColorsKJ(length(neuronGroup)+2);

figure, hold on

%response ripples
subplot(2,3,1), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg)
title('on ripples')

%response ripples no down before
subplot(2,3,2), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,3,3), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')


%response tones up>up
subplot(2,3,4), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,3,5), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,3,6), hold on 

for i=1:length(neuronGroup)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronGroup{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')




