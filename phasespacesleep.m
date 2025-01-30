for chan=ch(4:end)
load(strcat('gamma_ch_',num2str(chan),'.mat'))
ghi_new=Restrict(smooth_ghi,Epoch);
theta_new=Restrict(ThetaRatioTSD,Epoch);
t=Range(ghi_new);
ti=t(5:100:end);
ghi_new=Restrict(smooth_ghi,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

dur1=[];
dur2=[];
dur3=[];
dur4=[];
dur5=[];
dur6=[];
dur7=[];
dur8=[];

h=figure
set(h,'Position',[2000 2000 2000 1000])
subplot(2,2,1)

sleeptheta=(Restrict(ThetaRatioTSD,SWSEpoch));
ghi_new_s=Restrict(smooth_ghi,ts(Range(sleeptheta)))
% scatter(log(Data(ghi_new_s)),log(Data(sleeptheta)),5,ones(length(Data(sleeptheta)),1),'filled');
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0 0.2 0.8],'MarkerSize',5);
hold on
remtheta=(Restrict(ThetaRatioTSD,REMEpoch));
ghi_new_r=Restrict(smooth_ghi,ts(Range(remtheta)));
% scatter(log(Data(ghi_new_r)),log(Data(remtheta)),5,2*ones(length(Data(remtheta)),1),'filled');
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0.8 0.2 0.1],'MarkerSize',5);
waketheta=(Restrict(ThetaRatioTSD,Wake));
ghi_new_w=Restrict(smooth_ghi,ts(Range(waketheta)));
% scatter(log(Data(ghi_new_w)),log(Data(waketheta)),5,4*ones(length(Data(waketheta)),1),'filled');
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.2 0.2 0.2],'MarkerSize',5);
title(num2str(chan));
xlabel('gamma bulb')
ylabel('theta hpc')
legend('SWS','REM','Wake')
ti=t(5:300:end);
ghi_new=Restrict(smooth_ghi,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

subplot(2,2,2)
plot(log(Data(ghi_new)),log(Data(theta_new)),'color',[0.6 0.6 0.6])
xlabel('gamma bulb')
ylabel('theta hpc')
% saveFigure(h,strcat('phasespace_ch_',num2str(chan)),'')
% close(h)

ti=t(5:100:end);
ghi_new=Restrict(smooth_ghi,ts(ti));
theta_new=Restrict(theta_new,ts(ti));
ghi_new=tsd(Range(ghi_new),Data(ghi_new)-min(Data(ghi_new)));
ghi_new=tsd(Range(ghi_new),Data(ghi_new)/max(Data(ghi_new)));
theta_new=tsd(Range(theta_new),Data(theta_new)-min(Data(theta_new)));
theta_new=tsd(Range(theta_new),Data(theta_new)/max(Data(theta_new)));
a=Data(ghi_new);
b=Data(theta_new);
for k=2:size(ti)-1

%     do dist1/dit2
%     look at direction

dur1(k)=sqrt((b(k-1)-b(k+1))^2);
dur2(k)=sqrt((a(k-1)-a(k+1))^2);
dur3(k)=sqrt((b(k-1)-b(k+1))^2+(a(k-1)-a(k+1))^2);
dur4(k)=abs(b(k-1)-b(k))/abs(b(k-1)-b(k+1));
dur5(k)=abs(a(k-1)-a(k))/abs(a(k-1)-a(k+1));
dur6(k)=(sqrt((b(k-1)-b(k))^2+(a(k-1)-a(k))^2))/(sqrt((b(k-1)-b(k+1))^2+(a(k-1)-a(k+1))^2));
dur7(k)=((b(k-1)-b(k+1)));
dur8(k)=((a(k-1)-a(k+1)));



%    dur(k)=FindEpochLength(t(k),SWSEpoch,REMEpoch,Wake,MicroWake,MicroSleep,strSleep,strWake);
end
dur1(1)=0;
dur1(size(t))=0;
dur2(1)=0;
dur3(1)=0;
dur2(size(t))=0;
dur3(size(t))=0;
% h=figure
% subplot(1,3,1)
% scatter(log(Data(ghi_new)),log(Data(theta_new)),15,log(dur1),'filled');
% set(gca,'XScale','log','YScale','log')
% xlabel('gamma bulb')
% ylabel('theta hpc')
% 
% % xlim([0.00003 1])
% % ylim([0.05 1.1])
% % caxis([-16 3])
% title('vertical speed - blb')
% subplot(1,3,2)
% scatter((Data(ghi_new)),(Data(theta_new)),15,log(dur2),'filled');
% set(gca,'XScale','log','YScale','log')
% % xlim([0.00003 1])
% % caxis([-16 3])
% % ylim([0.05 1.1])
% xlabel('gamma bulb')
% ylabel('theta hpc')
% 
% title('horizontal speed')
% subplot(1,3,3)
% scatter((Data(ghi_new)),(Data(theta_new)),15,log(dur3),'filled');
% title('total speed')
% set(gca,'XScale','log','YScale','log')
% xlabel('gamma bulb')
% ylabel('theta hpc')
% close h
% % ylim([0.05 1.1])
% % xlim([0.00003 1])
% % caxis([-16 3])

% h=figure
set(h,'Position',[2000 2000 1500 500])
set(h,'Position',[2000 2000 2000 1000])
    subplot(2,3,4)
    [mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur1,80,80,[2 -8],[1 -7]);
    imagesc((mn)')
    axis xy
    title('theta speed')
subplot(2,3,5)
[mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur2,80,80,[2 -8],[1 -7]);
imagesc(log(mn)')
axis xy
title('gamma speed')
subplot(2,3,6)
[mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur3,80,80,[2 -8],[1 -7]);
imagesc(log(mn)')
axis xy
title('total speed')
% saveFigure(h,strcat('phasespacespeed_ch_',num2str(chan)),'')
% close(h)

end


%%%%%%
ghi_new=Restrict(smooth_ghi,Epoch);
theta_new=Restrict(ThetaRatioTSD,Epoch);
t=Range(ghi_new);
% t=t(1::end);
dur=[];
ghi_new=Restrict(smooth_ghi,ts(t));
theta_new=Restrict(theta_new,ts(t));
a=Data(ghi_new);
b=Data(theta_new);
for k=2:size(t)-1
%     dur(k)=sqrt((a(k-1)-a(k+1))^2);
try
   dur(k)=FindEpochLength(t(k),SWSEpoch,REMEpoch,Wake,MicroWake,MicroSleep,strSleep,strWake);
catch dur(k)=NaN;
end
end
dur(1)=0;
dur(size(t))=0;

% figure
scatter(log(Data(ghi_new)),log(Data(theta_new)),15,log(dur),'filled');

%%%


figure
subplot(1,3,1)
[mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur4,50,50,[-2 -8],[0 -3]);
imagesc(log(mn)')
axis xy
title('theta ratio')
subplot(1,3,2)
[mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur5,50,50,[-2 -8],[0 -3]);
imagesc(log(mn)')
axis xy
title('gamma ratio')
subplot(1,3,3)
[mn,sd]=mean2D(log(Data(ghi_new)),log(Data(theta_new)),dur6,50,50,[-2 -8],[0 -3]);
imagesc(log(mn)')
axis xy
title('total ratio')

figure
subplot(2,2,1)
g=Data(ghi_new);
th=Data(theta_new);
[mn,sd]=mean2D(log(g(find(dur7'<0))),log(th(find(dur7'<0))),dur7(find(dur7'<0)),50,50,[-2 -8],[0 -3]);
imagesc(log(abs(mn))')
axis xy
title('theta speed, increasing')
subplot(2,2,3)
[mn,sd]=mean2D(log(g(dur7>0)),log(th(dur7>0)),dur7(dur7>0),50,50,[-2 -8],[0 -3]);
imagesc(log(abs(mn))')
axis xy
title('theta speed, decreasing')

subplot(2,2,2)
[mn,sd]=mean2D(log(g(dur8<0)),log(th(dur8<0)),dur7(dur8<0),50,50,[-2 -8],[0 -3]);
imagesc(log(abs(mn))')
axis xy
title('gamma speed, increasing')

subplot(2,2,4)
[mn,sd]=mean2D(log(g(dur8>0)),log(th(dur8>0)),dur7(dur8>0),50,50,[-2 -8],[0 -3]);
imagesc(log(abs(mn))')
axis xy
title('gamma speed, decreasing')