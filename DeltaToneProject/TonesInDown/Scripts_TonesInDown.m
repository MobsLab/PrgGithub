%%Scripts_TonesInDown
% 16.04.2018 KJ
%
%
% see
%    
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

%% init
%params
binsize_met = 10;
nbBins_met  = 80;
binsize_mua = 2;
minDuration = 75;

%tone impact
load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')

%neuron info
load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')
load('SpikeData.mat', 'S')
load('IdFigureData2.mat', 'night_duration')

%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
ToneEvent = ts(tones_tmp);


%% responding neurons
Cdiff = Ctones - Csham;
idt = xtones>0 & xtones<80;

for i=1:length(neuronsLayers)
    effect_peak(i) = max(Cdiff(i,idt));
    effect_mean(i) = mean(Cdiff(i,idt));
end

responses = zeros(length(neuronsLayers),1);
idn = effect_peak>4;
resp_neurons = NumNeurons(idn);
regular_neurons = NumNeurons(~idn);


%% Correlation matrix
newS = [S(resp_neurons) S(regular_neurons)];

t_step=0:50:night_duration; %5ms
iFR=nan(length(newS),length(t_step)); iFRz=iFR;
for i=1:length(newS)
    iFR(i,:) = hist(Range(newS{i}),t_step);
end

MatCor = corrcoef(iFR');



