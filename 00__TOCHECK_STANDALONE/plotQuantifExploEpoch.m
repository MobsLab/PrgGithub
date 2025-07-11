function plotQuantifExploEpoch(X,Y,A,n,numgcf)


inver=0;

if inver
    Y=tsd(Range(Y),500-Data(Y));
end

try
    figure(numgcf), clf
catch
    figure('color',[1 1 1]),
end
clf
subplot(1,3,1), hold on
plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
xiB=Data(Restrict(X,intervalSet((A(n,1)-30)*1E4,(A(n,1)*1E4))));
yiB=Data(Restrict(Y,intervalSet((A(n,1)-30)*1E4,(A(n,1)*1E4))));
xiA=Data(Restrict(X,intervalSet((A(n,2))*1E4,(A(n,2)+30)*1E4)));
yiA=Data(Restrict(Y,intervalSet((A(n,2))*1E4,(A(n,2)+30)*1E4)));
xi=Data(Restrict(X,intervalSet(A(n,1)*1E4,A(n,2)*1E4)));
yi=Data(Restrict(Y,intervalSet(A(n,1)*1E4,A(n,2)*1E4)));
plot(xiB,yiB,'g','linewidth',2)
plot(xiA,yiA,'r','linewidth',2)
plot(xi,yi,'k','linewidth',2)
plot(xi(1),yi(1),'go','markerfacecolor','g')
plot(xi(end),yi(end),'ro','markerfacecolor','r')
title(num2str(n))
subplot(1,3,2), hold on 
plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
plot(xi,yi,'k','linewidth',2)
plot(xi(1),yi(1),'go','markerfacecolor','g')
plot(xi(end),yi(end),'ro','markerfacecolor','r')
xl=xlim;
yl=ylim;
try
title(num2str(A(n,1)-A(n-1,2)))
end
subplot(1,3,3), hold on 
plot(xi,yi,'color',[0.7 0.7 0.7])
rg=Range(Restrict(X,intervalSet(A(n,1)*1E4,A(n,2)*1E4)),'s');
scatter(xi,yi,30,rg-rg(1)), title(num2str(rg(end)-rg(1))), colorbar
xlim(xl)
ylim(yl)