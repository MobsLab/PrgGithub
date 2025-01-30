clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
mice_PAG_neurons = [905,911,994,1162,1168,1182,1186,1230];
% 1161 removed?
% 2mice were removed for not having enought data throughout the maze
DiffBinSizes = [0.02,0.05,0.1,0.2];
Thresh_TrainSet = [0.3 0.7];
Thresh = 0.5;
TimeAroundRipples = 600;
DoZscore =0;
LinLimits = [0.00:0.25:1];
%% Shock vs safe decoder
for bb = 1:length(DiffBinSizes)
    bb
    Binsize = DiffBinSizes(bb)*1e4;
    
    for mm=1:length(mice_PAG_neurons)
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
        
        Spikes_train = full(Data(Restrict(Q,TrainEpoch)));
        LinPos_train = Data(Restrict(LinPos,ts(Range(Restrict(Q,TrainEpoch)))));
        
        % Balance train data
        [Y,X] =   histc(LinPos_train,LinLimits);
        Y = Y(1:end-1);
        MinLong = min(Y);
        LinPos_train_reasample = [];
        Spikes_train_reasample = [];
        for ii = 1:length(LinLimits)-1
            Class1 = find(LinPos_train>=LinLimits(ii) & LinPos_train<=LinLimits(ii+1));
            Shuffle_Class1 = randperm(length(Class1),length(Class1));
            Class1 = Class1(Shuffle_Class1);
            
            LinPos_train_reasample = [LinPos_train_reasample;LinPos_train(Class1(1:MinLong))];
            Spikes_train_reasample = [Spikes_train_reasample;Spikes_train(Class1(1:MinLong),:)];
            
        end
        LinPos_train_discr = LinPos_train_reasample>Thresh;
        
        [B,stats] = lasso(Spikes_train_reasample,LinPos_train_reasample,'Alpha',0.5,'Standardize',false,'CV',10);
        coef = B(:,stats.IndexMinMSE);
        coef0 = stats.Intercept(stats.IndexMinMSE);
        yhat = Spikes_train_reasample*coef + coef0;
        
        % Add NL - piecewise linearitty
        x = LinPos_train_reasample;
        slope = x(yhat<0.5)\yhat(yhat<0.5);
        p1 = [slope,0];
        yhat1 = polyval(p1,yhat(yhat<0.5));
        slope = x(yhat>=0.5)\yhat(yhat>=0.5);
        p2 = [slope,0];
        yhat2 = polyval(p2,yhat(yhat>=0.5));
        
        
        
        %% Tie to ripples
        % RipplesData
        Spikes_test = full(Data(Restrict(Q,RipplesEpoch)));
        yrip = Spikes_test*coef + coef0;
        
        
        RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),yrip);
        [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
        RipPred_Bin{bb,mm}  = T;
        
        yrip(yrip<0.5) =  polyval(p1,yrip(yrip<0.5));
        yrip(yrip>=0.5) =  polyval(p2,yrip(yrip>=0.5));
        
        RipPred_tsd = tsd(Range(Restrict(Q,RipplesEpoch)),yrip);
        [M,T] = PlotRipRaw(RipPred_tsd,Range(Ripples,'s'),TimeAroundRipples,0,0,0);
        RipPred_Bin_NL{bb,mm}  = T;
        
    end
end



% Binned position
figure
for bb = 1:length(DiffBinSizes)
    AllRip = [];
    for mm=1:length(mice_PAG_neurons)
        lgrip(mm) = length(nanmean(RipPred_Bin_NL{bb,mm}) );
    end
    for mm=1:length(mice_PAG_neurons)
        
        AllRip = [AllRip; nanmean(RipPred_Bin_NL{bb,mm}(:,1:min(lgrip)),1)];
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
        dat_temp = RipPred_Bin{bb,mm}(:,1:min(lgrip));
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
