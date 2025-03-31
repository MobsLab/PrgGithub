
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : OB gamma tracks Wake/sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Raw traces
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline')
for l=[4 11 2] % EMG, EKG, OBm
    load(['LFPData/LFP' num2str(l) '.mat'])
    LFP_ferret{l} = LFP;
    LFP_ferret_Fil{l} = FilterLFP(LFP,[20 100],1024);
    LFP_ferret_Fil2{l} = FilterLFP(LFP,[50 300],1024);
    LFP_ferret_Fil3{l} = FilterLFP(LFP,[.5 10],1024);
end

figure
subplot(121)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
i=i+1;
plot(Range(LFP_ferret_Fil3{2},'s') , (Data(LFP_ferret_Fil3{2})-Data(LFP_ferret_Fil3{4}))*2-i*4.5e3 , 'k' , 'LineWidth',1)
xlim([191.5 195.5]), ylim([-12e3 4e3]), axis off
text(191,0,'EMG','FontSize',15)
text(191,-4200,'OB','FontSize',15)
text(191,-9000,'EEG','FontSize',15)
text(192.5,3500,'Wake','FontSize',20)

subplot(122)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
i=i+1;
plot(Range(LFP_ferret_Fil3{2},'s') , Data(LFP_ferret_Fil3{2})*2-i*4.5e3 , 'k' , 'LineWidth',1)
xlim([6886 6890]), ylim([-12e3 4e3]), axis off
text(6886+1.5,3500,'Sleep','FontSize',20)



%% Mean spectrum
% path{1} = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220520_n/';
path{1} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long';
path{2} = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long';
path{3} = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs';
for i=1:3
    load([path{i} filesep 'SleepScoring_OBGamma.mat'], 'Sleep', 'Wake')
    load([path{i} filesep 'B_Middle_Spectrum.mat'])
    Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    OB_High_Wake = Restrict(Sptsd,Wake);
    OB_High_Sleep = Restrict(Sptsd,Sleep);
    Mean_Sp_Wake(i,:) = nanmean(Data(OB_High_Wake));
    Mean_Sp_Sleep(i,:) = nanmean(Data(OB_High_Sleep));
end
RANGE = Spectro{3};
Range_Middle = Spectro{3};

figure
[~,MaxPowerValues,~] = Plot_MeanSpectrumForMice_BM(Mean_Sp_Wake , 'Color' , 'b' , 'smoothing' , 2);
Plot_MeanSpectrumForMice_BM(Mean_Sp_Sleep , 'power_norm_value' , MaxPowerValues , 'Color' , 'k' , 'smoothing' , 2);
xlim([15 100]), ylim([0 1.1])
makepretty
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
f=get(gca,'Children'); legend([f([5 1])],'Wake','Sleep');



% compare with mice
path_m{1} = '/media/nas6/ProjetEmbReact/Mouse1146/20201216';
path_m{2} = '/media/nas7/ProjetEmbReact/Mouse1379/20221020/';
path_m{3} = '/media/nas7/ProjetEmbReact/Mouse1411/20230208/';
path_m{4} = '/media/nas7/ProjetEmbReact/Mouse1417/20230220/';
for i=1:4
    load([path_m{i} filesep 'SleepScoring_OBGamma.mat'], 'Sleep', 'Wake','TotalNoiseEpoch')
    load([path_m{i} filesep 'B_Middle_Spectrum.mat'])
    Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    OB_High_Wake = Restrict(Sptsd,Wake); 
    OB_High_Sleep = Restrict(Sptsd,Sleep);
    Mean_Sp_Wake_m(i,:) = nanmean(Data(OB_High_Wake));
    Mean_Sp_Sleep_m(i,:) = nanmean(Data(OB_High_Sleep));
end

figure
[~,MaxPowerValues,~] = Plot_MeanSpectrumForMice_BM(Mean_Sp_Wake_m , 'Color' , 'b' , 'smoothing' , 2);
Plot_MeanSpectrumForMice_BM(Mean_Sp_Sleep_m , 'power_norm_value' , MaxPowerValues , 'Color' , 'k' , 'smoothing' , 2);
xlim([15 100]), ylim([0 1.1])
makepretty
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
f=get(gca,'Children'); legend([f([5 1])],'Wake','Sleep');



