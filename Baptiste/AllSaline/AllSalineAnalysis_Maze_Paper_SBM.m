
GetAllSalineSessions_BM

%%
Session_type={'Cond','TestPre','TestPost'};
Mouse=Drugs_Groups_UMaze_BM(22);
% Var = {'HPC_Low_Spectrum','OB_Low_Spectrum','PFC_Low_Spectrum'};
Var = {'Respi'};
Side = {'All','Shock','Safe'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try
            % variables
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'speed');
            Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
            ThetaPower.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'hpc_theta_power');
            Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples');
            StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch','epochname','stimepoch');
            HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartrate');
            HR_Var.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'heartratevar');
            
            % epochs
            TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Respi.(Session_type{sess}).(Mouse_names{mouse}))));
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_fz_epoch');
            FreezeEpoch_camera.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freeze_epoch_camera');
            
            ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_zoneepoch');
            BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
            UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
            
            ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
            Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
            Active_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
            Active_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
            %
%             for var=1:length(Var)
%                 try
%                     if var==1
%                         Variable = HPC_Low_Spectrum;
%                     elseif var==2
%                         Variable = OB_Low_Spectrum;
%                     elseif var==3
%                         Variable = PFC_Low_Spectrum;
%                     end
%                     
%                     for side=1:3
%                         if side==1
%                             Epoch_to_use = FreezeEpoch;
%                         elseif side==2
%                             Epoch_to_use = Freeze_Shock;
%                         elseif side==3
%                             Epoch_to_use = Freeze_Safe;
%                         end
%                         
%                         TSD.(Var{var}).(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Variable.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use.(Session_type{sess}).(Mouse_names{mouse}));
%                         
%                     end
%                 end
%             end
            
            ExtraStim.(Session_type{sess}).(Mouse_names{mouse}) = and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            %
        end
    end
    disp(Mouse_names{mouse})
end

