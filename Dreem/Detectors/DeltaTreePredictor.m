% DeltaTreePredictor
%
% use labelize slow wave to create a ML predictor
% - data from the clinical trials
% 
%   see DataClinicLabelizer ClinicDeltaLabelizor
%
%

clear 

filelist = dir([FolderClinicLabelized 'label*']);


all_labels = [];
all_waveforms = cell(0);
all_subjects = [];

for i=1:length(filelist)
    clear labels waveforms subjects durations
    filename = [FolderClinicLabelized filelist(i).name];
    load(filename);
    
    all_labels = [all_labels labels];
    all_subjects = [all_subjects ones(1,length(labels))*subject]; 
    
    all_waveforms = [all_waveforms waveforms];
    
end

%format data in waveforms
nb_points = 30;  % number of point in the interpolation
with_duration=1;  % one feature will be the the signal duration
norm_waveform = cellfun(@(v)signalEpochNormalize(v, nb_points, with_duration), all_waveforms, 'UniformOutput', false);


%create mat
nb_waveform = length(norm_waveform);
wavemat = zeros(nb_waveform, nb_points+with_duration);
for i=1:nb_waveform
    wavemat(i,:) = norm_waveform{i};
end


%% True labels
Y = all_labels';  % response: 0 for no SW and 1 for SW
X = wavemat;
cv = crossvalind('HoldOut', size(X,1), 0.7);
Xtrain = X(~cv,:);
Ytrain = Y(~cv,:);
Xtest = X(cv,:);
Ytest = Y(cv,:);


%% Random Forest predictor
big_rf = TreeBagger(400,Xtrain,Ytrain,'OOBVarImp','On');
Yfit = predict(big_rf,Xtest);
figure, hold on, 
subplot(1,2,1), plot(oobError(big_rf))
xlabel('Number of Grown Trees'), ylabel('Out-of-Bag Classification Error')
hold on, subplot(1,2,2), bar(big_rf.OOBPermutedVarDeltaError)
xlabel('Feature Index'), ylabel('Out-of-Bag Feature Importance')

CP = classperf(Ytest, str2num(cell2mat(Yfit)));


%saving data
cd(FolderClinicPredictor)
save predictor_05102017.mat big_rf CP



% %% Boost algorithm
% Y(Y==0)=-1;
% maxIters = 100;
% Options.loss = 'exploss';
% Options.shrinkageFactor = 0.1;
% Options.subsamplingFactor = 0.3;
% Options.maxTreeDepth = 5;
% 
% model = SQBMatrixTrain(Xtrain, Ytrain, maxIters, Options);
% Yfit = SQBMatrixPredict(model, Xtest);