%% Gamma values distribution
path{1} = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220426_n';
path{2} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long';
path{3} = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long';
path{4} = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs';
for i=1:4
    load([path{i} filesep 'SleepScoring_OBGamma.mat'],'SmoothGamma')
    load([path{i} filesep 'SleepScoring_Accelero.mat'],'Wake','Sleep')
    Smooth_Gamma{i} = SmoothGamma;
    
    D = zscore(log10(Data(Smooth_Gamma{i}))');
    h=histogram(D,'BinLimits',[-2 4],'NumBins',200);
    HistData(i,:) = h.Values./sum(h.Values);
    
    D1 = Data(Restrict(tsd(Range(Smooth_Gamma{i}) , D') , Wake));
    h=histogram(D1,'BinLimits',[-2 4],'NumBins',200);
    HistData_Wake(i,:) = h.Values./sum(h.Values);
    
    D2 = Data(Restrict(tsd(Range(Smooth_Gamma{i}) , D') , Sleep));
    h=histogram(D2,'BinLimits',[-2 4],'NumBins',200);
    HistData_Sleep(i,:) = h.Values./sum(h.Values);
end

figure
Data_to_use = HistData;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(-2,4,200), runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
ylim([0 .045]), xlabel('Gamma power (zscore)'), ylabel('PDF')
makepretty

figure
Data_to_use = HistData_Wake;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(-2,4,200), runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-b',1); hold on;
Data_to_use = HistData_Sleep;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
shadedErrorBar(linspace(-2,4,200), runmean(nanmean(Data_to_use),3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

ylim([0 .045]), xlabel('Gamma power (zscore)'), ylabel('PDF')
makepretty


%% Overlap
load('/media/nas7/React_Passive_AG/OBG/paper_processing/Data_Paper/Paper_Data_Ferret.mat')
% or edit Overlap_EMG_Gamma_Ferret_BM.m

Cols={[.6 .5 .9],[.8 .5 .9]};
X=[1:2];
Legends={'Ferret 1','Ferret 2'};

figure
MakeSpreadAndBoxPlot3_SB({Overlap2(1,:) Overlap2(2,:)},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('Overlap'), ylim([0 1])

%% corr plot
CorrPlot_EMG_Gamma_Ferret_Example_BM

%% Transitions
Transition_Wake_Sleep_Ferret_BM

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : REM/NREM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spectrograms
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma')
REMEpoch = mergeCloseIntervals(REMEpoch,25e4);
REMEpoch = dropShortIntervals(REMEpoch,25e4);
H = load('H_Low_Spectrum.mat');
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});
[H_Sptsd_clean,~,EpochClean] = CleanSpectro(H_Sptsd , H.Spectro{3} , 5);

figure
subplot(6,1,4:5)

imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),5)',50)'), axis xy
ylabel('Frequency (Hz)')
colormap viridis, caxis([2.8 4.3])

LineHeight = 19;
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = [0 0 0];
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('Hippocampus', 'FontSize', 14)

% % clean ?
% figure
% imagesc(Range(H_Sptsd_clean)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd_clean)'),5)',50)'), axis xy
% xlabel('time (hours)'), ylabel('Frequency (Hz)')
% colormap jet
% 
% LineHeight = 19;
% Colors.SWS = 'r';
% Colors.REM = 'g';
% Colors.Wake = 'b';
% Colors.Noise = [0 0 0];
% PlotPerAsLine(and(Wake,EpochClean),LineHeight,Colors.Wake,'timescaling',3.6e7);
% PlotPerAsLine(and(SWSEpoch,EpochClean),LineHeight,Colors.SWS,'timescaling',3.6e7);
% PlotPerAsLine(and(REMEpoch,EpochClean),LineHeight,Colors.REM,'timescaling',3.6e7);
subplot(616)

plot(Range(SmoothTheta,'s')/3.6e3 , runmean(Data(SmoothTheta),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 10])
box off
ylabel('Theta/Delta')
xlabel('Time (hours)'), ylabel('Gamma power')


% B = load('B_Middle_Spectrum.mat');
B = load('B_High_Spectrum.mat');

B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});

subplot(6,1,1:2)

imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),5)',500)'), axis xy
ylabel('Frequency (Hz)'), ylim([20 100])
caxis([2 3.5])

LineHeight = 95;
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = [0 0 0];
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('Olfactory Bulb', 'FontSize', 14)

subplot(613)

plot(Range(SmoothGamma,'s')/3.6e3 , runmean(Data(SmoothGamma),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothGamma,'s')/3.6e3)]), ylim([0 7e2])
box off

%% Corr plot
Epoch_4h = intervalSet(0, 4*3600*1e4);
SmoothGammaf = Restrict(SmoothGamma, Epoch_4h);
SmoothThetaf = Restrict(SmoothTheta, Epoch_4h);
Sleepf = and(Sleep, Epoch_4h);
Wakef = and(Wake, Epoch_4h);
SWSEpochf = and(SWSEpoch, Epoch_4h);
REMEpochf = and(REMEpoch, Epoch_4h);
SmoothGamma_int2f = SmoothGammaf;

