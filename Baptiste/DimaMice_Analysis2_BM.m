

clear all

Dir=PathForExperimentsERC_Dima('UMazePAG');

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}.nmouse;
end


Session_type={'Fear','Cond','Ext','TestPre','TestPost'};


for mouse=1:length(Mouse)
    
    cd(Dir.path{mouse}{1})
    load('behavResources.mat', 'SessionEpoch')
    
    load('behavResources.mat', 'ZoneEpoch')
    ZoneEpoch_To_Use=ZoneEpoch;
    
    load('behavResources.mat', 'MovAcctsd')
    
    try
        ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Ext;
    catch
        try
            ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Extinction;
        catch
            try
                ExtEpoch.(Mouse_names{mouse}) = SessionEpoch.ExploAfter;
            catch
                ExtEpoch.(Mouse_names{mouse}) = intervalSet([],[]);
            end
        end
    end
    CondEpoch.(Mouse_names{mouse}) =  or(SessionEpoch.Cond1,or(SessionEpoch.Cond2,or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
    FearEpoch.(Mouse_names{mouse}) =  or(CondEpoch.(Mouse_names{mouse}) , ExtEpoch.(Mouse_names{mouse}));
    
    try
        TestPreEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2) , or(SessionEpoch.TestPre3,SessionEpoch.TestPre4));
    catch
        try
            TestPreEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2) , SessionEpoch.TestPre4);
        catch
            TestPreEpoch.(Mouse_names{mouse}) =  intervalSet([],[]);
        end
    end
    TestPostEpoch.(Mouse_names{mouse}) =  or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2) , or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
    
    load('B_Low_Spectrum.mat')
    OB_Sptsd=tsd(Spectro{1, 2}*1e4,Spectro{1, 1});
    
    for sess=1:5
        
        if sess==1
            Epoch_to_use=FearEpoch.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondEpoch.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=ExtEpoch.(Mouse_names{mouse});
        elseif sess==4
            Epoch_to_use=TestPreEpoch.(Mouse_names{mouse});
        elseif sess==5
            Epoch_to_use=TestPostEpoch.(Mouse_names{mouse});
        end
        
        Acc.(Session_type{sess}).(Mouse_names{mouse})=Restrict(MovAcctsd,Epoch_to_use);
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=Restrict(OB_Sptsd,Epoch_to_use);
        TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = Epoch_to_use;
        try
            ShockZone.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.Shock,ZoneEpoch_To_Use.FarShock ));
        catch
            ShockZone.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,ZoneEpoch_To_Use.Shock);
        end
        
        try
            SafeZone.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.NoShock,or(ZoneEpoch_To_Use.FarNoShock,ZoneEpoch_To_Use.CentreNoShock)));
        catch
            SafeZone.(Session_type{sess}).(Mouse_names{mouse}) =and(Epoch_to_use,or(ZoneEpoch_To_Use.NoShock,ZoneEpoch_To_Use.CentreNoShock));
        end
        
        try
            load('behavResources.mat', 'FreezeAccEpoch')
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})=and(FreezeAccEpoch,Epoch_to_use);
        catch
            keyboard
            Params.thtps_immob=2;  Params.smoofact_Acc = 30;  Params.th_immob_Acc = 1.7e7;
            FreezeAccEpoch=MakeFreezeAccEpoch_BM(MovAcctsd,Params);
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})=and(Epoch_to_use,FreezeAccEpoch);
        end
        ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
        
        thr=13; clear Data_Spectro; Data_Spectro=Data(OBSpec.(Session_type{sess}).(Mouse_names{mouse}));
        [~,Spectrum_Peak] = max(Data_Spectro(:,thr:end)');
        Frequencies_withNoise = Spectro{3}((Spectrum_Peak+thr-1));
        Frequencies_withNoise(Frequencies_withNoise==Spectro{3}(thr))=NaN;
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = tsd(Range(OBSpec.(Session_type{sess}).(Mouse_names{mouse})) , Frequencies_withNoise');
        
        Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
        Active_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        Active_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
        Respi_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
        Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
        
    end
    disp(Mouse_names{mouse})
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            FreezeTime.(Session_type{sess})(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Shock.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            FreezeTime_Safe.(Session_type{sess})(mouse) = sum(DurationEpoch(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime.(Session_type{sess})(mouse) = sum(DurationEpoch(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Shock.(Session_type{sess})(mouse) = sum(DurationEpoch(Active_Shock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            ActiveTime_Safe.(Session_type{sess})(mouse) = sum(DurationEpoch(Active_Safe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
            Respi_Shock_Fz.(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            Respi_Safe_Fz.(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            ExpeDuration.(Session_type{sess})(mouse) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        end
    end
    try
        Respi_Shock_Fz.(Session_type{sess})(Respi_Shock_Fz.(Session_type{sess})==0) = NaN;
        Respi_Safe_Fz.(Session_type{sess})(Respi_Safe_Fz.(Session_type{sess})==0) = NaN;
        Respi_Diff.(Session_type{sess}) = Respi_Shock_Fz.(Session_type{sess})-Respi_Safe_Fz.(Session_type{sess});
    end
end


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
legend('Cond','Ext','TestPost')
title('Sessions duration'), ylabel('time (min)')

subplot(312)
for sess=[2 3 5]
    plot(FreezeTime.(Session_type{sess})/60), hold on
    xticks([1:length(Mouse)]); xlim([0 length(Mouse)]); xticklabels({''}); xtickangle(45);
end
makepretty
title('Freezing duration'), ylabel('time (min)')

subplot(313)
for sess=[2 3 5]
    plot(FreezeTime.(Session_type{sess})./ExpeDuration.(Session_type{sess})), hold on
    xticks([1:length(Mouse)]); xlim([0 length(Mouse)]); xticklabels(Mouse_names); xtickangle(45);
end
makepretty
title('Freezing proportion'), ylabel('proportion')

a=suptitle('Protocol overview, aversive stimulations, n=50'); a.FontSize=20;


% features freezing & respi
figure; sess=2;
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
xlim([0 7.5]), ylim([0 7.5]), axis square
grid on
xlabel('Shock freezing frequency (Hz)'), ylabel('Safe freezing frequency (Hz)')

a=suptitle(['Freezing and breathing analysis, Maze, Saline, ' Session_type{sess} ' n=53']); a.FontSize=20;


% mice weird
Mouse(find(Respi_Shock_Fz.(Session_type{sess})-Respi_Safe_Fz.(Session_type{sess})<0))


% Time fz = f(time active) 
figure; sess=2;
subplot(211)
PlotCorrelations_BM(ActiveTime_Shock.(Session_type{sess}) , FreezeTime_Shock.(Session_type{sess})); axis square
xlabel('Time spent active shock'), ylabel('Time spent freezing shock')
title(Session_type{sess})

subplot(212)
PlotCorrelations_BM(ActiveTime_Safe.(Session_type{sess}) , FreezeTime_Safe.(Session_type{sess})); axis square
xlabel('Time spent active safe'), ylabel('Time spent freezing safe')

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
figure; sess=2;
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

    
% zone aversiveness = f(respi fz) 
figure; sess=2;
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

    
% diff respi = f(fz time)
figure; sess=2;
subplot(211)
PlotCorrelations_BM(log10(FreezeTime_Shock.(Session_type{sess})) , Respi_Diff.(Session_type{sess})); axis square
xlabel('shock freezing time (log scale)'), ylabel('Diff respi shock-safe')
xlim([0 3.5]), ylim([-1 3.5])
title(Session_type{sess})

subplot(212)
PlotCorrelations_BM(log10(FreezeTime_Safe.(Session_type{sess})) , Respi_Diff.(Session_type{sess})); axis square
xlabel('safe freezing time (log scale)'), ylabel('Diff respi shock-safe')
xlim([0 3.5]), ylim([-1 3.5])

a=suptitle('Respi diff = f(Freezing time)'); a.FontSize=20;


% learning = f(freq respi)
figure; sess=2;
clear A; A=ActiveTime_Shock.TestPost; A(A==0)=1; 

subplot(131)
PlotCorrelations_BM(Respi_Shock_Fz.(Session_type{sess}) , log10(A)); axis square
ylabel('Respi shock fz')
ylim([0 3]), xlim([-.5 6])
title(Session_type{sess})

subplot(132)
PlotCorrelations_BM(Respi_Safe_Fz.(Session_type{sess}) , log10(A)); axis square
ylabel('Respi safe fz')
ylim([0 3]), xlim([-.5 6])

subplot(133)
PlotCorrelations_BM(Respi_Diff.(Session_type{sess}) , log10(A)); axis square
xlabel('time spent shock zone TestPost (log scale)'), ylabel('Diff respi shock-safe')
ylim([0 3]), xlim([-.5 6])

a=suptitle('Learning = f(Respi diff)'); a.FontSize=20;


% evol
figure; sess=2;
plot(runmean_BM(nanmean(Respi_Fz_Evol_Shock.(Session_type{sess})),3),'r')
hold on
plot(runmean_BM(nanmean(Respi_Fz_Evol_Safe.(Session_type{sess})),3),'b')
makepretty
ylim([3 6])






