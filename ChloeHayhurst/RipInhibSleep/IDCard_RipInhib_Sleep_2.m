clear all
close all

load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions.mat')
% GetEmbReactMiceFolderList_BM
Session_type={'TestPre','TestPost','Cond','Ext','Fear'};

Mouse_names = 'M1775';

RangeLow = linspace(0.1526,20,261);
RangeHigh = linspace(22,98,32);
RangeVHigh = linspace(22,249,94);
RangeLow2 = linspace(1.0681,20,249);

disp('gathering data...')

for sess=1:length(Session_type)
     Sessions_List_ForLoop_BM
    disp(Session_type{sess})
    
    % variables
    Speed.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'speed');
    Respi.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'respi_freq_bm');
    %             ThetaPower.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'hpc_theta_power');
    Ripples.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'ripples');
    StimEpoch.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch','epochname','stimepoch');
    HR.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'heartrate');
    HR_Var.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'heartratevar');
    Xtsd.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'xalignedposition');
    Ytsd.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'yalignedposition');
    %             Accelero.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'accelero');
    %             LinearPosition.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'LinearPosition');
    Aligned_Position.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'alignedposition');
    StimEpoch2.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch','epochname','vhc_stim');
    SpectroBulb.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'spectrum','prefix','B_Low');
    
    % epochs
    TotEpoch.(Session_type{sess}) = intervalSet(0,max(Range(Speed.(Session_type{sess}))));
    FreezeEpoch.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch' , 'epochname' , 'freezeepoch');
    FreezeEpoch.(Session_type{sess}) = mergeCloseIntervals(FreezeEpoch.(Session_type{sess}),1);
    
    FreezeEpoch_camera.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch' , 'epochname' , 'freeze_epoch_camera');
    
    ActiveEpoch.(Session_type{sess}) = TotEpoch.(Session_type{sess})-FreezeEpoch.(Session_type{sess});
    ActiveEpoch.(Session_type{sess}) = mergeCloseIntervals(ActiveEpoch.(Session_type{sess}),1);
    ZoneEpoch.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch' , 'epochname' , 'zoneepoch');
    BlockedEpoch.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch' , 'epochname' , 'blockedepoch');
    UnblockedEpoch.(Session_type{sess}) = TotEpoch.(Session_type{sess})-BlockedEpoch.(Session_type{sess});
    UnblockedEpoch.(Session_type{sess}) = mergeCloseIntervals(UnblockedEpoch.(Session_type{sess}),1);

    try
        StimEpochUnblocked.(Session_type{sess}) = and(StimEpoch.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    catch
        StimEpochUnblocked.(Session_type{sess}) = NaN;
    end
    
    XtsdUnblocked.(Session_type{sess}) = Restrict(Xtsd.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    YtsdUnblocked.(Session_type{sess}) = Restrict(Ytsd.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    XtsdFreezing.(Session_type{sess}) = Restrict(Xtsd.(Session_type{sess}),FreezeEpoch.(Session_type{sess}));
    YtsdFreezing.(Session_type{sess}) = Restrict(Ytsd.(Session_type{sess}),FreezeEpoch.(Session_type{sess}));
    XtsdFreezingCamera.(Session_type{sess}) = Restrict(Xtsd.(Session_type{sess}),FreezeEpoch_camera.(Session_type{sess}));
    YtsdFreezingCamera.(Session_type{sess}) = Restrict(Ytsd.(Session_type{sess}),FreezeEpoch_camera.(Session_type{sess}));
    XtsdFreezing_Unblocked.(Session_type{sess}) = Restrict(XtsdFreezing.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    YtsdFreezing_Unblocked.(Session_type{sess}) = Restrict(YtsdFreezing.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    XtsdFreezing_UnblockedCamera.(Session_type{sess}) = Restrict(XtsdFreezingCamera.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    YtsdFreezing_UnblockedCamera.(Session_type{sess}) = Restrict(YtsdFreezingCamera.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    XtsdStimUnblocked.(Session_type{sess}) = Restrict(XtsdUnblocked.(Session_type{sess}), Start(StimEpochUnblocked.(Session_type{sess})));
    YtsdStimUnblocked.(Session_type{sess}) = Restrict(YtsdUnblocked.(Session_type{sess}), Start(StimEpochUnblocked.(Session_type{sess})));
    XtsdStim.(Session_type{sess}) = Restrict(Xtsd.(Session_type{sess}), Start(StimEpoch.(Session_type{sess})));
    YtsdStim.(Session_type{sess}) = Restrict(Ytsd.(Session_type{sess}), Start(StimEpoch.(Session_type{sess})));
    
    ShockZoneEpoch.(Session_type{sess}) = ZoneEpoch.(Session_type{sess}){1};
    ShockZoneEpoch.(Session_type{sess}) = mergeCloseIntervals(ShockZoneEpoch.(Session_type{sess}),1);
    SafeZoneEpoch.(Session_type{sess}) = ZoneEpoch.(Session_type{sess}){2};
    SafeZoneEpoch.(Session_type{sess}) = mergeCloseIntervals(SafeZoneEpoch.(Session_type{sess}),1);
    ShockCornerEpoch.(Session_type{sess}) = ZoneEpoch.(Session_type{sess}){4};
    ShockCornerEpoch.(Session_type{sess}) = mergeCloseIntervals(ShockCornerEpoch.(Session_type{sess}),1);
    SafeCornerEpoch.(Session_type{sess}) = ZoneEpoch.(Session_type{sess}){5};
    SafeCornerEpoch.(Session_type{sess}) = mergeCloseIntervals(SafeCornerEpoch.(Session_type{sess}),1);
    MiddleZoneEpoch.(Session_type{sess}) = ZoneEpoch.(Session_type{sess}){3};
    MiddleZoneEpoch.(Session_type{sess}) = mergeCloseIntervals(MiddleZoneEpoch.(Session_type{sess}),1);
    SafeZoneEpoch_freezing.(Session_type{sess}) = or(ZoneEpoch.(Session_type{sess}){2} , ZoneEpoch.(Session_type{sess}){5});
    ShockUnblockedEpoch.(Session_type{sess})= and(ShockZoneEpoch.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    SafeUnblockedEpoch.(Session_type{sess})= and(SafeZoneEpoch.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    
    
    FreezeShockEpoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , ShockZoneEpoch.(Session_type{sess}));
    FreezeSafeEpoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , SafeZoneEpoch_freezing.(Session_type{sess}));
    
    FreezeSafe2Epoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , SafeZoneEpoch.(Session_type{sess}));
    FreezeMiddleEpoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , MiddleZoneEpoch.(Session_type{sess}));
    FreezeSafeCornerEpoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , SafeCornerEpoch.(Session_type{sess}));
    FreezeShockCornerEpoch.(Session_type{sess}) = and(FreezeEpoch.(Session_type{sess}) , ShockCornerEpoch.(Session_type{sess}));
    
    FreezeShockEpoch_camera.(Session_type{sess}) = and(FreezeEpoch_camera.(Session_type{sess}) , ShockZoneEpoch.(Session_type{sess}));
    FreezeSafeEpoch_camera.(Session_type{sess}) = and(FreezeEpoch_camera.(Session_type{sess}) , SafeZoneEpoch_freezing.(Session_type{sess}));
    
    ActiveShockEpoch.(Session_type{sess}) = and(ActiveEpoch.(Session_type{sess}) , ShockZoneEpoch.(Session_type{sess}));
    ActiveSafeEpoch.(Session_type{sess}) = and(ActiveEpoch.(Session_type{sess}) , SafeZoneEpoch_freezing.(Session_type{sess}));
    ActiveSafe2Epoch.(Session_type{sess}) = and(ActiveEpoch.(Session_type{sess}) , SafeZoneEpoch.(Session_type{sess}));
    
    Unblocked_ActiveEpoch.(Session_type{sess}) = and(ActiveEpoch.(Session_type{sess}),UnblockedEpoch.(Session_type{sess}));
    Unblocked_ActiveShockZoneEpoch.(Session_type{sess}) = and(ActiveShockEpoch.(Session_type{sess}) , UnblockedEpoch.(Session_type{sess}));
    Unblocked_ActiveSafeZoneEpoch.(Session_type{sess}) = and(ActiveSafeEpoch.(Session_type{sess}) , UnblockedEpoch.(Session_type{sess}));
    Unblocked_ActiveSafeZone2Epoch.(Session_type{sess}) = and(ActiveSafe2Epoch.(Session_type{sess}) , UnblockedEpoch.(Session_type{sess}));
    
    
    [ShockZoneEpoch_Corrected.(Session_type{sess}) , SafeZoneEpoch_Corrected.(Session_type{sess})] = Correct_ZoneEntries_Maze_BM(Unblocked_ActiveShockZoneEpoch.(Session_type{sess}) , Unblocked_ActiveSafeZoneEpoch.(Session_type{sess}));
    [ShockZoneEpoch_Corrected.(Session_type{sess}) , SafeZone2Epoch_Corrected.(Session_type{sess})] = Correct_ZoneEntries_Maze_BM(Unblocked_ActiveShockZoneEpoch.(Session_type{sess}) , Unblocked_ActiveSafeZone2Epoch.(Session_type{sess}));
    
    Position_Active_Unblocked.(Session_type{sess}) = Restrict(Aligned_Position.(Session_type{sess}),and(ActiveEpoch.(Session_type{sess}),UnblockedEpoch.(Session_type{sess})));
    [Thigmo_Active(sess)] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}));
    
end


for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    disp(Session_type{sess})
    
    RespiFzShock.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeShockEpoch.(Session_type{sess}));
    RespiFzSafe.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeSafeEpoch.(Session_type{sess}));
    RespiFzSafe2.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeSafe2Epoch.(Session_type{sess}));
    RespiFzMiddle.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeMiddleEpoch.(Session_type{sess}));
    RespiFzSafeCorner.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeSafeCornerEpoch.(Session_type{sess}));
    RespiFzShockCorner.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeShockCornerEpoch.(Session_type{sess}));
    
     RespiFzShockCamera.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeShockEpoch_camera.(Session_type{sess}));
    RespiFzSafeCamera.(Session_type{sess}) = Restrict(Respi.(Session_type{sess}), FreezeSafeEpoch_camera.(Session_type{sess}));
  
    
    RespiFzShock_mean(sess) = nanmean(Data(RespiFzShock.(Session_type{sess})));
    RespiFzSafe_mean(sess) = nanmean(Data(RespiFzSafe.(Session_type{sess})));
    RespiFzSafe2_mean(sess) = nanmean(Data(RespiFzSafe2.(Session_type{sess})));
    RespiFzMiddle_mean(sess) = nanmean(Data(RespiFzMiddle.(Session_type{sess})));
    RespiFzSafeCorner_mean(sess) = nanmean(Data(RespiFzSafeCorner.(Session_type{sess})));
    RespiFzShockCorner_mean(sess) = nanmean(Data(RespiFzShockCorner.(Session_type{sess})));
   
      RespiFzShock_meanCamera(sess) = nanmean(Data(RespiFzShockCamera.(Session_type{sess})));
    RespiFzSafe_meanCamera(sess) = nanmean(Data(RespiFzSafeCamera.(Session_type{sess})));
  
    SpectroBulbFz.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeEpoch.(Session_type{sess}));
    SpectroBulbFzShock.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeShockEpoch.(Session_type{sess}));
    SpectroBulbFzSafe.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeSafeEpoch.(Session_type{sess}));
    
    SpectroBulbFzCamera.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeEpoch_camera.(Session_type{sess}));
    SpectroBulbFzShockCamera.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeShockEpoch_camera.(Session_type{sess}));
    SpectroBulbFzSafeCamera.(Session_type{sess})= Restrict(SpectroBulb.(Session_type{sess}),FreezeSafeEpoch_camera.(Session_type{sess}));
    
    
    MeanSpectroBulb.(Session_type{sess})=nanmean(Data(SpectroBulb.(Session_type{sess})));
    MeanSpectroBulbCorr.(Session_type{sess})=nanmean(Data(SpectroBulb.(Session_type{sess}))).* RangeLow;
    MeanSpectroBulbFzShock.(Session_type{sess})=nanmean(Data(SpectroBulbFzShock.(Session_type{sess})));
    MeanSpectroBulbFzSafe.(Session_type{sess})=nanmean(Data(SpectroBulbFzSafe.(Session_type{sess})));
    MeanSpectroBulbFzShockCorr.(Session_type{sess})=nanmean(Data(SpectroBulbFzShock.(Session_type{sess}))).* RangeLow;
    MeanSpectroBulbFzSafeCorr.(Session_type{sess})=nanmean(Data(SpectroBulbFzSafe.(Session_type{sess}))).* RangeLow;
    
    
    MeanSpectroBulbFzShockCamera.(Session_type{sess})=nanmean(Data(SpectroBulbFzShockCamera.(Session_type{sess})));
    MeanSpectroBulbFzSafeCamera.(Session_type{sess})=nanmean(Data(SpectroBulbFzSafeCamera.(Session_type{sess})));
    MeanSpectroBulbFzShockCorrCamera.(Session_type{sess})=nanmean(Data(SpectroBulbFzShockCamera.(Session_type{sess}))).* RangeLow;
    MeanSpectroBulbFzSafeCorrCamera.(Session_type{sess})=nanmean(Data(SpectroBulbFzSafeCamera.(Session_type{sess}))).* RangeLow;
    
    
    
    TimeShockZone(sess)= sum(DurationEpoch(ShockZoneEpoch.(Session_type{sess}),'s'));
    TimeSafeZone(sess)= sum(DurationEpoch(SafeZoneEpoch.(Session_type{sess}),'s'));
    TimeSession(sess)= sum(DurationEpoch(TotEpoch.(Session_type{sess}),'s'));
    TimeSafeZone2(sess)= sum(DurationEpoch(SafeZoneEpoch_freezing.(Session_type{sess}),'s'));
    TimeShockUnblocked(sess)= sum(DurationEpoch(ShockZoneEpoch.(Session_type{sess}),'s'));
    
    
    % Shock/Safe zone entries
    
    ShockZoneEntries(sess)= length(Start(ShockZoneEpoch.(Session_type{sess})));
    SafeZoneEntries(sess)= length(Start(SafeZoneEpoch.(Session_type{sess})));
    
    ShockZoneEntriesCorr(sess)= length(Start(ShockZoneEpoch_Corrected.(Session_type{sess})));
    SafeZoneEntriesCorr(sess)= length(Start(SafeZoneEpoch_Corrected.(Session_type{sess})));
    SafeZoneEntries2Corr(sess)= length(Start(SafeZone2Epoch_Corrected.(Session_type{sess})));
    
    ExpeDuration(sess)= sum(DurationEpoch(TotEpoch.(Session_type{sess}),'s'));
    
    FreezeTime_camera(sess)= sum(DurationEpoch(FreezeEpoch_camera.(Session_type{sess}),'s'));
    
    FreezeTime(sess)= sum(DurationEpoch(FreezeEpoch.(Session_type{sess}),'s'));
    FreezeTime_Shock(sess)= sum(DurationEpoch(FreezeShockEpoch.(Session_type{sess}),'s'));
    FreezeTime_Safe(sess)= sum(DurationEpoch(FreezeSafeEpoch.(Session_type{sess}),'s'));
    FreezeTime_Shock_camera(sess)= sum(DurationEpoch(FreezeShockEpoch_camera.(Session_type{sess}),'s'));
    FreezeTime_Safe_camera(sess)= sum(DurationEpoch(FreezeSafeEpoch_camera.(Session_type{sess}),'s'));
    FreezeTime_Safe2(sess)= sum(DurationEpoch(FreezeSafe2Epoch.(Session_type{sess}),'s'));
    FreezeTime_Middle(sess)= sum(DurationEpoch(FreezeMiddleEpoch.(Session_type{sess}),'s'));
    FreezeTime_SafeCorner(sess)= sum(DurationEpoch(FreezeSafeCornerEpoch.(Session_type{sess}),'s'));
    FreezeTime_ShockCorner(sess)= sum(DurationEpoch(FreezeShockCornerEpoch.(Session_type{sess}),'s'));
    
    ActiveTime(sess)= sum(DurationEpoch(ActiveEpoch.(Session_type{sess}),'s'));
    ActiveTime_Shock(sess)= sum(DurationEpoch(ActiveShockEpoch.(Session_type{sess}),'s'));
    ActiveTime_Safe(sess)= sum(DurationEpoch(ActiveSafeEpoch.(Session_type{sess}),'s'));
    
    Freeze_Prop(sess)= FreezeTime(sess)/ TimeSession(sess);
    Freeze_PropCamera(sess)= FreezeTime_camera(sess)/ TimeSession(sess);
    
    FreezeShock_Prop(sess)= FreezeTime_Shock(sess)/ TimeSession(sess);
    FreezeSafe_Prop(sess)= FreezeTime_Safe2(sess)/ TimeSession(sess);
    
    FreezeShock_PropCamera(sess)= FreezeTime_Shock_camera(sess)/ TimeSession(sess);
    FreezeSafe_PropCamera(sess)= FreezeTime_Safe_camera(sess)/ TimeSession(sess);
    
    Active_Prop(sess)= ActiveTime(sess)/ TimeSession(sess);
    
    PropShockZone(sess)= TimeShockZone(sess)/ TimeSession(sess);
    PropSafeZone(sess)= TimeSafeZone(sess)/ TimeSession(sess);
    PropSafeZone2(sess)= TimeSafeZone2(sess)/ TimeSession(sess);
    
    Stim_num(sess)= sum(DurationEpoch(StimEpoch.(Session_type{sess})))/2000;
    Stim_num_unblocked(sess)= sum(DurationEpoch(StimEpochUnblocked.(Session_type{sess})))/2000;
    a = length(StimEpoch2.(Session_type{sess}));
    Stim_num2(sess)= length(a);
    
    [Thigmo_Active(sess)] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}));
    
