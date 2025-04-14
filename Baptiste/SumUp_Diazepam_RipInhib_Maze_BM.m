
clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

% Session_type={'Fear','Cond','Ext','TestPost','TestPre','Hab'};
% Session_type={'TestPre','Cond','TestPost','Ext','Fear'};
Session_type={'Cond','TestPost'};

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

Group=[13 15];
Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','Diazepam'};

Group=[7 8];
Cols = {[.65, .75, 0],[.63, .08, .18]};
X = 1:2;
Legends = {'RipControl','RipInhib'};

ind=1:4;
Side = {'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};
NoLegends = {'','','',''};


%%
n=1;
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
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
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch_withnoise');
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
                StimNumber.(Session_type{sess}){n}(mouse) = length(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                StimDensity.(Session_type{sess}){n}(mouse) = length(Start(StimEpoch.(Session_type{sess}).(Mouse_names{mouse})))./(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
                
                % 2) shock zone entries
                ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                ShockZoneEntries_Density.(Session_type{sess}){n}(mouse) = ShockEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                SafeZoneEntries_Density.(Session_type{sess}){n}(mouse) = SafeEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                %
                % 3) freezing proportion
                FreezingAll_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SafeZone.(Session_type{sess}).(Mouse_names{mouse})));
                
                % 4) thigmo
                [Thigmo_score.(Session_type{sess}){n}(mouse), ~] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                % 5) occupancy
                ShockZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                SafeZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(SafeZone.(Session_type{sess}).(Mouse_names{mouse})))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                Zone2_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(Zone2.(Session_type{sess}).(Mouse_names{mouse})))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                %
                % 6) duration
                Freezing_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezingShock_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezingSafe_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                
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
                
                % Mean speed
                MeanSpeed.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))));
                
            end
            disp(Mouse_names{mouse})
        end
        Ratio_ZoneEntries.(Session_type{sess}){n} = ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n};
    end
    n=n+1;
end

Trajectories_Function_Maze_BM

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition');
    end
end


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData2.(Drug_Group{group}).(Session_type{sess}) , ~ , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'ob_low');
    end
end



for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        try
            figure, [~ , ~ , Freq_Max_Shock.(Drug_Group{group}).(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))); close
            figure, [~ , ~ , Freq_Max_Safe.(Drug_Group{group}).(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))); close
        end
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

%% 
Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = 1:4;
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','','','',''};
ind=X;


figure
MakeSpreadAndBoxPlot3_SB(StimNumber.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('stim #')


figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(FreezingShock_prop.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
ylabel('freezing shock proportion')
subplot(222)
MakeSpreadAndBoxPlot3_SB(FreezingShock_prop.Ext,Cols,X,Legends,'showpoints',1,'paired',0);
title('Ext')

subplot(223)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_prop.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing safe proportion')
subplot(224)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_prop.Ext,Cols,X,Legends,'showpoints',1,'paired',0);


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.TestPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone entries (#/min)')
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(ShockZoneEntries_Density.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.TestPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)'), ylim([.3 1.2])
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.2])
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.3 1.2])
title('Test Post')


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.TestPre,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone occupancy (prop)')
title('Test Pre')
subplot(132)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
title('Cond')
subplot(133)
MakeSpreadAndBoxPlot3_SB(ShockZone_Occupancy.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
title('Test Post')




%%
Cols = {[1 .5 .5],[1 .3 .3],[.5 .5 1],[.3 .3 1]};
X = 1:4;
Legends = {'Shock Saline','Shock DZP','Safe Saline','Safe DZP'};
NoLegends = {'','','',''};
ind=X;


% for sess=2:3
%     figure
%     [~ , ~ , Freq_Max1.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.SalineSB.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
%     [~ , ~ , Freq_Max2.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.SalineSB.(Session_type{sess}).ob_low.mean(:,6,:)) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
%     [~ , ~ , Freq_Max3.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.ChronicFlx.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
%     [~ , ~ , Freq_Max4.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.ChronicFlx.(Session_type{sess}).ob_low.mean(:,6,:)) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
% %     close
% end

% figure
% subplot(121)
% MakeSpreadAndBoxPlot3_SB({Freq_Max1.Cond Freq_Max3.Cond Freq_Max2.Cond Freq_Max4.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
% ylim([1 6.5]), ylabel('Breathing (Hz)')
% title('Cond')
% 
% subplot(122)
% MakeSpreadAndBoxPlot3_SB({Freq_Max1.Ext Freq_Max3.Ext Freq_Max2.Ext Freq_Max4.Ext},Cols,X,Legends,'showpoints',1,'paired',0);
% ylim([1 6.5])
% title('Ext')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.Saline_short_all.Cond.Shock OB_Max_Freq.DZP_short_all.Cond.Shock...
OB_Max_Freq.Saline_short_all.Cond.Safe OB_Max_Freq.DZP_short_all.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 6.5]), ylabel('Breathing (Hz)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.Saline_short_all.Ext.Shock OB_Max_Freq.DZP_short_all.Ext.Shock...
OB_Max_Freq.Saline_short_all.Ext.Safe OB_Max_Freq.DZP_short_all.Ext.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 6.5])
title('Ext')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HR_Shock.Cond{1} HR_Shock.Cond{2}...
HR_Safe.Cond{1} HR_Safe.Cond{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([8 13]), ylabel('Heart rate (Hz)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({HR_Shock.Ext{1} HR_Shock.Ext{2}...
HR_Safe.Ext{1} HR_Safe.Ext{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([8 13])
title('Ext')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HRVar_Shock.Cond{1} HRVar_Shock.Cond{2}...
HRVar_Safe.Cond{1} HRVar_Safe.Cond{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .35]), ylabel('Heart rate variability (a.u.)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({HRVar_Shock.Ext{1} HRVar_Shock.Ext{2}...
HRVar_Safe.Ext{1} HRVar_Safe.Ext{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .35])
title('Ext')



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Cond{1} Ripples_Shock.Cond{2}...
Ripples_Safe.Cond{1} Ripples_Safe.Cond{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.8]), ylabel('Ripples occurence (#/s)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Ext{1} Ripples_Shock.Ext{2}...
Ripples_Safe.Ext{1} Ripples_Safe.Ext{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.8])
title('Ext')





Cols = {[1 .5 .5],[1 .3 .3],[.5 .5 1],[.3 .3 1]};
X = 1:4;
Legends = {'Shock Rip Control','Shock Rip Inhib','Safe Rip Control','Safe Rip Inhib'};
NoLegends = {'','','',''};
ind=X;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 6.5]), ylabel('Breathing (Hz)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Ext.Shock OB_Max_Freq.RipInhib.Ext.Shock...
OB_Max_Freq.RipControl.Ext.Safe OB_Max_Freq.RipInhib.Ext.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 6.5])
title('Ext')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HR_Shock.Cond{3} HR_Shock.Cond{4}...
HR_Safe.Cond{3} HR_Safe.Cond{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([8 13]), ylabel('Heart rate (Hz)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({HR_Shock.Ext{3} HR_Shock.Ext{4}...
HR_Safe.Ext{3} HR_Safe.Ext{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([8 13])
title('Ext')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HRVar_Shock.Cond{3} HRVar_Shock.Cond{4}...
HRVar_Safe.Cond{3} HRVar_Safe.Cond{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .35]), ylabel('Heart rate variability (a.u.)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({HRVar_Shock.Ext{3} HRVar_Shock.Ext{4}...
HRVar_Safe.Ext{3} HRVar_Safe.Ext{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .35])
title('Ext')



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Cond{3} Ripples_Shock.Cond{4}...
Ripples_Safe.Cond{3} Ripples_Safe.Cond{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 2]), ylabel('Ripples occurence (#/s)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Ext{3} Ripples_Shock.Ext{4}...
Ripples_Safe.Ext{3} Ripples_Safe.Ext{4}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.8])
title('Ext')






