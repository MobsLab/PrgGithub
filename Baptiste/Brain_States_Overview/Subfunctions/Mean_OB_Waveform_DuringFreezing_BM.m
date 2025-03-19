
%% OB mean waveform during freezing

GetEmbReactMiceFolderList_BM

Session_type={'Cond','Ext'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM([688,739,777,779,849,893,1096],lower(Session_type{sess}),'respi_meanwaveform');
end


Mouse=[688,739,777,779,849,893];
for mouse=1:length(Mouse)
    
    max_LFP = max([max(squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,5,:))) , max(squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,6,:))) , max(squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,5,:))) , max(squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,6,:)))]) ;
    
    subplot(2,3,mouse)
    plot(squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,5,:))/max_LFP)
    hold on
    plot(squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,6,:))/max_LFP)
        plot(squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,5,:))/max_LFP,'r')
    hold on
    plot(squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,6,:))/max_LFP,'b')
    
    A1(mouse,:) = squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,5,:))/max_LFP;
    B1(mouse,:) = squeeze(TSD_DATA.Cond.respi_meanwaveform(mouse,6,:))/max_LFP;
    C1(mouse,:) = squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,5,:))/max_LFP;
    D1(mouse,:) = squeeze(TSD_DATA.Ext.respi_meanwaveform(mouse,6,:))/max_LFP;
end

figure
plot(mean(A1))
hold on
plot(mean(B1))
plot(mean(C1))
plot(mean(D1))
vline(361,'--r')
vline(257,'--r')
vline(500,'--r')






for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA2.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM([11147,11184,11189,11200,11204,11205,11206,11207],lower(Session_type{sess}),'respi_meanwaveform');
end


Mouse=[11147,11184,11189,11200,11204,11205,11206,11207];
figure
for mouse=1:length(Mouse)
    
    max_LFP = max([max(squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,5,:))) , max(squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,6,:))) , max(squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,5,:))) , max(squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,6,:)))]) ;
    
    subplot(2,3,mouse)
    plot(squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,5,:))/max_LFP)
    hold on
    plot(squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,6,:))/max_LFP)
        plot(squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,5,:))/max_LFP,'r')
    hold on
    plot(squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,6,:))/max_LFP,'b')
    
    A(mouse,:) = squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,5,:))/max_LFP;
    B(mouse,:) = squeeze(TSD_DATA2.Cond.respi_meanwaveform(mouse,6,:))/max_LFP;
    C(mouse,:) = squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,5,:))/max_LFP;
    D(mouse,:) = squeeze(TSD_DATA2.Ext.respi_meanwaveform(mouse,6,:))/max_LFP;
end



figure
plot(mean(A))
hold on
plot(mean(B))
plot(mean(C))
plot(mean(D))
vline(361,'--r')
vline(257,'--r')
vline(500,'--r')



figure
plot(mean(A1))
hold on
plot(mean(A))
makepretty


figure
plot(mean(B1))
hold on
plot(mean(B))
makepretty


figure
plot(mean(C1))
hold on
plot(mean(C))
makepretty


%%
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
load('behavResources_SB.mat')
load('InstFreqAndPhase_B.mat')

Fz_shock = and(Behav.FreezeAccEpoch , Behav.ZoneEpoch{1});
Fz_safe = and(Behav.FreezeAccEpoch , or(Behav.ZoneEpoch{5} , Behav.ZoneEpoch{2}));

AllPeaks_ts = ts(AllPeaks(2:6:end,1)*1e4);

PeakFzShock = Restrict(AllPeaks_ts , Fz_shock);
PeakFzSafe = Restrict(AllPeaks_ts , Fz_safe);
 
figure
plot(Range(LFP),Data(LFP))
hold on
plot(Range(AllPeaks_ts),1,'*r')

freq = [1 7]; % frequency range of ripples
LFPf=FilterLFP(LFP,freq,1048);


[M1,T1] = PlotRipRaw(LFP, Range(PeakFzShock)/1e4, 300 , 'PlotFigure' , 0);
[M2,T2] = PlotRipRaw(LFP, Range(PeakFzSafe)/1e4, 300 , 'PlotFigure' , 0);

figure
plot(mean(T1)-mean(mean(T1)))
hold on; 
plot(mean(T2)-mean(mean(T2)))



[M1,T3] = PlotRipRaw(LFPf , Range(PeakFzShock)/1e4, 300);
[M2,T4] = PlotRipRaw(LFPf , Range(PeakFzSafe)/1e4, 300);

figure
plot(mean(T3)-mean(mean(T3)))
hold on; 
plot(mean(T4)-mean(mean(T4)))








respi_peak