% Shock/Safe zone entries
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type) % generate all data required for analyses
        
        Sessions_List_ForLoop_BM
        
        try
            ShockZoneEpoch_act.(Session_type{sess}).(Mouse_names{mouse}) = and(ShockZone.(Session_type{sess}).(Mouse_names{mouse}) , and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEpoch_act.(Session_type{sess}).(Mouse_names{mouse}) = and(SafeZone.(Session_type{sess}).(Mouse_names{mouse}) , and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] = Correct_ZoneEntries_Maze_BM(ShockZoneEpoch_act.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_act.(Session_type{sess}).(Mouse_names{mouse}));
        end
        
    end
    disp(Mouse_names{mouse})
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            ExpeDuration.(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeTime_camera.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch_camera.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            FreezeTime.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Shock.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Safe.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            ActiveTime.(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Shock.(Session_type{sess})(mouse) = sum(DurationEpoch(Active_Shock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Safe.(Session_type{sess})(mouse) = sum(DurationEpoch(Active_Safe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            
            Speed_all.(Session_type{sess})(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
            D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
            ImmobilityTime.(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));

            Respi_Shock_Fz.(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            Respi_Safe_Fz.(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            
            Ripples_Shock_Fz.(Session_type{sess})(mouse) = length(Ripples_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Shock.(Session_type{sess})(mouse);
            Ripples_Safe_Fz.(Session_type{sess})(mouse) = length(Ripples_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}))/FreezeTime_Safe.(Session_type{sess})(mouse);
            
            HR_Shock_Fz.(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            HR_Safe_Fz.(Session_type{sess})(mouse) = nanmean(Data(HR_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            
            HR_Var_Shock_Fz.(Session_type{sess})(mouse) = nanmean(Data(HR_Var_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            HR_Var_Safe_Fz.(Session_type{sess})(mouse) = nanmean(Data(HR_Var_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            
            ThetaPower_All.(Session_type{sess})(mouse) = nanmean(Data(ThetaPower.(Session_type{sess}).(Mouse_names{mouse})));
            ThetaPower_All_Fz.(Session_type{sess})(mouse) = nanmean(Data(ThetaPower_Fz.(Session_type{sess}).(Mouse_names{mouse})));
            ThetaPower_Shock_Fz.(Session_type{sess})(mouse) = nanmean(Data(ThetaPower_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            ThetaPower_Safe_Fz.(Session_type{sess})(mouse) = nanmean(Data(ThetaPower_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            
            ExtraStim_all.(Session_type{sess})(mouse) =  length(Start(ExtraStim.(Session_type{sess}).(Mouse_names{mouse})));
            ExtraStim_all_dens.(Session_type{sess})(mouse) =  length(Start(ExtraStim.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
            ExtraStim_all_dens_act.(Session_type{sess})(mouse) =  length(Start(ExtraStim.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/60e4);
            
            ShockZoneEntries.(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
            SafeZoneEntries.(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
            
            ShockZoneEntries_dens.(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
            SafeZoneEntries_dens.(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
            
            ShockZoneEntries_dens_act.(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/60e4);
            SafeZoneEntries_dens_act.(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(and(UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/60e4);
        end
    end
    ShockTime_prop.(Session_type{sess}) = (FreezeTime_Shock.(Session_type{sess})+ActiveTime_Shock.(Session_type{sess}))./ExpeDuration.(Session_type{sess});
    SafeTime_prop.(Session_type{sess}) = (FreezeTime_Safe.(Session_type{sess})+ActiveTime_Safe.(Session_type{sess}))./ExpeDuration.(Session_type{sess});

    FreezeTime_prop.(Session_type{sess}) = FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess});
    FreezeTime_Shock_prop.(Session_type{sess}) = FreezeTime_Shock.(Session_type{sess})./(FreezeTime_Shock.(Session_type{sess})+ActiveTime_Shock.(Session_type{sess}));
    FreezeTime_Safe_prop.(Session_type{sess}) = FreezeTime_Safe.(Session_type{sess})./(FreezeTime_Safe.(Session_type{sess})+ActiveTime_Safe.(Session_type{sess}));
    try
        Respi_Shock_Fz.(Session_type{sess})(Respi_Shock_Fz.(Session_type{sess})==0) = NaN;
        Respi_Safe_Fz.(Session_type{sess})(Respi_Safe_Fz.(Session_type{sess})==0) = NaN;
        HR_Shock_Fz.(Session_type{sess})(HR_Shock_Fz.(Session_type{sess})==0) = NaN;
        HR_Safe_Fz.(Session_type{sess})(HR_Safe_Fz.(Session_type{sess})==0) = NaN;
        HR_Var_Shock_Fz.(Session_type{sess})(HR_Var_Shock_Fz.(Session_type{sess})==0) = NaN;
        HR_Var_Safe_Fz.(Session_type{sess})(HR_Var_Safe_Fz.(Session_type{sess})==0) = NaN;
        Ripples_Shock_Fz.(Session_type{sess})(Ripples_Shock_Fz.(Session_type{sess})==0) = NaN;
        Ripples_Safe_Fz.(Session_type{sess})(Ripples_Safe_Fz.(Session_type{sess})==0) = NaN;
        Respi_Diff.(Session_type{sess}) = Respi_Shock_Fz.(Session_type{sess})-Respi_Safe_Fz.(Session_type{sess});
        ShockZoneEntries.(Session_type{sess})(ShockZoneEntries.(Session_type{sess})==0) = NaN;
        SafeZoneEntries.(Session_type{sess})(SafeZoneEntries.(Session_type{sess})==0) = NaN;
        ShockZoneEntries_dens.(Session_type{sess})(ShockZoneEntries_dens.(Session_type{sess})==0) = NaN;
        SafeZoneEntries_dens.(Session_type{sess})(SafeZoneEntries_dens.(Session_type{sess})==0) = NaN;
        ShockZoneEntries_dens_act.(Session_type{sess})(ShockZoneEntries_dens_act.(Session_type{sess})==0) = NaN;
        SafeZoneEntries_dens_act.(Session_type{sess})(SafeZoneEntries_dens_act.(Session_type{sess})==0) = NaN;
        ExtraStim_all.(Session_type{sess})(ExtraStim_all.(Session_type{sess})==0) = NaN;
        ExtraStim_all_dens.(Session_type{sess})(ExtraStim_all_dens.(Session_type{sess})==0) = NaN;
        ExtraStim_all_dens_act.(Session_type{sess})(ExtraStim_all_dens_act.(Session_type{sess})==0) = NaN;
    end
end
ShockTime_prop.TestPre(1:2) = NaN; ShockTime_prop.TestPost(1:2) = NaN;
SafeTime_prop.TestPre(1:2) = NaN; SafeTime_prop.TestPost(1:2) = NaN;
Speed_all.TestPre(1:2) = NaN; Speed_all.TestPost(1:2) = NaN; 


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            Respi_Fz_Evol.(Session_type{sess})(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
            if isempty(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})))
                Respi_Fz_Evol_Shock.(Session_type{sess})(mouse,:) = NaN(1,100);
            else
                Respi_Fz_Evol_Shock.(Session_type{sess})(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
            end
            if isempty(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})))
                Respi_Fz_Evol_Safe.(Session_type{sess})(mouse,:) = NaN(1,100);
            else
                Respi_Fz_Evol_Safe.(Session_type{sess})(mouse,:) = interp1(linspace(0,1,length(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})))) , Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})) , linspace(0,1,100));
            end
        end
    end
end



%% figures
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

% global overview
figure
subplot(311)
for sess=[2 3 5]
    plot(ExpeDuration.(Session_type{sess})/60), hold on
    xticks([1:length(Mouse)]); xlim([0 length(Mouse)]); xticklabels({''}); xtickangle(45);
end
makepretty
vline(21.5,'--r','PAG'), vline(21.5,'--r','Eyelid')
legend('Cond','Ext','TestPost')
title('Sessions duration'), ylabel('time (min)')

subplot(312)
for sess=[2 3 5]
    plot(FreezeTime.(Session_type{sess})/60), hold on
    xticks([1:length(Mouse)]); xlim([0 length(Mouse)]); xticklabels({''}); xtickangle(45);
end
vline(21.5,'--r'), vline(21.5,'--r')
makepretty
title('Freezing duration'), ylabel('time (min)')

subplot(313)
for sess=[2 3 5]
    plot(FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess})), hold on
    xticks([1:length(Mouse)]); xlim([0 length(Mouse)]); xticklabels(Mouse_names); xtickangle(45);
end
vline(21.5,'--r'), vline(21.5,'--r')
makepretty
title('Freezing proportion'), ylabel('proportion')

a=suptitle('Protocol overview, aversive stimulations, n=50'); a.FontSize=20;


% features freezing & respi
for sess=1:3
    figure
    subplot(221)
    MakeSpreadAndBoxPlot2_SB({FreezeTime_Shock.(Session_type{sess}) FreezeTime_Safe.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0);
    ylabel('time (s)'), title('Freezing duration')
    
    subplot(222)
    MakeSpreadAndBoxPlot2_SB({Respi_Shock_Fz.(Session_type{sess}) Respi_Safe_Fz.(Session_type{sess})},Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Frequency (Hz)'), title('Respiratory rate during freezing')
    ylim([1.2 7.5])
    
    subplot(223)
    PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess}) , FreezeTime_Safe.(Session_type{sess}))
    xlabel('Shock freezing duration (s)'), ylabel('Safe freezing duration (s)')
    xlim([0 2e3]), ylim([0 2e3]), axis square
    grid on
    set(gca , 'Xscale','log'), set(gca , 'Yscale','log')
    
    subplot(224)
    PlotCorrelations_BM(Respi_Shock_Fz.(Session_type{sess}) , Respi_Safe_Fz.(Session_type{sess}))
    xlim([0 7]), ylim([0 7]), axis square
    grid on
    xlabel('Shock freezing frequency (Hz)'), ylabel('Safe freezing frequency (Hz)')
    
    a=suptitle(['Freezing and breathing analysis, Maze, Saline, ' Session_type{sess} ' n=53']); a.FontSize=20;
end

% mice weird
Mouse(find(Respi_Shock_Fz.(Session_type{sess})-Respi_Safe_Fz.(Session_type{sess})<0))


% Time fz = f(time active) 
for sess=1:3 % small correction for 469
ActiveTime_Safe.(Session_type{sess})(9) = NaN;
FreezeTime_Safe.(Session_type{sess})(9) = NaN;
end

figure
for sess=1:3
    subplot(2,3,sess)
    PlotCorrelations_BM(ActiveTime_Shock.(Session_type{sess}) , FreezeTime_Shock.(Session_type{sess})); axis square
    xlabel('Time spent active shock'), ylabel('Time spent freezing shock')
    title(Session_type{sess})
    
    subplot(2,3,sess+3)
    PlotCorrelations_BM(ActiveTime_Safe.(Session_type{sess}) , FreezeTime_Safe.(Session_type{sess})); axis square
    xlabel('Time spent active safe'), ylabel('Time spent freezing safe')
end
a=suptitle('Time spent freezing = f(Time spent active)'); a.FontSize=20;


figure
for sess=1:3
    subplot(2,3,sess)
    PlotCorrelations_BM(ActiveTime_Shock.(Session_type{sess}) , FreezeTime_Safe.(Session_type{sess})); axis square
    xlabel('Time spent active shock'), ylabel('Time spent freezing safe')
    title(Session_type{sess})
    
    subplot(2,3,sess+3)
    PlotCorrelations_BM(ActiveTime_Safe.(Session_type{sess}) , FreezeTime_Shock.(Session_type{sess})); axis square
    xlabel('Time spent active safe'), ylabel('Time spent freezing shock')
end
a=suptitle('Time spent freezing = f(Time spent active)'); a.FontSize=20;


% respi fz = f(time freezing) 
for sess=1:3
    figure
    subplot(221)
    PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess}) , Respi_Shock_Fz.(Session_type{sess})); axis square
    xlabel('fz time shock'), ylabel('respi shock')
    ylim([1 7])
    subplot(223)
    PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess}) , Respi_Safe_Fz.(Session_type{sess})); axis square
    xlabel('fz time shock'), ylabel('respi safe')
    ylim([1 7])
    subplot(222)
    PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess}) , Respi_Shock_Fz.(Session_type{sess})); axis square
    xlabel('fz time safe'), ylabel('respi shock')
    ylim([1 7])
    subplot(224)
    PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess}) , Respi_Safe_Fz.(Session_type{sess})); axis square
    xlabel('fz time safe'), ylabel('respi safe')
    ylim([1 7])
    
    a=suptitle(['Time spent freezing = f(Respi frequency), ' Session_type{sess}]); a.FontSize=20;
end

% zone aversiveness = f(respi fz) 
for sess=1:3
    figure
    subplot(221)
    PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})./(FreezeTime_Shock.(Session_type{sess})+ActiveTime_Shock.(Session_type{sess})) , Respi_Shock_Fz.(Session_type{sess})); axis square
    xlabel('fz proportion shock'), ylabel('respi shock')
    xlim([0 1]), ylim([1 7])
    subplot(223)
    PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})./(FreezeTime_Shock.(Session_type{sess})+ActiveTime_Shock.(Session_type{sess})) , Respi_Safe_Fz.(Session_type{sess})); axis square
    xlabel('fz proportion shock'), ylabel('respi safe')
    xlim([0 1]), ylim([1 7])
    subplot(222)
    PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})./(FreezeTime_Safe.(Session_type{sess})+ActiveTime_Safe.(Session_type{sess})) , Respi_Shock_Fz.(Session_type{sess})); axis square
    xlabel('fz proportion safe'), ylabel('respi shock')
    xlim([0 1]), ylim([1 7])
    subplot(224)
    PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})./(FreezeTime_Safe.(Session_type{sess})+ActiveTime_Safe.(Session_type{sess})) , Respi_Safe_Fz.(Session_type{sess})); axis square
    xlabel('fz proportion safe'), ylabel('respi safe')
    xlim([0 1]), ylim([1 7])
    
    a=suptitle(['Zone aversiveness = f(Respi frequency), ' Session_type{sess}]); a.FontSize=20;
