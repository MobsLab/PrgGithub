% Multilayer_analysis_KJ

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
load ChannelsToAnalyse/PFCx_middle
eval(['load LFPData/LFP',num2str(channel)])
LFPmid=LFP;
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
down_durations = End(Down,'ms') - Start(Down,'ms');
large_down_intv = [down_interval(:,1)-down_durations*coeffLim down_interval(:,2)+down_durations*coeffLim];
largeDown = intervalSet(large_down_intv(:,1), large_down_intv(:,2));


%% LFP
% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPmid));
    k=k+1;
end
Factor_deepmid=find(distance==min(distance))*0.1;


k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPmid)-i*Data(LFPsup));
    k=k+1;
end
Factor_midsup=find(distance==min(distance))*0.1;


%restrict
nbDown = size(down_durations,1);
for i=1:nbDown
    if mod(i,1000)==0
        disp(num2str(i))
    end
    subDownup = subset(largeDown,i);
    signal_deep{i} = Restrict(LFPdeep,subDownup);
    signal_mid{i} = Restrict(LFPmid,subDownup);
    signal_sup{i} = Restrict(LFPsup,subDownup);
end


% normalize signal for prediction
nb_points = 20;  % number of point in the interpolation
norm_deep = cellfun(@(v)signalEpochNormalize(v, nb_points), signal_deep, 'UniformOutput', false);
norm_mid = cellfun(@(v)signalEpochNormalize(v, nb_points), signal_mid, 'UniformOutput', false);
norm_sup = cellfun(@(v)signalEpochNormalize(v, nb_points), signal_sup, 'UniformOutput', false);

sigmat = zeros(nbDown, 2*nb_points);
for i=1:nbDown
    sigmat(i,:) = [norm_sup{i}; norm_deep{i}];
end



%response
Y = down_durations;
X = sigmat;
cv = crossvalind('HoldOut', size(X,1), 0.7);
Xtrain = X(~cv,:);
Ytrain = Y(~cv,:);
Xtest = X(cv,:);
Ytest = Y(cv,:);

big_rf = TreeBagger(100,Xtrain,Ytrain,'Method','regression','OOBVarImp','On');
Yfit = predict(big_rf,Xtest);

figure, hold on
subplot(1,3,1), hold on, plot(0:500)
hold on, plot(Ytest,Yfit,'k.')
xlabel('true down duration'), ylabel('predicted down duration')
subplot(1,3,2), hold on, plot(oobError(big_rf))
xlabel('Number of Grown Trees'), ylabel('Out-of-Bag Mean Squared Error')
subplot(1,3,3), hold on, bar(big_rf.OOBPermutedVarDeltaError),
for j=1:size(sigmat,2)/nb_points - 1
    hold on, line([j*nb_points+0.5 j*nb_points+0.5], get(gca, 'ylim'));
end
xlabel('Feature Index'), ylabel('Out-of-Bag Feature Importance')











