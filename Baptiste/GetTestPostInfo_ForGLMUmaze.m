
function [Thigmo_score,Latency_Shock,Latency_Safe,SafeZone_Occupancy,ShockZone_Occupancy,ShockZoneEntries_Density,SafeZoneEntries_Density] = GetTestPostInfo_ForGLMUmaze

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Session_type={'Habituation','TestPre','Cond','TestPost','Ext'};

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','Diazepam'};
NoLegends = {'','','',''};

ind=1:4;
Group=[7 8];
Group=[11];

Side = {'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};


%%
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=4%1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            try
                Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
                TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
                ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
                Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
                Position.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'alignedposition');
                Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position.(Session_type{sess}).(Mouse_names{mouse}) , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
                for zones=1:5
                    Zone_c.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){zones} , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                end
                
                ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=Zone_c.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=or(Zone_c.(Session_type{sess}).(Mouse_names{mouse}){2},Zone_c.(Session_type{sess}).(Mouse_names{mouse}){5});
                
                [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] =...
                    Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                
                
                ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                Zone2.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2};
                
                FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                
                TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse})));
                
                %   1) stims density
                StimNumber.(Session_type{sess}){n}(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                StimDensity.(Session_type{sess}){n}(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))./(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
                
                % 2) shock zone entries
                ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                ShockZoneEntries_Density.(Session_type{sess}){n}(mouse) = ShockEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                SafeZoneEntries_Density.(Session_type{sess}){n}(mouse) = SafeEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                %
                % 3) freezing proportion, aversiveness
                FreezingAll_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SafeZone.(Session_type{sess}).(Mouse_names{mouse})));
                
                % 4) thigmo
                [Thigmo_score.(Session_type{sess}){n}(mouse), ~] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                % 5) occupancy
                ShockZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(ShockZone.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                SafeZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(SafeZone.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                Zone2_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(Zone2.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                %
                % 6) duration
                Freezing_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4;
                FreezingShock_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/60e4;
                FreezingSafe_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/60e4;
                
                % 7) latency
                clear Sta Sto
                Sta  = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Shock.(Session_type{sess}){n}(mouse) = Sta(1);
                Sto  = Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Safe.(Session_type{sess}){n}(mouse) = Sto(1);
                
                % 8) proportion for expe duration
                Freezing_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                
                % 9) Distance traveled
                %                 DistTraveled.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                Position.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'alignedposition');
                Position_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                DistTraveled2.(Session_type{sess}){n}(mouse) = Dist_Traveld_From_Position_BM(Position_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                DistTraveled.(Session_type{sess}){n}(mouse) = DistTraveled2.(Session_type{sess}){n}(mouse)./(sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
                
                % 10) Mean speed
                Walking = thresholdIntervals(Speed.(Session_type{sess}).(Mouse_names{mouse}) , 1,'Direction','Above');
                MeanSpeed.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Walking)));
                
            end
            disp(Mouse_names{mouse})
        end
        Ratio_ZoneEntries.(Session_type{sess}){n} = ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n};
    end
    n=n+1;
end

end