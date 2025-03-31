
%% initialization parameters
clear all
GetEmbReactMiceFolderList_BM

% Session_type={'CondPre','CondPost','Ext','TestPost','Cond'};
Session_type={'Habituation','TestPre','Cond','TestPost'};
Session_type={'TestPre','Cond','TestPost','Ext'};
% Session_type={'TestPre','Cond','Ext','TestPost','CondPre','CondPost'};
% Session_type={'Habituation','TestPre','Cond','TestPost'};
% Session_type={'TestPre','Cond','TestPost'};

% Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','Saline','Diazepam','RipControl','RipInhib','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','SalineMaze1Time1','DZPMaze1Time1','DZPMaze4Time1'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','RipSham2','RipInhib2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = 1:4;
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};

ind=1:4;
Group=[13 15 7:8];
% Group=[13 15];

Side={'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};


DrugsGroups_Comparison_Function_BM

Trajectories_Function_Maze_BM


%% Generate data
% Freeze duration
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Sessions_List_ForLoop_BM
            
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
            TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_nosleep');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_nosleep');
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            Freeze_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            Freeze_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));

            Distance_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            
            ActiveEpoch_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));

            % side analysis
            for side=1:3
                if side==1
                    ZoneEp = TotEpoch;
                elseif side==2
                    ZoneEp = ShockZoneEpoch;
                elseif side==3
                    ZoneEp = SafeZoneEpoch;
                end
                BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
                ActiveEpoch_Unblocked.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , and(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            end
            %  zones analysis
            Zones=ZoneEpoch;
            AbsoluteTime_Free.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            AbsoluteTime_Free_Active.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            for zones=1:5
                Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Zone_Free_Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})-Start(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4;
                Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones) = sum(Stop(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))-Start(and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                
                Speed_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones})));
                DistanceTraveled_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones) = Speed_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones)*(Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones));
                Speed_Unblocked_Active.(Session_type{sess}).(Mouse_names{mouse})(zones) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , and(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones} , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
                Zone_Blocked_Freezing_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Zones.(Session_type{sess}).(Mouse_names{mouse}){zones}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            end
            Proportion_Time_Spent_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones) = Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
            Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse}) = Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})./Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse});
            
        end
        disp(Mouse_names{mouse})
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for zones=1:5
                
                DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Freezing_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}){zones}{n}(mouse) = Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}).(Mouse_names{mouse})(zones)/60;
                DATA.Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones}{n}(mouse) = Proportion_Time_Spent_Freezing_In_Zones.(Session_type{sess}).(Mouse_names{mouse})(zones);
                
                DATA.DistanceTraveled_Unblocked.(Session_type{sess}){zones}{n}(mouse) = DistanceTraveled_Unblocked.(Session_type{sess}).(Mouse_names{mouse})(zones);
                DATA.Speed_Unblocked_Active.(Session_type{sess}){zones}{n}(mouse) = Speed_Unblocked_Active.(Session_type{sess}).(Mouse_names{mouse})(zones);
                Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse) = length(Start(Zone_Free_Active_Epoch.(Session_type{sess}).(Mouse_names{mouse}){zones}));
                Zone_Entries_Density.(Session_type{sess}){zones}{n}(mouse) = Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse)/(AbsoluteTime_Free_Active.(Session_type{sess}).(Mouse_names{mouse})/60e4);
                Zone_Entries_DistNorm.(Session_type{sess}){zones}{n}(mouse) = Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse)./(Distance_UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Zones_MeanDuration.(Session_type{sess}){zones}{n}(mouse) = (sum(DurationEpoch(Zones_Free.(Session_type{sess}).(Mouse_names{mouse}){zones}))/1e4)/Zone_Entries_Numb.(Session_type{sess}){zones}{n}(mouse);
                
            end
        end
    end
    n=n+1;
end


for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                            
            TimeSpent_Unblocked_Active_All.(Session_type{sess}){n}(mouse) = sum(Stop(ActiveEpoch_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))-Start(ActiveEpoch_Unblocked.(Session_type{sess}).(Mouse_names{mouse})))/1e4;

            for side=1:length(Side)
                if side==1
                    ZoneEp = TotEpoch;
                elseif side==2
                    ZoneEp = ShockZoneEpoch;
                elseif side==3
                    ZoneEp = SafeZoneEpoch;
                end
                FreezeDuration.(Side{side}).(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezeDuration_Blocked.(Side{side}).(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(Freeze_BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezeDuration_Unblocked.(Side{side}).(Session_type{sess}){n}(mouse) = sum(Stop(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(Freeze_UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                                
                TimeSpent.(Side{side}).(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(ZoneEp.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TimeSpent_Blocked.(Side{side}).(Session_type{sess}){n}(mouse) = (sum(Stop(BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(BlockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TimeSpent_Unblocked.(Side{side}).(Session_type{sess}){n}(mouse) = (sum(Stop(UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(UnblockedEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                TimeSpent_Unblocked_Active.(Side{side}).(Session_type{sess}){n}(mouse) = sum(Stop(ActiveEpoch_Unblocked.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))-Start(ActiveEpoch_Unblocked.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;

                FzEpNumber.(Side{side}).(Session_type{sess}){n}(mouse) = length(Start(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),ZoneEp.(Session_type{sess}).(Mouse_names{mouse}))));
                FzEMeanDuration.(Side{side}).(Session_type{sess}){n}(mouse) = nanmean(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),ZoneEp.(Session_type{sess}).(Mouse_names{mouse}))))/1e4;
                
                Proportional_Time_Unblocked.(Side{side}).(Session_type{sess}){n}(mouse) = TimeSpent_Unblocked.(Side{side}).(Session_type{sess}){n}(mouse)./TimeSpent_Unblocked.(Side{1}).(Session_type{sess}){n}(mouse);
                Proportional_TimeFz.(Side{side}).(Session_type{sess}){n}(mouse) = FreezeDuration.(Side{side}).(Session_type{sess}){n}(mouse)./(sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                Proportional_Time_Unblocked_Active.(Side{side}).(Session_type{sess}){n}(mouse) = TimeSpent_Unblocked_Active.(Side{side}).(Session_type{sess}){n}(mouse)./TimeSpent_Unblocked.(Side{1}).(Session_type{sess}){n}(mouse);
                
                Proportionnal_Time_Freezing_Blocked_ofZone.(Side{side}).(Session_type{sess}){n} = FreezeDuration_Blocked.(Side{side}).(Session_type{sess}){n}./TimeSpent_Blocked.(Side{side}).(Session_type{sess}){n};
                Proportional_Time_Freezing_UnblockedEpoch.(Side{side}).(Session_type{sess}){n} = FreezeDuration_Unblocked.(Side{side}).(Session_type{sess}){n}./TimeSpent_Unblocked.(Side{1}).(Session_type{sess}){n};
               
                Proportionnal_Time_Freezing_ofZone.(Side{side}).(Session_type{sess}){n} = FreezeDuration.(Side{side}).(Session_type{sess}){n}./TimeSpent.(Side{side}).(Session_type{sess}){n};
                Proportionnal_Time_Freezing_Unblocked_ofZone.(Side{side}).(Session_type{sess}){n} = FreezeDuration_Unblocked.(Side{side}).(Session_type{sess}){n}./TimeSpent_Unblocked.(Side{side}).(Session_type{sess}){n};           
            end
        end
        n=n+1;
    end
end

% Shock/Safe zone entries
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type) % generate all data required for analyses
            
            Sessions_List_ForLoop_BM
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_nosleep');
            Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            for zones=1:5
            Zone_c.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){zones} , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
            end
            % clean shock & safe epoch, put an option on it ? BM 24/09/2022
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=Zone_c.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=or(Zone_c.(Session_type{sess}).(Mouse_names{mouse}){2},Zone_c.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            clear StaShock StoShock StaSafe StoSafe
            StaShock = Start(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})); StoShock=Stop(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            StaSafe = Start(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})); StoSafe=Stop(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            % zone epoch only considered if longer than 1s and merge with 1s
            try
                clear ind_to_use_shock; ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
                StaShock=StaShock([true ; ~ind_to_use_shock]);
                StoShock=StoShock([~ind_to_use_shock ; true]);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(StaShock , StoShock);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
            catch
                ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            end
            
            try
                clear ind_to_use_safe; ind_to_use_safe = StoSafe(1:end-1)==StaSafe(2:end);
                StaSafe=StaSafe([true ; ~ind_to_use_safe]);
                StoSafe=StoSafe([~ind_to_use_safe ; true]);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(StaSafe , StoSafe);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=dropShortIntervals(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})=mergeCloseIntervals(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}),1e4);
            catch
                SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet([],[]);
            end
        end
        disp(Mouse_names{mouse})
    end
    n=n+1;
end

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
            SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
            ShockZoneEntries_Density.(Session_type{sess}){n}(mouse) = ShockEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active_All.(Session_type{sess}){n}(mouse)/60);
            SafeZoneEntries_Density.(Session_type{sess}){n}(mouse) = SafeEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active_All.(Session_type{sess}){n}(mouse)/60);
        end
        Ratio_ZoneEntries.(Session_type{sess}){n} = ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n};
    end
    n=n+1;
end


% Trajectories
Trajectories_Function_Maze_BM

% Physio
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate','heartratevar','ripples','ob_low','respi_freq_BM');
    end
end


for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try; Ripples_All.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).ripples.mean(mouse,3); end
            try; Ripples_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).ripples.mean(mouse,5); end
            try; Ripples_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).ripples.mean(mouse,6); end
            
            Ripples_All.(Session_type{sess}){n}(Ripples_All.(Session_type{sess}){n}==0)=NaN;
            Ripples_Shock.(Session_type{sess}){n}(Ripples_Shock.(Session_type{sess}){n}==0)=NaN;
            Ripples_Safe.(Session_type{sess}){n}(Ripples_Safe.(Session_type{sess}){n}==0)=NaN;
        end
        n=n+1;
    end
end


for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            HR_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean(mouse,5);
            HR_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean(mouse,6);
            HRVar_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean(mouse,5);
            HRVar_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean(mouse,6);
            
            HR_Shock.(Session_type{sess}){n}(HR_Shock.(Session_type{sess}){n}==0)=NaN;
            HR_Safe.(Session_type{sess}){n}(HR_Safe.(Session_type{sess}){n}==0)=NaN;
            HRVar_Shock.(Session_type{sess}){n}(HRVar_Shock.(Session_type{sess}){n}==0)=NaN;
            HRVar_Safe.(Session_type{sess}){n}(HRVar_Safe.(Session_type{sess}){n}==0)=NaN;
            
        end
        HR_Diff.(Session_type{sess}){n} = HR_Shock.(Session_type{sess}){n}-HR_Safe.(Session_type{sess}){n};
        HRVar_Diff.(Session_type{sess}){n} = HRVar_Shock.(Session_type{sess}){n}-HRVar_Safe.(Session_type{sess}){n};
        n=n+1;
    end
end

for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Respi_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_BM.mean(mouse,5);
            Respi_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_BM.mean(mouse,6);
            
        end
        Respi_Diff.(Session_type{sess}){n} = Respi_Shock.(Session_type{sess}){n}-Respi_Safe.(Session_type{sess}){n};
        n=n+1;
    end
end

OB_MaxFreq_Maze_BM

Drug_Group = {'','','','','SalineBM','Diazepam','RipControl','RipInhib'};
for sess=[1 2 4]
    n=1;
    for group=Group
        
        OB_Max_Freq_All.(Session_type{sess}).Shock{n} = OB_Max_Freq.(Drug_Group{group}).(Session_type{sess}).Shock;
        OB_Max_Freq_All.(Session_type{sess}).Safe{n} = OB_Max_Freq.(Drug_Group{group}).(Session_type{sess}).Safe;
        OB_Freq_All_Diff.(Session_type{sess}){n} = OB_Max_Freq_All.(Session_type{sess}).Shock{n}./OB_Max_Freq_All.(Session_type{sess}).Safe{n};
        
        n=n+1;
    end
end


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=5
            
            MeanSpectrum_Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OutPutData.(Drug_Group{group}).Cond.ob_low.mean(mouse,5,:);
            MeanSpectrum_Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OutPutData.(Drug_Group{group}).Cond.ob_low.mean(mouse,6,:);
            
        end
    end
end

%% corrections
for sess=1:length(Session_type)
    for side=1:3
        Proportional_Time_Unblocked.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        Proportional_TimeFz.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        Proportionnal_Time_Freezing_Blocked_ofZone.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        Proportional_Time_Freezing_UnblockedEpoch.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        Proportionnal_Time_Freezing_ofZone.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        Proportionnal_Time_Freezing_Unblocked_ofZone.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        FzEpNumber.(Side{side}).(Session_type{sess}){1}(9)=NaN;
        FzEMeanDuration.(Side{side}).(Session_type{sess}){1}(9)=NaN;
%         Proportionnal_Time_Freezing_ofZone.(Side{side}).(Session_type{sess}){3}(7)=NaN;
    end
end

%% Figures sectionfigure; n=1;
% 1
figure; n=1;
for sess=1:3
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.4,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1.1])

    n=n+1;