cd('') % find session, Epoch=intervalSet(0,1e7) if I remember correctly

figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(Restrict(SmoothGammaf, Epoch))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
ylim([0 2.5e4]), box off
v1=vline(2.7,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Restrict(SmoothThetaf , and(Sleepf , Epoch)))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
xlabel('HPC theta / delta power (a.u.)'), xlim([-.5 .85])
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(.318,'-r'); v2.LineWidth=5;
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
TSD = Restrict(SmoothGamma_int2f , and(Wakef , Epoch));
X = log10(Data(TSD)); Y = log10(Data(Restrict(Restrict(SmoothThetaf,TSD) , and(Wakef , Epoch)))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.b'), hold on
TSD = Restrict(SmoothGamma_int2f , and(SWSEpochf , Epoch));
X = log10(Data(TSD)); Y = log10(Data(Restrict(Restrict(SmoothThetaf,TSD) , and(SWSEpochf , Epoch)))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.r')
TSD = Restrict(SmoothGamma_int2f , and(REMEpochf , Epoch));
X = log10(Data(TSD)); Y = log10(Data(Restrict(Restrict(SmoothThetaf,TSD) , and(REMEpochf , Epoch)))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.g')
axis square
f=get(gca,'Children'); l=legend([f([3 2 1])],'Wake','NREM','REM'); 



%% mean spectrums
edit MeanSpectrums_AllFerret_Sleep_BM.m

%% eye movement
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('DLC/DLC_data.mat', 'areas_pupil_tsd', 'pupil_mvt_tsd')
load('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch')
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);

smooth_PupilSize = tsd(Range(areas_pupil_tsd) , runmean(Data(areas_pupil_tsd),1e2));
PupilSize_Wake = Restrict(smooth_PupilSize , Wake);
PupilSize_NREM = Restrict(smooth_PupilSize , SWSEpoch);
PupilSize_REM = Restrict(smooth_PupilSize , REMEpoch);

smooth_PupilMvt = tsd(Range(pupil_mvt_tsd) , runmean(Data(pupil_mvt_tsd),1e2));
PupilMvt_Wake = Restrict(smooth_PupilMvt , Wake);
PupilMvt_NREM = Restrict(smooth_PupilMvt , SWSEpoch);
PupilMvt_REM = Restrict(smooth_PupilMvt , REMEpoch);


figure
subplot(2,5,1:4)
plot(Range(PupilSize_Wake,'s')/3.6e3 , Data(PupilSize_Wake) , '.b')
hold on
plot(Range(PupilSize_NREM,'s')/3.6e3 , Data(PupilSize_NREM) , '.r')
plot(Range(PupilSize_REM,'s')/3.6e3 , Data(PupilSize_REM) , '.g')
ylabel('pupil size (a.u.)')
box off
legend('Wake','NREM','REM')

subplot(2,5,6:9)
plot(Range(PupilMvt_Wake,'s')/3.6e3 , Data(PupilMvt_Wake) , '.b')
hold on
plot(Range(PupilMvt_NREM,'s')/3.6e3 , Data(PupilMvt_NREM) , '.r')
plot(Range(PupilMvt_REM,'s')/3.6e3 , Data(PupilMvt_REM) , '.g')
xlabel('time (hours)'), ylabel('pupil movement (a.u.)')
box off


subplot(255)
[Y,X]=hist(Data(PupilSize_Wake),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'b','LineWidth',2)
hold on
[Y,X]=hist(Data(PupilSize_NREM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'r','LineWidth',2)
[Y,X]=hist(Data(PupilSize_REM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'g','LineWidth',2)
xlabel('pupil size (a.u.)'), ylabel('PDF')
xlim([0 1500]), box off

subplot(2,5,10)
[Y,X]=hist(Data(PupilMvt_Wake),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'b','LineWidth',2)
hold on
[Y,X]=hist(Data(PupilMvt_NREM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'r','LineWidth',2)
[Y,X]=hist(Data(PupilMvt_REM),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,90),'g','LineWidth',2)
xlabel('pupil movement (a.u.)'), ylabel('PDF')
box off, xlim([0 1])


%% pharmacological confirmation
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240201_atropine/')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma')
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
H = load('H_Low_Spectrum.mat');
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});

figure
subplot(6,1,1:2)
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),5)',50)'), axis xy
ylabel('Frequency (Hz)')
colormap viridis, caxis([2.8 4.3])

LineHeight = 19;
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = [0 0 0];
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('HPC')

text(1.3,22,'Atropine injection','FontSize',8)
u=text(1.5,19,'-----','FontSize',8); set(u,'Rotation',90)

subplot(613)
plot(Range(SmoothTheta,'s')/3.6e3 , runmean(Data(SmoothTheta),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 10])
box off
ylabel('Theta/Delta')


