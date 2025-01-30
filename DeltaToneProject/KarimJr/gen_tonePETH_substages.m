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
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

% tones
load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
nb_tones = length(TONEtime2_SWS);
delay = 2000; %in 1E-4s
ToneEvent = Restrict(ts(TONEtime2_SWS + delay),SWSEpoch);

%Substages
clear op NamesOp Dpfc Epoch noise
try
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    op; disp('Loading epochs from NREMepochsML.m')
catch
    [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
    disp('saving in NREMepochsML.mat')
    save NREMepochsML.mat op NamesOp Dpfc Epoch noise
end
[Substages,NamesSubstages]=DefineSubStages(op,noise);
%N1=Substages{1}; N2=Substages{2}; N3=Substages{3}; REM=Substages{4}; WAKE=Substages{5}; SWS=Substages{6}; swaOB=Substages{8};

%params
freqDelta = [1 6];
thD = 2;
thDeep = 2.4;
minDeltaDuration = 50;

t_before = -30000; %in 1E-4s
t_after = 20000; %in 1E-4s


%% Multi-Unit activity
binsize=10;
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s


%% Signals
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

%% deltas
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
deltas_tmp = Start(DeltaOffline) + (End(DeltaOffline)-Start(DeltaOffline)) / 2;

% For each substage
for ep=1:5
    SubTones = Restrict(ToneEvent, Substages{ep});
    tones_sub = Range(SubTones);
    nb_tones_sub = length(tones_sub);
    last_delta_tone = zeros(nb_tones_sub, 1);
        for i=1:nb_tones_sub
            idx_delta_before = find(deltas_tmp < tones_sub(i), 1, 'last');
            last_delta_tone(i) = tones_sub(i) - deltas_tmp(idx_delta_before);
        end
    [delay_delta_sort, idx_delta_sort] = sort(last_delta_tone, 'ascend');

    figure, hold on, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(Q, SubTones, idx_delta_sort, t_before, t_after);
    hold on, title(['MUA tone ' NamesSubstages{ep}])
    figure, hold on, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(EEGsleepDiff, SubTones, idx_delta_sort, t_before, t_after);
    hold on, title(['LFP tone ' NamesSubstages{ep}])
    
end











