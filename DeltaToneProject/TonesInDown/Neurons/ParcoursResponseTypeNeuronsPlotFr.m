%%ParcoursResponseTypeNeuronsPlotFr
% 09.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones
%   influence of the firing rate
%
% see
%   ParcoursResponseTypeNeurons ParcoursResponseTypeNeuronsPlot1
%   ParcoursResponseTypeNeuronsPlot2


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseTypeNeurons.mat'))

zscoring=2;  %0 for firing rate, 1 for zscore, 2 for zscore by the pre period 

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

%normalisation
if zscoring==1
    Zripples = zscore(MatRipples,[],2);
    ZripplesBef = zscore(MatRipplesBef,[],2);
    ZripplesCorr = zscore(MatRipplesCorr,[],2);
    ZtonesUpUp = zscore(MatTonesUpUP,[],2);
    ZtonesUpDown = zscore(MatTonesUpDown,[],2);
    ZtonesDownUp = zscore(MatTonesDownUp,[],2);
    
elseif zscoring==2
    Zripples = (MatRipples-mean(MatRipples(:,t_corr<-100),2)) ./ std(MatRipples(:,t_corr<-100),0,2);
    ZripplesBef = (MatRipplesBef-mean(MatRipplesBef(:,t_corr<-100),2)) ./ std(MatRipplesBef(:,t_corr<-100),0,2);
    ZripplesCorr = (MatRipplesCorr-mean(MatRipplesCorr(:,t_corr<-100),2)) ./ std(MatRipplesCorr(:,t_corr<-100),0,2);
    ZtonesUpUp = (MatTonesUpUP-mean(MatTonesUpUP(:,t_corr<-100),2)) ./ std(MatTonesUpUP(:,t_corr<-100),0,2);
    ZtonesUpDown = (MatTonesUpDown-mean(MatTonesUpDown(:,t_corr<-100),2)) ./ std(MatTonesUpDown(:,t_corr<-100),0,2);
    ZtonesDownUp = (MatTonesDownUp-mean(MatTonesDownUp(:,t_corr<-100),2)) ./ std(MatTonesDownUp(:,t_corr<-100),0,2);
    
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
neuronClass = InfoNeuronClass;
neuronClass(neuronClass<0) = -1;
neuronClass(neuronClass>0) = 1;


%% mean and max response to ripples/tones

selected_neurons = 1:length(neuronClass);

% selected_neurons = neuronClass>0;

% mean and max response for ripples
twindow = t_corr>-30 & t_corr<30;
meanResp_ripples = mean(Zripples(selected_neurons,twindow),2);
meanResp_ripplesBef = mean(ZripplesBef(selected_neurons,twindow),2);
meanResp_ripplesCorr = mean(ZripplesCorr(selected_neurons,twindow),2);

maxResp_ripples = max(Zripples(selected_neurons,twindow),[],2);
maxResp_ripplesBef = max(ZripplesBef(selected_neurons,twindow),[],2);
maxResp_ripplesCorr = max(ZripplesCorr(selected_neurons,twindow),[],2);

% mean and max response for tones
twindow = t_corr>30 & t_corr<60;
meanResp_tUpUp = mean(ZtonesUpUp(selected_neurons,twindow),2);
meanResp_tUpDown = mean(ZtonesUpDown(selected_neurons,twindow),2);

% twindow = t_corr>20 & t_corr<70;
maxResp_tUpUp = max(ZtonesUpUp(selected_neurons,twindow),[],2);
maxResp_tUpDown = max(ZtonesUpDown(selected_neurons,twindow),[],2);

% twindow = t_corr>20 & t_corr<70;
meanResp_tDownUp = mean(ZtonesDownUp(selected_neurons,twindow),2);
maxResp_tDownUp = max(ZtonesDownUp(selected_neurons,twindow),[],2);


