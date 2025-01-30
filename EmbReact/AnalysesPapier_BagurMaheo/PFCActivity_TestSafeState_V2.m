clear all
SessionNames = {'SleepPreUMaze','UMazeCond'};
Binsize = 0.2*1e4;
MinPoints = 300;
MiceNumber=[490,507,508,514]; % 509 excluded, not enought low activity in homecage
for ss=1:length(SessionNames)
    Dir_Sep{ss} = PathForExperimentsEmbReact(SessionNames{ss});
end
for ii = 1 :length(Dir_Sep{ss}.ExpeInfo)
    MouseID(ii) = Dir_Sep{ss}.ExpeInfo{ii}{1}.nmouse;
end

ThresholdVals = [0,1e7,3e7,10e7];
ImmobLevel  = {'Low','Mid','High'};
SaveLoc = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PFC_DecodeStates/';

CumulData.Sf = [];
CumulData.Sk = [];
CumulData.NREM = [];
CumulData.Low = [];
CumulData.Mid = [];
CumulData.High = [];
CumulData.Loco= [];

MinPoints_Cum = 300;

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
    try,Vtsd = ConcatenateDataFromFolders_SB(FolderList,'speed');; catch, Vtsd = tsd(0,0);end
    Linpos = ConcatenateDataFromFolders_SB(FolderList,'LinearPosition');
    SafeSide = thresholdIntervals(Linpos,0.6,'Direction','Above');
    ShockSide = thresholdIntervals(Linpos,0.4,'Direction','Below');
    
    FreezeEpoch = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
    FreezeEpoch = and(FreezeEpoch,SleepEpochs{1});
    
    DatForPCA = [];
    FzData_Sf =  Data(Restrict(Q,and(and(FreezeEpoch,SafeSide),SessionId.(SessionNames{2}))));
    DatForPCA = [DatForPCA;FzData_Sf(randperm(size(FzData_Sf,1),MinPoints),:)];
    DatId.Sf = [1:MinPoints];
    CumulData.Sf = [CumulData.Sf,FzData_Sf(1:MinPoints_Cum,:)];
    
    FzData_Sk =  Data(Restrict(Q,and(and(FreezeEpoch,ShockSide),SessionId.(SessionNames{2}))));
    DatForPCA = [DatForPCA;FzData_Sk(randperm(size(FzData_Sk,1),MinPoints),:)];
    DatId.Sk = [MinPoints+1:MinPoints*2];
    CumulData.Sk = [CumulData.Sk,FzData_Sk(1:MinPoints_Cum,:)];
    
    
    NREMData =  Data(Restrict(Q,and(SleepEpochs{2},SessionId.(SessionNames{1}))));
    DatForPCA = [DatForPCA;NREMData(randperm(size(NREMData,1),MinPoints),:)];
    DatId.NREM = [MinPoints*2+1:MinPoints*3];
    CumulData.NREM = [CumulData.NREM,NREMData(1:MinPoints_Cum,:)];
    
    REMData =  Data(Restrict(Q,and(SleepEpochs{3},SessionId.(SessionNames{1}))));
    DatForPCA = [DatForPCA;REMData(randperm(size(REMData,1),min([size(REMData,1),MinPoints])),:)];
    DatId.REM = [MinPoints*3+1:MinPoints*4];
    
    
    %Fz vs NREM decoding
    MinLg = min([size(NREMData,1),size(FzData_Sf,1)]);
    NREMData = NREMData(randperm(size(NREMData,1),MinLg),:);
    train_X = [FzData_Sf(1:MinLg/2,:);NREMData(1:MinLg/2,:)];
    train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
    cl = fitcsvm(train_X,train_Y');
    [y,scores2_train] = predict(cl,train_X);
    Acc_train.FzvsNREM(mm) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
    
    test_X = [FzData_Sf(MinLg/2:end,:);NREMData(MinLg/2:end,:)];
    [y_test,scores2_test] = predict(cl,test_X);
    Acc_test.FzvsNREM(mm) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
    
    %Fz vs REM decoding
    MinLg = min([size(REMData,1),size(FzData_Sf,1)]);
    REMData = REMData(randperm(size(REMData,1),MinLg),:);
    train_X = [FzData_Sf(1:MinLg/2,:);REMData(1:MinLg/2,:)];
    train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
    cl = fitcsvm(train_X,train_Y');
    [y,scores2_train] = predict(cl,train_X);
    Acc_train.FzvsREM(mm) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
    
    test_X = [FzData_Sf(MinLg/2:MinLg,:);REMData(MinLg/2:MinLg,:)];
    [y_test,scores2_test] = predict(cl,test_X);
    Acc_test.FzvsREM(mm) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
    
    %FzSf vs FzSk decoding
    MinLg = min([size(FzData_Sk,1),size(FzData_Sf,1)]);
    FzData_Sk = FzData_Sk(randperm(size(FzData_Sk,1),MinLg),:);
    train_X = [FzData_Sf(1:MinLg/2,:);FzData_Sk(1:MinLg/2,:)];
    train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
    cl = fitcsvm(train_X,train_Y');
    [y,scores2_train] = predict(cl,train_X);
    Acc_train.FzSfvsFzSk(mm) = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
    
    test_X = [FzData_Sf(MinLg/2:MinLg,:);FzData_Sk(MinLg/2:MinLg,:)];
    [y_test,scores2_test] = predict(cl,test_X);
    Acc_test.FzSfvsFzSk(mm) = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
    [Acc_train_Lin,Acc_test_Lin,Proj_train,Proj_test,Projector.SfSk] = PerfomLinearDecoding(FzData_Sf,FzData_Sk);
    
    
    if mm==4
        ThresholdVals = [0,1.5e7,5e7,15e7]; % Otherwise really not enough data
    end
    for th = 1:length(ThresholdVals)-1
        % Redfine freezing with given thershold
        FreezeEpoch_New = thresholdIntervals(NewMovAcctsd,ThresholdVals(th+1),'Direction','Below');
        MovEpoch_New = thresholdIntervals(NewMovAcctsd,ThresholdVals(th),'Direction','Above');
        EPOI = and(FreezeEpoch_New,MovEpoch_New);
        EPOI = mergeCloseIntervals(EPOI,0.3*1E4);
        EPOI = dropShortIntervals(EPOI,2*1E4);
        EPOI = and(EPOI,SleepEpochs{1});
        
        % Redfine freezing with given thershold
        Dur(mm,th) = sum(Stop(and(EPOI,SessionId.(SessionNames{1})),'s') - Start(and(EPOI,SessionId.(SessionNames{1})),'s'));
        Speed(mm,th) = nanmean(Data(Restrict(Vtsd,and(EPOI,SessionId.(SessionNames{1})))));
        FIxedMobility{th} = Data(Restrict(Q,and(EPOI,SessionId.(SessionNames{1}))));
        
        % Decode with PFC
        % Randomize order
        FIxedMobility{th} = FIxedMobility{th}(randperm(size( FIxedMobility{th},1),size( FIxedMobility{th},1)),:);
        
        DatForPCA = [DatForPCA;FIxedMobility{th}(1:MinPoints,:)];
        DatId.(ImmobLevel{th}) = [MinPoints*(3+th)+1:MinPoints*(4+th)];
        
        CumulData.(ImmobLevel{th}) = [CumulData.(ImmobLevel{th}),FIxedMobility{th}(1:MinPoints_Cum,:)];
        
        % Train
        MinLg = min([5000,size(FIxedMobility{th},1),size(FzData_Sf,1)]);
        train_X = [FIxedMobility{th}(1:MinLg/2,:);FzData_Sf(1:MinLg/2,:)];
        train_Y = [zeros(floor(MinLg/2),1);ones(floor(MinLg/2),1)];
        cl = fitcsvm(train_X,train_Y');
        [y,scores2_train] = predict(cl,train_X);
        Acc_train.(['Fzvs' ImmobLevel{th}])(mm)  = (1-nanmean(y(1:MinLg/2))+nanmean(y(MinLg/2+1:end)))/2;
        
        test_X = [FIxedMobility{th}(MinLg/2:MinLg,:);FzData_Sf(MinLg/2:MinLg,:)];
        [y_test,scores2_test] = predict(cl,test_X);
        Acc_test.(['Fzvs' ImmobLevel{th}])(mm)  = (1-nanmean(y_test(1:MinLg/2))+nanmean(y_test(MinLg/2+1:end)))/2;
        
        [Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,Projector.(['Fzvs' ImmobLevel{th}])] = PerfomLinearDecoding(FIxedMobility{th},FzData_Sf);
        
    end
    
    [Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,Projector.LowVsHighMov] = PerfomLinearDecoding(FIxedMobility{1},FIxedMobility{2});
    
    % Do PCA
    [EigVect,EigVals]=PerformPCA(zscore(DatForPCA)');
    
    % Do PCA no sleep
    ToEliminate = [DatId.NREM,DatId.REM];
    DatForPCA_NoSleep = DatForPCA;
    DatForPCA_NoSleep(ToEliminate,:) = [];
    [EigVect_NoSleep,EigVals]=PerformPCA(zscore(DatForPCA_NoSleep)');
    
    % Figure
    AllDecoders = fieldnames(Acc_train);
    
    fig = figure;
    subplot(311)
    for ff  = 1 : length(AllDecoders)
        
        bar(ff,Acc_train.(AllDecoders{ff})(mm),'k')
        hold on
        bar(ff,Acc_test.(AllDecoders{ff})(mm),'b')
    end
    ylim([0 1])
    xlim([0 7])
    set(gca,'XTick',[1:length(AllDecoders)],'XTickLabel',AllDecoders)
    xtickangle(45)
    ylabel('Accuracy')
    title('Safe Fz vs Other state decoding')
    legend('train','test')
    
    subplot(323)
    hold on
    plot(EigVect(:,1)'*DatForPCA(DatId.Sf,:)',EigVect(:,2)'*DatForPCA(DatId.Sf,:)','b.')
    hold on
    plot(EigVect(:,1)'*DatForPCA(DatId.Sk,:)',EigVect(:,2)'*DatForPCA(DatId.Sk,:)','r.')
    plot(EigVect(:,1)'*DatForPCA(DatId.NREM,:)',EigVect(:,2)'*DatForPCA(DatId.NREM,:)','k.')
    plot(EigVect(:,1)'*DatForPCA(DatId.REM,:)',EigVect(:,2)'*DatForPCA(DatId.REM,:)','.','color',[0.6 0.6 0.6])
    cols = summer(length(ThresholdVals)-1);
    for ii=1:length(ImmobLevel)
        plot(EigVect(:,1)'*DatForPCA(DatId.(ImmobLevel{ii}),:)',EigVect(:,2)'*DatForPCA(DatId.(ImmobLevel{ii}),:)','.','color',cols(ii,:))
    end
    xlabel('PC1'),ylabel('PC2')
    title('WithSleep')
    
    subplot(324)
    hold on
    plot(EigVect(:,3)'*DatForPCA(DatId.Sf,:)',EigVect(:,4)'*DatForPCA(DatId.Sf,:)','b.')
    hold on
    plot(EigVect(:,3)'*DatForPCA(DatId.Sk,:)',EigVect(:,4)'*DatForPCA(DatId.Sk,:)','r.')
    plot(EigVect(:,3)'*DatForPCA(DatId.NREM,:)',EigVect(:,4)'*DatForPCA(DatId.NREM,:)','k.')
    plot(EigVect(:,3)'*DatForPCA(DatId.REM,:)',EigVect(:,4)'*DatForPCA(DatId.REM,:)','.','color',[0.6 0.6 0.6])
    cols = summer(length(ThresholdVals)-1);
    for ii=1:length(ImmobLevel)
        plot(EigVect(:,3)'*DatForPCA(DatId.(ImmobLevel{ii}),:)',EigVect(:,4)'*DatForPCA(DatId.(ImmobLevel{ii}),:)','.','color',cols(ii,:))
    end
    xlabel('PC3'),ylabel('PC4')
    
    subplot(325)
    hold on
    plot(EigVect_NoSleep(:,1)'*DatForPCA_NoSleep(DatId.Sf,:)',EigVect_NoSleep(:,2)'*DatForPCA_NoSleep(DatId.Sf,:)','b.')
    hold on
    plot(EigVect_NoSleep(:,1)'*DatForPCA_NoSleep(DatId.Sk,:)',EigVect_NoSleep(:,2)'*DatForPCA_NoSleep(DatId.Sk,:)','r.')
    cols = summer(length(ThresholdVals)-1);
    for ii=1:length(ImmobLevel)
        plot(EigVect_NoSleep(:,1)'*DatForPCA_NoSleep(DatId.(ImmobLevel{ii})-600,:)',EigVect_NoSleep(:,2)'*DatForPCA_NoSleep(DatId.(ImmobLevel{ii})-600,:)','.','color',cols(ii,:))
    end
    xlabel('PC1'),ylabel('PC2')
    title('NoSleep')
    
    subplot(326)
    hold on
    plot(EigVect_NoSleep(:,3)'*DatForPCA_NoSleep(DatId.Sf,:)',EigVect_NoSleep(:,4)'*DatForPCA_NoSleep(DatId.Sf,:)','b.')
    hold on
    plot(EigVect_NoSleep(:,3)'*DatForPCA_NoSleep(DatId.Sk,:)',EigVect_NoSleep(:,4)'*DatForPCA_NoSleep(DatId.Sk,:)','r.')
    cols = summer(length(ThresholdVals)-1);
    for ii=1:length(ImmobLevel)
        plot(EigVect_NoSleep(:,3)'*DatForPCA_NoSleep(DatId.(ImmobLevel{ii})-600,:)',EigVect_NoSleep(:,4)'*DatForPCA_NoSleep(DatId.(ImmobLevel{ii})-600,:)','.','color',cols(ii,:))
    end
    xlabel('PC3'),ylabel('PC4')
    
    saveas(fig.Number,[SaveLoc 'PFCDecodeStates_M' num2str(mm) '.png'])
    
    %% Try some projections
    Cols = {'b','r','k',[0.6 0.6 0.6],cols(1,:),cols(2,:),cols(3,:)};
    PtTypes = fieldnames(DatId);
    fig = figure;
    subplot(221)
    for type = 1:length(PtTypes)
        plot(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)',Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs high mov')
    makepretty
    subplot(222)
    for type = 1:length(PtTypes)
        plot(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)',Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(Projector.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs Fz')
    makepretty
    subplot(223)
    for type = 1:length(PtTypes)
        plot(Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)',Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(Projector.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('Low vs Fz')
    makepretty
    subplot(224)
    for type = 1:length(PtTypes)
        plot(Projector.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)',Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(Projector.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(Projector.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(Projector.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('FzvsHigh')
    makepretty
    saveas(fig.Number,[SaveLoc 'PFCProjections_M' num2str(mm) '.png'])
    
end


for ff  = 1 : length(AllDecoders)
    for mm = 1:4
        Alltrain(ff,mm) = Acc_train.(AllDecoders{ff})(mm);
        Alltest(ff,mm) = Acc_test.(AllDecoders{ff})(mm);
    end
end


fig = figure;
subplot(211)
bar(1:ff,nanmean(Alltrain'))
hold on
errorbar(1:ff,nanmean(Alltrain'),stdError(Alltrain'),'.k')
plot(Alltrain,'color',[0.6 0.6 0.6])
ylim([0 1])
xlim([0 7])
set(gca,'XTick',[1:length(AllDecoders)],'XTickLabel',AllDecoders)
xtickangle(45)
ylabel('Accuracy')
title('Train - Safe Fz vs Other state decoding')

subplot(212)
bar(1:ff,nanmean(Alltest'))
hold on
errorbar(1:ff,nanmean(Alltest'),stdError(Alltest'),'.k')
plot(Alltest,'color',[0.6 0.6 0.6])
ylim([0 1])
xlim([0 7])
set(gca,'XTick',[1:length(AllDecoders)],'XTickLabel',AllDecoders)
xtickangle(45)
ylabel('Accuracy')
title('Test - Safe Fz vs Other state decoding')
saveas(fig.Number,[SaveLoc 'PFCDecoderAllMice.png'])

%% Project psudo pop
[Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,ProjectorCumul.LowVsHighMov] = ....
    PerfomLinearDecoding(CumulData.Low,CumulData.High);

[Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,ProjectorCumul.SfSk] = ....
    PerfomLinearDecoding(CumulData.Sk,CumulData.Sf);

[Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,ProjectorCumul.FzvsLow] = ....
    PerfomLinearDecoding(CumulData.Sf,CumulData.Low);

[Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,ProjectorCumul.FzvsHigh] = ....
    PerfomLinearDecoding(CumulData.Sf,CumulData.High);

[Acc_train_Lin,Acc_test_Lin,Proj_test,Proj_train,ProjectorCumul.SleepVsHigh] = ....
    PerfomLinearDecoding(CumulData.NREM,CumulData.High);

PtTypes = fieldnames(CumulData);
Cols = {'b','r','k',cols(1,:),cols(2,:),cols(3,:)};

fig = figure;
subplot(321)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.SfSk*CumulData.(PtTypes{type})',ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('Sf Vs Sk')
ylabel('Low vs high mov')
makepretty

subplot(322)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.SfSk*CumulData.(PtTypes{type})',ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('Sf Vs Sk')
ylabel('Low vs Fz')
makepretty

subplot(323)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})',ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('Low vs high mov')
ylabel('Low vs Fz')
makepretty

subplot(324)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})',ProjectorCumul.SfSk*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('High vs low mouvement')
ylabel('Safe vs shock')
makepretty

subplot(325)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})',ProjectorCumul.SfSk*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('Sleep Vs high Mo')
ylabel('Safe vs shock')
makepretty

subplot(326)
for type = 1:length(PtTypes)
    plot(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})',ProjectorCumul.SfSk*CumulData.(PtTypes{type})','.','color',Cols{type})
    hold on
