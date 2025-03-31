clear all
close all

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

% Session_type={'TestPre','TestPost','Cond','Ext'};
Session_type={'Cond'};
% Group = [7 8];
Group = [11];
Name = {'Saline_SB','','','','','','Rip_Control','Rip_Inhib','','','Saline','','','','','','Saline_BM_CH','Atropine','','Saline_All_CH','Saline_BM'};


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
%             ThetaPower.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'hpc_theta_power');
            Ripples.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch');
            HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HR_Var.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
%             Aligned_Position.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'alignedposition');
%             Accelero.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'accelero');
%             LinearPosition.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'LinearPosition');
            StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','vhc_stim');
             

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
          TimeSafeZone2.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(SafeZoneEpoch_freezing.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
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
      
            PropShockZone.(Name{group}).(Session_type{sess})(mouse) = TimeShockZone.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            PropSafeZone.(Name{group}).(Session_type{sess})(mouse) = TimeSafeZone.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);
            PropSafeZone2.(Name{group}).(Session_type{sess})(mouse) = TimeSafeZone2.(Name{group}).(Session_type{sess})(mouse) / TimeSession.(Name{group}).(Session_type{sess})(mouse);

            
            Stim_num.(Name{group}).(Session_type{sess})(mouse) = sum(DurationEpoch(StimEpoch.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})))/2000;
            a = length(StimEpoch2.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}));
            Stim_num2.(Name{group}).(Session_type{sess})(mouse) = length(a);
            
            disp(Mouse_names{mouse})
        end
    end
end

OB_Max_Freq.RipControl.Cond.Shock=[4.578 4.501 5.951 5.112 4.807 NaN 3.891 4.578 3.738 NaN];
OB_Max_Freq.RipControl.Cond.Safe=[3.51 4.501 4.272 NaN 4.12 NaN 3.586 3.738 3.204 NaN];

OB_Max_Freq.RipInhib.Cond.Shock=[4.272 4.196 NaN 5.417 4.883 4.959 4.73 4.807 NaN 5.875];
OB_Max_Freq.RipInhib.Cond.Safe=[4.272 5.112 4.578 4.73 4.883 4.807 4.349 4.501 NaN 4.425];


for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            path = FolderList.(Mouse_names{mouse}){1};
            cd(path)
            load behavResources_SB.mat
            NumStimVHC.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = sum(Start(TTLInfo.StimEpoch2))
        end
    end
end


Session_type={'SleepPre','SleepPost'};
Group = [7 8];
Name = {'Saline_SB','','','','','','Rip_Control','Rip_Inhib','','','Saline','','','','','','Saline_BM_CH','Atropine','','Saline_All_CH','Saline_BM'};


for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        if convertCharsToStrings(Session_type{sess})=='SleepPre'
            FolderList=SleepPreSess(1);
        elseif convertCharsToStrings(Session_type{sess})=='SleepPost'
            FolderList=SleepPostSess;
        end
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            
            % variables
            HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
        
        end
    end
end


