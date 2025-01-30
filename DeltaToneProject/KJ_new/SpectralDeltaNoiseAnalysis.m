%SpectralDeltaNoiseAnalysis

clear 
%load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch Wake
clear number

StartInterval = intervalSet(3600*1E4,5000*1E4); % first hour interval
SigSup = Restrict(LFPsup,StartInterval);
SigDeep = Restrict(LFPdeep,StartInterval);

%% detection of delta waves
minDeltaDuration = 75;
freqDelta=[1 5];
thD = 2;
tlarge = 1000;

%diff between deep and sup
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(SigDeep)-i*Data(SigSup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGsleepDiff=ResampleTSD(tsd(Range(SigDeep),Data(SigDeep) - Factor*Data(SigSup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

%threshold crossing
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
large_deltas = [Start(DeltaOffline)-tlarge, End(DeltaOffline)+tlarge];


%% Replacement of delta with white noise
x_signal = Range(SigSup);
y_signal = Data(SigSup);

for i=1:length(large_deltas)
    x_part = find(x_signal>large_deltas(i,1) & x_signal<large_deltas(i,2));
    y_signal(x_part) = randn(length(x_part),1);
end


%% Plot
figure, hold on,
[spectrum,~,f] = MTSpectrum(y_signal,'frequency',1250, 'range',[0 20]);
subplot(1,2,1),hold on, plot(f,spectrum), ylim([0 12E4]), title('Modified with white noise')
[spectrum,~,f] = MTSpectrum(Data(SigSup),'frequency',1250, 'range',[0 20]);
subplot(1,2,2),hold on, plot(f,spectrum), ylim([0 12E4]), title('Original')












