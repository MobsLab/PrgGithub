clear all
SessionNames = {'SleepPreUMaze','UMazeCond'};
Binsize = 0.2*1e4;
MinPoints = 500;
MiceNumber=[490,507,508,509,514];
for ss=1:length(SessionNames)
    Dir_Sep{ss} = PathForExperimentsEmbReact(SessionNames{ss});
end
for ii = 1 :length(Dir_Sep{ss}.ExpeInfo)
    MouseID(ii) = Dir_Sep{ss}.ExpeInfo{ii}{1}.nmouse;
end

ThresholdVals = [0.5*1e7,1e7:1e7:10e7];

for mm=1:length(MiceNumber)
    
    % Get the list of folders for this mouse
    FolderList = {};
    for ss=1:length(SessionNames)
        FolderList = [FolderList,Dir_Sep{ss}.path{find(MouseID==MiceNumber(mm))}];
    end
    
    % load the data
    SessionId =  ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sessiontype');
    
    SessionId.Cond{1} = SessionId.UMazeCond{1};
    for ii = 2:length(SessionId.UMazeCond)
        SessionId.Cond{1} = or(SessionId.Cond{1},SessionId.UMazeCond{ii});
    end
    SessionId = rmfield(SessionId,'UMazeCond');
    SessionNames = fieldnames(SessionId);
    for ss=1:length(SessionNames)
        SessionId.(SessionNames{ss}) = SessionId.(SessionNames{ss}){1};
    end
    
    Spikes = ConcatenateDataFromFolders_SB(FolderList,'spikes');
    cd(FolderList{1});
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes = Spikes(numNeurons);
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),full(zscore(Data(Q))));
    
    SleepEpochs = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates'); % wake - nrem -rem
    Acctsd = ConcatenateDataFromFolders_SB(FolderList,'accelero');
    NewMovAcctsd = tsd(Range(Acctsd) , runmean(Data(Acctsd),30)); % smoothed
    Vtsd = ConcatenateDataFromFolders_SB(FolderList,'speed');
    Linpos = ConcatenateDataFromFolders_SB(FolderList,'LinearPosition');
    SafeSide = thresholdIntervals(Linpos,0.6,'Direction','Above');
    
    FreezeEpoch = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
    FreezeEpoch = and(FreezeEpoch,SleepEpochs{1});
    
    DatForPCA = [];
    FzData =  Data(Restrict(Q,and(and(FreezeEpoch,SafeSide),SessionId.(SessionNames{2}))));
    DatForPCA = [DatForPCA;FzData(randperm(size(FzData,1),MinPoints),:)];
    NREMData =  Data(Restrict(Q,and(SleepEpochs{2},SessionId.(SessionNames{1}))));
    DatForPCA = [DatForPCA;NREMData(randperm(size(NREMData,1),MinPoints),:)];
    REMData =  Data(Restrict(Q,and(SleepEpochs{3},SessionId.(SessionNames{1}))));
    DatForPCA = [DatForPCA;REMData(randperm(size(REMData,1),MinPoints),:)];
    
    %Fz vs NREM decoding
    MinLg = size(REMData,1);
    NREMData = NREMData(randperm(size(NREMData,1),MinLg),:);
    train_X = [FzData(1:MinLg/2,:);NREMData(1:MinLg/2,:)];
    train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
    cl = fitcsvm(train_X,train_Y');
    [y,scores2_train] = predict(cl,train_X);
    Acc_train(mm,1) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
    
    test_X = [FzData(MinLg/2:end,:);NREMData(MinLg/2:end,:)];
    [y_test,scores2_test] = predict(cl,test_X);
    Acc_test(mm,1) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
    
    
    %Fz vs REM decoding
    MinLg = size(REMData,1);
    REMData = REMData(randperm(size(REMData,1),MinLg),:);
    train_X = [FzData(1:MinLg/2,:);REMData(1:MinLg/2,:)];
    train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
    cl = fitcsvm(train_X,train_Y');
    [y,scores2_train] = predict(cl,train_X);
    Acc_train(mm,2) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
    
    test_X = [FzData(MinLg/2:end,:);REMData(MinLg/2:end,:)];
    [y_test,scores2_test] = predict(cl,test_X);
    Acc_test(mm,2) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
    
    for th = 1:length(ThresholdVals)
        % Redfine freezing with given thershold
        FreezeEpoch_New = thresholdIntervals(NewMovAcctsd,ThresholdVals(th),'Direction','Below');
        FreezeEpoch_New = mergeCloseIntervals(FreezeEpoch_New,0.3*1E4);
        FreezeEpoch_New = dropShortIntervals(FreezeEpoch_New,2*1E4);
        FreezeEpoch_New = and(FreezeEpoch_New,SleepEpochs{1});
        
        % Redfine freezing with given thershold
        for ss=1:length(SessionNames)
            Dur(mm,ss,th) = sum(Stop(and(FreezeEpoch_New,SessionId.(SessionNames{ss})),'s') - Start(and(FreezeEpoch_New,SessionId.(SessionNames{ss})),'s'));
            Speed(mm,ss,th) = nanmean(Data(Restrict(Vtsd,and(FreezeEpoch_New,SessionId.(SessionNames{ss})))));
            if ss ==1
                LowMobility{ss} = Data(Restrict(Q,and(FreezeEpoch_New,SessionId.(SessionNames{ss}))));
            else
                LowMobility{ss} = Data(Restrict(Q,and(and(FreezeEpoch_New,SafeSide),SessionId.(SessionNames{ss}))));
            end
        end
        
        % Decode with PFC
        % Equalize sample size
        MinLg = min([5000,min(cellfun(@(x) size(x,1),LowMobility))]);
        for ss=1:length(SessionNames)
            LowMobility{ss} = LowMobility{ss}(randperm(size( LowMobility{ss},1),MinLg),:);
        end
        
        DatForPCA = [DatForPCA;LowMobility{ss}(1:MinPoints,:)];
        
        % Train
        %         train_X = [LowMobility{1}(1:MinLg/2,:);LowMobility{2}(1:MinLg/2,:)];
        train_X = [LowMobility{1}(1:MinLg/2,:);FzData(1:MinLg/2,:)];
        train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
        cl = fitcsvm(train_X,train_Y');
        [y,scores2_train] = predict(cl,train_X);
        Acc_train(mm,th+2) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
        
        %         test_X = [LowMobility{1}(MinLg/2:end,:);LowMobility{2}(MinLg/2:end,:)];
        test_X = [LowMobility{1}(MinLg/2:end,:);FzData(MinLg/2:end,:)];
        [y_test,scores2_test] = predict(cl,test_X);
        Acc_test(mm,th+2) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
        
    end
   
    % Do PCA
    [EigVect,EigVals]=PerformPCA(zscore(DatForPCA'));
end


plot(EigVect(:,1)'*DatForPCA)


