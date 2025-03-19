function Find2030Epoch(Epoch,ThetaI,chB,filename)

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
Fil1015=FilterLFP(LFP,[20 30],1024);


Hil1015=hilbert(Data(Fil1015));
TenFifRatioTSD=tsd(Range(Fil1015),abs(Hil1015));
smooth_1015=tsd(Range(TenFifRatioTSD),runmean(Data(TenFifRatioTSD),ceil(smootime/median(diff(Range(TenFifRatioTSD,'s'))))));

rat_1015=log(Data(Restrict((smooth_1015),sleepper)));

TenFif_thresh=Get1015Thresh(rat_1015);

TenFif_thresh=exp(TenFif_thresh);
TenFifEpoch=thresholdIntervals(smooth_1015,TenFif_thresh,'Direction','Below');
TenFifEpoch=mergeCloseIntervals(TenFifEpoch,ThetaI(1)*1E4);
TenFifEpoch=dropShortIntervals(TenFifEpoch,ThetaI(2)*1E4);
TenFifEpoch=dropShortIntervals(TenFifEpoch,ThetaI(2)*1E4);

smooth_2030=smooth_1015;

save(strcat(filename,'StateEpochSBAllOB_Ter'),'TenFifEpoch','chB', 'smooth_2030','TenFifRatioTSD','sleepper','ThetaI','TenFif_thresh','-v7.3','-append');

end