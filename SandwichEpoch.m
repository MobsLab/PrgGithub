function NewEpoch=SandwichEpoch(Epoch1,Epoch2,minin,minout)
%  NewEpoch=SandwichEpoch(Epoch1,Epoch2,maxin,minout)
% NewEpoch contains the elements of Epoch1 shorter than minin that are
% sandwiched between elements of EPoch2 longer than minout

% get rid of too long elements
lengthind=(Stop(Epoch1)-Start(Epoch1))<minin;
ShortEpoch=subset(Epoch1,lengthind);
lengthind=(Stop(Epoch2)-Start(Epoch2))>minout;
LongEpoch=subset(Epoch2,lengthind);

StpL=Stop(LongEpoch);
StrL=Start(LongEpoch);
StpS=Stop(ShortEpoch);
StrS=Start(ShortEpoch);
EpToKeep=[];
for j=1:length(StrS)
    if ~isempty(find(StpL==StrS(j))) & ~isempty(find(StrL==StpS(j)))
        EpToKeep=[EpToKeep,j];
    end
end
NewEpoch=subset(ShortEpoch,EpToKeep);
end






