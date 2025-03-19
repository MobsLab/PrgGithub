clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir = PathForExperimentsSleepRipplesSpikes('Basal')
cols = lines(6);

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    % Load LFP to get time right
    load('LFPData/LFP1.mat')
    AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
    tps = Range(LFP);
    
    % Get the neurons from the PFCx
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    try,S = tsdArray(S);end
    S = S(numNeurons);
    S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
    Q = MakeQfromS(S,Binsize);
    % DatQ = zscore(Data(Q));
    % Q = tsd(Range(Q),DatQ);
    
    % Arrange everything (downstates and sleep epochs) with the right bins
    load('DownState.mat')
    
    % Downs
    timeEvents = Data(Restrict(AllTime,down_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    DatQ = Data(Q);
    for sp = 1:length(numNeurons)
        DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
    end
    Q_downcorr = tsd(Range(Q),DatQ);
    
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    clear Vals
    [aft_cell,bef_cell]=transEpoch(Epoch{1},Epoch{5});
    N1NearWake = or(aft_cell{1,2},bef_cell{1,2})
    
    EpochNew{1} = Epoch{3}; %N3
    EpochNew{2} = Epoch{2}; %N2
    EpochNew{3} = N1NearWake; %N1-wk
    EpochNew{4} = Epoch{1}-N1NearWake; %N1-sl
    EpochNew{5} = Epoch{4}; %REM
    EpochNew{6} = Epoch{5}; %Wake
    NameEpoch = {'N3','N2','N1wk','N1sl','REM','Wake'};
    
    for ep = 1:6
        timeEvents = Data(Restrict(AllTime,EpochNew{ep}));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,2*1e4);
        dat_temp = Data(QEvents)/2500;
        tps_temp = Range(QEvents);
        tps_temp(dat_temp<0.75) = [];
        CleanedEpoch.(NameEpoch{ep}) = intervalSet(tps_temp,tps_temp+2*1e4);
        Vals.(NameEpoch{ep}) = Data(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Tps.(NameEpoch{ep}) = Range(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Vals_downcorr.(NameEpoch{ep}) = Data(Restrict(Q_downcorr,CleanedEpoch.(NameEpoch{ep})));
    end
    
    
    [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
    [Acc_all_downcorr,Acc_ConfMat_downcorr,MeanW_downcorr] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0);
    [Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);
    [Acc_all_FRContr,Acc_ConfMat_FRContr,MeanW_FRContr] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',1);
    
    % Stronger cross validation - half and half data
    [Acc_all_Half,Acc_ConfMat_Half,MeanW_Half] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0,'crossval_half',1);
    [Acc_all_downcorr_Half,Acc_ConfMat_downcorr_Half,MeanW_downcorr_Half] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0,'crossval_half',1);

    save('SubStageDecodingN1Split.mat','Acc_all','Acc_ConfMat','MeanW',...
        'Acc_all_downcorr','Acc_ConfMat_downcorr','MeanW_downcorr',...
        'Acc_all_Rand','Acc_ConfMat_Rand','MeanW_Rand',...
        'Acc_all_FRContr','Acc_ConfMat_FRContr','MeanW_FRContr','EpochNew',...
        'Acc_all_Half','Acc_ConfMat_Half','MeanW_Half',...
        'Acc_all_downcorr_Half','Acc_ConfMat_downcorr_Half','MeanW_downcorr_Half')
    
    fig = figure;
    set(fig,'Position',[100         -70        1785         996])
    subplot(121)
    plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)
    hold on
    plot(-1,1,'.','color',[1 0.6 0.6],'MarkerSize',20)
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all','newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all_downcorr','newfig',0,'plotcolors',[1 0.6 0.6]), hold on
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all_Half','newfig',0,'plotcolors',[1 0 0]), hold on
    [hl,hp]=boundedline(1:6,nanmean(Acc_all_Rand'),std(Acc_all_Rand'),'alpha','k','transparency',0.2);
    set(hp,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
    set(hl,'Color','none')
    line([1 6],[1 1]/5,'linewidth',4,'color','k','linestyle',':')
    set(gca,'XTickLabel',NameEpoch(1:6),'XTick',[1:6])
    ylim([0 1])
    xlim([0.5 6.5])
    ylabel('Accuracy')
    box off
    set(gca,'FontSize',18,'LineWidth',2)
    set(gca,'XTickLabel',NameEpoch(1:6),'XTick',[1:6])
    h = legend('Classifier','Classifier-DownCorr'), legend boxoff
    title([num2str(length(numNeurons)) ' Neurons'])
    
    subplot(243)
    imagesc(squeeze(nanmean(Acc_ConfMat,3)))
    set(gca,'XTickLabel',NameEpoch(1:6),'XTick',[1:6],'YTickLabel',NameEpoch(1:6),'YTick',[1:6])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.4 1])
    colormap([[0 0 0];plasma(200)])
    title('Population classifier')
    
    subplot(244)
    imagesc(squeeze(nanmean(Acc_ConfMat_FRContr,3)))
    set(gca,'XTickLabel',NameEpoch(1:6),'XTick',[1:6],'YTickLabel',NameEpoch(1:6),'YTick',[1:6])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.4 1])
    colormap([[0 0 0];plasma(200)])
    title('FR classifier')
    
    subplot(224)
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    clear Vals
    for f = 1:2
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        for ep = 1:6
            Vals{ep}(f,:) = Data(Restrict(Ftsd,EpochNew{ep}));
        end
    end
    
    
    for ep = 1:6
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    
    for ep = 1:6
        PC1tsd = tsd(Range(Restrict(Q,EpochNew{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,EpochNew{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,EpochNew{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    
    legend(NameEpoch(1:6))
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    title('PCA')
    annotation('textbox',[.50 0 .2 .06], 'String', cd, 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
    
    saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/FigBilanNSplitMouse',num2str(k),'.png'])
    saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/FigBilanNSplitMouse',num2str(k),'.fig'])
    close all
    
end

%% Load data and compare

clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
    NameEpoch = {'N3','N2','N1wk','N1sl','REM','Wake'};

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    load('SubStageDecodingN1Split.mat')
    Accuracy(k,:) = nanmean(Acc_all');
    Accuracy_down(k,:) = nanmean(Acc_all_downcorr');
    Accuracy_FR(k,:) = nanmean(Acc_all_FRContr');
    Accuracy_Rand(k,:) = nanmean(Acc_all_Rand');
    
    Accuracy_ConfMat(k,:,:) = squeeze(nanmean(Acc_ConfMat,3));
    Accuracy_ConfMat_down(k,:,:) = squeeze(nanmean(Acc_ConfMat_downcorr,3));
    Accuracy_ConfMat_FR(k,:,:) = squeeze(nanmean(Acc_ConfMat_FRContr,3));
    Accuracy_ConfMat_Rand(k,:,:) = squeeze(nanmean(Acc_ConfMat_Rand,3));
    
   
end

fig = figure;
set(fig,'Position',[100         -70        1785         996])
plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)

N1Wake_wake = (Accuracy_ConfMat(:,3,6)+Accuracy_ConfMat(:,6,3))/2;
N1Sleep_wake = (Accuracy_ConfMat(:,6,4)+Accuracy_ConfMat(:,6,4))/2;

[pval,hd] = PlotErrorSpreadN_KJ({N1Sleep_wake,N1Wake_wake},'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
line([1 2],[1 1]/2,'linewidth',4,'color','k','linestyle',':')
ylim([0 1])
xlim([0.5 2.5])
set(gca,'XTick',[1:2],'XTickLabel',{'N1 near wake','N1 near sleep'})
set(gca,'FontSize',18,'LineWidth',2)
ylabel('Accuracy')



fig = figure;
imagesc(squeeze(nanmean(Accuracy_ConfMat,1)))
set(gca,'XTickLabel',NameEpoch(1:6),'XTick',[1:6],'YTickLabel',NameEpoch(1:6),'YTick',[1:6])
axis xy
axis square
h = colorbar,ylabel(h,'Accuracy')
clim([0.4 1])
colormap([[0 0 0];plasma(200)])
title('Pop. classifier')
