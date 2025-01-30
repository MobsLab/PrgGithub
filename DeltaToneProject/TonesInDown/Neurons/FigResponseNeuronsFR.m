%%FigResponseNeuronsFR
% 10.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%   Influence of firing rate
%
% see
%   ParcoursResponseTypeNeurons ParcoursResponseTypeNeuronsPlot1
%


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseRipplesTypeNeurons.mat'))
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseTypeNeurons.mat'))

%params
zscoring = 2; %0 for firing rate, 1 for zscore, 2 for zscore by the pre period 

%% concatenate and zscore

MatRipples = [];
MatRipplesBef = [];
MatRipplesCorr = [];
MatTransitDownUp = [];
MatTransitUpDown = [];
RipNeuronClass = [];
RipNeuronFR = [];

for p=1:length(resprip_res.path)
    MatRipples     = [MatRipples ; resprip_res.MatRipples{p}];
    MatRipplesBef  = [MatRipplesBef ; resprip_res.MatRipplesBef{p}];
    MatRipplesCorr = [MatRipplesCorr ; resprip_res.MatRipplesCorr{p}];
    MatTransitDownUp = [MatTransitDownUp ; resprip_res.MatTransitDownUp{p}];
    MatTransitUpDown = [MatTransitUpDown ; resprip_res.MatTransitUpDown{p}];
    
    RipNeuronClass = [RipNeuronClass ; resprip_res.InfoNeuronClass{p}];
    RipNeuronFR = [RipNeuronFR ; resprip_res.InfoNeuronFR{p}];
end


MatTonesUpUP = [];
MatTonesUpDown = [];
MatTonesDownUp = [];
MatTransitDownUp = [];
MatTransitUpDown = [];
ToneNeuronClass = [];
ToneNeuronFR = [];

for p=1:length(resp_res.path)    
    MatTonesUpUP   = [MatTonesUpUP ; resp_res.MatTonesUpUP{p}];
    MatTonesUpDown = [MatTonesUpDown ; resp_res.MatTonesUpDown{p}];
    MatTonesDownUp = [MatTonesDownUp ; resp_res.MatTonesDownUp{p}];
    
    MatTransitDownUp = [MatTransitDownUp ; resp_res.MatTransitDownUp{p}];
    MatTransitUpDown = [MatTransitUpDown ; resp_res.MatTransitUpDown{p}];
    
    ToneNeuronClass = [ToneNeuronClass ; resp_res.InfoNeuronClass{p}];
    ToneNeuronFR = [ToneNeuronFR ; resp_res.InfoNeuronFR{p}];
    
end

%timestamps
t_corr = resp_res.t_corr{1};


%normalisation
if zscoring==1
    Zripples = zscore(MatRipples,[],2);
    ZripplesBef = zscore(MatRipplesBef,[],2);
    ZripplesCorr = zscore(MatRipplesCorr,[],2);
    ZtonesUpUp = zscore(MatTonesUpUP,[],2);
    ZtonesUpDown = zscore(MatTonesUpDown,[],2);
    ZtonesDownUp = zscore(MatTonesDownUp,[],2);
    ZtransitDownUp = zscore(MatTransitDownUp,[],2);
    ZtransitUpDown = zscore(MatTransitUpDown,[],2);
    
