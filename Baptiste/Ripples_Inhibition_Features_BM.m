

%% Ripples inhibition overview, methodological part
clear all
GetEmbReactMiceFolderList_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib'};
Group=7:8;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        ShockZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) = ZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}){1};
        SafeZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) = or(ZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}){2},ZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}){5});
        VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
        Around_VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = intervalSet(Start(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))-100 , Start(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))+100);
        Accelero.(Drug_Group{group}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
        for stim=1:length(Start(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse})))
            Accelero_Around_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse})(stim) = nanmean(Data(Restrict(Accelero.(Drug_Group{group}).(Mouse_names{mouse}) , subset(Around_VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}),stim))));
        end
        FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        TotalEpoch.(Drug_Group{group}).(Mouse_names{mouse})=intervalSet(0,max(Range(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'speed'))));
        ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse})=TotalEpoch.(Drug_Group{group}).(Mouse_names{mouse})-FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse});
        
        VHC_Stim_Epoch_DuringFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        VHC_Stim_Epoch_DuringShockFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , and(FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , ShockZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Epoch_DuringSafeFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , and(FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , SafeZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse})));
        
        VHC_Stim_Epoch_DuringActive.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        VHC_Stim_Epoch_DuringShockActive.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , and(ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , ShockZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Epoch_DuringSafeActive.(Drug_Group{group}).(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) , and(ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , SafeZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse})));
        
        Freeze_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = and(ShockZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        Freeze_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = and(SafeZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        
        Active_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = and(ShockZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        Active_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse}) = and(SafeZoneEpoch.(Drug_Group{group}).(Mouse_names{mouse}) , ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}));
        
        FreezeTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(FreezeEpoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        ShockFreezeTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(Freeze_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(Freeze_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        SafeFreezeTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(Freeze_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(Freeze_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        FreezeTime_All{n}(mouse) = FreezeTime.(Drug_Group{group}).(Mouse_names{mouse});
        FreezeTime_Shock{n}(mouse) = ShockFreezeTime.(Drug_Group{group}).(Mouse_names{mouse});
        FreezeTime_Safe{n}(mouse) = SafeFreezeTime.(Drug_Group{group}).(Mouse_names{mouse});
        
        ActiveTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(ActiveEpoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        ShockActiveTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(Active_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(Active_Shock_Epoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        SafeActiveTime.(Drug_Group{group}).(Mouse_names{mouse}) = sum(Stop(Active_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse}))-Start(Active_Safe_Epoch.(Drug_Group{group}).(Mouse_names{mouse})))/1e4;
        ActiveTime_All{n}(mouse) = ActiveTime.(Drug_Group{group}).(Mouse_names{mouse});
        ActiveTime_Shock{n}(mouse) = ShockActiveTime.(Drug_Group{group}).(Mouse_names{mouse});
        ActiveTime_Safe{n}(mouse) = SafeActiveTime.(Drug_Group{group}).(Mouse_names{mouse});
        
        Start_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse}) = Start(VHC_Stim_Epoch.(Drug_Group{group}).(Mouse_names{mouse}));
        VHC_Stim_Numb.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse}));
        
        VHC_Stim_Numb_DuringFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringFreezing.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Numb_DuringShockFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringShockFreezing.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Numb_DuringSafeFreezing.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringSafeFreezing.(Drug_Group{group}).(Mouse_names{mouse})));
        
        VHC_Stim_Numb_DuringActive.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringActive.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Numb_DuringShockActive.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringShockActive.(Drug_Group{group}).(Mouse_names{mouse})));
        VHC_Stim_Numb_DuringSafeActive.(Drug_Group{group}).(Mouse_names{mouse}) = length(Start(VHC_Stim_Epoch_DuringSafeActive.(Drug_Group{group}).(Mouse_names{mouse})));
        
        VHC_Stim_Numb_All{n}(mouse) = VHC_Stim_Numb.(Drug_Group{group}).(Mouse_names{mouse});
        
        VHC_Stim_Numb_DuringFreezing_All{n}(mouse) = VHC_Stim_Numb_DuringFreezing.(Drug_Group{group}).(Mouse_names{mouse});
        VHC_Stim_Numb_DuringFreezing_Shock{n}(mouse) = VHC_Stim_Numb_DuringShockFreezing.(Drug_Group{group}).(Mouse_names{mouse});
        VHC_Stim_Numb_DuringFreezing_Safe{n}(mouse) = VHC_Stim_Numb_DuringSafeFreezing.(Drug_Group{group}).(Mouse_names{mouse});
        
        VHC_Stim_Numb_DuringActive_All{n}(mouse) = VHC_Stim_Numb_DuringActive.(Drug_Group{group}).(Mouse_names{mouse});
        VHC_Stim_Numb_DuringActive_Shock{n}(mouse) = VHC_Stim_Numb_DuringShockActive.(Drug_Group{group}).(Mouse_names{mouse});
        VHC_Stim_Numb_DuringActive_Safe{n}(mouse) = VHC_Stim_Numb_DuringSafeActive.(Drug_Group{group}).(Mouse_names{mouse});
        
        
        disp(Mouse_names{mouse})
    end
    VHC_Stim_Prop_DuringFreezing_All{n} = VHC_Stim_Numb_DuringFreezing_All{n}./VHC_Stim_Numb_All{n};
    
    VHC_Stim_FreezingDensity_All{n} = VHC_Stim_Numb_DuringFreezing_All{n}./FreezeTime_All{n};
    VHC_Stim_FreezingDensity_Shock{n} = VHC_Stim_Numb_DuringFreezing_Shock{n}./FreezeTime_Shock{n};
    VHC_Stim_FreezingDensity_Safe{n} = VHC_Stim_Numb_DuringFreezing_Safe{n}./FreezeTime_Safe{n};
    
    VHC_Stim_ActiveDensity_All{n} = VHC_Stim_Numb_DuringActive_All{n}./ActiveTime_All{n};
    VHC_Stim_ActiveDensity_Shock{n} = VHC_Stim_Numb_DuringActive_Shock{n}./ActiveTime_Shock{n};
    VHC_Stim_ActiveDensity_Safe{n} = VHC_Stim_Numb_DuringActive_Safe{n}./ActiveTime_Safe{n};
    
    n=n+1;