B = load('B_Middle_Spectrum.mat');
B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});

subplot(6,1,4:5)
imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),5)',500)'), axis xy
ylabel('Frequency (Hz)'), ylim([20 100])
caxis([2 3.5])

LineHeight = 95;
Colors.SWS = 'r';
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = [0 0 0];
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('OB')

subplot(616)
plot(Range(SmoothGamma,'s')/3.6e3 , runmean(Data(SmoothGamma),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothGamma,'s')/3.6e3)]), ylim([0 7e2])
box off
xlabel('time (hours)'), ylabel('Gamma power')


%% transitions
edit SleepTransitions_Ferret_BM.m

%% EMG drop
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240124')
load('LFPData/LFP4.mat')
FilLFP = FilterLFP(LFP,[50 300],1024);
EMGDataf = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));

load('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch')
EMG_Wake = Restrict(EMGDataf , Wake);
EMG_NREM = Restrict(EMGDataf , SWSEpoch);
EMG_REM = Restrict(EMGDataf , REMEpoch);

figure
plot(Range(EMG_Wake,'s')/3600 , log10(Data(EMG_Wake)) , '.b')
hold on
plot(Range(EMG_NREM,'s')/3600 , log10(Data(EMG_NREM)) , '.r')
plot(Range(EMG_REM,'s')/3600 , log10(Data(EMG_REM)) , '.g')


figure
[Y,X]=hist(log10(Data(EMG_Wake)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,10),'b','LineWidth',1)
hold on
[Y,X]=hist(log10(Data(EMG_NREM)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,10),'r','LineWidth',1)
[Y,X]=hist(log10(Data(EMG_REM)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,10),'g','LineWidth',1)
xlabel('EMG power (log scale)'), ylabel('PDF')
box off, xlim([1.5 6])
legend('Wake','NREM','REM')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3: .1-.5Hz 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Raw traces
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
for l=[25 26 35] % OB1 OB2 Piezzo
    load(['LFPData/LFP' num2str(l) '.mat'])
    LFP_ferret{l} = LFP;
    LFP_ferret_Fil{l} = FilterLFP(LFP,[20 100],1024);
    LFP_ferret_Fil2{l} = FilterLFP(LFP,[.1 10],1024);
end

figure
plot(Range(LFP_ferret{25},'s') , Data(LFP_ferret{25}) , 'k')
hold on
plot(Range(LFP_ferret{26},'s') , Data(LFP_ferret{26})-3e3 , 'k')
plot(Range(LFP_ferret_Fil2{35},'s') , Data(LFP_ferret_Fil2{35})-3.5e3 , 'r','LineWidth',2)
plot(Range(LFP_ferret_Fil{25},'s') , Data(LFP_ferret_Fil{25})-5.5e3 , 'k')
xlim([8249 8259]), axis off
text(8248,3.5e3,'Piezzo','FontSize',15,'Color','r')
text(8247.7,3e3,'thoracic cavity','FontSize',15,'Color','r')
text(8248,-1.75e3,'OB','FontSize',15)
text(8248.1,-5.5e3,'filtered','FontSize',15)
text(8248,-6e3,'20-100Hz','FontSize',15)

line([8249 8250],[-8e3 -8e3],'LineStyle','-','Color','k','LineWidth',5)
text(8249.4,-7.7e3,'1s','FontSize',15)



%% corr Breathing/gamma
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')
load('SleepScoring_OBGamma.mat', 'SWSEpoch', 'REMEpoch' , 'Wake')
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);

load('LFPData/LFP26.mat')
FilGamma = FilterLFP(LFP,[40 60],1024);
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); 
smootime=.06;
SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));


FilULow = FilterLFP(LFP,[.1 1],1024); 
tEnveloppeULow = tsd(Range(LFP), abs(hilbert(Data(FilULow))) ); 
smootime=.006;
SmoothULow = tsd(Range(tEnveloppeULow), runmean(Data(tEnveloppeULow), ...
    ceil(smootime/median(diff(Range(tEnveloppeULow,'s'))))));


SmoothULow_Wake = Restrict(SmoothULow , Wake);
[c_wake,lags] = xcorr(Data(SmoothULow_Wake) , Data(Restrict(SmoothGamma,SmoothULow_Wake)) , 3750 , 'biased');

figure
plot(linspace(-3,3,7501) , c_wake , 'b' , 'LineWidth' , 2)
xlabel('lag (s)'), ylabel('Corr values 0.1-1Hz/40-60Hz (a.u.)'), xlim([-3 3])
vline(0,'--r')
box off