end

% diff respi = f(fz time)
figure
for sess=1:3
    subplot(2,3,sess)
    PlotCorrelations_BM(log10(FreezeTime_Shock.(Session_type{sess})) , Respi_Diff.(Session_type{sess})); axis square
    xlabel('shock freezing time (log scale)'), ylabel('Diff respi shock-safe')
    xlim([0 3.5]), ylim([-1 3.5])
    title(Session_type{sess})
    
    subplot(2,3,sess+3)
    PlotCorrelations_BM(log10(FreezeTime_Safe.(Session_type{sess})) , Respi_Diff.(Session_type{sess})); axis square
    xlabel('safe freezing time (log scale)'), ylabel('Diff respi shock-safe')
    xlim([0 3.5]), ylim([-1 3.5])
end
a=suptitle('Respi diff = f(Freezing time)'); a.FontSize=20;


% learning = f(freq respi)
figure
ActiveTime_Shock.TestPost(1:14)=NaN;
clear A; A=ActiveTime_Shock.TestPost; A(A==0)=1; 
for sess=1:3
    
    subplot(3,3,sess)
    PlotCorrelations_BM(Respi_Shock_Fz.(Session_type{sess}) , log10(A)); axis square
    ylabel('Respi shock fz')
    ylim([0 3]), xlim([-.5 6])
    title(Session_type{sess})
    
    subplot(3,3,sess+3)
    PlotCorrelations_BM(Respi_Safe_Fz.(Session_type{sess}) , log10(A)); axis square
    ylabel('Respi safe fz')
    ylim([0 3]), xlim([-.5 6])
    
    subplot(3,3,sess+6)
    PlotCorrelations_BM(Respi_Diff.(Session_type{sess}) , log10(A)); axis square
    xlabel('time spent shock zone TestPost (log scale)'), ylabel('Diff respi shock-safe')
    ylim([0 3]), xlim([-.5 6])
