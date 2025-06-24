clear all
close all

cd('/media/nas8-2/ProjetEmbReact/transfer')
load('AllSessions.mat');

% GetEmbReactMiceFolderList_BM
% GetAllSalineSessions_BM
Group = [3 4 8];
% Group = [7 3];

Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline','TrueBaseline','Saline','SalineLong','SalineCourt','All'};
% Session_type={'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','ExtPre','ExtPost','Cond','Fear'};
Session_type = {'TestPre','TestPostPre','TestPostPost'};
% Session_type={'CondPre','CondPost','ExtPre','ExtPost','Cond'};
% Session_type = {'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','Cond'};
% Session_type = {'ExtPre','ExtPost'};



RangeLow = linspace(0.1526,20,261);
RangeHigh = linspace(22,98,32);
RangeVHigh = linspace(22,249,94);
RangeLow2 = linspace(1.0681,20,249);


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        disp(Mouse_names{mouse})
        for sess=1:length(Session_type)
            Sessions_List_ForLoop_BM
            disp(Session_type{sess})
            % variables
            Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
            Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
%             ThetaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'hpc_theta_power');
%             GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ob_gamma_power');
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch');
            %             SleepyEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','sleepyepoch');
            HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
            Xtsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'xalignedposition');
            Ytsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'yalignedposition');
            %             Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'accelero');
            %             LinearPosition.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'LinearPosition');
            Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'alignedposition');
            SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','B_Low');
%             SpectroBulbHigh.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','B_High');
         
            
            % epochs
            TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))));
            FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch');
            FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch_withnoise');

            ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch');
            BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse});
            
            try
                StimEpochUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            catch
                StimEpochUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = NaN;
            end
            
            XtsdUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Xtsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            YtsdUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ytsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            XtsdFreezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Xtsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            YtsdFreezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ytsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            XtsdFreezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(XtsdFreezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            YtsdFreezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(YtsdFreezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            XtsdStimUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(XtsdUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Start(StimEpochUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            YtsdStimUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(YtsdUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Start(StimEpochUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            XtsdStim.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Xtsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Start(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            YtsdStim.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ytsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Start(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2};
            ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){4};
            SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5};
            MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){3};
            SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}){5});
            ShockUnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= and(ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            SafeUnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= and(SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeMiddleEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeShockEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeSafe2Epoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeMiddleEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , MiddleZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafeCornerEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            FreezeShockCornerEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockCornerEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                        
            ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            ActiveSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Unblocked_ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Unblocked_ActiveShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Unblocked_ActiveSafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Unblocked_ActiveSafeZone2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveSafe2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            [ShockZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})] = Correct_ZoneEntries_Maze_BM(Unblocked_ActiveShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , Unblocked_ActiveSafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            [ShockZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , SafeZone2Epoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})] = Correct_ZoneEntries_Maze_BM(Unblocked_ActiveShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) , Unblocked_ActiveSafeZone2Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Position_Active_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),and(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            [Thigmo_Active.(Name{group}).(Session_type{sess})(mouse)] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Position_Freezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),and(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),UnblockedEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            [Thigmo_Freezing.(Name{group}).(Session_type{sess})(mouse)] = Thigmo_From_Position_BM(Position_Freezing_Unblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
        end
    end
end


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            
            TimeShockZone.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            TimeSafeZone.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            TimeSession.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            TimeSafeZone2.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            TimeShockUnblocked.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
%             SleepyTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SleepyEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
            % Shock/Safe zone entries
            
            ShockZoneEntries.(Name{group}).(Session_type{sess})(mouse)= length(Start(ShockZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEntries.(Name{group}).(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            ShockZoneEntriesCorr.(Name{group}).(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEntriesCorr.(Name{group}).(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEntries2Corr.(Name{group}).(Session_type{sess})(mouse) = length(Start(SafeZone2Epoch_Corrected.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            ExpeDuration.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
%             FreezeTime_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
            FreezeTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
%             FreezeTime_Shock_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
%             FreezeTime_Safe_camera.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeEpoch_camera.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_Safe2.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafe2Epoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_Middle.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeMiddleEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_SafeCorner.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeSafeCornerEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            FreezeTime_ShockCorner.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeShockCornerEpoch_Behav.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
            ActiveTime.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            ActiveTime_Shock.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            ActiveTime_Safe.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),'s'));
            
            Freeze_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            FreezeShock_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            FreezeSafe_Prop.(Name{group}).(Session_type{sess})(mouse) = FreezeTime_Safe2.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            Active_Prop.(Name{group}).(Session_type{sess})(mouse) = ActiveTime.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
%             SleepyProp.(Name{group}).(Session_type{sess})(mouse) = SleepyTime.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            
            PropShockZone.(Name{group}).(Session_type{sess})(mouse) = TimeShockZone.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            PropSafeZone.(Name{group}).(Session_type{sess})(mouse) = TimeSafeZone.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            PropSafeZone2.(Name{group}).(Session_type{sess})(mouse) = TimeSafeZone2.(Name{group}).(Session_type{sess})(mouse)/ TimeSession.(Name{group}).(Session_type{sess})(mouse);
            
            Stim_num.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/2000;
            Stim_num_unblocked.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(StimEpochUnblocked.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/2000;
         
        end
    end
end


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            
            RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            RespiFzShock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            RespiFzSafe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
%             FastBreathingEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Data(RespiFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),)
            
            RespiFzShock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFzShock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            RespiFzSafe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(RespiFzSafe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            SpectroBulbFz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            SpectroBulbFzShock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            SpectroBulbFzSafe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            MeanSpectroBulb.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            MeanSpectroBulbCorr.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulb.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
            MeanSpectroBulbFzShock.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbFzShock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            MeanSpectroBulbFzSafe.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbFzSafe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            MeanSpectroBulbFzShockCorr.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbFzShock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
            MeanSpectroBulbFzSafeCorr.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbFzSafe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
%             MeanSpectroBulbHigh.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHigh.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             MeanSpectroBulbHighCorr.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHigh.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeHigh;
%             
            HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            HR_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            HR_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            HRVar_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            HRVar_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            HRVar_Fz_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            HRVar_Fz_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            
            Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Ripples_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),FreezeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime.(Name{group}).(Session_type{sess})(mouse);
            Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Shock.(Name{group}).(Session_type{sess})(mouse);
            Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = length(Ripples_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Safe.(Name{group}).(Session_type{sess})(mouse);
            
%             GammaPower_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             GammaPower_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             
%             ThetaPower_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(ThetaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeShockEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             ThetaPower_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(ThetaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), FreezeSafeEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            
%             GammaPower_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(GammaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             GammaPower_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(GammaPower_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             GammaPower_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(GammaPower_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             
%             ThetaPower_Shock_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(ThetaPower_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             ThetaPower_Safe_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(ThetaPower_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            
            
            if Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) == 0
                Ripples_Fz_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            if Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) == 0
                Ripples_Fz_Shock_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
            end
            
            if Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) == 0
                Ripples_Fz_Safe_density.(Name{group}).(Session_type{sess})(mouse) = NaN;
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
            
            
        end
    end
end

Create_Occup_Map_CH

%% Sleep

% GetEmbReactMiceFolderList_BM
% Group = [1 2 3 4];
% Group = [1 2];
% Group = [3 4 7];

% Group = 7;
Session_type={'SleepPre','SleepPostPre','SleepPostPost'};
% Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline','TrueBaseline','Saline','SalineLong'};


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        if convertCharsToStrings(Session_type{sess})=='SleepPre'
            FolderList=SleepPreSess(1);
        elseif convertCharsToStrings(Session_type{sess})=='SleepPostPre'
            FolderList=SleepPostPreSess;
        elseif convertCharsToStrings(Session_type{sess})=='SleepPostPost'
            FolderList=SleepPostPostSess;
        end
        
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            
                        StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch2');
   a = length(StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Stim_num2.(Name{group}).(Session_type{sess})(mouse) = length(a);
            
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            Xtsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'xposition');
            Ytsd.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'yposition');
            HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
%             SpectroHPC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'spectrum','prefix','H_Low');
        end
    end
end


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        if convertCharsToStrings(Session_type{sess})=='SleepPre'
            FolderList=SleepPreSess(1);
        elseif convertCharsToStrings(Session_type{sess})=='SleepPostPre'
            FolderList=SleepPostPreSess;
        elseif convertCharsToStrings(Session_type{sess})=='SleepPostPost'
            FolderList=SleepPostPostSess;
        end
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            path = FolderList.(Mouse_names{mouse}){1};
            cd(path)
            
            % variables
            load('StateEpochSB.mat', 'WakeAcc' , 'SWSEpochAcc', 'REMEpochAcc', 'Epoch');
            %             OneEpoch = intervalSet(0,3600e4);
            %             Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(WakeAcc,OneEpoch);
            %             REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) =  and(REMEpochAcc,OneEpoch);
            %             NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = and(SWSEpochAcc,OneEpoch);
            %             Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) =  or(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = WakeAcc;
            REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) =  REMEpochAcc;
            NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = SWSEpochAcc;
            Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) =  or(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            Tot_Epoch = Epoch;
            Wake_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(Epoch)-Start(Epoch));
            Wake_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4);
            Wake_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            Frag_Wake.(Name{group}).(Session_type{sess})(mouse) = Wake_EpNumb.(Name{group}).(Session_type{sess})(mouse)./Wake_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
%             HR_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             HR_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             HR_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             HRVar_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             HRVar_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             HRVar_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            
            
            
            %             HR_Sleep.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            %
            %
            %             Mean_HR_Wake.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            if sum(DurationEpoch(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))) > 0
                Sleep_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(Tot_Epoch)-Start(Tot_Epoch));
                Sleep_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Frag_Sleep.(Name{group}).(Session_type{sess})(mouse) = Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse)./Sleep_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                REM_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(Tot_Epoch)-Start(Tot_Epoch));
                REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                REM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Frag_REM.(Name{group}).(Session_type{sess})(mouse) = REM_EpNumb.(Name{group}).(Session_type{sess})(mouse)./REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                NREM_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(Tot_Epoch)-Start(Tot_Epoch));
                NREM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                NREM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Frag_NREM.(Name{group}).(Session_type{sess})(mouse) = NREM_EpNumb.(Name{group}).(Session_type{sess})(mouse)./NREM_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                try
                Mean_HR_NREM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Mean_HR_REM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Mean_HRVar_NREM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Mean_HRVar_REM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HRVar_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                catch
                    Mean_HR_Sleep.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    Mean_HR_NREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    Mean_HR_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    Mean_HRVar_Sleep.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    Mean_HRVar_NREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    Mean_HRVar_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                    
                end
                REM_prop2.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                NREM_prop2.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/sum(Stop(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))-Start(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                %
                a = Start(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
                if (a(1) == 0) == 0
                    LatencyToSleep.(Name{group}).(Session_type{sess})(mouse) = a(1)./1e4;
                elseif a(1) == 0
                    LatencyToSleep.(Name{group}).(Session_type{sess})(mouse) = a(2)./1e4;
                end
                
            else
                REM_prop.(Name{group}).(Session_type{sess})(mouse) = 0;
                REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = 0;
                REM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = 0;
                Frag_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                %                 Mean_HR_Sleep.(Name{group}).(Session_type{sess})(mouse) = NaN;
                %                 Mean_HR_NREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                %                 Mean_HR_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                REM_prop2.(Name{group}).(Session_type{sess})(mouse) = 0;
                NREM_prop2.(Name{group}).(Session_type{sess})(mouse) = 0;
                
            end
            
            j = 0;
            for i = 1:10
                Epoch = intervalSet(0+j, 600e4+j);
                try
                    SleepEpochTemp = and(Sleep_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    SleepPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp))/sum(Stop(Epoch)-Start(Epoch));

                    REMEpochTemp = and(REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    REMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    REMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(REMEpochTemp)-Start(REMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));
                                        
                    NREMEpochTemp = and(NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    NREMPropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    NREMPropTemp2.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(NREMEpochTemp)-Start(NREMEpochTemp))/sum(Stop(SleepEpochTemp)-Start(SleepEpochTemp));

                    WakeEpochTemp = and(Wake_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),Epoch);
                    WakePropTemp.(Name{group}).(Session_type{sess})(mouse,i) = sum(Stop(WakeEpochTemp)-Start(WakeEpochTemp))/sum(Stop(Epoch)-Start(Epoch));
                    
                end
                j = j+600e4;
                clear REMEpochTemp  NREMEpochTemp
            end
            
            %             load(strcat(cd,'/ChannelsToAnalyse/dHPC_rip.mat'))
            %              rip_chan.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = channel;
            clear 'WakeAcc' 'Sleep' 'Epoch' 'a' channel
        end
    end