%%


figure
a=barh([2 1],[-nanmean(FreezingShock_prop.Cond{1}); -nanmean(FreezingShock_prop.Cond{2})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_prop.Cond{1}),2,nanstd(FreezingShock_prop.Cond{1})/sqrt(length(FreezingShock_prop.Cond{1})),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_prop.Cond{2}),1,nanstd(FreezingShock_prop.Cond{2})/sqrt(length(FreezingShock_prop.Cond{2})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_prop.Cond{1}); nanmean(FreezingSafe_prop.Cond{2})],'stacked'); 
errorbar(nanmean(FreezingSafe_prop.Cond{1}),2,0,nanstd(FreezingSafe_prop.Cond{1})/sqrt(length(FreezingSafe_prop.Cond{1})),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_prop.Cond{2}),1,0,nanstd(FreezingSafe_prop.Cond{2})/sqrt(length(FreezingSafe_prop.Cond{2})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing proportion')
yticklabels({'Chronic flx','Saline'}), 
makepretty_BM2
xlim([-.2 .2])

[p(1),h,stats] = ranksum(FreezingShock_prop.Cond{1} , FreezingShock_prop.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_prop.Cond{1} , FreezingSafe_prop.Cond{2});
p

lim=-.08;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.1,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.18;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.19,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



% 2nd way
figure
a=barh([2 1],[-nanmean(FreezingShock_Dur.Cond{1}); -nanmean(FreezingShock_Dur.Cond{2})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_Dur.Cond{1}),2,nanstd(FreezingShock_Dur.Cond{1})/sqrt(length(FreezingShock_Dur.Cond{1})),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_Dur.Cond{2}),1,nanstd(FreezingShock_Dur.Cond{2})/sqrt(length(FreezingShock_Dur.Cond{2})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_Dur.Cond{1}); nanmean(FreezingSafe_Dur.Cond{2})],'stacked'); 
errorbar(nanmean(FreezingSafe_Dur.Cond{1}),2,0,nanstd(FreezingSafe_Dur.Cond{1})/sqrt(length(FreezingSafe_Dur.Cond{1})),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_Dur.Cond{2}),1,0,nanstd(FreezingSafe_Dur.Cond{2})/sqrt(length(FreezingSafe_Dur.Cond{2})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing proportion')
yticklabels({'Chronic flx','Saline'}), 
makepretty_BM2
xlim([-600 600])

[p(1),h,stats] = ranksum(FreezingShock_Dur.Cond{1} , FreezingShock_Dur.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_Dur.Cond{1} , FreezingSafe_Dur.Cond{2});
p

lim=-.3;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.32,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.25;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.27,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




