
%% shock/safe zone entries
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};

cd('/media/nas6/ProjetEmbReact/DataEmbReact'); load('Create_Behav_Drugs_BM.mat','Epoch_Unblocked')
GetEmbReactMiceFolderList_BM
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type) % generate all data required for analyses
        TimeSpentInactive.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s'))/60);
    end
end

Group=5:8;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type) % generate all data required for analyses
            
            Sessions_List_ForLoop_BM
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
            FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_nosleep');
            
            % clean shock & safe epoch, put an option on it ? BM 24/09/2022
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            clear StaShock StoShock StaSafe StoSafe
            StaShock = Start(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})); StoShock=Stop(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            StaSafe = Start(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})); StoSafe=Stop(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            try
                clear ind_to_use_shock; ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
                StaShock=StaShock([true ; ~ind_to_use_shock]);
                StoShock=StoShock([~ind_to_use_shock ; true]);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(StaShock , StoShock);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
            catch
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            end
            
            try
                clear ind_to_use_safe; ind_to_use_safe = StoSafe(1:end-1)==StaSafe(2:end);
                StaSafe=StaSafe([true ; ~ind_to_use_safe]);
                StoSafe=StoSafe([~ind_to_use_safe ; true]);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(StaSafe , StoSafe);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
            catch
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            end
            
            % Freezing
            FreezeEpoch.Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}));
            FreezeEpoch.Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}));
            
        end
        disp(Mouse_names{mouse})
    end
    n=n+1;
end

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type) % generate all data required for analyses
            ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./TimeSpentInactive.(Session_type{sess}).(Mouse_names{mouse});
            SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./TimeSpentInactive.(Session_type{sess}).(Mouse_names{mouse});
            Ratio_ZoneEntries.(Session_type{sess}){n} = log2(ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n});
        end
    end
    n=n+1;
end

% Figures section
ind=[5:8];
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

figure; n=1;
for sess=[4 5 7]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot2_SB(ShockEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot2_SB(SafeEntriesZone.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('entries/min'); end
    ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot2_SB(Ratio_ZoneEntries.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==4; ylabel('entries/min'); end
    %     ylim([0 4])
    hline(1,'--r')
    if n==1; u=text(-1,1.5,'Ratio Shock/Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;


%% Freezing episodes and mean duration
GetEmbReactMiceFolderList_BM
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        for side=1:length(Side)
            try
                EpisodeNumber.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = length(Start(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})));
                EpisodeMedianDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = nanmedian(Stop(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                EpisodeMeanDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            end
        end
    end
end
Mouse_names={'M1144'}; mouse=1;
for sess=1:length(Session_type)
    for side=1:length(Side)
        EpisodeMeanDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=NaN;
        EpisodeMedianDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})=NaN;
    end
end


for side=1:length(Side)
    for sess=1:length(Session_type)
        n=1;
        for group=[5 6 16 13 9 11 18 17]%1:length(Drug_Group)
            Drugs_Groups_UMaze_BM
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                Episode_Number.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeNumber.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                Episode_MedianDuration.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeMedianDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                Episode_MeanDuration.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeMeanDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                
            end
            n=n+1;
        end
    end
end

ind=[1:4];
ind=[5:8];


figure; n=1;
for sess=[4 5 3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot2_SB(Episode_Number.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,100,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 250])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#'); end
    if n==1; u=text(-1,35,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 100])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#'); end
    ylim([-1 160])
    if n==1; u=text(-1,60,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end

    n=n+1;
end
a=suptitle('Freezing analysis, episodes number'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 12])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 13])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 12])
    
    n=n+1;
end
a=suptitle('Freezing analysis, episodes median duration'); a.FontSize=20;



figure; n=1;
for sess=[4 5 3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot2_SB(Episode_MeanDuration.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 25])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Episode_MeanDuration.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 22])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot2_SB(Episode_MeanDuration.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 16])
    
    n=n+1;
end
a=suptitle('Freezing analysis, episodes mean duration'); a.FontSize=20;


%% Sleepy

clear all
GetEmbReactMiceFolderList_BM
Group = [9 11 18 17];

for group=Group
    Drugs_Groups_UMaze_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Sleepy.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','sleepyepoch');
        Sleepy_ind.(Mouse_names{mouse}) = sum(Stop(Sleepy.(Mouse_names{mouse}))-Start(Sleepy.(Mouse_names{mouse})))/60e4;
        Sleepy_all(mouse) = sum(Stop(Sleepy.(Mouse_names{mouse}))-Start(Sleepy.(Mouse_names{mouse})))/60e4;
        FreezeEpoch.All.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_nosleep');
        Sleepy_Freezing.(Mouse_names{mouse}) = and(Sleepy.(Mouse_names{mouse}) , FreezeEpoch.All.(Mouse_names{mouse}));
        Sleepy_Freezing_Dur.(Mouse_names{mouse}) = sum(Stop(Sleepy_Freezing.(Mouse_names{mouse}))-Start(Sleepy_Freezing.(Mouse_names{mouse})))/60e4;
        Freezing_Dur.(Mouse_names{mouse}) = sum(Stop(FreezeEpoch.All.(Mouse_names{mouse}))-Start(FreezeEpoch.All.(Mouse_names{mouse})))/60e4;
        
        disp(Mouse_names{mouse})
    end
end

figure
bar(Sleepy_all)
xticks([1:92]); xticklabels(Mouse_names); xtickangle(45)
ylabel('time (min)')
title('sleepy epoch time')

n=1;
for group=[5 6 16 13]
    Drugs_Groups_UMaze_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Sleepy_dur{n}(mouse) = Sleepy_ind.(Mouse_names{mouse});
        Sleepy_Freezing_Dur_all{n}(mouse) = Sleepy_Freezing_Dur.(Mouse_names{mouse});
        Freezing_Dur_all{n}(mouse) = Freezing_Dur.(Mouse_names{mouse});
    end
    Freezing_NoSleep_Dur_all{n} = Freezing_Dur_all{n}-Sleepy_Freezing_Dur_all{n};
    n=n+1;
end

Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

figure
subplot(141)
MakeSpreadAndBoxPlot2_SB(Freezing_Dur_all,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time(min)')
title('Freezing time')

subplot(142)
MakeSpreadAndBoxPlot2_SB(Sleepy_dur,Cols,X,Legends,'showpoints',1,'paired',0);
title('Sleepy time')

subplot(143)
MakeSpreadAndBoxPlot2_SB(Sleepy_Freezing_Dur_all,Cols,X,Legends,'showpoints',1,'paired',0);
title('Sleepy freezing time')

subplot(144)
MakeSpreadAndBoxPlot2_SB(Freezing_NoSleep_Dur_all,Cols,X,Legends,'showpoints',1,'paired',0);
title('Freezing time no sleepy')