end

Session_type={'SleepPre','SleepPostPre','SleepPostPost'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    disp(Session_type{sess})
    Ripples.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'ripples');
    Xtsd.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'xposition');
    Ytsd.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'yposition');
    StimEpoch2.(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names) , 'epoch','epochname','vhc_stim');
    a = length(StimEpoch2.(Session_type{sess}));
    Stim_num2(sess) = length(a);
end


%% Figures

% Learning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(241)
plot(Data(XtsdUnblocked.TestPre),Data(YtsdUnblocked.TestPre)), hold on
plot(Data(XtsdFreezing.TestPre),Data(YtsdFreezing.TestPre),'g.','MarkerSize',10)
ylim([-0.3 1.3])
xlim([-0.1 1.1])
title('TestPre')
subplot(242)
plot(Data(XtsdUnblocked.Cond),Data(YtsdUnblocked.Cond)), hold on
plot(Data(XtsdStimUnblocked.Cond),Data(YtsdStimUnblocked.Cond),'r.','MarkerSize',15)
plot(Data(XtsdFreezing_Unblocked.Cond),Data(YtsdFreezing_Unblocked.Cond),'g.','MarkerSize',10)
ylim([-0.3 1.3])
xlim([-0.1 1.1])
title('Cond')
subplot(243)
plot(Data(XtsdUnblocked.TestPost),Data(YtsdUnblocked.TestPost)), hold on
plot(Data(XtsdFreezing.TestPost),Data(YtsdFreezing.TestPost),'g.','MarkerSize',10)
ylim([-0.3 1.3])
xlim([-0.1 1.1])
title('TestPost')


