

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
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch_withnoise');
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
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
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
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











