clear all
close all

GetEmbReactMiceFolderList_BM

% Session_type={'TestPre','TestPost','Cond','CondPre','CondPost','Ext'};
Session_type={'Cond'};
Group = [18];
Name = {'Saline_SB','','','','','','','','','','Saline','','','','','','Saline_BM_CH','Atropine','','Saline_All_CH','Saline_BM'};

for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            
            % variables
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
            Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
            ThetaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'hpc_theta_power');
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch');
            HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
            Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'alignedposition');
            Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'accelero');
            LinearPosition.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'LinearPosition');
            
            % epochs
            TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))));
            FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch');
            FreezeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freeze_epoch_camera');
            
            ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch');
            BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            
            ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2};
            ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){4};
            SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5};
            MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){3};
            SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5});
            
            FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeMiddleEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));

            FreezeShockEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Unblocked_ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Unblocked_ActiveShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Unblocked_ActiveSafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            [ShockZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})] = Correct_ZoneEntries_Maze_BM(Unblocked_ActiveShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , Unblocked_ActiveSafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
%             ExtraStim.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
        end
    end
end
 % 
% try
%     for sess=1:length(Session_type)
%         Sessions_List_ForLoop_BM
%         OBGamma.Atropine.(Session_type{sess}).M1561 = NaN;
%     end
% end

% Behaviour

for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
              
            TimeShockZone.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            TimeSafeZone.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            TimeSession.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            Position_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Position_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Position_Active_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             Position_Freezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            [Thigmo_Active.(Name{group}).(Session_type{sess})(mouse)] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             [Thigmo_Freezing.(Name{group}).(Session_type{sess})(mouse)] = Thigmo_From_Position_BM(Position_Freezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));

            
            % Shock/Safe zone entries
                        
            ShockZoneEntries.(Name{group}).(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEntries.(Name{group}).(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            ExpeDuration.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeTime_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Shock_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Safe_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;            
            FreezeTime_Safe2.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Middle.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeMiddleEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_SafeCorner.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_ShockCorner.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
             
            ActiveTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Shock.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Safe.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            Freeze_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            FreezeShock_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            FreezeSafe_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            Active_Prop.(Name{group}).(Session_type{sess})(mouse) = ActiveTime.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            
            Freeze_Shock_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            Freeze_Safe_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
                        
            Speed_Moving.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Speed_Moving_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Speed_Moving.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Speed_Moving_Unblocked_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Speed_Moving_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Speed_Moving_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Speed_Moving.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Speed_all.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            D = Data(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
            ImmobilityTime.(Name{group}).(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Speed_Stim.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            clear A, A = Data(Speed_Stim.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Mean_Speed_Stim.(Name{group}).(Session_type{sess}){mouse,:} = A;
            
            disp(Mouse_names{mouse})
        end
    end
end

for mouse = 2:3
    for sess = 1:length(Session_type)
        TimeShockZone.Atropine2.(Session_type{sess})(mouse) = TimeShockZone.Atropine.(Session_type{sess})(mouse);
        TimeSafeZone.Atropine2.(Session_type{sess})(mouse) = TimeSafeZone.Atropine.(Session_type{sess})(mouse);
        ShockZoneEntries.Atropine2.(Session_type{sess})(mouse) = ShockZoneEntries.Atropine.(Session_type{sess})(mouse);
        SafeZoneEntries.Atropine2.(Session_type{sess})(mouse) = SafeZoneEntries.Atropine.(Session_type{sess})(mouse);
    end
end

for mouse = 1:3
    for sess = 1:length(Session_type)
        if TimeShockZone.Atropine2.(Session_type{sess})(mouse) == 0
            TimeShockZone.Atropine2.(Session_type{sess})(mouse) = NaN;
        end
        if TimeSafeZone.Atropine2.(Session_type{sess})(mouse) == 0
            TimeSafeZone.Atropine2.(Session_type{sess})(mouse) = NaN;
        end
         if ShockZoneEntries.Atropine2.(Session_type{sess})(mouse) == 0
            ShockZoneEntries.Atropine2.(Session_type{sess})(mouse) = NaN;
        end
         if SafeZoneEntries.Atropine2.(Session_type{sess})(mouse) == 0
            SafeZoneEntries.Atropine2.(Session_type{sess})(mouse) = NaN;
         end
    end
end



for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
%     Speed_Moving_Unblocked_mean.Saline_SB.(Session_type{sess})(2) = NaN;
%     Speed_Moving_mean.Saline_SB.(Session_type{sess})(2) = NaN;
    Speed_all.Saline_SB.(Session_type{sess})(2) = NaN;
    Speed_Moving_Unblocked_mean.Saline_SB.(Session_type{sess})(2) = NaN
end

Speed_Moving_Unblocked_mean.Atropine.TestPost(1) = NaN;
Thigmo_Active.Atropine.TestPost(1) = NaN;
ShockZoneEntries.Atropine.TestPost(1) = NaN;
SafeZoneEntries.Atropine.TestPost(1) = NaN;
% Speed_Moving_Unblocked_mean.Atropine.Ext(2) = NaN;


% Physio

for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})

                
                Respi_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_Safe2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_SafeCorner.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_ShockCorner.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Respi_Fz_Middle.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeMiddleEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
                Respi_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi_Fz_Safe2_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Safe2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi_Fz_Middle_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Middle.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi_Fz_ShockCorner_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_ShockCorner.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Respi_Fz_SafeCorner_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_SafeCorner.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Ripples_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                Ripples_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
               
                Ripples_Active_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/ActiveTime.(Name{group}).(Session_type{sess})(mouse);
                Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime.(Name{group}).(Session_type{sess})(mouse);
                Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse);
                Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse);
                
                
                if Ripples_Active_density.(Name{group}).(Session_type{sess})(mouse) == 0
                    Ripples_Active_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) == 0
                    Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) == 0
                    Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) == 0
                    Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Active_density.(Name{group}).(Session_type{sess})(mouse) == Inf
                    Ripples_Active_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) == Inf
                    Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                 if Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) == Inf
                    Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                if Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) == Inf
                    Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
                end
                
                HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_All.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
                HR_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Fz_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_All_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_All.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Active_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                HR_Var_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Var_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Var_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                HR_Var_All.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                
                HR_Var_Active_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Var_Active.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Var_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Var_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Var_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Var_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                HR_Var_All_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Var_All.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
        end
    end
end


for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    Ripples_Active_density.Saline_All_CH.(Session_type{sess})(3) = NaN;
    Ripples_Fz_density.Saline_All_CH.(Session_type{sess})(3) = NaN;
    Ripples_Fz_Shock_density.Saline_All_CH.(Session_type{sess})(3) = NaN;
    Ripples_Fz_Safe_density.Saline_All_CH.(Session_type{sess})(3) = NaN;
     Ripples_Active_density.Saline_BM.(Session_type{sess})(6) = NaN;
    Ripples_Fz_density.Saline_BM.(Session_type{sess})(6) = NaN;
    Ripples_Fz_Shock_density.Saline_BM.(Session_type{sess})(6) = NaN;
    Ripples_Fz_Safe_density.Saline_BM.(Session_type{sess})(6) = NaN;
end