end
a=suptitle('Time in zone / Total time, when free'); a.FontSize=20;


% 2
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .3])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Total time'); a.FontSize=20;


figure; sess=5;
for side=1:3
    subplot(3,1,side)
    if side==3
        MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{side}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    else
        MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{side}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    end
    if side==1; title('Cond'); end
    ylabel(Side{side})
end
a=suptitle('Time freezing in zone / Total time'); a.FontSize=20;

figure; sess=4;
for side=1:3
    subplot(3,1,side)
    if side==3
        MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{side}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    else
        MakeSpreadAndBoxPlot3_SB(Proportional_TimeFz.(Side{side}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    end
    if side==1; title('Fear'); end
    ylabel(Side{side})
end
a=suptitle('Time freezing in zone / Total time'); a.FontSize=20;



% 3
figure; n=1;
for sess=[1 2]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Blocked_ofZone.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Blocked_ofZone.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .8])
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Blocked_ofZone.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .8])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Total time, when blocked'); a.FontSize=20;

% 4
figure; n=1;
for sess=[1 2]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Freezing_UnblockedEpoch.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Freezing_UnblockedEpoch.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .05])
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Freezing_UnblockedEpoch.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Total time, when free'); a.FontSize=20;

% 5
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .8])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Time spent in zone'); a.FontSize=20;


