
clear
load('DeltaSleepEvent.mat')

delay = 0.14*1e4;

if exist('delay','var') && exist('TONEtime2','var')
    delay_arduino = delay;
    ToneEvent = ts(TONEtime2+delay);
    save behavResources.mat -append ToneEvent delay_arduino
elseif exist('delay','var') && exist('TONEtime1','var')
    delay_arduino = delay;
    ToneEvent = ts(TONEtime1+400+delay);
    save behavResources.mat -append ToneEvent delay_arduino
end
    
%% Events
load('behavResources.mat', 'ToneEvent')
evt.time = Range(ToneEvent)/1E4;
for i=1:length(evt.time)
    evt.description{i}='tones';
end
CreateEvent(evt,'tones','ton')



deltas_PFCx = GetDeltaWaves;
load('behavResources.mat', 'ToneEvent')
edges = 0:200:20000;
[x_isi, y_isi] = ISIcurves_KJ(ToneEvent,edges);
figure, plot(x_isi/1000, y_isi)
[C,B] = CrossCorr(Range(ToneEvent), Start(deltas_PFCx), 10,400);
figure, plot(B,C)
title(pwd)

