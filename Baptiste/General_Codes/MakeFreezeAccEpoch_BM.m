

function FreezeAccEpoch=MakeFreezeAccEpoch_BM(MovAcctsd,Params)

NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),Params.smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,Params.th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,Params.thtps_immob*1e4);






