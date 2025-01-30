function tpsout=GetZeroEpoch(Epoch,Signal)

for ep=1:length(Start(Epoch))
    keyboard
   Dat=Data(Restrict(Signal,subset(Epoch,ep)));
   Tps=Range(Restrict(Signal,subset(Epoch,ep)));
   [up,down,idxUp,idxDown] = ZeroCrossings([Tps,Dat]);
   tpsout(ep)=min(up);
    
end

end


