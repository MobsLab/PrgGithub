%%ResponseOfInterPyr2
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   FigNeuronsPutativeResponse3 ParcoursRipplesNeuronCrossCorr
%   ResponseOfInterPyr ResponseOfInterPyr3     



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaTone');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);

%params
binsize_cc = 2;
nbins_cc = 400;
p=1;

%goto
disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)
       

%% load
% tones
load('behavResources.mat', 'ToneEvent')
ToneEvent;

%load Spikes of PFCx
load('SpikeData.mat', 'S')
load('InfoNeuronsAll.mat', 'InfoNeurons')
NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
S = S(NumNeurons);

% Substages
load('SleepSubstages.mat', 'Epoch')
N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
N2N3 = or(N2,N3);

% ripples
load('Ripples.mat','tRipples')
if ~exist('tRipples','var')
    load('Ripples.mat','Ripples')
    tRipples = ts(Ripples(:,2)*10);
end


%% Cross Corr

%Ripples
MatRipples = [];
for i=1:length(S)
    [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
    MatRipples = [MatRipples ; C'];
end
Zripples = zscore(MatRipples,[],2);

%tones
MatTones = [];
for i=1:length(S)
    % PETH in Wake
    [C,B] = CrossCorr(Range(ToneEvent), Range(S{i}),binsize_cc,nbins_cc);
    MatTones = [MatTones ; C'];
end
Ztones = zscore(MatTones,[],2);

%tones in N2
MatToneN2 = [];
for i=1:length(S)
    % PETH in Wake
    [C,B] = CrossCorr(Range(Restrict(ToneEvent, N2)), Range(S{i}),binsize_cc,nbins_cc);
    MatToneN2 = [MatToneN2 ; C'];
end
ZtoneN2 = zscore(MatToneN2,[],2);

%tones in N3
MatToneN3 = [];
for i=1:length(S)
    % PETH in Wake
    [C,B] = CrossCorr(Range(Restrict(ToneEvent, N3)), Range(S{i}),binsize_cc,nbins_cc);
    MatToneN3 = [MatToneN3 ; C'];
end
ZtoneN3 = zscore(MatToneN3,[],2);

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


%% Plot 1 - Int/Pyr
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;

figure, hold on

%response ripples
subplot(2,2,1), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'pyramidal','interneuron')
title('on ripples')

%response tones
subplot(2,2,2), hold on 

for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(Ztones(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subplot(2,2,3), hold on 
for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subplot(2,2,4), hold on 
for i=1:length(neuronClass)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronClass{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')


%% Plot 2 - Layer
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;
minlayer = find(~cellfun(@isempty,neuronLayer),1);

figure, hold on

%response ripples
subplot(2,2,1), hold on 

for l=minlayer:length(neuronLayer)
    i=l-minlayer+1;
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronLayer{l},:)),2),'color', colori_neur{i});
    leg{i} = num2str(l);
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,leg), clear leg
title('on ripples')

%response tones
subplot(2,2,2), hold on 

for l=minlayer:length(neuronLayer)
    i=l-minlayer+1;
    hold on, h(i) = plot(t_corr,runmean(mean(Ztones(neuronLayer{l},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subplot(2,2,3), hold on 
for l=minlayer:length(neuronLayer)
    i=l-minlayer+1;
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronLayer{l},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subplot(2,2,4), hold on 
for l=minlayer:length(neuronLayer)
    i=l-minlayer+1;
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronLayer{l},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')


%% Plot 3 - FR
colori_neur = {[0.13 0.54 0.13],'b','r','k'};
fontsize=15;

figure, hold on

%response ripples
subplot(2,2,1), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
legend(h,'FR<7Hz','FR>7Hz')
title('on ripples')

%response tones
subplot(2,2,2), hold on 

for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(Ztones(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'xticklabel',{}, 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
title('on tones')

%response tones N2
subplot(2,2,3), hold on 
for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N2')

%response tones N3
subplot(2,2,4), hold on 
for i=1:length(neuronFR)
    hold on, h(i) = plot(t_corr,runmean(mean(ZtoneN2(neuronFR{i},:)),2),'color', colori_neur{i});
end
set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
xlabel('ms'),
title('on tones in N3')