subplot(245)

x = categorical({'TestPre','TestPost'});
x = reordercats(x,{'TestPre','TestPost'});
vals = [ShockZoneEntriesCorr(1) SafeZoneEntries2Corr(1) ; ShockZoneEntriesCorr(2) SafeZoneEntries2Corr(2)];
b = bar(x,vals);
color1 = [1 .5 .5];
color2 = [.5 .5 1];
b(1).FaceColor = color1;
b(2).FaceColor = color2;
title('Numb of zone entries')


subplot(246)

x = categorical({'TestPre','TestPost'});
x = reordercats(x,{'TestPre','TestPost'});
vals = [PropShockZone(1) PropSafeZone(1) ; PropShockZone(2) PropSafeZone(2)];
b = bar(x,vals);
color1 = [1 .5 .5];
color2 = [.5 .5 1];
b(1).FaceColor = color1;
b(2).FaceColor = color2;
title('Prop of time spent in zone')


subplot(247)

x = categorical({'Cond','Ext'});
x = reordercats(x,{'Cond','Ext'});
vals = [FreezeShock_Prop(3) FreezeSafe_Prop(3); FreezeShock_Prop(4) FreezeSafe_Prop(4)];

b = bar(x,vals);
color1 = [1 .5 .5];
color2 = [.5 .5 1];
b(1).FaceColor = color1;
b(2).FaceColor = color2;
title('Freezing prop')

