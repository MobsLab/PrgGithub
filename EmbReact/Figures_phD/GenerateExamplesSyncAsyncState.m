cd /media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab
load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab/LFPData/LFP14.mat')
load('SpikeData.mat')
[numNeurons, numtt, TT]=GetSpikesFromStructure('dHPC','remove_mua',1)

S = S(numNeurons);
Q = MakeQfromS(S,0.01*1E4);
LitEpoch = intervalSet(207.6*1e4,210*1e4)
[173.1 175.5]+34.5
figure
subplot(4,1,3:4)
RasterPlot(Restrict(S(ind),LitEpoch),'AxHandle',gca);
%RasterPlot(Restrict(S,LitEpoch),'AxHandle',gca);
set(gca,'xcolor','w','ycolor','w')
subplot(4,1,2)
bar(Range(Q,'ms'),runmean(nanmean(Data(Q)'),1))
xlim([[173.1 175.5]+34.5]*1e3)
set(gca,'xcolor','w','ycolor','w')
subplot(4,1,1)
plot(Range(LFP,'ms'),Data(LFP),'color','b','linewidth',1)
xlim([[173.1 175.5]+34.5]*1e3)
set(gca,'xcolor','w','ycolor','w')

FilLFP = FilterLFP(LFP,[6 10],1024);

% Get LFP phase
PhaseLFP = GetPhaseFilteredLFP(FilLFP);

% Correct the LFP phase
PhaseLFPCorr = CorrectLFPPhaseDistrib(PhaseLFP);

clear mu Kappa
for sp = 1:length(S)
    [PhasesSpikes,mutemp,Kappatemp,pval] =SpikeLFPModulationTransform(S{sp},tsd(Range(PhaseLFPCorr.Transf),mod(Data(PhaseLFPCorr.Transf)+pi/2,2*pi)),LitEpoch,30,0,0);
mu(sp) = mutemp.Transf;
Kappa(sp) = Kappatemp.Transf;

end
[val,ind] = sort(Kappa)
clf
subplot(211)
RasterPlot(Restrict(S,LitEpoch),'AxHandle',gca);
subplot(212)
RasterPlot(Restrict(S(ind),LitEpoch),'AxHandle',gca);



cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Habituation
load('SpikeData.mat')
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Habituation/LFPData/LFP20.mat')
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_mua',1)
S = S(numNeurons);
Q = MakeQfromS(S,0.01*1E4);
LitEpoch = intervalSet(194.841e4 ,197.2400*1e4)

figure
subplot(4,1,3:4)
RasterPlot(Restrict(S,LitEpoch),'AxHandle',gca);
set(gca,'xcolor','w','ycolor','w')
subplot(4,1,2)
bar(Range(Q,'ms'),runmean(nanmean(Data(Q)'),1))
xlim([[173.1 175.5]+34.5]*1e3)
set(gca,'xcolor','w','ycolor','w')
subplot(4,1,1)
LFP = FilterLFP(LFP,[1 100],1024);
plot(Range(LFP,'ms'),Data(LFP),'color','k','linewidth',1)
set(gca,'xcolor','w','ycolor','w')
xlim([1.9484    1.9724]*1e5)
ylim([-5000 7000])


cd /media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PreSleep/
load('LFPData/LFP29.mat')
load('SpikeData.mat')
[numNeurons, numtt, TT]=GetSpikesFromStructure('dHPC','remove_mua',1)

S = S(numNeurons);
Q = MakeQfromS(S,0.01*1E4);
LitEpoch = intervalSet(1773*1e4,1776*1e4)
figure
clf
i=9;
LitEpoch = intervalSet((1773 +i)*1e4,(1776 +i)*1e4);
subplot(4,1,3:4)
RasterPlot(Restrict(S(ind),LitEpoch),'AxHandle',gca);
%RasterPlot(Restrict(S,LitEpoch),'AxHandle',gca);
set(gca,'xcolor','w','ycolor','w')
xlim(([1773 1776]+i)*1e3)
set(gca,'xcolor','w','ycolor','w')

subplot(4,1,2)
bar(Range(Restrict(Q,LitEpoch),'s'),runmean(nanmean(Data(Restrict(Q,LitEpoch))'),1))
xlim([1773 1776]+i)
set(gca,'xcolor','w','ycolor','w')

subplot(4,1,1)
plot(Range(Restrict(LFP,LitEpoch),'s'),Data(Restrict(LFP,LitEpoch)),'color','k','linewidth',1)
xlim([1773 1776]+i)
set(gca,'xcolor','w','ycolor','w')


Rip1 = nanmean(Data(Restrict(Q,intervalSet(1783.2*1e4,1783.5*1e4))'));
[val,ind] = sort(Rip1);