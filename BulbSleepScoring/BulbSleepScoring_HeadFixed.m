%% Head restrained
smootime=3;

cd /media/nas6/HeadRestraint/1227/20211110
load('/media/nas6/HeadRestraint/1227/20211110/LFPData/LFP24.mat')

FilLFP=FilterLFP(LFP,[50 300],1024);
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
EMGVals=Data(EMGData);


load('/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPre_PreDrug/LFPData/LFP24.mat')
FilLFP = FilterLFP(LFP,[50 300],1024);
EMGData_Sl = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
EMGVals_Sl = Data(EMGData_Sl);

%%
load('/media/nas6/HeadRestraint/1227/20211110/LFPData/LFP31.mat')
FilGamma = FilterLFP(LFP,[50 70],1024); % filtering
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); %tsd: hilbert transform then enveloppe

% smooth gamma power
SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));


FilGamma = FilterLFP(LFP,[50 70],1024); % filtering
tEnveloppeGamma = tsd(Range(LFP), abs(hilbert(Data(FilGamma))) ); %tsd: hilbert transform then enveloppe

% smooth gamma power
SmoothGamma_Sl = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
    ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));



%%
clear all
cd /media/nas6/HeadRestraint/1227/20211110

load(['LFPData/LFP' num2str(24) '.mat'])
tpsmax = max(Range(LFP)); % use LFP to get precise end time
TotEpoch = intervalSet(0,tpsmax);

load('HeartBeatInfo.mat')
Before_HeartBeat = ts(Range(EKG.HBTimes)-100);
After_HeartBeat = ts(Range(EKG.HBTimes)+100);

HeartBeat_Epoch=intervalSet(Before_HeartBeat,After_HeartBeat);
EMG_Epoch = TotEpoch-HeartBeat_Epoch;

EMG_TSDHF = Restrict(LFP, EMG_Epoch);
FilLFPHF=FilterLFP(EMG_TSDHF , [50 300] , 1024);
EMG_TSDHF=tsd(Range(FilLFPHF),runmean(Data((FilLFPHF)).^2,ceil(.5/median(diff(Range(FilLFPHF,'s'))))));

cd('/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPre_PreDrug')
load(['LFPData/LFP' num2str(24) '.mat'])
tpsmax = max(Range(LFP)); % use LFP to get precise end time
TotEpoch = intervalSet(0,tpsmax);

load('HeartBeatInfo.mat')
Before_HeartBeat = ts(Range(EKG.HBTimes)-100);
After_HeartBeat = ts(Range(EKG.HBTimes)+100);

HeartBeat_Epoch=intervalSet(Before_HeartBeat,After_HeartBeat);
EMG_Epoch = TotEpoch-HeartBeat_Epoch;

EMG_TSDSl = Restrict(LFP, EMG_Epoch);
FilLFPSl=FilterLFP(EMG_TSDSl , [50 300] , 1024);
EMG_TSDSl=tsd(Range(FilLFPSl),runmean(Data((FilLFPSl)).^2,ceil(.5/median(diff(Range(FilLFPSl,'s'))))));


%%
cd('/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPre_PreDrug/')
load('StateEpochSB.mat')
SleepScoreFigure([cd filesep],TotalEpoch)

cd /media/nas6/HeadRestraint/1227/20211110