subplot(244)

x = categorical({'Cond','Ext'});
x = reordercats(x,{'Cond','Ext'});
vals = [RespiFzShock_mean(4) RespiFzSafe_mean(4); RespiFzShock_mean(5) RespiFzSafe_mean(5)];

b = bar(x,vals);
color1 = [1 .5 .5];
color2 = [.5 .5 1];
b(1).FaceColor = color1;
b(2).FaceColor = color2;
title('Respi')



subplot(248)

x = categorical({'TestPre','TestPost'});
x = reordercats(x,{'TestPre','TestPost'});
vals = [Thigmo_Active(1);Thigmo_Active(2)];
b = bar(x,vals);
color = [0.5 0.5 0.5];
b.FaceColor = color;
title('Thigmotaxis')

mtitle(Mouse_names);



%% Physio
th = 25;

Sessions = {'Cond','CondPre','ExtPre','CondPost','ExtPost'};
figure
for i = 1:5
subplot(2,5,i)
plot(RangeLow,MeanSpectroBulbFzShock.(Sessions{i}),'r')
hold on
[c,d]=max(MeanSpectroBulbFzShock.(Sessions{i})(th:end));
a = vline(RangeLow(d+th-1),'--r');
plot(RangeLow,MeanSpectroBulbFzSafe.(Sessions{i}),'b')
[~,d]=max(MeanSpectroBulbFzSafe.(Sessions{i})(th:end));
a = vline(RangeLow(d+th-1),'--b');
legend('shock','safe')
makepretty
title(Sessions{i})
xlim([0 10])

