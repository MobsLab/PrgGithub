function FindGammaEpochGL(Epoch,chB,mindur,filename)
res=pwd;
smootime=3;
load([res,'/LFPData/LFP',num2str(chB)]);


% find gamma epochs
disp(' ');
disp('... Creating Gamma Epochs ');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
sm_ghi=Data(Restrict(smooth_ghi,Epoch));

gamma_thresh=GetGammaThresh(sm_ghi);
gamma_thresh=exp(gamma_thresh);
sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);

save(strcat(filename,'StateEpochSB'),'sleepper','gamma_thresh','mindur','chB','smooth_ghi','-v7.3','-append');




end
