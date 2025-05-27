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

DirSocialDefeat_totSleepPost_mCherry_cno1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_totSleepPost_mCherry_cno = MergePathForExperiment(DirSocialDefeat_totSleepPost_mCherry_cno1,DirSocialDefeat_totSleepPost_BM_cno1);

for mm = 1:length(DirSocialDefeat_totSleepPost_mCherry_cno.path)
    enregistrements{4}{mm} = DirSocialDefeat_totSleepPost_mCherry_cno.path{mm}{1};
end

for grp = 1:4
    for mm = 1:length(enregistrements{grp})
        cd(enregistrements{grp}{mm})
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch')
        
%         Epoch = intervalSet(0,2*3600*1e4);
        Epoch = intervalSet(5*3600*1e4,7.5*3600*1e4);
        Wake = and(Wake,Epoch);
        REMEpoch = and(REMEpoch,Epoch);
        SWSEpoch = and(SWSEpoch,Epoch);
        
        
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
subplot(131)
clear A
for gr = 1:4
A{gr} = cellfun(@nanmean,REMBeforeWakeDur{gr})/1e4;
end
MakeSpreadAndBoxPlot2_SB(A,{},[1:4],{'Ctrl','SDS','DREADD','SDSCNO'},'paired',0)
ylabel('REM episode length before wake (s)')
makepretty
clear h p stat
for gr = 1:4
    for gr2 = 1:4
        [p(gr,gr2),h(gr,gr2),stat_temp] = ranksum(A{gr},A{gr2});
        stat(gr,gr2) = stat_temp.ranksum;
    end
end
cd /home/pinky/Documents/Figure_PapierMathilde/REMDurations
save('Statistics_REMBeforeWakeDur.mat','h','p','stat')


subplot(132)
clear A
for gr = 1:4
A{gr} = cellfun(@nanmean,REMBeforeSWSDur{gr})/1e4;
end
MakeSpreadAndBoxPlot2_SB(A,{},[1:4],{'Ctrl','SDS','DREADD','SDSCNO'},'paired',0)
ylabel('REM episode duration before SWS (s)')
makepretty
clear h p stat
for gr = 1:4
    for gr2 = 1:4
        [p(gr,gr2),h(gr,gr2),stat_temp] = ranksum(A{gr},A{gr2});
        stat(gr,gr2) = stat_temp.ranksum;
    end
end
cd /home/pinky/Documents/Figure_PapierMathilde/REMDurations
save('Statistics_REMBeforeSWSDur.mat','h','p','stat')


subplot(133)
for gr = 1:4
A{gr} = cellfun(@length,REMBeforeWakeDur{gr})./(cellfun(@length,REMBeforeWakeDur{gr})+cellfun(@length,REMBeforeSWSDur{gr}));
end
MakeSpreadAndBoxPlot2_SB(A,{},[1:4],{'Ctrl','SDS','DREADD','SDSCNO'},'paired',0)
ylabel('Prop REM episode followed by wake')
makepretty
clear h p stat
for gr = 1:4
    for gr2 = 1:4
        [p(gr,gr2),h(gr,gr2),stat_temp] = ranksum(A{gr},A{gr2});
        stat(gr,gr2) = stat_temp.ranksum;
    end
end
cd /home/pinky/Documents/Figure_PapierMathilde/REMDurations
save('Statistics_PropRemtoWakeTrans.mat','h','p','stat')

% 
% figure
% subplot(131)
% clear A
% A{1} = cellfun(@nanmean,WakeAfterREMDur{1})/1e4;
% A{2} = cellfun(@nanmean,WakeAfterREMDur{2})/1e4;
% MakeSpreadAndBoxPlot2_SB(A,{},[1:2],{'Ctrl','SDS'},'paired',0)
% ylabel('Wake episode length after REM (s)')
% 
% subplot(132)
% clear A
% A{1} = cellfun(@nanmean,SWSAfterREMDur{1})/1e4;
% A{2} = cellfun(@nanmean,SWSAfterREMDur{2})/1e4;
% MakeSpreadAndBoxPlot2_SB(A,{},[1:2],{'Ctrl','SDS'},'paired',0)
% ylabel('SWS episode duration after REM (s)')
% 
% subplot(133)
% A{1} = cellfun(@length,REMBeforeWakeDur{1})./(cellfun(@length,REMBeforeWakeDur{1})+cellfun(@length,REMBeforeSWSDur{1}));
% A{2} = cellfun(@length,REMBeforeWakeDur{2})./(cellfun(@length,REMBeforeWakeDur{2})+cellfun(@length,REMBeforeSWSDur{2}));
% MakeSpreadAndBoxPlot2_SB(A,{},[1:2],{'Ctrl','SDS'},'paired',0)
% ylabel('Prop REM episode followed by wake')
% 