end


% 
% 
% for group = Group
%     Mouse=Drugs_Groups_UMaze_CH(group);
%     disp (Name{group})
%     for sess=1:length(Session_type)
%         if convertCharsToStrings(Session_type{sess})=='SleepPre'
%             FolderList=SleepPreSess(1);
%         elseif convertCharsToStrings(Session_type{sess})=='SleepPostPre'
%             FolderList=SleepPostPreSess;
%         elseif convertCharsToStrings(Session_type{sess})=='SleepPostPost'
%             FolderList=SleepPostPostSess;
%         end
%         
%         disp(Session_type{sess})
%         for mouse=1:length(Mouse)
%             Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%             disp(Mouse_names{mouse})
%             
%             MeanSpectroHPC.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroHPC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             MeanSpectroHPCCorr.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroHPC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
%             SpectroBulbHPC_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(SpectroHPC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),NREM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             SpectroBulbHPC_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})= Restrict(SpectroHPC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),REM_Epoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             MeanSpectroHPC_NREM.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHPC_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             MeanSpectroHPCCorr_NREM.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHPC_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
%             MeanSpectroHPC_REM.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHPC_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
%             MeanSpectroHPCCorr_REM.(Name{group}).(Session_type{sess})(mouse,:)=nanmean(Data(SpectroBulbHPC_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}))).* RangeLow;
%                
%         end
%     end
% end


