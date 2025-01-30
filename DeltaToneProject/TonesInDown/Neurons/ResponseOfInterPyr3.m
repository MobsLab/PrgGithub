%%ResponseOfInterPyr3
% 09.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   ResponseOfInterPyr ResponseOfInterPyr2
%



clear

%goto
disp('****************************************************************')
disp(pwd)


%params
binsize_cc = 2;
nbins_cc = 400;
p=1;
       

%% load
% tones

load('behavResources.mat', 'ToneEvent')
if ~exist('ToneEvent','var')
    try
        load('behavResources_SB.mat', 'TTLInfo')
        ToneEvent = ts(sort([TTLInfo.CSMoinsTimes ; TTLInfo.CSPlusTimes]));
    catch
        load('behavResources.mat', 'BeepTimes')
        ToneEvent = ts(sort([BeepTimes.CSM BeepTimes.CSP]'));
    end
end
    
%load Spikes of PFCx
load('SpikeData.mat', 'S')
load('InfoNeuronsAll.mat', 'InfoNeurons')
NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
S = S(NumNeurons);

%% Cross Corr

%tones
MatTones = [];
for i=1:length(S)
    % PETH in Wake
    [C,B] = CrossCorr(Range(ToneEvent), Range(S{i}),binsize_cc,nbins_cc);
    MatTones = [MatTones ; C'];
end
Ztones = zscore(MatTones,[],2);

t_corr=B;


%% Neuron info
InfoNeuronClass = InfoNeurons.putative(strcmpi(InfoNeurons.structure,'PFCx'));
InfoNeuronLayer = InfoNeurons.layer(strcmpi(InfoNeurons.structure,'PFCx'));
InfoNeuronFR = InfoNeurons.firingrate(strcmpi(InfoNeurons.structure,'PFCx'));

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


%% Plot 1 

%Int/Pyr
colori_neur = {'b','r'};
fontsize=13;

figure, hold on

%response tones
subplot(1,2,1), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(Ztones(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'pyramidal','interneuron')
title('on tones')


%Layer
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
layers = find(~cellfun(@isempty,neuronLayer));

%response tones
subplot(1,2,2), hold on 

for i=1:length(layers)
    hold on, h(i) = plot(t_corr,runmean(mean(Ztones(neuronLayer{layers(i)},:)),2),'color', colori_neur{i});
    leg{i} = num2str(layers(i));
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg),
title('on tones')