end
a=suptitle('Learning = f(Respi diff)'); a.FontSize=20;


% evol
figure; n=1;
for sess=2:3
    subplot(1,2,n)
    plot(runmean_BM(nanmean(Respi_Fz_Evol_Shock.(Session_type{sess})),3),'r')
    hold on
    plot(runmean_BM(nanmean(Respi_Fz_Evol_Safe.(Session_type{sess})),3),'b')
    makepretty
    ylim([2 5])
    n=n+1;
end




%% splitting PAG eyelid

figure
PlotCorrelations_BM(ShockZoneEntries.(Session_type{sess})(1:21) , ExtraStim_all.(Session_type{sess})(1:21),'color','r'); axis square
PlotCorrelations_BM(ShockZoneEntries.(Session_type{sess})(22:end) , ExtraStim_all.(Session_type{sess})(22:end),'color','b'); axis square
xlim([0 100]), ylim([0 100])
xlabel('shock zone entries'), ylabel('eyelids stims')
line([0 100], [0 100],'Color','r','LineStyle','--')


% PAG
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(1:21) , ShockZoneEntries.(Session_type{sess})(1:21)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(1:21) , ExtraStim_all.(Session_type{sess})(1:21)); axis square
xlabel('fz time'), ylabel('extra stims')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(1:21) , ShockZoneEntries.(Session_type{sess})(1:21)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(1:21) , ExtraStim_all.(Session_type{sess})(1:21)); axis square
xlabel('shock fz time'), ylabel('extra stims')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(1:21) , ShockZoneEntries.(Session_type{sess})(1:21)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(1:21) , ExtraStim_all.(Session_type{sess})(1:21)); axis square
xlabel('safe fz time'), ylabel('extra stims')