% 
% Session_type={'SleepPostPre','SleepPostPost'};
% 
% for group = Group
%     Mouse=Drugs_Groups_UMaze_CH(group);
%     disp (Name{group})
%     for sess=1:length(Session_type)
%         if convertCharsToStrings(Session_type{sess})=='SleepPostPre'
%             FolderList=SleepPostPreSess;
%         elseif convertCharsToStrings(Session_type{sess})=='SleepPostPost'
%             FolderList=SleepPostPostSess;
%         end
%         
%         disp(Session_type{sess})
%         for mouse=1:length(Mouse)
%             Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%             disp(Mouse_names{mouse})
% %             LFP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'lfp','ChanNumber',rip_chan.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
% %             Fil_FLP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = FilterLFP(LFP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}),[100 250],96);
%             StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch2');
%             a = length(StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
%             Stim_num2.(Name{group}).(Session_type{sess})(mouse) = length(a);
%             
% %             [m,s,t] = mETAverage(Start(StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Range(LFP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Data(LFP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),1,1000);
% %             [m,s,t] = mETAverage(Start(StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Range(Fil_FLP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),Data(Fil_FLP_rip.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),1,1000);
%             
% %             m2.(Name{group}).(Session_type{sess}){mouse} = m;
% %             s2.(Name{group}).(Session_type{sess}){mouse} = s;
%             
% %             mAll.(Name{group}).(Session_type{sess})(mouse,:) = m2.(Name{group}).(Session_type{sess}){:,mouse}';
% %             sAll.(Name{group}).(Session_type{sess})(mouse,:) = s2.(Name{group}).(Session_type{sess}){:,mouse}';
%         end
%     end
% end
% 
% 
% 
% 
% for group = Group
%     Mouse=Drugs_Groups_UMaze_CH(group);
%     disp (Name{group})
%     for mouse=1:length(Mouse)
%         Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%         disp(Mouse_names{mouse})
%         Stim_num2All.(Name{group})(mouse) = Stim_num2.(Name{group}).SleepPostPre(mouse) + Stim_num2.(Name{group}).SleepPostPost(mouse);
%     end
% end

%% Figures

% Group = [7 3 4];
% Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline'};
Session_type={'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','ExtPre','ExtPost','Cond','Fear'};

figure('color',[1 1 1])

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:6];
Legends={'Shock','Safe','Shock','Safe','Shock','Safe'};

subplot(251)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPre PropSafeZone.Baseline.TestPre PropShockZone.RipControlSleep.TestPre PropSafeZone.RipControlSleep.TestPre PropShockZone.RipInhibSleep.TestPre PropSafeZone.RipInhibSleep.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 0.7]);
ylabel('Prop of time');
title('Test Pre')
makepretty_CH
subplot(252)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPostPre PropSafeZone.Baseline.TestPostPre PropShockZone.RipControlSleep.TestPostPre PropSafeZone.RipControlSleep.TestPostPre PropShockZone.RipInhibSleep.TestPostPre PropSafeZone.RipInhibSleep.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 0.7]);
title('Test PostPre')
makepretty_CH
subplot(253)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPostPost PropSafeZone.Baseline.TestPostPost PropShockZone.RipControlSleep.TestPostPost PropSafeZone.RipControlSleep.TestPostPost PropShockZone.RipInhibSleep.TestPostPost PropSafeZone.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 0.7]);
title('Test PostPost')
makepretty_CH
subplot(256)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPre SafeZoneEntries.Baseline.TestPre ShockZoneEntries.RipControlSleep.TestPre SafeZoneEntries.RipControlSleep.TestPre ShockZoneEntries.RipInhibSleep.TestPre SafeZoneEntries.RipInhibSleep.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 40]);
title('Test Pre')
ylabel('# of entries');
makepretty_CH
subplot(257)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPostPre SafeZoneEntries.Baseline.TestPostPre ShockZoneEntries.RipControlSleep.TestPostPre SafeZoneEntries.RipControlSleep.TestPostPre ShockZoneEntries.RipInhibSleep.TestPostPre SafeZoneEntries.RipInhibSleep.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 40]);
title('Test PostPre')
makepretty_CH
subplot(258)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPostPost SafeZoneEntries.Baseline.TestPostPost ShockZoneEntries.RipControlSleep.TestPostPost SafeZoneEntries.RipControlSleep.TestPostPost ShockZoneEntries.RipInhibSleep.TestPostPost SafeZoneEntries.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 40]);
title('Test PostPost')
makepretty_CH

subplot(254)
MakeSpreadAndBoxPlot3_SB({FreezeShock_Prop.Baseline.Cond FreezeSafe_Prop.Baseline.Cond FreezeShock_Prop.RipControlSleep.Cond FreezeSafe_Prop.RipControlSleep.Cond FreezeShock_Prop.RipInhibSleep.Cond FreezeSafe_Prop.RipInhibSleep.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 0.2]);
title('Freezing prop')
makepretty_CH
 
Cols={[0.7, 0.7, 0.7],[0.7, 0.7, 0.7],[0.7, 0.7, 0.7],[.65, .75, 0],[.65, .75, 0],[.65, .75, 0],[.63, .08, .18],[.63, .08, .18],[.63, .08, .18]};
X=[1:9];
Legends={'TestPre','TestPostPre','TestPostPost','TestPre','TestPostPre','TestPostPost','TestPre','TestPostPre','TestPostPost'};
  
subplot(259)
MakeSpreadAndBoxPlot3_SB({Thigmo_Active.Baseline.TestPre Thigmo_Active.Baseline.TestPostPre Thigmo_Active.Baseline.TestPostPost Thigmo_Active.RipControlSleep.TestPre Thigmo_Active.RipControlSleep.TestPostPre Thigmo_Active.RipControlSleep.TestPostPost Thigmo_Active.RipInhibSleep.TestPre Thigmo_Active.RipInhibSleep.TestPostPre Thigmo_Active.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
title('Thigmotaxis')
makepretty_CH

Cols={[0.8 0.8 0.8],[0.3 0.3 0.3]};
X=[1:2];
Legends={'Control','Inhib'};

subplot(155)
MakeSpreadAndBoxPlot3_SB({Stim_num2.RipControlSleep.SleepPostPre + Stim_num2.RipControlSleep.SleepPostPost Stim_num2.RipInhibSleep.SleepPostPre + Stim_num2.RipInhibSleep.SleepPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
title('Numb of VHC stims')
makepretty_CH


%%

figure('color',[1 1 1])

Cols = {[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};
n = 1;
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    if group == 8
        i = 1;
    elseif group == 3
        i = 6;
        elseif group == 4
        i = 11;
    end
    subplot(3,5,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).Cond RespiFzSafe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1);
    makepretty_CH
    if group == 3
        ylabel('Rip Control','FontSize',15)
    elseif group == 4
        ylabel('Rip Inhib','FontSize',15)
        elseif group == 7
        ylabel('Baseline','FontSize',15)
        
    end
    title('Cond')
    ylim([1.5 5.5])
    if group == 3
        ylabel('Rip Control','FontSize',15)
    elseif group == 4
        ylabel('Rip Inhib','FontSize',15)
    end
    i = i+1;
    subplot(3,5,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPre RespiFzSafe_mean.(Name{group}).CondPre},Cols,X,Legends,'showpoints',1,'paired',1);
    title('CondPre')
    ylim([1.5 5.5])
    makepretty_CH
    i = i+1;
    subplot(3,5,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPre RespiFzSafe_mean.(Name{group}).ExtPre},Cols,X,Legends,'showpoints',1,'paired',1);
    title('ExtPre')
    makepretty_CH
    ylim([1.5 5.5])
    i = i+1;
    subplot(3,5,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPost RespiFzSafe_mean.(Name{group}).CondPost},Cols,X,Legends,'showpoints',1,'paired',1);
    title('CondPost')
    makepretty_CH
    ylim([1.5 5.5])
    i = i+1;
    subplot(3,5,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPost RespiFzSafe_mean.(Name{group}).ExtPost },Cols,X,Legends,'showpoints',1,'paired',1);
    title('ExtPost')
    makepretty_CH
    ylim([1.5 5.5])
    i = i+1;
    n = n+1;
