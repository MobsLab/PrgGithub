%MeanDeltaCurves_KJ

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
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Args
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 800;
mergeGap = 10; % duration max to allow a merge of silence period
predown_size = 30; % minimum duration for a predown, that can be merged in a 2nd step

durAverage = 7000;  % 700ms

%Find Down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize);
Q = Restrict(Q, SWSEpoch);
Down = FindDown2_KJ(Q, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
%durations
down_durations = End(Down,'ms') - Start(Down,'ms');
%transition time
updown_tmp = Start(Down);
downup_tmp = End(Down);
%nbDown = length(updown_tmp);
nbDown = 3000;

%get signals
rg_deep = Range(LFPdeep);
data_deep = Data(LFPdeep);
rg_sup = Range(LFPsup);
data_sup = Data(LFPsup);
lenData = length(data_deep(rg_deep>=updown_tmp(10) - durAverage & rg_deep<=updown_tmp(10)+durAverage));

updown_deep = zeros(nbDown, lenData);
downup_deep = zeros(nbDown, lenData);
updown_sup = zeros(nbDown, lenData);
downup_sup = zeros(nbDown, lenData);

for i=1:nbDown
    if mod(i,1000)==0
        disp(num2str(i))
    end
    try
        updown_deep(i,:) = data_deep(rg_deep>=updown_tmp(i) - durAverage & rg_deep<=updown_tmp(i)+durAverage);
        updown_sup(i,:) = data_sup(rg_sup>=updown_tmp(i) - durAverage & rg_sup<=updown_tmp(i)+durAverage);
        downup_deep(i,:) = data_deep(rg_deep>=downup_tmp(i) - durAverage & rg_deep<=downup_tmp(i)+durAverage);
        downup_sup(i,:) = data_sup(rg_sup>=downup_tmp(i) - durAverage & rg_sup<=downup_tmp(i)+durAverage);
    end
    
end


%% percentiles
highLim = prctile(down_durations(1:nbDown), 75);
lowLim = prctile(down_durations(1:nbDown), 25);
middleLim = prctile(down_durations(1:nbDown), 50);

shortDur = down_durations(1:nbDown)<lowLim;
midshortDur = down_durations(1:nbDown)>lowLim & down_durations(1:nbDown)<middleLim;
midlongDur = down_durations(1:nbDown)>middleLim & down_durations(1:nbDown)<highLim;
longDur = down_durations(1:nbDown)>highLim;

updown_deep_short = mean(updown_deep(shortDur,:));
updown_deep_midshort = mean(updown_deep(midshortDur,:));
updown_deep_midlong = mean(updown_deep(midlongDur,:));
updown_deep_long = mean(updown_deep(longDur,:));

updown_sup_short = mean(updown_sup(shortDur,:));
updown_sup_midshort = mean(updown_sup(midshortDur,:));
updown_sup_midlong = mean(updown_sup(midlongDur,:));
updown_sup_long = mean(updown_sup(longDur,:));

downup_deep_short = mean(downup_deep(shortDur,:));
downup_deep_midshort = mean(downup_deep(midshortDur,:));
downup_deep_midlong = mean(downup_deep(midlongDur,:));
downup_deep_long = mean(downup_deep(longDur,:));

downup_sup_short = mean(downup_sup(shortDur,:));
downup_sup_midshort = mean(downup_sup(midshortDur,:));
downup_sup_midlong = mean(downup_sup(midlongDur,:));
downup_sup_long = mean(downup_sup(longDur,:));


%% plot
tmp = linspace(-durAverage/10, durAverage/10, lenData);
figure,
hold on, subplot(2,2,1)
hold on, plot(tmp, updown_deep_short,'b')
hold on, plot(tmp, updown_deep_midshort,'g')
hold on, plot(tmp, updown_deep_midlong,'r')
hold on, plot(tmp, updown_deep_long,'k')
hold on, plot([0 0],get(gca,'ylim'), 'b')
hold on, xlabel('time (ms)')
hold on, ylabel('amplitude LFP')
title('up>Down - Deep')

hold on, subplot(2,2,2)
hold on, plot(tmp, updown_sup_short,'b')
hold on, plot(tmp, updown_sup_midshort,'g')
hold on, plot(tmp, updown_sup_midlong,'r')
hold on, plot(tmp, updown_sup_long,'k')
hold on, plot([0 0],get(gca,'ylim'), 'b')
hold on, xlabel('time (ms)')
hold on, ylabel('amplitude LFP')
title('up>Down - Sup')

hold on, subplot(2,2,3)
hold on, plot(tmp, downup_deep_short,'b')
hold on, plot(tmp, downup_deep_midshort,'g')
hold on, plot(tmp, downup_deep_midlong,'r')
hold on, plot(tmp, downup_deep_long,'k')
hold on, plot([0 0],get(gca,'ylim'), 'b')
hold on, xlabel('time (ms)')
hold on, ylabel('amplitude LFP')
title('down>Up - Deep')

hold on, subplot(2,2,4)
hold on, plot(tmp, downup_sup_short,'b')
hold on, plot(tmp, downup_sup_midshort,'g')
hold on, plot(tmp, downup_sup_midlong,'r')
hold on, plot(tmp, downup_sup_long,'k')
hold on, plot([0 0],get(gca,'ylim'), 'b')
hold on, xlabel('time (ms)')
hold on, ylabel('amplitude LFP')
title('down>Up - Sup')