end


for n=1:2
    VHC_density_shock{n} = (VHC_Stim_Numb_DuringActive_Shock{n}+VHC_Stim_Numb_DuringFreezing_Shock{n})./(FreezeTime_Shock{n}+ActiveTime_Shock{n});
    VHC_density_safe{n} = (VHC_Stim_Numb_DuringActive_Safe{n}+VHC_Stim_Numb_DuringFreezing_Safe{n})./(FreezeTime_Safe{n}+ActiveTime_Safe{n});
end

% Stims by session, time, accuracy,...
Cols = {[.65, .75, 0],[.63, .08, .18]};
X = 1:2;
Legends = {'Rip sham','Rip inhib'};
NoLegends = {'',''};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(FreezeTime_All ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('Freeze all'); ylabel('time (s)');
subplot(132)
MakeSpreadAndBoxPlot3_SB(FreezeTime_Shock ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('Freeze shock'); ylabel('time (s)');
subplot(133)
MakeSpreadAndBoxPlot3_SB(FreezeTime_All ,Cols,X,Legends , 'showpoints',1,'paired',0);
title('Freeze safe'); ylabel('time (s)');




figure
subplot(341)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_All ,Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims'); ylabel('#');
subplot(342)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during freezing'); ylabel('#');
subplot(343)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Prop_DuringFreezing_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims freezing proportion'); ylabel('proportion')
subplot(344)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_All , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC density freezing'); ylabel('Hz');
subplot(345)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_Shock , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock freezing'); ylabel('#'); ylim([0 650]);
subplot(346)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringFreezing_Safe , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe freezing'); ylabel('#'); ylim([0 650]);
subplot(347)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringActive_Shock , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during shock active'); ylabel('#'); ylim([0 650]);
subplot(348)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_DuringActive_Safe , Cols,X,NoLegends , 'showpoints',1,'paired',0);
title('VHC stims during safe active'); ylabel('#'); ylim([0 650]);
subplot(349)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_Shock , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,10)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_FreezingDensity_Safe , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe freezing'); ylabel('Hz'); ylim([0 1])
subplot(3,4,11)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_ActiveDensity_Shock , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density shock active'); ylabel('Hz'); ylim([0 1])
subplot(3,4,12)
MakeSpreadAndBoxPlot3_SB(VHC_Stim_ActiveDensity_Safe , Cols,X,Legends , 'showpoints',1,'paired',0);
title('VHC density safe active'); ylabel('Hz'); ylim([0 1])

