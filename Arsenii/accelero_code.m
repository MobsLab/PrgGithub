% Accelerometer
smootime = 3;
smooth_Acc = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
[accelero_thresh , mu1 , mu2 , std1 , std2 , AshD_accelero] = GetGammaThresh(Data(smooth_Acc), 1, 1)