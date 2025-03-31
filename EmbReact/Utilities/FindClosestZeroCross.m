function tpsout=FindClosestZeroCross(tpsin,Signal,UpAndDown)

Dat=Data(Signal);
Tps=Range(Signal);
[up,down] = ZeroCrossings([Tps,Dat]);

if UpAndDown==0
    AllCross=sort([up;down]);
elseif UpAndDown==1
    AllCross=Tps(up==1);
else
    AllCross=sort([down]);
        AllCross=Tps(down==1);

end

for ep=1:length(tpsin)
    Dist=(AllCross-tpsin(ep));
    Dist(Dist<0)=Inf;
    [val,ind]=min(Dist);
    tpsout(ep)=AllCross(ind);
    
end

end


