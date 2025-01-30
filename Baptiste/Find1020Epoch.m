function Find1020Epoch(Epoch,ThetaI,chH,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chH),'.mat'));

LFP = Restrict(LFP,Epoch); % added by BM on 01/09/2022

load('StateEpochSB.mat','sleepper')

% find theta epochs

disp(' ');
disp('... Creating Theta Epochs ');
Fil1020=FilterLFP(LFP,[10 20],1024);
Hil1020=hilbert(Data(Fil1020));
H=abs(Hil1020);
tot_1020=Restrict(tsd(Range(LFP),H),Epoch);

% smooth 10-20 power
smooth_1020=tsd(Range(tot_1020),runmean(Data(tot_1020),ceil(smootime/median(diff(Range(tot_1020,'s'))))));

TenTwenty_thresh = GetThetaThresh(log(Data(smooth_1020)));
TenTwenty_thresh = exp(TenTwenty_thresh);

TenTwentyEpoch=thresholdIntervals(smooth_1020 , TenTwenty_thresh,'Direction','Below');
TenTwentyEpoch=mergeCloseIntervals(TenTwentyEpoch,ThetaI(1)*1E4);
TenTwentyEpoch=dropShortIntervals(TenTwentyEpoch,ThetaI(2)*1E4);

try
    save(strcat(filename,'StateEpochSBAllOB'),'TenTwentyEpoch', 'smooth_1020','TenTwenty_thresh','ThetaI','-v7.3','-append');
catch
    save(strcat(filename,'StateEpochSB'),'TenTwentyEpoch', 'smooth_1020','TenTwenty_thresh','ThetaI','-v7.3','-append');
end
end