%% raw signals Sleep
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/')
for l=[24 1] % OB HPC
    load(['LFPData/LFP' num2str(l) '.mat'])
    LFP_ferret{l} = LFP;
    LFP_ferret_Fil{l} = FilterLFP(LFP,[.1 1],1024);
    LFP_ferret_Fil2{l} = FilterLFP(LFP,[3 6],1024);
end

figure
subplot(131)
plot(Range(LFP_ferret{24},'s') , Data(LFP_ferret{24}) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(LFP_ferret{1},'s') , Data(LFP_ferret{1})*5-6e3 , 'k' , 'LineWidth' , .2)
xlim([2987 3007]), ylim([-1e4 5e3]), axis off
text(2985,0,'OB','FontSize',15)
text(2985,-6e3,'HPC','FontSize',15)
line([2987 2990],[-1e4 -1e4],'LineStyle','-','Color','k','LineWidth',5)
text(2988,-.92e4,'3s','FontSize',15)
title('NREM1')

subplot(132)
plot(Range(LFP_ferret{24},'s') , Data(LFP_ferret{24}) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(LFP_ferret{1},'s') , Data(LFP_ferret{1})*5-6e3 , 'k' , 'LineWidth' , .2)
xlim([3280 3300]), ylim([-1e4 5e3]), axis off
title('NREM2')

subplot(133)
plot(Range(LFP_ferret{24},'s') , Data(LFP_ferret{24}) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(LFP_ferret{1},'s') , Data(LFP_ferret{1})*5-6e3 , 'k' , 'LineWidth' , .2)
xlim([4680 4700]), ylim([-1e4 5e3]), axis off
title('REM')



%% Corr plot Sleep
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma',...
    'smooth_01_05', 'Epoch_S1', 'Epoch_S2', 'TotalNoiseEpoch','Sleep')
Wake = or(Wake , TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,3e4);
Wake = dropShortIntervals(Wake,3e4);
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
NREM2 = and(Epoch_S1 , SWSEpoch);
NREM2 = mergeCloseIntervals(NREM2,3e4);
NREM2 = dropShortIntervals(NREM2,3e4);
NREM1 = and(Epoch_S2 , SWSEpoch);
NREM1 = mergeCloseIntervals(NREM1,3e4);
NREM1 = dropShortIntervals(NREM1,3e4);

load(['LFPData/LFP' num2str(26) '.mat'])
FilLFP = FilterLFP(LFP,[.4 1],1024);
smooth_01_05 = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));


SmoothTheta_Sleep = Restrict(SmoothTheta , Sleep);
smooth_01_05_Sleep = Restrict(smooth_01_05 , Sleep);



figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothTheta_Sleep)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
xlim([-.4 1]), ylim([0 3e4]), box off
v1=vline(.37,'-r'); v1.LineWidth=5;
xlabel('HPC theta / delta power (a.u.)')

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(smooth_01_05_Sleep)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
xlabel('OB 0.1-1 power (a.u.)'), xlim([1.4 2.8])
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(2.13,'-r'); v2.LineWidth=5;
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothTheta_Sleep , NREM2))); Y = log10(Data(Restrict(smooth_01_05_Sleep , NREM2))); 
plot(X(1:3e3:end) , Y(1:3e3:end) , '.','MarkerSize',10,'Color',[.5 0 0]), hold on
X = log10(Data(Restrict(SmoothTheta_Sleep , REMEpoch))); Y = log10(Data(Restrict(smooth_01_05_Sleep , REMEpoch))); 
plot(X(1:3e3:end) , Y(1:3e3:end) , '.g','MarkerSize',10), hold on
X = log10(Data(Restrict(SmoothTheta_Sleep , NREM1))); Y = log10(Data(Restrict(smooth_01_05_Sleep , NREM1))); 
plot(X(1:3e3:end) , Y(1:3e3:end) , '.','MarkerSize',10,'Color',[1 .5 .5]), hold on
axis square, xlim([-.4 1]), ylim([1.4 2.8])
f=get(gca,'Children'); l=legend([f([1 3 2])],'NREM1','NREM2','REM'); 


%% correspondance
SleepInfo = GetSleepSessions_Ferret_BM;

