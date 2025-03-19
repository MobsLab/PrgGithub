function Find_1_8_Epoch(Epoch,ThetaI,chH,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chH),'.mat'));

LFP = Restrict(LFP,Epoch); % added by BM on 01/09/2022

load('StateEpochSB.mat','sleepper')

% find theta epochs

disp(' ');
disp('... Creating 1-8 Epochs ');
Fil_1_8=FilterLFP(LFP,[1 8],1024);
Hil_1_8=hilbert(Data(Fil_1_8));
H=abs(Hil_1_8);
tot_1_8=Restrict(tsd(Range(LFP),H),Epoch);

% smooth 10-20 power
smooth_1_8=tsd(Range(tot_1_8),runmean(Data(tot_1_8),ceil(smootime/median(diff(Range(tot_1_8,'s'))))));

OneEight_thresh = GetThetaThresh(log(Data(Restrict(smooth_1_8,sleepper))));
OneEight_thresh = exp(OneEight_thresh);

OneEightEpoch=thresholdIntervals(smooth_1_8 , OneEight_thresh,'Direction','Above');
OneEightEpoch=mergeCloseIntervals(OneEightEpoch,ThetaI(1)*1E4);
OneEightEpoch=dropShortIntervals(OneEightEpoch,ThetaI(2)*1E4);


save(strcat(filename,'StateEpochSB'),'OneEightEpoch', 'smooth_1_8','OneEight_thresh','ThetaI','-v7.3','-append');

end