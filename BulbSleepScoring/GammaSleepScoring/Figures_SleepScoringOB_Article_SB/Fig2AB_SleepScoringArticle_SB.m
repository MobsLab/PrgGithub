%% Code used for Fig2 11th april draft
close all
clear all
load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243/StateEpochSB.mat')
sm_ghi=Data(smooth_ghi);
[Y,X]=hist(log(sm_ghi),1000);
Y=Y/sum(Y);
st_ = [1.07e-2 0 0.101 3.49e-3 1.5 0.21];
[cf2,goodness2]=createFit2gauss(X,Y,[]);
a= coeffvalues(cf2);
b=intersect_gaussians(a(2), a(5), a(3), a(6));
[~,ind]=max(Y);
gamma_thresh=b(b>X(ind));
figure
subplot(121)
plot(X,Y,'linewidth',2)
hold on
h_ = plot(cf2,'fit',0.95);
set(h_(1),'Color','r',...
    'LineStyle','-', 'LineWidth',3,...
    'Marker','none', 'MarkerSize',6);
legend off
xlim([4.5 8])
a= coeffvalues(cf2);
d=([min(X):max(X)/1000:max(X)*2]);
Y1=normpdf(d,a(2),a(3));
Y2=normpdf(d,a(5),a(6));
box off
subplot(122)
plot(d,Y1,'linewidth',3)
hold on
plot(d,Y2,'linewidth',3)
plot(([gamma_thresh gamma_thresh]),[0 3.3],'color','k','linewidth',3)
xlim([4.5 8])
box off



figure
subplot(4,1,[1:3])
rat_theta=Data(Restrict(smooth_Theta,sleepper));
[Y,X]=hist(rat_theta,100);
Y=Y/sum(Y);
[cf2,goodness2,output]=createFit1gauss(X,Y);
a=coeffvalues(cf2);

plot(X,Y,'linewidth',2)
hold on
h_ = plot(cf2,'fit');
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',3,...
    'Marker','none', 'MarkerSize',6);
plot(([theta_thresh theta_thresh]),[0 0.07],'color','k','linewidth',3)
box off

subplot(4,1,4)
Y1=normpdf(X,a(2),a(3)/sqrt(2));
diff=(Y-a(1)*Y1)./Y;
plot(X(1:end),abs(diff(1:end)))
hold on
line([0.5 7.5],[0.5 0.5],'linewidth',3,'color',[0.6 0.2 0.6])
ylim([-0.5 1.5])
box off
