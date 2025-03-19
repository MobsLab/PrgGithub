

load('H_Middle_Spectrum.mat')
load('SleepScoring_OBGamma.mat')

%% OB Gamma during phasic REM

% detect phasic REM
load('H_Low_Spectrum.mat')

Sptsd_H_Low=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_H_Low_Wake=Restrict(Sptsd_H_Low,Wake);
Sptsd_H_Low_NREM=Restrict(Sptsd_H_Low,SWSEpoch);
Sptsd_H_Low_REM=Restrict(Sptsd_H_Low,REMEpoch);

Sp_Wake=Data(Sptsd_Wake); Rg_Wake=Range(Sptsd_Wake,'s');
Sp_NREM=Data(Sptsd_NREM); Rg_NREM=Range(Sptsd_NREM,'s');
Sp_REM=Data(Sptsd_REM); Rg_REM=Range(Sptsd_REM,'s');

LowRange = Spectro{3};

% mean spectrum Hippocampus Low
figure
subplot(131)
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 2e4]); xlim([10 100])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('linear scale')

% 1) Theta power 12-13 Hz distribution 

MeanPower_12_13_band_REM = nanmean(Sp_REM(:,157:170)');

figure
nhist({log10(MeanPower_12_13_band_REM)} , 'samebins')
makepretty
title('Mean power [20-50 Hz] distribution')
xlabel('Power (log scale)')

% 2) Ratio power 10-12 Hz / 4-12 Hz distribution 

MeanPower_10_12_4_12_band_REM = nanmean(Sp_REM(:,131:157)')./nanmean(Sp_REM(:,52:157)');

figure
nhist({log10(MeanPower_10_12_4_12_band_REM)} , 'samebins')
makepretty
title('Mean power [20-50 Hz] distribution')
xlabel('Power (log scale)')

% 3) Looking at HPC gamma power & theta power 

load('H_Middle_Spectrum.mat')

Sptsd_HPC=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake_HPC=Restrict(Sptsd_HPC,Wake);
Sptsd_NREM_HPC=Restrict(Sptsd_HPC,SWSEpoch);
Sptsd_REM_HPC=Restrict(Sptsd_HPC,REMEpoch);

load('B_Middle_Spectrum.mat')

Sptsd_Bulb = tsd(Spectro{2}*1e4 , Spectro{1});
Sptsd_Wake_Bulb = Restrict(Sptsd_Bulb , Wake);
Sptsd_NREM_Bulb = Restrict(Sptsd_Bulb , SWSEpoch);
Sptsd_REM_Bulb = Restrict(Sptsd_Bulb , REMEpoch);


Data_Sptsd_REM_HPC = Data(Sptsd_REM_HPC);
GammaPower_Sptsd_REM_HPC = nanmean(Data_Sptsd_REM_HPC(:,24:62)'); % Gamma power between 35-80 Hz
ThetaPower_Sptsd_REM_HPC = nanmean(Data_Sptsd_REM_HPC(:,1:6)'); % theta power between 6-12 Hz
FastThetaPower_Sptsd_REM_HPC = nanmean(Data_Sptsd_REM_HPC(:,6:7)'); % theta power between 12-13 Hz
ThetaRhythm_REM_HPC = ConvertSpectrum_in_Frequencies_BM(LowRange , Range(Sptsd_H_Low_REM) , Data(Sptsd_H_Low_REM) , 4); % theta frequency evolution
ThetaRhythm_REM_HPC_OnGammaTime = Restrict(ThetaRhythm_REM_HPC , ts(Range(Sptsd_REM_HPC))); % thetha frequency with gamma times

Data_Sptsd_REM_Bulb = Data(Sptsd_REM_Bulb);
GammaPower_Sptsd_REM_Bulb = nanmean(Data_Sptsd_REM_Bulb(:,13:33)'); % Gamma power between 20-45 Hz


figure
subplot(121)
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_Wake_HPC)),'b')
hold on
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_NREM_HPC)),'r')
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_REM_HPC)),'g')
legend('Wake','NREM','REM')
makepretty
set(gca,'yscale','log')
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('Gamma Power, HPC')

