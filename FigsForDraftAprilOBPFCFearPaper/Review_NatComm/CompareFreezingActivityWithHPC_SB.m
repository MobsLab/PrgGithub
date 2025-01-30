clear all
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', 994);

cd(Dir.path{1}{1})
load('behavResources.mat')
load('SpikeData.mat')
CondEpoch = SessionEpoch.Cond1;
CondEpoch = or(CondEpoch, SessionEpoch.Cond2);
CondEpoch = or(CondEpoch, SessionEpoch.Cond3);
CondEpoch = or(CondEpoch, SessionEpoch.Cond4);

FreezeAccEpoch = and(FreezeAccEpoch,CondEpoch);
FreezeAccEpoch = dropShortIntervals(FreezeAccEpoch,4*1E4);
FreezeAccEpoch = mergeCloseIntervals(FreezeAccEpoch,1*1E4);

clear OnResp OffResp
for num = 1:length(S)
clf,[~,sq,sweeps] = RasterPETH(S{num}, ts(Stop(FreezeAccEpoch)), -20000, +20000,'BinSize',500);
OffResp(num,:) = Data(sq)/length(sweeps);
clf,[fh,sq,sweeps] = RasterPETH(S{num}, ts(Start(FreezeAccEpoch)), -20000, +20000,'BinSize',500);
OnResp(num,:) = Data(sq)/length(sweeps);
end
figure
DatNormZ = (zscore([OnResp,OffResp]')');
SustVal = nanmean(DatNormZ(:,60:100),2);
UseForTresh = SustVal;
[a,ind] = sort(UseForTresh);
subplot(4,1,1:3)
imagesc([Range(sq,'s');Range(sq,'s')+4],1:size(DatNormZ,1),DatNormZ(ind,:))
% imagesc([Range(sq,'s');Range(sq,'s')+4],1:size(DatNormZ(BasicNeuronInfo.firingrate<2,:),1),DatNormZ(BasicNeuronInfo.firingrate<2,:))
caxis([-3 3])
line([0 0],ylim,'color','k')
line([4 4],ylim,'color','k')    
makepretty
ylabel('Neuron #')
xlabel('Time to freeze on (s)')

subplot(4,1,4)
[M,T] = PlotRipRaw(MovAcctsd,Start(FreezeAccEpoch,'s'),2000,1,0,0);
plot(M(:,1),M(:,2),'color','k')
hold on
[M,T] = PlotRipRaw(MovAcctsd,Stop(FreezeAccEpoch,'s'),2000,1,0,0);
plot(M(:,1)+4,M(:,2),'color','k')
makepretty
ylabel('Accelero')
xlabel('Time to freeze on (s)')

