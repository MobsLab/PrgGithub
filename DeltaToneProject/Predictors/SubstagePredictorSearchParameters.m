% SubstagePredictorSearchParameters
% 17.04.2019 KJ
%
% Find best parameters for substage predictions with neural network
% 
%   see 
%       PredictSubstageFromNeuronsContinuous 
%

clear
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/


%% init

%params
binsizes = [50 100 500]; % in ms
windowstage = [1 1.5 2 2.5 3] * 1e4; % 
stepwindow = 1e4;

try 
    load('IdFigureData2.mat', 'night_duration')
catch
    night_duration = max(Range(S));
end


%% Load Spikes

%spikes
load('SpikeData.mat', 'S')
load('InfoNeuronsAll.mat', 'InfoNeurons')
selected_neurons = (~InfoNeurons.ismua);


for b=1:length(binsizes)
    try
        FiringRate = MakeQfromS(tsdArray(S(selected_neurons)),binsizes(b)*10);
    catch
        FiringRate = MakeQfromS(S(selected_neurons),binsizes(b)*10);
    end


    %% Load Substages
    %substages
    load('SleepSubstages.mat', 'Epoch')
    Substages = Epoch(1:5); %N1,N2,N3,REM and Wake

    for w=1:length(windowstage)
        disp(['b=' num2str(b) '   ' 'w=' num2str(w)])
        %time intervals
        stepwindow = windowstage(w)/2;
        x_intervals = windowstage(w)/2:stepwindow:night_duration-windowstage(w)/2;

        %True substages
        labels_epoch = nan(length(x_intervals),1);
        for ep=1:5
            intervals = [Start(Epoch{ep}) End(Epoch{ep})];
            [status,~,~] = InIntervals(x_intervals,intervals);
            labels_epoch(status) = ep;
        end
        labels_epoch(isnan(labels_epoch))=5;

        %X and Y   
        Y = [];
        X = cell(0);
        for i=1:length(x_intervals)
            intv = intervalSet(x_intervals(i)-windowstage(w)/2,x_intervals(i)+windowstage(w)/2);
            try
                sample_features = full(Data(Restrict(FiringRate,intv)))';
                %add samples only if well processed, no error
                if all(~isnan(sample_features(:))) 
                    X{end+1} = sample_features;
                    Y(end+1) = labels_epoch(i);
                end
            catch
                disp(['error for i=' num2str(i)])
            end
        end

        %format
        nb_neurons = size(X{1},1);
        size_spiketrain = size(X{1},2);
    
        %% LSTM

        nb_train = max(floor(length(x_intervals)/4),1e4);
        idx_train = sort(randsample(length(x_intervals),nb_train));
        idx_test = setdiff(1:length(x_intervals),idx_train);
        idx_val = sort(randsample(idx_test,nb_train));
        

        %X
        X_train = X(idx_train)';
        X_test = X(idx_test)';
        X_val = X(idx_val)';
        %Y
        Y = categorical(Y');
        Y_train = Y(idx_train);
        Y_test = Y(idx_test);
        Y_val = Y(idx_val);

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
        maxEpochs = 5;
        miniBatchSize = 32;
        shuffle = 'never';

        options = trainingOptions('adam', ...
            'ExecutionEnvironment','gpu', ...
            'MaxEpochs',maxEpochs, ...
            'MiniBatchSize',miniBatchSize, ...
            'GradientThreshold',1, ...
            'ValidationData',{X_val, Y_val},...
            'Verbose',false);

        % options = trainingOptions('sgdm', ...
        %     'MaxEpochs',maxEpochs, ...
        %     'MiniBatchSize',miniBatchSize, ...
        %     'Shuffle', shuffle);

        net = trainNetwork(X_train,Y_train,layers,options);


        %test
        Yfit = classify(net, X_test);
        CP = classperf(grp2idx(Y_test), grp2idx(Yfit));
        confusion_matrix{b,w} = CP.CountingMatrix(1:end-1,:);

        %accuracy
        fscore(b,w) = WeightedF1ScoreSleepStaging(confusion_matrix{b,w});
    end

end