% Eyelid
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ExtraStim_all.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('extra stims')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ExtraStim_all.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('extra stims')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ExtraStim_all.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('extra stims')

a=suptitle('Eyelids, Cond sessions'); a.FontSize=20;


% Eyelid unblocked dens
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ShockZoneEntries_dens.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ExtraStim_all_dens.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('extra stims')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ShockZoneEntries_dens.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ExtraStim_all_dens.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('extra stims')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ShockZoneEntries_dens.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ExtraStim_all_dens.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('extra stims')

a=suptitle('Eyelids, density unblocked epoch, Cond sessions'); a.FontSize=20;


% Eyelid unblocked dens when active
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('extra stims')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('extra stims')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('extra stims')

a=suptitle('Eyelids, density unblocked active epoch, Cond sessions'); a.FontSize=20;


% Eyelid unblocked dens when active, freezing prop
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime_prop.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime_prop.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('fz time'), ylabel('extra stims')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock_prop.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock_prop.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('shock fz time'), ylabel('extra stims')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe_prop.(Session_type{sess})(22:end) , ShockZoneEntries_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe_prop.(Session_type{sess})(22:end) , ExtraStim_all_dens_act.(Session_type{sess})(22:end)); axis square
xlabel('safe fz time'), ylabel('extra stims')

