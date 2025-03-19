function [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4,MQ,TQ]=FindDown(S,neu,SWSEpoch,siz,th,ch,smo,fac,plo,num)

%[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,neu,SWSEpoch,siz,th,ch,smo,fac,plo,num)
%[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,number,SWSEpoch,10,0.01,1,0,[0 85],1);
% siz=10;
% th=0.01;
% smo=3;
% ch=1;
%fac=[1000 1000];

siz=siz*10;

try
    fac;
    fac=fac*10;
catch
    fac=[0 0];
end

try
    num;
    if mod(num(1)*num(2),7)>0
        num=[1,7,1];
    end
catch
    num=[1,7,1];
end


T=PoolNeurons(S,neu);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,siz);
if smo>0
    Qt=tsd(Range(Q),smooth(full(Data(Q))/length(neu),smo));
else
    Qt=tsd(Range(Q),full(Data(Q))/length(neu));
end
rg=Range(Qt);
TotEpoch=intervalSet(rg(1),rg(end));

ma=max(Data(Qt));

if th>ma
    disp('******* Problem threshold ! ***********')
end

if ch==1
    Down=thresholdIntervals(Qt,th,'Direction','Below');
elseif ch==2
    Down=thresholdIntervals(Qt,ma/10,'Direction','Below');th=ma/10;
elseif ch==3
    Down=thresholdIntervals(Qt,ma/2,'Direction','Below');th=ma/2;
end


if plo
    figure('color',[1 1 1]),
    numfig=gcf;
end

subplot(num(1),num(2),num(3):num(3)+2), plot(Range(Qt,'s'),Data(Qt),'k')
hold on, plot(Range(Restrict(Qt,SWSEpoch),'s'),Data(Restrict(Qt,SWSEpoch)),'r')

xl=xlim; line(xl,[th th])

%DurTsd=tsd((Start(Down)+End(Down))/2,End(Down,'ms')-Start(Down,'ms'));
DurTsd=tsd(Start(Down),End(Down,'ms')-Start(Down,'ms'));

[h1,b1]=hist(Data(Restrict(DurTsd,SWSEpoch)),[0:floor(siz/10):2000]);
[h2,b2]=hist(Data(Restrict(DurTsd,TotEpoch-SWSEpoch)),[0:floor(siz/10):2000]);
title(['bin size: ', num2str(siz/10), 'ms, Th: ', num2str(th), ', smo: ', num2str(smo),', Nb: ',num2str(length(neu))])

% subplot(num(1),num(2),num(3)+1), hold on
% plot(b1,h1,'r','linewidth',2)
% plot(b2,h2,'k','linewidth',2)
% xlim([0 1900])

subplot(num(1),num(2),num(3)+3), hold on
plot(b1,h1,'r','linewidth',2)
plot(b2,h2,'k','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'xtick',[10 50 100 500 1500])


xlim([0 1900])
yl=ylim; line([50 50],yl,'color','b')
yl=ylim; line([100 100],yl,'color','b')
yl=ylim; line([250 250],yl,'color','b')
xlabel('Duration of Down (ms)')
ylabel('Nb of Down')
if fac(2)>0
    title(['lim: 50ms, 100ms and 250ms, Th: ',num2str(fac(2)/10),'ms'])
else
    title('lim: 50ms, 100ms and 250ms')
end

DurDownSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurDownNoSWS=sum(End((TotEpoch-SWSEpoch),'s')-Start((TotEpoch-SWSEpoch),'s'));

b=1;
for j=1:10:1000
    B(1,b+4)=sum(h1(find(b1>j)))/(sum(h1(find(b1>j)))+sum(h2(find(b2>j))))*100;
    B(2,b+4)=(sum(h1(find(b1>j)))/DurDownSWS)/((sum(h1(find(b1>j))))/DurDownSWS+sum(h2(find(b2>j)))/DurDownNoSWS)*100;
    b=b+1;
end
subplot(num(1),num(2),num(3)+4), hold on
plot(1:10:1000,B(1,5:end),'ko-','markerfacecolor','k')
plot(1:10:1000,B(2,5:end),'bo-','markerfacecolor','b')
ylim([50 100])
xlabel('Min time for Down (ms)')
ylabel('Percentage of Down during SWS')
yl=ylim; line([50 50],yl,'color','b')
yl=ylim; line([100 100],yl,'color','b')
yl=ylim; line([250 250],yl,'color','b')
title(['Nb of Down: ',num2str(length(Start(Down)))])


if fac(2)>0
    subplot(num(1),num(2),num(3)+3), yl=ylim; line([fac(2) fac(2)]/10,yl,'color','r','linewidth',2)
    subplot(num(1),num(2),num(3)+4), yl=ylim; line([fac(2) fac(2)]/10,yl,'color','r','linewidth',2)
    Down=dropShortIntervals(Down,fac(2));
    if fac(1)>0
        Down=mergeCloseIntervals(Down,fac(1));
    end
    
end


sttemp=Start(Down);
entemp=End(Down);

%intTsd=tsd((sttemp(2:end)+entemp(1:end-1))/2,(sttemp(2:end)-entemp(1:end-1))/10);
intTsd=tsd(sttemp(2:end),(sttemp(2:end)-entemp(1:end-1))/10);

% st1=Start(and(Down,SWSEpoch),'ms');
% en1=End(and(Down,SWSEpoch),'ms');
% st2=Start((Down-SWSEpoch),'ms');
% en2=End((Down-SWSEpoch),'ms');
[h3,b3]=hist(Data(Restrict(intTsd,SWSEpoch)),[0:floor(siz/2):20000]);
[h4,b4]=hist(Data(Restrict(intTsd,TotEpoch-SWSEpoch)),[0:floor(siz/2):20000]);

% subplot(num(1),num(2),num(3)+4), hold on
% plot(b3,h3,'r','linewidth',2)
% plot(b4,h4,'k','linewidth',2)
% xlim([0 19000])

subplot(num(1),num(2),num(3)+5), hold on
plot(b3,h3,'r','linewidth',2)
plot(b4,h4,'k','linewidth',2)
set(gca,'yscale','log')
set(gca,'xscale','log')
xlim([0 19000])
xlabel('Inter Down interval (ms)')
ylabel('Nb of Down')
title(['Nb of Down corrected: ',num2str(length(Start(Down)))])
set(gca,'xtick',[100 500 2000 8000])

if plo
    st=Start(Down,'s');en=End(Down,'s');
    if length(st)>5000
        [MQ,TQ]=PlotRipRaw(Qt,st(1:5000),800);close
        dur=en(1:5000)-st(1:5000);
    else
        [MQ,TQ]=PlotRipRaw(Qt,st,800);close
        dur=en-st;
    end
    figure(numfig), subplot(num(1),num(2),num(3)+6), hold on
    %[BE,id]=sort(mean(TQ(:,find(MQ(:,1)>fac(2)/1E4&MQ(:,1)<fac(2)/1E4+0.15)),2));
    
    [BD,id]=sort(dur,'Descend');
    try
        imagesc(MQ(:,1),1:5000,TQ(id,:)), colormap(pink)
    end
    try
        plot(MQ(:,1),2000+20000*mean(TQ(id(1:300),:)),'b','linewidth',2),
        plot(MQ(:,1),2000+20000*mean(TQ(id(end-300:end),:)),'r','linewidth',2), xlim([-0.8 0.8])
    end
    plot(MQ(:,1),2000+20000*mean(TQ),'w','linewidth',2)
    line([0 0],yl,'color',[0.7 0.7 0.7]), ylim([0 5000])
end