end
mtitle('freezing breathing frequency')




figure('color',[1 1 1])

Cols = {[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};
n = 1;
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    if group == 8
        i = 1;
    elseif group == 3
        i = 5;
        elseif group == 4
        i = 9;
    end
    subplot(3,4,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).Fear RespiFzSafe_mean.(Name{group}).Fear},Cols,X,Legends,'showpoints',1,'paired',1);
    makepretty_CH
    if group == 3
        ylabel('Rip Control','FontSize',15)
    elseif group == 4
        ylabel('Rip Inhib','FontSize',15)
        elseif group == 7
        ylabel('Baseline','FontSize',15)
    end
    title('Fear')
    ylim([1.5 5.5])
    if group == 3
        ylabel('Rip Control','FontSize',15)
    elseif group == 4
        ylabel('Rip Inhib','FontSize',15)
    end
    i = i+1;
    subplot(3,4,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).Cond RespiFzSafe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1);
    title('Cond')
    ylim([1.5 5.5])
    makepretty_CH
    i = i+1;
    subplot(3,4,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPre RespiFzSafe_mean.(Name{group}).CondPre},Cols,X,Legends,'showpoints',1,'paired',1);
    title('ExtPre')
    makepretty_CH
    ylim([1.5 5.5])
    i = i+1;
    subplot(3,4,i)
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPost RespiFzSafe_mean.(Name{group}).CondPost},Cols,X,Legends,'showpoints',1,'paired',1);
    title('CondPost')
    makepretty_CH
    ylim([1.5 5.5])
    i = i+1;
    n = n+1;
end
mtitle('freezing breathing frequency')


%%

figure('color',[1 1 1])
Cols = {[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock','Safe','Shock','Safe'};

subplot(1,5,1)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.Cond RespiFzSafe_mean.RipControlSleep.Cond RespiFzShock_mean.RipInhibSleep.Cond RespiFzSafe_mean.RipInhibSleep.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 5.5])
ylabel('Breathing frequency (Hz)')
title('Cond')
makepretty_CH
subplot(1,5,2)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.CondPre RespiFzSafe_mean.RipControlSleep.CondPre RespiFzShock_mean.RipInhibSleep.CondPre RespiFzSafe_mean.RipInhibSleep.CondPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 5.5])
makepretty_CH
title('CondPre')
subplot(1,5,3)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.ExtPre RespiFzSafe_mean.RipControlSleep.ExtPre RespiFzShock_mean.RipInhibSleep.ExtPre RespiFzSafe_mean.RipInhibSleep.ExtPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 5.5])
makepretty_CH
title('ExtPre')
subplot(1,5,4)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.CondPost RespiFzSafe_mean.RipControlSleep.CondPost RespiFzShock_mean.RipInhibSleep.CondPost RespiFzSafe_mean.RipInhibSleep.CondPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 5.5])
makepretty_CH
title('CondPost')
subplot(1,5,5)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.ExtPost RespiFzSafe_mean.RipControlSleep.ExtPost RespiFzShock_mean.RipInhibSleep.ExtPost RespiFzSafe_mean.RipInhibSleep.ExtPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 5.5])
makepretty_CH
title('ExtPost')
mtitle('Freezing breathing frequency')


figure('color',[1 1 1])
Cols1 = {[1 .5 .5],[1 .5 .5],[1 .5 .5],[1 .5 .5]};
Cols2 = {[.5 .5 1],[.5 .5 1],[.5 .5 1],[.5 .5 1]};
X=[1:4];
Legends={'CondPre','ExtPre','CondPost','ExtPost'};
subplot(221)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipControlSleep.CondPre RespiFzShock_mean.RipControlSleep.ExtPre RespiFzShock_mean.RipControlSleep.CondPost RespiFzShock_mean.RipControlSleep.ExtPost},Cols1,X,Legends,'showpoints',1,'paired',1);
ylabel('Rip Control Breathing (Hz)')
ylim([1 6])
makepretty_CH
subplot(222)
MakeSpreadAndBoxPlot3_SB({RespiFzSafe_mean.RipControlSleep.CondPre RespiFzSafe_mean.RipControlSleep.ExtPre RespiFzSafe_mean.RipControlSleep.CondPost RespiFzSafe_mean.RipControlSleep.ExtPost},Cols2,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylim([1 6])

subplot(223)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.RipInhibSleep.CondPre RespiFzShock_mean.RipInhibSleep.ExtPre RespiFzShock_mean.RipInhibSleep.CondPost RespiFzShock_mean.RipInhibSleep.ExtPost},Cols1,X,Legends,'showpoints',1,'paired',1);
ylabel('Rip Inhib Breathing (Hz)')
makepretty_CH
ylim([1 6])

subplot(224)
MakeSpreadAndBoxPlot3_SB({RespiFzSafe_mean.RipInhibSleep.CondPre RespiFzSafe_mean.RipInhibSleep.ExtPre RespiFzSafe_mean.RipInhibSleep.CondPost RespiFzSafe_mean.RipInhibSleep.ExtPost},Cols2,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylim([1 6])

mtitle('Freezing Breathing evolution');

%%

Cols={[0.8 0.8 0.8],[0.3 0.3 0.3]};
Col1=[1 .5 .5];
Col2=[.5 .5 1];
Col3=[.3 .5 1];
Col4=[1 .2 .5];
X=[1:2];
Legends={'Control','Inhib'};

figure('color',[1 1 1])
subplot(161)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.RipControlSleep.TestPre ShockZoneEntries.RipInhibSleep.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Pre')
makepretty_CH
ylim([0 35])
subplot(262)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipControlSleep.CondPre,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipControlSleep.CondPre,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPre')
ylabel('Control')

subplot(268)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipInhibSleep.CondPre,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipInhibSleep.CondPre,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
ylabel('Inhib')


subplot(163)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.RipControlSleep.TestPostPre ShockZoneEntries.RipInhibSleep.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',0);
title('Test PostPre')
makepretty_CH
ylim([0 35])

subplot(264)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipControlSleep.CondPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipControlSleep.CondPost,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPost')
ylabel('Control')

subplot(2,6,10)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipInhibSleep.CondPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipInhibSleep.CondPost,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
ylabel('Inhib')


subplot(165)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.RipControlSleep.TestPostPost ShockZoneEntries.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post Post')
makepretty_CH
ylim([0 35])

subplot(266)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipControlSleep.ExtPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipControlSleep.ExtPost,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('ExtPost')
ylabel('Control')

subplot(2,6,12)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.RipInhibSleep.ExtPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.RipInhibSleep.ExtPost,'color',Col2);
a.mainLine.LineWidth = 2;
ylabel('Inhib')
xlim([0 10])
ylim([0 1.1])



%%

X=[1:2];
Legends={'Sleep Post Pre','Sleep Post Post'};
Cols={[0.3 0.3 0.3],[0.3 0.3 0.3]};

