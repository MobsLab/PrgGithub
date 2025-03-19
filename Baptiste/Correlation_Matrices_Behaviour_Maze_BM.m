
%%
clear all
GetAllSalineSessions_BM
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type={'Habituation','TestPre','Cond','CondPre','CondPost','TestPost','Ext'};
Side={'All','Shock','Safe'};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Sessions_List_ForLoop_BM
        
        Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
        Position.(Session_type{sess}).(Mouse_names{mouse}) = Data(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}));
        Position.(Session_type{sess}).(Mouse_names{mouse})(or(Position.(Session_type{sess}).(Mouse_names{mouse})<0 , Position.(Session_type{sess}).(Mouse_names{mouse})>1)) = NaN;
        
        BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
        
        TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}))));
        UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
        
        % generate tsd
        Position_tsd_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Position_tsd_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Position_tsd_Freeze.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Position_tsd_Active.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        Position_tsd_Freeze_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , and(BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        Position_tsd_Freeze_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        
        Position_tsd_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) , and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})));
        
        Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
        Mean_Speed.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
        Mean_Speed_all(mouse,sess) = Mean_Speed.(Session_type{sess}).(Mouse_names{mouse});
        
        Accelero.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
        Mean_Accelero.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Data(Restrict(Accelero.(Session_type{sess}).(Mouse_names{mouse}) , and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
        Mean_Accelero_all(mouse,sess) = Mean_Accelero.(Session_type{sess}).(Mouse_names{mouse});
        
        FreezeEpoch_Cam.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
        Freezing_Cam_Prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(FreezeEpoch_Cam.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
        Freezing_Cam_Prop_all(mouse,sess) = Freezing_Cam_Prop.(Session_type{sess}).(Mouse_names{mouse});
        
        Freezing_Acc_Prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse})));
        Freezing_Acc_Prop_all(mouse,sess) = Freezing_Acc_Prop.(Session_type{sess}).(Mouse_names{mouse});
        
        try
            EyelidEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            ExtraStim_Numb.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(and(EyelidEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            ExtraStim_Numb_all(mouse,sess) = ExtraStim_Numb.(Session_type{sess}).(Mouse_names{mouse});
        end
        
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch_behav');
        ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        for side=1:3
            if side==1
                ZoneEp = TotEpoch;
            elseif side==2
                ZoneEp = ShockZoneEpoch;
            elseif side==3
                ZoneEp = SafeZoneEpoch;
            end
            FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse}));
            FreezeProp.(Side{side})(mouse,sess) = sum(DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/...
                max(Range(Accelero.(Session_type{sess}).(Mouse_names{mouse})));
            FzEpNumber.(Side{side})(mouse,sess) = length(Start(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})));
            FzMeanDuration.(Side{side})(mouse,sess) = nanmean(DurationEpoch(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            Thigmo_score_all.(Side{side})(mouse,sess) =  Thigmo_From_Position_BM(Restrict(Position_tsd_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEp.(Session_type{sess}).(Mouse_names{mouse})));
        end
        
        % zones entries
        Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        TimeSpent_Unblocked_Active_All.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
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
        
        ShockEntriesZone(mouse,sess) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
        SafeEntriesZone(mouse,sess) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
        Ratio_ZoneEntries(mouse,sess) = ShockEntriesZone(mouse,sess)./SafeEntriesZone(mouse,sess);
        ShockZoneEntries_Density(mouse,sess) = ShockEntriesZone(mouse,sess)./(TimeSpent_Unblocked_Active_All.(Session_type{sess}).(Mouse_names{mouse})/60);
        SafeZoneEntries_Density(mouse,sess) = SafeEntriesZone(mouse,sess)./(TimeSpent_Unblocked_Active_All.(Session_type{sess}).(Mouse_names{mouse})/60);
        
    disp(Mouse_names{mouse})
    end
end
Mean_Speed_all(10,3:4) = 4; Mean_Accelero_all2 = log10([Mean_Accelero_all(1:13,:)*1.7 ; Mean_Accelero_all(14:22,:)]);



%%
Data_to_use=[Mean_Speed_all(:,2:6) Freezing_Cam_Prop_all(:,[3 4 5 7])...
    ExtraStim_Numb_all(:,3:5)...
    ShockEntriesZone(:,2:6) SafeEntriesZone(:,2:6) Ratio_ZoneEntries(:,2:6)...
    ShockZoneEntries_Density(:,2:6) SafeZoneEntries_Density(:,2:6)...
    Thigmo_score_all.All(:,2:6) Thigmo_score_all.Safe(:,2:6)...
    FreezeProp.All(:,[3 4 5 7]) FzEpNumber.All(:,[3 4 5 7]) FzMeanDuration.All(:,[3 4 5 7])...
    FreezeProp.Shock(:,[3 4 5 7]) FzEpNumber.Shock(:,[3 4 5 7]) FzMeanDuration.Shock(:,[3 4 5 7])...
    FreezeProp.Safe(:,[3 4 5 7]) FzEpNumber.Safe(:,[3 4 5 7]) FzMeanDuration.Safe(:,[3 4 5 7])...
    ];

Var_Names={'Mean Speed, TestPre','Mean Speed, Cond','Mean Speed, CondPre','Mean Speed, CondPost','Mean Speed, TestPost',...
    'Freeze Cam, Cond','Freeze Cam, CondPre','Freeze Cam, CondPost','Freeze Cam, Ext',...
    'Stim numb, Cond','Stim numb, CondPre','Stim numb, CondPost',...
    'Shock entries, TestPre','Shock entries, Cond','Shock entries, CondPre','Shock entries, CondPost','Shock entries, TestPost',...
    'Safe entries, TestPre','Safe entries, Cond','Safe entries, CondPre','Safe entries, CondPost','Safe entries, TestPost',...
    'Ratio entries, TestPre','Ratio entries, Cond','Ratio entries, CondPre','Ratio entries, CondPost','Ratio entries, TestPost',...
    'Shock entries dens, TestPre','Shock entries dens, Cond','Shock entries dens, CondPre','Shock entries dens, CondPost','Shock entries dens, TestPost',...
    'Safe entries dens, TestPre','Safe entries dens, Cond','Safe entries dens, CondPre','Safe entries dens, CondPost','Safe entries dens, TestPost',...
    'Thigmo, TestPre','Thigmo, Cond','Thigmo, CondPre','Thigmo, CondPost','Thigmo, TestPost',...
    'Thigmo safe, TestPre','Thigmo safe, Cond','Thigmo safe, CondPre','Thigmo safe, CondPost','Thigmo safe, TestPost',...
    'Freeze Prop All, Cond','Freeze Prop All, CondPre','Freeze Prop All, CondPost','Freeze Prop All, Ext',...
    'Freeze Ep Numb All, Cond','Freeze Ep Numb All, CondPre','Freeze Ep Numb All, CondPost','Freeze Ep Numb All, Ext',...
    'Freeze Mean Dur All, Cond','Freeze Mean Dur All, CondPre','Freeze Mean Dur All, CondPost','Freeze Mean Dur All, Ext',...
    'Freeze Prop Shock, Cond','Freeze Prop Shock, CondPre','Freeze Prop Shock, CondPost','Freeze Prop Shock, Ext',...
    'Freeze Ep Numb Shock, Cond','Freeze Ep Numb Shock, CondPre','Freeze Ep Numb Shock, CondPost','Freeze Ep Numb Shock, Ext',...
    'Freeze Mean Dur Shock, Cond','Freeze Mean Dur Shock, CondPre','Freeze Mean Dur Shock, CondPost','Freeze Mean Dur Shock, Ext',...
    'Freeze Prop Safe, Cond','Freeze Prop Safe, CondPre','Freeze Prop Safe, CondPost','Freeze Prop Safe, Ext',...
    'Freeze Ep Numb Safe, Cond','Freeze Ep Numb Safe, CondPre','Freeze Ep Numb Safe, CondPost','Freeze Ep Numb Safe, Ext',...
    'Freeze Mean Dur Safe, Cond','Freeze Mean Dur Safe, CondPre','Freeze Mean Dur Safe, CondPost','Freeze Mean Dur Safe, Ext',...
    };

Data_to_use(isnan(Data_to_use))=0;


[z,mu,sigma] = zscore(Data_to_use);
[Mf , v1, v_selec , eigen_vector] = Correlations_Matrices_Data_BM(z , Mouse , Var_Names);


for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(z,1))
        
        PC_values{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
        
    end
end



%% old
% Data_to_use=zscore(Mean_Accelero_all2')';
Data_to_use=zscore(Mean_Speed_all')';
Data_to_use=Mean_Accelero_all2;
Data_to_use=Freezing_Acc_Prop_all;
Data_to_use=Freezing_Cam_Prop_all;
Data_to_use=zscore(Freezing_Cam_Prop_all);
Data_to_use=Thigmo_score_all;
Data_to_use=zscore(Thigmo_score_all')';



[Data_corr1,p1] = corr(Data_to_use,'type','pearson');
[Data_corr2,p2] = corr(Data_to_use','type','pearson');

[~,v]=sortrows(Data_corr1);
[~,v2]=sortrows(Data_corr2);
Data_corr3 = Data_corr1(v,v);
Data_corr4 = Data_corr2(v2,v2);

[rows1,cols1] = find(p1<.05);
[rows2,cols2] = find(p2<.05);
[rows3,cols3] = find(p1(v,v)<.05);
[rows4,cols4] = find(p2(v2,v2)<.05);

figure
subplot(131)
imagesc(Data_to_use)
colormap redblue
axis square, axis xy
xticks(1:12), xticklabels(Session_type), xtickangle(45)
yticks(1:21), yticklabels(Mouse_names)
colorbar
title('Parameters values by mouse')

subplot(232)
imagesc(Data_corr1)
hold on
plot(rows1,cols1,'*k')
axis square, axis xy
xticks(1:12), xticklabels(Session_type), xtickangle(45)
yticks(1:12), yticklabels(Session_type)
caxis([-1 1])
colorbar
title('Correlations for parameters')

subplot(233)
imagesc(Data_corr2)
hold on
plot(rows2,cols2,'*k')
axis square, axis xy
xticks(1:21), xticklabels(Mouse_names), xtickangle(45)
yticks(1:21), yticklabels(Mouse_names)
caxis([-1 1])
title('Correlations for mice')

subplot(235)
imagesc(Data_corr3)
hold on
plot(rows3,cols3,'*k')
axis square, axis xy
xticks(1:12), xticklabels(Session_type(v)), xtickangle(45)
yticks(1:12), yticklabels(Session_type(v))
caxis([-1 1])
title('Sorted')

subplot(236)
imagesc(Data_corr4)
hold on
plot(rows4,cols4,'*k')
axis square, axis xy
xticks(1:21), xticklabels(Mouse_names(v2)), xtickangle(45)
yticks(1:21), yticklabels(Mouse_names(v2))
caxis([-1 1])
title('Sorted')




% maybe correct that part
for ind=[37 39 46:48 58 60]
    Data_to_use(isnan(Data_to_use(:,ind)),ind)=0;
end

Data_to_use = zscore(Data_to_use);
Data_to_use = zscore_nan_BM(Data_to_use')';

[Data_corr3 , ~ , ~ , v] = OrderMatrix_BM(Data_corr1 ,1);
[Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2 , 1);

[rows1,cols1] = find(p1<.05);
[rows2,cols2] = find(p2<.05);
[rows3,cols3] = find(p1(v,v)<.05);
[rows4,cols4] = find(p2(v2,v2)<.05);


figure
subplot(141)
imagesc(Data_to_use)
colormap redblue
axis square, axis xy
xticks(1:length(Variables)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names)
colorbar
title('Parameters values by mouse')

subplot(242)
imagesc(Data_corr3)
hold on
plot(rows1,cols1,'*k')
axis square, axis xy
xticks(1:length(Variables)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Variables)), yticklabels({''}), ylabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
caxis([-1 1])
colorbar
title('Correlation matrix on behaviour parameters')

subplot(243)
[rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(Data_corr3);
App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

subplot(244)
imagesc(App_Data1)
axis square, axis xy
xticks(1:length(Variables)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Variables)), yticklabels({''}), ylabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
caxis([-1 1])
title('λ1 x PC1')

subplot(246)
imagesc(Data_corr4)
hold on
plot(rows3,cols3,'*k')
axis square, axis xy
xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
caxis([-1 1])
title('Correlation matrix on behaviour parameters')

subplot(247)
[rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

subplot(248)
imagesc(App_Data2)
axis square, axis xy
xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
caxis([-1 1])
title('λ1 x PC1')

a=suptitle('Global approach for bejavioural parameters using matrices correlations'); a.FontSize=20;