a=suptitle('Eyelids, density unblocked active epoch, freezing prop, Cond sessions'); a.FontSize=20;


% Freeze Cond & SZ entries TestPost 
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

a=suptitle('Eyelids, density unblocked active epoch, freezing prop, Cond sessions'); a.FontSize=20;


% Freeze prop Cond & SZ entries TestPost 
figure, sess=2;
subplot(321)
PlotCorrelations_BM(FreezeTime_prop.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(322)
PlotCorrelations_BM(FreezeTime_prop.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(323)
PlotCorrelations_BM(FreezeTime_Shock_prop.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(324)
PlotCorrelations_BM(FreezeTime_Shock_prop.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')

subplot(325)
PlotCorrelations_BM(FreezeTime_Safe_prop.(Session_type{sess})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('safe fz time'), ylabel('shock zone entries')

subplot(326)
PlotCorrelations_BM(FreezeTime_Safe_prop.(Session_type{sess})(22:end) , ActiveTime_Shock.TestPost(22:end)); axis square
xlabel('shock fz time'), ylabel('shock zone entries')




figure, sess=2;
subplot(131)
PlotCorrelations_BM(ShockZoneEntries.(Session_type{2})(22:end) , FreezeTime.(Session_type{2})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')

subplot(132)
PlotCorrelations_BM(ShockZoneEntries.(Session_type{2})(22:end) , ShockZoneEntries.(Session_type{5})(22:end)); axis square
xlabel('fz time'), ylabel('shock zone entries')



%% add mean spectrum

Session_type = {'Cond','Ext'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'ob_low','hpc_low','pfc_low','ob_pfc_coherence','hpc_pfc_coherence');
end



figure, sess=1;
[~ , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:)), 'color' , 'b' , 'threshold' , 13);
[~ , MaxPowerValues3] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,:)), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues4] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,:)), 'color' , 'b' , 'threshold' , 65);
[~ , MaxPowerValues5] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,5,:)), 'color' , 'b' , 'threshold' , 26);
[~ , MaxPowerValues6] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,6,:)), 'color' , 'b' , 'threshold' , 26);
clf


subplot(131)
clear D; D=squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [1 .5 .5] , 'threshold' , 13 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']') , 'smoothing' , 3 , 'dashed_line' , 0);

clear D; D=squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [.5 .5 1] , 'threshold' , 13 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']') , 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(Freq_Max1)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(Freq_Max2)); set(v2,'LineStyle','--','Color',[.5 .5 1])
title('Olfactory bulb')

