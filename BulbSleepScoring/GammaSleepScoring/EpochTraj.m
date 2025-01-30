function EpochTraj(filename)

cd(filename)
load('StateEpochSB.mat')
dt=20;
% plot basic figure
fig=figure; set(fig,'Position',[66 1 1615 971]);
times=(Range(smooth_ghi));
smooth_Theta=Restrict(smooth_Theta,times);
times=ts(times(1:300:end));
smooth_Theta_und=Restrict(smooth_Theta,times);
smooth_ghi_und=Restrict(smooth_ghi,times);

sizedt=ceil(dt/median(diff(Range(smooth_ghi,'s'))));
% get percentage levels
sleepgam=mean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
sleepthet=mean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
remgam=mean(log(Data(Restrict(smooth_ghi,REMEpoch))));
remthet=mean(log(Data(Restrict(smooth_Theta,REMEpoch))));
wakegam=mean(log(Data(Restrict(smooth_ghi,wakeper))));
wakethet=mean(log(Data(Restrict(smooth_Theta,wakeper))));


% sws/REM transitions
[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
[gam{1},thet{1}]=GetTransitionData(aft_cell,smooth_ghi,smooth_Theta,sizedt);
[delta{1,1},goodper{1,1},good{1,1}]=transitiontimes(thet{1}{1},sizedt,[sleepthet+(remthet-sleepthet)*0.3,sleepthet+(remthet-sleepthet)*0.7]);
[delta{1,2},goodper{1,2},good{1,2}]=transitiontimes(thet{1}{2},sizedt,[sleepthet+(remthet-sleepthet)*0.7,sleepthet+(remthet-sleepthet)*0.3]);

% sws/wake transition
[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
[gam{2},thet{2}]=GetTransitionData(aft_cell,smooth_ghi,smooth_Theta,sizedt);
[delta{2,1},goodper{2,1},good{2,1}]=transitiontimes(gam{2}{1},sizedt,[sleepgam+(wakegam-sleepgam)*0.3,sleepgam+(wakegam-sleepgam)*0.7]);
[delta{2,2},goodper{2,2},good{2,2}]=transitiontimes(gam{2}{2},sizedt,[sleepgam+(wakegam-sleepgam)*0.7,sleepgam+(wakegam-sleepgam)*0.3]);

% rem/wake transition
[aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
[gam{3},thet{3}]=GetTransitionData(aft_cell,smooth_ghi,smooth_Theta,sizedt);
[delta{3,1},goodper{3,1},good{3,1}]=transitiontimes(gam{3}{1},sizedt,[remgam+(wakegam-remgam)*0.3,remgam+(wakegam-remgam)*0.7]);

%figure

subplot(5,5,1)
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt+median(diff(Range(smooth_ghi,'s')))];
plot(timeaxis,thet{1}{1},'color',[0.2 0.2 0.2]);
hold on
y1=mean(thet{1}{1})-stdError(thet{1}{1});                   %#create first curve
y2=mean(thet{1}{1})+stdError(thet{1}{1});                  %#create second curve
X=[timeaxis,fliplr(timeaxis)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(thet{1}{1}),'r','linewidth',3)
box off
title('SWS-->REM')
ylabel('theta/delta')
xlim([-10 10])

subplot(5,5,2)
plot(timeaxis,thet{1}{2},'color',[0.2 0.2 0.2]);
hold on
y1=mean(thet{1}{2})-stdError(thet{1}{2});                   %#create first curve
y2=mean(thet{1}{2})+stdError(thet{1}{2});                  %#create second curve
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(thet{1}{2}),'r','linewidth',3)
box off
title('REM-->SWS')
ylabel('theta/delta')
xlim([-10 10])

subplot(5,5,3)
plot(timeaxis,gam{2}{1},'color',[0.2 0.2 0.2]);
hold on
y1=mean(gam{2}{1})-stdError(gam{2}{1});                   %#create first curve
y2=mean(gam{2}{1})+stdError(gam{2}{1});                  %#create second curve
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(gam{2}{1}),'r','linewidth',3)
box off
title('SWS-->wake')
ylabel('gamma')
xlim([-10 10])

