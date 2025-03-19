%DownMergeThreshEffect_KJ

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
load StateEpochSB SWSEpoch Wake
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Args
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 0;
maxDownDur = 2000;

minDurBins = 0:10:1500; % minimum duration bins for downstates
mergeGap_list = 0:10:30; % duration max to allow a merge of silence period
predown_size = 30;


%Pool spikes
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize);
Qsws = Restrict(Q, SWSEpoch);
Qwake = Restrict(Q, Wake);


%% Number of downs
nbDownSws = zeros(length(mergeGap_list), length(minDurBins));
nbDownWake = zeros(length(mergeGap_list), length(minDurBins));
for i=1:length(mergeGap_list)
    mergeGap = mergeGap_list(i);
    DownSws = FindDown2_KJ(Qsws, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
    downSwsDur = (End(DownSws) - Start(DownSws)) / 10; %in ms
    DownWake = FindDown2_KJ(Qwake, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
    downWakeDur = (End(DownWake) - Start(DownWake)) / 10; %in ms
    
    for j=1:length(minDurBins)
        bmin = minDurBins(j);
        nbDownSws(i,j) = sum(downSwsDur>bmin);
        nbDownWake(i,j) = sum(downWakeDur>bmin);
    end
end


% Total durations of Epochs
DurationSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s')) / 3600;
DurationWake=sum(End((Wake),'s')-Start((Wake),'s')) / 3600;

nbDownSws = nbDownSws / DurationSWS;
nbDownWake = nbDownWake / DurationWake;


%% plot
figure,
hold on, plot(minDurBins, nbDownSws(1,:) ,'b')
hold on, plot(minDurBins, nbDownSws(2,:) ,'y')
hold on, plot(minDurBins, nbDownSws(3,:) ,'r')
hold on, plot(minDurBins, nbDownSws(4,:) ,'k')
hold on, plot(minDurBins, nbDownWake(1,:) ,'--.b')
hold on, plot(minDurBins, nbDownWake(2,:) ,'--.y')
hold on, plot(minDurBins, nbDownWake(3,:) ,'--.r')
hold on, plot(minDurBins, nbDownWake(4,:) ,'--.k')
hold on, set(gca,'xscale','log')
hold on, set(gca,'yscale','log')
hold on, set(gca,'xtick',[10 50 100 200 500 1500])
hold on, legend('Sws 0ms','Sws 10ms','Sws 20ms','Sws 30ms', 'Wake 0ms','Wake 10ms','Wake 20ms','Wake 30ms')
hold on, title('Distribution of downstates for several merge conditions')














