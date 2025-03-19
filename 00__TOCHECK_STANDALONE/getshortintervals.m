function Ep2=getshortintervals(Ep,lim)

dur=Stop(Ep)-Start(Ep);
ind=find(dur<lim);
Ep2=subset(Ep,ind);

end