figure('color',[1 1 1])
subplot(121)
MakeSpreadAndBoxPlot3_SB({Stim_num2.RipControlSleep.SleepPostPre Stim_num2.RipControlSleep.SleepPostPost},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([400 2000])
ylabel('# vhc stims')
title('Rip Control')
makepretty_CH
subplot(122)
MakeSpreadAndBoxPlot3_SB({Stim_num2.RipInhibSleep.SleepPostPre Stim_num2.RipInhibSleep.SleepPostPost},Cols,X,Legends,'showpoints',1,'paired',1);
title('Rip Inhib')
ylabel('# vhc stims')
makepretty_CH
ylim([400 2000])


%%

figure('color',[1 1 1])
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if group == 3
            i = 1;
        elseif group == 4
            i = 6;
        end
        subplot(2,5,i) , hold on
        plot(Data(XtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),'k.'),
        ylim([-0.2 1.2])
        xlim([-0.1 1.1])
        if group == 3
            ylabel('Rip Control','FontSize',15)
        elseif group == 4
            ylabel('Rip Inhib','FontSize',15)
        end
        title('TestPre')
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'k.'), hold on
        ylim([-0.2 1.2])
        xlim([-0.1 1.1])
        title('CondPre')
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),'k.'),
        ylim([-0.2 1.2])
        xlim([-0.1 1.1])
        title('TestPostPre')
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'k.'), hold on
        ylim([-0.2 1.2])
        xlim([-0.1 1.1])
        title('CondPost')
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),'k.'), hold on
        ylim([-0.2 1.2])
        xlim([-0.1 1.1])
        title('TestPostPost')
        
    end
end

hold on

for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if group == 3
            i = 1;
        elseif group == 4
            i = 6;
        end
        subplot(2,5,i), hold on
        plot(Data(XtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'r.','MarkerSize',15)
        plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'r.','MarkerSize',15)
        plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'g.','MarkerSize',10)
        i = i+1;
        subplot(2,5,i), hold on
        plot(Data(XtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),'g.','MarkerSize',10)

    end
end

mtitle('Unblocked - Eyelid stims (red) - Freezing (green)')

%%

figure('color',[1 1 1])
n = 1;
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
        if group == 3
            i = 1;
        elseif group == 4
            i = 6;
        end
        subplot(2,5,i)
        imagesc(OccupMap_squeeze.Active_Unblocked.TestPre{n}), axis xy, caxis([0 0.001]);
        if group == 1
            ylabel('Rip Control','FontSize',15)
        elseif group == 2
            ylabel('Rip Inhib','FontSize',15)
        end
        title('TestPre')
        if group == 3
            ylabel('Rip Control','FontSize',15)
        elseif group == 4
            ylabel('Rip Inhib','FontSize',15)
        end
        i = i+1;
        caxis([0 2e-4])
        subplot(2,5,i)
        imagesc(OccupMap_squeeze.Active_Unblocked.CondPre{n}), axis xy, caxis([0 0.001]);
        title('CondPre')
        i = i+1;
        caxis([0 2e-4])
        subplot(2,5,i)
        imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPre{n}), axis xy, caxis([0 0.001]);
        title('TestPostPre')
        i = i+1;
        caxis([0 2e-4])
        subplot(2,5,i)
        imagesc(OccupMap_squeeze.Active_Unblocked.CondPost{n}), axis xy, caxis([0 0.001]);
        title('CondPost')
        i = i+1;
        caxis([0 2e-4])
        subplot(2,5,i)
        imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPost{n}), axis xy, caxis([0 0.001]);
        title('TestPostPost')
        n = n+1;
        caxis([0 2e-4])
        colormap pink
end
mtitle('Active unblocked')

%%



Cols={[0.8 0.8 0.8],[0.3 0.3 0.3]};
X=[1:2];
Legends={'Control','Inhib'};

figure

subplot(231)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntriesCorr.RipControlSleep.TestPre ShockZoneEntriesCorr.RipInhibSleep.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
title('TestPre')
ylim([0 21])
makepretty_CH
ylabel('Number of entries in shock')

subplot(232)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntriesCorr.RipControlSleep.TestPostPre ShockZoneEntriesCorr.RipInhibSleep.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',0);
title('TestPostPre')
makepretty_CH
ylim([0 21])


subplot(233)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntriesCorr.RipControlSleep.TestPostPost ShockZoneEntriesCorr.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
title('TestPostPost')
makepretty_CH
ylim([0 21])


subplot(234)
MakeSpreadAndBoxPlot3_SB({PropShockZone.RipControlSleep.TestPre PropShockZone.RipInhibSleep.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylim([0 0.4])

ylabel('Prop Shock zone')

subplot(235)
MakeSpreadAndBoxPlot3_SB({PropShockZone.RipControlSleep.TestPostPre PropShockZone.RipInhibSleep.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylim([0 0.4])

subplot(236)
MakeSpreadAndBoxPlot3_SB({PropShockZone.RipControlSleep.TestPostPost PropShockZone.RipInhibSleep.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylim([0 0.4])

%%
figure('color',[1 1 1])

x = 0;
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    
    subplot(2,4,1+x)
    Data_to_use = MeanSpectroBulbFzShock.(Name{group}).Fear;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter, 'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
    Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).Fear;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
    vline(3,'--r')
    legend([s1.mainLine s2.mainLine],'Shock','Safe');
    ylabel(Name{group})
    makepretty
    title('Fear')
    xlim([0 10])
    
    subplot(2,4,2+x)
    Data_to_use = MeanSpectroBulbFzShock.(Name{group}).CondPre;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
    Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).CondPre;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
    vline(3,'--r')
    legend([s1.mainLine s2.mainLine],'Shock','Safe');
    makepretty
    title('CondPre')
    xlim([0 10])
    
    subplot(2,4,3+x)
    clear a;
    for i = 1:length(Mouse)
        a(i,:)=MeanSpectroBulbFzShock.(Name{group}).CondPost(i,:);
    end
    b = length(Mouse);
    for i= 1:length(Mouse)
        a(i+b,:)=MeanSpectroBulbFzShock.(Name{group}).ExtPre(i,:);
    end
    
    Data_to_use = a;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
    clear a;
    for i = 1:length(Mouse)
        a(i,:)=MeanSpectroBulbFzSafe.(Name{group}).CondPost(i,:);
    end
    b = length(Mouse);
    for i= 1:length(Mouse)
        a(i+b,:)=MeanSpectroBulbFzSafe.(Name{group}).ExtPre(i,:);
    end
    Data_to_use = a;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
    vline(3,'--r')
    legend([s1.mainLine s2.mainLine],'Shock','Safe');
    makepretty
    title('CondPost')
    xlim([0 10])
    
    subplot(2,4,4+x)
    Data_to_use = MeanSpectroBulbFzShock.(Name{group}).ExtPost;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
    Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).ExtPost;
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
    vline(3,'--r')
    legend([s1.mainLine s2.mainLine],'Shock','Safe');
    makepretty
    title('ExtPost')
    xlim([0 10])
    
    x  = 4;
    
end

mtitle('Not Normalized')

%%

figure('color',[1 1 1])


x = 0;
for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    
    subplot(2,4,1+x)
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.(Name{group}).Fear,'color','r');
    a.mainLine.LineWidth = 2;
    hold on
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.(Name{group}).Fear,'color','b');
    xlim([0 10])
    ylim([0 1.1])
    title('Fear')
    a.mainLine.LineWidth = 2;
    makepretty_CH
    subplot(2,4,2+x)
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.(Name{group}).CondPre,'color','r');
    a.mainLine.LineWidth = 2;
    hold on
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.(Name{group}).CondPre,'color','b');
    a.mainLine.LineWidth = 2;
    xlim([0 10])
    ylim([0 1.1])
    title('CondPre')
    makepretty_CH
    subplot(2,4,3+x)
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.(Name{group}).CondPost,'color','r');
    a.mainLine.LineWidth = 2;
    hold on
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.(Name{group}).CondPost,'color','b');
    a.mainLine.LineWidth = 2;
    xlim([0 10])
    ylim([0 1.1])
    title('CondPost')
    makepretty_CH
    subplot(2,4,4+x)
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShockCorr.(Name{group}).ExtPost,'color','r');
    a.mainLine.LineWidth = 2;
    hold on
    a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafeCorr.(Name{group}).ExtPost,'color','b');
    a.mainLine.LineWidth = 2;
    xlim([0 10])
    ylim([0 1.1])
    title('ExtPost')
    makepretty_CH
    x = 4;
