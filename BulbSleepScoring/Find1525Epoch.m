function Find1525Epoch(Epoch,ThetaI,chB,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chB),'.mat'));
if exist('StateEpochSB.mat')>0
load('StateEpochSB.mat','sleepper')
else
   load('SleepScoring_OBGamma.mat','Sleep')
   sleepper = Sleep;
end

% find theta epochs

disp(' ');
disp('... Creating OB RemEpochs Epochs ');
Fil1525=FilterLFP(LFP,[15 25],1024);


Hil1525=hilbert(Data(Fil1525));
TenFifRatioTSD=tsd(Range(Fil1525),abs(Hil1525));
smooth_1525=tsd(Range(TenFifRatioTSD),runmean(Data(TenFifRatioTSD),ceil(smootime/median(diff(Range(TenFifRatioTSD,'s'))))));

rat_1525=log(Data(Restrict((smooth_1525),sleepper)));

TenFif_thresh=Get1015Thresh(rat_1525);

TenFif_thresh=exp(TenFif_thresh);
TenFifEpoch=thresholdIntervals(smooth_1525,TenFif_thresh,'Direction','Below');
TenFifEpoch=mergeCloseIntervals(TenFifEpoch,ThetaI(1)*1E4);
TenFifEpoch=dropShortIntervals(TenFifEpoch,ThetaI(2)*1E4);

save(strcat(filename,'StateEpochSBAllOB_Bis'),'TenFifEpoch','chB', 'smooth_1525','TenFifRatioTSD','sleepper','ThetaI','TenFif_thresh','-v7.3','-append');

end