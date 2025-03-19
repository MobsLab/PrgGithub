function DeltaEvolution(Dpfc,Dpac,lim,smo)

try
    smo;
catch
    smo=0;
end


rg=Range(Dpfc,'s');
rg2=Range(Dpac,'s');

id=find(diff(rg)<lim);
id2=find(diff(rg2)<lim);

figure('color',[1 1 1]), 
subplot(2,4,1:2), plot(rg(2:end)/3600,diff(rg),'k'), ylabel('PFCx')
hold on, plot(rg(1:end-1)/3600,SmoothDec(diff(rg),3),'r.','markersize',10)
hold on, plot(rg(id)/3600,0.5*ones(length(id),1),'bo','markerfacecolor','b')
ylim([0 10])

subplot(2,4,[3,7]), hold on, 
plot(rg(id),1:length(id), 'k','linewidth',2)
plot(rg2(id2),1:length(id2), 'r','linewidth',2)

%[h1a,b1a]=hist(diff(rg),[0:0.01:2]);h1a(end)=0;
[h1b,b1b]=hist(diff(rg(1:floor(length(rg)/4))),[0:0.01:4]);h1b(end)=0;
[h1c,b1c]=hist(diff(rg(3*floor(length(rg)/4):end)),[0:0.01:4]);h1c(end)=0;
[C1b,B1b]=CrossCorr(rg(1:floor(length(rg)/4))*1E4,rg(1:floor(length(rg)/4))*1E4,20,500);C1b(B1b==0)=0;
[C1c,B1c]=CrossCorr(rg(3*floor(length(rg)/4):end)*1E4,rg(3*floor(length(rg)/4):end)*1E4,20,500);C1c(B1c==0)=0;

subplot(2,4,4), hold on
plot(b1b,SmoothDec(h1b/max(h1b),smo),'k')
plot(b1c,SmoothDec(h1c/max(h1c),smo),'r')
plot(B1b/1E3,SmoothDec(C1b/max(C1b),smo),'b')
plot(B1c/1E3,SmoothDec(C1c/max(C1c),smo),'m')
xlim([0 3.9])



subplot(2,4,5:6), plot(rg2(2:end),diff(rg2),'k'), ylabel('PaCx')
hold on, plot(rg2(1:end-1),SmoothDec(diff(rg2),3),'r.','markersize',10)
hold on, plot(rg2(id2),0.5*ones(length(id2),1),'bo','markerfacecolor','b')
ylim([0 10])
% 
% subplot(2,4,7), hold on
% plot(cumsum(rg(id))/sum(rg(id)),'k','linewidth',2);
% plot(cumsum(rg2(id2))/sum(rg2(id2)),'r','linewidth',2);


% [h2a,b2a]=hist(diff(rg2),[0:0.01:2]);h2a(end)=0;
[h2b,b2b]=hist(diff(rg2(1:floor(length(rg)/4))),[0:0.01:4]);h2b(end)=0;
[h2c,b2c]=hist(diff(rg2(3*floor(length(rg)/4):end)),[0:0.01:4]);h2c(end)=0;
[C2b,B2b]=CrossCorr(rg2(1:floor(length(rg2)/4))*1E4,rg2(1:floor(length(rg2)/4))*1E4,20,500);C2b(B2b==0)=0;
[C2c,B2c]=CrossCorr(rg2(3*floor(length(rg2)/4):end)*1E4,rg2(3*floor(length(rg2)/4):end)*1E4,20,500);C2c(B2c==0)=0;

subplot(2,4,8), hold on
plot(b2b,SmoothDec(h2b/max(h2b),smo),'k')
plot(b2c,SmoothDec(h2c/max(h2c),smo),'r')
plot(B2b/1E3,SmoothDec(C2b/max(C2b),smo),'b')
plot(B2c/1E3,SmoothDec(C2c/max(C2c),smo),'m')
xlim([0 3.9])

set(gcf,'position',[15         348        1426         420])