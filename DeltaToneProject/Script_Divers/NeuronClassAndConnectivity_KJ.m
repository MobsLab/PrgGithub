%%NeuronClassAndConnectivity_KJ
% 18.01.2019 KJ
%
%
%
% see
%   FindMonoSynapticConnectivity
%



%% load
% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep

load('SpikeConnectivity.mat')
load('SpikeData.mat')
load('InfoNeuronsAll.mat')

neuronClass = InfoNeurons.putative;
neuronFR = InfoNeurons.firingrate;
neuronIsMua = InfoNeurons.ismua;



%% 

nb_excit.output = sum(MatConnectivity==1,2);
nb_inhib.output = sum(MatConnectivity==-1,2);
nb_excit.input = sum(MatConnectivity==1,1)';
nb_inhib.input = sum(MatConnectivity==-1,1)';


idx = find(neuronClass<0 & nb_excit.output>=1 & neuronIsMua==0);
idx = find(nb_inhib.output>=1 & neuronIsMua==0);
idx = find(neuronClass<0 & nb_excit.output<=4 & neuronIsMua==0);
idx = find(neuronClass<0 & nb_excit.output>=1 & neuronIsMua==0);


[idx neuronFR(idx) nb_inhib.output(idx) nb_excit.output(idx)]



