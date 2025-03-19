clear all

load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat', 'Epoch1', 'Epoch_Unblocked')

GetEmbReactMiceFolderList_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends ={'', '', '', '','','','',''};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        
        EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = Epoch_Unblocked.(Session_type{sess}){mouse,1};
        
    end
end

Group=5:8;

% CAREFULL, here proportion of total time and not proportion of time spent in the zone
for sess=1:length(Session_type)
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            Zones.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
            TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            LinearPosition.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');
            OBSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
            LinearPosition_Freezing.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearPosition.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            for zones=1:5
                Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
                Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                OB_Freezing_in_Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} = Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}));
            end
            
            Proportion_Time_Spent_In_BiggerZones.(Session_type{sess}).(Mouse_names{mouse})(1) = (sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){1})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){1})) + sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){4})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){4})))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_In_BiggerZones.(Session_type{sess}).(Mouse_names{mouse})(2) = (sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){2})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){2})) + sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){5})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){5})))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_In_BiggerZones.(Session_type{sess}).(Mouse_names{mouse})(3) = sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){3})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){3}))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
            
            Proportion_Time_Spent_In_NonAnalyzedZones.(Session_type{sess}).(Mouse_names{mouse}) = Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(3) + Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(4);
            Proportion_Time_Spent_Freezing_In_NonAnalyzedZones.(Session_type{sess}).(Mouse_names{mouse}) = Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(3) + Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(4);
            Proportion_Time_Spent_Freezing_In_NonAnalyzedZones_ofFz.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){3} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){3} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))) + sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){4} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){4} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))))./sum(Stop(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            
            disp(Mouse_names{mouse})
        end
    end
end

for sess=1:length(Session_type)
    Proportion_Time_Spent_In_Zones.(Session_type{sess}).M1147=NaN;
    Proportion_Time_Spent_In_BiggerZones.(Session_type{sess}).M1147=NaN;
    Proportion_Time_Spent_In_NonAnalyzedZones.(Session_type{sess}).M1147=NaN;
    Proportion_Time_Spent_Freezing_In_NonAnalyzedZones.(Session_type{sess}).M1147=NaN;
end

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];

            Proportion_Time_Spent_In_Zones.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_Freezing_In_Zones.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse});
            Absolute_Time_Spent_Freezing_In_Zones.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_In_BiggerZones.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Proportion_Time_Spent_In_BiggerZones.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_In_NonAnalyzedZones.Figure.(Session_type{sess}){n}(mouse) = Proportion_Time_Spent_In_NonAnalyzedZones.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_Freezing_In_NonAnalyzedZones.Figure.(Session_type{sess}){n}(mouse) = Proportion_Time_Spent_Freezing_In_NonAnalyzedZones.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_Freezing_In_NonAnalyzedZones_ofFz.Figure.(Session_type{sess}){n}(mouse) = Proportion_Time_Spent_Freezing_In_NonAnalyzedZones_ofFz.(Session_type{sess}).(Mouse_names{mouse});
            for zones=1:5
                OB_Freezing_in_Zones.(Drug_Group{group}).(Session_type{sess}){mouse,zones} = OB_Freezing_in_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones);
                if length(nanmean(Data(OB_Freezing_in_Zones.(Drug_Group{group}).(Session_type{sess}){mouse,zones}{1}))==1)
                    OB_FreezingMean_in_Zones.(Drug_Group{group}).(Session_type{sess})(mouse,zones,:) = NaN(1,261);
                else
                    OB_FreezingMean_in_Zones.(Drug_Group{group}).(Session_type{sess})(mouse,zones,:) = nanmean(Data(OB_Freezing_in_Zones.(Drug_Group{group}).(Session_type{sess}){mouse,zones}{1}));
                end
            end
            
        end
    end
    n=n+1;
end


for sess=1:length(Session_type)
    for zones=1:5
        n=1;
        for group=Group
%             try
                Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}{n} = Proportion_Time_Spent_In_Zones.(Drug_Group{group}).(Session_type{sess})(:,zones);
                Absolute_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}{n} = Absolute_Time_Spent_Freezing_In_Zones.(Drug_Group{group}).(Session_type{sess})(:,zones);
                Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}{n} = Proportion_Time_Spent_Freezing_In_Zones.(Drug_Group{group}).(Session_type{sess})(:,zones);
                try
                    Proportion_Time_Spent_In_BiggerZones.Figure.(Session_type{sess}){zones}{n} = Proportion_Time_Spent_In_BiggerZones.(Drug_Group{group}).(Session_type{sess})(:,zones);
                end
%             end
            n=n+1;
        end
    end
end


%% figures
% Time spent
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

ind=[1:4];
ind=[5:8];

% Porportion time CondPre/COnd
figure
for zones=1:5
    n=1;
    for sess=[6 4 5 7]
        
        subplot(5,4,n+(zones-1)*4)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==6; ylabel(['Zones ' num2str(zones)]); end 
        n=n+1;
        ylim([0 1])
   
    end
end
a=suptitle('Zones occupancy during Maze, drugs'); a.FontSize=20;

