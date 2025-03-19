% ClassifySubstageFromSUA
% 24.01.2018 KJ
%
% Try to predict substages (N1,N2,N3,REM and Wake) from neural activity
%   - create a dataset
%   - create a CNN model
% 
%   see 
%       DatasetSubstageFromSUA TestClassifierSubstage ClassifySubstageFromSUA2
%



%% init

%load
clear
load(fullfile(FolderDeltaDataKJ,'Datasets','DatasetSubstageFromSUA.mat'))

test_train = 'mouse';

if strcmpi(test_train,'random')
    X = cell(0);
    Y = [];
    for p=1:length(data_csfs.X)
        X = [X data_csfs.X{p}];
        Y = [Y data_csfs.Y{p}];
    end

    %data
    Y = categorical(Y');

    %train and validation
    idx = false(length(X), 1);
    idx(randperm(numel(idx), floor(0.2*length(X)))) = true; % validation = 20% of the dataset  

    X_train = X(~idx);
    X_test = X(idx);
    Y_train = Y(~idx);
    Y_test = Y(idx);

elseif strcmpi(test_train,'mouse')
    X_train = cell(0);
    Y_train = [];
    for p=1:4
        X_train = [X_train ; data_csfs.X{p}'];
        Y_train = [Y_train ; data_csfs.Y{p}'];
    end
    
    X_test = cell(0);
    Y_test = [];
    for p=4:6
        X_test = [X_test ; data_csfs.X{p}'];
        Y_test = [Y_test ; data_csfs.Y{p}'];
    end
    
    Y_train = categorical(Y_train);
    Y_test = categorical(Y_test);
    
end



%% LSTM

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
maxEpochs = 200;
miniBatchSize = 50;
shuffle = 'never';

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'GradientThreshold',1, ...
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
conf_matrix = CP.CountingMatrix(1:end-1,:);
CP.CountingMatrix(1:end-1,:)
conf_matrix./sum(conf_matrix,1)