%bar plot of mean amplitude
barmean_ripples{1} = meanResp_ripples(InfoNeuronClass>0); barmean_ripples{2} = meanResp_ripples(InfoNeuronClass<0);
barmean_ripplesBef{1} = meanResp_ripplesBef(InfoNeuronClass>0); barmean_ripplesBef{2} = meanResp_ripplesBef(InfoNeuronClass<0);
barmean_ripplesCorr{1} = meanResp_ripplesCorr(InfoNeuronClass>0); barmean_ripplesCorr{2} = meanResp_ripplesCorr(InfoNeuronClass<0);
barmean_tUpUp{1} = meanResp_tUpUp(InfoNeuronClass>0); barmean_tUpUp{2} = meanResp_tUpUp(InfoNeuronClass<0);
barmean_tUpDown{1} = meanResp_tUpDown(InfoNeuronClass>0); barmean_tUpDown{2} = meanResp_tUpDown(InfoNeuronClass<0);
barmean_tDownUp{1} = meanResp_tDownUp(InfoNeuronClass>0); barmean_tDownUp{2} = meanResp_tDownUp(InfoNeuronClass<0);

%bar plot of max amplitude
barmax_ripples{1} = maxResp_ripples(InfoNeuronClass>0); barmax_ripples{2} = maxResp_ripples(InfoNeuronClass<0);
barmax_ripplesBef{1} = maxResp_ripplesBef(InfoNeuronClass>0); barmax_ripplesBef{2} = maxResp_ripplesBef(InfoNeuronClass<0);
barmax_ripplesCorr{1} = maxResp_ripplesCorr(InfoNeuronClass>0); barmax_ripplesCorr{2} = maxResp_ripplesCorr(InfoNeuronClass<0);
barmax_tUpUp{1} = maxResp_tUpUp(InfoNeuronClass>0); barmax_tUpUp{2} = maxResp_tUpUp(InfoNeuronClass<0);
barmax_tUpDown{1} = maxResp_tUpDown(InfoNeuronClass>0); barmax_tUpDown{2} = maxResp_tUpDown(InfoNeuronClass<0);
barmax_tDownUp{1} = maxResp_tDownUp(InfoNeuronClass>0); barmax_tDownUp{2} = maxResp_tDownUp(InfoNeuronClass<0);	



%% Plot 3 - Mean amplitude
fontsize=13;
sz = 20;

figure, hold on

