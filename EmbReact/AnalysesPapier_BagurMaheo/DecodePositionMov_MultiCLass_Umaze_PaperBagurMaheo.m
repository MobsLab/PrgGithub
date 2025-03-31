
%% Multiclass - nearest neighbour
clear all
close all

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

clear NumberNeurons Realpos_Rip RipPred Error_Test_Fz Accuracy_Test_Fz Pos_Prediction_Fz Accuracy_Test Error_Test
% mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
mice_PAG_neurons = [906,911,994,1161,1162,1168,1186,1230,1239]; % subset used by BM
DiffBinSizes = [0.02,0.05,0.1,0.2];%0.5,0.7,1,1.5];
% DiffBinSizes = [0.05,0.1];
RipplesBinSize = 0.05*1e4;
DoZscore = 0;
NumPositionClasses = 4;
IncludeFreezingInTraining = 1;
MakeIndividualPlots = 0;
JustPlaceCells = 0;
for bb = 1:length(DiffBinSizes)
    Binsize = DiffBinSizes(bb)*1e4;
    for mm=1:length(mice_PAG_neurons)
        load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(mice_PAG_neurons(mm)),'.mat'])

        % Get test and train epochs
        Ripples = Restrict(Ripples,and(thresholdIntervals(LinPos,0.6,'Direction','Above'),FreezeEpoch));
        RipplesEpoch = intervalSet(Range(Ripples)-0.5*1e4,Range(Ripples)+0.5*1e4);
        RipplesEpoch = mergeCloseIntervals(RipplesEpoch,0.5*1e4);
        RipplesEpoch = CleanUpEpoch(RipplesEpoch);
        if IncludeFreezingInTraining
            TotalEpoch = MovEpoch -RipplesEpoch;
        else
            TotalEpoch = MovEpoch - or(FreezeEpoch,RipplesEpoch);
        end
        NumEpisodes = length(Start(TotalEpoch));
        TrainEpisodes = randperm(NumEpisodes,floor(NumEpisodes*0.8));
        TrainEpoch = subset(TotalEpoch,sort(TrainEpisodes));
        TestEpoch = TotalEpoch - TrainEpoch;
        
        % Train data
        Q = MakeQfromS(Spikes,Binsize);
        if DoZscore
            Q = tsd(Range(Q),zscore(Data(Q)));
        end
        if JustPlaceCells
            load('PlaceCellInfo.mat')
            ToKeep = find(Place_Cells{1}.(['Mouse' num2str(mice_PAG_neurons(mm))])>0.5);
            datQ = Data(Q);
            Q = tsd(Range(Q),datQ(:,ToKeep));
        end
        Spikes_train = full(Data(Restrict(Q,TrainEpoch)));
        LinPos_train = Data(Restrict(LinPos,ts(Range(Restrict(Q,TrainEpoch)))));
        LinPos_train_discr = discretize(LinPos_train,[0:1/NumPositionClasses:1]);
        
        % Balance train data
        MinLong = min(hist(LinPos_train_discr,[1:NumPositionClasses]));
        LinPos_train_balanced = [];
        Spikes_train_balanced = [];
        clear Spikes_train_avprofile
        for n = 1:NumPositionClasses
            Class1 = find(LinPos_train_discr==n);
            Shuffle_Class1 = randperm(length(Class1),length(Class1));
            Class1 = Class1(Shuffle_Class1);
            Spikes_train_avprofile(n,:) = nanmean(Spikes_train(Class1(1:MinLong),:),1);
            LinPos_train_balanced = [LinPos_train_balanced;LinPos_train(Class1(1:MinLong))];
            Spikes_train_balanced = [Spikes_train_balanced;Spikes_train(Class1(1:MinLong),:)];
        end
        
        % Train data
        LinPos_train_balanced_discr = discretize(LinPos_train_balanced,[0:1/NumPositionClasses:1]);
        
        clear Class_prediction_Train Pos_Prediction_Train
        for bin = 1:size(Spikes_train_balanced,1)
            Test_snip = Spikes_train_balanced(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_avprofile(cl,:)');
            end
            [~,Class_prediction_Train(bin)] = max(C_binbybin);
            
        end
        Pos_Prediction_Train  = ((Class_prediction_Train'-1)/(NumPositionClasses-1));
        Pos_Prediction_Train(Pos_Prediction_Train==1) = 1-1e-4;
        Pos_Prediction_Train(Pos_Prediction_Train==0) = 1e-4;
        % Get the non linearity
        [fitresult, gof] = createFit_logitfunction(runmean(Pos_Prediction_Train,3), LinPos_train_balanced);
        Pos_Prediction_Train_NL = feval(fitresult,Pos_Prediction_Train);
        
        % Error rates
        Accuracy_Train(bb,mm) = nanmean(Class_prediction_Train' == LinPos_train_balanced_discr);
        Error_Train(bb,mm) = nanmean(sqrt((Pos_Prediction_Train - LinPos_train_balanced).^2));
        Error_Train_NL(bb,mm) = nanmean(sqrt((Pos_Prediction_Train_NL - LinPos_train_balanced).^2));
        
        for cl = 1:NumPositionClasses
            MnDecodedPos_Train{bb}(mm,cl) = nanmean(Pos_Prediction_Train(LinPos_train_balanced_discr==cl));
            MnDecodedPos_Train_NL{bb}(mm,cl) = nanmean(Pos_Prediction_Train_NL(LinPos_train_balanced_discr==cl));
        end
        
        if MakeIndividualPlots
            fig = figure;
            fig.Name = num2str(mice_PAG_neurons(mm));
            [val,ind] = sort(LinPos_train_balanced);
            hold on
            plot(Pos_Prediction_Train(ind),'color','c')
            plot(runmean(Pos_Prediction_Train(ind),5),'color','b')
            plot(runmean(Pos_Prediction_Train_NL(ind),5),'color','r')
            plot(val,'color','k','linewidth',3)
            title([num2str(size(Spikes_train,2)) ' neur - movement'])
            ylabel('Position (decoded or real)')
        end
        
        % Test data
        Spikes_test = full(Data(Restrict(Q,TestEpoch)));
        LinPos_test = Data(Restrict(LinPos,ts(Range(Restrict(Q,TestEpoch)))));
        LinPos_test_discr = discretize(LinPos_test,[0:1/NumPositionClasses:1]);
        
        clear Class_prediction Pos_Prediction
        for bin = 1:size(Spikes_test,1)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_avprofile(cl,:)');
            end
            [~,Class_prediction(bin)] = max(C_binbybin);
            
        end
        Pos_Prediction  = ((Class_prediction'-1)/(NumPositionClasses-1));
        Accuracy_Test(bb,mm) = nanmean(Class_prediction' == LinPos_test_discr);
        Error_Test(bb,mm) = nanmean(sqrt((Pos_Prediction - LinPos_test).^2));
        
        for cl = 1:NumPositionClasses
            MnDecodedPos{bb}(mm,cl) = nanmean(Pos_Prediction(LinPos_test_discr==cl));
        end
        
        
        % Get the non linearity
        Pos_Prediction(Pos_Prediction==1) = 1-1e-4;
        Pos_Prediction(Pos_Prediction==0) = 1e-4;
        Pos_Prediction_NL = feval(fitresult,Pos_Prediction);
        
        % Error rates
        Error_Train_NL(bb,mm) = nanmean(sqrt((Pos_Prediction_NL - LinPos_test).^2));
        
        for cl = 1:NumPositionClasses
            MnDecodedPos_NL{bb}(mm,cl) = nanmean(Pos_Prediction_NL(LinPos_test_discr==cl));
        end
        
        if MakeIndividualPlots
            fig = figure;
            fig.Name = num2str(mice_PAG_neurons(mm));
            [val,ind] = sort(LinPos_test);
            hold on
            plot(Pos_Prediction(ind),'color','c')
            plot(runmean(Pos_Prediction(ind),5),'color','b')
            plot(runmean(Pos_Prediction_NL(ind),5),'color','r')
            plot(val,'color','k','linewidth',3)
            title([num2str(size(Spikes_test,2)) ' neur - movement'])
            ylabel('Position (decoded or real)')
        end
        
        % Test data on freezing
        Spikes_test = full(Data(Restrict(Q,FreezeEpoch - RipplesEpoch)));
        LinPos_test_Fz = Data(Restrict(LinPos,ts(Range(Restrict(Q,FreezeEpoch - RipplesEpoch)))));
        LinPos_test_Fz_discr = discretize(LinPos_test_Fz,[0:1/NumPositionClasses:1]);
        
        clear Class_prediction_Fz Pos_Prediction_Fz
        for bin = 1:size(Spikes_test,1)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_avprofile(cl,:)');
            end
            [~,Class_prediction_Fz(bin)] = max(C_binbybin);
            
        end
        Pos_Prediction_Fz  = ((Class_prediction_Fz'-1)/(NumPositionClasses-1));
        Accuracy_Test_Fz (bb,mm) = nanmean(Class_prediction_Fz' == LinPos_test_Fz_discr);
        Error_Test_Fz (bb,mm) = nanmean(sqrt((Pos_Prediction_Fz - LinPos_test_Fz).^2));
        
        % Get error by class
        for cl = 1:NumPositionClasses
            MnDecodedPos_Fz{bb}(mm,cl) = nanmean(Pos_Prediction_Fz(LinPos_test_Fz_discr==cl));
        end
        
        % Get the non linearity
        Pos_Prediction_Fz(Pos_Prediction_Fz==1) = 1-1e-4;
        Pos_Prediction_Fz(Pos_Prediction_Fz==0) = 1e-4;
        Pos_Prediction_Fz_NL = feval(fitresult,Pos_Prediction_Fz);
        
        % Error rates
        Error_Train_Fz_NL(bb,mm) = nanmean(sqrt((Pos_Prediction_Fz_NL - LinPos_test_Fz).^2));
        
        for cl = 1:NumPositionClasses
            MnDecodedPos_Fz_NL{bb}(mm,cl) = nanmean(Pos_Prediction_Fz_NL(LinPos_test_Fz_discr==cl));
        end
        
        if MakeIndividualPlots
            fig = figure;
            fig.Name = num2str(mice_PAG_neurons(mm));
            [val,ind] = sort(LinPos_test_Fz);
            hold on
            plot(Pos_Prediction_Fz(ind),'color','c')
            plot(runmean(Pos_Prediction_Fz(ind),5),'color','b')
            plot(runmean(Pos_Prediction_Fz_NL(ind),5),'color','r')
            plot(val,'color','k','linewidth',3)
            title([num2str(size(Spikes_test,2)) ' neur - freezing'])
            ylabel('Position (decoded or real)')
        end
        
        % RipplesData
%         Q_ForRip = MakeQfromS(Spikes,RipplesBinSize);
%         if DoZscore
%             Q_ForRip = tsd(Range(Q_ForRip),zscore(Data(Q_ForRip)));
%         end
        Spikes_test = full(Data(Restrict(Q,RipplesEpoch)));
        
        clear Class_prediction_ripplestriggered
        for bin = 1:size(Spikes_test,1)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_avprofile(cl,:)');
            end
            [~,Class_prediction_ripplestriggered(bin)] = max(C_binbybin);
            
        end
        Pos_prediction_ripplestriggered  = ((Class_prediction_ripplestriggered'-1)/(NumPositionClasses-1));
        
        RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),Pos_prediction_ripplestriggered);
        [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),200,0,0,0);
        tps_Rip{bb} = M(:,1);
        RipPred{bb}{mm} = T;
        [M_rip,T] = PlotRipRaw(LinPos,Range(Ripples,'s'),200,0,0,0);
        Realpos_Rip{bb}{mm} = T;
        tps_Pos{bb} = M_rip(:,1);

        % Get the non linearity
        Pos_prediction_ripplestriggered(Pos_prediction_ripplestriggered==1) = 1-1e-4;
        Pos_prediction_ripplestriggered(Pos_prediction_ripplestriggered==0) = 1e-4;
        Pos_prediction_ripplestriggered_NL = feval(fitresult,Pos_prediction_ripplestriggered);
        RipPred_tsd_NL = tsd(Range(Restrict(Q,RipplesEpoch)),Pos_prediction_ripplestriggered_NL);
        [M,T] = PlotRipRaw(RipPred_tsd_NL,Range(Ripples,'s'),200,0,0,0);
        RipPred_NL{bb}{mm} = T;
        NumberNeurons(mm) = size(Spikes_test,2);
        
        
        
    end
    
end



%%

figure
for bb = 1:length(DiffBinSizes)
subplot(length(DiffBinSizes),3,(bb-1)*3+1)
% plot(-1,-1,'c.')
hold on
plot(0.12:0.25:1,nanmean(MnDecodedPos_Train{bb}),'color','b')
plot(0.12:0.25:1,0.12:0.25:1,'color','k')
plot(0.12:0.25:1,nanmean(MnDecodedPos_Train_NL{bb}),'color','r')
plot(0.12:0.25:1,MnDecodedPos_Train{bb}','c.')
plot(0.12:0.25:1,MnDecodedPos_Train_NL{bb}','m.')
xlim([-0.1 1.1])
ylim([-0.1 1])
axis square
makepretty
xlabel('Real position')
ylabel('Actual position')
% legend('MeanLin','x=y','MeanML')
title('All - train')

subplot(length(DiffBinSizes),3,(bb-1)*3+2)
plot(-1,-1,'c.')
hold on
plot(0.12:0.25:1,nanmean(MnDecodedPos{bb}),'color','b')
plot(0.12:0.25:1,0.12:0.25:1,'color','k')
plot(0.12:0.25:1,nanmean(MnDecodedPos_NL{bb}),'color','r')
plot(0.12:0.25:1,MnDecodedPos{bb}','c.')
plot(0.12:0.25:1,MnDecodedPos_NL{bb}','m.')
xlim([-0.1 1.1])
ylim([-0.1 1])
axis square
makepretty
xlabel('Real position')
ylabel('Actual position')
title('Movement')

subplot(length(DiffBinSizes),3,(bb-1)*3+3)
plot(-1,-1,'c.')
hold on
plot(0.12:0.25:1,nanmean(MnDecodedPos_Fz{bb}),'color','b')
plot(0.12:0.25:1,0.12:0.25:1,'color','k')
plot(0.12:0.25:1,MnDecodedPos_Fz{bb}','c.')
plot(0.12:0.25:1,nanmean(MnDecodedPos_Fz_NL{bb}),'color','r')
plot(0.12:0.25:1,MnDecodedPos_Fz_NL{bb}','m.')

xlim([-0.1 1.1])
ylim([-0.1 1])
axis square
makepretty
xlabel('Real position')
ylabel('Actual position')
title('Freezing')
end

figure
subplot(121)
plot(NumberNeurons,nanmean(Error_Test,1),'.')
hold on
plot(NumberNeurons,nanmean(Error_Test_Fz,1),'.')
makepretty
ylim([0 0.5])
xlim([10 100])
xlabel('number of neurons')
ylabel('Mean square error')

subplot(122)
plot(DiffBinSizes,nanmean(Error_Test',1),'.')
hold on
plot(DiffBinSizes,nanmean(Error_Test_Fz',1),'.')
makepretty
ylim([0 0.5])
xlim([0 1.7])
xlabel('bin size (s)')
ylabel('Mean square error')

% Z-score
figure
ThreshError = 1;
for bb = 1:length(DiffBinSizes)
    subplot(2,3,bb)
    GoodMice = Error_Test(bb,:)<ThreshError;
    MnRipResp = [];
    for mm = 1:length(mice_PAG_neurons)
        TrigData = (zscore(nanmean((RipPred{bb}{mm}))));
        MnRipResp = [MnRipResp;TrigData];
    end
    ylim([-3 3])
    line([0 0],ylim,'color','r','linewidth',2)
    hold on
    plot(tps_Rip{bb},MnRipResp(GoodMice,:)','color',[0.8 0.8 0.8])
    errorbar(tps_Rip{bb},nanmean(MnRipResp(GoodMice,:)),stdError(MnRipResp(GoodMice,:)),'linewidth',3,'color','k')
    xlabel('time to ripples')
    ylabel('Z-scored decoded position')
    title(['Training binsize = ' num2str(DiffBinSizes(bb)) ' s'])
end



% Actual positoin
figure
ThreshError = 1;
for bb = 1:length(DiffBinSizes)
    subplot(2,3,bb)
    GoodMice = Error_Test(bb,:)<ThreshError;
    MnRipResp = [];
    for mm = 1:length(mice_PAG_neurons)
        TrigData = nanmean((RipPred{bb}{mm}));
        MnRipResp = [MnRipResp;TrigData];
    end
    ylim([0 1])
    line([0 0],ylim,'color','r','linewidth',2)
    hold on
    plot(tps_Rip{bb},MnRipResp(GoodMice,:),'color',[0.8 0.8 0.8])
    errorbar(tps_Rip{bb},nanmean(MnRipResp(GoodMice,:)),stdError(MnRipResp(GoodMice,:)),'linewidth',3,'color','k')
    xlabel('time to ripples')
    ylabel('Decoded position')
    title(['Training binsize = ' num2str(DiffBinSizes(bb)) ' s'])
end


%LinPos
figure
ThreshError = 5;
for bb = 1:length(DiffBinSizes)
    subplot(2,3,bb)
    GoodMice = find(Error_Test(bb,:)<ThreshError);
    clear meanpos_Rip
    for mm = 1:length(mice_PAG_neurons)
        meanpos_Rip(mm,:) = nanmean((Realpos_Rip{bb}{mm}));
    end
    ylim([0 1])
    
    line([0 0],ylim,'color','r','linewidth',2)
    hold on
    plot(tps_Pos{bb},meanpos_Rip(GoodMice,:)','color',[0.8 0.8 0.8])
    errorbar(tps_Pos{bb},nanmean(meanpos_Rip(GoodMice,:)),stdError(meanpos_Rip(GoodMice,:)),'linewidth',3,'color','k')
    xlabel('time to ripples')
    ylabel('Mean positsion (real)')
    title(['Training binsize = ' num2str(DiffBinSizes(bb)) ' s'])
end