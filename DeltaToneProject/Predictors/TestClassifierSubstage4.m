% TestClassifierSubstage4
% 25.01.2018 KJ
%
% test on one night 
% 
%   see 
%       TestClassifierSubstage TestClassifierSubstage2 TestClassifierSubstage3
%
%


%% neural network model

%load
clear
load(fullfile(FolderDeltaDataKJ,'Datasets','TestClassifierSubstage.mat'))
% load(fullfile(FolderDeltaDataKJ,'Datasets','TestClassifierSubstage2.mat'))


%data
Y = categorical(Y');


%train and validation
idx = false(length(X), 1);
idx(randperm(numel(idx), floor(0.2*length(X)))) = true; % validation = 20% of the dataset  

X_train = X(~idx);
X_test = X(idx);
Y_train = Y(~idx);
Y_test = Y(idx);


%% LSTM

%model
inputSize = 60;
outputSize = 300;
outputMode = 'last';
numClasses = 5;

layers = [ ...
    sequenceInputLayer(inputSize),
    lstmLayer(outputSize,'OutputMode',outputMode),
    fullyConnectedLayer(numClasses),
    softmaxLayer,
    classificationLayer];

%training
maxEpochs = 300;
miniBatchSize = 80;
shuffle = 'never';

options = trainingOptions('sgdm', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle', shuffle);

net = trainNetwork(X,Y,layers,options);


%test
% X_test = X(idx);
% for i=1:length(X_test)
%     X_test{i} = (X_test{i}).*(X_test{i});
% end

Yfit = classify(net, X_test);
CP = classperf(grp2idx(Y_test), grp2idx(Yfit));
CP.CountingMatrix


