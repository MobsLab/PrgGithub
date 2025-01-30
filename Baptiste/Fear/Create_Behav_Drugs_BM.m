
%% Behaviour code

% will generate behaviour variables:
% - FreezingProportion (total, ratio, shock, safe)
% - zone occupancy
% - occupancy mean time
% - extra stim number
% - zone entries
% - latency to enter shock zone
% - freezing time
% - RA
% - Latency to move after door removal

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};


for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'accelero');
    disp(Session_type{sess})
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        
        try
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','blockedepoch');
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
%             RA.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'risk_assessment') ;
        end
    end
    
%     try
%         Session_type={'CondShock','CondSafe','ExtShock','ExtSafe'};
%         for sess=1:length(Session_type)
%             
%             Sessions_List_ForLoop_BM
%             
%             EscapeLatency.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'escape_latency');
%             
%         end
%         EscapeLatency.Shock.Cond.(Mouse_names{mouse}) = nanmean(EscapeLatency.CondShock.(Mouse_names{mouse}));
%         EscapeLatency.Safe.Cond.(Mouse_names{mouse}) = nanmean(EscapeLatency.CondSafe.(Mouse_names{mouse}));
%         EscapeLatency.Shock.Ext.(Mouse_names{mouse}) = nanmean(EscapeLatency.ExtShock.(Mouse_names{mouse}));
%         EscapeLatency.Safe.Ext.(Mouse_names{mouse}) = nanmean(EscapeLatency.ExtSafe.(Mouse_names{mouse}));
%     end
    
    disp(Mouse_names{mouse})
end

% little temporary correction for OE mice
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            if length(Start(Epoch1.(Session_type{sess}){mouse,2}))==0
                Epoch1.(Session_type{sess}){mouse,2} = intervalSet(0,0);
            end
        end
    end
end

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for cond=1:8
            try
                Epoch_Blocked.(Session_type{sess}){mouse,cond} = and(Epoch1.(Session_type{sess}){mouse,cond} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                Epoch_Unblocked.(Session_type{sess}){mouse,cond} = Epoch1.(Session_type{sess}){mouse,cond} - Epoch_Blocked.(Session_type{sess}){mouse,cond};
            end
        end
    end
end


clear ExtraStim FreezingProp ZoneOccupancy StimNumb ShockZoneEntries SafeZoneEntries Total_Time Latency_SZ OccupancyMeanTime;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        try
            % Freezing proportion
            FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}));
            % Freezing shock/safe proportion
            FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}));
            % Shock and safe proportion
            FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/(sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5})) +sum(Stop(Epoch1.(Session_type{sess}){mouse,7})-Start(Epoch1.(Session_type{sess}){mouse,7})));
            FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6}))/(sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6})) +sum(Stop(Epoch1.(Session_type{sess}){mouse,8})-Start(Epoch1.(Session_type{sess}){mouse,8})));
            % Exploration
            ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,5})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,5})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,7})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,7})))/sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,1})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse}) = (sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,6})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,6})) + sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,8})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,8})))/sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,1})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            % mean time in shock zone
            OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1} , Epoch_Unblocked.(Session_type{sess}){mouse,1})) - Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1} , Epoch_Unblocked.(Session_type{sess}){mouse,1})))/1e4;
            OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , Epoch_Unblocked.(Session_type{sess}){mouse,1})) - Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , Epoch_Unblocked.(Session_type{sess}){mouse,1})))/1e4;
            % Stim number / min
            StimNumb.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch1.(Session_type{sess}){mouse,2}));
            StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(and(Epoch1.(Session_type{sess}){mouse,2} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            ExtraStim.(Session_type{sess}).(Mouse_names{mouse}) = (StimNumb.(Session_type{sess}).(Mouse_names{mouse}) - StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse}))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s'))/60);
            % Shock / Safe zone entries / min
            clear ShZ_Entries; ShZ_Entries = Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1} , Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse}) = length(ShZ_Entries(ShZ_Entries>2e4))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s'))/60) ; % consider shock zone entries only if sup to 2s
            clear SaZ_Entries; SaZ_Entries = Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneEntries.Safe.(Session_type{sess}).(Mouse_names{mouse}) = length(SaZ_Entries(SaZ_Entries>2e4))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 1},'s'))/60) ; % consider safe zone entries only if sup to 2s
            % Shock / Safe zone entries / when note freezing
            clear ShZ_Entries; ShZ_Entries = Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1} , Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneEntriesActive.Shock.(Session_type{sess}).(Mouse_names{mouse}) = length(ShZ_Entries(ShZ_Entries>2e4))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s'))/60) ; % consider shock zone entries only if sup to 2s
            clear SaZ_Entries; SaZ_Entries = Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            ZoneEntriesActive.Safe.(Session_type{sess}).(Mouse_names{mouse}) = length(SaZ_Entries(SaZ_Entries>2e4))/(sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s')-Start(Epoch_Unblocked.(Session_type{sess}){mouse, 4},'s'))/60) ; % consider safe zone entries only if sup to 2s
            % Total time
            Total_Time.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1}))/6e5;
            % Shock zone entries latency
            Latency.Shock.(Session_type{sess}).(Mouse_names{mouse})=Get_Latency_BM(Epoch1.(Session_type{sess}){mouse,7})/1e4;
            % Freezing time
            FreezingTime.All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}))/6e5;
            FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))/6e5;
            FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,6})-Start(Epoch1.(Session_type{sess}){mouse,6}))/6e5;
            % Stim by SZ entries
            Stim_By_SZ_entries.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse})/ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
            % Time in middle zone
            Occupancy_MiddleZone.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3})-Start(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3}))/sum(Stop(Epoch_Unblocked.(Session_type{sess}){mouse,1})-Start(Epoch_Unblocked.(Session_type{sess}){mouse,1}));
            FreezingProp_MiddleZone.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3} , Epoch1.(Session_type{sess}){mouse,3}))-Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3} , Epoch1.(Session_type{sess}){mouse,3})))/sum(Stop(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3})-Start(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3}));
            FreezingTime_MiddleZone.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3} , Epoch1.(Session_type{sess}){mouse,3}))-Start(and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3} , Epoch1.(Session_type{sess}){mouse,3})))/1e4;
        end
    end
    disp(Mouse_names{mouse})
