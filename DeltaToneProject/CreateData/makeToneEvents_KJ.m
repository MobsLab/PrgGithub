% makeToneEvents_KJ
% 09.03.2018 KJ
%
% generate behavRessources variables
%
% Info
%   see 
%



%% params
sessionDelta = [2 4];
all_sessions = 1:5;
delay = 0.49*1e4;

filelist = dir('*.xml');
for i=1:length(filelist)
    if ~contains(filelist(i).name, 'SpikeRef') && ~contains(filelist(i).name, 'SubRef')
       xml_file = filelist(i).name; 
    end
end
basename = xml_file(1:end-4);
try
    load behavResources.mat tpsdeb
    tpsdeb;
catch
    load('behavResources.mat', 'tpsCatEvt')
    tpsdeb = tpsCatEvt(1:2:length(tpsCatEvt));
end

foldername1=pwd;
cd('..')
foldername2=pwd;

%% Detection with triggered tone

%Tonetime1
TONEtime1 = [];
for i=1:length(sessionDelta)
    s = sessionDelta(i);
    %fires
    try
        load(fullfile(foldername2,'Info', [basename '-0' num2str(s) '-DeltaSleep-fires_matrix']));
        TONEtime1 = [TONEtime1 ; fires(:,1)+tpsdeb{s}*1E4];
    end
end

%Tonetime2
TONEtime2 = [];
for i=1:length(sessionDelta)
    s = sessionDelta(i);
    %fires actual
    try
        load(fullfile(foldername2,'Info', [basename '-0' num2str(s) '-DeltaSleep-fires_actual_time']));
        TONEtime2 = [TONEtime2 ; fires_actual_time(:,1)+tpsdeb{s}*1E4];
    end
end


%% Detection for non Stim sessions
DeltaDetect = [];
for i=1:length(all_sessions)
    s = all_sessions(i);
    try
        if ismember(i,sessionDelta)
            load(fullfile(foldername2,'Info', [basename '-0' num2str(i) '-DeltaSleep-detections_matrix']));
        else
            load(fullfile(foldername2,'Info', [basename '-0' num2str(i) '-Sleep-detections_matrix']));
        end

        DeltaDetect = [DeltaDetect ; detections(:,1)+tpsdeb{i}*1E4];
    end
end


cd(foldername1)

%%  Restrit DeltaDetect to remove delta followed by tone
[~, idx, ~] = intersect(DeltaDetect, TONEtime1);
DeltaDetect(idx) = [];

save DeltaSleepEvent DeltaDetect TONEtime1 
% if exist('TONEtime2','var')
if ~isempty(TONEtime2)
    save DeltaSleepEvent -append TONEtime2
end

if exist('delay','var') && exist('TONEtime2','var')
    delay_arduino = delay;
    ToneEvent = ts(TONEtime2+delay);
    save behavResources.mat -append ToneEvent delay_arduino
end

%% Events
load('behavResources.mat', 'ToneEvent')
evt.time = Range(ToneEvent)/1E4;
for i=1:length(evt.time)
    evt.description{i}='tones';
end
CreateEvent(evt,'tones','ton')







