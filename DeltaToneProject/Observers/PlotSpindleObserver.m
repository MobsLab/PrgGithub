%PlotSpindleObserver

clear
%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
PFCdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
PFCsup=LFP;
clear LFP
clear channel
load ChannelsToAnalyse/PFCx_spindle
eval(['load LFPData/LFP',num2str(channel)])
PFCspindle=LFP;
clear LFP
clear channel

load StateEpochSB SWSEpoch

% params
spindle_frequency_range = [10 20];
fs = 1250;

%Spindles
lfp_signal = Data(PFCspindle);
[spindles_start_end, detected_spindles] = spindle_estimation_FHN2015(lfp_signal, fs, spindle_frequency_range);

spindles_tmp = spindles_start_end * 1E4 / 1250;
SpindlesEpoch = intervalSet(spindles_tmp(:,1), spindles_tmp(:,2));
SpindlesEpoch = and(SpindlesEpoch, SWSEpoch);


%% signals
signals{1} = [Range(PFCspindle,'ms')'/1000 ; Data(PFCdeep)'];
signals{2} = [Range(PFCsup,'ms')'/1000 ; Data(PFCsup)']; 
signals{3} = [Range(PFCdeep,'ms')'/1000 ; Data(PFCdeep)'];

spindles_start = Start(SpindlesEpoch) /1E4;
spindles_duration = (End(SpindlesEpoch) - Start(SpindlesEpoch)) / 1E4;

%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 4]);
for ch=1:sog.nb_channel
    sog.add_rectangles(spindles_start, spindles_duration, ch);
end
sog.set_time_events(spindles_start);
sog.set_title('PFC spindle', 1);
sog.set_title('PFC sup', 2);
sog.set_title('PFC deep', 3);

sog.set_ymin(1, -4000); sog.set_ymax(1, 4000);
sog.set_ymin(2, -4000); sog.set_ymax(2, 4000);
sog.set_ymin(3, -4000); sog.set_ymax(3, 4000);

sog.run_window





