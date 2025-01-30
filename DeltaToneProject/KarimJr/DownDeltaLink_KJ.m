% DownDeltaLink_KJ

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

% params
binsize=10;
thresh0 = 0.9;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
tbefore = 500; %time before down init, in E-4s
tafter = 500; %time after down end
%Delta
minDeltaDuration = 50;
freqDelta=[1 5];

%% LFP
% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;

%Diff
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
Filt_diff = Restrict(Filt_diff,SWSEpoch);
Filt_diff = tsd(Range(Filt_diff),max(Data(Filt_diff),0));
pos = Data(Filt_diff);
std_diff = std(pos(pos>0));

%Deep
EEGsleepDeep=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100); 
Filt_deep = FilterLFP(EEGsleepDeep, freqDelta, 1024);
Filt_deep = Restrict(Filt_deep,SWSEpoch);
Filt_deep = tsd(Range(Filt_deep),max(Data(Filt_deep),0));
pos = Data(Filt_deep);
std_deep = std(pos(pos>0));

%Sup
EEGsleepSup=ResampleTSD(tsd(Range(LFPsup),Data(LFPsup)),100); 
Filt_sup = FilterLFP(EEGsleepSup, freqDelta, 1024);
Filt_sup = Restrict(Filt_sup,SWSEpoch);
Filt_sup = tsd(Range(Filt_sup),max(-Data(Filt_sup),0));
pos = Data(Filt_sup);
std_sup = std(pos(pos>0));

clear pos


%% Find downstates
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
down_interval = [Start(Down) End(Down)];
down_durations = End(Down) - Start(Down);
largeDown = intervalSet(Start(Down)-tbefore,End(Down)+tafter);


%% Extract data

%nbDown = size(down_interval,1);
nbDown = 5000;

for i=1:nbDown
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDown = subset(largeDown,i);
    signal_diff{i} = Restrict(Filt_diff,subDown);
    signal_deep{i} = Restrict(Filt_deep,subDown);
    signal_sup{i} = Restrict(Filt_sup,subDown);
end

amplitude_diff = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_diff);
amplitude_deep = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_deep);
amplitude_sup = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_sup);

amplitude_diff = amplitude_diff / std_diff;
amplitude_deep = amplitude_deep / std_deep;
amplitude_sup = amplitude_sup / std_sup;


%% plot
downDur = down_durations(1:nbDown)' / 10;

%Correlation
[r_diff, p_diff] = corrcoef(downDur, amplitude_diff);
r_diff = r_diff(1,2);
p_diff = p_diff(1,2);
[r_deep, p_deep] = corrcoef(downDur, amplitude_deep);
r_deep = r_deep(1,2);
p_deep = p_deep(1,2);
[r_sup, p_sup] = corrcoef(downDur, amplitude_sup);
r_sup = r_sup(1,2);
p_sup = p_sup(1,2);
%fit
poly_diff = polyfit(downDur, amplitude_diff,1);
y_diff = polyval(poly_diff,downDur);
poly_deep = polyfit(downDur, amplitude_diff,1);
y_deep = polyval(poly_deep,downDur);
poly_sup = polyfit(downDur, amplitude_diff,1);
y_sup = polyval(poly_sup,downDur);

%scatter plot
figure, hold on
subplot(2,3,1),hold on
scatter(downDur, amplitude_diff, '*')
hold on,plot(downDur, y_diff)
text(500,6,['R=' num2str(r_diff)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Diff')

subplot(2,3,2),hold on
scatter(downDur, amplitude_deep, '*')
hold on,plot(downDur, y_deep)
text(500,6,['R=' num2str(r_deep)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Deep')

subplot(2,3,3),hold on
scatter(downDur, amplitude_sup, '*')
hold on,plot(downDur, y_sup)
text(500,6,['R=' num2str(r_sup)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Sup')
hold on,

%density plot
subplot(2,3,4),hold on
[values, center] = hist3([amplitude_diff' downDur'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Diff')

subplot(2,3,5),hold on
[values, center] = hist3([amplitude_deep' downDur'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Deep')

subplot(2,3,6),hold on
[values, center] = hist3([amplitude_sup' downDur'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Sup')


