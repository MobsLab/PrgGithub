

clear all
% GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
Group=1;

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            try
                RA.(Drug_Group{group}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'risk_assessment');
                RA_grade.(Drug_Group{group}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'ra_grade');
            catch
                RA_grade.(Drug_Group{group}).(Mouse_names{mouse}) = NaN;
            end
            RA_number.(Drug_Group{group})(mouse) = sum(RA_grade.(Drug_Group{group}).(Mouse_names{mouse}));
            
            LinearDist.(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(CondSess.(Mouse_names{mouse}) , 'linearposition');
            LinearDist_WhenRA.(Mouse_names{mouse}) = Restrict(LinearDist.(Mouse_names{mouse}) , RA.(Drug_Group{group}).(Mouse_names{mouse}));
        end
        disp(Mouse_names{mouse})
    end
    RA_number_All{group} = RA_number.(Drug_Group{group});
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            h=histogram(Data(LinearDist_WhenRA.(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
            RA{n}(mouse,:) = h.Values;
        end
    end
    n=n+1;
end

save('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat','RA','-append')


% for correlations
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat','FreezingTime','FreezingProportion')

clear RA_tot Freezing_Tot FreezingProportionShock_Tot FreezingProportionSafe_Tot 
RA_tot=[]; Freezing_Tot=[]; FreezingProportionShock_Tot=[]; FreezingProportionSafe_Tot=[];
for group=1:6
    RA_tot = [RA_tot ; RA_number_All{group}'];
    Freezing_Tot = [Freezing_Tot ; FreezingTime.Figure.All.Cond{group}];
    FreezingProportionShock_Tot = [FreezingProportionShock_Tot ; FreezingProportion.Figure.Shock.Cond{group}];
    FreezingProportionSafe_Tot = [FreezingProportionSafe_Tot ; FreezingProportion.Figure.Safe.Cond{group}];
end

%% Figures
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
X = [1:6];
Legends = {'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short'};
NoLegends = {'','','',''};

figure
MakeSpreadAndBoxPlot2_SB(RA_number_All,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('RA grade (a.u.)')
title('RA for drugs groups, UMaze')


Cols1 = {'-b','-r','-m','-g','-b','-r','-m','-g'};

figure
subplot(121)
for group=1:4
    Data_to_use = HistData{group};
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,Cols1{group},1); hold on;
end
makepretty
xlabel('linear distance (a.u.'), ylabel('RA score (a.u.)')
f=get(gca,'Children'); legend([f(13),f(9),f(5),f(1)],'Saline','Chronic Flx','Acute Flx','Midazolam');
title('Localisation of RA, Cond sessions')

subplot(122)
Data_to_use = HistData{5};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-c',1); hold on;
Data_to_use = HistData{6};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,25) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
h.mainLine.Color=[0.85, 0.325, 0.1]; h.patch.FaceColor=[0.85, 0.325, 0.1]; h.edge(1).Color=[0.85, 0.325, 0.1]; h.edge(2).Color=[0.85, 0.325, 0.1];
makepretty
xlabel('linear distance (a.u.'),
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');
title('Localisation of jumps, Cond sessions')

a=suptitle('RA localisation, UMaze, drugs'); a.FontSize=20;


% Correlations
clear A; A=RA_tot; A(A==0)=NaN; A(A>80)=NaN;

figure
PlotCorrelations_BM(log10(Freezing_Tot) , A);
axis square
xlabel('freezing time (log scale)'), ylabel('RA (a.u.)')


figure
subplot(121)
PlotCorrelations_BM(FreezingProportionShock_Tot , A);
axis square
xlabel('shock freezing proportion'), ylabel('jumps density (#/min active)')

subplot(122)
PlotCorrelations_BM(FreezingProportionSafe_Tot , A);
axis square
xlabel('safe freezing proportion'), ylabel('jumps density (#/min active)')


%%

% Déjà affiner la quantif de la fréq de RA : il faudrait normaliser par rapport au temps en mouvement 
% ou au nombre de traversées du Umaze ou encore nombre de RA / nombre d'entrées directes en SZ. 
% Sinon des souris qui bougent peu sont pénalisées

% - regarder où se passe le RA aussi (si c'est plus ou mois proche du choc zone) --> assez facile et 
%  potentiellement très instructif sur où la souris met la limite choc/sace
% - regarder quand se passe le RA : plutôt au début ou à la fin des sessions : ça s'inscrit dans 
% le projet plus global de l'évolution du comportement pdt la tâche 



for mouse=1:length(Mouse)
    for sess=2:length(Session_type)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        end
        
        Speed.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
        Zone_Epoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        Linear_Position.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');

        disp(Mouse_names{mouse})
        
    end
end

for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        end
        
        ShockZoneEntries.(Mouse_names{mouse}) = length(Start(Zone_Epoch.(Mouse_names{mouse}){1}));
        ShockZoneEntries_All(mouse) = ShockZoneEntries.(Mouse_names{mouse});
        MovingEpoch.(Mouse_names{mouse})=thresholdIntervals(Speed.(Mouse_names{mouse}),3);
        MovingEpoch.(Mouse_names{mouse})=mergeCloseIntervals(MovingEpoch.(Mouse_names{mouse}),0.3*1E4);
        MovingEpoch.(Mouse_names{mouse})=dropShortIntervals(MovingEpoch.(Mouse_names{mouse}),0.5*1E4);
        Speed_Moving.(Mouse_names{mouse}) = Restrict(Speed.(Mouse_names{mouse}) , MovingEpoch.(Mouse_names{mouse}));
        Ratio_Moving_Not.(Mouse_names{mouse}) = sum(Stop(MovingEpoch.(Mouse_names{mouse}))-Start(MovingEpoch.(Mouse_names{mouse})))/max(Range(Speed.(Mouse_names{mouse})));

    end
end

figure
plot(ShockZoneEntries_All.Fear); hold on
plot(ShockZoneEntries_All.Fear,'.r','MarkerSize',20);
xticks([1:52]); xticklabels(Mouse_names); xtickangle(45)

for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095'};
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
    elseif group==5 % diazepam mice
        Mouse_names={'M11147','M11184','M11189','M11200','M11204','M11205','M11206','M11207'};
    elseif group==6 % new saline mice
        Mouse_names={'M1144','M1146','M1147','M1170','M1171','M1172','M1174','M1184','M1189','M1200','M1204','M1205','M1206'};
    elseif group==7 % diazepam mice
        Mouse_names={'M11147','M11184','M11189','M11200','M11204','M11205','M11206'};
    elseif group==8 % new saline mice
        Mouse_names={'M1147','M1184','M1189','M1200','M1204','M1205','M1206'};
    end
    
    for mouse=1:length(Mouse_names)
        for sess=1:length(Session_type)
            
            ShockZoneEntries.(Drug_Group{group})(mouse) = ShockZoneEntries.(Mouse_names{mouse});
            AllTime.(Drug_Group{group})(mouse) = max(Range(Speed.(Mouse_names{mouse}),'s'));
            Ratio_Moving_Not.(Drug_Group{group})(mouse) = Ratio_Moving_Not.(Mouse_names{mouse});
            
        end
    end
    
    for sess=1:length(Session_type)
        ShockZoneEntries_TimeNorm.(Drug_Group{group}) = (ShockZoneEntries.(Drug_Group{group})./AllTime.(Drug_Group{group}))*60;
        RA_SZentries_norm.(Drug_Group{group}) = RA.(Drug_Group{group})./ShockZoneEntries_TimeNorm.(Drug_Group{group});
        RA_Speed_norm.(Drug_Group{group}) = RA.(Drug_Group{group})./Ratio_Moving_Not.(Drug_Group{group});
    end
end

% SZ entries

figure
for sess=1:length(Session_type)
    
    subplot(2,3,sess)
    MakeSpreadAndBoxPlot2_SB({ShockZoneEntries_TimeNorm.Saline , ShockZoneEntries_TimeNorm.ChronicFlx , ShockZoneEntries_TimeNorm.AcuteFlx, ShockZoneEntries_TimeNorm.Midazolam, ShockZoneEntries_TimeNorm.Diazepam, ShockZoneEntries_TimeNorm.NewSaline},Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    title(Session_type{sess});
    ylim([-0.1 6]); 
    if sess==1; ylabel('Shock zone entries/min'); end
    
end


for sess=1:length(Session_type)
    
    subplot(2,3,sess+3)
    MakeSpreadAndBoxPlot2_SB({RA_SZentries_norm.Saline , RA_SZentries_norm.ChronicFlx , RA_SZentries_norm.AcuteFlx, RA_SZentries_norm.Midazolam, RA_SZentries_norm.Diazepam, RA_SZentries_norm.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
    title(Session_type{sess});
    ylim([-2 85])
    if sess==1; ylabel('RA normalized by SZ entries'); end
    
end


% Speed

figure
for sess=1:length(Session_type)
    
    subplot(2,3,sess)
    MakeSpreadAndBoxPlot2_SB({Ratio_Moving_Not.Saline , Ratio_Moving_Not.ChronicFlx , Ratio_Moving_Not.AcuteFlx, Ratio_Moving_Not.Midazolam, Ratio_Moving_Not.Diazepam, Ratio_Moving_Not.NewSaline},Cols,X,NoLegends_Drugs,'showpoints',1,'paired',0);
    title(Session_type{sess});
    ylim([-0.1 0.7]); 
    if sess==1; ylabel('Proportion of time spent moving (%)'); end
    
end

for sess=1:length(Session_type)
    
    subplot(2,3,sess+3)
    MakeSpreadAndBoxPlot2_SB({RA_Speed_norm.Saline , RA_Speed_norm.ChronicFlx , RA_Speed_norm.AcuteFlx, RA_Speed_norm.Midazolam, RA_Speed_norm.Diazepam, RA_Speed_norm.NewSaline},Cols,X,Legends_Drugs,'showpoints',1,'paired',0);
    title(Session_type{sess});
    ylim([-2 250])
    if sess==1; ylabel('RA normalized by time spent moving'); end

end



%% ??
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        EscapeLatency.Shock.Cond.(Mouse_names{mouse}) = nanmean(EscapeLatency.CondShock.(Mouse_names{mouse}));
        EscapeLatency.Safe.Cond.(Mouse_names{mouse}) = nanmean(EscapeLatency.CondSafe.(Mouse_names{mouse}));
        EscapeLatency.Shock.Ext.(Mouse_names{mouse}) = nanmean(EscapeLatency.ExtShock.(Mouse_names{mouse}));
        EscapeLatency.Safe.Ext.(Mouse_names{mouse}) = nanmean(EscapeLatency.ExtSafe.(Mouse_names{mouse}));
        
    end
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    RA_All_Cond(mouse) = RA.Cond.(Mouse_names{mouse});
    FreezingProportion_Cond(mouse) = FreezingProportion.All.Cond.(Mouse_names{mouse});
    FreezingProportionRatio_Cond(mouse) = FreezingProportion.Ratio.Cond.(Mouse_names{mouse});
    FreezingProportionShock_Cond(mouse) = FreezingProportion.Shock.Cond.(Mouse_names{mouse});
    FreezingProportionSafe_Cond(mouse) = FreezingProportion.Safe.Cond.(Mouse_names{mouse});
    DistanceTraveled_Cond(mouse) = TSD_DATA.Cond.speed.mean(mouse,1)*Total_Time.Cond.(Mouse_names{mouse});
    
end


subplot(221)
PlotCorrelations_BM(RA_All_Cond , FreezingProportion_Cond)
ylabel('proportion')
xlim([0 8]); ylim([0 .4]);
title('Freezing = f(RA density)')
subplot(222)
PlotCorrelations_BM(RA_All_Cond , FreezingProportionRatio_Cond)
title('Ratio shock/safe = f(RA density)')
subplot(223)
PlotCorrelations_BM(RA_All_Cond , FreezingProportionShock_Cond)
ylabel('proportion'); xlabel('RA/min')
xlim([0 8]); ylim([0 .6]);
title('Shock freezing = f(RA density)')
subplot(224)
PlotCorrelations_BM(RA_All_Cond , FreezingProportionSafe_Cond)
xlabel('RA/min'); xlim([0 8]); ylim([0 .6]);
title('Safe freezing = f(RA density)')

a=suptitle('Freezing correlations with RA'); a.FontSize=20;


figure
subplot(221)
PlotCorrelations_BM(RA_All_Cond./DistanceTraveled_Cond , FreezingProportion_Cond)
ylabel('proportion')
xlim([0 .05]); ylim([0 .4]);
title('Freezing = f(RA density)')
subplot(222)
PlotCorrelations_BM(RA_All_Cond./DistanceTraveled_Cond , FreezingProportionRatio_Cond)
title('Ratio shock/safe = f(RA density)')
subplot(223)
PlotCorrelations_BM(RA_All_Cond./DistanceTraveled_Cond , FreezingProportionShock_Cond)
ylabel('proportion'); xlabel('RA/min')
xlim([0 .05]); ylim([0 .6]);
title('Shock freezing = f(RA density)')
subplot(224)
PlotCorrelations_BM(RA_All_Cond./DistanceTraveled_Cond , FreezingProportionSafe_Cond)
xlabel('RA/min')
xlim([0 .05]); ylim([0 .6]);
title('Safe freezing = f(RA density)')

a=suptitle('Freezing correlations with RA, distance traveled normalisation'); a.FontSize=20;


