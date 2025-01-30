clear all
Dir = PathForExperimentsEmbReact('BaselineSleep');
n = 0;
for k = 1 : length(Dir.path)
    
    cd(Dir.path{k}{1})
    if exist('HeartBeatInfo.mat')>0 & exist('SleepSubstages.mat')>0
        load('HeartBeatInfo.mat')
        load('SleepSubstages.mat')
        n=n+1;
        [Y.N1(n,:),X] = hist(Data(Restrict(EKG.HBRate,Epoch{1})),[0:0.25:20]);
        [Y.N2(n,:),X] = hist(Data(Restrict(EKG.HBRate,Epoch{2})),[0:0.25:20]);
        [Y.N3(n,:),X] = hist(Data(Restrict(EKG.HBRate,Epoch{3})),[0:0.25:20]);
        [Y.REM(n,:),X] = hist(Data(Restrict(EKG.HBRate,Epoch{4})),[0:0.25:20]);
        [Y.Wake(n,:),X] = hist(Data(Restrict(EKG.HBRate,Epoch{5})),[0:0.25:20]);
       
        Mean.N1(n) = nanmean(Data(Restrict(EKG.HBRate,Epoch{1})));
        Mean.N2(n) = nanmean(Data(Restrict(EKG.HBRate,Epoch{2})));
        Mean.N3(n) = nanmean(Data(Restrict(EKG.HBRate,Epoch{3})));
        Mean.REM(n) = nanmean(Data(Restrict(EKG.HBRate,Epoch{4})));
        Mean.Wake(n) = nanmean(Data(Restrict(EKG.HBRate,Epoch{5})));

    end
    
end

figure
clf
plot(X,nanmean(Y.N1./sum(Y.N1')'),'b','linewidth',3), hold on
plot(X,nanmean(Y.N2./sum(Y.N2')'),'g','linewidth',3), hold on
plot(X,nanmean(Y.N3./sum(Y.N3')'),'m','linewidth',3), hold on
plot(X,nanmean(Y.REM./sum(Y.REM')'),'r','linewidth',3), hold on
plot(X,nanmean(Y.Wake./sum(Y.Wake')'),'k','linewidth',3), hold on
legend(NameEpoch(1:5))

PlotErrorBarN_KJ({Mean.N1,Mean.N2,Mean.N3,Mean.REM,Mean.Wake})
set(gca,'XTick',[1:5],'XTickLabel',NameEpoch(1:5))

figure
plot(X,(Y.N1./sum(Y.N1')'),'b','linewidth',3), hold on
