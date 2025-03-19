
%% Fear analysis

GetEmbReactMiceFolderList_BM
Voltage_UMaze_Drugs_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
Side_ind=[3 5 6];
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'speed','ripples');
end

Create_Behav_Drugs_BM

GetEmbReactMiceFolderList_BM
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
%         if and(Mouse_names{mouse}=='M739', or(sess==1, or(sess==2,sess==4))); for i=1:8; TSD_DATA.(Session_type{sess}).speed.tsd{mouse,i}=tsd(NaN,NaN); end; end
        % Speed
        Speed.Shock.(Session_type{sess}).(Mouse_names{mouse}) = nanmean([Data(TSD_DATA.(Session_type{sess}).speed.tsd{mouse,5}) ; Data(TSD_DATA.(Session_type{sess}).speed.tsd{mouse,7})]);
        Speed.Safe.(Session_type{sess}).(Mouse_names{mouse}) = nanmean([Data(TSD_DATA.(Session_type{sess}).speed.tsd{mouse,6}) ; Data(TSD_DATA.(Session_type{sess}).speed.tsd{mouse,8})]);
        % Ripples
        if  TSD_DATA.(Session_type{sess}).ripples.mean(mouse,5)==0
            Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse}) = NaN;
        else
            Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,5);
        end
        if  TSD_DATA.(Session_type{sess}).ripples.mean(mouse,6)==0
            Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse}) = NaN;
        else
            Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,6);
        end
        % 
    end
    disp(Mouse_names{mouse})
end

for group=1:length(Drug_Group)
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Speed.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Speed.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Speed.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Speed.Safe.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse});
            Ripples.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        Speed.Shock.Figure.(Session_type{sess}){group} = Speed.Shock.(Drug_Group{group}).(Session_type{sess});
        Speed.Safe.Figure.(Session_type{sess}){group} = Speed.Safe.(Drug_Group{group}).(Session_type{sess});
        Ripples.FigureShock.(Session_type{sess}){group} = Ripples.Shock.(Drug_Group{group}).(Session_type{sess});
        Ripples.FigureSafe.(Session_type{sess}){group} = Ripples.Safe.(Drug_Group{group}).(Session_type{sess});
    end
end

%% Figures
Cols1 = {[0, 0, 1],[1, 0, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
Legends_Drugs1 ={'SalineSB' 'Chronic Flx' 'Saline_Short','DZP_Short'};
NoLegends_Drugs1 ={'', '', '', '',''};
X1 = [1:4];

Cols2 = {[0, 0, 1],[1, 0.5, 0.5],[0, 0.5, 0],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs2 ={'SalineSB' 'Acute Flx' 'Midazolam','Saline_Long','DZP_Long'};
NoLegends_Drugs2 ={'', '', '', '',''};
X2 = [1:5];

Cols3 = {[0 1 0],[.7 .2 .2]};
Legends_Drugs3 ={'CondPre' 'CondPost'};
NoLegends_Drugs3 ={'', '', '', '',''};
X3 = [1:2];

%% Freezing analysis
%% Cond
% Freezing proportion & ratio shock/safe
figure; n=1;
for sess=[2 3]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureAll.(Session_type{sess})([1 2 5 6]),Cols1,X1,NoLegends_Drugs1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.5])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureShock.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); 
    if sess==2; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;

% Shock & safe freezing proportion
figure; n=1;
for sess=[2 3]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Shock.(Session_type{sess})([1 2 5 6]),Cols1,X1,NoLegends_Drugs1,'showpoints',1,'paired',0);
    if sess==2; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 .6])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Safe.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0);
    if sess==2; ylabel('Safe freezing proportion'); end
    ylim([-0.01 .5])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


figure
MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Shock.Cond([1 2]),{[0, 0, 1],[1, 0, 0]},[1 2],{'SalineSB','Chronic Flx'},'showpoints',1,'paired',0); 
ylabel('Proportion')

%% CondPre/CondPost
% Freezing proportion & ratio shock/safe
figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureAll.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.5])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingProp.FigureShock.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;

figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Shock.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
    if sess==4; ylabel('Shock freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 .8])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingPercentage.Figure.Safe.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
    if sess==4; ylabel('Safe freezing proportion'); end
    ylim([-0.01 .5])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


%% Occupancy
%% Cond
figure
sess=2;
subplot(141)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); ylabel('proportion')
ylim([-0.01 0.45])

subplot(142)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')

subplot(143)
MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Extra stim'); ylabel('#/min')

subplot(144)
MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('SZ entries / extra-stim'); ylabel('entries/shock')

a=suptitle('Conditionning sessions analysis, UMaze drugs experiments'); a.FontSize=20;