elseif zscoring==2
    Zripples = (MatRipples-mean(MatRipples(:,t_corr<-200),2)) ./ std(MatRipples(:,t_corr<-200),0,2);
    ZripplesBef = (MatRipplesBef-mean(MatRipplesBef(:,t_corr<-200),2)) ./ std(MatRipplesBef(:,t_corr<-200),0,2);
    ZripplesCorr = (MatRipplesCorr-mean(MatRipplesCorr(:,t_corr<-200),2)) ./ std(MatRipplesCorr(:,t_corr<-200),0,2);
    ZtonesUpUp = (MatTonesUpUP-mean(MatTonesUpUP(:,t_corr<-200),2)) ./ std(MatTonesUpUP(:,t_corr<-200),0,2);
    ZtonesUpDown = (MatTonesUpDown-mean(MatTonesUpDown(:,t_corr<-200),2)) ./ std(MatTonesUpDown(:,t_corr<-200),0,2);
    ZtonesDownUp = (MatTonesDownUp-mean(MatTonesDownUp(:,t_corr<-200),2)) ./ std(MatTonesDownUp(:,t_corr<-200),0,2);
    ZtransitDownUp = (MatTransitDownUp-mean(MatTransitDownUp(:,t_corr<-200),2)) ./ std(MatTransitDownUp(:,t_corr<-200),0,2);
    ZtransitUpDown = (MatTransitUpDown-mean(MatTransitUpDown(:,t_corr<-200),2)) ./ std(MatTransitUpDown(:,t_corr<-200),0,2);
    
else
    Zripples = MatRipples ./ RipNeuronFR;
    ZripplesBef = MatRipplesBef ./ RipNeuronFR;
    ZripplesCorr = MatRipplesCorr ./ RipNeuronFR;
    ZtonesUpUp = MatTonesUpUP ./ ToneNeuronFR;
    ZtonesUpDown = MatTonesUpDown ./ ToneNeuronFR;
    ZtonesDownUp = MatTonesDownUp ./ ToneNeuronFR;
    ZtransitDownUp = MatTransitDownUp ./ ToneNeuronFR;
    ZtransitUpDown = MatTransitUpDown ./ ToneNeuronFR;
end


%clean
Zripples(~isfinite(Zripples))=nan;
ZripplesBef(~isfinite(ZripplesBef))=nan;
ZripplesCorr(~isfinite(ZripplesCorr))=nan;
ZtonesUpUp(~isfinite(ZtonesUpUp))=nan;
ZtonesUpDown(~isfinite(ZtonesUpDown))=nan;
ZtonesDownUp(~isfinite(ZtonesDownUp))=nan;
ZtransitDownUp(~isfinite(ZtransitDownUp))=nan;
ZtransitUpDown(~isfinite(ZtransitUpDown))=nan;


%ordering
[~,id_fr] = sort(RipNeuronFR);
Oripples = Zripples(id_fr,:);
OripplesBef = ZripplesBef(id_fr,:);
OripplesCorr = ZripplesCorr(id_fr,:);

[~,id_fr] = sort(ToneNeuronFR);
OtonesUpUp = ZtonesUpUp(id_fr,:);
OtonesUpDown = ZtonesUpDown(id_fr,:);
OtonesDownUp = ZtonesDownUp(id_fr,:);



%% neurons
%class
neuronClass.ripples{1} = find(RipNeuronClass>0);
neuronClass.ripples{2} = find(RipNeuronClass<0);
neuronClass.tones{1} = find(ToneNeuronClass>0);
neuronClass.tones{2} = find(ToneNeuronClass<0);

%by firing rate
group_fr = [0 2 5 50];
for i=1:length(group_fr)-1
    neuronFR.ripples{i} = find(RipNeuronFR>group_fr(i) & RipNeuronFR<=group_fr(i+1));
    neuronFR.tones{i} = find(ToneNeuronFR>group_fr(i) & ToneNeuronFR<=group_fr(i+1));
    labels{i} = [num2str(group_fr(i)) ' - ' num2str(group_fr(i+1)) ' Hz'];
end

%by group and firing rate
neuronGroup.ripples{1} = find(RipNeuronClass<0 & RipNeuronFR>5);
neuronGroup.ripples{2} = find(RipNeuronClass>0 & RipNeuronFR>5);
neuronGroup.ripples{3} = find(RipNeuronClass<0 & RipNeuronFR<=5);
neuronGroup.ripples{4} = find(RipNeuronClass>0 & RipNeuronFR<=5);