end

mtitle('Normalized')

%%
Cols={[0.8 0.8 0.8],[0.5 0.5 0.5],[0.8 0.8 0.8],[0.5 0.5 0.5],[0.8 0.8 0.8],[0.5 0.5 0.5]};
X=[1:6];
Legends={'Pre','Pre','PostPre','PostPre','PostPost','PostPost'};

figure('color',[1 1 1])
subplot(121)
MakeSpreadAndBoxPlot3_SB({Frag_Sleep.RipControlSleep.SleepPre Frag_Sleep.RipInhibSleep.SleepPre  Frag_Sleep.RipControlSleep.SleepPostPre Frag_Sleep.RipInhibSleep.SleepPostPre Frag_Sleep.RipControlSleep.SleepPostPost Frag_Sleep.RipInhibSleep.SleepPostPost},Cols,X,Legends,'paired',0,'showpoints',1);
title('Sleep fragmentation')
makepretty_CH
subplot(122)
MakeSpreadAndBoxPlot3_SB({LatencyToSleep.RipControlSleep.SleepPre LatencyToSleep.RipInhibSleep.SleepPre  LatencyToSleep.RipControlSleep.SleepPostPre LatencyToSleep.RipInhibSleep.SleepPostPre LatencyToSleep.RipControlSleep.SleepPostPost LatencyToSleep.RipInhibSleep.SleepPostPost },Cols,X,Legends,'paired',0,'showpoints',1);
title('Latency to sleep')
makepretty_CH



Cols={[0.8 0.8 0.8],[0.5 0.5 0.5],[0.8 0.8 0.8],[0.5 0.5 0.5],[0.8 0.8 0.8],[0.5 0.5 0.5]};
X=[1:6];
Legends={'Pre','Pre','PostPre','PostPre','PostPost','PostPost'};