% Mean time in zones
figure; n=1;
for sess=[6 2 7 3]
    subplot(2,5,n)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([1 2 5 6]),Cols1,X1,NoLegends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in shock zone (s)'); end
    title(Session_type{sess})
    ylim([-0.01 20])
    
    subplot(2,5,n+5)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([1 2 5 6]),Cols1,X1,Legends_Drugs1,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in safe zone (s)'); end
    ylim([-0.01 60])
    
    n=n+1;
end
a=suptitle('Mean time in zone when unblocked'); a.FontSize=20;


%% CondPre & CondPost analysis
figure; sess=4;
subplot(241)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); ylabel('proportion')
ylim([-0.01 0.45])
u=text(-2.5,.15,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(242)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')

subplot(243)
MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Extra stim'); ylabel('#/min')

subplot(244)
MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('SZ entries / extra-stim'); ylabel('entries/shock')

sess=5;
subplot(245)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('proportion')
ylim([-0.01 0.45])
u=text(-2.5,.15,Session_type{sess}); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(246)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('#/min')

subplot(247)
MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('#/min')

subplot(248)
MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('entries/shock')

a=suptitle('Conditionning sessions analysis, UMaze drugs experiments'); a.FontSize=20;


% Mean time in zones
figure; n=1;
for sess=[6 4 5 7 3]
    subplot(2,5,n)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in shock zone (s)'); end
    title(Session_type{sess})
    ylim([-0.01 20])
    
    subplot(2,5,n+5)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})([1 3 4 7 8]),Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0); makepretty; xtickangle(45);
    if sess==6; ylabel('Mean time in safe zone (s)'); end
    ylim([-0.01 60])
    
    n=n+1;
end
a=suptitle('Mean time in zone when unblocked'); a.FontSize=20;


%% CondPre & CondPost but paired
figure
for group=1:8
    subplot(4,8,group)
    MakeSpreadAndBoxPlot2_SB([ZoneOccupancy.FigureShock.CondPre{group} ZoneOccupancy.FigureShock.CondPost{group}],Cols3,X3,NoLegends_Drugs3,'showpoints',0,'paired',1);
    title(Drug_Group{group});
    ylim([-0.01 0.36]); hline(.3501,'--r')
    if group==1; ylabel('Shock zone occupancy'); end
    
    subplot(4,8,group+8)
    MakeSpreadAndBoxPlot2_SB([ShockZoneEntries.Figure.CondPre{group} ShockZoneEntries.Figure.CondPost{group}],Cols3,X3,NoLegends_Drugs3,'showpoints',0,'paired',1);
    ylim([-0.01 6]); hline(2.1365,'--r')
    if group==1; ylabel('Shock zone entries'); end
    
    subplot(4,8,group+16)
    MakeSpreadAndBoxPlot2_SB([ExtraStim.Figure.CondPre{group} ExtraStim.Figure.CondPost{group}],Cols3,X3,NoLegends_Drugs3,'showpoints',0,'paired',1);
    ylim([-0.01 1.5]);
    if group==1; ylabel('extra-stim'); end
    
    subplot(4,8,group+24)
    MakeSpreadAndBoxPlot2_SB([Stim_By_SZ_entries.CondPre{group} Stim_By_SZ_entries.CondPost{group}],Cols3,X3,NoLegends_Drugs3,'showpoints',0,'paired',1);
    ylim([-1 100]);
    if group==1; ylabel('entries/shock'); end
end
a=suptitle('Behaviour, conditionning sessions analysis, UMaze drugs experiments'); a.FontSize=20;


%% Test Post analysis
figure
sess=7;
subplot(131)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); 
ylim([-0.01 0.36])
hline(.3501,'--r')

subplot(132)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')
hline(2.1365,'--r')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Latency_SZ.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone latency'); ylabel('time (s)')
hline(15.7,'--r')

a=suptitle('Test Post analysis, UMaze drugs experiments'); a.FontSize=20;

% Test Pre figures
figure
sess=6;
subplot(131)
MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.FigureShock.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone occupancy'); 
%ylim([-0.01 0.35])
hline(.3501,'--r')

subplot(132)
MakeSpreadAndBoxPlot2_SB(ShockZoneEntries.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone entries'); ylabel('#/min')
hline(2.1365,'--r')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Latency_SZ.Figure.(Session_type{sess}),Cols,X,Legends_Drugs,'showpoints',1,'paired',0); makepretty; xtickangle(45);
title('Shock zone latency'); ylabel('time (s)')
hline(15.7,'--r')

a=suptitle('Test Pre analysis, UMaze drugs experiments'); a.FontSize=20;

%% Correlations

Behaviour_Behaviour_Correlations_BM

Neuro_And_Behaviour_Correlations_BM

%% Checking basic parameters

edit Active_Freezing_PhysiologicalValues_Drugs_BM.m