for group = Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    disp (Name{group})
    for sess=1:length(Session_type)
        if convertCharsToStrings(Session_type{sess})=='SleepPre'
            FolderList=SleepPreSess(1);
        elseif convertCharsToStrings(Session_type{sess})=='SleepPost'
            FolderList=SleepPostSess;
        end
        disp(Session_type{sess})
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            disp(Mouse_names{mouse})
            path = FolderList.(Mouse_names{mouse}){1};
            cd(path)
            
            % variables
            load('StateEpochSB.mat', 'Wake' , 'Sleep' , 'SWSEpoch', 'REMEpoch', 'Epoch');
            OneEpoch = intervalSet(0,3600e4);
            Wake_Epoch = and(Wake,OneEpoch);
            Sleep_Epoch =  and(Sleep,OneEpoch);
            REM_Epoch =  and(REMEpoch,OneEpoch);
            NREM_Epoch = and(SWSEpoch,OneEpoch);
            
            
            
            Wake_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(Wake_Epoch)-Start(Wake_Epoch))/sum(Stop(OneEpoch)-Start(OneEpoch));
            Wake_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(Wake_Epoch))/1e4);
            Wake_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(Wake_Epoch));
            Frag_Wake.(Name{group}).(Session_type{sess})(mouse) = Wake_EpNumb.(Name{group}).(Session_type{sess})(mouse)./Wake_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
            Frag_Wake2.(Name{group}).(Session_type{sess})(mouse) = Wake_EpNumb.(Name{group}).(Session_type{sess})(mouse)./sum(DurationEpoch(Wake_Epoch.(Name{group}).(Session_type{sess})(mouse)));
            HR_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Wake_Epoch);
            HR_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), NREM_Epoch);
            HR_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), REM_Epoch);
            HR_Sleep.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(HR.(Name{group}).(Session_type{sess}).(Mouse_names{mouse}), Sleep_Epoch);
            
            
            Mean_HR_Wake.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Wake.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
            
            if sum(DurationEpoch(Sleep_Epoch)) > 0
                Sleep_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(Sleep_Epoch)-Start(Sleep_Epoch))/sum(Stop(OneEpoch)-Start(OneEpoch));
                Sleep_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(Sleep_Epoch))/1e4);
                Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(Sleep_Epoch));
                Frag_Sleep.(Name{group}).(Session_type{sess})(mouse) = Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse)./Sleep_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                Frag_Sleep2.(Name{group}).(Session_type{sess})(mouse) = Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse)./sum(DurationEpoch(Wake_Epoch.(Name{group}).(Session_type{sess})(mouse)));
                REM_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(REM_Epoch)-Start(REM_Epoch))/sum(Stop(OneEpoch)-Start(OneEpoch));
                REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(REM_Epoch))/1e4);
                REM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(REM_Epoch));
                Frag_REM.(Name{group}).(Session_type{sess})(mouse) = REM_EpNumb.(Name{group}).(Session_type{sess})(mouse)./REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                NREM_prop.(Name{group}).(Session_type{sess})(mouse) = sum(Stop(NREM_Epoch)-Start(NREM_Epoch))/sum(Stop(OneEpoch)-Start(OneEpoch));
                NREM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = nanmean((DurationEpoch(NREM_Epoch))/1e4);
                NREM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = length(Start(NREM_Epoch));
                Frag_NREM.(Name{group}).(Session_type{sess})(mouse) = NREM_EpNumb.(Name{group}).(Session_type{sess})(mouse)./NREM_Dur_mean.(Name{group}).(Session_type{sess})(mouse);
                Mean_HR_Sleep.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_Sleep.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Mean_HR_NREM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_NREM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                Mean_HR_REM.(Name{group}).(Session_type{sess})(mouse) = nanmean(Data(HR_REM.(Name{group}).(Session_type{sess}).(Mouse_names{mouse})));
                
                a = Start(Sleep_Epoch);
                LatencyToSleep.(Name{group}).(Session_type{sess})(mouse) = a(1);
                
            else
                Sleep_prop.(Name{group}).(Session_type{sess})(mouse) = 0;
                Sleep_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = 0;
                Sleep_EpNumb.(Name{group}).(Session_type{sess})(mouse) = 0;
                Frag_Sleep.(Name{group}).(Session_type{sess})(mouse) = NaN;
                REM_prop.(Name{group}).(Session_type{sess})(mouse) = 0;
                REM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = 0;
                REM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = 0;
                Frag_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                NREM_prop.(Name{group}).(Session_type{sess})(mouse) = 0;
                NREM_Dur_mean.(Name{group}).(Session_type{sess})(mouse) = 0;
                NREM_EpNumb.(Name{group}).(Session_type{sess})(mouse) = 0;
                Frag_NREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                Mean_HR_Sleep.(Name{group}).(Session_type{sess})(mouse) = NaN;
                Mean_HR_NREM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                Mean_HR_REM.(Name{group}).(Session_type{sess})(mouse) = NaN;
                LatencyToSleep.(Name{group}).(Session_type{sess})(mouse) = 3600e4;
            end
            clear 'Wake' 'Sleep' 'Epoch' 'a'
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
MakeSpreadAndBoxPlot_CH({FreezeShock_Prop.Saline.Cond FreezeSafe_Prop.Saline.Cond},Cols,X,Legends,1,0);
makepretty_CH