subplot(5,5,4)
plot(timeaxis,gam{2}{2},'color',[0.2 0.2 0.2]);
hold on
y1=mean(gam{2}{2})-stdError(gam{2}{2});                   %#create first curve
y2=mean(gam{2}{2})+stdError(gam{2}{2});                  %#create second curve
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(gam{2}{2}),'r','linewidth',3)
box off
title('wake-->SWS')
ylabel('gamma')
xlim([-10 10])

subplot(5,5,5)
plot(timeaxis,gam{3}{1},'color',[0.2 0.2 0.2]);
hold on
y1=mean(gam{3}{1})-stdError(gam{3}{1});                   %#create first curve
y2=mean(gam{3}{1})+stdError(gam{3}{1});                  %#create second curve
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(gam{3}{1}),'r','linewidth',3)
box off
title('REM-->wake')
ylabel('gamma')
xlim([-10 10])

subplot(5,5,5)
plot(timeaxis,gam{3}{1},'color',[0.2 0.2 0.2]);
hold on
y1=mean(gam{3}{1})-stdError(gam{3}{1});                   %#create first curve
y2=mean(gam{3}{1})+stdError(gam{3}{1});                  %#create second curve
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(timeaxis,mean(gam{3}{1}),'r','linewidth',3)
box off
title('REM-->wake')
ylabel('gamma')
xlim([-10 10])
skiptime=22000;
figsmoo=500;
subplot(5,5,[6:9,11:14,16:19,21:24])
plot(log(Data(smooth_ghi_und)),log(Data(smooth_Theta_und)),'.','color',[0.6 0.6 0.6],'MarkerSize',1); hold on;
plot(smooth(log(gam{1}{1}(:,skiptime:end-skiptime))',figsmoo),smooth(log(thet{1}{1}(:,skiptime:end-skiptime))',figsmoo),'color',[1 0.8 0.2])
plot(smooth(log(gam{1}{2}(:,skiptime:end-skiptime))',figsmoo),smooth(log(thet{1}{2}(:,skiptime:end-skiptime))',figsmoo),'color',[1 0.2 0])
plot(smooth(log(gam{2}{1}(:,skiptime:end-skiptime))',figsmoo),smooth(log(thet{2}{1}(:,skiptime:end-skiptime))',figsmoo),'color',[0.2 0.8 1])
plot(smooth(log(gam{2}{2}(:,skiptime:end-skiptime))',figsmoo),smooth(log(thet{2}{2}(:,skiptime:end-skiptime))',figsmoo),'color',[0.8 0.2 1])
plot(smooth(log(gam{3}{1}(:,skiptime:end-skiptime))',figsmoo),smooth(log(thet{3}{1}(:,skiptime:end-skiptime))',figsmoo),'color',[0 0 1])
legend('All Data','S2R','R2S','S2W','W2S','R2W')

subplot(5,5,[10,15])
h=bar(1,mean(delta{1,1})); hold on
g=bar(2,mean(delta{1,2}));
errorbar([1,2],[mean(delta{1,1}),mean(delta{1,2})],[stdError(delta{1,1}),stdError(delta{1,2})],'xk')
set(h,'facecolor',[1 0.8 0.2])
set(g,'facecolor',[1 0.2 0])

subplot(5,5,[20,25])
h=bar(1,mean(delta{2,1})); hold on
g=bar(2,mean(delta{2,2}));
i=bar(3,mean(delta{3,1}));
errorbar([1,2,3],[mean(delta{2,1}),mean(delta{2,2}),mean(delta{3,1})],[stdError(delta{2,1}),stdError(delta{2,2}),stdError(delta{3,1})],'xk')
set(h,'facecolor',[0.2 0.8 1])
set(g,'facecolor',[0.8 0.2 1])
set(i,'facecolor',[0 0 1])

saveas(fig,'Trajectorystudy.png')
saveas(fig,'Trajectorystudy.fig')
save('Trajectories.mat','gam','thet','delta','gam','goodper','good')
end