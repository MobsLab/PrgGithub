%AmplitudeDownDur_KJ
% S: Spikes
% NumNeurons: cells to select
% SWSEpoch
% binsize: bin size for MUA computation
% minDownDuration: minimum duration to classify as a downstate
% thresh: value of the threshold to cross to detect a downstate
% thresh_mode: almost zero (0), firing rate(1), mean rate percent(2), max rate percent(3)
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
thresh0 = 0.7;
minDownDur = 75;
maxDownDur = 500;
mergeGap = 10; % duration max to allow a merge of silence period
predown_size = 50;
tbefore = 500; %time before down init, in E-4s
tafter = 500; %time after down end
%Delta
minDeltaDuration = 75;
freqDelta=[1 5];

%%%%%%%%%%%%%%%%%%%
% LFP
%%%%%%%%%%%%%%%%%%%
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

%Deep
EEGsleepDeep=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100); 
Filt_deep = FilterLFP(EEGsleepDeep, freqDelta, 1024);
Filt_deep = Restrict(Filt_deep,SWSEpoch);

%Sup
EEGsleepSup=ResampleTSD(tsd(Range(LFPsup),Data(LFPsup)),100); 
Filt_sup = FilterLFP(EEGsleepSup, freqDelta, 1024);
Filt_sup = Restrict(Filt_sup,SWSEpoch);

%%%%%%%%%%%%%%%%%%%
% Find downstates
%%%%%%%%%%%%%%%%%%%
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Qsws = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
down_interval = [Start(Down) End(Down)];
down_durations = down_interval(:,2) - down_interval(:,1);
largeDown = intervalSet(Start(Down)-tbefore, End(Down)+tafter);

%nbDown = size(down_interval,1);
nbDown = 5000;

%Restrict Signal around downstates
for i=1:nbDown
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDown = subset(largeDown,i);
    signal_diff{i} = Data(Restrict(Filt_diff,subDown));
    signal_deep{i} = Data(Restrict(Filt_deep,subDown));
    signal_sup{i} = Data(Restrict(Filt_sup,subDown));
end

signalpos_diff = cellfun(@(v)max(v,0),signal_diff,'UniformOutput', false);
signalpos_deep = cellfun(@(v)max(v,0),signal_deep,'UniformOutput', false);
signalpos_sup = cellfun(@(v)max(v,0),signal_sup,'UniformOutput', false);

mean_amp_diff = cellfun(@mean, signalpos_diff);
mean_amp_deep = cellfun(@mean, signalpos_deep);
mean_amp_sup = cellfun(@mean, signalpos_sup);

max_amp_diff = cellfun(@max, signalpos_diff);
max_amp_deep = cellfun(@max, signalpos_deep);
max_amp_sup = cellfun(@max, signalpos_sup);

%scatter plot
downDur = down_durations(1:nbDown)' / 10;

figure, hold on
subplot(2,3,1),hold on
scatter(downDur, mean_amp_diff, 'filled')
xlabel('Down duration')
ylabel('Mean delta amplitude')
title('Diff')
subplot(2,3,4),hold on
scatter(downDur, max_amp_diff, 'filled')
xlabel('Down duration')
ylabel('Max delta amplitude')

subplot(2,3,2),hold on
scatter(downDur, mean_amp_deep, 'filled')
xlabel('Down duration')
ylabel('Mean delta amplitude')
title('Deep')
subplot(2,3,5),hold on
scatter(downDur, max_amp_deep, 'filled')
xlabel('Down duration')
ylabel('Max delta amplitude')

subplot(2,3,3),hold on
xlabel('Down duration')
ylabel('Mean delta amplitude')
title('Sup')
scatter(downDur, mean_amp_sup, 'filled')
subplot(2,3,6),hold on
scatter(downDur, max_amp_sup, 'filled')
xlabel('Down duration')
ylabel('Max delta amplitude')


%density plot
figure, hold on
subplot(2,3,1),hold on
[values, center] = hist3([ mean_amp_diff' downDur'], {0:25:1200 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Mean delta amplitude')
xlim([0 1200]), ylim([0 700]9mar)
title('Diff')

subplot(2,3,4),hold on
[values, center] = hist3([ max_amp_diff' downDur'], {0:25:3500 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Max delta amplitude')
xlim([0 3500]), ylim([0 700])

subplot(2,3,2),hold on
[values, center] = hist3([ mean_amp_deep' downDur'], {0:25:1200 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Mean delta amplitude')
xlim([0 1200]), ylim([0 700])

title('Deep')

subplot(2,3,5),hold on
[values, center] = hist3([ max_amp_deep' downDur'], {0:25:3500 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Max delta amplitude')
xlim([0 3500]), ylim([0 700])

subplot(2,3,3),hold on
[values, center] = hist3([ mean_amp_sup' downDur'], {0:25:1200 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Mean delta amplitude')
xlim([0 1200]), ylim([0 700])
title('Sup')

subplot(2,3,6),hold on
[values, center] = hist3([ max_amp_sup' downDur'], {0:25:3500 0:25:700});
imagesc(center{1}, center{2}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Max delta amplitude')
xlim([0 3500]), ylim([0 700])




