
%% Sleep

load('LFPData/LFP32.mat')
LFPX = LFP;
load('LFPData/LFP33.mat')
LFPY = LFP;
load('LFPData/LFP34.mat')
LFPZ = LFP;

load('StateEpochSB.mat', 'Wake','REMEpoch', 'SWSEpoch')
load('B_Low_Spectrum.mat')
OB_Sp_tsd = tsd(Spectro{2}*1e4, Spectro{1});

Breathing_From_Accelerometer(LFP_X , LFP_Y , LFP_Z , OB_Sp_tsd , [.1 2],  'result_epoch' , Wake , SWSEpoch , REMEpoch);



%% Freezing

GetEmbReactMiceFolderList_BM

clearvars -except CondSess
Mouse_names={'M1391'}; mouse=1;

LFP_X = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'lfp', 'channumber' , 32);
LFP_Y = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'lfp', 'channumber' , 33);
LFP_Z = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'lfp', 'channumber' , 34);
FreezeEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch', 'epochname' , 'freezeepoch');
ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch', 'epochname' , 'zoneepoch');
ShockEpoch = ZoneEpoch{1};
SafeEpoch = or(ZoneEpoch{2} , ZoneEpoch{5});
Freeze_Shock = and(FreezeEpoch , ShockEpoch);
Freeze_Safe = and(FreezeEpoch , SafeEpoch);
OB_Sp_tsd = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'spectrum', 'prefix' , 'B_Low');

Breathing_From_Accelerometer(LFP_X , LFP_Y , LFP_Z , OB_Sp_tsd  , [1 8] , 'result_epoch', Freeze_Safe , Freeze_Shock);




[Ctemp_shock,phi_shock,S12,S1temp_shock,S2temp_shock,t,f,confC,phitemp,Cerr] = cohgramc( Data(Restrict(LFP_Bulb_deep,ResultEpoch{2})) , Data(Restrict(LFP_mixed_tsd,ResultEpoch{2})) , movingwin , params);
[Ctemp_safe,phi_safe,S12,S1temp_safe,S2temp_safe,t,f,confC,phitemp,Cerr] = cohgramc( Data(Restrict(LFP_Bulb_deep,ResultEpoch{1})) , Data(Restrict(LFP_mixed_tsd,ResultEpoch{1})) , movingwin , params);

phi_shock = -resample(phi_shock , 4 , 1);
phi_shock = resample(phi_shock' , 4 , 1);
phi_shock = zscore(phi_shock)';
phi_safe = -resample(phi_safe , 4 , 1);
phi_safe = resample(phi_safe' , 4 , 1);
phi_safe = zscore(phi_safe)';

imagesc(linspace(0, sum(DurationEpoch(ResultEpoch{2}))/60e4 , length(Acc_Sp_tsd_ResultEpoch{2})) , linspace(0,20,size(phi_shock,2)) , runmean(runmean(phi_shock,25)',25)), axis xy
ylim([0 10])
ylabel('Frequency (Hz)')
title('Shock freezing')
makepretty
subplot(212)
imagesc(linspace(0, sum(DurationEpoch(ResultEpoch{1}))/60e4 , length(Acc_Sp_tsd_ResultEpoch{1})) , linspace(0,20,size(phi_safe,2)) , runmean(runmean(phi_safe,25)',25)), axis xy
ylim([0 10])
ylabel('Frequency (Hz)')
xlabel('time (min)')
title('Safe freezing')
makepretty
a=suptitle('Coherogram breathing from accelero and OB LFP, freezing'); a.FontSize=20;



SgnFiltre0=FilterLFP(PhaseBulb_tsd,[1 8],1024);

PhaseBulb_tsd = tsd(Range(LFP_Bulb_deep) , angle(hilbert(Data(SgnFiltre0)))*180/pi+180);
PhaseAcc_tsd = tsd(Range(LFP_Bulb_deep) , angle(hilbert(Data(LFP_mixed_tsd)))*180/pi+180);

[Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr] = cohgramc(Data(LFP_Bulb_deep) , Data(LFP_mixed_tsd) , movingwin , params);
LFP_Bulb_deep = Restrict(LFP_Bulb_deep , EpochWithoutNoise);
LFP_mixed_tsd = Restrict(LFP_mixed_tsd , EpochWithoutNoise);


figure
plot(runmean(nanmean(Ctemp(:,1:33)'),30))
a=colorbar; a.Ticks=[.4 .9]; a.TickLabels={'0','1'}; a.Label.String='Power (a.u.)';
a=colorbar; a.Ticks=caxis; a.TickLabels={'-π','π'}; a.Label.String='Phase (rad)';

Ctemp_tsd = tsd(tH*1e4 , runmean(nanmean(Ctemp(:,1:33)'),30)');
Ctemp_Fz = Restrict(Ctemp_tsd , or(ResultEpoch{1} , ResultEpoch{2}));

plot(Range(Ctemp_tsd,'s') , Data(Ctemp_tsd))
hold on
plot(Range(Ctemp_Fz,'s') , Data(Ctemp_Fz))

phi_tsd = tsd(tH*1e4 , runmean(nanmean(phi(:,1:33)'),30)');
phi_Fz = Restrict(phi_tsd , or(ResultEpoch{1} , ResultEpoch{2}));

figure
plot(Range(phi_tsd,'s') , Data(phi_tsd))
hold on
plot(Range(phi_Fz,'s') , Data(phi_Fz))