a=suptitle('Ripples inhibition features, experimental overview'); a.FontSize=20;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{1} VHC_Stim_FreezingDensity_Safe{1}} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);
ylim([0 1])
title('Ripples control')
subplot(122)
MakeSpreadAndBoxPlot3_SB({VHC_Stim_FreezingDensity_Shock{2} VHC_Stim_FreezingDensity_Safe{2}} , {[1 .5 .5],[.5 .5 1]} , [1:2] , {'Shock','Safe'} , 'showpoints',0,'paired',1);
ylim([0 1])
title('Ripples inhib')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(VHC_density_shock , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4])
title('VHC stim density shock')
subplot(122)
MakeSpreadAndBoxPlot3_SB(VHC_density_safe , Cols,X,Legends , 'showpoints',1,'paired',0);
ylim([0 .4])
title('VHC stim density safe')


figure
subplot(121)
PlotCorrelations_BM(Ripples_density_all.(Session_type{1}){3} , VHC_Stim_FreezingDensity_All{1})
axis square
subplot(122)
PlotCorrelations_BM(Ripples_density_all.(Session_type{1}){4} , VHC_Stim_FreezingDensity_All{2})
axis square



%% relation with Acc

for group=7:8
    figure
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,4,mouse)
        hist(log10(Accelero_Around_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse})),20)
        vline(7.2,'--r')
        xlim([4 10])
        stim_in_fz(mouse) = sum(log10(Accelero_Around_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse}))<7.2)/length(Accelero_Around_VHC_Stim.(Drug_Group{group}).(Mouse_names{mouse}));
        title([Mouse_names{mouse} ', ' num2str(round(stim_in_fz(mouse)*100)) ' %'])
        if mouse>4; xlabel('Accelero (log scale)'); end
        if or(mouse==1 , mouse==5); ylabel('stim #'); end
        
    end
    a=suptitle(['Distribution of accelerometer during VHC stims ' Drug_Group{group} ' (% during freezing)']); a.FontSize=20;
end



%% Calib features
Dir=PathForExperimentsEmbReact('Calibration_VHC');

for mouse=1:length(Dir.ExpeInfo)
    Mouse(mouse) = Dir.ExpeInfo{mouse}{1}.nmouse;
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    CalibSess.(Mouse_names{mouse}) = Dir.path{mouse};  
end


for group=7:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(CalibSess.(Mouse_names{mouse}))
            cd(CalibSess.(Mouse_names{mouse}){sess})
            try
                clear StimEpoch2
                load('behavResources.mat', 'StimEpoch2' , 'MovAcctsd')
                StimEpoch2;
                TotEpochDur.(Mouse_names{mouse})(sess) = max(Range(MovAcctsd))/1e4;
                
                Stim_Numb.(Mouse_names{mouse})(sess) = length(Start(StimEpoch2));
            end
        end
    end
end


for sess=1:10
    n=1;
    for group=7:8
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                Stim_Numb_All{sess}{n}(mouse) = Stim_Numb.(Mouse_names{mouse})(sess);
                Stim_Numb_All2{n}(mouse,sess) = Stim_Numb.(Mouse_names{mouse})(sess);
                Stim_Dens_All{sess}{n}(mouse) = Stim_Numb.(Mouse_names{mouse})(sess)/TotEpochDur.(Mouse_names{mouse})(sess);
                Stim_Dens_All2{n}(mouse,sess) = Stim_Numb.(Mouse_names{mouse})(sess)/TotEpochDur.(Mouse_names{mouse})(sess);
            end
            
        end
        n=n+1;
    end
end


%% Enveloppe before stims
GetEmbReactMiceFolderList_BM
Group=7:8;
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib'};
time_bef_stim=.003;

