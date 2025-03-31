%PlotSpindlesDeltaObserver

%GUI that shows burst of delta and timestamps of tones

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
load ChannelsToAnalyse/dHPC_rip
eval(['load LFPData/LFP',num2str(channel)])
HPCrip=LFP;
clear LFP
load ChannelsToAnalyse/NRT_deep
eval(['load LFPData/LFP',num2str(channel)])
NRTdeep=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Args
binsize=10;
thresh0 = 0.7;
minDownDur = 75;
maxDownDur = 500;
mergeGap = 10; % duration max to allow a merge of silence period
predown_size = 50;
thresh_rip = [5 7];
duration_rip = [30 30 100];

%% Find Down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10);
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
down_durations = End(Down) - Start(Down);
down_start = Start(Down);


%% Spindles
try
    load SpindlesPFCxSup.mat SpiTot
    Spi=SpiTot; 
    clear SpiTot
catch
    [Spi,SWA,stdev,usedEpoch]=FindSpindlesKarimNewSB(LFPsup,[2 20],SWSEpoch);
end

%% Ripples
try
    load newRipHPC.mat Ripples_tmp
    ripples = Ripples_tmp;
    clear Ripples_tmp
catch
    [ripples,~] = FindRipplesKarimSB(HPCrip,SWSEpoch,thresh_rip,duration_rip);
end


%% signals
MUA = Q;
spindles_start = Spi(:,1);
spindles_duration = Spi(:,3)-Spi(:,1);
spindles_peak = Spi(:,2);
ripples_duration = ripples(:,3) - ripples(:,1);
ripples_start = ripples(:,1);

signals{1} = [Range(LFPsup,'ms')'/1000 ; Data(LFPsup)']; 
signals{2} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
signals{3} = [Range(HPCrip,'ms')'/1000 ; Data(HPCrip)'];
signals{4} = [Range(NRTdeep,'ms')'/1000 ; Data(NRTdeep)'];
signals{5} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
%spindles and down rect
for ch=[1 2 4]
    sog.add_rectangles(spindles_start', spindles_duration', ch, 'b');
    sog.add_verticals(spindles_peak', ch);
    sog.add_rectangles(down_start'/1E4, down_durations'/1E4, ch);
end
sog.add_rectangles(ripples_start', ripples_duration',3, 'g');

sog.set_time_events(spindles_start);
sog.set_title('LFP sup', 1);
sog.set_title('LFP deep', 2);
sog.set_title('HPC rip', 3);
sog.set_title('NRT deep', 4);
sog.set_title('MUA', 5);

sog.set_ymin(1, -3000); sog.set_ymax(1, 3000);
sog.set_ymin(2, -3000); sog.set_ymax(2, 3000);
sog.set_ymin(3, -3000); sog.set_ymax(3, 3000);
sog.set_ymin(4, -3000); sog.set_ymax(4, 3000);
sog.set_ymin(5, 0); sog.set_ymax(5, 5);

sog.run_window



