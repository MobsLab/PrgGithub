function NewEp=CutUpEpochs(Epoch,minSz,maxSz)

%If a subset of the Epoch is more than maxSz in length it will be cut up
% into epochs longer than minSz, therefore minSz must be less than half the
% length of maxSz

if minSz>maxSz/2
    minSz=maxSz/2;
end
NewEp=intervalSet(0,0);
DurEp=Stop(Epoch,'s')-Start(Epoch,'s'); % duration fo all subset of epoch

for ep=1:length(Start(Epoch))
    LitEpo=subset(Epoch,ep);
    
    if DurEp(ep)>=maxSz
        numNewEp=floor(DurEp(ep)/minSz);
        durNewEp=DurEp(ep)/numNewEp-0.01;
        for nn=1:numNewEp
            NewEp=or(NewEp,intervalSet(Start(LitEpo)+durNewEp*1e4*(nn-1)+0.01*1e4,Start(LitEpo)+durNewEp*1e4*nn));
        end
        
    else
        NewEp=or(NewEp,LitEpo);
    end
    
end
StNewEp=Start(NewEp);
StpNewEp=Stop(NewEp);
NewEp=intervalSet(StNewEp(2:end),StpNewEp(2:end));

end