n=1;
for group=7:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        VHC_Stim_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
        Sta_Stim.(Mouse_names{mouse}) = Start(VHC_Stim_Epoch.(Mouse_names{mouse}));
        chan_numb = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1} , 'rip');
        LFP_rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
        Rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'ripples');
        
        for stim=1:length(Sta_Stim.(Mouse_names{mouse}))
            
            clear EpochBeforeStim LFP_rip_BefStim LFP_rip_BefStim_BandPassed_Pre LFP_rip_BefStim_BandPassed LFP_rip_BefStim_BandPassed_Abs LFP_rip_BefStim_BandPassed_Abs_Env
            BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse})(1,370) = 0;
            
            % 300 ms before stim analysis
            EpochBeforeStim = intervalSet(Sta_Stim.(Mouse_names{mouse})(stim)-.3e4 , Sta_Stim.(Mouse_names{mouse})(stim)-time_bef_stim*1e4);
            LFP_rip_BefStim = Restrict(LFP_rip.(Mouse_names{mouse}) , EpochBeforeStim);
            LFP_Data_Zscored = zscore(Data(LFP_rip_BefStim));
            LFP_Data_Zscored_tsd = tsd(Range(LFP_rip_BefStim) , LFP_Data_Zscored);
            if ~isempty(Range(LFP_rip_BefStim))
            CleanedEpoch = and(thresholdIntervals(LFP_Data_Zscored_tsd,-2) , thresholdIntervals(LFP_Data_Zscored_tsd,2,'Direction','Below')); % when stim artefact are still in the LFP signal
            LFP_rip_BefStim = Restrict(LFP_rip_BefStim , CleanedEpoch);
            LFP_rip_BefStim_BandPassed_Pre =  real(LowPassFilter(Data(LFP_rip_BefStim) , 250 , 1250));
            LFP_rip_BefStim_BandPassed =  real(HighPassFilter_BM(LFP_rip_BefStim_BandPassed_Pre , 120, 1250 ));
            
            LFP_rip_BefStim_BandPassed_Abs = abs(LFP_rip_BefStim_BandPassed);
            LFP_rip_BefStim_BandPassed_Abs_Env = Envelope_Maxima_BM(LFP_rip_BefStim_BandPassed_Abs , 7);
            BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse})(stim , 370-length(LFP_rip_BefStim_BandPassed_Abs_Env)+1:end) = LFP_rip_BefStim_BandPassed_Abs_Env;
            Rip_Before_Stim.(Mouse_names{mouse})(stim) = logical(length(Restrict(Rip.(Mouse_names{mouse}) , EpochBeforeStim)));
            end
        end
        Prop_Rip_Before_Stim.(Mouse_names{mouse}) = sum(Rip_Before_Stim.(Mouse_names{mouse}))/length(Rip_Before_Stim.(Mouse_names{mouse}));
        Prop_Rip_Before_Stim_all{n}(mouse,:) = Prop_Rip_Before_Stim.(Mouse_names{mouse});
        
        BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse})(BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse})==0) = NaN;
        BandPassed_Envelope_LFP_rip_all{n}(mouse,:) = nanmean(BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse}));
        
        clear Rg; Rg = Range(Rip.(Mouse_names{mouse}));
        for rip=1:length(Rip.(Mouse_names{mouse}))
            clear EpochAfterRip
            
            EpochAfterRip = intervalSet(Rg(rip) , Rg(rip)+.3e4);
            Stim_After_Rip.(Mouse_names{mouse})(rip) = logical(length(Start(and(VHC_Stim_Epoch.(Mouse_names{mouse}) , EpochAfterRip))));
        end
        Prop_Stim_After_Rip.(Mouse_names{mouse}) = sum(Stim_After_Rip.(Mouse_names{mouse}))/length(Stim_After_Rip.(Mouse_names{mouse}));
        Prop_Stim_After_Rip_all{n}(mouse,:) = Prop_Stim_After_Rip.(Mouse_names{mouse});
        
        disp(Mouse_names{mouse})
    end
    n=n+1;
end

