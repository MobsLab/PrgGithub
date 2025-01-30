
%% Multiclass - nearest neighbour
clear all
clear NumberNeurons Realpos_Rip RipPred Error_Test_Fz Accuracy_Test_Fz Pos_Prediction_Fz Accuracy_Test Error_Test
mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
% DiffBinSizes = [0.1,0.2,0.5,0.7,1,1.5];
DiffBinSizes = [0.5];
RipplesBinSize = 0.02*1e4;
DoZscore = 1;
NumPositionClasses = 4;
IncludeFreezingInTraining = 1;
close all
for bb = 1:length(DiffBinSizes)
    Binsize = DiffBinSizes(bb)*1e4;
    for mm=1:length(mice_PAG_neurons)
        load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(mice_PAG_neurons(mm)),'.mat'])
        
        % Get data
        Q = MakeQfromS(Spikes,Binsize);
        if DoZscore
            Q = tsd(Range(Q),zscore(Data(Q)));
        end
        % Get test and train epochs
        Ripples = Restrict(Ripples,and(thresholdIntervals(LinPos,0.6,'Direction','Above'),FreezeEpoch));
        RipplesEpoch = intervalSet(Range(Ripples)-0.5*1e4,Range(Ripples)+0.5*1e4);
        RipplesEpoch = mergeCloseIntervals(RipplesEpoch,0.5*1e4);
        RipplesEpoch = CleanUpEpoch(RipplesEpoch);
        TotalEpoch_Mov = MovEpoch -RipplesEpoch;
        
        %         else
        TotalEpoch = MovEpoch - or(FreezeEpoch,RipplesEpoch);
        NumEpisodes = length(Start(TotalEpoch));
        TrainEpisodes = randperm(NumEpisodes,floor(NumEpisodes*0.8));
        TrainEpoch = subset(TotalEpoch,sort(TrainEpisodes));
        TestEpoch = TotalEpoch - TrainEpoch;
        
        Spikes_train = full(Data(Restrict(Q,TrainEpoch)));
        LinPos_train = Data(Restrict(LinPos,ts(Range(Restrict(Q,TrainEpoch)))));
        LinPos_train = discretize(LinPos_train,[0:1/NumPositionClasses:1]);
        
        
        
        % Balance train data
        MinLong = min(hist(LinPos_train,[1:NumPositionClasses]));
        
        clear Spikes_train_balanced
        for n = 1:NumPositionClasses
            Class1 = find(LinPos_train==n);
            Shuffle_Class1 = randperm(length(Class1),length(Class1));
            Class1 = Class1(Shuffle_Class1);
            Spikes_train_balanced(n,:) = nanmean(Spikes_train(Class1(1:MinLong),:),1);
        end
        
        % Test data
        Spikes_test = full(Data(Restrict(Q,TestEpoch)));
        LinPos_test = Data(Restrict(LinPos,ts(Range(Restrict(Q,TestEpoch)))));
        LinPos_test_discr = discretize(LinPos_test,[0:1/NumPositionClasses:1]);
        
        clear Class_prediction Pos_Prediction
        for bin = 1:size(Spikes_test,1)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
            end
            [~,Class_prediction(bin)] = max(C_binbybin);
            
        end
        Pos_Prediction  = ((Class_prediction'-1)/(NumPositionClasses-1));
        Accuracy_Test(bb,mm) = nanmean(Class_prediction' == LinPos_test_discr);
        Error_Test(bb,mm) = nanmean(sqrt((Pos_Prediction - LinPos_test).^2));
        
        fig = figure;
        fig.Name = num2str(mice_PAG_neurons(mm));
        [val,ind] = sort(LinPos_test);
        hold on
        plot(Pos_Prediction(ind),'color','c')
        plot(runmean(Pos_Prediction(ind),5),'color','b')
        plot(val,'color','k','linewidth',3)
        title([num2str(size(Spikes_test,2)) ' neur - movement'])
        ylabel('Position (decoded or real)')
        
        % Test data on freezing
        Spikes_test = full(Data(Restrict(Q,FreezeEpoch - RipplesEpoch)));
        LinPos_test_Fz = Data(Restrict(LinPos,ts(Range(Restrict(Q,FreezeEpoch - RipplesEpoch)))));
        LinPos_test_Fz_discr = discretize(LinPos_test_Fz,[0:1/NumPositionClasses:1]);
        
        clear Class_prediction_Fz Pos_Prediction_Fz
        for bin = 1:size(Spikes_test,1)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
            end
            [~,Class_prediction_Fz(bin)] = max(C_binbybin);
            
        end
        Pos_Prediction_Fz  = ((Class_prediction_Fz'-1)/(NumPositionClasses-1));
        Accuracy_Test_Fz (bb,mm) = nanmean(Class_prediction_Fz' == LinPos_test_Fz_discr);
        Error_Test_Fz (bb,mm) = nanmean(sqrt((Pos_Prediction_Fz - LinPos_test_Fz).^2));
        
        fig = figure;
        fig.Name = num2str(mice_PAG_neurons(mm));
        [val,ind] = sort(LinPos_test_Fz);
        hold on
        plot(Pos_Prediction_Fz(ind),'color','c')
        plot(runmean(Pos_Prediction_Fz(ind),5),'color','b')
        plot(val,'color','k','linewidth',3)
        title([num2str(size(Spikes_test,2)) ' neur - freezing'])
        ylabel('Position (decoded or real)')
        
        % RipplesData
        Q_ForRip = MakeQfromS(Spikes,RipplesBinSize);
        Spikes_test = full(Data(Restrict(Q_ForRip,RipplesEpoch)));
        
        clear Class_prediction_ripplestriggered
        for bin = 1:length(Spikes_test)
            Test_snip = Spikes_test(bin,:);
            for cl = 1:NumPositionClasses
                C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
            end
            [~,Class_prediction_ripplestriggered(bin)] = max(C_binbybin);
            
        end
        Pos_prediction_ripplestriggered  = ((Class_prediction_ripplestriggered'-1)/(NumPositionClasses-1));
        
        RipPred_tsd = tsd(Range(Restrict(Q_ForRip,RipplesEpoch)),Pos_prediction_ripplestriggered);
        [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),400,0,0,0);
        RipPred{bb}{mm} = T;
        [M_rip,T] = PlotRipRaw(LinPos,Range(Ripples,'s'),400,0,0,0);
        Realpos_Rip{bb}{mm} = T;
        
        NumberNeurons(mm) = size(Spikes_test,2);
        
        
        
    end
    
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
plot(DiffBinSizes,nanmean(Error_Test'),'.')
hold on
plot(DiffBinSizes,nanmean(Error_Test_Fz'),'.')
makepretty
ylim([0 0.5])
xlim([0 1.7])
xlabel('bin size (s)')
ylabel('Mean square error')

% Z-score
figure
ThreshError = 0.3;
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
    plot(M(:,1),MnRipResp(GoodMice,:),'color',[0.8 0.8 0.8])
    errorbar(M(:,1),nanmean(MnRipResp(GoodMice,:)),stdError(MnRipResp(GoodMice,:)),'linewidth',3,'color','k')
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
    plot(M(:,1),MnRipResp(GoodMice,:),'color',[0.8 0.8 0.8])
    errorbar(M(:,1),nanmean(MnRipResp(GoodMice,:)),stdError(MnRipResp(GoodMice,:)),'linewidth',3,'color','k')
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
    plot(M_rip(:,1),meanpos_Rip(GoodMice,:)','color',[0.8 0.8 0.8])
    errorbar(M_rip(:,1),nanmean(meanpos_Rip(GoodMice,:)),stdError(meanpos_Rip(GoodMice,:)),'linewidth',3,'color','k')
    xlabel('time to ripples')
    ylabel('Mean positsion (real)')
    title(['Training binsize = ' num2str(DiffBinSizes(bb)) ' s'])
end






%% BM version
clear all
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data')
clear NumberNeurons Realpos_Rip RipPred Error_Test_Fz Accuracy_Test_Fz Pos_Prediction_Fz Accuracy_Test Error_Test
mice_PAG_neurons = [905,911,994,1161,1162,1168,1186,1230,1239];
% DiffBinSizes = [0.1,0.2,0.5,0.7,1,1.5];
DiffBinSizes = [0.5];
RipplesBinSize = 0.05*1e4;
DoZscore = 1;
NumPositionClasses = 4;
IncludeFreezingInTraining = 1;
SpeedLim = 2; % To define movepoch
close all
window_around_rip = [0.5 0.5];

for it=1:10
    for bb = 1:length(DiffBinSizes)
        %     Binsize = DiffBinSizes(bb)*1e4;
        Binsize = 0.05*1e4;
        for mm=1:length(mice_PAG_neurons)
            load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(mice_PAG_neurons(mm)),'.mat'])
            
            % Get data
            Q = MakeQfromS(Spikes,Binsize);
            if DoZscore
                Q = tsd(Range(Q),zscore(Data(Q)));
            end
            
            % Get test and train epochs
            %         Ripples = Restrict(Ripples,and(thresholdIntervals(LinPos,0.6,'Direction','Above'),FreezeEpoch));
            %         RipplesEpoch = intervalSet(Range(Ripples)-0.5*1e4,Range(Ripples)+0.5*1e4);
            %         RipplesEpoch = mergeCloseIntervals(RipplesEpoch,0.5*1e4);
            %         RipplesEpoch = CleanUpEpoch(RipplesEpoch);
            
            try
                TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
            catch
                try
                    TotalNoiseEpoch = NoiseEpoch;
                catch
                    TotalNoiseEpoch = intervalSet([],[]);
                end
            end
            AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);          % if you put AfterStimEpoch = ...+3e4, no significativity
            TotalNoiseEpoch = or(TotalNoiseEpoch , AfterStimEpoch);
            MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
            MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
            MovEpoch = MovEpoch-TotalNoiseEpoch;
            
            FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
            Ripples_Epoch = intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4);
            Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
            RipplesEpoch = Ripples_FreezeSafe-TotalNoiseEpoch;
            
            TotalEpoch_Mov = MovEpoch -RipplesEpoch;
            TotalEpoch = MovEpoch - or(FreezeEpoch,RipplesEpoch);
            NumEpisodes = length(Start(TotalEpoch));
            %         TrainEpisodes = randperm(NumEpisodes,floor(NumEpisodes*0.8));
            TrainEpisodes = randperm(NumEpisodes,NumEpisodes);
            %         TrainEpisodes2 = randperm(NumEpisodes,NumEpisodes);
            TrainEpoch = subset(TotalEpoch,sort(TrainEpisodes));
            %         TrainEpoch2 = subset(TotalEpoch,sort(TrainEpisodes2));
            %         TestEpoch = TotalEpoch - TrainEpoch;
            clear St, St = Start(TotalEpoch);
            TestEpoch = and(TotalEpoch , intervalSet(St(1)+10*60e4,St(1)+20*60e4));
            
            Spikes_train = full(Data(Restrict(Q,TrainEpoch)));
            %         Spikes_train2 = full(Data(Restrict(Q,TrainEpoch2)));
            LinPos_train = Data(Restrict(LinPos,ts(Range(Restrict(Q,TrainEpoch)))));
            LinPos_train = discretize(LinPos_train,[0:1/NumPositionClasses:1]);
            
            % Balance train data
            MinLong = min(hist(LinPos_train,[1:NumPositionClasses]));
            
            clear Spikes_train_balanced
            for n = 1:NumPositionClasses
                Class1 = find(LinPos_train==n);
                Shuffle_Class1 = randperm(length(Class1),length(Class1));
                Class1 = Class1(Shuffle_Class1);
                Spikes_train_balanced(n,:) = nanmean(Spikes_train(Class1(1:MinLong),:),1);
                %             Spikes_train_balanced2(n,:) = nanmean(Spikes_train2(Class1(1:MinLong),:),1);
            end
            
            % Test data
            Spikes_test = full(Data(Restrict(Q,TestEpoch)));
            LinPos_test = Data(Restrict(LinPos,ts(Range(Restrict(Q,TestEpoch)))));
            LinPos_test_discr = discretize(LinPos_test,[0:1/NumPositionClasses:1]);
            
            clear Class_prediction
            for bin = 1:size(Spikes_test,1)
                Test_snip = Spikes_test(bin,:);
                if sum(Test_snip==0)<length(Test_snip)-2
                    for cl = 1:NumPositionClasses
                        C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
                    end
                    [~,Class_prediction(bin)] = max(C_binbybin);
                    
                else
                    Class_prediction(bin) = 0;
                end
            end
            Class_prediction(Class_prediction==0)=NaN;
            Pos_Prediction{mm}  = ((Class_prediction'-1)/(NumPositionClasses-1))+.1;
            Accuracy_Test(bb,mm) = nanmean(Class_prediction' == LinPos_test_discr);
            Error_Test(bb,mm) = nanmean(sqrt((Pos_Prediction{mm} - LinPos_test).^2));
            
%             fig = figure;
%             fig.Name = num2str(mice_PAG_neurons(mm));
%             [val{mm},ind] = sort(LinPos_test);
%             hold on
%             plot(Pos_Prediction{mm}(ind),'color','c')
%             plot(runmean(Pos_Prediction{mm}(ind),5),'color','b')
%             plot(val{mm},'color','k','linewidth',3)
%             title([num2str(size(Spikes_test,2)) ' neur - movement'])
%             ylabel('Position (decoded or real)')
%             
%             [Corr_Test(bb,mm), pVal_Test(bb,mm)] = corr(val{mm} , runmean(Pos_Prediction{mm}(ind),5));
            
            % Test data on freezing
            Spikes_test = full(Data(Restrict(Q,FreezeEpoch - RipplesEpoch)));
            LinPos_test_Fz = Data(Restrict(LinPos,ts(Range(Restrict(Q,FreezeEpoch - RipplesEpoch)))));
            LinPos_test_Fz_discr = discretize(LinPos_test_Fz,[0:1/NumPositionClasses:1]);
            
            clear Class_prediction_Fz Pos_Prediction_Fz
            for bin = 1:size(Spikes_test,1)
                Test_snip = Spikes_test(bin,:);
                for cl = 1:NumPositionClasses
                    C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
                end
                [~,Class_prediction_Fz(bin)] = max(C_binbybin);
                
            end
            Pos_Prediction_Fz  = ((Class_prediction_Fz'-1)/(NumPositionClasses-1));
            Accuracy_Test_Fz (bb,mm) = nanmean(Class_prediction_Fz' == LinPos_test_Fz_discr);
            Error_Test_Fz (bb,mm) = nanmean(sqrt((Pos_Prediction_Fz - LinPos_test_Fz).^2));
            
            %         fig = figure;
            %         fig.Name = num2str(mice_PAG_neurons(mm));
            %         [val,ind] = sort(LinPos_test_Fz);
            %         hold on
            %         plot(Pos_Prediction_Fz(ind),'color','c')
            %         plot(runmean(Pos_Prediction_Fz(ind),5),'color','b')
            %         plot(val,'color','k','linewidth',3)
            %         title([num2str(size(Spikes_test,2)) ' neur - freezing'])
            %         ylabel('Position (decoded or real)')
            
            % RipplesData
            Q_ForRip = MakeQfromS(Spikes,RipplesBinSize);
            Spikes_test = full(Data(Restrict(Q_ForRip,RipplesEpoch)));
            
            clear Class_prediction_ripplestriggered
            for bin = 1:length(Spikes_test)
                Test_snip = Spikes_test(bin,:);
                if sum(Test_snip==0)<length(Test_snip)-2
                    for cl = 1:NumPositionClasses
                        C_binbybin(cl) = corr(Test_snip',Spikes_train_balanced(cl,:)');
                    end
                    [~,Class_prediction_ripplestriggered(bin)] = max(C_binbybin);
                else
                    Class_prediction_ripplestriggered(bin) = 0;
                end
            end
            Class_prediction_ripplestriggered(Class_prediction_ripplestriggered==0)=NaN;
            Pos_prediction_ripplestriggered  = ((Class_prediction_ripplestriggered'-1)/(NumPositionClasses-1))+.1;
            
            RipPred_tsd = tsd(Range(Restrict(Q_ForRip,RipplesEpoch)),Pos_prediction_ripplestriggered);
            [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),400,0,0,0);
            RipPred{bb}{mm} = T;
            [M_rip,T] = PlotRipRaw(LinPos,Range(Ripples,'s'),400,0,0,0);
            Realpos_Rip{bb}{mm} = T;
            
            NumberNeurons(mm) = size(Spikes_test,2);
            
            disp(num2str([it mm]))
        end
    end
    
    MnRipResp = [];
    for mm = 1:length(mice_PAG_neurons)
        
        RipPred2{bb}{mm} = RipPred{bb}{mm};
        RipPred2{1}{mm}(RipPred2{1}{mm}==0)=NaN;
        TrigData = nanmean((RipPred2{bb}{mm}));
        MnRipResp = [MnRipResp;TrigData];
        
    end
    AroundRip(it,:, :) = MnRipResp;
end


figure
plot(nanmean(squeeze(nanmean(AroundRip))))

figure
plot(squeeze(nanmean(AroundRip))')