end

for group=1:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
%             try
                FreezingProportion.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Ratio.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneOccupancy.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                OccupancyMeanTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                StimNumb.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb.(Session_type{sess}).(Mouse_names{mouse});
                StimNumb_Blocked.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse});
                ExtraStim.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneEntries.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEntries.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Safe.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEntriesActive.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntriesActive.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEntriesActive.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntriesActive.Safe.(Session_type{sess}).(Mouse_names{mouse});
             
                Total_Time.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Total_Time.(Session_type{sess}).(Mouse_names{mouse});
                
                Latency.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Latency.Shock.(Session_type{sess}).(Mouse_names{mouse});
                
                FreezingTime.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.All.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) ;
                
%                 RA.(Drug_Group{group}).(Session_type{sess})(mouse) = RA.(Session_type{sess}).(Mouse_names{mouse});
               
%                 EscapeLatency.Shock.(Drug_Group{group}).(Session_type{sess})(mouse) = EscapeLatency.Shock.(Session_type{sess}).(Mouse_names{mouse});
%                 EscapeLatency.Safe.(Drug_Group{group}).(Session_type{sess})(mouse) = EscapeLatency.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                Stim_By_SZ_entries.(Drug_Group{group}).(Session_type{sess})(mouse) = Stim_By_SZ_entries.(Session_type{sess}).(Mouse_names{mouse});
                
                Occupancy_MiddleZone.(Drug_Group{group}).(Session_type{sess})(mouse) = Occupancy_MiddleZone.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProp_MiddleZone.(Drug_Group{group}).(Session_type{sess})(mouse) = FreezingProp_MiddleZone.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime_MiddleZone.(Drug_Group{group}).(Session_type{sess})(mouse) = FreezingTime_MiddleZone.(Session_type{sess}).(Mouse_names{mouse});
%             end
        end
    end
end


for sess=1:length(Session_type)
    for group=1:8
%         try
            FreezingProportion.Figure.All.(Session_type{sess}){group} = FreezingProportion.All.(Drug_Group{group}).(Session_type{sess});
            FreezingProportion.Figure.Ratio.(Session_type{sess}){group} = FreezingProportion.Ratio.(Drug_Group{group}).(Session_type{sess});
            FreezingProportion.Figure.Shock.(Session_type{sess}){group} = FreezingProportion.Shock.(Drug_Group{group}).(Session_type{sess});
            FreezingProportion.Figure.Safe.(Session_type{sess}){group} = FreezingProportion.Safe.(Drug_Group{group}).(Session_type{sess});
            ZoneOccupancy.Figure.Shock.(Session_type{sess}){group} = ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess});
            ZoneOccupancy.Figure.Safe.(Session_type{sess}){group} = ZoneOccupancy.Safe.(Drug_Group{group}).(Session_type{sess});
            OccupancyMeanTime.Figure.Shock.(Session_type{sess}){group} = OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess});
            OccupancyMeanTime.Figure.Safe.(Session_type{sess}){group} = OccupancyMeanTime.Safe.(Drug_Group{group}).(Session_type{sess});
            %if ExtraStim.(Drug_Group{group}).(Session_type{sess})>0
            ExtraStim.Figure.(Session_type{sess}){group} = ExtraStim.(Drug_Group{group}).(Session_type{sess});
            ZoneEntries.Figure.Shock.(Session_type{sess}){group} = ZoneEntries.Shock.(Drug_Group{group}).(Session_type{sess});
            ZoneEntries.Figure.Safe.(Session_type{sess}){group} = ZoneEntries.Safe.(Drug_Group{group}).(Session_type{sess});
            ZoneEntriesActive.Figure.Shock.(Session_type{sess}){group} = ZoneEntriesActive.Shock.(Drug_Group{group}).(Session_type{sess});
            ZoneEntriesActive.Figure.Safe.(Session_type{sess}){group} = ZoneEntriesActive.Safe.(Drug_Group{group}).(Session_type{sess});
            Latency.Figure.Shock.(Session_type{sess}){group} = Latency.Shock.(Drug_Group{group}).(Session_type{sess});
            FreezingTime.Figure.All.(Session_type{sess}){group} = FreezingTime.All.(Drug_Group{group}).(Session_type{sess});
            FreezingTime.Figure.Shock.(Session_type{sess}){group} = FreezingTime.Shock.(Drug_Group{group}).(Session_type{sess});
            FreezingTime.Figure.Safe.(Session_type{sess}){group} =  FreezingTime.Safe.(Drug_Group{group}).(Session_type{sess}) ;