n=1;
for group=7
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            chan_numb = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1} , 'rip');
            LFP_rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
            Rip.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'ripples');
            TimeRipPeak.(Mouse_names{mouse}) = Range(Rip.(Mouse_names{mouse}));
            for rip=1:length(Rip.(Mouse_names{mouse}))
                try
                    clear EpochAroundRip LFP_AroundRip LFP_Data_Zscored LFP_rip_BefStim_BandPassed_Pre LFP_rip_BefStim_BandPassed LFP_rip_BefStim_BandPassed_Abs LFP_rip_BefStim_BandPassed_Abs_Env
                    BandPassed_Envelope_LFP_rip.(Drug_Group{group}).(Mouse_names{mouse})(1,500) = 0;
                    %
                    %             % 300 ms before stim analysis
                    EpochAroundRip = intervalSet(TimeRipPeak.(Mouse_names{mouse})(rip)-.2e4 , TimeRipPeak.(Mouse_names{mouse})(rip)+.2e4);
                    LFP_AroundRip = Restrict(LFP_rip.(Mouse_names{mouse}) , EpochAroundRip);
                    LFP_Data_Zscored = zscore(Data(LFP_AroundRip));
                    LFP_Data_Zscored_tsd = tsd(Range(LFP_AroundRip) , LFP_Data_Zscored);
                    CleanedEpoch = and(thresholdIntervals(LFP_Data_Zscored_tsd,-2) , thresholdIntervals(LFP_Data_Zscored_tsd,2,'Direction','Below')); % when stim artefact are still in the LFP signal
                    LFP_rip_BefStim = Restrict(LFP_AroundRip , CleanedEpoch);
                    LFP_rip_BefStim_BandPassed_Pre =  real(LowPassFilter(Data(LFP_rip_BefStim) , 250 , 1250));
                    LFP_rip_BefStim_BandPassed =  real(HighPassFilter_BM(LFP_rip_BefStim_BandPassed_Pre , 120, 1250 ));
                    
                    LFP_rip_BefStim_BandPassed_Abs = abs(LFP_rip_BefStim_BandPassed);
                    LFP_rip_BefStim_BandPassed_Abs_Env = Envelope_Maxima_BM(LFP_rip_BefStim_BandPassed_Abs , 7);
                    BandPassed_Envelope_AroundRip.(Drug_Group{group}).(Mouse_names{mouse})(rip , 1:length(LFP_rip_BefStim_BandPassed_Abs_Env)) = LFP_rip_BefStim_BandPassed_Abs_Env;
                end
            end
            
            BandPassed_Envelope_AroundRip.(Drug_Group{group}).(Mouse_names{mouse})(BandPassed_Envelope_AroundRip.(Drug_Group{group}).(Mouse_names{mouse})==0) = NaN;
            BandPassed_Envelope_AroundRip_all{n}(mouse,:) = nanmean(BandPassed_Envelope_AroundRip.(Drug_Group{group}).(Mouse_names{mouse}));
        end
        disp(Mouse_names{mouse})
    end
    BandPassed_Envelope_AroundRip_all{n}(BandPassed_Envelope_AroundRip_all{n}==0)=NaN;
    n=n+1;
end




figure
Data_to_use = BandPassed_Envelope_LFP_rip_all{1}(:,1:349);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-300,0,349) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.65, .75, 0]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
Data_to_use = BandPassed_Envelope_LFP_rip_all{2}(:,1:349);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-500,-200,349) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.63, .08, .18]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
Data_to_use = BandPassed_Envelope_AroundRip_all{1};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-375,25,498) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.3, .745, .93]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;


xlim([-250 -100]), vline(0,'--r'), vline(-200,'--r')
ylabel('enveloppe amplitude (a.u.)'), xlabel('time (ms)')
t=text(0,350,'VHC stims','Color','r');
f=get(gca,'Children'); l=legend([f(9),f(5)],'Ripples sham','Ripples inhib'); 

a=suptitle('Signal enveloppe after band pass filter 120-250Hz'); a.FontSize=12;



%% Correlations with behaviour
cd('/media/nas6/ProjetEmbReact/DataEmbReact'); load('Create_Behav_Drugs_BM.mat', 'FreezingProportion','ZoneEntries', 'ZoneOccupancy', 'Occupancy_MiddleZone', 'ZoneEntriesActive', 'ZoneEpoch', 'Total_Time')
GetEmbReactMiceFolderList_BM
Session_type={'Cond'}; sess=1;

n=1;
for group=7:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        FreezingProportion_All_Cond_All(mouse) = FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse});
        FreezingProportion_All_Cond_Shock(mouse) = FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse});
        FreezingProportion_All_Cond_Safe(mouse) = FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse});
        FreezingProportion_All_Cond_Ratio(mouse) = FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse});
        ShockZoneEntries_All_Cond(mouse) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse});
        ShockZoneOccupancy_All_Cond(mouse) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
        ShockEntriesZone_BySecondActive_Cond(mouse) = ZoneEntriesActive.Shock.(Session_type{sess}).(Mouse_names{mouse});
        ShockZoneEpoch_Occupancy_Cond(mouse) = (sum(DurationEpoch(ZoneEpoch.Cond.(Mouse_names{mouse}){1}))/60e4)./Total_Time.Cond.(Mouse_names{mouse});
    end
    n=n+1;
