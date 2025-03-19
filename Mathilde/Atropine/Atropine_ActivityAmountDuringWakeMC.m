
clear all
load('behavResources.mat')
load('SleepScoring_OBGamma.mat')
figure,plot(Range(MovAcctsd),Data(MovAcctsd),'k')
hold on,plot(Range(Restrict(MovAcctsd,Wake)),Data(Restrict(MovAcctsd,Wake)),'b')
plot(Range(Restrict(MovAcctsd,and(Wake,ThetaEpoch))),Data(Restrict(MovAcctsd,and(Wake,ThetaEpoch))),'color', [0 1 1])
legend({'All','Wake','Wake theta'})


TotAcc_Wake = mean(Data(Restrict(MovAcctsd,Wake)));
ToatAcc_WakeTheta = mean(Data(Restrict(MovAcctsd,and(Wake,ThetaEpoch))));


%%

DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

%% input dir
DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');
DirBaselineMC = PathForExperimentsAtropine_MC('Baseline');

DirAtropineTG = PathForExperiments_TG('atropine_Atropine');
DirBaselineTG = PathForExperiments_TG('atropine_Baseline');

DirAtropine = MergePathForExperiment(DirAtropineMC, DirAtropineTG);
DirBaseline = MergePathForExperiment(DirBaselineMC, DirBaselineTG);

%%
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('behavResources.mat', 'MovAcctsd');
    b{i} = load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','ThetaEpoch');
    durtotal_sal = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
    Epoch1_sal{i} = intervalSet(0,durtotal_sal/2);
    Epoch2_sal{i} = intervalSet(durtotal_sal/2,durtotal_sal);
    
    TotAcc_WakeBefore_sal(i) = mean(Data(Restrict(a{i}.MovAcctsd, and(b{i}.Wake,Epoch1_sal{i}))));
    TotAcc_WakeAfter_sal(i) = mean(Data(Restrict(a{i}.MovAcctsd, and(b{i}.Wake,Epoch2_sal{i}))));
    ToatAcc_WakeThetaBefore_sal(i) = mean(Data(Restrict(a{i}.MovAcctsd, and(and(b{i}.Wake,Epoch1_sal{i}),b{i}.ThetaEpoch))));
    ToatAcc_WakeThetaAfter_sal(i) = mean(Data(Restrict(a{i}.MovAcctsd, and(and(b{i}.Wake,Epoch2_sal{i}),b{i}.ThetaEpoch))));
end

for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    c{j} = load('behavResources.mat', 'MovAcctsd');
    d{j} = load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','ThetaEpoch');
    durtotal_atrop = max([max(End(d{j}.Wake)),max(End(d{j}.SWSEpoch))]);
    Epoch1_atrop{j} = intervalSet(0,durtotal_atrop/2);
    Epoch2_atrop{j} = intervalSet(durtotal_atrop/2,durtotal_atrop);
    
    TotAcc_WakeBefore_atropine(j) = mean(Data(Restrict(c{j}.MovAcctsd, and(d{j}.Wake,Epoch1_atrop{j}))));
    TotAcc_WakeAfter_atropine(j) = mean(Data(Restrict(c{j}.MovAcctsd, and(d{j}.Wake,Epoch2_atrop{j}))));
    ToatAcc_WakeThetaBefore_atropine(j) = mean(Data(Restrict(c{j}.MovAcctsd, and(and(d{j}.Wake,Epoch1_atrop{j}),d{j}.ThetaEpoch))));
    ToatAcc_WakeThetaAfter_atropine(j) = mean(Data(Restrict(c{j}.MovAcctsd, and(and(d{j}.Wake,Epoch2_atrop{j}),d{j}.ThetaEpoch))));
end

%%
figure, subplot(121), PlotErrorBarN_KJ({TotAcc_WakeBefore_sal, TotAcc_WakeBefore_atropine}, 'newfig',0)
ylim([0 12e7])
xticks([1 2])
xticklabels({'Saline','Atropine'})
subplot(122), PlotErrorBarN_KJ({TotAcc_WakeAfter_sal, TotAcc_WakeAfter_atropine}, 'newfig',0)
ylim([0 12e7])
xticks([1 2])
xticklabels({'Saline','Atropine'})

%%
figure, subplot(121), PlotErrorBarN_KJ({ToatAcc_WakeThetaBefore_sal, ToatAcc_WakeThetaBefore_atropine}, 'newfig',0)
ylim([0 12e7])
xticks([1 2])
xticklabels({'Saline','Atropine'})
subplot(122), PlotErrorBarN_KJ({ToatAcc_WakeThetaAfter_sal, ToatAcc_WakeThetaAfter_atropine}, 'newfig',0)
ylim([0 12e7])
xticks([1 2])
xticklabels({'Saline','Atropine'})