%             RA.Figure.(Session_type{sess}){group} = RA.(Drug_Group{group}).(Session_type{sess});
%             EscapeLatency.Figure.(Session_type{sess}){group} = EscapeLatency.(Drug_Group{group}).(Session_type{sess});
            Stim_By_SZ_entries.Figure.(Session_type{sess}){group} = Stim_By_SZ_entries.(Drug_Group{group}).(Session_type{sess});
            Occupancy_MiddleZone.Figure.(Session_type{sess}){group} = Occupancy_MiddleZone.(Drug_Group{group}).(Session_type{sess});
            FreezingProp_MiddleZone.Figure.(Session_type{sess}){group} = FreezingProp_MiddleZone.(Drug_Group{group}).(Session_type{sess});
            FreezingTime_MiddleZone.Figure.(Session_type{sess}){group} = FreezingTime_MiddleZone.(Drug_Group{group}).(Session_type{sess});
%         end
    end
end


clear All
for sess=1:length(Session_type)
    All.FreezingTime.Figure.Shock.(Session_type{sess})=[]; All.FreezingTime.Figure.Safe.(Session_type{sess})=[]; All.FreezingProp.FigureAll.(Session_type{sess})=[]; All.FreezingProp.FigureShock.(Session_type{sess})=[]; All.ZoneOccupancy.FigureShock.(Session_type{sess})=[]; All.ExtraStim.Figure.(Session_type{sess})=[]; All.ShockZoneEntries.Figure.(Session_type{sess})=[]; All.Latency_SZ.Figure.(Session_type{sess})=[]; All.Stim_By_SZ_entries.(Session_type{sess})=[]; All.FreezingPercentage.Figure.Shock.(Session_type{sess})=[]; All.FreezingPercentage.Figure.Safe.(Session_type{sess})=[];
    for group=1:8
        try
            All.FreezingProp.FigureAll.(Session_type{sess}) = [All.FreezingProp.FigureAll.(Session_type{sess}) ; FreezingProp.FigureAll.(Session_type{sess}){group}];
            All.FreezingProp.FigureShock.(Session_type{sess}) = [All.FreezingProp.FigureShock.(Session_type{sess}) ; FreezingProp.FigureShock.(Session_type{sess}){group}];
            All.FreezingPercentage.Figure.Safe.(Session_type{sess}) = [All.FreezingPercentage.Figure.Safe.(Session_type{sess}) ; FreezingPercentage.Figure.Shock.(Session_type{sess}){group}];
            All.FreezingPercentage.Figure.Shock.(Session_type{sess}) = [All.FreezingPercentage.Figure.Shock.(Session_type{sess}) ; FreezingPercentage.Figure.Safe.(Session_type{sess}){group}];
            All.ZoneOccupancy.FigureShock.(Session_type{sess}) = [All.ZoneOccupancy.FigureShock.(Session_type{sess}) ; ZoneOccupancy.FigureShock.(Session_type{sess}){group}];
            All.ExtraStim.Figure.(Session_type{sess}) = [All.ExtraStim.Figure.(Session_type{sess}) ; ExtraStim.Figure.(Session_type{sess}){group}];
            All.ShockZoneEntries.Figure.(Session_type{sess}) = [All.ShockZoneEntries.Figure.(Session_type{sess}) ; ShockZoneEntries.Figure.(Session_type{sess}){group}];
            All.Latency_SZ.Figure.(Session_type{sess}) = [All.Latency_SZ.Figure.(Session_type{sess}) ; Latency_SZ.Figure.(Session_type{sess}){group}];
            All.Stim_By_SZ_entries.(Session_type{sess}) = [All.Stim_By_SZ_entries.(Session_type{sess}) ; Stim_By_SZ_entries.(Session_type{sess}){group}];
            All.FreezingTime.Figure.Shock.(Session_type{sess}) = [All.FreezingTime.Figure.Shock.(Session_type{sess}) ; FreezingTime.Figure.Shock.(Session_type{sess}){group}];
            All.FreezingTime.Figure.Safe.(Session_type{sess}) =  [All.FreezingTime.Figure.Safe.(Session_type{sess}) ; FreezingTime.Figure.Safe.(Session_type{sess}){group}] ;
        end
    end
end