end

% Correlations stim and freezing
figure
subplot(231)
PlotCorrelations_BM(VHC_Stim_Numb_All{2} ,FreezeTime_All);
title('All freezing'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .6]); xlim([0 2000])
subplot(232)
PlotCorrelations_BM(VHC_Stim_Numb_All ,FreezingProportion_All_Cond_Shock(ind) , 30,0,'k')
title('Shock freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]); xlim([0 2000])
subplot(233)
PlotCorrelations_BM(VHC_Stim_Numb_All , FreezingProportion_All_Cond_Safe(ind) , 30,0,'k')
title('Safe freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]); xlim([0 2000])
subplot(234)
PlotCorrelations_BM(VHC_Stim_Numb_All ,FreezingProportion_All_Cond_Ratio(ind) , 30,0,'k')
title('Freezing ratio'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .7]); xlim([0 2000])
subplot(235)
PlotCorrelations_BM(VHC_Stim_Numb_All , ShockEntriesZone_BySecondActive_Cond(ind) , 30,0,'k')
title('Shock zone entries'); xlabel('VHC stim #'); ylabel('#/min'); ylim([0 4.5]); xlim([0 2000])
subplot(236)
PlotCorrelations_BM(VHC_Stim_Numb_All ,ShockZoneEpoch_Occupancy_Cond(ind) , 30,0,'k')
title('Shock zone occupancy'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .5]); xlim([0 2000])

a=suptitle('VHC stims correlations with behaviour, all mice, n=18'); a.FontSize=20;


figure
subplot(231)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) ,FreezingProportion_All_Cond_All(ind) , 30,0,'k')
title('All freezing'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .6]);
subplot(232)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) ,FreezingProportion_All_Cond_Shock(ind) , 30,0,'k')
title('Shock freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]);
subplot(233)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) , FreezingProportion_All_Cond_Safe(ind) , 30,0,'k')
title('Safe freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]);
subplot(234)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) ,FreezingProportion_All_Cond_Ratio(ind) , 30,0,'k')
title('Freezing ratio'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .7]);
subplot(235)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) ,ShockZoneEntries_All_Cond(ind) , 30,0,'k')
title('Shock zone entries'); xlabel('VHC stim #'); ylabel('#/min'); ylim([0 4.5]);
subplot(236)
PlotCorrelations_BM(VHC_Stim_Numb_DuringFreezing_All(ind) ,ShockZoneOccupancy_All_Cond(ind) , 30,0,'k')
title('Shock zone occupancy'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .24]);

a=suptitle('VHC stims correlations with behaviour, all mice, n=18'); a.FontSize=20;


figure
subplot(231)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) ,FreezingProportion_All_Cond_All(ind) , 30,0,'k')
title('All freezing'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .6]);
subplot(232)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) ,FreezingProportion_All_Cond_Shock(ind) , 30,0,'k')
title('Shock freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]);
subplot(233)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) , FreezingProportion_All_Cond_Safe(ind) , 30,0,'k')
title('Safe freezing'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .7]);
subplot(234)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) ,FreezingProportion_All_Cond_Ratio(ind) , 30,0,'k')
title('Freezing ratio'); ylabel('proportion'); xlabel('VHC stim #'); ylim([0 .7]);
subplot(235)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) ,ShockZoneEntries_All_Cond(ind) , 30,0,'k')
title('Shock zone entries'); xlabel('VHC stim #'); ylabel('#/min'); ylim([0 4.5]);
subplot(236)
PlotCorrelations_BM(VHC_Stim_FreezingDensity_All(ind) ,ShockZoneOccupancy_All_Cond(ind) , 30,0,'k')
title('Shock zone occupancy'); xlabel('VHC stim #'); ylabel('proportion'); ylim([0 .24]);

a=suptitle('VHC stims correlations with behaviour, all mice, n=18'); a.FontSize=20;






