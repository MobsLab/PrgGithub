%%ToneEffectOnNeurons2
% 12.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneEffectOnNeurons
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


p=2;

disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)

clearvars -except Dir p

%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
ToneEvent = ts(tones_tmp);



%% neuron response to tones
load('NeuronTones.mat')
%   'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')

Cdiff = Ctones - Csham;
idx = xtones>0 & xtones<80;

for i=1:length(neuronsLayers)
    effect_peak(i) = max(Cdiff(i,idx));
    effect_mean(i) = mean(Cdiff(i,idx));
end

%responding neurons
idx = effect_peak>4|effect_mean>1.5;
resp_neurons = NumNeurons(idx);
regular_neurons = NumNeurons(~idx);


%% effect on Down without responding neurons
%params
binsize_mua = 2;
minDuration  = 50;

MUAreg = GetMuaNeurons_KJ(regular_neurons,'binsize',binsize_mua); %2ms
down_PFCx = FindDownKJ(MUAreg, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
down_duration = End(down_PFCx) - Start(down_PFCx);



