function TrialSet=OrganizeDataForKernelFitting(LFP,Epoch,TrialDur)

% First get correct epochs :
% - if epoch is less than TrialDur it is dropped
% - if epoch is at least n TrialDur long then it is cut into n
% epochs
Epoch=dropShortIntervals(Epoch,TrialDur);
BegEp=Start(Epoch);
EndEp=Stop(Epoch);

AllStart=[];
AllEnd=[];
for st=1:length(BegEp)
    Dur=EndEp(st)-BegEp(st);
    NumEpoch=floor(Dur/TrialDur);
    NewBeg=BegEp(st)+floor(mod(Dur,TrialDur)/2);
    for n=1:NumEpoch
        AllStart=[AllStart,NewBeg+(n-1)*TrialDur];
        AllEnd=[AllEnd,NewBeg+(n)*TrialDur];
    end
end
TrialEpoch=intervalSet(AllStart,AllEnd);

for st=1:length(Start(TrialEpoch))
    TrialSet(st,:)=Data(Restrict(LFP,subset(TrialEpoch,st)));
end

end