end
for type = 1:length(PtTypes)
    plot(nanmean(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
    plot(nanmean(ProjectorCumul.SleepVsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
end
axis square
xlabel('Sleep Vs high Mo')
ylabel('Safe vs shock')
makepretty

saveas(fig.Number,[SaveLoc 'PFCProjections_M' num2str(mm) '.png'])

%% PCA all together
AllData = [];
for ii = 1:length(PtTypes)
    AllData = [AllData ;CumulData.(PtTypes{ii})];
end


[EigVect,EigVals]=PerformPCA(zscore(AllData(1:end,:)'));

A = zscore(AllData(1:end,:)');
Cols = {'b','r','k',cols(1,:),cols(2,:),cols(3,:)};
subplot(121)
for ii = 1:length(PtTypes)
    X = EigVect(:,1)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    Y = EigVect(:,2)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    plot(X,Y,'.','color',Cols{ii})
    hold on
end
for ii = 1:length(PtTypes)
    X = EigVect(:,1)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    Y = EigVect(:,2)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    plot(nanmean(X),nanmean(Y),'.','color','k','MarkerSize',70)
    plot(nanmean(X),nanmean(Y),'.','color',Cols{ii},'MarkerSize',50)
end
makepretty
xlabel('PC1')
ylabel('PC2')

subplot(122)
for ii = 1:length(PtTypes)
    X = EigVect(:,3)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    Y = EigVect(:,4)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    plot(X,Y,'.','color',Cols{ii})
    hold on
end
for ii = 1:length(PtTypes)
    X = EigVect(:,3)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    Y = EigVect(:,4)'*A(:,MinPoints_Cum*(ii-1)+1:MinPoints_Cum*(ii));
    plot(nanmean(X),nanmean(Y),'.','color','k','MarkerSize',70)
    plot(nanmean(X),nanmean(Y),'.','color',Cols{ii},'MarkerSize',50)
end

makepretty
xlabel('PC3')
ylabel('PC4')



 fig = figure;
    subplot(221)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.SfSk*CumulData.(PtTypes{type})',ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs high mov')
    makepretty
    subplot(222)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.SfSk*CumulData.(PtTypes{type})',ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.SfSk*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs Fz')
    makepretty
    subplot(223)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})',ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.LowVsHighMov*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('Low vs Fz')
    makepretty
    subplot(224)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})',ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.FzvsHigh*CumulData.(PtTypes{type})'),nanmean(ProjectorCumul.FzvsLow*CumulData.(PtTypes{type})'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('FzvsHigh')
    makepretty
    saveas(fig.Number,[SaveLoc 'PFCProjections_M' num2str(mm) '.png'])

    
    
    fig = figure;
    subplot(221)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)',ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs high mov')
    makepretty
    subplot(222)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)',ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.SfSk*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Sf Vs Sk')
    ylabel('Low vs Fz')
    makepretty
    subplot(223)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)',ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.LowVsHighMov*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('Low vs Fz')
    makepretty
    subplot(224)
    for type = 1:length(PtTypes)
        plot(ProjectorCumul.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)',ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)','.','color',Cols{type})
        hold on
    end
    for type = 1:length(PtTypes)
        plot(nanmean(ProjectorCumul.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color','k','MarkerSize',50)
        plot(nanmean(ProjectorCumul.FzvsHigh*DatForPCA(DatId.(PtTypes{type}),:)'),nanmean(ProjectorCumul.FzvsLow*DatForPCA(DatId.(PtTypes{type}),:)'),'.','color',Cols{type},'MarkerSize',40)
    end
    axis square
    xlabel('Low vs high mov')
    ylabel('FzvsHigh')
    makepretty
    saveas(fig.Number,[SaveLoc 'PFCProjections_M' num2str(mm) '.png'])
