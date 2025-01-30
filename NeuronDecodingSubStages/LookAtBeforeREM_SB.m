clear all
Binsize = 2*1e4;
% Dir=PathForExperimentsEmbReact('BaselineSleep');
ReorderSleepDepth = [3,2,1,4,5];
Dir = PathForExperimentsSleepRipplesSpikes('Basal')
cols = lines(6);
smootime=3;

for k = 12:length(Dir.path)
    
    cd(Dir.path{k})
    disp(Dir.path{k})
    try,
    load('StateEpochSB.mat','smooth_Theta')
    catch
        load('SleepScoring_OBGamma.mat','SmoothTheta')
        smooth_Theta = SmoothTheta;
    end
    
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
    
    clear tRipples
    try, load('Ripples.mat')
        tRipples;
    catch
        tRipples = [];
    end
    timeEvents = Data(Restrict(AllTime,tRipples));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QRipples = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    
    
    clear alldown_PFCx
    try, load('DownState.mat')
        alldown_PFCx;
    catch
        alldown_PFCx = [];
    end
    timeEvents = Data(Restrict(AllTime,alldown_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    
    clear alldeltas_PFCx
    try, load('DeltaWaves.mat')
        alldeltas_PFCx;
    catch
        alldeltas_PFCx = [];
    end
    timeEvents = Data(Restrict(AllTime,alldeltas_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDelta = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    
    % PFC
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(strcat('LFPData/LFP',num2str(channel),'.mat'));
    
    % find theta epochs
    
    disp(' ');
    disp('... Creating Theta Epochs ');
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[2 5],1024);
    
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    ThetaRatio=abs(HilTheta)./H;
    ThetaRatioTSD=tsd(Range(FilTheta),ThetaRatio);
    smooth_Theta_PFC=tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
    

    
    % Make figure
    GoodRem = dropShortIntervals(Epoch{4},10*1e4);
    GoodNRem = dropShortIntervals(Epoch{2},5*1e4);
    [aft_cell,bef_cell]=transEpoch(GoodNRem,GoodRem);
    
    
    clf
    times = Start(GoodRem);
    subplot(332)
    [B,C] = CrossCorr(times,Start(alldeltas_PFCx),500,100);
    plot(C/1e3,B,'linewidth',2), hold on
    N2TransitionInfo.DeltaOnREM = [C,B];
    [B,C] = CrossCorr(times,Start(alldown_PFCx),500,100);
    plot(C/1e3,B,'linewidth',2)
    N2TransitionInfo.DownOnREM = [C,B];
    MeanDownN2 = length(Start(and(alldown_PFCx,Epoch{2})))/sum(Stop(Epoch{2},'s')-Start(Epoch{2},'s'));
    MeanDeltaN2 = length(Start(and(alldeltas_PFCx,Epoch{2})))/sum(Stop(Epoch{2},'s')-Start(Epoch{2},'s'));
    ylabel('Evts/s')
    yyaxis right
    [M,T]=PlotRipRaw(smooth_Theta_PFC,times/1e4,20000,0,0,0);
    N2TransitionInfo.PFCTheta = [M(:,1),M(:,2)];
    plot(M(:,1),M(:,2),'linewidth',2)
    ylabel('ThetaPower')
    Yl = ylim;
    ylim([Yl(1) Yl(2)*1.2])
    xlim([-20 20])
    xlabel('Time to REM (s)')
    title('All REM')
    box off
    set(gca,'linewidth',2,'FontSize',12)
    legend(['Down (N2av=' num2str(MeanDownN2) ')'],['Delta (N2av=' num2str(MeanDeltaN2) ')'])

    subplot(3,3,5)
    [B,C] = CrossCorr(times,Range(tRipples),1000,50);
    bar(C/1e3,B)
    N2TransitionInfo.RipplesOnREM = [C,B];
    ylabel('Ripples/s')
    [M,T]=PlotRipRaw(smooth_Theta,times/1e4,20000,0,0,0);
    N2TransitionInfo.ThetaOnREM = [M(:,1),M(:,2)];
    yyaxis right
    plot(M(:,1),M(:,2),'linewidth',2)
    xlim([-20 20])
    ylabel('ThetaPower')
    xlabel('Time to REM (s)')
    box off
    set(gca,'linewidth',2,'FontSize',12)
    
    
    
    subplot(3,3,8)
    [SleepStages, Epochs, time_in_substages, meanDuration_substages, percentvalues_NREM] = MakeIDfunc_Sleepstages;
    [M,T]=PlotRipRaw(SleepStages,times/1e4,20000,0,0,0);
    Vals  = unique(Data(SleepStages));
    for ep = 1:5
        Perc(ep,:) = sum(T==Vals(ep))/size(T,1);
    end
    bar(M(:,1),Perc(1:5,1:end)','stacked')
    xlim([-20 20])
    ylabel('%of stage')
    xlabel('Time to REM (s)')
    box off
    set(gca,'linewidth',2,'FontSize',12)
    N2TransitionInfo.BefREM = Perc;

    try
    GoodRemAfterN2 = aft_cell{1,2};
    times = Stop(GoodRemAfterN2);
    subplot(333)
    [B,C] = CrossCorr(times,Start(alldeltas_PFCx),500,100);
    N2TransitionInfo.DeltaOnREMN2 = [C,B];
    plot(C/1e3,B,'linewidth',2), hold on
    [B,C] = CrossCorr(times,Start(alldown_PFCx),500,100);
    N2TransitionInfo.DownOnREMN2 = [C,B];
    plot(C/1e3,B,'linewidth',2)
    xlim([-20 20])
    xlabel('Time to REM (s)')
    title('REM after N2')
    ylabel('Evts/s')
    yyaxis right
    [M,T]=PlotRipRaw(smooth_Theta_PFC,times/1e4,20000,0,0,0);
    N2TransitionInfo.PFCTheta = [M(:,1),M(:,2)];
    plot(M(:,1),M(:,2),'linewidth',2)
    ylabel('ThetaPower')
    Yl = ylim;
    ylim([Yl(1) Yl(2)*1.2])
    N2TransitionInfo.PFCThetaN2 = [M(:,1),M(:,2)];
    box off
    set(gca,'linewidth',2,'FontSize',12)
    legend('Delta','Down')
    
    subplot(3,3,6)
    [B,C] = CrossCorr(times,Range(tRipples),1000,50);
    bar(C/1e3,B)
    N2TransitionInfo.RipplesOnREMN2 = [C,B];
    [M,T]=PlotRipRaw(smooth_Theta,times/1e4,20000,0,0,0);
    N2TransitionInfo.ThetaOnREMN2 = [M(:,1),M(:,2)];
    yyaxis right
    plot(M(:,1),M(:,2),'linewidth',2)
    xlim([-20 20])
    ylabel('Theta/delta HPC')
    xlabel('Time to REM (s)')
    box off
    set(gca,'linewidth',2,'FontSize',12)
    
    subplot(3,3,9)
    [SleepStages, Epochs, time_in_substages, meanDuration_substages, percentvalues_NREM] = MakeIDfunc_Sleepstages;
    [M,T]=PlotRipRaw(SleepStages,times/1e4,20000,0,0,0);
    Vals  = unique(Data(SleepStages));
    for ep = 1:5
        Perc(ep,:) = sum(T==Vals(ep))/size(T,1);
    end
    bar(M(:,1),Perc(1:5,1:end)','stacked')
    N2TransitionInfo.BefREMN2 = Perc;
    xlim([-20 20])
    ylabel('%of stage')
    xlabel('Time to REM (s)')
    box off
    set(gca,'linewidth',2,'FontSize',12)
    end
    
    subplot(2,3,1)
    EpochNew2 = EpochNew([3,2,5]);
    clear A
    for ep = 1:3
        EPOI = EpochNew2{ep};
        
        A{1} = Data(Restrict(QDown,EPOI));
        
        
        A{2} = Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,EPOI)))));
        
        hold on
        %         if ep==2
        %             plot(A{2},A{4},'.','MarkerSize',20)
        %         else
        plot(A{1},A{2},'.','MarkerSize',15)
        %         end
    end
    A{1} = Data(Restrict(QDown,EpochNew{1}));
    A{2} = Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,EpochNew{1})))));
    plot(nanmean(A{1}),nanmean(A{2}),'.','MarkerSize',50)
    
    A{1} = Data(Restrict(QDown,EpochNew{4}));
    A{2} = Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,EpochNew{4})))));
    plot(nanmean(A{1}),nanmean(A{2}),'.','MarkerSize',50)
    
    legend({'N2other','N2REM','REM','N3','N1'})
    set(gca,'linewidth',2,'FontSize',12)
    box off
    xlabel('Down/s')
    ylabel('Theta/delta HPC')
    
    clear A
    subplot(2,3,4)
    plot(Data(Restrict(QDown,Epoch{10})),Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,Epoch{10}))))),'.','color',[0.8 0.8 0.8])
    hold on
    V = Range(Restrict(QDown,Epoch{4}));
    N = Start(Epoch{4});
    A = repmat(N,[1 length(V)]);
    Dist = A-V';
    Dist(Dist>0) = NaN;
    [minValue,closestIndex] = min(abs(Dist));
    closestValue = N(closestIndex);
    scatter(Data(Restrict(QDown,Epoch{4})),Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,Epoch{4}))))),30,(minValue)/1e4,'filled')
    
    V = Range(Restrict(QDown,Epoch{7}));
    N = Start(Epoch{4});
    A = repmat(N,[1 length(V)]);
    Dist = A-V';
    Dist(Dist<0) = NaN;
    [minValue,closestIndex] = min(abs(Dist));
    closestValue = N(closestIndex);
    X = Data(Restrict(QDown,Epoch{7})); X(minValue/1e4>30) = [];
    Y = Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,Epoch{7}))))); Y(minValue/1e4>30) = [];
    minValue(minValue/1e4>30) = [];
    scatter(X,Y,30,-(minValue)/1e4,'filled')
    colormap jet
    clim([-30 30])
    colorbar
    set(gca,'linewidth',2,'FontSize',12)
    box off
    xlabel('Down/s')
    ylabel('Theta/delta HPC')
    
    saveas(12,['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/N1N2N3PCA/N2BeforeREM',num2str(k),'.png'])
    
    save('TransitionToREM.mat','N2TransitionInfo')
    clf
