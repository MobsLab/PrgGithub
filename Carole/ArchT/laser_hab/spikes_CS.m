% when you've finished the sorting execute this
SetCurrentSession
MakeData_Spikes('mua',1,'recompute',1)
%%
clear all
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
load('SpikeData.mat')
%%
load('LFPData/DigInfo9.mat')

StimOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
StimOff = intervalSet(0,900*1e4)-StimOn;
StimOnClose = intervalSet(Start(StimOn),Start(StimOn)+1*1e4);
clear RemResp
%%
for sp = 1:length(numNeurons)
    [Y,X] = hist(Range(S{numNeurons(sp)},'s'),[0:0.1:900]);
    PETHtsd = tsd([0:0.1:900]*1e4,Y');
    
    subplot(211)
    plot(X,zscore(Y)), hold on
    plot(Range(DigTSD,'s'),Data(DigTSD))
    subplot(212)
    [M,T]=PlotRipRaw(PETHtsd,Start(StimOn,'s'),90000,0,0);
    plot(M(:,1),M(:,2))
    TetName(sp) = TT{sp}(1);
    RemResp(sp,:) = M(:,2);
    line([0 0],ylim,'color','k'),line([45 45],ylim,'color','k')
    FiringOff(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOff)))./sum(Stop(StimOff,'s')-Start(StimOff,'s'));
    FiringOn(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOn)))./sum(Stop(StimOn,'s')-Start(StimOn,'s'));
    
    FiringOnClose(sp) = length(Range(Restrict(S{numNeurons(sp)},StimOnClose)))./sum(Stop(StimOnClose,'s')-Start(StimOnClose,'s'));
       pause
       clf
end
%%
load('behavResources.mat')

%% look at behaviour
[M,T]=PlotRipRaw(Vtsd,Start(StimOn,'s'),90000,0,0);
nhist({log(Data(Restrict(Vtsd,StimOn))),log(Data(Restrict(Vtsd,StimOff)))})

[M,T]=PlotRipRaw(MovAcctsd,Start(StimOn,'s'),90000,0,0);
nhist({log(Data(Restrict(MovAcctsd,StimOn))),log(Data(Restrict(MovAcctsd,StimOff)))})

%% modulation index
% remember to add the toolbox ot path

ModIndx = ((FiringOn-FiringOff)./(FiringOn+FiringOff));

%% view as heatmap
figure
A = {ModIndx};
MakeSpreadAndBoxPlot_SB(A,{[0.3 0.3 0.3]},1)
hold on
line(xlim,[0 0],'linewidth',1,'color','k','linestyle',':')
ylim([-1.1 1.1])
xlim([0 2])
[p,h,stats] = signrank(A{1})
sigstar({{0.8,1.2}},p)
%%
figure
imagesc(M(:,1),1:length(FiringOff),SmoothDec(sortrows([ModIndx',ZScoreWiWindowSB(RemResp,[700:850])]),[0.1,3]))
xlim([-20 60])
clim([-2 2])
line([0 0],ylim,'linewidth',2,'color','k')
line([45 45],ylim,'linewidth',2,'color','k')
colormap redblue


