% TestClassifierSubstage3
% 25.01.2018 KJ
%
% test on one night 
% 
%   see TestClassifierSubstage TestClassifierSubstage2
%


%% neural network model

%load
clear
load(fullfile(FolderDeltaDataKJ,'Datasets','TestClassifierSubstage2.mat'))
load(fullfile(FolderDeltaDataKJ,'Datasets','TestClassifierSubstage.mat'))

%data
Y = Y';
nb_neurons = size(X{1},1);
size_spiketrain = size(X{1},2);

new_X = zeros(length(X),nb_neurons*size_spiketrain);
for i=1:length(X)
    new_X(i,:) = reshape(X{i},[1 size(X{i},1)*size(X{i},2)]);
end

%train and validation
idx = false(length(X), 1);
idx(randperm(numel(idx), floor(0.2*length(X)))) = true; % validation = 20% of the dataset  

X_train = new_X(~idx,:);
X_test = new_X(idx,:);
Y_train = Y(~idx);
Y_test = Y(idx);



%% Tree bagger

pred_rf = TreeBagger(500,X_train,Y_train,'OOBVarImp','On');
Yfit = predict(pred_rf,X_test);

hold on, subplot(1,2,1), plot(oobError(pred_rf))
xlabel('Number of Grown Trees'), ylabel('Out-of-Bag Classification Error')
hold on, subplot(1,2,2),  bar(pred_rf.OOBPermutedVarDeltaError)
xlabel('Feature Index'), ylabel('Out-of-Bag Feature Importance')
CP = classperf(Y_test, str2num(cell2mat(Yfit)));

