function tpsout=GetMaxEpoch(Epoch,Signal)

for ep=1:length(Start(Epoch))
    
   Dat=Data(Restrict(Signal,subset(Epoch,ep)));
   Tps=Range(Restrict(Signal,subset(Epoch,ep)));
   [val,ind]=max(Dat);
   tpsout(ep)=Tps(min(ind));
    
end

end