figure; sess=5;
subplot(211)
MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
ylabel('prop time, shock')
title(Session_type{sess})
ylim([0 .7])

subplot(212)
MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('prop time, safe')
ylim([0 .8])

a=suptitle('Time freezing in zone / Time spent in zone'); a.FontSize=20;



figure; n=1;
for sess=[1 2]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Unblocked_ofZone.(Side{1}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.25,'Total'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .7])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Unblocked_ofZone.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.07,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
%     ylim([0 .05])
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_Unblocked_ofZone.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('time (s)'); end
    if n==1; u=text(-1,.25,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    n=n+1;
end
a=suptitle('Time freezing in zone / Time spent in zone, when free'); a.FontSize=20;




figure; n=1;
for sess=[1:3]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(SafeEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('entries/min'); end
%     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(Ratio_ZoneEntries.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    %     ylim([0 4])
    hline(1,'--r')
    if n==1; u=text(-1,1.5,'Ratio Shock/Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;



% Freezing episodes mean duration
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 17])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Freezing episodes mean duration'); a.FontSize=20;


% Freezing episodes number
figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([0 5.1])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('#'); end
%     ylim([0 4])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    %     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes number'); a.FontSize=20;


% Zones analysis
figure; p=1; sess=5;
for zones=[1 4 3 5 2]
    
    subplot(3,5,p)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Total time','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 32])
    title(Zones_Lab{p})
    
    subplot(3,5,p+5)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Time active','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 30])
    
    subplot(3,5,p+10)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,1.5,'Time freezing','FontSize',15,'FontWeight','bold','Rotation',90); end
    ylim([0 8.5])
    
    p=p+1;
