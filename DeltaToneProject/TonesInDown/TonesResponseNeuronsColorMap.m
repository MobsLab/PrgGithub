%%TonesResponseNeuronsColorMap
% 24.07.2018 KJ
%
%
% see
%   
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

%get data for each record
p=2;
disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)


%% load
load(fullfile(FolderDeltaDataKJ,'ParcoursToneEffectOnNeuronsFeatures.mat'))
firingrate  = effect_res.firingrate{p};
CcFeat      = effect_res.ccfeat{p};
Ccsham      = effect_res.ccsham{p};
baseline    = effect_res.baseline{p};
nb_neurons  = effect_res.nb_neurons{p};

%tone impact
load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')

%neuron info
load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')


%% Plot

MatPlot1 = CcFeat.upup;
MatPlot2 = CcFeat.down;


figure, hold on

%1
subplot(1,2,1), hold on
imagesc(xsham, 1:size(MatPlot1,1), MatPlot1), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
% line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatPlot1,1)], 'XLim',[-500 500]);
title('up>up'),
ylabel('# neurons'),
    
%1
subplot(1,2,2), hold on
imagesc(xsham, 1:size(MatPlot2,1), MatPlot2), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
% line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatPlot2,1)], 'XLim',[-500 500]);
title('in down'),
ylabel('# neurons'),




