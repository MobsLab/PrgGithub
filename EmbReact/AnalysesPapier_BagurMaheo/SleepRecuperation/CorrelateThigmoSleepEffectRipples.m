clear all
sess = 2;
load('Thigmotaxy_HC.mat')
LimInOut = 8;
Thigmo{1} = nanmean(AllH{sess}{1}(:,1:LimInOut)')./nanmean(AllH{sess}{1}(:,LimInOut+1:end)');
Thigmo{2} = nanmean(AllH{sess}{2}(:,1:LimInOut)')./nanmean(AllH{sess}{2}(:,LimInOut+1:end)');

load('RippleEffect_Sleep.mat')
Wake{1} = MnWk.sleep_post(1,:);
Wake{2} = MnWk.sleep_post(2,:);


REM{1} = REM_1hr.sleep_post(1,:);
REM{2} = REM_1hr.sleep_post(2,:);


figure
subplot(2,2,1)
plot(Thigmo{1},Wake{1},'k.')
hold on
plot(Thigmo{2},Wake{2},'r.')
% [R,P] = corrcoef(Thigmo{1},Wake{1});
% [R,P] = corrcoef(Thigmo{2},Wake{2});
[R,P] = corrcoef([Thigmo{1},Thigmo{2}],[Wake{1},Wake{2}]);
makepretty
ylabel('Wake prop')
xlabel('Thigmo score')
title(['R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])

subplot(2,2,2)
plot(Thigmo{1},REM{1},'k.')
hold on
plot(Thigmo{2},REM{2},'r.')
[R,P] = corrcoef([Thigmo{1},Thigmo{2}],[REM{1},REM{2}]);
makepretty
ylabel('REM prop')
xlabel('Thigmo score')
title(['R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])

X = [Thigmo{1},Thigmo{2}];
X(X>2) = NaN;
Y = [REM{1},REM{2}];
Y(Y>0.13) = NaN;
[R,P] = corrcoef(X,Y,'Rows','complete')

subplot(2,2,3)
plot(Wake{1},REM{1},'k.')
hold on
plot(Wake{2},REM{2},'r.')
[R,P] = corrcoef([Wake{1},Wake{2}],[REM{1},REM{2}]);
makepretty
xlabel('Wake prop')
ylabel('REM prop')
title(['R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
