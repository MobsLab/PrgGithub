function [ThetaRatioTSD , SmoothTheta]=FindThetaEpoch_BM(LFP)

smootime=1;
% load(strcat('LFPData/LFP',num2str(chH),'.mat'));
% load('StateEpochSB.mat','sleepper')

% find theta epochs

disp(' ');
disp('... Creating Theta Epochs ');

FilTheta = FilterLFP(LFP,[5 10],1024);
FilDelta = FilterLFP(LFP,[2 5],1024);
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_delta(hilbert_delta<100) = 100;
theta_ratio = hilbert_theta ./ hilbert_delta;
ThetaRatioTSD = tsd(Range(FilTheta), theta_ratio);

% smooth Theta / delta ratio
SmoothTheta = tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));


rat_theta=log(Data(SmoothTheta));
 
 %theta_thresh=GetThetaThresh(rat_theta);
% theta_thresh=exp(theta_thresh);
% ThetaEpoch=thresholdIntervals(smooth_Theta,theta_thresh,'Direction','Above');
% ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
% ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);


%save(strcat(filename,'StateEpochSB'),'ThetaEpoch','chH', 'smooth_Theta','ThetaRatioTSD','ThetaI','theta_thresh','-v7.3','-append');


end