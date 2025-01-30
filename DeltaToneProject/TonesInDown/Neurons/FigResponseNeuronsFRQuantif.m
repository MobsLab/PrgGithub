%%FigResponseNeuronsFRQuantif
% 10.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%   Influence of firing rate
%
% see
%   ParcoursResponseTypeNeurons ParcoursResponseTypeNeuronsPlot1
%   ParcoursResponseTypeNeuronsPlotFr


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseRipplesTypeNeurons.mat'))
load(fullfile(FolderDeltaDataKJ,'ParcoursResponseTypeNeurons.mat'))

%params
zscoring = 2;

%% concatenate and zscore

MatRipples = [];
MatRipplesBef = [];
MatRipplesCorr = [];
RipNeuronClass = [];
RipNeuronFR = [];

for p=1:length(resprip_res.path)
    MatRipples     = [MatRipples ; resprip_res.MatRipples{p}];
    MatRipplesBef  = [MatRipplesBef ; resprip_res.MatRipplesBef{p}];
    MatRipplesCorr = [MatRipplesCorr ; resprip_res.MatRipplesCorr{p}];
    
    RipNeuronClass = [RipNeuronClass ; resprip_res.InfoNeuronClass{p}];
    RipNeuronFR = [RipNeuronFR ; resprip_res.InfoNeuronFR{p}];
end


MatTonesUpUP = [];
MatTonesUpDown = [];
MatTonesDownUp = [];
ToneNeuronClass = [];
ToneNeuronFR = [];

for p=1:length(resp_res.path)    
    MatTonesUpUP   = [MatTonesUpUP ; resp_res.MatTonesUpUP{p}];
    MatTonesUpDown = [MatTonesUpDown ; resp_res.MatTonesUpDown{p}];
    MatTonesDownUp = [MatTonesDownUp ; resp_res.MatTonesDownUp{p}];
    
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
    
elseif zscoring==2
    Zripples = (MatRipples-mean(MatRipples(:,t_corr<-100),2)) ./ std(MatRipples(:,t_corr<-100),0,2);
    ZripplesBef = (MatRipplesBef-mean(MatRipplesBef(:,t_corr<-100),2)) ./ std(MatRipplesBef(:,t_corr<-100),0,2);
    ZripplesCorr = (MatRipplesCorr-mean(MatRipplesCorr(:,t_corr<-100),2)) ./ std(MatRipplesCorr(:,t_corr<-100),0,2);
    ZtonesUpUp = (MatTonesUpUP-mean(MatTonesUpUP(:,t_corr<-100),2)) ./ std(MatTonesUpUP(:,t_corr<-100),0,2);
    ZtonesUpDown = (MatTonesUpDown-mean(MatTonesUpDown(:,t_corr<-100),2)) ./ std(MatTonesUpDown(:,t_corr<-100),0,2);
    ZtonesDownUp = (MatTonesDownUp-mean(MatTonesDownUp(:,t_corr<-100),2)) ./ std(MatTonesDownUp(:,t_corr<-100),0,2);
    
else
    Zripples = MatRipples ./ RipNeuronFR;
    ZripplesBef = MatRipplesBef ./ RipNeuronFR;
    ZripplesCorr = MatRipplesCorr ./ RipNeuronFR;
    ZtonesUpUp = MatTonesUpUP ./ ToneNeuronFR;
    ZtonesUpDown = MatTonesUpDown ./ ToneNeuronFR;
    ZtonesDownUp = MatTonesDownUp ./ ToneNeuronFR;
end


%% mean and max response to ripples/tones

% mean and max response for ripples
twindow = t_corr>-20 & t_corr<50;
meanResp_ripples = mean(Zripples(:,twindow),2);
meanResp_ripplesBef = mean(ZripplesBef(:,twindow),2);
meanResp_ripplesCorr = mean(ZripplesCorr(:,twindow),2);

maxResp_ripples = max(Zripples(:,twindow),[],2);
maxResp_ripplesBef = max(ZripplesBef(:,twindow),[],2);
maxResp_ripplesCorr = max(ZripplesCorr(:,twindow),[],2);

