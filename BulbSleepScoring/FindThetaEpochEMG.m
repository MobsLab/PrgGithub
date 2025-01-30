function FindThetaEpochEMG(Epoch,ThetaI,chH,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chH),'.mat'));
load('StateEpochEMGSB.mat','sleepper')

% find theta epochs

load('StateEpochSB.mat','smooth_Theta')
rat_theta=log(Data(Restrict((smooth_Theta),sleepper)));

theta_thresh=GetThetaThresh(rat_theta);
theta_thresh=exp(theta_thresh);
ThetaEpoch=thresholdIntervals(smooth_Theta,theta_thresh,'Direction','Above');
ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);


save(strcat(filename,'StateEpochEMGSB'),'ThetaEpoch','chH', 'smooth_Theta','ThetaI','theta_thresh','-v7.3','-append');


end