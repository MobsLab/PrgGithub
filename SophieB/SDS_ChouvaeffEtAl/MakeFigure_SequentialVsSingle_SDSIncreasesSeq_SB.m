clear all
Cols = {'k','r'};
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);
for mm = 1:length(Dir_ctrl.path)
    enregistrements{1}{mm} = Dir_ctrl.path{mm}{1};
end

%%3
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);

for mm = 1:length(DirSocialDefeat_classic.path)
    enregistrements{2}{mm} = DirSocialDefeat_classic.path{mm}{1};
end

DirSocialDefeat_totSleepPost_dreadd_cno = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');

for mm = 1:length(DirSocialDefeat_totSleepPost_dreadd_cno.path)
    enregistrements{3}{mm} = DirSocialDefeat_totSleepPost_dreadd_cno.path{mm}{1};
end



for grp = 1:length(enregistrements)
    subplot(4,1,grp)
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','tsdMovement')
       
        
        Epoch = intervalSet(0*3600*1e4,7.8*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        maxtime{grp}(mm) = max(Range(Restrict(tsdMovement,Epoch),'min'));
        StpREM = Stop(REMEpoch,'s');
        StrtREM = Start(REMEpoch,'s');

        % get rid of last epidsode to be sure we get a good estimate of
        % interREM interval
        StpREM(end) = [];
        StrtREM(end) = [];
        
        % Basic REM characteristics
        TotRem{grp}(mm) = sum(StpREM- StrtREM);
        MnRemDur{grp}(mm) = nanmean(StpREM- StrtREM);
        NumRemEp{grp}(mm) = length(StpREM- StrtREM);
        
        RemDur{grp}{mm} = StpREM - StrtREM;
        RemDur{grp}{mm}(end) = [];
        RemInterval{grp}{mm} = StrtREM(2:end) - StpREM(1:end-1);
        for rr = 1:length(StrtREM)-1
            MiniEpoch = intervalSet(StpREM(rr)*1e4,StrtREM(rr+1)*1e4);
            MiniEpoch_NREM = and(MiniEpoch,SWSEpoch);
            RemInterval_SWS{grp}{mm}(rr) = sum(Stop(MiniEpoch_NREM) - Start(MiniEpoch_NREM))/1e4;
            MiniEpoch_Wake = and(MiniEpoch,Wake);
            RemInterval_Wake{grp}{mm}(rr) = sum(Stop(MiniEpoch_Wake) - Start(MiniEpoch_Wake))/1e4;
        end
        
                
        % Get REM followed by wake and sleep
        [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
        WakeAfterREMDur{grp}{mm} = Stop(bef_cell{2,1}) - Start(bef_cell{2,1});
        REMBeforeWakeDur{grp}{mm} = Stop(aft_cell{1,2}) - Start(aft_cell{1,2});
        
        [aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);
        SWSAfterREMDur{grp}{mm} = Stop(bef_cell{2,1}) - Start(bef_cell{2,1});
        REMBeforeSWSDur{grp}{mm} = Stop(aft_cell{1,2}) - Start(aft_cell{1,2});
    end
        
    
end

figure
subplot(1,3,1:2)
GroupNames = {'Ctrl','SDS','DREADD'};
Lim = [1,1,1,1]*5.1;
%% Look at sequential vs single
for grp = 1:3
    AllX{grp} = [];
    AllY{grp} = [];
    
    for mm = 1:length(enregistrements{grp})
        Seq =log(RemInterval_SWS{grp}{mm})<=Lim(grp);
        Single = log(RemInterval_SWS{grp}{mm})>Lim(grp);
        plot(RemDur{grp}{mm}(Seq),log(RemInterval_SWS{grp}{mm}(Seq)),'k.')
        hold on
        plot(RemDur{grp}{mm}(Single),log(RemInterval_SWS{grp}{mm}(Single)),'b.')
        AllX{grp} = [AllX{grp},RemDur{grp}{mm}'];
        AllY{grp} = [AllY{grp},log(RemInterval_SWS{grp}{mm})];
        
        hold on
        xlabel('REM duration')
        ylabel('InterREM SWS duration - log')
        makepretty
        ylim([0 8])
        xlim([0 250])
%         title(GroupNames{grp})
        
    end
end
legend('Single','Sequential')


%% Choose threhsold
subplot(1,3,3)
XBins = [0,150];
for ii = 1:length(XBins)-1
    [Y,X] = hist([AllY{1}(AllX{1}<XBins(ii+1) & AllX{1}>XBins(ii)),...
        AllY{2}(AllX{2}<XBins(ii+1) & AllX{2}>XBins(ii)),...,...
        AllY{3}(AllX{3}<XBins(ii+1) & AllX{3}>XBins(ii))],100);
   X(1) = [];
Y(1) = [];
 plot(X,runmean(Y,1))
    hold on
end
[cf2,goodness2]=createFit2gauss(X(:),Y(:),[]);
a= coeffvalues(cf2);
b=intersect_gaussians(a(2), a(5), a(3), a(6));
plot(cf2)
        xlim([0 8])
view([90 -90]) 
line([b(1) b(1)],ylim)
legend off
makepretty

clear A
for grp = 1:3
    for mm = 1:length(RemInterval_SWS{grp})
        A{grp}(mm) = length(RemInterval_SWS{grp}{mm}(log(RemInterval_SWS{grp}{mm})<Lim(grp)))/length(RemInterval_SWS{grp}{mm});
    end
end
figure
MakeSpreadAndBoxPlot2_SB(A,{},[1:3],GroupNames,'paired',0)
ylabel('Prop sequential cycles')
makepretty
clear h p stat
[h(1),p(1),stat{1}] = ranksum(A{1},A{2});
[h(2),p(2),stat{2}] = ranksum(A{1},A{3});
[h(3),p(3),stat{3}] = ranksum(A{2},A{3});
save('statsPropSeqCycles.mat','h','p','stat')


% Look at time spent in sequential NREM vs sigle NREM
clear A
for grp = 1:3
    for mm = 1:length(RemInterval_SWS{grp})
        A{grp}(mm) = sum(RemInterval_SWS{grp}{mm}(log(RemInterval_SWS{grp}{mm})<Lim(grp)))/sum(RemInterval_SWS{grp}{mm});
    end
end
figure
MakeSpreadAndBoxPlot2_SB(A,{},[1:3],GroupNames,'paired',0)
ylabel('Prop sequential NREM')
makepretty
clear h p stat
[h(1),p(1),stat{1}] = ranksum(A{1},A{2});
[h(2),p(2),stat{2}] = ranksum(A{1},A{3});
[h(3),p(3),stat{3}] = ranksum(A{2},A{3});
save('statsPropSeqNREM.mat','h','p','stat')