% mean and max response for tones
twindow = t_corr>0 & t_corr<80;
meanResp_tUpUp = mean(ZtonesUpUp(:,twindow),2);
meanResp_tUpDown = mean(ZtonesUpDown(:,twindow),2);
meanResp_tDownUp = mean(ZtonesDownUp(:,twindow),2);

maxResp_tUpUp = max(ZtonesUpUp(:,twindow),[],2);
maxResp_tUpDown = max(ZtonesUpDown(:,twindow),[],2);
maxResp_tDownUp = max(ZtonesDownUp(:,twindow),[],2);


%% neurons
%class
neuronClass.ripples{1} = find(RipNeuronClass>0);
neuronClass.ripples{2} = find(RipNeuronClass<0);
neuronClass.tones{1} = find(ToneNeuronClass>0);
neuronClass.tones{2} = find(ToneNeuronClass<0);

%by firing rate
group_fr = [0:2:15 50];
for i=1:length(group_fr)-1
    neuronFR.ripples{i} = find(RipNeuronFR>group_fr(i) & RipNeuronFR<=group_fr(i+1));
    neuronFR.tones{i} = find(ToneNeuronFR>group_fr(i) & ToneNeuronFR<=group_fr(i+1));
end


%% data by class

for i=1:length(neuronFR.tones)
    datamean.ripples{i} = meanResp_ripples(neuronFR.ripples{i}); 
    datamean.ripbef{i} = meanResp_ripplesBef(neuronFR.ripples{i}); 
    datamean.ripcorr{i} = meanResp_ripplesCorr(neuronFR.ripples{i}); 
    
    datamean.tupup{i} = meanResp_tUpUp(neuronFR.tones{i}); 
    datamean.tupdown{i} = meanResp_tUpDown(neuronFR.tones{i}); 
    datamean.tdownup{i} = meanResp_tDownUp(neuronFR.tones{i}); 
    
    datamax.ripples{i} = maxResp_ripples(neuronFR.ripples{i}); 
    datamax.ripbef{i} = maxResp_ripplesBef(neuronFR.ripples{i}); 
    datamax.ripcorr{i} = maxResp_ripplesCorr(neuronFR.ripples{i}); 
    
    datamax.tupup{i} = maxResp_tUpUp(neuronFR.tones{i}); 
    datamax.tupdown{i} = maxResp_tUpDown(neuronFR.tones{i}); 
    datamax.tdownup{i} = maxResp_tDownUp(neuronFR.tones{i}); 
end
    


%% Plot curves
fontsize=13;

figure, hold on

%response ripples
subplot(2,2,1), hold on 
PlotErrorLineN_KJ(datamean.ripples, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'b');
PlotErrorLineN_KJ(datamean.ripbef, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'r');
PlotErrorLineN_KJ(datamean.ripcorr, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'k');

set(gca,'fontsize',fontsize), xlabel('firing rate'), ylabel('mean amplitude')
title('ripples')


subplot(2,2,2), hold on 
PlotErrorLineN_KJ(datamax.ripples, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'b');
PlotErrorLineN_KJ(datamax.ripbef, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'r');
PlotErrorLineN_KJ(datamax.ripcorr, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'k');

set(gca,'fontsize',fontsize), xlabel('firing rate'), ylabel('max amplitude')
title('ripples')

%response tones
subplot(2,2,3), hold on 
PlotErrorLineN_KJ(datamean.tupup, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'b');
PlotErrorLineN_KJ(datamean.tupdown, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'r');
PlotErrorLineN_KJ(datamean.tdownup, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'k');

set(gca,'fontsize',fontsize), xlabel('firing rate'), ylabel('mean amplitude')
title('tones')

subplot(2,2,4), hold on 
PlotErrorLineN_KJ(datamax.tupup, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'b');
PlotErrorLineN_KJ(datamax.tupdown, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'r');
PlotErrorLineN_KJ(datamax.tdownup, 'x_data',group_fr(1:end-1), 'newfig', 0, 'errorbars',1, 'median',1, 'linecolor', 'k')

set(gca,'fontsize',fontsize), xlabel('firing rate'), ylabel('max amplitude')
title('tones')

