
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : OB gamma tracks Wake/sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Raw traces
edit Ferret_Paper_RawTraces_Gamma.m


%% Mean spectrum
edit Ferret_Paper_MeanSpectrums_Gamma.m


%% Gamma values distribution
edit Ferret_Paper_PowerDistributions_Gamma.m


%% corr plot
edit CorrPlot_EMG_Gamma_Ferret_Example_BM.m


%% Overlap
edit Overlap_EMG_Gamma_Ferret_BM.m


%% Transitions
edit Transition_Wake_Sleep_Ferret_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : REM/NREM/IS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Raw traces
edit Ferret_Paper_RawTraces_SleepStates.m


%% Spectrograms
edit Ferret_Paper_Spectrograms_SleepStates.m


%% 3 types of sleep
edit Ferret_Paper_CorrPlot_SleepStates.m


%% schematic & splitted spectro
edit Ferret_Paper_SleeScoring_Illustration.m


%% PCA say the same
edit Ferret_Paper_PCA_Spectrograms_SleepStates.m


%% where does this OB rhythm comes from ?
edit Ferret_Paper_Delta_AcrossCortices_Sleep.m % delta power across cortices
edit Ferret_Paper_OB_Delta_NREM.m % is there delta in OB ?


%% mean spectrums
edit MeanSpectrums_AllFerret_Sleep_BM.m


%% REM confirmation
edit Ferret_Paper_REMconfirm_EyeMov.m
edit Ferret_Paper_REMconfirm_Pharmaco.m


%% IS sleep study
edit Ferret_Paper_IS_Sleep_Study.m
% edit NREM_subtypes_Ferret_BM.m


%% transitions
edit SleepTransitions_Ferret_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3: OB/pupil correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% cross-corr




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

