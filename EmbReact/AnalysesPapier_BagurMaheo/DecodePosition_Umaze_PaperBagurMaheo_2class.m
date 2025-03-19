clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
DiffBinSizes = [0.02,0.05,0.1,0.2];
Thresh_TrainSet = [0.3 0.7];
Thresh = 0.5;
TimeAroundRipples = 600;
DoZscore =1;
JustPlaceCells = 0;
if JustPlaceCells
    load('PlaceCellInfo.mat')
end

%% Shock vs safe decoder
for bb = 1:length(DiffBinSizes)
    bb
    Binsize = DiffBinSizes(bb)*1e4;
    mousenum = 0;
    
    for mm=1:length(mice_PAG_neurons)
        if JustPlaceCells
            if isfield(Place_Cells{1},['Mouse' num2str(mice_PAG_neurons(mm))])
                go = 1;
            else go=0;
            end
        else
            go=1;
        end
        
        if go==1
            mousenum = mousenum +1;
            load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(mice_PAG_neurons(mm)),'.mat'])
            
            % Get test and train epochs
            Ripples = Restrict(Ripples,and(thresholdIntervals(LinPos,0.6,'Direction','Above'),FreezeEpoch));
            RipplesEpoch = intervalSet(Range(Ripples)-TimeAroundRipples*10*1.5,Range(Ripples)+TimeAroundRipples*10*1.5);
            RipplesEpoch = mergeCloseIntervals(RipplesEpoch,0.5*1e4);
            RipplesEpoch = CleanUpEpoch(RipplesEpoch);
            
            TotalEpoch = MovEpoch - or(FreezeEpoch,RipplesEpoch);
            NumEpisodes = length(Start(TotalEpoch));
            TrainEpisodes = randperm(NumEpisodes,floor(0.8*NumEpisodes));
            TrainEpoch = subset(TotalEpoch,sort(TrainEpisodes));
            TestEpoch = TotalEpoch - TrainEpoch;
            
            %% Train data
            Q = MakeQfromS(Spikes,Binsize);
            if DoZscore
                Q = tsd(Range(Q),zscore(Data(Q)));
            end
            
            if JustPlaceCells
                ToKeep = find(Place_Cells{1}.(['Mouse' num2str(mice_PAG_neurons(mm))])>0.5);
                datQ = Data(Q);
                Q = tsd(Range(Q),datQ(:,ToKeep));
            end
            
            
            Spikes_train = full(Data(Restrict(Q,TrainEpoch)));
            LinPos_train = Data(Restrict(LinPos,ts(Range(Restrict(Q,TrainEpoch)))));
            
            % Balance train data
            Class1 = find(LinPos_train>Thresh_TrainSet(2));
            Shuffle_Class1 = randperm(length(Class1),length(Class1));
            Class1 = Class1(Shuffle_Class1);
            Class2 = find(LinPos_train<Thresh_TrainSet(1));
            Shuffle_Class2 = randperm(length(Class2),length(Class2));
            Class2 = Class2(Shuffle_Class2);
            MinLong = min([length(Class1),length(Class2)]);
            LinPos_train = [LinPos_train(Class1(1:MinLong));LinPos_train(Class2(1:MinLong))];
            LinPos_train_discr = LinPos_train>Thresh;
            Spikes_train = [Spikes_train(Class1(1:MinLong),:);Spikes_train(Class2(1:MinLong),:)];
            
            % Do training
            classifier_2way = fitcsvm(Spikes_train,LinPos_train_discr,'ClassNames',[0,1]);
            [prediction_train,scores_train] = predict(classifier_2way,Spikes_train);
            Accuracy_Train(bb,mousenum) = nanmean(prediction_train == LinPos_train_discr);
            
            f = polyfit(scores_train(:,2),LinPos_train,1);
            PredictPosition_train{bb,mousenum}  = polyval(f,scores_train(:,2));
            RealPosition_train{bb,mousenum}  = LinPos_train;
            
            % Add NL - piecewise linearitty
            clear yhat yhat1 yhat2 yhat_new
            x = LinPos_train;
            yhat =  PredictPosition_train{bb,mousenum};
            slope = x(yhat<0.5)\yhat(yhat<0.5);
            p1 = [slope,0];
            yhat1 = polyval(p1,yhat(yhat<0.5));
            slope = x(yhat>=0.5)\yhat(yhat>=0.5);
            p2 = [slope,0];
            yhat2 = polyval(p2,yhat(yhat>=0.5));
            yhat_new = yhat;
            yhat_new(yhat<0.5) = yhat1;
            yhat_new(yhat>=0.5) = yhat2;
            
            Accuracy_Train_Nl(bb,mousenum) = nanmean(yhat_new>0.5 == LinPos_train_discr);
            PredictPosition_train_Nl{bb,mousenum}  = yhat_new;

            
            %% Test data
            Spikes_test = full(Data(Restrict(Q,TestEpoch)));
            LinPos_test = Data(Restrict(LinPos,ts(Range(Restrict(Q,TestEpoch)))));
            LinPos_test_discr = LinPos_test>Thresh;
            
            % Do test
            [prediction_test,scores_test] = predict(classifier_2way,Spikes_test);
            
            PredictPosition_test{bb,mousenum}  = polyval(f,scores_test(:,2));
            RealPosition_test{bb,mousenum}  = LinPos_test;
            %
            %         fig = figure;
            %         fig.Name = num2str(mice_PAG_neurons(mm));
            %         subplot(211)
            %         [val,ind] = sort(LinPos_train);
            %         plot(val)
            %         hold on
            %         plot(runmean(prediction_train(ind),1))
            %
            %         subplot(212)
            %         [val,ind] = sort(LinPos_test_discr);
            %         plot(val)
            %         hold on
            %         plot(runmean(prediction_test(ind),1))
            
            Accuracy_Test(bb,mousenum) = nanmean(prediction_test == LinPos_test_discr);
            
            % Add NL - piecewise linearitty
            clear yhat yhat1 yhat2 yhat_new
            yhat =  PredictPosition_test{bb,mousenum};
            yhat1 = polyval(p1,yhat(yhat<0.5));
            yhat2 = polyval(p2,yhat(yhat>=0.5));
            yhat_new = yhat;
            yhat_new(yhat<0.5) = yhat1;
            yhat_new(yhat>=0.5) = yhat2;
            Accuracy_Test_Nl(bb,mousenum) = nanmean(yhat_new>0.5 - LinPos_test_discr);
            PredictPosition_test_NL{bb,mousenum}  = yhat_new;
            
            %% Visualize the quality of the fit
            Spikes_full = full(Data(Restrict(Q,TotalEpoch)));
            LinPos_full = Data(Restrict(LinPos,ts(Range(Restrict(Q,TotalEpoch)))));
            [prediction_full,scores_full] = predict(classifier_2way,Spikes_full);
                        PredictPosition_full{bb,mousenum}  = polyval(f,scores_full(:,2));

            clear yhat yhat1 yhat2 yhat_new
            yhat =  PredictPosition_full{bb,mousenum};
            yhat1 = polyval(p1,yhat(yhat<0.5));
            yhat2 = polyval(p2,yhat(yhat>=0.5));
            yhat_new = yhat;
            yhat_new(yhat<0.5) = yhat1;
            yhat_new(yhat>=0.5) = yhat2;
            PredictPosition_full_NL{bb,mousenum}  = yhat_new;
            RealPosition_full{bb,mousenum}  = LinPos_full;

            
            %% Tie to ripples
            % RipplesData
            Spikes_test = full(Data(Restrict(Q,RipplesEpoch)));
            
            clear Class_prediction_ripplestriggered
            [prediction_rip,scores_rip] = predict(classifier_2way,Spikes_test);
            rip_predictpos  = polyval(f,scores_rip(:,2));

                                    
            RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),prediction_rip);
            [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
            RipPred_Bin{bb,mousenum}  = T;
            RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),scores_rip(:,2));
            [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
            RipPred_Score{bb,mousenum}  = nanmean(T);
            
            RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),rip_predictpos);
            [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
            RipPred_Pos{bb,mousenum}  = T;
            
            % Add NL - piecewise linearitty
            clear yhat yhat1 yhat2 yhat_new
            yhat = rip_predictpos;
            yhat1 = polyval(p1,yhat(yhat<0.5));
            yhat2 = polyval(p2,yhat(yhat>=0.5));
            yhat_new = yhat;
            yhat_new(yhat<0.5) = yhat1;
            yhat_new(yhat>=0.5) = yhat2;
            RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),yhat_new);
            [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
            RipPred_Pos_Nl{bb,mousenum}  = T;
            
            
        end
       NumNeurons(mm) = size(Spikes,1);
    end
end


% Guessed position
figure
for bb = 1:length(DiffBinSizes)
    AllRip = [];
        AllRip_NL = [];

    for mm=1:length(mice_PAG_neurons)
        lgrip(mm) = length(nanmean(RipPred_Pos{bb,mm}) );
    end
    for mm=1:length(mice_PAG_neurons)
        
        AllRip = [AllRip; nanmean(RipPred_Pos{bb,mm}(:,1:min(lgrip)),1)];
    end
    
%     for mm=1:length(RipPred_Pos_Nl)
%         
%         AllRip_NL = [AllRip_NL; nanmean(RipPred_Pos_Nl{bb,mm}(:,1:min(lgrip)),1)];
%     end
%     GoodMice = Accuracy_Train_Nl(bb,:) > 0.5;
%     AllRip = AllRip(GoodMice,:);
    subplot(2,2,bb)
    tps = [DiffBinSizes(bb):DiffBinSizes(bb):size(AllRip,2)*DiffBinSizes(bb)]-(size(AllRip,2)*DiffBinSizes(bb))/2;
    plot(tps,AllRip','color',[0.6 0.6 0.6])
    hold on
    plot(tps,...
        nanmean(AllRip),'color','k','linewidth',3)
    xlabel('Time to ripples (s)')
    title(['Binsize = ' num2str(DiffBinSizes(bb))])
    ylabel('Predicted position')
    makepretty
    ylim([0 1])
    
end



% Binned position
figure
for bb = 1:length(DiffBinSizes)
    AllRip = [];
    for mm=1:length(mice_PAG_neurons)
        lgrip(mm) = length(nanmean(RipPred_Bin{bb,mm}) );
    end
    for mm=1:length(mice_PAG_neurons)
        
        AllRip = [AllRip; nanmean(RipPred_Bin{bb,mm}(:,1:min(lgrip)),1)];
    end
    subplot(2,2,bb)
    tps = [DiffBinSizes(bb):DiffBinSizes(bb):size(AllRip,2)*DiffBinSizes(bb)]-(size(AllRip,2)*DiffBinSizes(bb))/2;
    plot(tps,AllRip','color',[0.6 0.6 0.6])
    hold on
    plot(tps,...
        nanmean(AllRip),'color','k','linewidth',3)
    xlabel('Time to ripples (s)')
    title(['Binsize = ' num2str(DiffBinSizes(bb))])
    ylabel('Proabbility of being in safe')
    makepretty
    ylim([0 1])
    
end





figure

for bb = 1:length(DiffBinSizes)
    AllRip = [];
    for mm=1:length(mice_PAG_neurons)
        lgrip(mm) = length(nanmean(RipPred_Bin{bb,mm}) );
    end
    clear Y
    for mm=1:length(mice_PAG_neurons)
        dat_temp = RipPred_Pos_Nl{bb,mm}(:,1:min(lgrip));
        for binid = 1:size(dat_temp,2)
            [Y(mm,binid,:),X] =   hist(dat_temp(:,binid),[0.05:0.1:1]);
            Y(mm,binid,:) = Y(mm,binid,:)/sum(Y(mm,binid,:));
        end
    end
    subplot(2,2,bb)
    tps = [DiffBinSizes(bb):DiffBinSizes(bb):size(dat_temp,2)*DiffBinSizes(bb)]-(size(dat_temp,2)*DiffBinSizes(bb))/2;
    imagesc(tps,[0.05:0.1:1],squeeze(mean(Y,1))')
    hold on
    
    xlabel('Time to ripples (s)')
    title(['Binsize = ' num2str(DiffBinSizes(bb))])
    ylabel('Maze position'), axis xy
    makepretty
    
end


cd('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/')
save('2classdecoder_ShockVsSafe_HPC_WithNL.mat',...
    'Accuracy_Train','PredictPosition_train','RealPosition_train','PredictPosition_test','RealPosition_test','Accuracy_Test','RipPred_Bin','RipPred_Score','RipPred_Pos',...
    'RipPred_Pos_Nl','Accuracy_Test_Nl','Accuracy_Train_Nl')




mousenum = 4;

%%%
plot(RealPosition_full{bb,mousenum},'linewidth',3,'color','k')
hold on
plot(runmean(PredictPosition_full{bb,mousenum},20))