for ferret=1:2
    for sess=1:length(SleepInfo.path{ferret})
        cd(SleepInfo.path{ferret}{sess})
        
        load('SleepScoring_OBGamma.mat', 'Wake', 'SWSEpoch', 'REMEpoch', 'TotalNoiseEpoch', 'Epoch', 'Epoch_S1', 'Epoch_S2')
        Wake = or(Wake , TotalNoiseEpoch);
        REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
        REMEpoch = dropShortIntervals(REMEpoch,35e4);
        Wake = mergeCloseIntervals(Wake,3e4);
        Wake = dropShortIntervals(Wake,3e4);
        TotDur = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)));
        
        % S1-NREM S1-REM S2-NREM S2-REM
        Overlap(ferret,sess,1) =  sum(DurationEpoch(and(SWSEpoch , Epoch_S1)))./TotDur;
        Overlap(ferret,sess,2) =  sum(DurationEpoch(and(REMEpoch , Epoch_S1)))./TotDur;
        Overlap(ferret,sess,3) =  sum(DurationEpoch(and(SWSEpoch , Epoch_S2)))./TotDur;
        Overlap(ferret,sess,4) =  sum(DurationEpoch(and(REMEpoch , Epoch_S2)))./TotDur;
        
        disp(sess)
    end
end
Overlap(2,7:end,:) = NaN;

Cols={[1 .5 .5],[.5 0 0],[0 1 0],[.3 .3 .3]};
X=[1:4];
Legends={'NREM1','NREM2','REM1','REM2'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Overlap(1,:,3) Overlap(1,:,1) Overlap(1,:,4) Overlap(1,:,2)},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('% of total duration'), ylim([0 .6]), title('Ferret 1')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Overlap(2,:,3) Overlap(2,:,1) Overlap(2,:,4) Overlap(2,:,2)},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 .6]), title('Ferret 2')


%% Spectrograms
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma',...
    'smooth_01_05', 'Epoch_S1', 'Epoch_S2', 'TotalNoiseEpoch')
Wake = or(Wake , TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,3e4);
Wake = dropShortIntervals(Wake,3e4);
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
NREM2 = and(Epoch_S1 , SWSEpoch);
NREM2 = mergeCloseIntervals(NREM2,3e4);
NREM2 = dropShortIntervals(NREM2,3e4);
NREM1 = and(Epoch_S2 , SWSEpoch);
NREM1 = mergeCloseIntervals(NREM1,3e4);
NREM1 = dropShortIntervals(NREM1,3e4);

H = load('H_Low_Spectrum.mat');
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});

figure
%
subplot(9,1,1:2)
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),5)',50)'), axis xy
ylabel('Frequency (Hz)')
colormap viridis, caxis([1.5 4])
title('HPC')

Colors.Wake = 'b';
Colors.REM = 'g';
Colors.NREM1 = [1 .5 .5];
Colors.NREM2 = [.5 0 0];
Colors.Noise = [0 0 0];

LineHeight = 19;
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(NREM1,LineHeight,Colors.NREM1,'timescaling',3.6e7);
PlotPerAsLine(NREM2,LineHeight,Colors.NREM2,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);

g=[length(Start(REMEpoch))+length(Start(NREM2))+length(Start(NREM1))+1 length(Start(REMEpoch))+length(Start(NREM2))+1 ...
length(Start(REMEpoch))+1 1];
f=get(gca,'Children'); l=legend([f(g)],'Wake','NREM1','NREM2','REM');

subplot(913)
plot(Range(SmoothTheta,'s')/3.6e3 , runmean(Data(SmoothTheta),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 10])
box off
ylabel('Theta/Delta')


B = load('B_UltraLow_Spectrum.mat');
B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});

%
subplot(9,1,4:5)
imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),5)',5)'), axis xy
ylabel('Frequency (Hz)')
caxis([1.3 5])

LineHeight = .95;
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(NREM1,LineHeight,Colors.NREM1,'timescaling',3.6e7);
PlotPerAsLine(NREM2,LineHeight,Colors.NREM2,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);

title('OB Ultra low')

subplot(916)
plot(Range(smooth_01_05,'s')/3.6e3 , runmean(Data(smooth_01_05),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(smooth_01_05,'s')/3.6e3)]), ylim([0 7e2])
box off
ylabel('Gamma power')


B = load('B_Middle_Spectrum.mat');
B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});
%
subplot(9,1,7:8)
imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),5)',500)'), axis xy
ylabel('Frequency (Hz)'), ylim([20 100])
caxis([2.5 3.5])
title('OB High')

LineHeight = 95;
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(NREM1,LineHeight,Colors.NREM1,'timescaling',3.6e7);
PlotPerAsLine(NREM2,LineHeight,Colors.NREM2,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);

subplot(919)
plot(Range(SmoothGamma,'s')/3.6e3 , runmean(Data(SmoothGamma),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothGamma,'s')/3.6e3)]), ylim([0 1e3])
box off
xlabel('time (hours)'), ylabel('Gamma power')


%% Delta power
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma',...
    'smooth_01_05', 'Epoch_S1', 'Epoch_S2', 'TotalNoiseEpoch')
