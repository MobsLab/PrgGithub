clear all
mm=0;
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep';
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/';
cols = lines(5);
RemoveDown = 0;
Binsize = 2*1e4;
figure(2)
clf

for m = 1 : mm
    cd(FileName{m})
    load('SleepSubstages.mat')
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    S = S(numNeurons);
    
    Q = MakeQfromS(S,Binsize);
    
    if RemoveDown
        
        % Arrange everything (downstates and sleep epochs) with the right bins
        load('DownState.mat')
        
        load('LFPData/LFP1.mat')
        AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
        tps = Range(LFP);
        
        % Downs
        timeEvents = Data(Restrict(AllTime,alldown_PFCx));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,Binsize);
        QDown = tsd(Range(QEvents),Data(QEvents)/(1250*Binsize/1e4)); % divide by number of bins in 2seconds
        DatQ = Data(Q);
        for sp = 1:length(numNeurons)
            DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
        end
        Q = tsd(Range(Q),DatQ);
        
    end
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    subplot(3,mm,m)
    
    clear Vals
    for f = 1:2
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        if f==2
            if sign(nanmean(Data(Restrict(Ftsd,Epoch{4}))))==-1
                Ftsd = tsd(Range(Q),(-EigVect(:,f)'*Qref')');
            end
        end
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    
    for ep = 1:5
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    
    for ep = 1:5
        PC1tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,Epoch{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    axis tight
    title([num2str(length(EigVals)) ' units'])
    
    subplot(3,mm,mm+m)
    plot(100*cumsum(EigVals)/sum(EigVals),'-','linewidth',3)
    xlabel('PC number')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    xlabel('PC number')
    ylabel('% var explaine')
    
    subplot(3,mm,2*mm+m)
    clear DistBetweenCentres AllData TotDist DistBetweenCentresMean TotDistMean
    for f = 1 :length(EigVals)
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        for ep = 1:5
            AllData{ep} = (Data(Restrict(Ftsd,Epoch{ep})));
        end
        for ep =1:5
            for ep2=1:5
                [D] = pdist2( AllData{ep}, AllData{ep2},'squaredeuclidean');
                DistBetweenCentres(f,ep,ep2) =     nanmean(nanmean(D));
                [D] = pdist2( nanmean(AllData{ep}), nanmean(AllData{ep2}),'squaredeuclidean');
                DistBetweenCentresMean(f,ep,ep2) =     D;
                
            end
        end
    end
    
    QZ = tsd(Range(Q),Qref);
    for ep =1:5
        for ep2=1:5
            [D] = pdist2( (Data(Restrict(QZ,Epoch{ep}))),(Data(Restrict(QZ,Epoch{ep2}))),'squaredeuclidean');
            TotDist(ep,ep2) =     nanmean(nanmean(D));
            [D] = pdist2( nanmean(Data(Restrict(QZ,Epoch{ep}))),nanmean(Data(Restrict(QZ,Epoch{ep2}))),'squaredeuclidean');
            TotDistMean(ep,ep2) = D;
            
        end
    end
    
    IntraStateDist = sum(diag(TotDist));
    InterStateDist = sum((tril(TotDist(:))))-IntraStateDist;
    
    for f = 1 :length(EigVals)
        LocDist = squeeze(DistBetweenCentres(f,:,:));
        IntraStateDistPC(f) = sum(diag(LocDist));
        InterStateDistPC(f) = sum((tril(LocDist(:))))- IntraStateDistPC(f) ;
    end
    bar(100*(InterStateDistPC/InterStateDist-IntraStateDistPC/IntraStateDist))
    xlim([0 20])
    ylabel('% interstate vs intrastate expl VAR')
    
    yyaxis right
    InterStateDist = sum((tril(TotDistMean(:))));
    for f = 1 :length(EigVals)
        LocDist = squeeze(DistBetweenCentresMean(f,:,:));
        InterStateDistPC(f) = sum((tril(LocDist(:))));
    end
    plot(100*cumsum(InterStateDistPC/InterStateDist),'.-','linewidth',2)
    ylim([0 100])
    ylabel('% interstate dist expl MEAN')
    xlabel('PC number')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    
    
    
end


%%
clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/PCADifferentStates/';
cols = lines(5);
RemoveDown = 0;
Binsize = 2*1e4;
figure(2)
clf

for m = 17 : length(Dir.path)
    clear S Epoch
    clf
    cd(Dir.path{m})
    load('SleepSubstages.mat')
    load('SpikeData.mat')
    try,S = tsdArray(S);end
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    S = S(numNeurons);
    
    Q = MakeQfromS(S,Binsize);
    
    if RemoveDown
        
        % Arrange everything (downstates and sleep epochs) with the right bins
        load('DownState.mat')
        
        load('LFPData/LFP1.mat')
        AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
        tps = Range(LFP);
        
        % Downs
        timeEvents = Data(Restrict(AllTime,alldown_PFCx));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,Binsize);
        QDown = tsd(Range(QEvents),Data(QEvents)/(1250*Binsize/1e4)); % divide by number of bins in 2seconds
        DatQ = Data(Q);
        for sp = 1:length(numNeurons)
            DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
        end
        Q = tsd(Range(Q),DatQ);
        
    end
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    subplot(1,3,1)
    
    clear Vals
    for f = 1:2
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        if f==2
            if sign(nanmean(Data(Restrict(Ftsd,Epoch{4}))))==-1
                Ftsd = tsd(Range(Q),(-EigVect(:,f)'*Qref')');
            end
        end
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    
    for ep = 1:5
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    
    for ep = 1:5
        PC1tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,Epoch{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    axis tight
    title([num2str(length(EigVals)) ' units'])
    
    subplot(2,3,2)
    plot(100*cumsum(EigVals)/sum(EigVals),'-','linewidth',3)
    xlabel('PC number')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    xlabel('PC number')
    ylabel('% var explained')
    title('PCA on all data')
    
    AllMicePCA.EigVals{m} = EigVals;
    
    subplot(2,3,5)
    clear DistBetweenCentres AllData TotDist DistBetweenCentresMean TotDistMean InterStateDistPCMean InterStateDistPCMean
    clear InterStateDistPC InterStateDist IntraStateDistPC IntraStateDist
    
    for f = 1 :length(EigVals)
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        for ep = 1:5
            AllData{ep} = (Data(Restrict(Ftsd,Epoch{ep})));
        end
        for ep =1:5
            for ep2=1:5
                [D] = pdist2( AllData{ep}, AllData{ep2},'squaredeuclidean');
                DistBetweenCentres(f,ep,ep2) =     nanmean(nanmean(D));
                [D] = pdist2( nanmean(AllData{ep}), nanmean(AllData{ep2}),'squaredeuclidean');
                DistBetweenCentresMean(f,ep,ep2) =     D;
                
            end
        end
    end
    
    QZ = tsd(Range(Q),Qref);
    for ep =1:5
        for ep2=1:5
            [D] = pdist2( (Data(Restrict(QZ,Epoch{ep}))),(Data(Restrict(QZ,Epoch{ep2}))),'squaredeuclidean');
            TotDist(ep,ep2) =     nanmean(nanmean(D));
            [D] = pdist2( nanmean(Data(Restrict(QZ,Epoch{ep}))),nanmean(Data(Restrict(QZ,Epoch{ep2}))),'squaredeuclidean');
            TotDistMean(ep,ep2) = D;
            
        end
    end
    
    IntraStateDist = sum(diag(TotDist));
    InterStateDist = sum((tril(TotDist(:))))-IntraStateDist;
    
    for f = 1 :length(EigVals)
        LocDist = squeeze(DistBetweenCentres(f,:,:));
        IntraStateDistPC(f) = sum(diag(LocDist));
        InterStateDistPC(f) = sum((tril(LocDist(:))))- IntraStateDistPC(f) ;
    end
    bar(100*(InterStateDistPC/InterStateDist-IntraStateDistPC/IntraStateDist))
    xlim([0 20])
    ylabel('% interstate vs intrastate expl VAR')
    
    AllMicePCA.InterStateDistPC{m} = InterStateDistPC;
    AllMicePCA.InterStateDist{m} = InterStateDist;
    AllMicePCA.IntraStateDistPC{m} = IntraStateDistPC;
    AllMicePCA.IntraStateDist{m} = IntraStateDist;
    
    
    yyaxis right
    InterStateDistMean = sum((tril(TotDistMean(:))));
    for f = 1 :length(EigVals)
        LocDist = squeeze(DistBetweenCentresMean(f,:,:));
        InterStateDistPCMean(f) = sum((tril(LocDist(:))));
    end
    plot(100*cumsum(InterStateDistPCMean/InterStateDistMean),'.-','linewidth',2)
    ylim([0 100])
    ylabel('% interstate dist expl MEAN')
    xlabel('PC number')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    title('Relation of PCs to sleep states')
    
    AllMicePCA.InterStateDistPCMean{m} = InterStateDistPCMean;
    AllMicePCA.InterStateDistMean{m} = InterStateDistMean;
    
    %% State by State PCA
    subplot(2,3,3)
    clear EigVectState EigValsState
    QZ = tsd(Range(Q),Qref);
    Epoch{6} = or(Epoch{1},or(Epoch{2},Epoch{3}));
    Epoch{7} = or(or(Epoch{1},or(Epoch{2},Epoch{3})),Epoch{4});
    for ep =1:7
        DataAmount(ep) = size(Data(Restrict(QZ,Epoch{ep}))',2);
    end
    for ep =1:7
        dattemp = Data(Restrict(QZ,Epoch{ep}))';
        reorder = randperm(size(dattemp,2)); reorder = reorder(1:min(DataAmount));
        dattemp = dattemp(:,reorder);
        [EigVectState{ep},EigValsState{ep}]=PerformPCA(dattemp);
        plot(cumsum(EigValsState{ep})/sum(EigValsState{ep}),'-','linewidth',3)
        hold on
    end
    NameEpoch{6} = 'NREM';
    NameEpoch{7} = 'Sleep';
    legend(NameEpoch(1:7))
    ylabel('% var exp')
    xlabel('PC number')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    title('PCA on each state')
    
    subplot(2,3,6)
    for ep =1:7
        for ep2 = 1:7
            dattemp = Data(Restrict(QZ,Epoch{ep}))';
            reorder = randperm(size(dattemp,2)); reorder = reorder(1:min(DataAmount));
            dattemp = dattemp(:,reorder);
            clear allfactPC allfact
            for f= 1:length(EigValsState{ep})
                allfactPC(f) = sum((EigVectState{ep2}(:,f)'*dattemp).^2);
            end
            VarExp(ep,ep2) = nansum(allfactPC(1:5))./nansum(allfactPC);
        end
        
    end
    AllMicePCA.EigVectStateByState{m} = EigValsState;
    AllMicePCA.VarExpBetweenStateByState{m} = VarExp;
    
    for ep =1:7
        VarExp(ep,:) = VarExp(ep,:)./nanmean(VarExp(ep,ep));
    end
    imagesc(VarExp([1,2,3,6,7,4,5],[1,2,3,6,7,4,5]))
    set(gca,'XTick',[1:7],'XTickLabel',NameEpoch([1,2,3,6,7,4,5]),'YTick',[1:7],'YTickLabel',NameEpoch([1,2,3,6,7,4,5]))
    axis xy
    xlabel('PCA target')
    ylabel('PCA source')
    title('Var expalined first 5 PCs')
    set(gca,'FontSize',11,'linewidth',2)
    colorbar
    
    saveas(2,[FolderName 'PCASleepStates',num2str(m),'.png'])
end
figure
for ep =1:7
    subplot(4,2,ep)
    for m = 1:20
        vals = AllMicePCA.EigVectStateByState{m}{ep};
        vals = cumsum(vals)/sum(vals);
        plot([1:length(AllMicePCA.EigVectStateByState{m}{ep})]/length(AllMicePCA.EigVectStateByState{m}{ep}),vals)
        hold on
    end
end


figure
clf
subplot(121)
clear eigvals
xnew = [1:20]/20;
for ep =1:7
    for m = 1:20
        vals = AllMicePCA.EigVectStateByState{m}{ep};
        vals = cumsum(vals)/sum(vals);
        x=[1:length(AllMicePCA.EigVectStateByState{m}{ep})]/length(AllMicePCA.EigVectStateByState{m}{ep});
        eigvals(m,:) = 100*interp1(x,vals,xnew);
    end
    eigvals(18,:)= [];
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
    hold on
end
set(gca,'FontSize',11,'linewidth',2)
box off
xlabel('PC number - norm to 1')
ylabel('% Var expl')
ylim([0 100])
title('AllPCs')

subplot(122)
clear eigvals
xnew = [1:10];
for ep =1:7
    for m = 1:20
        vals = AllMicePCA.EigVectStateByState{m}{ep};
        vals = cumsum(vals(1:10))/sum(vals);
        eigvals(m,:) = 100*vals;
    end
    eigvals(18,:)= [];
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
    hold on
end
legend(NameEpoch(1:7),'Location','NorthWest')
set(gca,'FontSize',11,'linewidth',2)
box off
xlabel('PC number')
ylabel('% Var expl')
ylim([0 100])
title('First 10 PCs')


%%
figure
clf
subplot(121)

clear eigvals
xnew = [1:20]/20;
    for m = 1:20
        vals = AllMicePCA.EigVals{m};
        vals = cumsum(vals)/sum(vals);
        x=[1:length(AllMicePCA.EigVals{m})]/length(AllMicePCA.EigVals{m});
        eigvals(m,:) = 100*interp1(x,vals,xnew);
    end
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
    hold on
set(gca,'FontSize',11,'linewidth',2)
box off
xlabel('PC number - norm to 1')
ylabel('% Var expl')
ylim([0 100])
title('AllPCs')

subplot(122)
clear eigvals
xnew = [1:10];
    for m = 1:20
        vals = AllMicePCA.EigVals{m};
        vals = cumsum(vals(1:10))/sum(vals);
        eigvals(m,:) = 100*vals;
    end
    eigvals(18,:)= [];
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
    hold on
set(gca,'FontSize',11,'linewidth',2)
box off
xlabel('PC number')
ylabel('% Var expl')
ylim([0 100])
title('First 10 PCs')




figure
clf

% All data points
clear eigvals
xnew = [1:20]/20;
for m = 1:20
    vals = AllMicePCA.EigVals{m};
    vals = cumsum(vals)/sum(vals);
    x=[1:length(AllMicePCA.EigVals{m})]/length(AllMicePCA.EigVals{m});
    eigvals(m,:) = 100*interp1(x,vals,xnew);
end
errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
hold on

clear eigvals
xnew = [1:20]/20;
for m = 1:20
    vals = AllMicePCA.IntraStateDistPC{m};
    vals = cumsum(vals)/sum(vals);
    x=[1:length(AllMicePCA.EigVals{m})]/length(AllMicePCA.EigVals{m});
    eigvals(m,:) = 100*interp1(x,vals,xnew);
end
errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
hold on

clear eigvals
xnew = [1:20]/20;
for m = 1:20
    vals = AllMicePCA.InterStateDistPC{m};
    vals = cumsum(vals)/sum(vals);
    x=[1:length(AllMicePCA.EigVals{m})]/length(AllMicePCA.EigVals{m});
    eigvals(m,:) = 100*interp1(x,vals,xnew);
end
errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
hold on

clear eigvals
xnew = [1:20]/20;
for m = 1:20
    vals = AllMicePCA.InterStateDistPCMean{m};
    vals = cumsum(vals)/sum(vals);
    x=[1:length(AllMicePCA.EigVals{m})]/length(AllMicePCA.EigVals{m});
    eigvals(m,:) = 100*interp1(x,vals,xnew);
end
errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2)
hold on

legend('All','Intra','Inter','Mean')

set(gca,'FontSize',11,'linewidth',2)
box off
xlabel('PC number - norm to 1')
ylabel('% Var expl')
ylim([0 100])
title('AllPCs')

%%
for m = 1:20
    VarExpTemp = AllMicePCA.VarExpBetweenStateByState{m};
    for k = 1:7
        VarExpTemp(k,:) = VarExpTemp(k,:)./VarExpTemp(k,k);
    end
        imagesc(VarExpTemp([1,2,3,6,7,4,5],[1,2,3,6,7,4,5]))
pause

    VarExpAv(m,:,:) = VarExpTemp;
end
VarExpAv(18,:,:) = [];

figure
A = 100*(squeeze(nanmean(VarExpAv)));
imagesc(A([1,2,3,6,7,4,5],[1,2,3,6,7,4,5]))
set(gca,'XTick',[1:7],'XTickLabel',NameEpoch([1,2,3,6,7,4,5]),'YTick',[1:7],'YTickLabel',NameEpoch([1,2,3,6,7,4,5]))
axis xy
xlabel('PCA target')
ylabel('PCA source')
title('Var expalined first 5 PCs')
set(gca,'FontSize',11,'linewidth',2)
colorbar

figure
clf
for k = 1:7
    subplot(3,3,k)
    PlotErrorBarN_KJ(100*squeeze(VarExpAv(:,k,[1,2,3,6,7,4,5])),'newfig',0)
    set(gca,'XTick',[1:7],'XTickLabel',NameEpoch([1,2,3,6,7,4,5]))
    title(NameEpoch(k))
    ylabel('% var explained norm')
    set(gca,'FontSize',11,'linewidth',2)
end


%%
%%
clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/PCADifferentStates/';
cols = lines(5);
RemoveDown = 0;
Binsize = 2*1e4;
figure(2)
clf

for m = 1 : length(Dir.path)
    clear S Epoch
    cd(Dir.path{m})
    load('SleepSubstages.mat')
    load('SpikeData.mat')
    try,S = tsdArray(S);end
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    S = S(numNeurons);
    
    Q = MakeQfromS(S,Binsize);
    
    if RemoveDown
        
        % Arrange everything (downstates and sleep epochs) with the right bins
        load('DownState.mat')
        
        load('LFPData/LFP1.mat')
        AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
        tps = Range(LFP);
        
        % Downs
        timeEvents = Data(Restrict(AllTime,alldown_PFCx));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,Binsize);
        QDown = tsd(Range(QEvents),Data(QEvents)/(1250*Binsize/1e4)); % divide by number of bins in 2seconds
        DatQ = Data(Q);
        for sp = 1:length(numNeurons)
            DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
        end
        Q = tsd(Range(Q),DatQ);
        
    end
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    subplot(4,5,m)
    
    clear Vals
    for f = 1:2
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        if f==2
            if sign(nanmean(Data(Restrict(Ftsd,Epoch{4}))))==-1
                Ftsd = tsd(Range(Q),(-EigVect(:,f)'*Qref')');
            end
        end
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    
    for ep = 1:5
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    
    for ep = 1:5
        PC1tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,Epoch{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',11,'linewidth',2)
    axis tight
    title([Dir.name{m} ' - ' num2str(length(EigVals)) ' units'])
end