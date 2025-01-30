
% EPM
Dir=PathForExperimentsEmbReact('EPM');
j=1;
for mouse=[1 2 4 5 6 7 8 11 12 13 14 15 16]
    cd(Dir.path{mouse}{1})
    
    clear Behav
    load('behavResources_SB.mat', 'Behav')
    Epoch = intervalSet(0,300e4);
    for i=1:3
        Behav.ZoneEpoch{i} = and(Behav.ZoneEpoch{i} , Epoch);
        Behav.ZoneEpoch{i} = dropShortIntervals(Behav.ZoneEpoch{i} , 1e4);
        Behav.ZoneEpoch{i} = mergeCloseIntervals(Behav.ZoneEpoch{i},1e4);
    end
    
    OpenArm_Prop(j) = sum(DurationEpoch(Behav.ZoneEpoch{1}))/(sum(DurationEpoch(Behav.ZoneEpoch{1})) + ...
        sum(DurationEpoch(Behav.ZoneEpoch{2})) + sum(DurationEpoch(Behav.ZoneEpoch{3})));
    OpenArm_Entries(j) = length(Start(Behav.ZoneEpoch{1}));
    ClosedArm_Entries(j) = length(Start(Behav.ZoneEpoch{2}));
    Ratio_Entries(j) = OpenArm_Entries(j)/(OpenArm_Entries(j) + ClosedArm_Entries(j));
    
    Speed.EPM{j} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
    DistanceTraveled.EPM(j) = nanmean(Data(Speed.EPM{j}))*300;
    clear D
    D = Data(Speed.EPM{j}); D=D(D<2);
    ImmobilityTime.EPM(j) = length(D)/length(Data(Speed.EPM{j}));
    
    j=j+1;
    disp(Dir.ExpeInfo{mouse}{1}.nmouse)
end


