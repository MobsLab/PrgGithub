clear all
GetEmbReactMiceFolderList_BM

Session_type={'Cond','Ext','Fear','TestPre','TestPost'};

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','DZP','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

Group=[5:6 13:16];

Side={'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
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
                
                FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                
                TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse})));
                
                %   1) stims density
                StimNumber.(Session_type{sess}){n}(mouse) = length(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                StimDensity.(Session_type{sess}){n}(mouse) = length(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})))./(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
                
                % 2) shock zone entries
                ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                ShockZoneEntries_Density.(Session_type{sess}){n}(mouse) = ShockEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                SafeZoneEntries_Density.(Session_type{sess}){n}(mouse) = SafeEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                
                % 3) freezing proportion
                FreezingAll_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SafeZone.(Session_type{sess}).(Mouse_names{mouse})));
                
                % 4) thigmo
                [Thigmo_score.(Session_type{sess}){n}(mouse), ~] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                % 5)
                ShockZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                
            end
            disp(Mouse_names{mouse})
        end
        Ratio_ZoneEntries.(Session_type{sess}){n} = ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n};
    end
    n=n+1;
end


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'heartrate','heartratevar','ripples','ob_low','respi_freq_BM');
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


%%
Cols = {[.3, .745, .93],[.3, .545, .93],[.3, .345, .93],[.85, .325, .098],[.65, .325, .098],[.45, .325, .098]};
X = 1:6;
Legends = {'Saline1','Saline2','Saline all','DZP1','DZP2','DZP all'};
NoLegends = {'','','','','',''};
ind=X;

figure
MakeSpreadAndBoxPlot3_SB(StimNumber.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('stim #')

figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(FreezingShock_prop.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
ylabel('freezing shock proportion')
subplot(222)
MakeSpreadAndBoxPlot3_SB(FreezingShock_prop.Ext([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Ext')

subplot(223)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_prop.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing safe proportion')
subplot(224)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_prop.Ext([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);




figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.TestPre([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone entries (#/min)')
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.TestPost([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post')

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.TestPre([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)'), ylim([.3 1.2])
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.2])
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.TestPost([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.2])
title('Test Post')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.TestPre([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone occupancy (prop)')
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.Cond([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.TestPost([1 4 3 2 6 5]),Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post')







