clear all
chB  = 25;
smootime=3;

figure
cd('/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,5_Baseline/M689_05_Baseline_180228_165956')
load('B_High_Spectrum.mat')
gamma(1) = nanmean(nanmean(log(Spectro{1}(:,14:16))));
AllGammaVals{1} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{1} =Data(smooth_ghi);

cd('/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_0,8_Baseline/M689_Isoflurane_Baseline_08_180228_155706')
load('B_High_Spectrum.mat')
gamma(2) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{2} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{2} =Data(smooth_ghi);

cd('/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,0_Baseline/M689_Isoflurane_10_Baseline_180228_140658_180228_142049')
load('B_High_Spectrum.mat')
gamma(3) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{3} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{3} =Data(smooth_ghi);

cd('/media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_1,5_Baseline/M689_Isoflurane_15_Baseline_180228_174521')
load('B_High_Spectrum.mat')
gamma(4) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{4} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{4} =Data(smooth_ghi);

cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M689/Isoflurane_WakeUP
load('B_High_Spectrum.mat')
gamma(5) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{5} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{5} =Data(smooth_ghi);

cd /media/DataMOBS78/ProcessedData_EMbRerct_FLX/Mouse689/20180213/ProjectEmbReact_M689_20180213_SleepPre_PreDrug
load('B_High_Spectrum.mat')
gamma(6) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{6} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{6} =Data(smooth_ghi);

cd /media/DataMOBS78/ProcessedData_EMbRerct_FLX/Mouse689/20180213/ProjectEmbReact_M689_20180213_SleepPost_PreDrug
load('B_High_Spectrum.mat')
gamma(7) = nanmean(nanmean(Spectro{1}(:,14:16)));
AllGammaVals{7} = nanmean(log(Spectro{1}(:,14:16)'));
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=(tsd(Range(LFP),H));
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
AllGammaVals_smooth{7} =Data(smooth_ghi);