end



[aft_cell,bef_cell]=transEpoch(Epoch{2},Epoch{4});
N2BeforeREM = or(aft_cell{1,2},bef_cell{2,1});
N2BeforeREM = aft_cell{1,2};
% N2BeforeREM = Epoch{2}-aft_cell{1,2};
EpochNew = EpochNew([3,2,5]);
for ep = 1:3
N2BeforeREM = EpochNew{ep};

timeEvents = Data(Restrict(AllTime,tRipples));
binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
QEvents = MakeQfromS(binsEvents,2*1e4);
QRipples = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
A{1} = Data(Restrict(QRipples,N2BeforeREM));

timeEvents = Data(Restrict(AllTime,alldeltas_PFCx));
binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
QEvents = MakeQfromS(binsEvents,2*1e4);
QDelta = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
A{2} = Data(Restrict(QDelta,N2BeforeREM));

timeEvents = Data(Restrict(AllTime,alldown_PFCx));
binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
QEvents = MakeQfromS(binsEvents,2*1e4);
QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
A{3} = Data(Restrict(QDelta,N2BeforeREM));

A{4} = Data(Restrict(smooth_Theta,ts(Range(Restrict(QDown,N2BeforeREM)))));

hold on
if ep==1
    plot(A{2},A{4},'.','MarkerSize',20)
else
plot(A{2},A{4},'.','MarkerSize',10)
end
end
legend({'N2other','N2REM','REM'})

for k = 1:3
subplot(1,3,k),hold on
plot(A{k},A{4},'*')
end