figure('color',[1 1 1])
subplot(131)
MakeSpreadAndBoxPlot3_SB({Wake_prop.RipControlSleep.SleepPre Wake_prop.RipInhibSleep.SleepPre Wake_prop.RipControlSleep.SleepPostPre Wake_prop.RipInhibSleep.SleepPostPre Wake_prop.RipControlSleep.SleepPostPost Wake_prop.RipInhibSleep.SleepPostPost},Cols,X,Legends,'paired',0,'showpoints',1);
ylabel('Wake proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(132)
MakeSpreadAndBoxPlot3_SB({NREM_prop.RipControlSleep.SleepPre NREM_prop.RipInhibSleep.SleepPre NREM_prop.RipControlSleep.SleepPostPre NREM_prop.RipInhibSleep.SleepPostPre NREM_prop.RipControlSleep.SleepPostPost NREM_prop.RipInhibSleep.SleepPostPost},Cols,X,Legends,'paired',0,'showpoints',1);
ylabel('NREM proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(133)
MakeSpreadAndBoxPlot3_SB({REM_prop.RipControlSleep.SleepPre REM_prop.RipInhibSleep.SleepPre REM_prop.RipControlSleep.SleepPostPre REM_prop.RipInhibSleep.SleepPostPre REM_prop.RipControlSleep.SleepPostPost REM_prop.RipInhibSleep.SleepPostPost},Cols,X,Legends,'paired',0,'showpoints',1);
ylabel('REM proportion')
% ylim([0 0.16])
makepretty_CH

%%


figure
subplot(121)
Data_to_use = mAll.RipInhibSleep.SleepPostPre(:,1:150);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s1 = shadedErrorBar(t(t<0) , Mean_All_Sp , Conf_Inter, 'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
Data_to_use = mAll.RipInhibSleep.SleepPostPre(:,151:end)-1300;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s2 = shadedErrorBar(t(t>=0) , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
title('Sleep Post Pre')
makepretty


subplot(122)
Data_to_use = mAll.RipInhibSleep.SleepPostPost(:,1:150);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s1 = shadedErrorBar(t(t<0) , Mean_All_Sp , Conf_Inter, 'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
Data_to_use = mAll.RipInhibSleep.SleepPostPost(:,151:end)-7000;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s2 = shadedErrorBar(t(t>=0) , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
title('Sleep Post Post')
makepretty

mtitle('Mean shape of rip LFP around stim');


%%

% % [m,s,t]=+.
% [m2,s2,t2]=mETAverage(Start(TTLInfo.StimEpoch2),Range(LFPd),Data(LFPd),1,300);
% [m3,s3,t3]=mETAverage(Start(TTLInfo.StimEpoch2),Range(LFP),Data(LFP),1,300);
% 
% figure, plot(t(t>0),m(t>0)-mean(m(t>0)),'k')
% hold on, plot(t(t<0),m(t<0)-mean(m(t<0)),'k')
% 
% hold on, plot(t2(t2<0),m2(t2<0)-mean(m2(t2<0)),'r')
% hold on, plot(t2(t2>0),m2(t2>0)-mean(m2(t2>0)),'r')
% 
% hold on, plot(t3(t3<0),m3(t3<0)-mean(m3(t3<0)),'b')
% hold on, plot(t3(t3>0),m3(t3>0)-mean(m3(t3>0)),'b')
% 
% line([0 0],ylim,'color','k','linestyle',':')

%%   Overview very long protocol - wo stims


Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline'};
Session_type={'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','ExtPre','ExtPost','Cond','Fear'};

figure('color',[1 1 1])

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

subplot(241)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPre PropSafeZone.Baseline.TestPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
ylabel('Prop of time');
title('Test Pre')
makepretty_CH
subplot(242)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPostPre PropSafeZone.Baseline.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
title('Test PostPre')
makepretty_CH
subplot(243)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Baseline.TestPostPost PropSafeZone.Baseline.TestPostPost },Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
title('Test PostPost')
makepretty_CH
subplot(245)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPre SafeZoneEntries.Baseline.TestPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test Pre')
ylabel('# of entries');
makepretty_CH
subplot(246)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPostPre SafeZoneEntries.Baseline.TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test PostPre')
makepretty_CH
subplot(247)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.Baseline.TestPostPost SafeZoneEntries.Baseline.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test PostPost')
makepretty_CH

subplot(244)
MakeSpreadAndBoxPlot3_SB({FreezeShock_Prop.Baseline.Cond FreezeSafe_Prop.Baseline.Cond},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.2]);
title('Freezing prop')
makepretty_CH
 
Cols={[.65, .75, 0],[.65, .75, 0],[.65, .75, 0]};
X=[1:3];
Legends={'TestPre','TestPostPre','TestPostPost'};
  
subplot(248)
MakeSpreadAndBoxPlot3_SB({Thigmo_Active.Baseline.TestPre Thigmo_Active.Baseline.TestPostPre Thigmo_Active.Baseline.TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('Thigmotaxis')
makepretty_CH

%%

% Cols={[1 .5 .5],[.5 .5 1]};
% X=[1:2];
% Legends={'Shock','Safe'};
% 
% figure
% subplot(121)
% MakeSpreadAndBoxPlot3_SB({GammaPower_Shock_mean.Baseline.Cond GammaPower_Safe_mean.Baseline.Cond},Cols,X,Legends,'showpoints',1,'paired',1,,'optiontest','ttest');
% title('Gamma Power')
% makepretty_CH
% 
% subplot(122)
% MakeSpreadAndBoxPlot3_SB({ThetaPower_Shock_mean.Baseline.Cond ThetaPower_Safe_mean.Baseline.Cond},Cols,X,Legends,'showpoints',1,'paired',1,,'optiontest','ttest');
% title('Theta Power')
% makepretty_CH


%%

figure('color',[1 1 1])

Cols = {[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};
n = 1;
group =7;
i = 1;
Mouse=Drugs_Groups_UMaze_CH(group);
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).Fear RespiFzSafe_mean.(Name{group}).Fear},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('Fear')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPre RespiFzSafe_mean.(Name{group}).CondPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('CondPre')
% ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPre RespiFzSafe_mean.(Name{group}).ExtPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('ExtPre')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPost RespiFzSafe_mean.(Name{group}).CondPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('CondPost')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPost RespiFzSafe_mean.(Name{group}).ExtPost },Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('ExtPost')
ylim([1.5 5.5])
i = i+1;
n = n+1;
makepretty_CH
mtitle('freezing breathing frequency')


%%

figure
Cols={[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3]};
X=[1:7];
Legends={'TestPre','CondPre','PostPre','ExtPre','CondPost','PostPost','ExtPost'};

subplot(131)
MakeSpreadAndBoxPlot3_SB({SleepyProp.Baseline.TestPre SleepyProp.Baseline.CondPre SleepyProp.Baseline.TestPostPre SleepyProp.Baseline.ExtPre SleepyProp.Baseline.CondPost SleepyProp.Baseline.TestPostPost SleepyProp.Baseline.ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
title('sleepy prop')

subplot(132)
MakeSpreadAndBoxPlot3_SB({SleepyTime.Baseline.TestPre SleepyTime.Baseline.CondPre SleepyTime.Baseline.TestPostPre SleepyTime.Baseline.ExtPre SleepyTime.Baseline.CondPost SleepyTime.Baseline.TestPostPost SleepyTime.Baseline.ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
title('sleepy time')

subplot(133)
MakeSpreadAndBoxPlot3_SB({GammaPower_mean.Baseline.TestPre GammaPower_mean.Baseline.CondPre GammaPower_mean.Baseline.TestPostPre GammaPower_mean.Baseline.ExtPre GammaPower_mean.Baseline.CondPost GammaPower_mean.Baseline.TestPostPost GammaPower_mean.Baseline.ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
title('mean gamma power')



%%

figure('color',[1 1 1])
Mouse=Drugs_Groups_UMaze_CH(group);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    i = 1;
    subplot(2,5,i) , hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),'k.'),
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPre')
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('CondPre')
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),'k.'),
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPostPre')
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('CondPost')
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPostPost')
    
end

hold on
Mouse=Drugs_Groups_UMaze_CH(group);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    i = 1;

    subplot(2,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'r.','MarkerSize',15)
    plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'r.','MarkerSize',15)
    plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(2,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),'g.','MarkerSize',10)
    
end

mtitle('Unblocked - Eyelid stims (red) - Freezing (green)')



%%

figure('color',[1 1 1])

n = 1;
Mouse=Drugs_Groups_UMaze_CH(group);
i = 6;
subplot(2,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPre{n}), axis xy, caxis([0 0.001]);

title('TestPre')

i = i+1;
caxis([0 2e-4])
subplot(2,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.CondPre{n}), axis xy, caxis([0 0.001]);
title('CondPre')
i = i+1;
caxis([0 2e-4])
subplot(2,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPre{n}), axis xy, caxis([0 0.001]);
title('TestPostPre')
i = i+1;
caxis([0 2e-4])
subplot(2,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.CondPost{n}), axis xy, caxis([0 0.001]);
title('CondPost')
i = i+1;
caxis([0 2e-4])
subplot(2,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPost{n}), axis xy, caxis([0 0.001]);
title('TestPostPost')
n = n+1;
caxis([0 2e-4])
% colormap pink
% mtitle('Active unblocked')



%%

figure('color',[1 1 1])

Col1 = [1 .5 .5];
Col2 =[.5 .5 1];
x = 0;
Mouse=Drugs_Groups_UMaze_CH(group);

subplot(141)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).Fear,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).Fear,'color',Col2);
xlim([0 10])
ylim([0 1.1])
title('Fear')
a.mainLine.LineWidth = 2;
makepretty_CH
subplot(142)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).CondPre,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).CondPre,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPre')
makepretty_CH
subplot(143)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).CondPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).CondPost,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPost')
makepretty_CH
subplot(144)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).Cond,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).Cond,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('Cond')
makepretty_CH

%%

Cols={[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3]};
X=[1:3];
Legends={'Pre','PostPre','PostPost',};

