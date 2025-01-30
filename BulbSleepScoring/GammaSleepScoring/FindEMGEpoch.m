function FindEMGEpoch(Epoch,chE,mindur,filename)

smootime=3;
load(strcat('LFPData/LFP',num2str(chE),'.mat'));


% find gamma epochs
disp(' ');
disp('... Creating EMG Epochs ');
FilLFP=FilterLFP(LFP,[50 300],1024);
FilLFP=Restrict(FilLFP,Epoch);
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
EMGData=Restrict(EMGData,Epoch);
EMGVals=Data(EMGData);


EMG_thresh=GetGammaThresh(EMGVals);
EMG_thresh=exp(EMG_thresh);
sleepper=thresholdIntervals(EMGData,EMG_thresh,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);

save(strcat(filename,'StateEpochEMGSB'),'sleepper','EMG_thresh','mindur','chE','EMGData','-v7.3','-append');




end

