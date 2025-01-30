%RippleTriggeredSpikes_SB

%cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre


load('SpikeData.mat')
try
Binsize = 0.01*1e4;
temp = MakeQfromS(S,Binsize);
catch
    clear
load SpikeData
save SpikeData_old
S=tsdArray(S);
save SpikeData
disp('made SpikdeData ...')
end


Binsize = 0.01*1e4;
load('Ripples.mat')
load('DeltaWaves.mat')
try
load('DownState.mat')
end
Q = MakeQfromS(S,Binsize);
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
S = S(numNeurons);
QDat = full(Data(Q));
TimeAroundDelta = 0.5*1e4;
load('SleepSubstages.mat')


%DeltaEpoch = mergeCloseIntervals(intervalSet(Start(down_PFCx)-TimeAroundDelta,Stop(down_PFCx)+TimeAroundDelta),0.1*1e4);
DeltaEpoch = mergeCloseIntervals(intervalSet(Start(deltas_PFCx)-TimeAroundDelta,Stop(deltas_PFCx)+TimeAroundDelta),0.1*1e4);
try
Ripplests = ts(Ripples(:,2)*10);
catch
    Ripplests=tRipples;
    Ripples(:,1)=Range(tRipples,'ms');
    Ripples(:,2)=Range(tRipples,'ms');
end
Ripplests=Restrict(Ripplests,Epoch{7});
RipplesNoDel = Restrict(Ripplests,Epoch{7}-DeltaEpoch);
RippleSpikingNoDel = [];
RippleSpiking = [];

for nn = 1:length(numNeurons)
    QOneNeur = tsd(Range(Q),QDat(:,nn));
    
    [M,T] = PlotRipRaw(QOneNeur,Ripples(:,2)*1e-3,1000,0,0);
    RippleSpiking = [RippleSpiking,(M(:,2))];
    
     [MNoDel,TNoDel] = PlotRipRaw(QOneNeur,Range(RipplesNoDel,'s'),1000,0,0);
    RippleSpikingNoDel = [RippleSpikingNoDel,(MNoDel(:,2))];
    
    tpsrip = M(:,1);
    
end

figure, 
subplot(3,1,1), hold on
plot(tpsrip,nanmean((RippleSpiking)')),title(pwd), line([0 0],ylim,'color',[0.6 0.6 0.6])
plot(tpsrip,nanmean((RippleSpikingNoDel)'))
subplot(3,1,2), hold on
plot(tpsrip,nanmean(zscore(RippleSpiking)')), line([0 0],ylim,'color',[0.6 0.6 0.6])
plot(tpsrip,nanmean(zscore(RippleSpikingNoDel)'))

%RippleTriggeredSpikes

[cripdelta,b]=CrossCorr(Range(Ripplests),Range(PoolNeurons(S,1:length(S))),10,200);
[cripnodelta,b]=CrossCorr(Range(RipplesNoDel),Range(PoolNeurons(S,1:length(S))),10,200);

subplot(3,1,3), hold on, plot(b/1E3,cripnodelta,'r'), plot(b/1E3,cripdelta,'k'), line([0 0],ylim,'color',[0.6 0.6 0.6])
title([num2str(length(Range(Ripplests))),', ',num2str(length(Range(RipplesNoDel)))])