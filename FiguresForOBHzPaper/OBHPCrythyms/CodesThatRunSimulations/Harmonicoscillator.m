cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP5.mat')
LFPB=FilterLFP(LFP,[1 20],1024);
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP2.mat')
LFPH=FilterLFP(LFP,[1 20],1024);
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP8.mat')
LFPP=LFP;
LFPPf=FilterLFP(LFPP,[1 20],1024);
load('behavResources.mat')

FreezeEpoch2=intervalSet(Start(FreezeEpoch)-2E4,Stop(FreezeEpoch)+2E4);

st=Stop(FreezeEpoch);
st=Start(FreezeEpoch);
FreezeEpoch2=intervalSet(st-2E4,st+6E4);


% 
% %% good params
% no=1;
% no=no+1;
% dt=1/1250;
% k=10;
% c=0.2;
% m=0.005;
% f=sqrt(k/m)/(2*pi)
% clear x
% x(1)=000;
% xd(1)=00;
% F=(-50*Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+50*Data(Restrict(LFPB,subset(FreezeEpoch2,no))));
% for t=2:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))
%     x(t)=x(t-1)+dt*xd(t-1);
%     xd(t)=xd(t-1)+dt*(-c*xd(t-1)-k*x(t-1)+F(t))/m;
% end
% clf
% plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),5000+Data(Restrict(LFPB,subset(FreezeEpoch2,no))),'b'), hold on
% plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),2*Data(Restrict(LFPP,subset(FreezeEpoch2,no))),'r','linewidth',2), hold on
% plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),7000+Data(Restrict(LFPH,subset(FreezeEpoch2,no))),'m'), hold on
% plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),-Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+Data(Restrict(LFPB,subset(FreezeEpoch2,no)))-1e4,'m'), hold on
% x=std(Data(Restrict(LFPP,subset(FreezeEpoch2,no))))*x./std(x);
% plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),x,'k','linewidth',2)


no=1;


no=no+1;
dt=1/1250;
k=10;
c=0.2;
m=0.005;
f=sqrt(k/m)/(2*pi)
clear x
clear x2
x(1)=000;
xd(1)=00;
F=(-60*Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+40*Data(Restrict(LFPB,subset(FreezeEpoch2,no))));
for t=2:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))
    x(t)=x(t-1)+dt*xd(t-1);
    xd(t)=xd(t-1)+dt*(-c*xd(t-1)-k*x(t-1)+F(t))/m;
end

x2(1)=000;
xd2(1)=00;
% F=(-50*Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+50*Data(Restrict(LFPB,subset(FreezeEpoch2,no))));
F2=(100*Data(Restrict(LFPB,subset(FreezeEpoch2,no))));
for t=2:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))
    x2(t)=x2(t-1)+dt*xd2(t-1);
    xd2(t)=xd2(t-1)+dt*(-c*xd2(t-1)-k*x2(t-1)+F2(t))/m;
end


clf
subplot(4,3,1:6), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),5000+Data(Restrict(LFPB,subset(FreezeEpoch2,no))),'b'), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),2*Data(Restrict(LFPP,subset(FreezeEpoch2,no)))-0.7e4,'r','linewidth',2), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),5000+Data(Restrict(LFPH,subset(FreezeEpoch2,no))),'m'), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),-Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+Data(Restrict(LFPB,subset(FreezeEpoch2,no))),'color',[0.6 0.6 0.6]), hold on
x=std(Data(Restrict(LFPP,subset(FreezeEpoch2,no))))*x./std(x);
x2=std(Data(Restrict(LFPP,subset(FreezeEpoch2,no))))*x2./std(x2);
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),x-0.7e4,'k','linewidth',2)

plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),-1.4E4+2*Data(Restrict(LFPP,subset(FreezeEpoch2,no))),'r','linewidth',2), hold on
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),-1.4E4+x2,'k','linewidth',2)



subplot(4,3,7:9), hold on
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),SmoothDec((x'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2,10),'r')
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),SmoothDec((x2'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2,10),'color',[0.6 0.6 0.6])
title([num2str(mean((x'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2)/std(x)), '   -   ', num2str(mean((x2'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2)/std(x2))])


d=Data(Restrict(LFPPf,subset(FreezeEpoch2,no)));
l=length(x);
ida=(1:floor(length(x)/3));
idb=(floor(length(x)/3):2*floor(length(x)/3));
idc=(2*floor(length(x)/3):l);

[C1a,B1a]=xcorr(x(ida),d(ida),1000,'coeff');
[C2a,B2a]=xcorr(x2(ida),d(ida),1000,'coeff');
[C3a,B3a]=xcorr(d(ida),d(ida),1000,'coeff');

[C1b,B1b]=xcorr(x(idb),d(idb),1000,'coeff');
[C2b,B2b]=xcorr(x2(idb),d(idb),1000,'coeff');
[C3b,B3b]=xcorr(d(idb),d(idb),1000,'coeff');

[C1c,B1c]=xcorr(x(idc),d(idc),1000,'coeff');
[C2c,B2c]=xcorr(x2(idc),d(idc),1000,'coeff');
[C3c,B3c]=xcorr(d(idc),d(idc),1000,'coeff');

subplot(4,3,10), hold on
plot(B3a,C3a,'k','linewidth',2)
plot(B1a,C1a,'r')
plot(B2a,C2a,'color',[0.6 0.6 0.6])
ylim([-1 1])

subplot(4,3,11), hold on
plot(B3b,C3b,'k','linewidth',2)
plot(B1b,C1b,'r')
plot(B2b,C2b,'color',[0.6 0.6 0.6])
ylim([-1 1])

subplot(4,3,12), hold on
plot(B3c,C3c,'k','linewidth',2)
plot(B1c,C1c,'r')
plot(B2c,C2c,'color',[0.6 0.6 0.6])
ylim([-1 1])
