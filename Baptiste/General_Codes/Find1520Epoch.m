function Find1520Epoch(Epoch,ThetaI,chB,filename)

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
Fil1520=FilterLFP(LFP,[15 20],1024);


Hil1520=hilbert(Data(Fil1520));
TenFifRatioTSD=tsd(Range(Fil1520),abs(Hil1520));
smooth_1520=tsd(Range(TenFifRatioTSD),runmean(Data(TenFifRatioTSD),ceil(smootime/median(diff(Range(TenFifRatioTSD,'s'))))));

rat_1520=log(Data(Restrict((smooth_1520),sleepper)));

TenFif_thresh=Get1015Thresh(rat_1520);

TenFif_thresh=exp(TenFif_thresh);
TenFifEpoch=thresholdIntervals(smooth_1520,TenFif_thresh,'Direction','Below');
TenFifEpoch=mergeCloseIntervals(TenFifEpoch,ThetaI(1)*1E4);
TenFifEpoch=dropShortIntervals(TenFifEpoch,ThetaI(2)*1E4);

save(strcat(filename,'StateEpochSBAllOB'),'TenFifEpoch','chB', 'smooth_1520','TenFifRatioTSD','sleepper','ThetaI','TenFif_thresh','-v7.3','-append');

end