% TestPre & TestPost
Session_Type = {'TestPre','TestPost'};
for sess=1:2
    if sess==1; Dir=PathForExperimentsEmbReact('TestPre');
    else; Dir=PathForExperimentsEmbReact('TestPost'); end
    i=1;
    for mouse=2:14
        AlignedPosition.(Session_Type{sess}){i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'AlignedPosition');
        Thigmo_score.(Session_Type{sess})(i) = Thigmo_From_Position_BM(AlignedPosition.(Session_Type{sess}){i});
        ShockZoneEntries.(Session_Type{sess})(i) = sum(ConcatenateDataFromFolders_SB(Dir.path{mouse},'sz_entries'));
        Speed.(Session_Type{sess}){i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
        DistanceTraveled.(Session_Type{sess})(i) = nanmean(Data(Speed.(Session_Type{sess}){i}))*300;
        clear D
        D = Data(Speed.(Session_Type{sess}){i}); D=D(D<2);
        ImmobilityTime.(Session_Type{sess})(i) = length(D)/length(Data(Speed.(Session_Type{sess}){i}));
        
        i=i+1;
        disp(Dir.ExpeInfo{mouse}{1}.nmouse)
    end
    Thigmo_score.(Session_Type{sess})(Thigmo_score.(Session_Type{sess})==0) = NaN;
end


% Cond 
Dir=PathForExperimentsEmbReact('UMazeCond');
i=1;
for mouse=2:14
    AlignedPosition.Cond{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'AlignedPosition');
    Thigmo_score.Cond(i) = Thigmo_From_Position_BM(AlignedPosition.Cond{i});
    ShockZoneEntries.Cond(i) = sum(ConcatenateDataFromFolders_SB(Dir.path{mouse},'sz_entries'));
    Speed.Cond{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'speed');
    DistanceTraveled.Cond(i) = nanmean(Data(Speed.Cond{i}))*(max(Range(Speed.Cond{i}))/1e4);
    
    FreezeEpoch{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'epoch','epochname','freezeepoch');
    ZoneEpoch{i} = ConcatenateDataFromFolders_SB(Dir.path{mouse},'epoch','epochname','zoneepoch');
    Freeze_Shock{i} = and(FreezeEpoch{i} , ZoneEpoch{i}{1});
    Freeze_Safe{i} = and(FreezeEpoch{i} , or(ZoneEpoch{i}{2} , ZoneEpoch{i}{5}));
    Freeze_All_Dur(i) = sum(DurationEpoch(FreezeEpoch{i}))/60e4;
    Freeze_Shock_Dur(i) = sum(DurationEpoch(Freeze_Shock{i}))/60e4;
    Freeze_Safe_Dur(i) = sum(DurationEpoch(Freeze_Safe{i}))/60e4;   
    
    i=i+1;
    disp(Dir.ExpeInfo{mouse}{1}.nmouse)
end


figure
subplot(131)
PlotCorrelations_BM(DistanceTraveled.TestPre , DistanceTraveled.EPM ,'method','pearson')
subplot(132)
PlotCorrelations_BM(DistanceTraveled.Cond , DistanceTraveled.EPM ,'method','pearson')
subplot(133)
PlotCorrelations_BM(DistanceTraveled.TestPost , DistanceTraveled.EPM ,'method','pearson')

figure
subplot(121)
PlotCorrelations_BM(ImmobilityTime.TestPre , ImmobilityTime.EPM ,'method','pearson')
subplot(122)
PlotCorrelations_BM(ImmobilityTime.TestPost , ImmobilityTime.EPM ,'method','pearson')

figure
subplot(231)
PlotCorrelations_BM(OpenArm_Entries , ShockZoneEntries.TestPre ,'method','pearson')
subplot(232)
PlotCorrelations_BM(OpenArm_Entries , ShockZoneEntries.Cond ,'method','pearson')
subplot(233)
PlotCorrelations_BM(OpenArm_Entries , ShockZoneEntries.TestPost ,'method','pearson')

subplot(234)
PlotCorrelations_BM(OpenArm_Prop , ShockZoneEntries.TestPre ,'method','pearson')
subplot(235)
PlotCorrelations_BM(OpenArm_Prop , ShockZoneEntries.Cond ,'method','pearson')
subplot(236)
PlotCorrelations_BM(OpenArm_Prop , ShockZoneEntries.TestPost ,'method','pearson')


figure
subplot(231)
PlotCorrelations_BM(OpenArm_Entries , Thigmo_score.TestPre ,'method','pearson')
subplot(232)
PlotCorrelations_BM(OpenArm_Entries , Thigmo_score.Cond ,'method','pearson')
subplot(233)
PlotCorrelations_BM(OpenArm_Entries , Thigmo_score.TestPost ,'method','pearson')

subplot(234)
PlotCorrelations_BM(OpenArm_Prop , Thigmo_score.TestPre ,'method','pearson')
subplot(235)
PlotCorrelations_BM(OpenArm_Prop , Thigmo_score.Cond ,'method','pearson')
subplot(236)
PlotCorrelations_BM(OpenArm_Prop , Thigmo_score.TestPost ,'method','pearson')
 


figure
subplot(231)
PlotCorrelations_BM(OpenArm_Entries , Freeze_All_Dur ,'method','pearson')
subplot(232)
PlotCorrelations_BM(OpenArm_Entries , Freeze_Shock_Dur ,'method','pearson')
subplot(233)
PlotCorrelations_BM(OpenArm_Entries , Freeze_Safe_Dur ,'method','pearson')

subplot(234)
PlotCorrelations_BM(OpenArm_Prop , Freeze_All_Dur ,'method','pearson')
subplot(235)
PlotCorrelations_BM(OpenArm_Prop , Freeze_Shock_Dur ,'method','pearson')
subplot(236)
PlotCorrelations_BM(OpenArm_Prop , Freeze_Safe_Dur ,'method','pearson')


%% selecting significative
figure
subplot(121)
PlotCorrelations_BM(OpenArm_Prop , Freeze_Safe_Dur ,'method','pearson')
axis square
xlabel('open arm proportion'), ylabel('freezing safe duration, Cond (min)')
grid on
xlim([0 .5])

subplot(122)
PlotCorrelations_BM(OpenArm_Entries , Freeze_Safe_Dur ,'method','pearson')
axis square
xlabel('open arm entries (#)'), ylabel('freezing safe duration, Cond (min)')
grid on
xlim([0 12])




figure
subplot(121)
PlotCorrelations_BM(OpenArm_Prop , Freeze_Shock_Dur ,'method','pearson')
axis square
xlabel('open arm proportion'), ylabel('freezing safe duration, Cond (min)')
grid on
xlim([0 .5])

subplot(122)
PlotCorrelations_BM(OpenArm_Entries , Freeze_Shock_Dur ,'method','pearson')
axis square
xlabel('open arm entries (#)'), ylabel('freezing safe duration, Cond (min)')
grid on
xlim([0 12])






