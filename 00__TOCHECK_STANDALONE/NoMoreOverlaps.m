
function NewEpoch=NoMoreOverlaps(sleepper,Ne)

% For intervalSet files

beg=Start(Epoch);
fin=Stop(Epoch);
i=1;
while i<length(beg)-1
    if (fin(i)-beg(i+1))>0
        fin(i)=[];
        beg(i)=[];
    else
    i=i+1;    
    end
end

NewEpoch=intervalSet(beg,fin);
end