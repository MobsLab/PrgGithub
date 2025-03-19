%PlotDeltaRipplesObserver
%
%
%


clear

% params
binsize= 10;

%% Load data
%LFP
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
PFCdeep=LFP;
clear LFP
try
    load ChannelsToAnalyse/PFCx_sup
catch
    load ChannelsToAnalyse/PFCx_deltasup
end
eval(['load LFPData/LFP',num2str(channel)])
PFCsup=LFP;
clear LFP
try
    load ChannelsToAnalyse/dHPC_rip
    if isempty(channel); 
        error;
    end
catch
    load ChannelsToAnalyse/dHPC_deep
end
eval(['load LFPData/LFP',num2str(channel)])
HPCrip=LFP;
clear LFP
clear channel

%Epoch
load StateEpochSB SWSEpoch

%MUA and spikes
load SpikeData
load SpikesToAnalyse/PFCx_Neurons
NumNeurons=number;
clear number
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
MUA=MakeQfromS(ST,binsize*10);

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
    
%Delta waves
try
    load DeltaPFCx DeltaOffline
catch
    try
        load newDeltaPFCx DeltaEpoch
    catch
        load AllDeltaPFCx DeltaEpoch
    end
    DeltaOffline = DeltaEpoch;
    clear DeltaEpoch
end

%Ripples
try
    load newRipHPC Ripples_tmp
catch
    load AllRipplesdHPC25 dHPCrip;
    Ripples_tmp=dHPCrip;
    clear dHPCrip
end
Ripples = intervalSet(Ripples_tmp(:,1)*1E4,Ripples_tmp(:,3)*1E4);

%tones
try
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = 2000;
    event_tmp = (TONEtime1 + delay) / 1E4;
catch
    load ShamSleepEvent SHAMtime
    event_tmp = Range(SHAMtime) / 1E4;
end


%% signals and detections

labels = {'PFCx sup', 'PFCx deep', 'HPC', 'MUA'};
signals{1} = [Range(PFCsup,'ms')'/1000 ; Data(PFCsup)'];
signals{2} = [Range(PFCdeep,'ms')'/1000 ; Data(PFCdeep)'];
signals{3} = [Range(HPCrip,'ms')'/1000 ; Data(HPCrip)'];
signals{4} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];

start_down = Start(Down,'ms')' / 1000;
down_duration = (End(Down,'ms') - Start(Down,'ms'))' / 1000;
start_delta = Start(DeltaOffline,'ms')' / 1000;
delta_duration = (End(DeltaOffline,'ms') - Start(DeltaOffline,'ms'))' / 1000;
start_ripples = Start(Ripples,'ms')' / 1000;
ripples_duration = (End(Ripples,'ms') - Start(Ripples,'ms'))' / 1000;


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[1 2]);
for ch=1:sog.nb_channel
    sog.set_title(labels{ch}, ch);
    sog.add_verticals(event_tmp, ch);
end

%add events
sog.add_rectangles(start_delta, delta_duration, 1);
sog.add_rectangles(start_delta, delta_duration, 2);
sog.add_rectangles(start_ripples, ripples_duration, 3,'b');
sog.add_rectangles(start_down, down_duration, 4);

sog.set_time_events(sort([start_ripples]));

%ylim
sog.set_ymin(1, -2000); sog.set_ymax(1, 2000);
sog.set_ymin(2, -2000); sog.set_ymax(2, 2000);
sog.set_ymin(3, -2000); sog.set_ymax(3, 2000);
sog.set_ymin(4, 0); sog.set_ymax(4, 7);

sog.run_window







