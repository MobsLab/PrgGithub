cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP5.mat')
LFPB=FilterLFP(LFP,[1 20],1024);
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP2.mat')
LFPH=FilterLFP(LFP,[1 20],1024);
load('/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPData/LFP8.mat')
LFPP=LFP;
LFPPf=FilterLFP(LFPP,[1 20],1024);
load('behavResources.mat')
FreezeEpoch2=intervalSet(Start(FreezeEpoch)-5E4,Stop(FreezeEpoch)+5E4);

no=1;
no=no+1;
dt=1/1250;
k=10;
c=0.25;
m=0.005;
f=sqrt(k/m)/(2*pi)
clear x
clear x2
x(1)=000;
xd(1)=00;
F=(-50*Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+50*Data(Restrict(LFPB,subset(FreezeEpoch2,no))));
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
subplot(4,1,1:3), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),5000+Data(Restrict(LFPB,subset(FreezeEpoch2,no))),'b'), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),2*Data(Restrict(LFPP,subset(FreezeEpoch2,no))),'r','linewidth',2), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),5000+Data(Restrict(LFPH,subset(FreezeEpoch2,no))),'m'), hold on
plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),-Data(Restrict(LFPH,subset(FreezeEpoch2,no)))+Data(Restrict(LFPB,subset(FreezeEpoch2,no)))-0.7e4,'m'), hold on
x=std(Data(Restrict(LFPP,subset(FreezeEpoch2,no))))*x./std(x);
x2=std(Data(Restrict(LFPP,subset(FreezeEpoch2,no))))*x2./std(x2);
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),x,'k','linewidth',2)

plot(Range(Restrict(LFPB,subset(FreezeEpoch2,no)),'s'),-1.4E4+2*Data(Restrict(LFPP,subset(FreezeEpoch2,no))),'r','linewidth',2), hold on
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),-1.4E4+x2,'k','linewidth',2)



subplot(4,1,4), hold on
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),SmoothDec((x'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2,10),'r')
plot([1:length(Data(Restrict(LFPH,subset(FreezeEpoch2,no))))]*dt+Start(subset(FreezeEpoch2,no),'s'),SmoothDec((x2'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2,10),'color',[0.6 0.6 0.6])
title([num2str(mean((x'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2)/std(x)), '   -   ', num2str(mean((x2'-Data(Restrict(LFPPf,subset(FreezeEpoch2,no)))).^2)/std(x2))])


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
