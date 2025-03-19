% DownPredictor_KJ

clear
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
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
tbefore = 1000; %time before down init, in E-4s
tafter = 1000; %time after down end
%Delta
minDeltaDuration = 50;
freqDelta=[1 5];
thresh_delta = 1;

coeffLim = 0.4;  % to detect delta associated with a down, even a little bit out of the down



%% LFP
% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;

%Diff
LFPdiff = tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup));
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
Filt_diff = Restrict(Filt_diff,SWSEpoch);
Filtpos_diff = tsd(Range(Filt_diff),max(Data(Filt_diff),0));
pos = Data(Filtpos_diff);
std_diff = std(pos(pos>0));

%Deep
EEGsleepDeep=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100); 
Filt_deep = FilterLFP(EEGsleepDeep, freqDelta, 1024);
Filt_deep = Restrict(Filt_deep,SWSEpoch);
Filtpos_deep = tsd(Range(Filt_deep),max(Data(Filt_deep),0));
pos = Data(Filtpos_deep);
std_deep = std(pos(pos>0));

%Sup
EEGsleepSup=ResampleTSD(tsd(Range(LFPsup),Data(LFPsup)),100); 
Filt_sup = FilterLFP(EEGsleepSup, freqDelta, 1024);
Filt_sup = Restrict(Filt_sup,SWSEpoch);
Filtpos_sup = tsd(Range(Filt_sup),max(-Data(Filt_sup),0));
pos = Data(Filtpos_sup);
std_sup = std(pos(pos>0));
clear pos


%Find Threshold crossing
DeltaDiff = thresholdIntervals(Filtpos_diff, thresh_delta*std_diff, 'Direction', 'Above');
DeltaDiff = dropShortIntervals(DeltaDiff,minDeltaDuration*10); % noise remove
nbDeltaDiff = length(Start(DeltaDiff));
deltaCenterDiff = Start(DeltaDiff) + (End(DeltaDiff) - Start(DeltaDiff))/2;  % in ts

DeltaDeep = thresholdIntervals(Filtpos_deep, thresh_delta*std_deep, 'Direction', 'Above');
DeltaDeep = dropShortIntervals(DeltaDeep,minDeltaDuration*10); % noise remove
nbDeltaDeep = length(Start(DeltaDeep));
deltaCenterDeep = Start(DeltaDeep) + (End(DeltaDeep) - Start(DeltaDeep))/2;  % in ts

DeltaSup = thresholdIntervals(Filtpos_sup, thresh_delta*std_sup, 'Direction', 'Above');
DeltaSup = dropShortIntervals(DeltaSup,minDeltaDuration*10); % noise remove
nbDeltaSup = length(Start(DeltaSup));
deltaCenterSup = Start(DeltaSup) + (End(DeltaSup) - Start(DeltaSup))/2;  % in ts


%% Find downstates
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
down_interval = [Start(Down) End(Down)];
down_durations = End(Down) - Start(Down);
large_down_intv = [down_interval(:,1)-down_durations*coeffLim down_interval(:,2)+down_durations*coeffLim];


%% Delta detected: signal

% create datasets
for i=1:nbDeltaDiff
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDeltaDiff = subset(DeltaDiff,i);
    signal_diff{i} = Restrict(LFPdiff,subDeltaDiff);
end
for i=1:nbDeltaDeep
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDeltaDeep = subset(DeltaDeep,i);
    signal_deep{i} = Restrict(LFPdeep,subDeltaDeep);
end
for i=1:nbDeltaSup
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDeltaSup = subset(DeltaSup,i);
    signal_sup{i} = Restrict(LFPsup,subDeltaSup);
end


%normalize signal for prediction
nb_points = 30;  % number of point in the interpolation
with_duration=1;  % one feature will be the the signal duration
norm_diff = cellfun(@(v)signalEpochNormalize(v, nb_points, with_duration), signal_diff, 'UniformOutput', false);
norm_deep = cellfun(@(v)signalEpochNormalize(v, nb_points, with_duration), signal_deep, 'UniformOutput', false);
norm_sup = cellfun(@(v)signalEpochNormalize(v, nb_points, with_duration), signal_sup, 'UniformOutput', false);

diffmat = zeros(nbDeltaDiff, nb_points+with_duration);
for i=1:nbDeltaDiff
    diffmat(i,:) = norm_diff{i};
end
deepmat = zeros(nbDeltaDeep, nb_points+with_duration);
for i=1:nbDeltaDeep
    deepmat(i,:) = norm_deep{i};
end
supmat = zeros(nbDeltaSup, nb_points+with_duration);
for i=1:nbDeltaSup
    supmat(i,:) = norm_sup{i};
end
sigmat = zeros(nbDown, 2*nb_points);
for i=1:nbDown
    sigmat(i,:) = [norm_sup{i}; norm_deep{i}];
end



%% Tree bagger

dataLFP = {diffmat, deepmat, supmat, sigmat};
deltaCenters = {deltaCenterDiff, deltaCenterDeep, deltaCenterSup};
titles = {'diffmat', 'deepmat', 'supmat','sup and deep'};


figure, hold on
for i=1:length(dataLFP)
    % True labels
    [status,interval,index] = InIntervals(deltaCenters{i}, large_down_intv);
    Y = status;  % response: 0 for no down and 1 for down
    X = dataLFP{i};
    cv = crossvalind('HoldOut', size(X,1), 0.7);
    Xtrain = X(~cv,:);
    Ytrain = Y(~cv,:);
    Xtest = X(cv,:);
    Ytest = Y(cv,:);

    big_rf = TreeBagger(200,Xtrain,Ytrain,'OOBVarImp','On');
    Yfit = predict(big_rf,Xtest);

    hold on, subplot(length(dataLFP),2,2*i-1), plot(oobError(big_rf))
    xlabel('Number of Grown Trees'), ylabel('Out-of-Bag Classification Error')
    title(titles{i})
    hold on, subplot(length(dataLFP),2,2*i), bar(big_rf.OOBPermutedVarDeltaError)
    xlabel('Feature Index'), ylabel('Out-of-Bag Feature Importance')
    
    CP{i} = classperf(Ytest, str2num(cell2mat(Yfit)));
end


 









