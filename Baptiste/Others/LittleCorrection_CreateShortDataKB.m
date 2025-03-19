








th_immob=0.005;
thtps_immob=2;
smoofact=10;
smoofact_Acc = 30;
th_immob_Acc = 1.7e7;

try
load('behavResources_SB.mat','Behav')
end

NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);

Behav.MovAcctsd=MovAcctsd;
Behav.FreezeAccEpoch=FreezeAccEpoch;
save('behavResources_SB.mat','Behav')
















