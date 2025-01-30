% AnalysisLayersPFCDown
% 18.10.2017 KJ
%
% Look at the LAYERS features of the LFP of the PFCx during Down states
%
%
%


clear

%params
window_after = 0.1E4;
thresh_duration = 1200; %120ms
nb_evt = 500;

%params
t_before = -2E4; %in 1E-4s
t_after = 2E4; %in 1E-4s


%channels = [32 34 36 38 58 59 60 61 62 63]; %244
channels = [0 3 5 7 25 26 27 29 31]; %243



%% Load data
%LFP
for i=1:length(channels)
    ch = channels(i);
    eval(['load LFPData/LFP',num2str(ch)])
    PFC{i} = LFP;
    clear LFP
end

%Stages
load StateEpochSB SWSEpoch


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
Down = and(Down,SWSEpoch);
down_durations = End(Down) - Start(Down);
start_down = Start(Down);

% %choose randomly n events, that are longer than threshold duration
% idx_down = find(down_durations>thresh_duration);
% idx_down = sort(idx_down(randperm(length(idx_down),nb_evt)));
% 
% DownChoosen = [Start(Down) End(Down)];
% DownChoosen = intervalSet(DownChoosen(idx_down,1),DownChoosen(idx_down,2));
% DownChoosen_more = intervalSet(Start(DownChoosen), End(DownChoosen) + window_after);
% 
% 


%% 


%% durations

stdown{1} = start_down(down_durations==0.1E4);
label_down{1} = '100ms';
stdown{2} = start_down(down_durations==0.12E4);
label_down{2} = '120ms';
stdown{3} = start_down(down_durations>0.13E4 & down_durations<0.17E4);
label_down{3} = '130-170ms';
stdown{4} = start_down(down_durations>0.19E4 & down_durations<0.23E4);
label_down{4} = '190-230ms';
stdown{5} = start_down(down_durations>0.25E4 & down_durations<0.29E4);
label_down{5} = '250-290ms';
stdown{6} = start_down(down_durations>0.3E4);
label_down{6} = '>300ms';


%% PETH
for i=1:length(stdown)
    for ch=1:length(channels)
        pfc.down{ch,i} = PlotRipRaw(PFC{ch},stdown{i}/1E4, 1000,0,0);
    end
end

for i=1:length(stdown)
    for ch=1:length(channels)
        peak_value(ch,i) = max(pfc.down{ch,i}(:,2));
    end
end


%% Plot
for i=1:length(stdown)
    figure, hold on
    for ch=1:length(channels)
        plot(pfc.down{ch,i}(:,1), pfc.down{ch,i}(:,2)), hold on
    end
    title([label_down{i} ' (' num2str(length(stdown{i})) ' down)']), legend(cellstr(num2str(channels')))
end





