

GetAllSalineSessions_BM
Mouse=[117 404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566 666 667 668 669 688,...
    739 777 779 849 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];
Session_type={'Habituation','TestPre','Cond','CondPre','CondPost','TestPost'};
Var_Names = {'thigmotaxis', 'middle time', 'immobility', 'mean speed', 'HR' , 'HRVar','respi'};

for mouse=1:length(Mouse)
    % TestPre variables
    sess=2;
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Sessions_List_ForLoop_BM
    
    Position_tsd.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
    Thigmo_score.(Session_type{sess})(mouse) = Thigmo_From_Position_BM(Position_tsd.(Session_type{sess}).(Mouse_names{mouse}));
    
    ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
    PropTime_Middle.(Session_type{sess})(mouse) = sum(DurationEpoch(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3}))/max(Range(Position_tsd.(Session_type{sess}).(Mouse_names{mouse})));
    for zones=1:5
        ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){zones} = mergeCloseIntervals(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){zones} , 1);
        ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){zones} = dropShortIntervals(ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){zones} , 1);
    end
    MeanArmDur.(Session_type{sess})(mouse) = (nanmean(DurationEpoch(ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){1}))...
        +nanmean(DurationEpoch(ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){2})))/2e4;
    ArmEntries.(Session_type{sess})(mouse) = (length(Start(ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){1}))...
        +length(Start(ZoneEpochCorr.(Session_type{sess}).(Mouse_names{mouse}){2})))/2;
    
    Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
    D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
    ImmobilityTime.(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
    MeanSpeed.(Session_type{sess})(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
    
    HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
    HR_Var.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartratevar');
    
    HR_all.(Session_type{sess})(mouse) = nanmean(Data(HR.(Session_type{sess}).(Mouse_names{mouse})));
    HRVar_all.(Session_type{sess})(mouse) = nanmean(Data(HR_Var.(Session_type{sess}).(Mouse_names{mouse})));
    
    
    Speed_smooth = tsd(Range(Speed.TestPre.(Mouse_names{mouse})) , runmean(Data(Speed.TestPre.(Mouse_names{mouse})) ,9));
    ImmobileEpoch = thresholdIntervals(Speed_smooth , 2 ,'Direction','Below');
    ImmobileEpoch = mergeCloseIntervals(ImmobileEpoch,0.3*1e4);
    ImmEpoch.(Mouse_names{mouse}) = dropShortIntervals(ImmobileEpoch,.3*1e4);
    ImmEp.(Session_type{sess})(mouse) = length(Start(ImmEpoch.(Mouse_names{mouse})));
    ImmMeanDur.(Session_type{sess})(mouse) = nanmean(DurationEpoch(ImmEpoch.(Mouse_names{mouse})))/1e4;
    
    HR_Immobile_all.(Session_type{sess})(mouse) = nanmean(Data(Restrict(HR.(Session_type{sess}).(Mouse_names{mouse}) , ImmEpoch.(Mouse_names{mouse}))));
    
    % Cond variables
    sess=3;
    Sessions_List_ForLoop_BM
    
    % Epochs
    Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
    Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
    TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
    FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_fz_epoch');
    %     FreezeEpoch_camera.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freeze_epoch_camera');
    BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
    UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
    StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch');
    
    ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
    ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_zoneepoch');
    
    ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
    SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
    
    Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
    Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
    
    
    ExtraStim.(Session_type{sess})(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
    ExtraStim_dens.(Session_type{sess})(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    Freeze_prop.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    Freeze_Shock_prop.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    Freeze_Safe_prop.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})));
    Respi_Fz_shock.(Session_type{sess})(mouse) = nanmean(Data(Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}))));
    Respi_Fz_safe.(Session_type{sess})(mouse) = nanmean(Data(Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}))));
    
    disp(Mouse_names{mouse})
end


M_pre = [Thigmo_score.(Session_type{sess}) ; PropTime_Middle.(Session_type{sess}) ; ImmobilityTime.(Session_type{sess}) ;...
    MeanSpeed.(Session_type{sess}) ; MeanArmDur.(Session_type{sess}) ;...
    HR_all.(Session_type{sess}) ; HRVar_all.(Session_type{sess})];
M_pre(5,11) = max(M_pre(5,[1:10 12:end]));
M_pre(1,26:29) = mean(M_pre(1,:));

M = zscore_nan_BM(M_pre');

Var_Names = {'thigmotaxis', 'middle time', 'immobility prop', 'mean speed', 'mean arm duration',...
    'HR' , 'HRVar'};

ind_mice = ~isnan(M_pre(6,:)); ind_var = [1:7];
ind_mice = [1:2 4:25 30:length(Mouse)]; ind_var = 1:5;
[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(M(ind_mice,ind_var) , Mouse_names(ind_mice) , Var_Names(ind_var))

[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(M_pre(ind_var,ind_mice)' , Mouse_names(ind_mice) , Var_Names(ind_var))


figure
PlotCorrelations_BM(M(:,5) , M(:,4)')

PlotCorrelations_BM(M_pre(3,:) , M_pre(4,:)')

figure
PlotCorrelations_BM(M(v2(1),:) , M(v2(end),:))
PlotCorrelations_BM(M(v2(1),:) , M(v2(2),:))


% stims
figure
ind_mice1 = [1:2 4:25];
subplot(121)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , ExtraStim.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(122)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , ExtraStim.Cond(ind_mice2))
axis square


% Freezing prop
figure
ind_mice1 = [1:2 4:25];
subplot(321)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , Freeze_prop.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(322)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , Freeze_prop.Cond(ind_mice2))
axis square


ind_mice1 = [1:2 4:25];
subplot(323)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , Freeze_Shock_prop.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(324)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , Freeze_Shock_prop.Cond(ind_mice2))
axis square


ind_mice1 = [1:2 4:25];
subplot(325)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , Freeze_Safe_prop.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(326)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , Freeze_Safe_prop.Cond(ind_mice2))
axis square


% Respi
figure
ind_mice1 = [1:2 4:25];
subplot(221)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , Respi_Fz_shock.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(222)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , Respi_Fz_shock.Cond(ind_mice2))
axis square


ind_mice1 = [1:2 4:25];
subplot(223)
PlotCorrelations_BM(proj_mice_pre2(ind_mice1) , Respi_Fz_safe.Cond(ind_mice1))
axis square

ind_mice2 = 30:length(Mouse);
subplot(224)
PlotCorrelations_BM(proj_mice_pre2(ind_mice2) , Respi_Fz_safe.Cond(ind_mice2))
axis square



%%
for mouse=1:length(Mouse)
    proj_mice_pre(mouse) = dot(M(mouse,v1) , eig1);
end
proj_mice_pre2=2*(proj_mice_pre-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1; % normalisation [-1 1]



load('/media/nas7/Modelling_Behaviour/Free_Explo_Project/FromBaptiste/Workspace_DrugsOverview_Sal.mat',...
    'ExtraStimNumber','Proportionnal_Time_Freezing_ofZone','Respi_Shock','ImmobilityTime','Speed','ShockEntriesZone')

m = 'pearson';
m = 'spearman';