mtitle('Proportion of time spent freezing in zone');
saveFigure_BM(5,'Propfreezing-saline','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/');

%%

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock','Safe','Shock','Safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot_CH({PropShockZone.Rip_Control.TestPre PropSafeZone.Rip_Control.TestPre PropShockZone.Rip_Inhib.TestPre PropSafeZone.Rip_Inhib.TestPre},Cols,X,Legends,1,0);
ylim([0 1.2]);
title('Test Pre')
makepretty_CH
subplot(122)
MakeSpreadAndBoxPlot3_SB({PropShockZone.Rip_Control.TestPost, PropSafeZone2.Rip_Control.TestPost PropShockZone.Rip_Inhib.TestPost, PropSafeZone2.Rip_Inhib.TestPost},Cols,X,Legends,'paired',0,'showpoints',1);
ylim([0 1.2]);
title('Test Post')
makepretty_CH

mtitle('Time spent in zones Test Pre/Post');
saveFigure_BM(1,'test','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/PosterSD1');

%% 

Cols={[1 .5 .5],[1 .5 .5],[.5 .5 1],[.5 .5 1]};
X=[1:4];
Legends={'Shock','Shock','Safe','Safe'};

figure

MakeSpreadAndBoxPlot_CH({FreezeShock_Prop.Rip_Control.Cond FreezeShock_Prop.Rip_Inhib.Cond FreezeSafe_Prop.Rip_Control.Cond FreezeSafe_Prop.Rip_Inhib.Cond},Cols,X,Legends,1,0);

mtitle('Freezing Prop')
saveFigure_BM(3,'Freezing_Prop','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/PosterSD1')

%%

Cols={[1 .5 .5],[.5 .5 1],[1 .5 .5],[.5 .5 1]};
X=[1:4];
Legends={'Shock','Safe','Shock','Safe'};