neuronGroup.tones{1} = find(ToneNeuronClass<0 & ToneNeuronFR>5);
neuronGroup.tones{2} = find(ToneNeuronClass>0 & ToneNeuronFR>5);
neuronGroup.tones{3} = find(ToneNeuronClass<0 & ToneNeuronFR<=5);
neuronGroup.tones{4} = find(ToneNeuronClass>0 & ToneNeuronFR<=5);

leg = {'Int > 5Hz', 'Pyr > 5Hz', 'Int < 5Hz', 'Pyr < 5Hz'};

    

%% Plot - Int/Pyr
colori_neur = {'b','r'};
fontsize=13;

figure, hold on

%response ripples
subplot(2,4,1), hold on 

for i=1:length(neuronClass.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zripples(neuronClass.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'pyramidal','interneuron')
title('on ripples')

%response ripples no down before
subplot(2,4,2), hold on 

for i=1:length(neuronClass.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesBef(neuronClass.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,4,3), hold on 

for i=1:length(neuronClass.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesCorr(neuronClass.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')

%response transition up>down
subplot(2,4,4), hold on 

for i=1:length(neuronClass.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitUpDown(neuronClass.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('start down')


%response tones up>up
subplot(2,4,5), hold on 

for i=1:length(neuronClass.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpUp(neuronClass.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,4,6), hold on 

for i=1:length(neuronClass.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpDown(neuronClass.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,4,7), hold on 

for i=1:length(neuronClass.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesDownUp(neuronClass.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')

%response transition down>up
subplot(2,4,8), hold on 

for i=1:length(neuronClass.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitDownUp(neuronClass.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('end down')


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



%% Plot curves by FR
colori_neur = {'b','r','k'};
fontsize=13;

figure, hold on

%response ripples
subplot(2,4,1), hold on 

for i=1:length(neuronFR.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zripples(neuronFR.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,labels)
title('on ripples')

%response ripples no down before
subplot(2,4,2), hold on 

for i=1:length(neuronFR.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesBef(neuronFR.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,4,3), hold on 

for i=1:length(neuronFR.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesCorr(neuronFR.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')

%response transition up>down
subplot(2,4,4), hold on 

for i=1:length(neuronFR.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitUpDown(neuronFR.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('start down')

%response tones up>up
subplot(2,4,5), hold on 

for i=1:length(neuronFR.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpUp(neuronFR.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,4,6), hold on 

for i=1:length(neuronFR.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpDown(neuronFR.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,4,7), hold on 

for i=1:length(neuronFR.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesDownUp(neuronFR.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')

%response transition down>up
subplot(2,4,8), hold on 

for i=1:length(neuronFR.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitDownUp(neuronFR.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('end down')


%% Plot curves by FR and type
colori_neur = {'r', [0.5 0 0.5], [1 0.45 0], 'b'};
fontsize=13;

figure, hold on

%response ripples
subplot(2,4,1), hold on 

for i=1:length(neuronGroup.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(Zripples(neuronGroup.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg)
title('on ripples')

%response ripples no down before
subplot(2,4,2), hold on 

for i=1:length(neuronGroup.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesBef(neuronGroup.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down before')

%response ripples no down around
subplot(2,4,3), hold on 

for i=1:length(neuronGroup.ripples)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZripplesCorr(neuronGroup.ripples{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('ripples no down around')

%response transition up>down
subplot(2,4,4), hold on 

for i=1:length(neuronGroup.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitUpDown(neuronGroup.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('start down')

%response tones up>up
subplot(2,4,5), hold on 

for i=1:length(neuronGroup.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpUp(neuronGroup.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>up')

%response tones up>down
subplot(2,4,6), hold on 

for i=1:length(neuronGroup.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesUpDown(neuronGroup.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones up>down')

%response tones down>up
subplot(2,4,7), hold on 

for i=1:length(neuronGroup.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtonesDownUp(neuronGroup.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-300 300], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones down>up')

%response transition down>up
subplot(2,4,8), hold on 

for i=1:length(neuronGroup.tones)
    hold on, h(i) = plot(t_corr,runmean(nanmean(ZtransitDownUp(neuronGroup.tones{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('end down')


