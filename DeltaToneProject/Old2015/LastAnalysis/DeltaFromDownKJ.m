
% Input
%
% S: Spikes
% NumNeurons: cells to select
% SWSEpoch
% binsize: bin size for MUA computation
% minDownDuration: minimum duration to classify as a downstate
% thresh: value of the threshold to cross to detect a downstate
% thresh_mode: firing rate(1), mean rate percent(2), max rate percent(3)
% LFPsup
% LFPdeep

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
thresh = 0.08;
thresh_mode = 3;
minDownDuration = 50;
%Delta
minDeltaDuration = 75;
freqDelta=[1 5];
thD = 2;

%%%%%%%%%%%%%%%%%%%
% Find deltas
%%%%%%%%%%%%%%%%%%%
% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
% Difference between EEG deep and EEG sup (*factor)
EEGsleepD=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100); 

Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
Filt_EEGd = Restrict(Filt_EEGd,SWSEpoch);
abs_lfpdiff_value = max(Data(Filt_EEGd),0);
thresh_delta = thD * std(abs_lfpdiff_value(abs_lfpdiff_value>0));

all_cross_thresh=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,SWSEpoch)), abs_lfpdiff_value),thresh_delta,'Direction','Above');
DeltaEpoch=dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
tDelta=Start(DeltaEpoch)+(End(DeltaEpoch)-Start(DeltaEpoch))/2;
DurDelta=tsd(Start(DeltaEpoch),End(DeltaEpoch,'ms') - Start(DeltaEpoch,'ms'));
DurDelta=Restrict(DurDelta, SWSEpoch);
nbDelta = length(tDelta);


%%%%%%%%%%%%%%%%%%%
% Find downstates
%%%%%%%%%%%%%%%%%%%
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s

if thresh_mode==2  % percentage of mean rate
    thresh = thresh * mean(full(Data(Q)));
elseif thresh_mode==3  % max of mean rate
    thresh = thresh * max(full(Data(Q)));
end

%Down
Down = thresholdIntervals(Q,thresh,'Direction','Below');
Down = dropShortIntervals(Down, minDownDuration * 10);
tDown =Start(Down)+(End(Down)-Start(Down))/2;
DurDown=tsd(Start(Down),End(Down,'ms') - Start(Down,'ms'));
DurDown=Restrict(DurDown, SWSEpoch);
nbDown = length(tDown);


%%%%%%%%%%%%%%%%%%%
% Matching delta and downstates
%%%%%%%%%%%%%%%%%%%
down_interval = [Start(Down) End(Down)];
delta_interval = [Start(DeltaEpoch) End(DeltaEpoch)];
[status,interval,index] = InIntervals(tDelta,down_interval);
newDeltaInterval = intervalSet([Start(DeltaEpoch)-800 End(DeltaEpoch) + 800]); 

nb_ok = sum(status);
nb_points = 50;
new_points = linspace(0, 1, nb_points);
new_deepDown = zeros(nb_ok, nb_points);
new_supDown = zeros(nb_ok, nb_points);
matching_down = zeros(nb_ok,2);

%Rescale
for i=1:1000
    if status(i)>0
        matching_down(i,:) = down_interval(interval(i));
        subDelta = subset(newDeltaInterval, i);
        deepCurve = Data(Restrict(LFPdeep, subDelta));
        x = linspace(0, 1, length(deepCurve));
        new_deepDown(i,:) = interp1(x, deepCurve, new_points);
        supCurve = Data(Restrict(LFPsup, subDelta));
        x = linspace(0, 1, length(supCurve));
        new_supDown(i,:) = interp1(x, supCurve, new_points);

    end
    
end

%Matching
new_delta_interval = delta_interval(interval>0,:);
new_down_interval = down_interval(interval(interval>0),:);


%%%%%%%%%%%%%%%%%%%
% Plot Mean signal
%%%%%%%%%%%%%%%%%%%

%plot 
mean_deep = mean(new_deepDown,1);
std_deep = std(new_deepDown,1);
meanPlusStd_deep = mean_deep + std_deep;
meanMinusStd_deep = mean_deep - std_deep;

mean_sup = mean(new_supDown,1);
std_sup = std(new_supDown,1);
meanPlusStd_sup = mean_sup + std_sup;
meanMinusStd_sup = mean_sup - std_sup;

figure, hold on
x = new_points;
subplot(1,2,1)
hold on, plot(x, mean_deep, 'r','linewidth',2)
hold on, fill([x fliplr(x)], [meanPlusStd_deep fliplr(meanMinusStd_deep)], 'r');
alpha(.25);
subplot(1,2,2)
hold on, plot(x, mean_sup, 'k','linewidth',2)
hold on, fill([x fliplr(x)], [meanPlusStd_sup fliplr(meanMinusStd_sup)], 'k');
alpha(.25);


%%%%%%%%%%%%%%%%%%%
% Scatter plot duration
%%%%%%%%%%%%%%%%%%%

%DurDelta & DurDown
%interval
delta_duration = (new_delta_interval(:,2) - new_delta_interval(:,1))';
down_duration = (new_down_interval(:,2) - new_down_interval(:,1))';
scatter(new_down_durations/10,new_delta_durations/10,'filled');


%%%%%%%%%%%%%%%%%%%
% Subplot of delta by duration 
%%%%%%%%%%%%%%%%%%%
EEGsleepD=tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup));
deltasDur = delta_duration;
downsDur = down_duration;
range_dur = [0 120 170 220 270 400 700];
figure, hold on
for i=1:length(range_dur)-1
    durMin = range_dur(i)*10;
    durMax = range_dur(i+1)*10;
    deltaToplot = new_delta_interval(downsDur>durMin & downsDur<durMax,:);
    subplot(2,3,i),hold on
    for j=1:size(deltaToplot,1)
        currentDelta = deltaToplot(j,:);
        subset = intervalSet(currentDelta(1)-2000,currentDelta(2)+2000);
        curve = Restrict(EEGsleepD, subset);
        x = Range(curve,'ms');
        x = x -x(1);
        hold on, plot(x, Data(curve))
    end
    

end






