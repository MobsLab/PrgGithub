
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM

Session_type={'TestPre','Cond','Ext','TestPost'};
Drug_Group={'First_PAG','Night_PAG','Neurons_PAG','First_Eyelid','Saline_Long_SB','Chronic_Flx','Acute_Flx',...
    'Midazolam','Saline_Short','Diazepam_Short','Saline_Short2','Diazepam_Short2','Saline_Long_BM','Diazepam_Long_BM',...
    'Acute_Bus','ChronicBUS','RipControl1','RipInhib1','RipControl2','RipInhib2','RipControl3','RipInhib3'};

ind=1:4;
Group=1:22;

Side={'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze2_BM(group);
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


Var={'Stim #','Stim density','SZ entries #, Cond','SZ entries #, Test Post','SZ entries density, Cond','SZ entries density, Test Post'...
    'Fz prop','Fz shock prop','Fz safe prop','Thigmotaxis'};
Mouse_All=[];
M1=[]; M2=[]; M3=[]; M4=[];  M5=[]; M6=[];  M7=[]; M8=[]; M9=[]; M10=[];
T1=[]; T2=[]; T3=[]; T4=[]; T5=[]; T6=[]; T7=[]; T8=[]; T9=[]; T10=[];

for group=Group
    Mouse=Drugs_Groups_UMaze2_BM(group);
    Mouse_All = [Mouse_All Mouse];
    
    M1 = [M1 ; StimNumber.Cond{group}'];
    M2 = [M2 ; StimDensity.Cond{group}'];
    M3 = [M3 ; ShockEntriesZone.Cond{group}'];
    M4 = [M4 ; ShockEntriesZone.TestPost{group}'];
    M5 = [M5 ; ShockZoneEntries_Density.Cond{group}'];
    M6 = [M6 ; ShockZoneEntries_Density.TestPost{group}'];
    M7 = [M7 ; FreezingAll_prop.Cond{group}'];
    M8 = [M8 ; FreezingShock_prop.Cond{group}'];
    M9 = [M9 ; FreezingSafe_prop.Cond{group}'];
    M10 = [M10 ; Thigmo_score.TestPre{group}'];
    
    
    T1 = [T1 ; nanmedian(StimNumber.Cond{group})];
    T2 = [T2 ; nanmedian(StimDensity.Cond{group})];
    T3 = [T3 ; nanmedian(ShockEntriesZone.Cond{group})];
    T4 = [T4 ; nanmedian(ShockEntriesZone.TestPost{group})];
    T5 = [T5 ; nanmedian(ShockZoneEntries_Density.Cond{group})];
    T6 = [T6 ; nanmedian(ShockZoneEntries_Density.TestPost{group})];
    T7 = [T7 ; nanmedian(FreezingAll_prop.Cond{group})];
    T8 = [T8 ; nanmedian(FreezingShock_prop.Cond{group})];
    T9 = [T9 ; nanmedian(FreezingSafe_prop.Cond{group})];
    T10 = [T10 ; nanmedian(Thigmo_score.TestPre{group})];
    
end

M=[M1 M2 M3 M4 M5 M6 M7 M8 M9 M10];
for m=1:142
    Mouse_names{m} = ['M' num2str(m)];
end

T=[T1 T2 T3 T4 T5 T6 T7 T8 T9 T10];



figure, i=1;
for n=[2 5 6]
    subplot(1,3,i)
    imagesc(eval(['M' num2str(n)]))
    colorbar
    title(Var{n})
    
    i=i+1;
end

figure, n=7;
for i=1:4
    subplot(1,4,i)
    imagesc(eval(['M' num2str(n)]))
    colorbar
    title(Var{n})
    
    n=n+1;
end


figure, i=1;
for n=[2 5 6]
    subplot(1,3,i)
    imagesc(eval(['T' num2str(n)]))
    if i==1; yticks([1:length(Group)]), yticklabels(Drug_Group); end
    colorbar
    title(Var{n})
    
    i=i+1;
end

T(15,10)=.5;
T10(15)=.5;
figure, n=7;
for i=1:4
    subplot(1,4,i)
    imagesc(eval(['T' num2str(n)]))
    if i==1; yticks([1:length(Group)]), yticklabels(Drug_Group); end
    colorbar
    title(Var{n})
    
    n=n+1;
end


figure
PlotCorrelations_BM(M3,M4')
xlabel(Var{3}), ylabel(Var{4})

figure
PlotCorrelations_BM(M2,M8')
xlabel(Var{2}), ylabel(Var{8})


[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(zscore(M) , Mouse_names , Var)

[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(zscore(T(:,[2 5 6 7:10])) , Drug_Group , Var([2 5 6 7:10]))




