end
a=suptitle('Time spent in zones, Cond sessions'); a.FontSize=20;


figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(3,5,p)
    MakeSpreadAndBoxPlot3_SB(Zone_Entries_Numb.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('entries #');end
    ylim([0 260]); title(Zones_Lab{p})

        subplot(3,5,p+5)
    MakeSpreadAndBoxPlot3_SB(Zone_Entries_Density.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('entries #/s active');end
%     ylim([0 260]); title(Zones_Lab{p})

    subplot(3,5,p+10)
    MakeSpreadAndBoxPlot3_SB(Zone_Entries_DistNorm.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('mean duration');end
    ylim([0 35])
    
    p=p+1;
end
a=suptitle('Zones entries analysis, Unblocked, Cond sessions'); a.FontSize=20;



% Trajectories
figure; m=1; type=2;
for group=Group
    
    subplot(4,3,1+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy;caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(4,3,2+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).Cond{m})
    axis xy; caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
        subplot(4,3,3+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).TestPost{m})
    axis xy; caxis([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre - Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end
a=suptitle(['Occupancy maps ' Type{type}]); a.FontSize=20;



figure; m=1; type=6;
for group=Group
    
    subplot(4,3,1+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).CondPre{m})
    axis xy;caxis([0 1e-2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(4,3,2+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).CondPost{m})
    axis xy;caxis([0 1e-2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(4,3,3+(m-1)*3);
    imagesc(OccupMap_squeeze.(Type{type}).CondPre{m}-OccupMap_squeeze.(Type{type}).CondPost{m})
    axis xy; caxis([0 1e-2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    
    colormap hot
    m=m+1;
end
a=suptitle(['Occupancy maps ' Type{type}]); a.FontSize=20;




% Physio
figure; n=1;
for sess=[1 2 4]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(Ripples_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 2])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Ripples_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,.7,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 2])
    
    n=n+1;
end
a=suptitle('Ripples analysis'); a.FontSize=20;


figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(HR_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([7 14])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(HR_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([7 14])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(HR_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([-2 4]); hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Heart rate analysis'); a.FontSize=20;

figure; sess=5;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({HR_Shock.(Session_type{sess}){group} HR_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([9 13])
    title(Drug_Group{group+4})
end


figure; sess=5;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({HRVar_Shock.(Session_type{sess}){group} HRVar_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([0 .3])
    title(Drug_Group{group+4})
end
a=suptitle('Heart rate variability, Cond sessions'); a.FontSize=20;

figure; sess=4;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({HR_Shock.(Session_type{sess}){group} HR_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([8.5 12.5])
    title(Drug_Group{group+4})
end

figure; sess=4;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({HRVar_Shock.(Session_type{sess}){group} HRVar_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([0 .3])
    title(Drug_Group{group+4})
end



figure; n=1;
for sess=1:4
    subplot(3,4,n)
    MakeSpreadAndBoxPlot3_SB(HRVar_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
%     ylim([7 14])
    
    subplot(3,4,n+4)
    MakeSpreadAndBoxPlot3_SB(HRVar_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([7 14])
    
    subplot(3,4,n+8)
    MakeSpreadAndBoxPlot3_SB(HRVar_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     ylim([-2 4]); 
hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Heart rate variability analysis'); a.FontSize=20;


OB_MaxFreq_Maze_BM.m

figure; n=1;
for sess=[1 2 4]
    subplot(3,3,n)
    MakeSpreadAndBoxPlot3_SB(OB_Max_Freq_All.(Session_type{sess}).Shock,Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,4.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([1.5 7])
    
    subplot(3,3,n+3)
    MakeSpreadAndBoxPlot3_SB(OB_Max_Freq_All.(Session_type{sess}).Safe,Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,4.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([.5 6])
    
    subplot(3,3,n+6)
    MakeSpreadAndBoxPlot3_SB(OB_Freq_All_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 3]);
    hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Respi analysis'); a.FontSize=20;




figure; n=1;
for sess=1:4
    subplot(3,4,n)
    MakeSpreadAndBoxPlot3_SB(Respi_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
%     ylim([7 14])
    
    subplot(3,4,n+4)
    MakeSpreadAndBoxPlot3_SB(Respi_Safe.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([7 14])
    
    subplot(3,4,n+8)
    MakeSpreadAndBoxPlot3_SB(Respi_Diff.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('Frequency (Hz)'); u=text(-1,-1,'Diff Shock-Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([-2 4]);
    hline(0,'--r')
    
    n=n+1;
end
a=suptitle('Respi analysis'); a.FontSize=20;



figure; sess=5;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({Respi_Shock.(Session_type{sess}){group} Respi_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([1.5 6.5])
    title(Drug_Group{group+4})
end
a=suptitle('Respiratory rhythm, Cond sessions'); a.FontSize=20;

figure; sess=4;
for group=1:4
    subplot(1,4,group)
    MakeSpreadAndBoxPlot3_SB({Respi_Shock.(Session_type{sess}){group} Respi_Safe.(Session_type{sess}){group}},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1);
    ylim([1.5 6.5])
    title(Drug_Group{group+4})
end
a=suptitle('Respiratory rhythm, Ext sessions'); a.FontSize=20;



% Mean spectrums
sess=4; thr=19;
figure, group=5;
subplot(231)
[m1,A] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,B] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')

f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
u=text(-3,.3,'Rip control','FontWeight','bold','FontSize',20); set(u,'Rotation',90);


subplot(232)
[m1,~] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))./m1';
plot(Spectro{3} , Data_to_use , 'r')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

subplot(233)
[m1,~] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))./m1';
plot(Spectro{3} , Data_to_use , 'b')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

group=6;
subplot(234)
[m1,C] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(thr+1:end));
vline(RangeLow(d+thr),'--r')

[m1,D] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
vline(RangeLow(d+thr),'--b')

makepretty; xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
u=text(-2.5,.3,'Rip inhib','FontWeight','bold','FontSize',20); set(u,'Rotation',90);

subplot(235)
[m1,m2] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))./m1';
plot(Spectro{3} , Data_to_use , 'r')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

subplot(236)
[m1,m2] = max(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))./m1';
plot(Spectro{3} , Data_to_use , 'b')
makepretty; xlim([0 10]); ylim([0 1]), u=vline(4.5); set(u,'LineWidth',2);

a=suptitle(['OB Low during freezing, ' (Session_type{sess}) ' sessions']); a.FontSize=20;



A1 = RangeLow(A+thr-1)
B1 = RangeLow(B+thr-1)
C1 = RangeLow(C+thr-1)
D1 = RangeLow(D+thr-1)




figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({A1 B1},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1); 
subplot(122)
MakeSpreadAndBoxPlot3_SB({C1 D1},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},'showpoints',0,'paired',1); 





%% comparing 2 freezing safe
figure, 

[m1,m2] = max(RangeLow(thr:end)'.*squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = RangeLow.*squeeze(OutPutData.RipControl.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
col= [.65, .75, 0]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
u=vline(RangeLow(d+thr),'--'); u.Color=[.65, .75, 0];

[m1,m2] = max(RangeLow(thr:end)'.*squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,thr:end))');
Data_to_use = RangeLow.*squeeze(OutPutData.RipInhib.(Session_type{sess}).ob_low.mean(:,6,:))./m1';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(:,thr+1:end));
u=vline(4.88,'--'); u.Color=[.63, .08, .18];
col= [.63, .08, .18]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;

f=get(gca,'Children');
a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing');
% makepretty;
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xticks([0:2:10]); xlim([0 10]); ylim([0 1])
u=text(-3,.3,'Rip control','FontWeight','bold','FontSize',20); set(u,'Rotation',90);

