%%Script_for_kb


%% paths
Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone'); %Random conditions, with enough spikes for down states
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0'); % Delta triggered conditions (delay = 0ms), with enough spikes for down states

%sham nights
Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);


%% get delta waves, down states
load('DeltaWaves.mat', 'deltas_PFCx')
% there are other infos in DeltaWaves.mat, like parameters to compute delta waves

load('DownState.mat', 'down_PFCx')


%% get ripples

load('Ripples.mat', 'RipplesEpoch') % Ripples intervalSet

load('Ripples.mat', 'Ripples') %vector, start / center / end, in ms


%% get spindles
load('Spindles.mat', 'spindles_PFCx') %in sec  [10-16]hz
load('Spindles.mat', 'spindles_high_PFCx') % high spindles [13-16]hz
load('Spindles.mat', 'spindles_low_PFCx') % low spindles [10-13]hz


%% get lfp

% PFCx locations contains a list of channels indices: it is all PFCx
% channels and I just kept one channel per tetrode
load('ChannelsToAnalyse/PFCx_locations.mat', 'channels') %get channel numbers, each channel correspond to a different location in PFCx 
load('ChannelsToAnalyse/PFCx_clusters.mat', 'clusters') %get the putative layers (or clusters) corresponding

%example to get an LFP signal from cluster 2
load('ChannelsToAnalyse/PFCx_locations.mat', 'channels') 
load('ChannelsToAnalyse/PFCx_clusters.mat', 'clusters')
chan = channels(clusters==2);
if ~isempty(chan)
    chan = chan(1);
    load(['LFPData/LFP' num2str(chan)], 'LFP')
else
    disp('no channel in layer 2')
end


%get LFP deep
load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
load(['LFPData/LFP' num2str(channel)], 'LFP')
LFPdeep = LFP; 
clear channel LFP
%just replace PFCx_deep to get other area


%% spikes

%MUA
MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize); %all neurons of PFCx
MUA  = GetMuaNeurons_KJ([1 2 3 10 14 15 20], 'binsize',binsize); %only the selected neurons

%Neurons
load('SpikeData.mat', 'S')

%Get neurons from PFCx
load('SpikesToAnalyse/PFCx_Neurons.mat')
NumNeurons = number;
S_pfc = S(NumNeurons);

% info on neurons in InfoNeuronsPFCx.mat
load('InfoNeuronsPFCx.mat', 'InfoNeurons')

NumNeurons = InfoNeurons.NumNeurons; % same as above
S_pfc = S(NumNeurons);

%for S_pfc
fr = InfoNeurons.firingrate; % firing rate of each neurons of S_pfc
layer = InfoNeurons.layer; % putative layer of each neurons of S_pfc
putative = InfoNeurons.putative; % int or pyr (>0 for pyramidal, and negative for interneurons - this the probability given by Sophie)
soloist = InfoNeurons.soloist; % soloïst or chorist (0 for chorist, 1 for soloïst)
prefered_substages = InfoNeurons.substages; % prefered substages, if any (0 if none)

fr_substage = InfoNeurons.fr_substage; % firing rate of each neurons of S_pfc, in each substages (Matrix n x 6)


%% Sleep stages

%directly from SleepScoring_OBGamma.mat (equivalent to StateEpochSB)
load('SleepScoring_OBGamma.mat', 'REMEpoch')
load('SleepScoring_OBGamma.mat', 'SWSEpoch')
load('SleepScoring_OBGamma.mat', 'Wake')

%directly from SleepScoring_Accelero.mat (equivalent to StateEpoch, with accelerometer)
load('SleepScoring_Accelero.mat', 'REMEpoch')
load('SleepScoring_Accelero.mat', 'SWSEpoch')
load('SleepScoring_Accelero.mat', 'Wake')    

%Substages
load('SleepSubstages.mat', 'Epoch')
N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7}; 


%% tones
load('behavResources.mat', 'ToneEvent')


%% sham
load('ShamSleepEventRandom.mat', 'SHAMtime')


