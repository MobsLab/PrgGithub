% PredictSubstageFromNeuronsContinuous
% 11.04.2019 KJ
%
% Try to predict substages (N1,N2,N3,REM and Wake) from neural activity
% Do it contiuously and check at transitions
% 
%   see 
%       ClassifySubstageFromSUA TestClassifierSubstage
%




cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/


%params
binsize = 100; % in ms
windowstage = 2e4; % 3 sec
stepwindow = 1e4;


%% load
%substages
load('SleepSubstages.mat', 'Epoch')
Substages = Epoch(1:5); %N1,N2,N3,REM and Wake
%spikes
load('SpikeData.mat', 'S')
load('InfoNeuronsAll.mat', 'InfoNeurons')

selected_neurons = (~InfoNeurons.ismua);
try
    FiringRate = MakeQfromS(tsdArray(S(selected_neurons)),binsize*10);
catch
    FiringRate = MakeQfromS(S(selected_neurons),binsize*10);
end


%% time window
try 
    load('IdFigureData2.mat', 'night_duration')
catch
    night_duration = max(Range(S));
end

x_intervals = windowstage/2:stepwindow:night_duration-windowstage/2;


%% True substages
labels_epoch = nan(length(x_intervals),1);
for ep=1:5
    intervals = [Start(Epoch{ep}) End(Epoch{ep})];
    [status,~,~] = InIntervals(x_intervals,intervals);
    labels_epoch(status) = ep;
end
labels_epoch(isnan(labels_epoch))=5;

%% X and Y   
Y = [];
X = cell(0);
for i=1:length(x_intervals)
    intv = intervalSet(x_intervals(i)-windowstage/2,x_intervals(i)+windowstage/2);
    try
        sample_features = full(Data(Restrict(FiringRate,intv)))';
        %add samples only if well processed, no error
        if all(~isnan(sample_features(:))) 
            X{end+1} = sample_features;
            Y(end+1) =  labels_epoch(i);
        end
    catch
        disp(['error for i=' num2str(i)])
    end
end

%format
nb_neurons = size(X{1},1);
size_spiketrain = size(X{1},2);



%% CNN
% 
% Y = categorical(Y);
%
% new_X = zeros(nb_neurons,size_spiketrain,1,length(X));
% for i=1:length(X)
%     new_X(:,:,1,i) = X{i};
% end
% nb_train = floor(length(x_intervals)/5);
% idx_train = sort(randsample(length(x_intervals),nb_train));
% idx_test = setdiff(1:length(x_intervals),idx_train);
% 
% X_train = new_X(:,:,1,idx_train);
% X_test = new_X(:,:,1,idx_test);
% Y_train = Y(idx_train);
% Y_test = Y(idx_test);
% 
% 
% %model
%
% layers = [
%     imageInputLayer([nb_neurons size_spiketrain 1])
% 
%     convolution2dLayer(1,nb_neurons,'Padding',0)
%     batchNormalizationLayer
%     reluLayer
% 
%     convolution2dLayer(3,nb_neurons*2,'Padding',0)
%     batchNormalizationLayer
%     reluLayer
% 
%     convolution2dLayer(3,nb_neurons*4,'Padding',0)
%     batchNormalizationLayer
%     reluLayer
% 
%     fullyConnectedLayer(5)
%     softmaxLayer
%     classificationLayer];
% 
% 
% %training
% options = trainingOptions('sgdm',...
%     'MaxEpochs',50, ...
%     'MiniBatchSize', 32, ...
%     'ValidationData',{X_test, Y_test},...
%     'ValidationFrequency',20,...
%     'Verbose',false,...
%     'Plots','training-progress');
% 
% net = trainNetwork(X_train, Y_train, layers, options);



%% LSTM

nb_train = floor(length(x_intervals)/6);
idx_train = sort(randsample(length(x_intervals),nb_train));
% idx_train = 1:floor(length(x_intervals)/8);
idx_test = setdiff(1:length(x_intervals),idx_train);

%X
X_train = X(idx_train)';
X_test = X(idx_test)';
%Y
Y = categorical(Y');
Y_train = Y(idx_train);
Y_test = Y(idx_test);

%model
inputSize = size(X_train{1},1);
outputSize = 300;
outputMode = 'last';
numClasses = 5;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(outputSize,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

%training
maxEpochs = 10;
miniBatchSize = 32;
shuffle = 'never';

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
    'ValidationData',{X_test, Y_test},...
    'Verbose',false, ...
    'Plots','training-progress');

% options = trainingOptions('sgdm', ...
%     'MaxEpochs',maxEpochs, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'Shuffle', shuffle);

net = trainNetwork(X_train,Y_train,layers,options);


%test
Yfit = classify(net, X_test);
CP = classperf(grp2idx(Y_test), grp2idx(Yfit));
confusion_matrix = CP.CountingMatrix(1:end-1,:);

%accuracy
fscore = WeightedF1ScoreSleepStaging(confusion_matrix);


%% Plot hypnograms
Y_pred = double(classify(net, X));
Y_true = double(Y);


figure, hold on
subplot(2,1,1), hold on
plot(x_intervals, Y_true,'b'), hold on
ylim([0.5 5.5]),
subplot(2,1,2), hold on
plot(x_intervals, Y_pred,'r'), hold on
ylim([0.5 5.5]),



% 
% figure,
% subplot(2,1,1), hold on
% plot(x_intervals, Y_true),
% 
% subplot(2,1,2), hold on
% plot(x_intervals, Y_pred),


















