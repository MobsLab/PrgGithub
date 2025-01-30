function TrialSet=OrganizeDataOBHPCPFCxFit(AllLFP,FreezeEpoch,TrialDur)

% First get correct epochs :
% - if epoch is less than TrialDur it is dropped
% - if epoch is at least n TrialDur long then it is cut into n
% epochs
FreezeEpoch=dropShortIntervals(FreezeEpoch,TrialDur);
BegFz=Start(FreezeEpoch);
EndFz=Stop(FreezeEpoch);
AllStart=[];
AllEnd=[];
for st=1:length(BegFz)
    Dur=EndFz(st)-BegFz(st);
    NumEpoch=floor(Dur/TrialDur);
    NewBeg=BegFz(st)+floor(mod(Dur,TrialDur)/2);
    for n=1:NumEpoch
        AllStart=[AllStart,NewBeg+(n-1)*TrialDur];
        AllEnd=[AllEnd,NewBeg+(n)*TrialDur];
    end
end
TrialEpoch=intervalSet(AllStart,AllEnd);

for st=1:length(Start(TrialEpoch))
    TrialSet.HPC(st,:)=Data(Restrict(AllLFP.HPC,subset(TrialEpoch,st)));
    TrialSet.OB(st,:)=Data(Restrict(AllLFP.OB,subset(TrialEpoch,st)));
    TrialSet.PFCx(st,:)=Data(Restrict(AllLFP.PFCx,subset(TrialEpoch,st)));
end

end