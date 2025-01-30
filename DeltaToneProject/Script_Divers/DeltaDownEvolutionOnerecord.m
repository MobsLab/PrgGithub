%%DeltaDownEvolutionOnerecord

clear

%params
smoothing1 = 0;
interval_duration = 60; %in sec;


%% load
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
start_down = Start(Down);
%Delta waves
try
    load DeltaPFCx DeltaOffline
catch
    load newDeltaPFCx DeltaEpoch
    DeltaOffline = DeltaEpoch;
    clear DeltaEpoch
end
start_deltas = Start(DeltaOffline);

load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP

%% Data

%time intervals
duration_total = max(Range(LFPdeep)) * 1E-4; %in sec
timestamps = 0:interval_duration:duration_total; %1min intervals
nb_intervals = length(timestamps)-1;

%init
deltas_nb = zeros(nb_intervals, 1);
downs_nb = zeros(nb_intervals, 1);
for t=1:nb_intervals
    intv = intervalSet(timestamps(t)*1E4,timestamps(t+1)*1E4);
    deltas_nb(t) = length(Restrict(ts(start_deltas),intv));
    downs_nb(t) = length(Restrict(ts(start_down),intv));
end


deltas_density = Smooth(deltas_nb,smoothing1);
down_density = Smooth(downs_nb,smoothing1);
x = timestamps(1:end-1);

%% plot
figure, hold on

plot(x, deltas_density,'-','color', 'r', 'Linewidth', 2), hold on
plot(x, down_density,'-','color', 'k', 'Linewidth', 2), hold on

ylabel('deltas/down per sec');
xlabel('time');