%ripples vs Up>Up
subplot(2,3,1), hold on 
scatter(meanResp_ripplesCorr, meanResp_tUpUp, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('Ripples corrected'), ylabel('tones Up>Up'),
title('mean response amplitude'),

%ripples vs Up>Down
subplot(2,3,2), hold on 
scatter(meanResp_ripplesCorr, meanResp_tUpDown, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('Ripples corrected'), ylabel('tones Up>Down'),
title('mean response amplitude'),


%ripples vs Down>Up
subplot(2,3,3), hold on 
scatter(meanResp_ripplesCorr, meanResp_tDownUp, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('Ripples corrected'), ylabel('tones Down>Up'),
title('mean response amplitude'),

%Up>Up vs Up>Down
subplot(2,3,4), hold on 
scatter(meanResp_tUpUp, meanResp_tUpDown, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('tones Up>Up'), ylabel('tones Up>Down'),
title('mean response amplitude'),

%Up>Up vs Down>Up
subplot(2,3,5), hold on 
scatter(meanResp_tUpUp, meanResp_tDownUp, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('tones Up>Up'), ylabel('tones Down>Up'),
title('mean response amplitude'),


%Up>Down vs Down>Up
subplot(2,3,6), hold on 
scatter(meanResp_tUpDown, meanResp_tDownUp, sz, log(InfoNeuronFR(selected_neurons)), 'filled'),
set(gca, 'fontsize',fontsize),
xlabel('tones Up>Down'), ylabel('tones Down>Up'),
title('mean response amplitude'),





%% Plot 1 - bar plot of mean amplitude
colori_neur = {'b','r'};
labels = {'pyramidal','interneuron'};

figure, hold on

%response ripples
subplot(2,3,1), hold on 
PlotErrorBarN_KJ(barmean_ripples, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels), ylabel('mean amplitude'),
title('on ripples'),

%response ripples no down before
subplot(2,3,2), hold on 
PlotErrorBarN_KJ(barmean_ripplesBef, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on ripples no down before'),

%response ripples no down around
subplot(2,3,3), hold on 
PlotErrorBarN_KJ(barmean_ripplesCorr, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on ripples no down around'),

%response tones up>up
subplot(2,3,4), hold on 
PlotErrorBarN_KJ(barmean_tUpUp, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels), ylabel('mean amplitude'),
title('on tones up>up'),

%response tones up>down
subplot(2,3,5), hold on 
PlotErrorBarN_KJ(barmean_tUpDown, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on tones up>down'),

%response tones down>up
subplot(2,3,6), hold on 
PlotErrorBarN_KJ(barmean_tDownUp, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on tones down>up'),


%% Plot 1 - bar plot of mean amplitude
colori_neur = {'b','r'};
labels = {'pyramidal','interneuron'};

figure, hold on

%response ripples
subplot(2,3,1), hold on 
PlotErrorBarN_KJ(barmax_ripples, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels), ylabel('max amplitude'),
title('on ripples'),

%response ripples no down before
subplot(2,3,2), hold on 
PlotErrorBarN_KJ(barmax_ripplesBef, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on ripples no down before'),

%response ripples no down around
subplot(2,3,3), hold on 
PlotErrorBarN_KJ(barmax_ripplesCorr, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on ripples no down around'),

%response tones up>up
subplot(2,3,4), hold on 
PlotErrorBarN_KJ(barmax_tUpUp, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels), ylabel('max amplitude'),
title('on tones up>up'),

%response tones up>down
subplot(2,3,5), hold on 
PlotErrorBarN_KJ(barmax_tUpDown, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on tones up>down'),

%response tones down>up
subplot(2,3,6), hold on 
PlotErrorBarN_KJ(barmax_tDownUp, 'newfig',0, 'barcolors',colori_neur, 'paired',0, 'ShowSigstar','sig','showpoints',0);
set(gca,'xtick',1:length(labels),'XtickLabel',labels)
title('on tones down>up'),



%% Plot 3 - Mean amplitude
fontsize=13;
colori_neur = [1 0 0 ; 0 0 1];


figure, hold on

%response ripples
subplot(2,3,1), hold on 
gscatter(InfoNeuronFR, meanResp_ripples, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),
ylabel('mean response amplitude'),

%response ripples no down before
subplot(2,3,2), hold on 
gscatter(InfoNeuronFR, meanResp_ripplesBef, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples no down before'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),

%response ripples no down around
subplot(2,3,3), hold on 
gscatter(InfoNeuronFR, meanResp_ripplesCorr, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples no down around'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),

%response tones up>up
subplot(2,3,4), hold on 
gscatter(InfoNeuronFR, meanResp_tUpUp, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on tones up>up')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'), ylabel('mean response amplitude'),

%response tones up>down
subplot(2,3,5), hold on 
gscatter(InfoNeuronFR, meanResp_tUpDown, neuronClass, colori_neur),
title('on tones up>down')
legend('interneuron','pyramidal')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'),
s=findobj('type','legend');
delete(s)


%response tones down>up
subplot(2,3,6), hold on 
gscatter(InfoNeuronFR, meanResp_tDownUp, neuronClass, colori_neur),
title('on tones down>up')
legend('interneuron','pyramidal')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'),



%% Plot 4 - Firing rates vs max amplitude
fontsize=13;
sz = 25;
colori_neur = [1 0 0 ; 0 0 1];


figure, hold on

%response ripples
subplot(2,3,1), hold on 
gscatter(InfoNeuronFR, maxResp_ripples, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),
ylabel('max response amplitude'),

%response ripples no down before
subplot(2,3,2), hold on 
gscatter(InfoNeuronFR, maxResp_ripplesBef, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples no down before'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),

%response ripples no down around
subplot(2,3,3), hold on 
gscatter(InfoNeuronFR, maxResp_ripplesCorr, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on ripples no down around'),
set(gca, 'XScale', 'log', 'fontsize',fontsize),

%response tones up>up
subplot(2,3,4), hold on 
gscatter(InfoNeuronFR, maxResp_tUpUp, neuronClass, colori_neur),
legend('interneuron','pyramidal')
title('on tones up>up')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'), ylabel('max response amplitude'),

%response tones up>down
subplot(2,3,5), hold on 
gscatter(InfoNeuronFR, maxResp_tUpDown, neuronClass, colori_neur),
title('on tones up>down')
legend('interneuron','pyramidal')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'),
s=findobj('type','legend');
delete(s)

%response tones down>up
subplot(2,3,6), hold on 
gscatter(InfoNeuronFR, maxResp_tDownUp, neuronClass, colori_neur),
title('on tones down>up')
legend('interneuron','pyramidal')
set(gca, 'XScale', 'log', 'fontsize',fontsize),
xlabel('firing rate (Hz)'),





