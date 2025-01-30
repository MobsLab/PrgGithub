clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir = PathForExperimentsSleepRipplesSpikes('Basal')

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    clearvars -except Dir k ReorderSleepDepth Dir Binsize
    
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
    
    % Downs - correct fr rate for down states
    timeEvents = Data(Restrict(AllTime,down_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    DatQ = Data(Q);
    for sp = 1:length(numNeurons)
        DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown)); % the firing rate is divided not by the binsize but by the total time in up
    end
    Q_downcorr = tsd(Range(Q),DatQ);
    
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    Epoch = Epoch(ReorderSleepDepth);
    NameEpoch = NameEpoch(ReorderSleepDepth);
    
    for ep = 1:5
        timeEvents = Data(Restrict(AllTime,Epoch{ep}));
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
    
    % Random bin cross vlidation
    [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
    [Acc_all_downcorr,Acc_ConfMat_downcorr,MeanW_downcorr] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0);
    
    % Stronger cross validation - half and half data
    [Acc_all_Half,Acc_ConfMat_Half,MeanW_Half] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0,'crossval_half',1);
    [Acc_all_downcorr_Half,Acc_ConfMat_downcorr_Half,MeanW_downcorr_Half] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0,'crossval_half',1);
    
    % Shuffle the id to do random decoding
    [Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);

    % Shuffle the neuron id to use FR alone
    [Acc_all_FRContr,Acc_ConfMat_FRContr,MeanW_FRContr] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',1);
    
    save('SubStageDecoding.mat','Acc_all','Acc_ConfMat','MeanW',...
        'Acc_all_downcorr','Acc_ConfMat_downcorr','MeanW_downcorr',...
        'Acc_all_Rand','Acc_ConfMat_Rand','MeanW_Rand',...
        'Acc_all_FRContr','Acc_ConfMat_FRContr','MeanW_FRContr',...
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
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all_Half','newfig',0,'plotcolors',[1 0.6 1]), hold on
    
    
    [hl,hp]=boundedline(1:5,nanmean(Acc_all_Rand'),std(Acc_all_Rand'),'alpha','k','transparency',0.2);
    set(hp,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
    set(hl,'Color','none')
    line([1 5],[1 1]/5,'linewidth',4,'color','k','linestyle',':')
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
    ylim([0 1])
    xlim([0.5 5.5])
    ylabel('Accuracy')
    box off
    set(gca,'FontSize',18,'LineWidth',2)
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
    h = legend('Classifier','Classifier-DownCorr'), legend boxoff
    title([num2str(length(numNeurons)) ' Neurons'])
    
    subplot(243)
    imagesc(squeeze(nanmean(Acc_ConfMat,3)))
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.4 1])
    colormap([[0 0 0];plasma(200)])
    title('Population classifier')
    
    subplot(244)
    imagesc(squeeze(nanmean(Acc_ConfMat_FRContr,3)))
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.4 1])
    colormap([[0 0 0];plasma(200)])
    title('FR classifier')
    
    subplot(224)
    for ep = 1:5
        Proj{ep} = Vals.(NameEpoch{ep})*squeeze(nanmean(MeanW(3,5,:,:),3));
    end
    Proj{6} = NaN;
    nhist(Proj,'color','summer')
    legend(NameEpoch)
    xlabel('Wake to N3 axis')
    title('Projection onto ''arousal'' axis')
    annotation('textbox',[.50 0 .2 .06], 'String', cd, 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
    
    saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/FigBilanMouse',num2str(k),'.png'])
    saveas(fig,[dropbox '/Mobs_member/SophieBagur/Figures/N1N2N3NeuronFiring/FigBilanMouse',num2str(k),'.fig'])
    close all
    
end

%% Load data and compare

clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir=PathForExperimentsSleepRipplesSpikes('Basal')

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    load('SubStageDecoding.mat')
    Accuracy(k,:) = nanmean(Acc_all');
    Accuracy_down(k,:) = nanmean(Acc_all_downcorr');
    Accuracy_FR(k,:) = nanmean(Acc_all_FRContr');
    Accuracy_Rand(k,:) = nanmean(Acc_all_Rand');
    
    Accuracy_ConfMat(k,:,:) = squeeze(nanmean(Acc_ConfMat,3));
    Accuracy_ConfMat_down(k,:,:) = squeeze(nanmean(Acc_ConfMat_downcorr,3));
    Accuracy_ConfMat_FR(k,:,:) = squeeze(nanmean(Acc_ConfMat_FRContr,3));
    Accuracy_ConfMat_Rand(k,:,:) = squeeze(nanmean(Acc_ConfMat_Rand,3));
    
    for ep = 1:5
        Proj(k,ep) = nanmean(Vals.(NameEpoch{ep})*squeeze(nanmean(MeanW(3,5,:,:),3)));
    end
    
end


fig = figure;
set(fig,'Position',[100         -70        1785         996])
plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)
hold on
plot(-1,1,'.','color',[1 0.6 0.6],'MarkerSize',20)
[pval,hd] = PlotErrorSpreadN_KJ(Accuracy,'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
[pval,hd] = PlotErrorSpreadN_KJ(Accuracy_down,'newfig',0,'plotcolors',[1 0.6 0.6]), hold on
[hl,hp]=boundedline(1:5,nanmean(Accuracy_Rand),1.96*std(Accuracy_Rand),'alpha','k','transparency',0.2);
set(hp,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
set(hl,'Color','none')
line([1 5],[1 1]/5,'linewidth',4,'color','k','linestyle',':')
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
clear p h
for k = 1:5,
    [p(k),h(k)] = signrank(Accuracy(:,k),Accuracy_down(:,k)),
    if p(k)<0.001
        text(k,0.9,'***','FontSize',18)
    elseif  p(k)<0.01
        text(k,0.9,'**','FontSize',18)
    elseif  p(k)<0.05
        text(k,0.9,'*','FontSize',18)
    end
end
ylim([0 1.1])
xlim([0.5 5.5])
ylabel('Accuracy')
box off
set(gca,'FontSize',18,'LineWidth',2)
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
h = legend('Classifier','Classifier-DownCorr'), legend boxoff

fig = figure;
set(fig,'Position',[100         -70        1785         996])
plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)
hold on
plot(-1,1,'.','color',[1 0.6 0.6],'MarkerSize',20)
[pval,hd] = PlotErrorSpreadN_KJ(Accuracy,'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
[pval,hd] = PlotErrorSpreadN_KJ(Accuracy_FR,'newfig',0,'plotcolors',[1 0.6 0.6]), hold on
[hl,hp]=boundedline(1:5,nanmean(Accuracy_Rand),1.96*std(Accuracy_Rand),'alpha','k','transparency',0.2);
set(hp,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
set(hl,'Color','none')
line([1 5],[1 1]/5,'linewidth',4,'color','k','linestyle',':')
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
clear p h
for k = 1:5,
    [p(k),h(k)] = signrank(Accuracy(:,k),Accuracy_FR(:,k)),
    if p(k)<0.001
        text(k,0.9,'***','FontSize',18)
    elseif  p(k)<0.01
        text(k,0.9,'**','FontSize',18)
    elseif  p(k)<0.05
        text(k,0.9,'*','FontSize',18)
    end
end
ylim([0 1.1])
xlim([0.5 5.5])
ylabel('Accuracy')
box off
set(gca,'FontSize',18,'LineWidth',2)
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
h = legend('Popclassif','FRclassif'), legend boxoff

figure
subplot(141)
imagesc(squeeze(nanmean(Accuracy_ConfMat,1)))
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
axis xy
axis square
h = colorbar,ylabel(h,'Accuracy')
clim([0.4 1])
colormap([[0 0 0];plasma(200)])
title('Pop. classifier')

subplot(142)
imagesc(squeeze(nanmean(Accuracy_ConfMat_down,1)))
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
axis xy
axis square
h = colorbar,ylabel(h,'Accuracy')
clim([0.4 1])
colormap([[0 0 0];plasma(200)])
title('Pop. classifier - down corr')

subplot(143)
imagesc(squeeze(nanmean(Accuracy_ConfMat_FR,1)))
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
axis xy
axis square
h = colorbar,ylabel(h,'Accuracy')
clim([0.4 1])
colormap([[0 0 0];plasma(200)])
title('FR classifier')

subplot(144)
imagesc(squeeze(nanmean(Accuracy_ConfMat_Rand,1)))
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
axis xy
axis square
h = colorbar,ylabel(h,'Accuracy')
clim([0.4 1])
colormap([[0 0 0];plasma(200)])
title('Random')

figure
ProjNew = Proj;
for k = 1:size(Proj,1)
   ProjNew(k,:) =  (ProjNew(k,:)-ProjNew(k,end));
   ProjNew(k,:) =  ProjNew(k,:)./(ProjNew(k,1));
end
[pval,hd] = PlotErrorSpreadN_KJ(ProjNew,'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
set(gca,'FontSize',18,'LineWidth',2)
ylabel('N3 to Wake axis projection  - norm')

%% All together
clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir=PathForExperimentsSleepRipplesSpikes('Basal')

for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    clearvars -except Dir k ReorderSleepDepth Dir Binsize Vals Vals_downcorr
    
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
    Epoch = Epoch(ReorderSleepDepth);
    NameEpoch = NameEpoch(ReorderSleepDepth);
    
    for ep = 1:5
        timeEvents = Data(Restrict(AllTime,Epoch{ep}));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,2*1e4);
        dat_temp = Data(QEvents)/2500;
        tps_temp = Range(QEvents);
        tps_temp(dat_temp<0.75) = [];
        CleanedEpoch.(NameEpoch{ep}) = intervalSet(tps_temp,tps_temp+2*1e4);
        Vals{k}.(NameEpoch{ep}) = Data(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Tps.(NameEpoch{ep}) = Range(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
        Vals_downcorr{k}.(NameEpoch{ep}) = Data(Restrict(Q_downcorr,CleanedEpoch.(NameEpoch{ep})));
    end
    
end

for k = 1:length(Dir.path)
    for ep = 1:5
        NumBins(k,ep) = size(Vals{k}.(NameEpoch{ep}),1);
    end
end
MinBinNum = min(NumBins);

for ep = 1:5
    ValsAll.(NameEpoch{ep}) = [];
        ValsAllDown.(NameEpoch{ep}) = [];

    for k = 1:length(Dir.path)
      ValsAll.(NameEpoch{ep}) = [ValsAll.(NameEpoch{ep}),Vals{k}.(NameEpoch{ep})(1:MinBinNum(ep),:)];  
      ValsAllDown.(NameEpoch{ep}) = [ValsAllDown.(NameEpoch{ep}),Vals_downcorr{k}.(NameEpoch{ep})(1:MinBinNum(ep),:)];  

    end
end

ValsSep = Vals
Vals = ValsAll
ValsSepdown = Vals_downcorr
Vals_downcorr = ValsAllDown



    [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
    [Acc_all_downcorr,Acc_ConfMat_downcorr,MeanW_downcorr] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0);
    [Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);
    [Acc_all_FRContr,Acc_ConfMat_FRContr,MeanW_FRContr] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',1);
    
    fig = figure;
    set(fig,'Position',[100         -70        1785         996])
    subplot(121)
    plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)
    hold on
    plot(-1,1,'.','color',[1 0.6 0.6],'MarkerSize',20)
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all','newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
    [pval,hd] = PlotErrorSpreadN_KJ(Acc_all_downcorr','newfig',0,'plotcolors',[1 0.6 0.6]), hold on
    [hl,hp]=boundedline(1:5,nanmean(Acc_all_Rand'),std(Acc_all_Rand'),'alpha','k','transparency',0.2);
    set(hp,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none')
    set(hl,'Color','none')
    line([1 5],[1 1]/5,'linewidth',4,'color','k','linestyle',':')
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
    ylim([0 1])
    xlim([0.5 5.5])
    ylabel('Accuracy')
    box off
    set(gca,'FontSize',18,'LineWidth',2)
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5])
    h = legend('Classifier','Classifier-DownCorr'), legend boxoff
    title([num2str(size(Vals.N1,2)) ' Neurons'])
    
    subplot(243)
    imagesc(squeeze(nanmean(Acc_ConfMat,3)))
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.5 1])
    colormap([[0 0 0];plasma(200)])
    title('Population classifier')
    
    subplot(244)
    imagesc(squeeze(nanmean(Acc_ConfMat_FRContr,3)))
    set(gca,'XTickLabel',NameEpoch(1:5),'XTick',[1:5],'YTickLabel',NameEpoch(1:5),'YTick',[1:5])
    axis xy
    axis square
    h = colorbar,ylabel(h,'Accuracy')
    clim([0.5 1])
    colormap([[0 0 0];plasma(200)])
    title('FR classifier')
    
    subplot(224)
    for ep = 1:5
        Proj{ep} = Vals.(NameEpoch{ep})*squeeze(nanmean(MeanW(1,3,:,:),3));
    end
    Proj{6} = NaN;
    nhist(Proj,'color','summer')
    legend(NameEpoch)
    xlabel('Wake to N3 axis')
    title('Projection onto ''arousal'' axis')
