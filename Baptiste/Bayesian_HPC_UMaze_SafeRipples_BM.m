%% Bayesian
clear all
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data')
clear NumberNeurons Realpos_Rip RipPred Error_Test_Fz Accuracy_Test_Fz Pos_Prediction_Fz Accuracy_Test Error_Test
mice_PAG_neurons = [905,911,994,1161,1162,1168,1186,1230,1239];
DiffBinSizes = [0.5];
RipplesBinSize = 0.05*1e4;
DoZscore = 1;
NumPositionClasses = 10;
IncludeFreezingInTraining = 1;
SpeedLim = 2; % To define movepoch
close all
window_around_rip = [0.5 0.5];
load('PlaceCells.mat', 'Place_Cells')
curvexy = [.15 .15 .85 .85; 0 .96 .96 0]';
SpatialBins = 10;

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
        
        FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
        Ripples_Epoch = intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4);
        Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
        RipplesEpoch = Ripples_FreezeSafe-TotalNoiseEpoch;
        
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = dropShortIntervals(mergeCloseIntervals((((MovEpoch-FreezeEpoch)-TotalNoiseEpoch)-Ripples_Epoch),.3e4),2*1e4);
        
        X_Pos = Data(Restrict(Xtsd,MovEpoch));
        Y_Pos = Data(Restrict(Ytsd,MovEpoch));
        mapxy=[X_Pos';Y_Pos']';
        [xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
        LinPos_tsd = tsd(Range(Restrict(Xtsd,MovEpoch)),t);
        %         LinearizePos_time = hist(t,linspace(0,1,SpatialBins))*median(diff(Range(Restrict(Xtsd,MovEpoch),'s')));
        %         LinearizePos_time = LinearizePos_time./sum(LinearizePos_time')';
        LinearizePos_time = ones(1,10)*.1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for neur=1:length(Spikes)
            try
                if max(size(Restrict(Spikes{neur},MovEpoch)))>10 % Only use cells with at least 10 spikes in move epoch
                    X_OnSpikes = Data(Restrict(Xtsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
                    Y_OnSpikes = Data(Restrict(Ytsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
                    mapxy=[X_OnSpikes';Y_OnSpikes']';
                    [xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
                    LinearizeFiring_binned1(neur,:) = hist(t,linspace(0,1,SpatialBins));
                    
                    
                    [map_mov{neur}, mapNS_mov{neur}, stats{neur}, px{neur}, py{neur}, FR_mov(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                        Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch , 'figure' , 0 , 'plotresults' , 0);
                    
                    if isempty(stats{neur}.spatialInfo)
                        stats{neur}.spatialInfo = 0;
                    end
                    
                    SpatialInfo(neur) = stats{neur}.spatialInfo;
                    
                    % Get only bins the mice has actually visited
                    map_temp = mapNS_mov{neur}.rate;
                    pos_temp = mapNS_mov{neur}.time;
                    map_temp = map_temp(8:56,8:56);
                    pos_temp = pos_temp(8:56,8:56);
                    map_temp(pos_temp==0) = NaN;
                    maze_lin=linspace(0,1,size(map_temp,1));
                    clear U, U=find(not(isnan(map_temp)));
                    
                    % linearize
                    [Y,X] = ind2sub(size(map_temp) , U);
                    [~,~,lin_proj] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[maze_lin(X);maze_lin(Y)]','linear');
                    [C,~,IC] = unique(lin_proj);
                    
                    % Mean firing rate for each level visited
                    for j=1:length(C)
                        LinFiring_temp(j,:) = [C(j) nanmean(map_temp(U(IC==j)))];
                    end
                    [~,order]=sort(LinFiring_temp(:,1));
                    LinFiring_temp = LinFiring_temp(order,:);
                    
                    % bin regularly thorughout the maze
                    clear LinearizeFiring_binned
                    for bin=1:NumPositionClasses
                        ind=find(and(LinFiring_temp(:,1)>=((bin-1)/NumPositionClasses) , LinFiring_temp(:,1)<(bin/NumPositionClasses)));
                        if ~isempty(ind)
                            LinearizeFiring_binned(neur,bin) = nanmean(LinFiring_temp(ind,2));
                        end
                    end
                    
                    LinearizeFiring_binned(neur,:) = LinearizeFiring_binned(neur,:);
                else
                    FR_mov(neur) = NaN;
                    SpatialInfo(neur) = 0;
                    LinearizeFiring_binned(neur,:) = nan(1,NumPositionClasses);
                    LinearizeFiring_binned1(neur,:) = nan(1,NumPositionClasses);
                    map_mov{neur}.rate = [];
                    map_mov{neur}.time = [];
                    map_mov{neur}.count = [];
                    mapNS_mov{neur}.rate = [];
                    mapNS_mov{neur}.time = [];
                    stats{neur} = 0;
                end
            end
        end
        close all
        
        clear LinearizeFiring_binned2
        LinearizeFiring_binned2 = LinearizeFiring_binned./sum(LinearizeFiring_binned')';
        BadGuys = find(sum(isnan(LinearizeFiring_binned2)'));
        LinearizeFiring_binned2(BadGuys,:) = [];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % RipplesData
        clear data_decoder M T decoded_position_bins decoded_positions
        Q_ForRip = MakeQfromS(Spikes,RipplesBinSize);
        data_decoder = full(Data(Restrict(Q_ForRip,RipplesEpoch)));
        %         Spikes_test = Spikes_test(:,Place_Cells{1}{mm});
        
        % Bayesian decoding
        for t = 1:size(data_decoder,1)
            likelihood = ones(1, size(LinearizeFiring_binned2, 2));
            for n = 1:size(LinearizeFiring_binned2, 1)
                likelihood = likelihood.*(LinearizeFiring_binned2(n, :).^data_decoder(t, n)).* exp(-LinearizeFiring_binned2(n, :));
            end
            posterior = (likelihood.* LinearizePos_time);
            decoded_positions(t, :) = posterior/sum(posterior); % Normalize posterior
        end
        [~, decoded_position_bins] = max(decoded_positions, [], 2);
        
        Decoding_tsd = tsd(Range(Restrict(Q_ForRip,RipplesEpoch)) , decoded_position_bins);
        
        [M,T] = PlotRipRaw(Decoding_tsd,Range(Restrict(Ripples , FreezeSafe),'s'),400,0,0,0);
        RipPred{bb}{mm} = T;
        
        %         NumberNeurons(mm) = size(Spikes_test,2);
        
        disp(mm)
    end
end


MnRipResp = [];
for mm = 1:length(mice_PAG_neurons)
    
    RipPred2{bb}{mm} = RipPred{bb}{mm};
    RipPred2{1}{mm}(RipPred2{1}{mm}==0)=NaN;
    TrigData = nanmean((RipPred2{bb}{mm}));
    MnRipResp = [MnRipResp;TrigData];
    
end

figure
plot(MnRipResp')

figure
plot(nanmean(MnRipResp))







































%% Multiclass - nearest neighbour
%% Multiclass - nearest neighbour
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
        TrainEpisodes = randperm(NumEpisodes,floor(NumEpisodes*0.8));
%         TrainEpisodes = randperm(NumEpisodes,NumEpisodes);
        %         TrainEpisodes2 = randperm(NumEpisodes,NumEpisodes);
        TrainEpoch = subset(TotalEpoch,sort(TrainEpisodes));
        %         TrainEpoch2 = subset(TotalEpoch,sort(TrainEpisodes2));
        TestEpoch = TotalEpoch - TrainEpoch;
        %         clear St, St = Start(TotalEpoch);
        %         TestEpoch = and(TotalEpoch , intervalSet(St(1)+10*60e4,St(1)+20*60e4));
        
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
            Spikes_train_balanced(n,:) = nanmean(Spikes_train(Class1(1:end),:),1);
%             Spikes_train_balanced(n,:) = nanmean(Spikes_train(Class1(1:MinLong),:),1);
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
        
%         fig = figure;
%         fig.Name = num2str(mice_PAG_neurons(mm));
%         [val{mm},ind] = sort(LinPos_test);
%         hold on
%         plot(Pos_Prediction{mm}(ind),'color','c')
%         plot(runmean(Pos_Prediction{mm}(ind),5),'color','b')
%         plot(val{mm},'color','k','linewidth',3)
%         title([num2str(size(Spikes_test,2)) ' neur - movement'])
%         ylabel('Position (decoded or real)')
%         
%         [Corr_Test(bb,mm), pVal_Test(bb,mm)] = corr(val{mm} , runmean(Pos_Prediction{mm}(ind),5));

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
        [M,T] = PlotRipRaw(RipPred_tsd,Range(Restrict(Ripples,FreezeSafe),'s'),400,0,0,0);
        RipPred{bb}{mm} = T;
        [M_rip,T] = PlotRipRaw(LinPos,Range(Restrict(Ripples,FreezeSafe),'s'),400,0,0,0);
        Realpos_Rip{bb}{mm} = T;
        
        NumberNeurons(mm) = size(Spikes_test,2);
        
        disp(mm)
    end
end





MnRipResp = [];
for mm = 1:length(mice_PAG_neurons)
    
    RipPred2{bb}{mm} = RipPred{bb}{mm};
    RipPred2{1}{mm}(RipPred2{1}{mm}==0)=NaN;
    TrigData = nanmean((RipPred2{bb}{mm}));
    MnRipResp = [MnRipResp;TrigData];
    
end

figure
plot(MnRipResp')

figure
plot(nanmean(MnRipResp))

figure
plot(MnRipResp'-nanmean(MnRipResp(:,1:2)'))

figure
plot(nanmean((MnRipResp'-nanmean(MnRipResp(:,[1 17])'))'))



%% 10 time nearest neighbour
%% Multiclass - nearest neighbour
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