subplot(122)
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_Wake_Bulb)),'b')
hold on
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_NREM_Bulb)),'r')
plot(Spectro{3} , Spectro{3}.*nanmean(Data(Sptsd_REM_Bulb)),'g')
makepretty
set(gca,'yscale','log')
xlabel('Frequency (Hz)')
title('Gamma Power, Bulb')

% Trying to detect phasic REM
figure
clf
plot(runmean(GammaPower_Sptsd_REM_HPC,300),'.g','MarkerSize',1)
ylim([1e3 2.5e4]); xlim([0 418130])
hold on
plot(runmean(Data(ThetaRhythm_REM_HPC_OnGammaTime),200)*1e3,'.r','MarkerSize',1)
plot(runmean(FastThetaPower_Sptsd_REM_HPC,300)/30+1e4,'.c','MarkerSize',1)
plot(runmean(ThetaPower_Sptsd_REM_HPC,300)/30+1.5e4,'.m','MarkerSize',1)
legend('Gamma power 35-80Hz','Theta frequency','Theta power 12-13Hz','Theta power 6-12Hz')
makepretty
title('Detecting phasic REM using differents methods')



MeanPower_GammaREM_HPC_tsd = tsd(Range(Sptsd_REM_HPC) , runmean(GammaPower_Sptsd_REM_HPC,100)');
MeanPower_GammaREM_Bulb_tsd = tsd(Range(Sptsd_REM_Bulb) , runmean(GammaPower_Sptsd_REM_Bulb,100)');

Epoch_With_REMGamma_High = thresholdIntervals(MeanPower_GammaREM_HPC_tsd , 4e3 , 'Direction','Above');
Epoch_With_REMGamma_High=mergeCloseIntervals(Epoch_With_REMGamma_High,0.3*1e4);
Epoch_With_REMGamma_High=dropShortIntervals(Epoch_With_REMGamma_High,1*1e4);


sum(Stop(Epoch_With_REMGamma_High)-Start(Epoch_With_REMGamma_High))/sum(Stop(REMEpoch)-Start(REMEpoch))

MeanPower_GammaREM_HPC_tsd_PasicREM = Restrict(MeanPower_GammaREM_HPC_tsd , Epoch_With_REMGamma_High);
MeanPower_GammaREM_Bulb_tsd_PasicREM = Restrict(MeanPower_GammaREM_Bulb_tsd , Epoch_With_REMGamma_High);


[a b] = find(Data(MeanPower_GammaREM_HPC_tsd_PasicREM) == runmean(GammaPower_Sptsd_REM_HPC,100));

% Is OB gamma correlated with HPC gamma ?
figure
subplot(211)
plot(runmean(GammaPower_Sptsd_REM_HPC,100),'.g')
ylim([0 1e4])
title('Gamma power 35-80 Hz, HPC')
hold on
plot(b , Data(MeanPower_GammaREM_HPC_tsd_PasicREM),'.r')
legend('All REM','Phasic REM')
ylabel('Power (A.U.)')

subplot(212)
plot(runmean(GammaPower_Sptsd_REM_Bulb,100),'.b')
ylim([0 4e4])
title('Gamma power 20-45 Hz, OB')
hold on
plot(b , Data(MeanPower_GammaREM_Bulb_tsd_PasicREM),'.r')
legend('All REM','Phasic REM')
makepretty
ylabel('Power (A.U.)')

a=suptitle('HPC & OB gamma power, REM Epochs concatenated'); a.FontSize=20;



figure
b=bar([(nanmean(Data(MeanPower_GammaREM_HPC_tsd_PasicREM))/nanmean(GammaPower_Sptsd_REM_HPC)-1)*100 (nanmean(Data(MeanPower_GammaREM_Bulb_tsd_PasicREM))/nanmean(GammaPower_Sptsd_REM_Bulb)-1)*100])
b.FaceColor = 'flat';
b.CData(1,:) = [0 1 0]; b.CData(2,:) = [0 0 1];
ylabel('% of increase relative to mean')
xticklabels({'HPC','Bulb'})
title('Gamma power during phasic REM')
makepretty
ylim([-10 70])


