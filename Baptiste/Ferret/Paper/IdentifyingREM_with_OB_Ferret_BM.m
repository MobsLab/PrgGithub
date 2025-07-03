
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs')
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/')
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/')
load('SleepScoring_OBGamma.mat', 'Sleep')

%% identifying REM with OB wire
load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , Sleep);
smootime = 10;

% OB
Frequency{1}=[4 7];
Frequency{2}=[.2 3];
FilTheta = FilterLFP(LFP,Frequency{1},1024);
FilDelta = FilterLFP(LFP,Frequency{2},1024);
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_delta(hilbert_delta<10) = 10;
theta_ratio = hilbert_theta./hilbert_delta;
ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
log_theta = log(Data(SmoothTheta));
theta_thresh = exp(GetThetaThresh(log_theta, 1, 1));
ThetaEpoch_OB = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');


% HPC
load([pwd filesep 'ChannelsToAnalyse/dHPC_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , Sleep);
smootime = 10;

Frequency{1}=[3 6];
Frequency{2}=[.2 3];
FilTheta = FilterLFP(LFP,Frequency{1},1024);
FilDelta = FilterLFP(LFP,Frequency{2},1024);
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_delta(hilbert_delta<10) = 10;
theta_ratio = hilbert_theta./hilbert_delta;
ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
log_theta = log(Data(SmoothTheta));
theta_thresh = exp(GetThetaThresh(log_theta, 1, 1));
ThetaEpoch_HPC = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');


% overlap
Recall(i) = sum(DurationEpoch(and(ThetaEpoch_OB , ThetaEpoch_HPC)))./sum(DurationEpoch(ThetaEpoch_HPC));
Precision(i) = sum(DurationEpoch(and(ThetaEpoch_OB , ThetaEpoch_HPC)))./sum(DurationEpoch(ThetaEpoch_OB));

figure
subplot(121)
b = bar(Recall);
xticklabels({'F1','F2','F3'}), ylabel('Recall'), box off

subplot(122)
b = bar(Precision);
xticklabels({'F1','F2','F3'}), ylabel('Precision'), box off



%%
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs')
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/')
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/')
load('SleepScoring_OBGamma.mat', 'Sleep')


smootime = 30;
load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , Sleep);
FilGamma = FilterLFP(LFP,[40 90],1024);
hilbert_gamma = abs(hilbert(Data(FilGamma)));
SmoothGamma = tsd(Range(LFP),runmean(hilbert_gamma,ceil(smootime/median(diff(Range(LFP,'s'))))));
theta_thresh = exp(GetThetaThresh(log(Data(SmoothGamma)), 1, 1));
GammaEpoch_OB = thresholdIntervals(SmoothGamma, theta_thresh, 'Direction','Above');


try
    load([pwd filesep 'ChannelsToAnalyse/dHPC_deep.mat'])
catch
   load([pwd filesep 'ChannelsToAnalyse/ThetaREM.mat']) 
end
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , Sleep);
smootime = 30;
Frequency{1}=[3 6];
Frequency{2}=[.2 3];
FilTheta = FilterLFP(LFP,Frequency{1},1024);
FilDelta = FilterLFP(LFP,Frequency{2},1024);
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_delta(hilbert_delta<10) = 10;
theta_ratio = hilbert_theta./hilbert_delta;
ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
log_theta = log(Data(SmoothTheta));
theta_thresh = exp(GetThetaThresh(log_theta, 1, 1));
ThetaEpoch_HPC = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');


Recall(i) = sum(DurationEpoch(and(GammaEpoch_OB , ThetaEpoch_HPC)))./sum(DurationEpoch(ThetaEpoch_HPC));
Precision(i) = sum(DurationEpoch(and(GammaEpoch_OB , ThetaEpoch_HPC)))./sum(DurationEpoch(GammaEpoch_OB));


figure
subplot(121)
b = bar(Recall);
xticklabels({'F1','F2','F3'}), ylabel('Recall'), box off

subplot(122)
b = bar(Precision);
xticklabels({'F1','F2','F3'}), ylabel('Precision'), box off




