%PlotShamVsToneObserver

%GUI that shows tones and their effect on delta
clear
%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP channel
try
    load ChannelsToAnalyse/PFCx_sup 
catch 
    load ChannelsToAnalyse/PFCx_deltasup
end
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP channel
load StateEpochSB SWSEpoch

load DeltaSleepEvent TONEtime2
delay = 1400;
tones = ts(TONEtime2 + delay);  % real tones
load ShamSleepEvent
shams = ts(Range(SHAMtime) + delay);  % shams with delay


%% signals
LFPdiff = tsd(Range(LFPsup), Data(LFPdeep) - Data(LFPsup));
tones_start = Range(tones,'ms') / 1000;
sham_start = Range(shams,'ms') / 1000;

signals{1} = [Range(LFPsup,'ms')'/1000 ; Data(LFPsup)']; 
signals{2} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
signals{3} = [Range(LFPdiff','ms')'/1000 ; Data(LFPdiff)'];

all_events = sort([tones_start;sham_start]);

%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.add_verticals(tones_start', ch, 'b')
    sog.add_verticals(sham_start', ch, 'r')
end
sog.set_time_events(all_events');
sog.set_title('LFP sup', 1);
sog.set_title('LFP deep', 2);
sog.set_title(['LFP diff'], 3);

sog.set_ymin(1, -2000); sog.set_ymax(1, 2000);
sog.set_ymin(2, -2000); sog.set_ymax(2, 2000);
sog.set_ymin(3, -2000); sog.set_ymax(3, 2000);

sog.run_window
