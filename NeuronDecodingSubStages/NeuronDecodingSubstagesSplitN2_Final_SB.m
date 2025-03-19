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
    [aft_cell,bef_cell]=transEpoch(Epoch{2},Epoch{4});
    N2BeforeREM = aft_cell{1,2};
    
    EpochNew{1} = Epoch{3}; %N3
    EpochNew{2} = N2BeforeREM; %N2-REM
    EpochNew{3} = Epoch{2}-N2BeforeREM; %N2
    EpochNew{4} = Epoch{1}; %N1
    EpochNew{5} = Epoch{4}; %REM
    EpochNew{6} = Epoch{5}; %Wake
    NameEpoch = {'N3','N2REM','N2other','N1','REM','Wake'};
    
    %     for ep = 1:6
    %         timeEvents = Data(Restrict(AllTime,EpochNew{ep}));
    %         binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    %         QEvents = MakeQfromS(binsEvents,2*1e4);
    %         dat_temp = Data(QEvents)/2500;
    %         tps_temp = Range(QEvents);
    %         tps_temp(dat_temp<0.75) = [];
    %         CleanedEpoch.(NameEpoch{ep}) = intervalSet(tps_temp,tps_temp+2*1e4);
    %         Vals.(NameEpoch{ep}) = Data(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
    %         Tps.(NameEpoch{ep}) = Range(Restrict(Q,CleanedEpoch.(NameEpoch{ep})));
    %         Vals_downcorr.(NameEpoch{ep}) = Data(Restrict(Q_downcorr,CleanedEpoch.(NameEpoch{ep})));
    %     end
    %
    %
    %     [Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
    %     [Acc_all_downcorr,Acc_ConfMat_downcorr,MeanW_downcorr] = MultiClassBinaryDecoder_SB(Vals_downcorr,'permutnum',100,'dorand',0,'testonfr',0);
    %     [Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);
    %     [Acc_all_FRContr,Acc_ConfMat_FRContr,MeanW_FRContr] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',1);
    %
    %
    %     try,[Sp,t,f]=LoadSpectrumML('dHPC_rip');
    %     catch
    %         try,[Sp,t,f]=LoadSpectrumML('dHPC_deep');
    %         end
    %     end
    %     Sptsd = tsd(t*1e4,Sp);
    %     for ep = 1:5
    %         SpectroH(ep,:) = nanmean(Data(Restrict(Sptsd,EpochNew{ep})));
    %     end
    %
    %     [Sp,t,f]=LoadSpectrumML('PFCx_deep');
    %     Sptsd = tsd(t*1e4,Sp);
    %     for ep = 1:5
    %         SpectroP(ep,:) = nanmean(Data(Restrict(Sptsd,EpochNew{ep})));
    %     end
    %
    %     [Sp,t,f]=LoadSpectrumML('Bulb_deep');
    %     Sptsd = tsd(t*1e4,Sp);
    %     for ep = 1:6
    %         SpectroB(ep,:) = nanmean(Data(Restrict(Sptsd,EpochNew{ep})));
    %     end
    
    %     save('SubStageDecodingN2Split.mat','Acc_all','Acc_ConfMat','MeanW',...
    %         'Acc_all_downcorr','Acc_ConfMat_downcorr','MeanW_downcorr',...
    %         'Acc_all_Rand','Acc_ConfMat_Rand','MeanW_Rand',...
    %         'Acc_all_FRContr','Acc_ConfMat_FRContr','MeanW_FRContr','EpochNew','NameEpoch',...
    %         'SpectroB','SpectroP','SpectroH')
    %
    clear tRipples
    try, load('Ripples.mat')
        tRipples;
    catch
        tRipples = [];
    end
    
    clear alldown_PFCx
    try, load('DownState.mat')
        alldown_PFCx;
    catch
        alldown_PFCx = [];
    end
    
    clear alldeltas_PFCx
    try, load('DeltaWaves.mat')
        alldeltas_PFCx;
    catch
        alldeltas_PFCx = [];
    end
    
    for ep = 1:5
        DurEp{ep}(k) = sum(Start(EpochNew{ep})-Stop(EpochNew{ep}))/1e4;
        
        if not(isempty(tRipples))
            Rippledensity{ep}(k,:) = length(Range(Restrict(tRipples,EpochNew{ep})))/DurEp{ep}(k);
        else
            Rippledensity{ep}(k,:) = NaN;
        end
        
        if not(isempty(down_PFCx))
            DownDensity{ep}(k,:) = length(Start(and(down_PFCx,EpochNew{ep})))/DurEp{ep}(k);
        else
            DownDensity{ep}(k,:) = NaN;
        end
        
        if not(isempty(alldeltas_PFCx))
            DeltaDensity{ep}(k,:) = length(Start(and(alldeltas_PFCx,EpochNew{ep})))/DurEp{ep}(k);
        else
            DeltaDensity{ep}(k,:) = NaN;
        end
        
    end
    
    save('SubStageDecodingN2Split.mat','DeltaDensity','DownDensity','DurEp','Rippledensity','-append')
    
    clear DeltaDensity DownDensity DurEp Rippledensity
    
end

%% Load data and compare

clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
clear AllH AllP AllB 
for k = 1:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    
    load('SubStageDecodingN2Split.mat')
    Accuracy(k,:) = nanmean(Acc_all');
    Accuracy_down(k,:) = nanmean(Acc_all_downcorr');
    Accuracy_FR(k,:) = nanmean(Acc_all_FRContr');
    Accuracy_Rand(k,:) = nanmean(Acc_all_Rand');
    
    Accuracy_ConfMat(k,:,:) = squeeze(nanmean(Acc_ConfMat,3));
    Accuracy_ConfMat_down(k,:,:) = squeeze(nanmean(Acc_ConfMat_downcorr,3));
    Accuracy_ConfMat_FR(k,:,:) = squeeze(nanmean(Acc_ConfMat_FRContr,3));
    Accuracy_ConfMat_Rand(k,:,:) = squeeze(nanmean(Acc_ConfMat_Rand,3));
    
    for ep = 1:length(NameEpoch)-1
    AllB{ep}(k,:) = SpectroB(ep,1:261)./sum(SpectroB(:));
    AllH{ep}(k,:) =  SpectroH(ep,1:261)./sum(SpectroH(:));
    AllP{ep}(k,:) = SpectroP(ep,1:261)./sum(SpectroP(:));
    AllRip{ep}(k) = -Rippledensity{ep}(k);
    AllDown{ep}(k) = -DeltaDensity{ep}(k);
    AllDelta{ep}(k) = -DownDensity{ep}(k);

    end
   
    
end

figure
subplot(131)
PlotErrorBarN_KJ(AllDelta,'newfig',0)
title('Delta waves')
ylabel('Delta/s')
set(gca,'XTick',[1:5],'XTickLabel',NameEpoch(1:5))

subplot(132)
PlotErrorBarN_KJ(AllDown,'newfig',0)
title('Down states')
ylabel('Down/s')
set(gca,'XTick',[1:5],'XTickLabel',NameEpoch(1:5))

subplot(133)
PlotErrorBarN_KJ(AllRip,'newfig',0)
title('Ripple')
ylabel('Ripples/s')
set(gca,'XTick',[1:5],'XTickLabel',NameEpoch(1:5))


figure
subplot(131)
for ep = 1:length(NameEpoch)-1
    errorbar([1:length(AllB{ep})]/size(AllB{ep},2),nanmean(AllB{ep}),stdError(AllB{ep}),'linewidth',2);
    hold on
end
title('OB')
set(gca,'FontSize',18,'LineWidth',2)
box off
xlabel('Frequency (Hz)')
ylabel('Power (AU)')

subplot(132)
for ep = 1:length(NameEpoch)-1
    errorbar([1:length(AllH{ep})]/size(AllH{ep},2),nanmean(AllH{ep}),stdError(AllH{ep}),'linewidth',2);
    hold on
end
title('HPC')
set(gca,'FontSize',18,'LineWidth',2)
box off
xlabel('Frequency (Hz)')
ylabel('Power (AU)')

subplot(133)
for ep = 1:length(NameEpoch)-1
    errorbar([1:length(AllP{ep})]/size(AllP{ep},2),nanmean(AllP{ep}),stdError(AllP{ep}),'linewidth',2);
    hold on
end
title('PFC')
set(gca,'FontSize',18,'LineWidth',2)
box off
xlabel('Frequency (Hz)')
ylabel('Power (AU)')


fig = figure;
set(fig,'Position',[100         -70        1785         996])
plot(-1,1,'.','color',[0.6 0.6 0.6],'MarkerSize',20)

subplot(121)
N2REM = (Accuracy_ConfMat(:,1,2)+Accuracy_ConfMat(:,2,1))/2;
N2NoREM = (Accuracy_ConfMat(:,1,3)+Accuracy_ConfMat(:,3,1))/2;

[pval,hd] = PlotErrorSpreadN_KJ({N2REM,N2NoREM},'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
line([1 2],[1 1]/2,'linewidth',4,'color','k','linestyle',':')
ylim([0 1])
xlim([0.5 2.5])
[pval,hd] = signrank(N2REM,N2NoREM);
 sigstar({[1,2]},pval)
title('Decoding vs N3')
set(gca,'XTick',[1:2],'XTickLabel',{'N2 bef REM','Other N2'})
set(gca,'FontSize',18,'LineWidth',2)
ylabel('Accuracy')

subplot(122)
N2REM = (Accuracy_ConfMat(:,4,2)+Accuracy_ConfMat(:,2,4))/2;
N2NoREM = (Accuracy_ConfMat(:,4,3)+Accuracy_ConfMat(:,3,4))/2;

[pval,hd] = PlotErrorSpreadN_KJ({N2REM,N2NoREM},'newfig',0,'plotcolors',[0.6 0.6 0.6]), hold on
line([1 2],[1 1]/2,'linewidth',4,'color','k','linestyle',':')
ylim([0 1])
xlim([0.5 2.5])
[pval,hd] = signrank(N2REM,N2NoREM);
 sigstar({[1,2]},pval)
title('Decoding vs REM')
set(gca,'XTick',[1:2],'XTickLabel',{'N2 bef REM','Other N2'})
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
