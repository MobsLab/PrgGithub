% makeToneEventsDigin_KJ
% 29.05.2019 KJ
%
% generate Tones from DigitalIn
%
% Info
%   see 
%       makeToneEvents_KJ


%thresh
thresh = 0.1;

%% DigitalIn
load('LFPData/InfoLFP.mat')
channel_dig = InfoLFP.channel(strcmpi(InfoLFP.structure,'Digin'));
load(fullfile('LFPData',['LFP' num2str(channel_dig) '.mat']))
DigitalIn = LFP;
clear LFP

%digital in data - input from the speaker 
x = Range(DigitalIn);
ysmooth = abs(Smooth(Data(DigitalIn),15));

%peaks
xmax = findpeaks(ysmooth,thresh);
peak_idx = xmax.loc; 
xpeaks = x(peak_idx);

% cleaning
doublons = find(diff(xpeaks)<2000)+1; %<200ms
peak_idx(doublons)=[];
xpeaks = x(peak_idx);

%value of peaks
ypeaks = ysmooth(peak_idx);

%sound start
x_befpeaks = x(ysmooth>thresh/2&ysmooth<thresh);
for i=1:length(xpeaks)
    x_tones(i) = x_befpeaks(find(x_befpeaks<xpeaks(i),1,'last'));
end

ToneDiginDetect = tsd(x_tones,ypeaks);


%% Save in DeltaSleepEvent and DeltabehavRessources

try
    save DeltaSleepEvent -append ToneDiginDetect
catch
    save DeltaSleepEvent ToneDiginDetect
end

ToneEvent = ts(Range(ToneDiginDetect));
save behavResources.mat -append ToneEvent

%% Events
load('behavResources.mat', 'ToneEvent')
evt.time = Range(ToneEvent)/1E4;
for i=1:length(evt.time)
    evt.description{i}='tones';
end
CreateEvent(evt,'tones','ton')







