%FiringUpDownTransition_KJ

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
windowFiring = 100 * 10; %window where the firing rate is assessed

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
nbDown = 5000;

%get firing rate
rg = Range(Q);
dataQ = full(Data(Q));

updown_rate = zeros(1,nbDown);
downup_rate = zeros(1,nbDown);

for i=1:nbDown
    if mod(i,200)==0
        disp(num2str(i))
    end

    updown_rate(i) = mean(dataQ(rg>=updown_tmp(i)-windowFiring & rg<=updown_tmp(i)));
    downup_rate(i) = mean(dataQ(rg>=downup_tmp(i) & rg<=downup_tmp(i)+windowFiring));
end


%% percentiles
highLim = prctile(down_durations(1:nbDown), 75);
lowLim = prctile(down_durations(1:nbDown), 25);
middleLim = prctile(down_durations(1:nbDown), 50);

shortDur = down_durations(1:nbDown)<lowLim;
midshortDur = down_durations(1:nbDown)>lowLim & down_durations(1:nbDown)<middleLim;
midlongDur = down_durations(1:nbDown)>middleLim & down_durations(1:nbDown)<highLim;
longDur = down_durations(1:nbDown)>highLim;

updown_short = updown_rate(shortDur);
updown_midshort = updown_rate(midshortDur);
updown_midlong = updown_rate(midlongDur);
updown_long = updown_rate(longDur);

downup_short = downup_rate(shortDur);
downup_midshort = downup_rate(midshortDur);
downup_midlong = downup_rate(midlongDur);
downup_long = downup_rate(longDur);


%% plot

figure,
hold on, subplot(1,2,1)
hold on, scatter(down_durations(1:nbDown), updown_rate, '+')
hold on, subplot(1,2,2)
hold on, scatter(down_durations(1:nbDown), downup_rate, '+')
hold off

bins = 0.05:0.1:0.75;
figure, 
hold on, subplot(1,2,1)
[c, b] = hist(updown_short, bins);
hold on, plot(b,c)
[c, b] = hist(updown_midshort, bins);
hold on, plot(b,c)
[c, b] = hist(updown_midlong, bins);
hold on, plot(b,c)
[c, b] = hist(updown_long, bins);
hold on, plot(b,c)
hold on, subplot(1,2,2)
[c, b] = hist(downup_short, bins);
hold on, plot(b,c)
[c, b] = hist(downup_midshort, bins);
hold on, plot(b,c)
[c, b] = hist(downup_midlong, bins);
hold on, plot(b,c)
[c, b] = hist(downup_long, bins);
hold on, plot(b,c)