figure
MakeSpreadAndBoxPlot_CH({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Shock OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,1,0);
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Shock OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
mtitle('Respi')
saveFigure_BM(2,'respi','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/')

Cols = {[1 .5 .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]};
X=[1:4];
Legends={'Shock','Safe','Shock','Safe'};


%%

Cols={[1 1 1],[0.5 0.5 0.5]};
X=[1:2];
Legends={'Rip Control','Rip Inhib'};

figure
MakeSpreadAndBoxPlot_CH({Stim_num.Rip_Control.Cond Stim_num.Rip_Inhib.Cond},Cols,X,Legends,1,0);
makepretty_CH
mtitle('Number of stims')
saveFigure_BM(5,'NumbStims','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/PosterSD1')

%%
Cols={[1 1 1],[0.5 0.5 0.5]};
X=[1:2];
Legends={'Rip Control','Rip Inhib'};

figure
MakeSpreadAndBoxPlot_CH({Stim_num2.Rip_Control.Cond Stim_num2.Rip_Inhib.Cond},Cols,X,Legends,1,0);
makepretty_CH
mtitle('Number of VHC stims')
% saveFigure_BM(5,'NumbStims','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/PosterSD1')

%%


Cols={[1 1 1],[0.5 0.5 0.5],[1 1 1],[0.5 0.5 0.5]};
X=[1:4];
Legends={'Sleep Pre','Sleep Post','Sleep Pre','Sleep Post'};

figure
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({Frag_Sleep.Rip_Control.SleepPre Frag_Sleep.Rip_Control.SleepPost Frag_Sleep.Rip_Inhib.SleepPre Frag_Sleep.Rip_Inhib.SleepPost},Cols,X,Legends,'paired',0,'showpoints',1);
makepretty_CH

mtitle('Sleep fragmentation')



Cols={[1 1 1],[0.5 0.5 0.5],[1 1 1],[0.5 0.5 0.5]};
X=[1:4];
Legends={'Sleep Pre','Sleep Post','Sleep Pre','Sleep Post'};

figure
[pval , stats_out] = MakeSpreadAndBoxPlot3_SB({LatencyToSleep.Rip_Control.SleepPre LatencyToSleep.Rip_Control.SleepPost LatencyToSleep.Rip_Inhib.SleepPre LatencyToSleep.Rip_Inhib.SleepPost},Cols,X,Legends,'paired',0,'showpoints',1);
makepretty_CH

mtitle('Latency to sleep')


Cols={[1 1 1],[0.5 0.5 0.5]};
X=[1:2];
Legends={'Control','Inhib'};

figure
subplot(131)
MakeSpreadAndBoxPlot_CH({Wake_prop.Rip_Control.SleepPost Wake_prop.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('Wake proportion')
ylim([0.1 0.8])
makepretty_CH
subplot(132)
MakeSpreadAndBoxPlot_CH({NREM_prop.Rip_Control.SleepPost NREM_prop.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('NREM proportion')
ylim([0.1 0.8])
makepretty_CH
subplot(133)
MakeSpreadAndBoxPlot_CH({REM_prop.Rip_Control.SleepPost REM_prop.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('REM proportion')
ylim([0 0.12])
makepretty_CH


figure
subplot(121)
MakeSpreadAndBoxPlot_CH({Sleep_prop.Rip_Control.SleepPost Sleep_prop.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('Wake proportion')
makepretty_CH
subplot(122)
MakeSpreadAndBoxPlot_CH({(Sleep_Dur_mean.Rip_Control.SleepPost)./1e4 (Sleep_Dur_mean.Rip_Inhib.SleepPost)./1e4},Cols,X,Legends,1,0);
ylabel('Mean duration ()')
makepretty_CH



Cols={[1 1 1],[0.5 0.5 0.5]};
X=[1:2];
Legends={'Control','Inhib'};

figure
subplot(131)
MakeSpreadAndBoxPlot_CH({Mean_HR_Wake.Rip_Control.SleepPost Mean_HR_Wake.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('Heart Rate Wake (Hz)')
makepretty_CH
subplot(132)
MakeSpreadAndBoxPlot_CH({Mean_HR_NREM.Rip_Control.SleepPost Mean_HR_NREM.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('Heart Rate NREM (Hz)')
makepretty_CH
subplot(133)
MakeSpreadAndBoxPlot_CH({Mean_HR_REM.Rip_Control.SleepPost Mean_HR_REM.Rip_Inhib.SleepPost},Cols,X,Legends,1,0);
ylabel('Heart Rate REM (Hz)')
makepretty_CH

subplot(131)
MakeSpreadAndBoxPlot3_SB({Mean_HR_Wake.Rip_Control.SleepPost Mean_HR_Wake.Rip_Inhib.SleepPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Heart Rate Wake (Hz)')
makepretty_CH
subplot(132)
MakeSpreadAndBoxPlot3_SB({Mean_HR_NREM.Rip_Control.SleepPost Mean_HR_NREM.Rip_Inhib.SleepPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Heart Rate NREM (Hz)')
makepretty_CH
subplot(133)
[pval] = MakeSpreadAndBoxPlot3_SB({Mean_HR_REM.Rip_Control.SleepPost Mean_HR_REM.Rip_Inhib.SleepPost},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Heart Rate REM (Hz)')
makepretty_CH