Wake = or(Wake , TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,3e4);
Wake = dropShortIntervals(Wake,3e4);
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
NREM2 = and(Epoch_S1 , SWSEpoch);
NREM2 = mergeCloseIntervals(NREM2,3e4);
NREM2 = dropShortIntervals(NREM2,3e4);
NREM1 = and(Epoch_S2 , SWSEpoch);
NREM1 = mergeCloseIntervals(NREM1,3e4);
NREM1 = dropShortIntervals(NREM1,3e4);


load('LFPData/LFP25.mat')
smootime=3;
FilLFP = FilterLFP(LFP,[.5 4],1024);
tEnveloppe = tsd(Range(LFP), abs(hilbert(Data(FilLFP))) );
Delta_Power = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

DeltaPower_NREM1 = Restrict(Delta_Power , NREM1);
DeltaPower_NREM2 = Restrict(Delta_Power , NREM2);
DeltaPower_REM = Restrict(Delta_Power , REMEpoch);


figure
[Y,X]=hist(log10(Data(DeltaPower_NREM1)),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[1 .5 .5],'LineWidth',2)
hold on
[Y,X]=hist(log10(Data(DeltaPower_NREM2)),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[.5 0 0],'LineWidth',2)
[Y,X]=hist(log10(Data(DeltaPower_REM)),100);
Y=Y/sum(Y);
plot(X,Y,'g','LineWidth',2)
xlabel('PFC delta power (log scale)'), ylabel('PDF'), xlim([1 2.5])
box off, legend('NREM1','NREM2','REM')



%% physio
cd('/media/nas7/React_Passive_AG/OBG/Labneh/head-fixed/20230227/')

load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'SmoothTheta', 'SmoothGamma',...
    'smooth_01_05', 'Epoch_S1', 'Epoch_S2', 'TotalNoiseEpoch', 'Epoch')
Wake = or(Wake , TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,3e4);
Wake = dropShortIntervals(Wake,3e4);
REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);
NREM2 = and(Epoch_S1 , SWSEpoch);
NREM2 = mergeCloseIntervals(NREM2,3e4);
NREM2 = dropShortIntervals(NREM2,3e4);
NREM1 = and(Epoch_S2 , SWSEpoch);
NREM1 = mergeCloseIntervals(NREM1,3e4);
NREM1 = dropShortIntervals(NREM1,3e4);
TotDur = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))./3.6e7;

load('HeartBeatInfo.mat', 'EKG')
HRVar = tsd(Range(EKG.HBRate) , movstd(Data(EKG.HBRate),5));

HR_Wake  = Restrict(EKG.HBRate , Wake);
HR_NREM1  = Restrict(EKG.HBRate , NREM1);
HR_NREM2  = Restrict(EKG.HBRate , NREM2);
HR_REM  = Restrict(EKG.HBRate , REMEpoch);

HRVar_Wake  = Restrict(HRVar , Wake);
HRVar_NREM1  = Restrict(HRVar , NREM1);
HRVar_NREM2  = Restrict(HRVar , NREM2);
HRVar_REM  = Restrict(HRVar , REMEpoch);


figure
subplot(121)
[Y,X]=hist(Data(HR_Wake),100);
Y=Y/sum(Y);
plot(X,Y,'b','LineWidth',1)
hold on
[Y,X]=hist(Data(HR_NREM1),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[1 .5 .5],'LineWidth',1)
[Y,X]=hist(Data(HR_NREM2),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[.5 0 0],'LineWidth',1)
[Y,X]=hist(Data(HR_REM),100);
Y=Y/sum(Y);
plot(X,Y,'g','LineWidth',1)
xlabel('Heart rate (Hz)'), ylabel('PDF')
box off, xlim([2 7])
legend('Wake','NREM1','NREM2','REM')

subplot(122)
[Y,X]=hist(log10(Data(HRVar_Wake)),100);
Y=Y/sum(Y);
plot(X,Y,'b','LineWidth',1)
hold on
[Y,X]=hist(log10(Data(HRVar_NREM1)),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[1 .5 .5],'LineWidth',1)
[Y,X]=hist(log10(Data(HRVar_NREM2)),100);
Y=Y/sum(Y);
plot(X,Y,'Color',[.5 0 0],'LineWidth',1)
[Y,X]=hist(log10(Data(HRVar_REM)),100);
Y=Y/sum(Y);
plot(X,Y,'g','LineWidth',1)
xlabel('Heart rate var (a.u.)'), ylabel('PDF')
box off, xlim([-3 1])


