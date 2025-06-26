function [REMEpoch, N2, N1, Wake] = cleanSleepStates_BM(REMEpoch, N2, N1, Wake, TotEpoch)


%% Parameters
thr_bridge_REM = 60 * 1e4;
thr_short_REM = 20 * 1e4;
thr_bridge_N1 = 60 * 1e4;
thr_short_N1 = 20 * 1e4;
thr_short_N2 = 20 * 1e4;
thr_short_Wake = 10 * 1e4;

%% --- Step 1: Clean REM (merge first, drop after) ---
REMEpoch = mergeCloseIntervals(REMEpoch, thr_bridge_REM);  % merge REM bouts < 60s apart
N1 = N1-REMEpoch;
N2 = N2-REMEpoch;
REMEpoch = REMEpoch-Wake;

REMEpoch = dropShortIntervals(REMEpoch, thr_short_REM);  % drop REM shorter than 20s
Epoch_left = TotEpoch-or(or(Wake , REMEpoch) , or(N1 , N2));
N1 = or(N1 , Epoch_left);

N1 = mergeCloseIntervals(N1 , thr_bridge_N1);
N1 = N1-REMEpoch;
N1 = N1-Wake;
N2 = N2-N1;

N2 = dropShortIntervals(N2 , thr_short_N2);  % drop N2 shorter than 20s
Epoch_left = TotEpoch-or(or(Wake , REMEpoch) , or(N1 , N2));
N1 = or(N1 , Epoch_left);

[aft_cell,bef_cell]=transEpoch(N1,N2);
N1_aft_N2 =  bef_cell{1,2};
N1_aft_N2_long = dropShortIntervals(N1_aft_N2 , thr_short_N1);  % drop N1 after N2 shorter than 20s
N1_aft_N2_short = N1_aft_N2-N1_aft_N2_long;
N1_aft_N2_short = CleanUpEpoch(N1_aft_N2_short);

N1 = N1 - N1_aft_N2_short;
Epoch_left = TotEpoch-or(or(Wake , REMEpoch) , or(N1 , N2));
N2 = or(N2 , Epoch_left);
N2 = mergeCloseIntervals(N2 , .05e4); % putting junctions clean

N1 = CleanUpEpoch(N1);

% remove short wake
sleepStates = {'REMEpoch', 'N1', 'N2'};
allEpochs = cell(1, 4);
Wake = mergeCloseIntervals(Wake , .05e4);

Sleep = or(REMEpoch, or(N1, N2));
[aft_cell, bef_cell] = transEpoch(Sleep, Wake);

wakeBeforeSleep = aft_cell{2,1};   % Wake followed by sleep
wakeAfterSleep  = bef_cell{2,1};   % Wake preceded by sleep

wakeBetween = intersect(wakeBeforeSleep, wakeAfterSleep);
shortWake = subset(wakeBetween, DurationEpoch(wakeBetween) < thr_short_Wake);

Sleep = or(Sleep, shortWake);
Sleep = mergeCloseIntervals(Sleep, 0);   % Merge touching intervals
Wake  = Wake-shortWake;          % Remove merged Wake from Wake

REMEpoch = and(Sleep, REMEpoch);
N1       = and(Sleep, N1);
N2       = and(Sleep, N2);

Wake = CleanUpEpoch(Wake);


end

% clear all
% 
% pwd = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241206_TORCs/';
% smootime = 10;
% LineHeight = 9.5;
% Colors.N1 = 'c';
% Colors.N2 = [1 0 0];
% Colors.REM = 'g';
% Colors.Wake = 'b';
% Colors.Noise = 'k';
% 
% 
% load([pwd filesep 'SleepScoring_OBGamma.mat'], 'Wake','TotalNoiseEpoch','Epoch','Sleep', 'SmoothGamma')
% 
% load([pwd filesep 'ChannelsToAnalyse/dHPC_deep.mat'])
% load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
% LFP = Restrict(LFP , Sleep);
% smootime = 10;
% 
% Frequency{1}=[3 6];
% Frequency{2}=[.2 3];
% FilTheta = FilterLFP(LFP,Frequency{1},1024);
% FilDelta = FilterLFP(LFP,Frequency{2},1024);
% hilbert_theta = abs(hilbert(Data(FilTheta)));
% hilbert_delta = abs(hilbert(Data(FilDelta)));
% hilbert_delta(hilbert_delta<10) = 10;
% theta_ratio = hilbert_theta./hilbert_delta;
% ThetaEpoch2 = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');
% 
% load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
% load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
% FilDelta = FilterLFP(LFP,[.5 4],1024);
% hilbert_delta = abs(hilbert(Data(FilDelta)));
% SmoothDelta_OB = tsd(Range(LFP),runmean(hilbert_delta,ceil(smootime/median(diff(Range(LFP,'s'))))));
% 
% log_theta_NREM = log(Data(Restrict(SmoothDelta_OB , Sleep-ThetaEpoch2)));
% theta_thresh = exp(GetThetaThresh(log_theta_NREM, 1, 1));
% N1_OB = thresholdIntervals(SmoothDelta_OB, theta_thresh, 'Direction','Below');
% 
% TotEpoch = intervalSet(0 , max(Range(SmoothDelta_OB)));
% Wake = or(Wake,TotalNoiseEpoch);
% Wake = mergeCloseIntervals(Wake,10e4);
% Sleep = TotEpoch-Wake;
% 
% clear REMEpoch N1 N2
% REMEpoch = and(Sleep , ThetaEpoch2);
% SWSEpoch = Sleep-REMEpoch;
% N1 = and(N1_OB , SWSEpoch);
% ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);
% SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
% log_theta = log(Data(SmoothTheta));
% theta_thresh = exp(GetThetaThresh(log_theta, 1, 1));
% N2 = SWSEpoch-N1_OB;

