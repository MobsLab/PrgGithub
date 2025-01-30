disp('refining boundaries')
%code Karim transitions
waking=Start(wakeper);
gosleep=Start(sleepper);

if waking(1)<gosleep(1)
    startstate=1;
else
    startstate=0;
end

startpt=Start(sleepper);
endpt=Stop(sleepper);

translimw=2*1e4;
translims=5*1e4;
wind=2*1e4;
num=0;
for p=1:length(startpt)-1
    go=0;
    last=Stop(subset(sleepper,p));
    a=find(Start(wakeper)>=last,1,'first');
    if abs(Start(subset(sleepper,p))-Stop(subset(sleepper,p)))>translims &  abs(Start(subset(wakeper,a))-Stop(subset(wakeper,a)))>translimw
        go=1;
    end
    if go==1
        try
            Ep=intervalSet(endpt(p)-wind*2,endpt(p)+wind*2);
            tps=Range(Restrict(smooth_ghi,Ep),'ms');
            test=Data(Restrict(smooth_ghi,Ep));
            [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
            if tps(ceil(size(tps,1)*perc2/100))*10 < startpt(p)
                Ep=intervalSet(endpt(p)-wind,endpt(p)+wind);
                tps=Range(Restrict(smooth_ghi,Ep),'ms');
                test=Data(Restrict(smooth_ghi,Ep));
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
                if tps(ceil(size(tps,1)*perc2/100))*10 > startpt(p)
                    endpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                                    num=num+1;
                end
            else
                endpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                num=num+1;
            end
            close all
        catch
            try
                Ep=intervalSet(endpt(p)-wind,endpt(p)+wind);
                tps=Range(Restrict(smooth_ghi,Ep),'ms');
                test=Data(Restrict(smooth_ghi,Ep));
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
                if tps(ceil(size(tps,1)*perc2/100))*10 > startpt(p)
                    endpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                                    num=num+1;
                end
            end
            close all
        end
        
    end
end



sleepper=intervalSet(startpt,endpt);
sleepper=mergeCloseIntervals(sleepper,1*1e4);
sleepper=dropShortIntervals(sleepper,1*1e4);
wakeper=TotalEpoch-sleepper;

waking=Start(wakeper);
gosleep=Start(sleepper);

if waking(1)<gosleep(1)
    startstate=1;
else
    startstate=0;
end
startpt=Start(sleepper);
endpt=Stop(sleepper);
num2=0;
for p=2:length(startpt)-1
    
      go=0;
    first=Start(subset(sleepper,p));
    a=find(Start(wakeper)<=first,1,'first');
    if abs(Start(subset(sleepper,p))-Stop(subset(sleepper,p)))>translims &  abs(Start(subset(wakeper,a))-Stop(subset(wakeper,a)))>translimw
        go=1;
    end
    if go==1
        try
            Ep=intervalSet(startpt(p)-wind*2,startpt(p)+wind*2);
            tps=Range(Restrict(smooth_ghi,Ep),'ms');
            test=Data(Restrict(smooth_ghi,Ep));
            [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
            if tps(ceil(size(tps,1)*perc2/100))*10 > endpt(p)
                Ep=intervalSet(endpt(p)-wind,endpt(p)+wind);
                tps=Range(Restrict(smooth_ghi,Ep),'ms');
                test=Data(Restrict(smooth_ghi,Ep));
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
                if tps(ceil(size(tps,1)*perc2/100))*10 < endpt(p)
                    startpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                    num2=num2+1;
                end
            else
                startpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                                    num2=num2+1;

            end
            close all
        catch
            try
                Ep=intervalSet(startpt(p)-wind,startpt(p)+wind);
                tps=Range(Restrict(smooth_ghi,Ep),'ms');
                test=Data(Restrict(smooth_ghi,Ep));
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p1,k,perc1,perc2]=fitsigmoid(tps,test,1);
                if tps(ceil(size(tps,1)*perc2/100))*10 < endpt(p)
                    startpt(p)=tps(ceil(size(tps,1)*perc2/100))*10;
                                        num2=num2+1;
                end
            end
            close all
        end
        
    end
end
sleepper=intervalSet(startpt,endpt);
sleepper=dropShortIntervals(sleepper,2*1e4);
sleepper=mergeCloseIntervals(sleepper,2*1e4);
wakeper=Epoch-sleepper;