subplot(2,5,i+5)
plot(RangeLow,MeanSpectroBulbFzShockCorr.(Sessions{i}),'r')
[~,d]=max(MeanSpectroBulbFzShockCorr.(Sessions{i})(th:end));
hold on
a = vline(RangeLow(d+th-1),'--r');
plot(RangeLow,MeanSpectroBulbFzSafeCorr.(Sessions{i}),'b')
[~,d]=max(MeanSpectroBulbFzSafeCorr.(Sessions{i})(th:end));
a = vline(RangeLow(d+th-1),'--b');
legend('shock','safe')
makepretty
title(Sessions{i})
xlim([0 10])
end
mtitle(Mouse_names);

%%

Cols = {[1 .5 .5],[1 0.8 0.8],[1 0.8 1],[0.8 0.8 1],[0.5 0.5 1]};

figure

subplot(3,4,1:3)
imagesc(Range(SpectroBulbFz.Cond),RangeLow,10*log10(Data(SpectroBulbFz.Cond))');axis xy
% hold on
% try
%     a = plot(Range(RespiFzShock.Cond),runmean_BM(Data(RespiFzShock.Cond),100),'.k');
%     a.Color = Cols{1,1};
% end
% try
%     a = plot(Range(RespiFzShockCorner.Cond),runmean_BM(Data(RespiFzShockCorner.Cond),100),'.r');
%     a.Color = Cols{1,2};
% end
% try
%     a = plot(Range(RespiFzMiddle.Cond),runmean_BM(Data(RespiFzMiddle.Cond),100),'.r');
%     a.Color = Cols{1,3};
% end
% try
%     
%     a = plot(Range(RespiFzSafeCorner.Cond),runmean_BM(Data(RespiFzSafeCorner.Cond),100),'.r');
%     a.Color = Cols{1,4};
% end
% try
%     a = plot(Range(RespiFzSafe2.Cond),runmean_BM(Data(RespiFzSafe2.Cond),100),'.r');
%     a.Color = Cols{1,5};
% end
ylim([0 12])
title('all freezing')


% Epoch = {'Shock','ShockCorner','Middle','SafeCorner','Safe2'}
% Session = 'Cond'
% 
% for epoch = 1:5
%     per(:,1) = Start(eval(strcat('Freeze',Epoch{epoch},'Epoch.',Session)));
%     per(:,2) = Stop(eval(strcat('Freeze',Epoch{epoch},'Epoch.',Session)));
%      for k = 1:size(per)
%         line([per(k,1) per(k,2)]/1e4, [10 10], 'color',Cols{1,epoch}, 'linewidth',5);hold on
%      end  
%     clear per
% end


subplot(3,4,5:7)
imagesc(Range(SpectroBulbFzShock.Cond),RangeLow,10*log10(Data(SpectroBulbFzShock.Cond))');axis xy
% hold on
% a = plot(Range(RespiFzShock.Cond),runmean_BM(Data(RespiFzShock.Cond),100),'.k');
% a.Color = Cols{1,1};
ylim([0 12])
% caxis([0 1.8e6])
title('shock freezing')
subplot(3,4,9:11)
imagesc(Range(SpectroBulbFzSafe.Cond),RangeLow,10*log10(Data(SpectroBulbFzSafe.Cond))');axis xy
% hold on
% a = plot(Range(RespiFzSafe.Cond),runmean_BM(Data(RespiFzSafe.Cond),100),'.k');
% a.Color = Cols{1,5};
ylim([0 12])

% caxis([0 1.8e6])
title('safe freezing')


subplot(1,4,4)

x = categorical({'CondPre','ExtPre','CondPost','ExtPost'});
x = reordercats(x,{'CondPre','ExtPre','CondPost','ExtPost'});
vals = [RespiFzShock_mean(4) RespiFzSafe_mean(4);  RespiFzShock_mean(6) RespiFzSafe_mean(6); RespiFzShock_mean(5) RespiFzSafe_mean(5);  RespiFzShock_mean(7) RespiFzSafe_mean(7)];

b = bar(x,vals);
color1 = [1 .5 .5];
color2 = [.5 .5 1];
b(1).FaceColor = color1;
b(2).FaceColor = color2;
title('Respi Freezing')


% 
% % % % 
% saveFigure_BM(2,'1641_ID2','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/RipInhibSleep/IDCards')
% saveFigure_BM(4,'1685_ID3','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/RipInhibSleep/IDCards')
% saveFigure_BM(3,'1641_ID3','/home/greta/Dropbox/Mobs_member/ChloeHayhurst/Data/UMaze/RipInhibSleep/IDCards')
% 




%%

figure
x = categorical({'Shock','ShockCorner','Middle','SafeCorner','Safe'});
x = reordercats(x,{'Shock','ShockCorner','Middle','SafeCorner','Safe'});
vals = [RespiFzShock_mean(8) RespiFzShockCorner_mean(8) RespiFzMiddle_mean(8) RespiFzSafeCorner_mean(8) RespiFzSafe2_mean(8)];
b = bar(x,vals);
title('Respi Freezing')