% Only for Cond
figure;
for zones=1:5
    n=1;
    for sess=[6 2 7]
        
        subplot(5,3,n+(zones-1)*3)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==6; ylabel(['Zones ' num2str(zones)]); end
        n=n+1;
        
    end
end
a=suptitle('Zones occupancy during Maze, drugs'); a.FontSize=20;


% Freezing exhaustive
figure; sess=2;
for zones=1:5
    
    subplot(3,5,zones)
    MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
    if zones==1; ylabel('proportion of total time'); u=text(-2,.15,'Time spent'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
    title(['Zones ' num2str(zones)])
    ylim([0 .4])
    
    subplot(3,5,zones+5)
    MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
    if zones==1; ylabel('time (s)'); u=text(-2,.06,'Time spent freezing'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
    ylim([0 1000])
   
    subplot(3,5,zones+10)
    MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones} ,Cols,X,Legends,'showpoints',1,'paired',0);
    if zones==1; ylabel('proportion of time in zone'); u=text(-2,.06,'Proportion time freezing'); set(u,'Rotation',90,'FontSize',15,'FontWeight','bold'); end
    ylim([0 .2])
    
end
a=suptitle('Zones occupancy during conditionning, when free'); a.FontSize=20;


% zone 3
figure; zones=3; sess=2;
subplot(131)
MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_Zones.Figure.(Session_type{sess}){zones}([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
title('Time spent / Total time')

subplot(132)
MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
title('Time spent freezing / Total time')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
title('Time spent freezing / Total freezing time')

a=suptitle('Middle zone occupancy during Maze, drugs'); a.FontSize=20;


% Non analayzed zones
figure; sess=2;
subplot(131)
MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_NonAnalyzedZones.Figure.(Session_type{sess})([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
title('Time spent / Total time')

subplot(132)
MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_NonAnalyzedZones.Figure.(Session_type{sess})([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
title('Time spent freezing / Total time')

subplot(133)
MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_NonAnalyzedZones_ofFz.Figure.(Session_type{sess})([ind]) ,Cols,X,Legends,'showpoints',1,'paired',0);
title('Time spent freezing / Total freezing time')

a=suptitle('Non analyzed zones occupancy during Maze, drugs'); a.FontSize=20;





%% others
figure;
for zones=1:3
    n=1;
    for sess=[6 2 7]
        
        subplot(3,3,n+(zones-1)*3)
        
        if zones==3; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_BiggerZones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_In_BiggerZones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==6; ylabel(['Zones ' num2str(zones)]); end 
        n=n+1;
   
    end
end
a=suptitle('Zones occupancy during Maze, drugs'); a.FontSize=20;


% Time spent freezing
figure;
for zones=1:5
    n=1;
    for sess=[4 5 7]
        
        subplot(5,3,n+(zones-1)*3)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==4; ylabel(['Zones ' num2str(zones)]); end
        n=n+1;
        
    end
end
a=suptitle('Freezing proportion in zones during Maze, drugs'); a.FontSize=20;

figure; sess=1;
for zones=1:5
        subplot(1,5,zones)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Proportion_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        ylim([0 .16])
        if zones==1; ylabel('proportion'); end
        title(['Zones ' num2str(zones)])
end
a=suptitle('Freezing proportion in zones during Maze, drugs'); a.FontSize=20;


figure;
for zones=1:5
    n=1;
    for sess=[4 5 7]
        
        subplot(5,3,n+(zones-1)*3)
        
        if zones==5; MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,Legends,'showpoints',1,'paired',0);
        else; MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Freezing_In_Zones.Figure.(Session_type{sess}){zones}  ,Cols,X,NoLegends,'showpoints',1,'paired',0);
        end
        if zones==1; title(Session_type{sess}); end
        if sess==4; ylabel(['Zones ' num2str(zones)]); end
        n=n+1;
        
    end
end
a=suptitle('Time spent freezing in zones during Maze, drugs'); a.FontSize=20;


% Freezing zones analysis
figure
for zones=1:5; n=1;
    for group=[5 6 16 13]
        subplot(5,4,(zones-1)*4+n)
        for sess=[4 5 7 3]
            
            plot(Spectro{3} , nanmean(squeeze(OB_FreezingMean_in_Zones.(Drug_Group{group}).(Session_type{sess})(:,zones,:)))); hold on
            xlim([0 10]); makepretty
            u=vline([2 4 6]); ylim([0 5e5])
            if n==1; ylabel('Power (a.u.)'); end
            if zones==5; xlabel('Frequency (Hz)'); end
            if and(zones==1 , n==1); legend('CondPre','CondPost','TestPost','Ext'); title(Drug_Group{group}); end
        end
        n=n+1;
    end
end



%% Linear distance
for sess=1:length(Session_type) % generate all data required for analyses
    
    if sess==1
        FolderList=FearSess;
    elseif sess==2
        FolderList=CondSess;
    elseif sess==3
        FolderList=ExtSess;
    elseif sess==4
        FolderList=CondPreSess;
    elseif sess==5
        FolderList=CondPostSess;
    elseif sess==6
        FolderList=TestPreSess;
    elseif sess==7
        FolderList=TestPostSess;
    end
    
    for mouse = 1:length(Mouse_names)
        try
            
            h=histogram(Data(LinearPosition.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
            HistData.(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            clear h
            h=histogram(Data(LinearPosition_Freezing.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
            HistData_Freezing.(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            
        end
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                if isnan(runmean(HistData.(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Session_type{sess}).(Mouse_names{mouse})),3))
                    HistData.(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                else
                    HistData.(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            catch
                HistData.(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
            end
            try
                if isnan(runmean(HistData_Freezing.(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData_Freezing.(Session_type{sess}).(Mouse_names{mouse})),3))
                    HistData_Freezing.(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                else
                    HistData_Freezing.(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData_Freezing.(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Session_type{sess}).(Mouse_names{mouse})),3);
                end
            catch
                HistData_Freezing.(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
            end
        end
    end
end


% Figures
figure
for group=1:4
    n=1;
    for sess=[6 4 5 7 3]
        
        subplot(5,4,4*(n-1)+group)
        
        Conf_Inter=nanstd(HistData.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(linspace(0,1,91) , nanmean(HistData.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        Conf_Inter=nanstd(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(linspace(0,1,91) , nanmean(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}))*10 , Conf_Inter,'r',1); hold on;
        makepretty; grid on
        if and(n==1,group==1); u=text(-.2,0.02,'TestPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==1); u=text(-.2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==1); u=text(-.2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==4,group==1); u=text(-.2,0.02,'TestPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==5,group==1); u=text(-.2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==5; xlabel('Linear position'); end
        ylim([0 .1])
        if and(n==1,group==1); f=get(gca,'Children'); legend([f(8),f(4)],'All','Freezing'); end
        
        n=n+1;
    end
end
a=suptitle('Linear position, dgs, UMaze'); a.FontSize=20;


figure
for group=5:8
    n=1;
    for sess=[6 4 5 7 3]
        
        subplot(5,4,4*(n-1)+group-4)
        
        Conf_Inter=nanstd(HistData.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(linspace(0,1,91) , nanmean(HistData.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        Conf_Inter=nanstd(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(linspace(0,1,91) , nanmean(HistData_Freezing.(Drug_Group{group}).(Session_type{sess}))*10 , Conf_Inter,'r',1); hold on;
        makepretty; grid on
        if and(n==1,group==5); u=text(-.2,0.02,'TestPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==2,group==5); u=text(-.2,0.02,'CondPre','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,group==5); u=text(-.2,0.02,'CondPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==4,group==5); u=text(-.2,0.02,'TestPost','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==5,group==5); u=text(-.2,0.02,'Ext','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if n==1; title(Drug_Group{group}); end
        if n==5; xlabel('Linear position'); end
        ylim([0 .1])
         if and(n==1,group==1); f=get(gca,'Children'); legend([f(8),f(4)],'All','Freezing'); end
        
        n=n+1;
    end
end
a=suptitle('Linear position, drugs, UMaze'); a.FontSize=20;




%%
clear all

cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'Epoch1', 'Epoch_Unblocked')

GetEmbReactMiceFolderList_BM

Session_type={'Cond'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends ={'', '', '', '','','','',''};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        
        EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = Epoch_Unblocked.(Session_type{sess}){mouse,1};
        
    end
end


% CAREFULL, here proportion of total time and not proportion of time spent in the zone
for sess=1:length(Session_type)
    for group=[9 11 18 17]
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            Zones.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
            TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , max(Range(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed'))));
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            for zones=1:5
                Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , EpochUnblocked.(Session_type{sess}).(Mouse_names{mouse}));
                Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
            end
             
            disp(Mouse_names{mouse})
        end
    end
end

ZonesLab={'Zone1','Zone2','Zone3','Zone4','Zone5'};
for sess=1:length(Session_type)
    n=1;
    for group=[9 11 18 17]
         Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            for zones=1:5
                Absolute_Time_Spent_Active_In_Zones_Free_All.(Session_type{sess}).(ZonesLab{zones}){n}(mouse) = Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones);
                Absolute_Time_Spent_Freezing_In_Zones_Free_All.(Session_type{sess}).(ZonesLab{zones}){n}(mouse) = Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones);
            end
            
            disp(Mouse_names{mouse})
        end
        n=n+1;
    end
end


Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

figure
for zones=1:5
%     subplot(2,5,zones)
%     MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Active_In_Zones_Free_All.(Session_type{sess}).(ZonesLab{zones}) ,Cols,X,NoLegends,'showpoints',1,'paired',0);
%      
    subplot(2,5,zones+5)
    MakeSpreadAndBoxPlot2_SB(Absolute_Time_Spent_Freezing_In_Zones_Free_All.(Session_type{sess}).(ZonesLab{zones}) ,Cols,X,Legends,'showpoints',1,'paired',0);
end



