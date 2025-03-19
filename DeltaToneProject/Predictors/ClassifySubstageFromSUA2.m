% ClassifySubstageFromSUA2
% 29.01.2018 KJ
%
% Try to predict substages (N1,N2,N3,REM and Wake) from neural activity
%   - create a dataset
%   - create a CNN model
% 
%   see 
%       DatasetSubstageFromSUA TestClassifierSubstage



%% init

%load
clear
load(fullfile(FolderDeltaDataKJ,'Datasets','DatasetSubstageFromSUA.mat'))


X = cell(0);
Y = [];
for p=1:length(data_csfs.X)
    X = [X data_csfs.X{p}];
    Y = [Y data_csfs.Y{p}];
end

%data
nb_neurons = size(X{1},1);
size_spiketrain = size(X{1},2);

Y = categorical(Y');

new_X = zeros(nb_neurons,size_spiketrain,1,length(X));
for i=1:length(X)
    new_X(:,:,1,i) = X{i};
end

%train and validation
idx = false(length(X), 1);
idx(randperm(numel(idx), floor(0.2*length(X)))) = true; % validation = 20% of the dataset  

X_train = new_X(:,:,1,~idx);
X_test = new_X(:,:,1,idx);
Y_train = Y(~idx);
Y_test = Y(idx);


%% Convolutional NN

%model
layers = [
    imageInputLayer([nb_neurons size_spiketrain 1])

    convolution2dLayer(1,nb_neurons,'Padding',0)
    batchNormalizationLayer
    reluLayer

    convolution2dLayer(3,nb_neurons*2,'Padding',0)
    batchNormalizationLayer
    reluLayer

    convolution2dLayer(3,nb_neurons*4,'Padding',0)
    batchNormalizationLayer
    reluLayer

    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];


%training
options = trainingOptions('sgdm',...
    'MaxEpochs',50, ...
    'MiniBatchSize', 32, ...
    'ValidationData',{X_test, Y_test},...
    'ValidationFrequency',20,...
    'Verbose',false,...
    'Plots','training-progress');

net = trainNetwork(X_train, Y_train, layers, options);



%test
Yfit = classify(net, X_test);
CP = classperf(grp2idx(Y_test), grp2idx(Yfit));
imagesc(CP.CountingMatrix(1:end-1,:))