subplot(132)
clear D; D=squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,5,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [1 .5 .5] , 'threshold' , 65 , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']') , 'smoothing' , 3 , 'dashed_line' , 0);
clear D; D=squeeze(OutPutData.(Session_type{sess}).hpc_low.mean(:,6,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [.5 .5 1] , 'threshold' , 65 , 'power_norm_value' , max([MaxPowerValues3' MaxPowerValues4']') , 'smoothing' , 3 , 'dashed_line' , 0);

xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1.7]); box off
makepretty_BM
v1=vline(nanmean(Freq_Max1)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(Freq_Max2)); set(v2,'LineStyle','--','Color',[.5 .5 1])
title('Hippocampus')

subplot(133)
clear D; D=squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,5,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [1 .5 .5] , 'threshold' , 26 , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']') , 'smoothing' , 3 , 'dashed_line' , 0);
clear D; D=squeeze(OutPutData.(Session_type{sess}).pfc_low.mean(:,6,:)); D(D==0)=NaN;
h = Plot_MeanSpectrumForMice_BM(D, 'color' , [.5 .5 1] , 'threshold' , 26 , 'power_norm_value' , max([MaxPowerValues5' MaxPowerValues6']') , 'smoothing' , 3 , 'dashed_line' , 0);

xlabel('Frequency (Hz)'); xlim([0 10]); ylim([0 1]); box off
makepretty_BM
v1=vline(nanmean(Freq_Max1)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(Freq_Max2)); set(v2,'LineStyle','--','Color',[.5 .5 1])
title('Prefrontal cortex')

a=suptitle('Mean spectrum during freezing'); a.FontSize=15;



[a , MaxPowerValues1] = max(DATA.OB_Low_Spectrum.Shock.(Session_type{sess})(:,10:end)');
[b , MaxPowerValues2] = max(DATA.OB_Low_Spectrum.Safe.(Session_type{sess})(:,10:end)');

MaxPowerValues1(MaxPowerValues1==1) = NaN;
MaxPowerValues2(MaxPowerValues2==1) = NaN;

MaxPowerValues1=Spectro{3}(MaxPowerValues1(~isnan(MaxPowerValues1))+9);
MaxPowerValues2=Spectro{3}(MaxPowerValues2(~isnan(MaxPowerValues2))+9);


figure
MakeSpreadAndBoxPlot3_SB({MaxPowerValues1 MaxPowerValues2},Cols,X,Legends,'showpoints',1,'paired',0);


MaxPowerValues1(MaxPowerValues1>7)=NaN;


%% Zones
GetAllSalineSessions_BM
Session_type={'Cond','TestPre','TestPost','Fear'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=4%1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch_behav');
        
        ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2};
        [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] = Correct_ZoneEntries_Maze_BM(...
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch_behav');
        FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
    
        disp(Mouse_names{mouse})
    end
end



for sess=4%1:3
    for mouse=1:length(Mouse)
%         try
%             PropTime_Shock.(Session_type{sess})(mouse) = sum(DurationEpoch(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/(4*180e4);
%             PropTime_Safe.(Session_type{sess})(mouse) = sum(DurationEpoch(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/(4*180e4);
%         end
%         try
%             Entries_Shock.(Session_type{sess})(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
%             Entries_Safe.(Session_type{sess})(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
%         end
%         try
%             clear Sta Sto
%             Sta  = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
%             Latency_Shock.(Session_type{sess})(mouse) = Sta(1);
%             Sto  = Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
%             Latency_Safe.(Session_type{sess})(mouse) = Sto(1);
%         end
%         PropTime_Shock.(Session_type{sess})(PropTime_Shock.(Session_type{sess})==0)=NaN; PropTime_Safe.(Session_type{sess})(PropTime_Safe.(Session_type{sess})==0)=NaN;
%         Entries_Shock.(Session_type{sess})(Entries_Shock.(Session_type{sess})==0)=NaN; Entries_Safe.(Session_type{sess})(Entries_Safe.(Session_type{sess})==0)=NaN;
%         Latency_Shock.(Session_type{sess})(Latency_Shock.(Session_type{sess})==0)=NaN; Latency_Safe.(Session_type{sess})(Latency_Safe.(Session_type{sess})==0)=NaN;
%         
        Freeze_Shock_TotDur.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
        Freeze_Safe_TotDur.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
        Freeze_Shock_MedDur.(Session_type{sess})(mouse) = nanmedian(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
        Freeze_Safe_MedDur.(Session_type{sess})(mouse) = nanmedian(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}))/1e4);
        
    end
end






figure
subplot(321)
A = PropTime_Shock.TestPre;
B = PropTime_Safe.TestPre;
ind=or(A>.7,B>.7); % remove mice that spent more than 70% of time in shock zone. 3/51 : 436   469   471.
A(ind) = NaN;
B(ind) = NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)

subplot(322)
A = PropTime_Shock.TestPost;
B = PropTime_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)


subplot(323)
A = Entries_Shock.TestPre;
B = Entries_Safe.TestPre;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 30]), ylabel('entries number')
[h,p] = ttest(A , B)

subplot(324)
A = Entries_Shock.TestPost;
B = Entries_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 30]), ylabel('entries number')
[h,p] = ttest(A , B)


subplot(325)
A = Latency_Shock.TestPre;
B = Latency_Safe.TestPre;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 600]), ylabel('latency first entry (s)')
[h,p] = ttest(A , B)

subplot(326)
A = Latency_Shock.TestPost;
B = Latency_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 600]), ylabel('latency first entry (s)')
[h,p] = ttest(A , B)



%%
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Freeze_Shock_TotDur.Fear Freeze_Safe_TotDur.Fear},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('total freezing duration (s)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Freeze_Shock_MedDur.Fear Freeze_Safe_MedDur.Fear},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('freezing episode median (s)')









