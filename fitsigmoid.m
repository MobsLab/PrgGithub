function [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p,k,perc1,perc2]=fitsigmoid(tps,val,fig)

try
    fig;
catch
    fig=0;
end

x=(tps-min(tps))/max((tps-min(tps)))*100;
y=(val-min(val))/max((val-min(val)));

if fig==1
figure, hold on

end

%%
f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
p = nlinfit(x,y,f,[0 20 50 5]);

xn=[0:0.01:100];
k=p(1) + p(2) ./ (1 + exp(-(xn-p(3))/p(4)));

if fig==1
%line(xn,f(p,x),'color','r','linewidth',2)
plot(xn,k,'color','r','linewidth',2)
plot(x,y,'ko','MarkerFaceColor','k')
end

%%
% fit(x,y,'a + b ./ (1 + exp(-(x-m)/s))','start',[0 20 50 5]) 



if fig==1
% plot(x,k,'ro')
end

ini=k(1);
fin=k(end);

if ini<fin
    temp=xn((k>fin-0.1*(fin-ini)));
    perc1=min(temp);
    temp=xn((k>fin-0.9*(fin-ini)));
    perc2=min(temp);
    ref=fin-0.1*(fin-ini);
else
    temp=xn((k>ini-0.1*(ini-fin)));
    perc1=max(temp);
    temp=xn((k>ini-0.9*(ini-fin)));
    perc2=max(temp);
    ref=ini-0.1*(ini-fin);
end

Perc=abs(perc2-perc1)/100*(tps(end)-tps(1));


if ini<fin
    temp=xn((k>fin-0.2*(fin-ini)));
    tfin=min(temp);
    temp=xn((k>fin-0.8*(fin-ini)));
    tdeb=min(temp);
else
    temp=xn((k>ini-0.2*(ini-fin)));
    tfin=max(temp);
    temp=xn((k>ini-0.8*(ini-fin)));
    tdeb=max(temp);
end


tdeb=tdeb/100*(tps(end)-tps(1));
tfin=tfin/100*(tps(end)-tps(1));




if fig==1

line([perc1 perc1],[0 1],'color','c')
line([perc2 perc2],[0 1],'color','c')
% line([0 100],[ref ref],'color','c')
title(['transition time : ',num2str(Perc),' ms'])

end


T=rescaleKB(xn,tps(1),tps(end));
%id=find(k>0.5);
id=find(k>(max(k)-min(k))/2);
EC50=T(id(1));

V=rescaleKB(k,min(k)+min(val),max(k)*max(val));
Vmax=V(end);