figure('color',[1 1 1])
subplot(222)
MakeSpreadAndBoxPlot3_SB({Frag_REM.Baseline.SleepPre Frag_REM.Baseline.SleepPostPre Frag_REM.Baseline.SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
title('REM fragmentation')
makepretty_CH
subplot(221)
MakeSpreadAndBoxPlot3_SB({LatencyToSleep.Baseline.SleepPre LatencyToSleep.Baseline.SleepPostPre LatencyToSleep.Baseline.SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
title('Latency to sleep')
makepretty_CH

subplot(234)
MakeSpreadAndBoxPlot3_SB({Wake_prop.Baseline.SleepPre Wake_prop.Baseline.SleepPostPre Wake_prop.Baseline.SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('Wake proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(235)
MakeSpreadAndBoxPlot3_SB({REM_prop.Baseline.SleepPre REM_prop.Baseline.SleepPostPre REM_prop.Baseline.SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('REM proportion all')
% ylim([0.1 0.8])
makepretty_CH
subplot(236)
MakeSpreadAndBoxPlot3_SB({REM_prop2.Baseline.SleepPre REM_prop2.Baseline.SleepPostPre REM_prop2.Baseline.SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('REM proportion sleep')
% ylim([0 0.16])
makepretty_CH

%%

% Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline','TrueBaseline','Saline','SalineLong','SalineCourt'};
% Group = 7;
% Session_type2 = {'CondPre','CondPost'};
Session_type2 = {'Ext'};

for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    for sess = 1:length(Session_type2)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            try
                RespiFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(RespiFzShock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(RespiFzShock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
                RespiFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(RespiFzSafe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(RespiFzSafe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
                RespiFzShockInterp.(Name{group}).(Session_type2{sess})(RespiFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50)<1.5) = NaN;
                RespiFzSafeInterp.(Name{group}).(Session_type2{sess})(RespiFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50)<1.5) = NaN;
                
            catch
                RespiFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
                RespiFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
            end
            try
                HRFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(HR_Fz_Shock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(HR_Fz_Shock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
                HRFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(HR_Fz_Safe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(HR_Fz_Safe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
                HRVarFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(HRVar_Fz_Shock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(HRVar_Fz_Shock.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
                HRVarFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = interp1(linspace(0,1,length(Data(HRVar_Fz_Safe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})))) , Data(HRVar_Fz_Safe.(Name{group}).(Session_type2{sess}).(Mouse_names{mouse})) , linspace(0,1,50));
               
            catch
                HRFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
                HRFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
                HRVarFzShockInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
                HRVarFzSafeInterp.(Name{group}).(Session_type2{sess})(mouse,1:50) = NaN;
                
            end
        end
    end
end


for group = Group
    Mouse=Drugs_Groups_UMaze_CH(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            clear hsh hsa
            hsh = histogram(Data(HRVar_Fz_Shock.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),'NumBins', 72, 'BinLimits',[0,0.35]);
            HistHRVar_Shock.(Name{group}).(Session_type{sess})(mouse,:) = hsh.Values;
            hsa = histogram(Data(HRVar_Fz_Safe.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})),'NumBins', 72, 'BinLimits',[0,0.35]);
            HistHRVar_Safe.(Name{group}).(Session_type{sess})(mouse,:) = hsa.Values;
            values_sh = hsh.Values;
            HistHRVar_Shock.(Name{group}).(Session_type{sess})(mouse,:) = values_sh / sum(values_sh);
            values_sa = hsa.Values;
            HistHRVar_Safe.(Name{group}).(Session_type{sess})(mouse,:) = values_sa / sum(values_sa); 
            
        end
    end
end

figure('Color',[1 1 1])
Cols1 = [1 .5 .5];
Cols2 = [.5 .5 1];
Data_to_use = RespiFzShockInterp.Baseline.CondPre; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(0,1,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on
Data_to_use = RespiFzSafeInterp.Baseline.CondPre; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(0,1,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;
makepretty
% ylim([2 6]);
Data_to_use = RespiFzShockInterp.Baseline.ExtPre; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(1,2,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on
Data_to_use = RespiFzSafeInterp.Baseline.ExtPre; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(1,2,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;
makepretty
Data_to_use = RespiFzShockInterp.Baseline.CondPost; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(2,3,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on
Data_to_use = RespiFzSafeInterp.Baseline.CondPost; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(2,3,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;
makepretty
Data_to_use = RespiFzShockInterp.Baseline.ExtPost; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(3,4,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on
Data_to_use = RespiFzSafeInterp.Baseline.ExtPost; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(3,4,50) , movmean(nanmean(Data_to_use),10,'omitnan') , movmean(Conf_Inter,10,'omitnan'),'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;
makepretty

ylabel('Breathing rate')
legend([h1.mainLine h2.mainLine],'Shock','Safe')
xlabel('time (au)')
hline(4.5,'r--')

%%
% 
% figure('color',[1 1 1])
% 
% x = 0;
% Mouse=Drugs_Groups_UMaze_CH(group);
% 
% subplot(141)
% Data_to_use = MeanSpectroBulbFzShock.(Name{group}).Fear;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter, 'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
% Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).Fear;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
% vline(3,'--r')
% legend([s1.mainLine s2.mainLine],'Shock','Safe');
% ylabel(Name{group})
% makepretty
% title('Fear')
% xlim([0 10])
% 
% subplot(142)
% Data_to_use = MeanSpectroBulbFzShock.(Name{group}).CondPre;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
% Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).CondPre;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
% vline(3,'--r')
% legend([s1.mainLine s2.mainLine],'Shock','Safe');
% makepretty
% title('CondPre')
% xlim([0 10])
% 
% subplot(143)
% clear a;
% for i = 1:length(Mouse)
%     a(i,:)=MeanSpectroBulbFzShock.(Name{group}).CondPost(i,:);
% end
% b = length(Mouse);
% for i= 1:length(Mouse)
%     a(i+b,:)=MeanSpectroBulbFzShock.(Name{group}).ExtPre(i,:);
% end
% 
% Data_to_use = a;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
% clear a;
% for i = 1:length(Mouse)
%     a(i,:)=MeanSpectroBulbFzSafe.(Name{group}).CondPost(i,:);
% end
% b = length(Mouse);
% for i= 1:length(Mouse)
%     a(i+b,:)=MeanSpectroBulbFzSafe.(Name{group}).ExtPre(i,:);
% end
% Data_to_use = a;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
% vline(3,'--r')
% legend([s1.mainLine s2.mainLine],'Shock','Safe');
% makepretty
% title('CondPost')
% xlim([0 10])
% 
% subplot(144)
% Data_to_use = MeanSpectroBulbFzShock.(Name{group}).ExtPost;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s1 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'r',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
% Data_to_use = MeanSpectroBulbFzSafe.(Name{group}).ExtPost;
% Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
% Mean_All_Sp = nanmean(Data_to_use);
% s2 = shadedErrorBar(RangeLow , Mean_All_Sp , Conf_Inter,'b',1); clear Data_to_use Conf_Inter Mean_All_Sp;
% vline(3,'--r')
% legend([s1.mainLine s2.mainLine],'Shock','Safe');
% makepretty
% title('ExtPost')
% xlim([0 10])


% %%
% 
% for sess=1:length(Session_type)
%     Sessions_List_ForLoop_BM
%     disp(Session_type{sess})
%     figure, hold on
%     for mouse=1:length(Mouse)
%         Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%         disp(Mouse_names{mouse})
%         clear sa sh
%         try
%             Data_to_use = runmean_BM(MeanSpectroBulbFzSafe.Baseline.(Session_type{sess})(mouse,:),3);
%             [~,sa]=max(Data_to_use(:,13:end));
%             RespiSafeMean2.Baseline.(Session_type{sess})(mouse) = RangeLow(sa+13);
%             plot(RangeLow, Data_to_use,'b')
%             vline(RespiSafeMean2.Baseline.(Session_type{sess})(mouse),'--b')
%         catch
%             RespiSafeMean2.Baseline.(Session_type{sess})(mouse) = NaN;
%         end
%         try
%             Data_to_use = runmean_BM(MeanSpectroBulbFzShock.Baseline.(Session_type{sess})(mouse,:),3);
%             [~,sh]=max(Data_to_use(:,13:end));
%             RespiShockMean2.Baseline.(Session_type{sess})(mouse) = RangeLow(sh+13);
%             plot(RangeLow, Data_to_use,'r')
%             vline(RespiShockMean2.Baseline.(Session_type{sess})(mouse),'--r')
%         catch
%             RespiShockMean2.Baseline.(Session_type{sess})(mouse) = NaN;
%         end
%     end
%     xlim([0 10])
%     mtitle(Session_type{sess});
% end