% Breathing Piezzo, frequency and variability
P = load('Piezzo_ULow_Spectrum.mat');
Sptsd = tsd(P.Spectro{2}*1e4 , P.Spectro{1});
[Sptsd_clean,~,EpochClean] = CleanSpectro(Sptsd , P.Spectro{3} , 8);

Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(P.Spectro{3} , Range(Sptsd_clean) , Data(Sptsd_clean) , 'frequency_band' , [.25 1]);
Breathing_var = tsd(Range(Spectrum_Frequency) , movstd(Data(Spectrum_Frequency) , ceil(30/median(diff(Range(Spectrum_Frequency,'s')))),'omitnan'));

Breathing_Wake  = Restrict(Spectrum_Frequency , Wake);
Breathing_NREM1  = Restrict(Spectrum_Frequency , NREM1);
Breathing_NREM2  = Restrict(Spectrum_Frequency , NREM2);
Breathing_REM  = Restrict(Spectrum_Frequency , REMEpoch);

Breathing_var_Wake = Restrict(Breathing_var , Wake);
Breathing_var_NREM1 = Restrict(Breathing_var , NREM1);
Breathing_var_NREM2 = Restrict(Breathing_var , NREM2);
Breathing_var_REM = Restrict(Breathing_var , REMEpoch);


figure
subplot(121)
[Y,X]=hist(Data(Breathing_Wake),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'b','LineWidth',1)
hold on
[Y,X]=hist(Data(Breathing_NREM1),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'Color',[1 .5 .5],'LineWidth',1)
[Y,X]=hist(Data(Breathing_NREM2),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'Color',[.5 0 0],'LineWidth',1)
[Y,X]=hist(Data(Breathing_REM),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'g','LineWidth',1)
xlabel('Breathing rate (Hz)'), ylabel('PDF')
box off,% xlim([1.5 6])
legend('Wake','NREM1','NREM2','REM')

subplot(122)
[Y,X]=hist(Data(Breathing_var_Wake),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'b','LineWidth',1)
hold on
[Y,X]=hist(Data(Breathing_var_NREM1),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'Color',[1 .5 .5],'LineWidth',1)
[Y,X]=hist(Data(Breathing_var_NREM2),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'Color',[.5 0 0],'LineWidth',1)
[Y,X]=hist(Data(Breathing_var_REM),100);
Y=Y/sum(Y);
plot(X,runmean(Y,3),'g','LineWidth',1)
xlabel('Breathing variability (a.u.)'), ylabel('PDF')
box off, xlim([0 .35])







%% on going stuff

Q = MakeQfromS(B,Binsize);
Q = tsd(Range(Q),full(Data(Q)));
D = Data(Q);



figure
imagesc(corr(log10(FiringRate_State([2 4:6],:)')))
axis square
xticks([1:5]), yticks([1:5]), xtickangle(45)
xticklabels({'Wake','REM','NREM1','NREM2'}), yticklabels({'Wake','REM','NREM1','NREM2'})
colormap redblue
caxis([-1 1])




figure
plot(Range(MovAcctsd,'s') , movmean(log10(Data(MovAcctsd)),3000,'omitnan'))


imagesc(Spectro{2} , Spectro{3} , SmoothDec(log10(Spectro{1})'), axis xy


load('B_Middle_Spectrum.mat')
Bef_inj = intervalSet(0 , (91*60+40)*1e4);
Aft_inj = intervalSet((91*60+40)*1e4 , (180*3.5)*60e4);
Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
Sp_Bef = Restrict(Sp_tsd , Bef_inj);
Sp_Aft = Restrict(Sp_tsd , Aft_inj);

figure
plot(Spectro{3} , nanmean(log10(Data(Sp_Bef))),'k')
hold on
plot(Spectro{3} , nanmean(log10(Data(Sp_Aft))),'g')
xlabel('Frequency (Hz)'), ylabel('Power (log scale)'), ylim([1.5 4])
legend('Before injection','After injection')
makepretty






figure
subplot(121)
Data_to_use = zscore(EMG_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.3 .5 .7]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Gamma_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.7 .5 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Acc_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(Acc_Data_WakeSleep)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.5 .7 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
vline(0,'--r'), xlabel('time (s)'), ylabel('Norm. power'), ylim([-1.5 2.5])
f=get(gca,'Children'); l=legend([f([12 8 4])],'EMG','OB','Acc'); 
makepretty
text(-7,2.5,'Wake','FontSize',15), text(3,2.5,'Sleep','FontSize',15)

subplot(122)
Data_to_use = zscore(EMG_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.3 .5 .7]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Gamma_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.7 .5 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Acc_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(Acc_Data_SleepWake)) , runmean(Mean_All_Sp,1) , runmean(Conf_Inter,1),'-k',1); hold on;
color= [.5 .7 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty
text(-7,2,'Sleep','FontSize',15), text(3,2.5,'Wake','FontSize',15)
vline(0,'--r'), xlabel('time (s)'), ylabel('Norm. power'), ylim([-1.5 2.5])

