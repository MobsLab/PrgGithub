

smootime = 10;
LineHeight = 9.5;
Colors.N1 = [1 .5 0];
Colors.N2 = [1 0 0];
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = 'k';


load([pwd filesep 'SleepScoring_OBGamma.mat'], 'Wake','TotalNoiseEpoch','Epoch','Sleep', 'SmoothGamma')

try
    load([pwd filesep 'ChannelsToAnalyse/dHPC_deep.mat'])
catch
    load([pwd filesep 'ChannelsToAnalyse/ThetaREM.mat'])    
end
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , Sleep);

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
ThetaEpoch2 = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');

load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
FilDelta = FilterLFP(LFP,[.5 4],1024);
hilbert_delta = abs(hilbert(Data(FilDelta)));
SmoothDelta_OB = tsd(Range(LFP),runmean(hilbert_delta,ceil(smootime/median(diff(Range(LFP,'s'))))));

log_theta_NREM = log(Data(Restrict(SmoothDelta_OB , Sleep-ThetaEpoch2)));
theta_thresh = exp(GetThetaThresh(log_theta_NREM, 1, 1));
N1 = thresholdIntervals(SmoothDelta_OB, theta_thresh, 'Direction','Below');

TotEpoch = intervalSet(0 , max(Range(SmoothDelta_OB)));
Wake = or(Wake,TotalNoiseEpoch);
Wake = mergeCloseIntervals(Wake,10e4);
Sleep = TotEpoch-Wake;

REMEpoch = and(Sleep , ThetaEpoch2);
SWSEpoch = Sleep-REMEpoch;
N1 = and(N1 , SWSEpoch);
N2 = SWSEpoch-N1;



%% breathing
TotDur = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))./3.6e7;

% Breathing Piezzo, frequency and variability
P = load('Piezzo_ULow_Spectrum.mat');
Sptsd = tsd(P.Spectro{2}*1e4 , P.Spectro{1});
[Sptsd_clean,~,EpochClean] = CleanSpectro(Sptsd , P.Spectro{3} , 8);

Piezzo_Wake  = Restrict(Sptsd_clean , Wake);
Piezzo_NREM  = Restrict(Sptsd_clean , SWSEpoch);
Piezzo_REM  = Restrict(Sptsd_clean , REMEpoch);

Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(P.Spectro{3} , Range(Sptsd_clean) , Data(Sptsd_clean) , 'frequency_band' , [.25 1]);
% Breathing_var = tsd(Range(Spectrum_Frequency) , movstd(Data(Spectrum_Frequency) , ceil(30/median(diff(Range(Spectrum_Frequency,'s')))),'omitnan'));

Breathing_Wake  = Restrict(Spectrum_Frequency , Wake);
Breathing_N1  = Restrict(Spectrum_Frequency , N1);
Breathing_N2  = Restrict(Spectrum_Frequency , N2);
Breathing_REM  = Restrict(Spectrum_Frequency , REMEpoch);


load('HeartBeatInfo.mat', 'EKG')
HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                
HR_Wake  = Restrict(EKG.HBRate , Wake);
HR_N1  = Restrict(EKG.HBRate , N1);
HR_N2  = Restrict(EKG.HBRate , N2);
HR_REM  = Restrict(EKG.HBRate , REMEpoch);

HRVar_Wake  = Restrict(HRVar , Wake);
HRVar_N1  = Restrict(HRVar , N1);
HRVar_N2  = Restrict(HRVar , N2);
HRVar_REM  = Restrict(HRVar , REMEpoch);

%%
Cols={[0 0 1],[1 .5 0],[1 0 0],[0 1 0]};
X = 1:4;
Legends = {'Wake','IS','NREM','REM'};
NoLegends = {'','','',''};


figure
D{1} = Data(Breathing_Wake)*60;
D{2} = Data(Breathing_N1)*60;
D{3} = Data(Breathing_N2)*60;
D{4} = Data(Breathing_REM)*60;
MakeSpreadAndBoxPlot3_SB(D,Cols,X,Legends,'showpoints',0,'paired',0)
ylabel('Breathing / min')
makepretty_BM2

figure
D{1} = Data(HR_Wake)*60;
D{2} = Data(HR_N1)*60;
D{3} = Data(HR_N2)*60;
D{4} = Data(HR_REM)*60;
MakeSpreadAndBoxPlot3_SB(D,Cols,X,Legends,'showpoints',0,'paired',0)
ylabel('Heart beat / min')
makepretty_BM2

figure
D{1} = Data(HRVar_Wake);
D{2} = Data(HRVar_N1);
D{3} = Data(HRVar_N2);
D{4} = Data(HRVar_REM);
MakeSpreadAndBoxPlot3_SB(D,Cols,X,Legends,'showpoints',0,'paired',0)
ylabel('Heart rate variability')
makepretty_BM2
