%Export to h5 

clear
%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

% params
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
frequency_sampling = 250;

%get lfp
EEGdeep = ResampleTSD(LFPdeep,frequency_sampling);
EEGsup = ResampleTSD(LFPsup,frequency_sampling);

% get downstate
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
down_start = Start(Down,'ms') * (frequency_sampling / 1000);
down_duration = (End(Down,'ms') - Start(Down,'ms')) * (frequency_sampling / 1000);

down_start = floor(down_start');
down_duration = floor(down_duration');

%Write
hdf5write('mouse244_29032015.h5', '/eeg_deep', Data(EEGdeep));
hdf5write('mouse244_29032015.h5', '/eeg_sup', Data(EEGsup), 'WriteMode', 'append');
hdf5write('mouse244_29032015.h5', '/down_start', down_start, 'WriteMode', 'append');
hdf5write('mouse244_29032015.h5', '/down_duration', down_duration, 'WriteMode', 'append');
hdf5write('mouse244_29032015.h5', '/fs', frequency_sampling, 'WriteMode', 'append');


