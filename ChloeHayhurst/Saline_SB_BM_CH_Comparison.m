%% Comparison of saline long protocol for SB BM and CH
% after Atropine_UMaze_prelim

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock Pre','Safe Pre','Shock Post','Safe Post'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({TimeShockZone.Saline_SB.TestPre, TimeSafeZone.Saline_SB.TestPre, TimeShockZone.Saline_SB.TestPost, TimeSafeZone.Saline_SB.TestPost},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 7e6])
title('Saline SB')
subplot(132)
MakeSpreadAndBoxPlot3_SB({TimeShockZone.Saline_BM.TestPre, TimeSafeZone.Saline_BM.TestPre, TimeShockZone.Saline_BM.TestPost, TimeSafeZone.Saline_BM.TestPost},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 7e6])
title('Saline BM')
subplot(133)
MakeSpreadAndBoxPlot3_SB({TimeShockZone.Saline_All_CH.TestPre, TimeSafeZone.Saline_All_CH.TestPre, TimeShockZone.Saline_All_CH.TestPost, TimeSafeZone.Saline_All_CH.TestPost},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 7e6])
title('Saline CH')
mtitle('Time spent in zones Test Pre/Post')
% saveFigure_BM(1,'Time_TestPre-Post','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Saline_SB.TestPre, SafeZoneEntries.Saline_SB.TestPre, ShockZoneEntries.Saline_SB.TestPost, SafeZoneEntries.Saline_SB.TestPost},Cols,X,Legends,'showpoints',0,'paired',1);
title('Saline SB')
ylim([0 45])
subplot(132)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Saline_BM.TestPre, SafeZoneEntries.Saline_BM.TestPre, ShockZoneEntries.Saline_BM.TestPost, SafeZoneEntries.Saline_BM.TestPost},Cols,X,Legends,'showpoints',0,'paired',1);
title('Saline BM')
ylim([0 45])
subplot(133)
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Saline_All_CH.TestPre, SafeZoneEntries.Saline_All_CH.TestPre, ShockZoneEntries.Saline_All_CH.TestPost, SafeZoneEntries.Saline_All_CH.TestPost},Cols,X,Legends,'showpoints',0,'paired',1,'ShowSigStar','all');
title('Saline')
ylim([0 45])
mtitle('Number of entries Test Pre/Post')
saveFigure_BM(1,'Entries_TestPre-Post','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


%% Freezing

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock Sal SB','Safe Sal SB','Shock Sal BM','Safe Sal BM','Shock Sal CH','Safe Sal CH'};
Session_type={'Cond','Ext'};


figure
for sess=1:2
subplot(1,2,sess)
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({FreezeTime_Shock.Saline_SB.(Session_type{sess}) FreezeTime_Safe.Saline_SB.(Session_type{sess}) FreezeTime_Shock.Saline_BM.(Session_type{sess}) FreezeTime_Safe.Saline_BM.(Session_type{sess}) FreezeTime_Shock.Saline_All_CH.(Session_type{sess}) FreezeTime_Safe.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Session_type{sess}))
ylim([0 2200])
end
mtitle('Freezing duration')
% saveFigure_BM(3,'Fz_Sh-Sf','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


figure
for sess=1:2
subplot(1,2,sess)
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({Freeze_Shock_Prop.Saline_SB.(Session_type{sess}) Freeze_Safe_Prop.Saline_SB.(Session_type{sess}) Freeze_Shock_Prop.Saline_BM.(Session_type{sess}) Freeze_Safe_Prop.Saline_BM.(Session_type{sess}) Freeze_Shock_Prop.Saline_All_CH.(Session_type{sess}) Freeze_Safe_Prop.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Session_type{sess}))
ylim([0 0.4])
end
mtitle('Freezing proportion')
% saveFigure_BM(4,'Fz_Prop_Sh-Sf','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


% Cols={[0 0 0.6],[0 0.6 0.6],[0 1 0.6]};
Cols={[1 0 0],[1 0.4 0],[1 0.8 0]};
X=[1:3];
Legends={'Saline SB','Saline BM','Saline CH'};
Session_type={'TestPre','TestPost','Cond','Ext'};

figure
for sess=1:4
subplot(1,4,sess)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Saline_SB.(Session_type{sess}) FreezeTime.Saline_BM.(Session_type{sess}) FreezeTime.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Session_type{sess}))
ylim([0 2500])
end
mtitle('Total freezing duration')
% saveFigure_BM(5,'Fz_tot','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')

Cols={[1 0 0],[1 0.4 0],[1 0.8 0]};
X=[1:3];
Legends={'Saline SB','Saline BM','Saline CH'};
Session_type={'TestPre','TestPost','Cond','Ext'};

figure
for sess=1:4
subplot(1,4,sess)
[pval , stats_out]  = MakeSpreadAndBoxPlot3_SB({Freeze_Prop.Saline_SB.(Session_type{sess}) Freeze_Prop.Saline_BM.(Session_type{sess}) Freeze_Prop.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Session_type{sess}))
ylim([0 0.5])
end
mtitle('Total freezing proportion')
% saveFigure_BM(2,'Fz_tot_prop','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


%% Thigmotaxis

Cols={[0 0 0.6],[0 0.6 0.6],[0 1 0.6]};
Cols={[1 0 0],[1 0.4 0],[1 0.8 0]};
X=[1:3];
Legends={'Saline SB','Saline BM','Saline CH'};
Session_type={'TestPre','TestPost','Cond','Ext'};

Group_bis = [1 21 20]
 
figure
for sess=1:4
subplot(1,4,sess)
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({Thigmo_Active.Saline_SB.(Session_type{sess}) Thigmo_Active.Saline_BM.(Session_type{sess}) Thigmo_Active.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Session_type{sess}))
ylim([0.3 1])
end
mtitle('Active thigmotaxis score')
% saveFigure_BM(5,'Active_thigmo_Sessions','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


figure
i = 1
X=[1:4];
Legends={'Test Pre', 'Test Post', 'Cond', 'Ext'};
for group = Group_bis
    if i == 1
      Cols={[1 0 0],[1 0 0],[1 0 0],[1 0 0]};
    end
    if i == 2
      Cols={[1 0.4 0],[1 0.4 0],[1 0.4 0],[1 0.4 0]};
    end
    if i == 3
      Cols={[1 0.8 0],[1 0.8 0],[1 0.8 0],[1 0.8 0]};
    end
subplot(1,3,i)
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({Thigmo_Active.(Name{group}).TestPre Thigmo_Active.(Name{group}).TestPost Thigmo_Active.(Name{group}).Cond Thigmo_Active.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
title(sprintf(Name{group}))
ylim([0.3 1])
i = i+1;
end
mtitle('Active thigmotaxis score')
% saveFigure_BM(6,'Active_thigmo_Groups','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')

% 
% figure
% for sess=1:4
% subplot(1,4,sess)
% MakeSpreadAndBoxPlot3_SB({Thigmo_Freezing.Saline_SB.(Session_type{sess}) Thigmo_Freezing.Saline_BM.(Session_type{sess}) Thigmo_Freezing.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
% title(sprintf(Session_type{sess}))
% ylim([-0.1 1.1])
% end
% mtitle('Freezing thigmotaxis score')

%% Respi

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock CondPre','Safe CondPre','Shock CondPost','Safe CondPost','Shock Ext','Safe Ext'};
Session_type={'TestPre','TestPost','Cond','Ext'};
Group_bis = [1 21 20]

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
   [pval , stats_out] =  MakeSpreadAndBoxPlot3_SB({Respi_Fz_Shock_mean.(Name{group}).CondPre Respi_Fz_Safe_mean.(Name{group}).CondPre Respi_Fz_Shock_mean.(Name{group}).CondPost Respi_Fz_Safe_mean.(Name{group}).CondPost Respi_Fz_Shock_mean.(Name{group}).Ext Respi_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
    ylim([1 7])
end
mtitle('Breathing Frequency')
% saveFigure_BM(5,'OB_freq','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock Cond','Safe Cond','Shock Ext','Safe Ext'};
Group_bis = [1 21 20]

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
   [pval , stats_out] =  MakeSpreadAndBoxPlot3_SB({Respi_Fz_Shock_mean.(Name{group}).Cond Respi_Fz_Safe_mean.(Name{group}).Cond Respi_Fz_Shock_mean.(Name{group}).Ext Respi_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
    ylim([1 7])
end
mtitle('Breathing Frequency')


Cols={[1 .5 .5],[1 .5 .5],[1 .5 .5],[.5 .5 1],[.5 .5 1],[.5 .5 1]};
X=[1:6];
Legends={'Shock SB','Shock BM','Shock CH','Safe SB','Safe BM','Safe CH'};
Group_bis = [1 21 20]
Session_type={'CondPre','CondPost','Ext'};

figure
for sess = 1:3
    subplot(1,3,sess)
   MakeSpreadAndBoxPlot3_SB({Respi_Fz_Shock_mean.Saline_SB.(Session_type{sess}) Respi_Fz_Shock_mean.Saline_BM.(Session_type{sess}) Respi_Fz_Shock_mean.Saline_All_CH.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_SB.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_BM.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf(Session_type{sess}))
    ylim([1 7])
end
mtitle('Breathing Frequency')


Cols={[1 .5 .5],[1 .5 .5],[1 .5 .5],[.5 .5 1],[.5 .5 1],[.5 .5 1]};
X=[1:6];
Legends={'Shock SB','Shock BM','Shock CH','Safe SB','Safe BM','Safe CH'};
Group_bis = [1 21 20]
Session_type={'Cond','Ext'};

figure
for sess = 1:2
    subplot(1,2,sess)
   MakeSpreadAndBoxPlot3_SB({Respi_Fz_Shock_mean.Saline_SB.(Session_type{sess}) Respi_Fz_Shock_mean.Saline_BM.(Session_type{sess}) Respi_Fz_Shock_mean.Saline_All_CH.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_SB.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_BM.(Session_type{sess}) Respi_Fz_Safe_mean.Saline_All_CH.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf(Session_type{sess}))
    ylim([1 7])
end
mtitle('Breathing Frequency')


%% Ripples

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock Cond','Safe Cond','Shock Ext','Safe Ext'};
Group_bis = [1 21 20]

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
    [pval , stats_out] = MakeSpreadAndBoxPlot3_SB({Ripples_Fz_Shock_density.(Name{group}).Cond Ripples_Fz_Safe_density.(Name{group}).Cond Ripples_Fz_Shock_density.(Name{group}).Ext Ripples_Fz_Safe_density.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
    ylim([0 1.3])
end
mtitle('Ripples / second')
% saveFigure_BM(17,'Rip_Cond-Ext','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')



Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock CondPre','Safe CondPre','Shock CondPost','Safe CondPost','Shock Ext','Safe Ext'};
Group_bis = [1 21 20]

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
    MakeSpreadAndBoxPlot3_SB({Ripples_Fz_Shock_density.(Name{group}).CondPre Ripples_Fz_Safe_density.(Name{group}).CondPre Ripples_Fz_Shock_density.(Name{group}).CondPost Ripples_Fz_Safe_density.(Name{group}).CondPost Ripples_Fz_Shock_density.(Name{group}).Ext Ripples_Fz_Safe_density.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
%     ylim([0 1.3])
end
mtitle('Ripples / second')
% saveFigure_BM(7,'Rip_Sh-Sf','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')


%% Heart Rate
% 
% Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
% X=[1:6];
% Legends={'Shock CondPre','Safe CondPre','Shock CondPost','Safe CondPost','Shock Ext','Safe Ext'};
% 
% figure
% i = 1;
% for group = Group_bis
%     subplot(1,3,i)
%     MakeSpreadAndBoxPlot3_SB({HR_Fz_Shock_mean.(Name{group}).CondPre HR_Fz_Safe_mean.(Name{group}).CondPre HR_Fz_Shock_mean.(Name{group}).CondPost HR_Fz_Safe_mean.(Name{group}).CondPost HR_Fz_Shock_mean.(Name{group}).Ext HR_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
%     title(sprintf((Name{group})))
%     i = i +1 ;
% end
% mtitle('HR')

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock Cond','Safe Cond','Shock Ext','Safe Ext'};

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
    MakeSpreadAndBoxPlot3_SB({HR_Fz_Shock_mean.(Name{group}).Cond HR_Fz_Safe_mean.(Name{group}).Cond HR_Fz_Shock_mean.(Name{group}).Ext HR_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',0,'paired',1);
    title(sprintf((Name{group})))
    i = i +1 ;
    ylim([8.5 13])
end
mtitle('HR')
% saveFigure_BM(7,'HR','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/Comparison_SB_BM_CH/')

%% Heart Rate Var

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock CondPre','Safe CondPre','Shock CondPost','Safe CondPost','Shock Ext','Safe Ext'};

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
    MakeSpreadAndBoxPlot3_SB({HR_Var_Fz_Shock_mean.(Name{group}).CondPre HR_Var_Fz_Safe_mean.(Name{group}).CondPre HR_Var_Fz_Shock_mean.(Name{group}).CondPost HR_Var_Fz_Safe_mean.(Name{group}).CondPost HR_Var_Fz_Shock_mean.(Name{group}).Ext HR_Var_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
    ylim([0 0.4])
end
mtitle('HR Var')


Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock Cond','Safe Cond','Shock Ext','Safe Ext'};

figure
i = 1;
for group = Group_bis
    subplot(1,3,i)
    MakeSpreadAndBoxPlot3_SB({HR_Var_Fz_Shock_mean.(Name{group}).Cond HR_Var_Fz_Safe_mean.(Name{group}).Cond HR_Var_Fz_Shock_mean.(Name{group}).Ext HR_Var_Fz_Safe_mean.(Name{group}).Ext},Cols,X,Legends,'showpoints',1,'paired',0);
    title(sprintf((Name{group})))
    i = i +1 ;
end
mtitle('HR Var')
