
Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline'};
Session_type={'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','ExtPre','ExtPost','Cond','Fear'};



%% BEHAVIOUR
% They avoid the shock zone, and freeze in the corners

figure('color',[1 1 1])

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

subplot(241)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPre PropSafeZone.(Name{group}).TestPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
ylabel('Prop of time');
title('Test Pre')
makepretty_CH
subplot(242)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPostPre PropSafeZone.(Name{group}).TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
title('Test PostPre')
makepretty_CH
subplot(243)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPostPost PropSafeZone.(Name{group}).TestPostPost },Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.7]);
title('Test PostPost')
makepretty_CH
subplot(245)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPre SafeZoneEntries.(Name{group}).TestPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test Pre')
ylabel('# of entries');
makepretty_CH
subplot(246)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPostPre SafeZoneEntries.(Name{group}).TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test PostPre')
makepretty_CH
subplot(247)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPostPost SafeZoneEntries.(Name{group}).TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 40]);
title('Test PostPost')
makepretty_CH

subplot(244)
MakeSpreadAndBoxPlot3_SB({FreezeShock_Prop.(Name{group}).Cond FreezeSafe_Prop.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
ylim([0 0.2]);
title('Freezing prop')
makepretty_CH
 
Cols={[.65, .75, 0],[.65, .75, 0],[.65, .75, 0]};
X=[1:3];
Legends={'TestPre','TestPostPre','TestPostPost'};
  
subplot(248)
MakeSpreadAndBoxPlot3_SB({Thigmo_Active.(Name{group}).TestPre Thigmo_Active.(Name{group}).TestPostPre Thigmo_Active.(Name{group}).TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('Thigmotaxis')
makepretty_CH


%%

figure('color',[1 1 1])
Mouse=Drugs_Groups_UMaze_CH(group);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    i = 1;
    subplot(1,5,i) , hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPre.(Mouse_names{mouse})),'k.'),
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPre')
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('CondPre')
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPre.(Mouse_names{mouse})),'k.'),
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPostPre')
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('CondPost')
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdUnblocked.(Name{group}).TestPostPost.(Mouse_names{mouse})),'k.'), hold on
    ylim([-0.2 1.2])
    xlim([-0.1 1.1])
    title('TestPostPost')
    
end

hold on
Mouse=Drugs_Groups_UMaze_CH(group);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    i = 1;

    subplot(1,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'r.','MarkerSize',15)
    plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPre.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdStimUnblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'r.','MarkerSize',15)
    plot(Data(XtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),Data(YtsdFreezing_Unblocked.(Name{group}).CondPost.(Mouse_names{mouse})),'g.','MarkerSize',10)
    i = i+1;
    subplot(1,5,i), hold on
    plot(Data(XtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),Data(YtsdFreezing.(Name{group}).TestPostPost.(Mouse_names{mouse})),'g.','MarkerSize',10)
    
end

mtitle('Unblocked - Eyelid stims (red) - Freezing (green)')



%%

figure('color',[1 1 1])

n = 1;
Mouse=Drugs_Groups_UMaze_CH(group);
i = 1;
subplot(1,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPre{n}), axis xy, caxis([0 0.001]);

title('TestPre')

i = i+1;
caxis([0 2e-4])
subplot(1,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.CondPre{n}), axis xy, caxis([0 0.001]);
title('CondPre')
i = i+1;
caxis([0 2e-4])
subplot(1,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPre{n}), axis xy, caxis([0 0.001]);
title('TestPostPre')
i = i+1;
caxis([0 2e-4])
subplot(1,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.CondPost{n}), axis xy, caxis([0 0.001]);
title('CondPost')
i = i+1;
caxis([0 2e-4])
subplot(1,5,i)
imagesc(OccupMap_squeeze.Active_Unblocked.TestPostPost{n}), axis xy, caxis([0 0.001]);
title('TestPostPost')
n = n+1;
caxis([0 2e-4])
colormap pink
mtitle('Active unblocked')
%%

% Cols={[1 .5 .5],[.5 .5 1]};
% X=[1:2];
% Legends={'Shock','Safe'};
% 
% figure
% subplot(121)
% MakeSpreadAndBoxPlot3_SB({GammaPower_Shock_mean.(Name{group}).Cond GammaPower_Safe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1,,'optiontest','ttest');
% title('Gamma Power')
% makepretty_CH
% 
% subplot(122)
% MakeSpreadAndBoxPlot3_SB({ThetaPower_Shock_mean.(Name{group}).Cond ThetaPower_Safe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1,,'optiontest','ttest');
% title('Theta Power')
% makepretty_CH
% 
% 
% figure
% Cols={[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3]};
% X=[1:7];
% Legends={'TestPre','CondPre','PostPre','ExtPre','CondPost','PostPost','ExtPost'};
% 
% subplot(131)
% MakeSpreadAndBoxPlot3_SB({SleepyProp.(Name{group}).TestPre SleepyProp.(Name{group}).CondPre SleepyProp.(Name{group}).TestPostPre SleepyProp.(Name{group}).ExtPre SleepyProp.(Name{group}).CondPost SleepyProp.(Name{group}).TestPostPost SleepyProp.(Name{group}).ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
% makepretty_CH
% title('sleepy prop')
% 
% subplot(132)
% MakeSpreadAndBoxPlot3_SB({SleepyTime.(Name{group}).TestPre SleepyTime.(Name{group}).CondPre SleepyTime.(Name{group}).TestPostPre SleepyTime.(Name{group}).ExtPre SleepyTime.(Name{group}).CondPost SleepyTime.(Name{group}).TestPostPost SleepyTime.(Name{group}).ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
% makepretty_CH
% title('sleepy time')
% 
% subplot(133)
% MakeSpreadAndBoxPlot3_SB({GammaPower_mean.(Name{group}).TestPre GammaPower_mean.(Name{group}).CondPre GammaPower_mean.(Name{group}).TestPostPre GammaPower_mean.(Name{group}).ExtPre GammaPower_mean.(Name{group}).CondPost GammaPower_mean.(Name{group}).TestPostPost GammaPower_mean.(Name{group}).ExtPost},Cols,X,Legends,'showpoints',1,'paired',1);
% makepretty_CH
% title('mean gamma power')

%% PHYSIOLOGY
% We do find the difference between shock and safe freezing, either by
% looking at the respi or the mean spectrums

figure('color',[1 1 1])

Cols = {[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};
n = 1;
i = 1;
Mouse=Drugs_Groups_UMaze_CH(group);
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).Fear RespiFzSafe_mean.(Name{group}).Fear},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('Fear')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPre RespiFzSafe_mean.(Name{group}).CondPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('CondPre')
% ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPre RespiFzSafe_mean.(Name{group}).ExtPre},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('ExtPre')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).CondPost RespiFzSafe_mean.(Name{group}).CondPost},Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('CondPost')
ylim([1.5 5.5])
makepretty_CH
i = i+1;
subplot(1,5,i)
MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).ExtPost RespiFzSafe_mean.(Name{group}).ExtPost },Cols,X,Legends,'showpoints',1,'paired',1,'optiontest','ttest');
title('ExtPost')
ylim([1.5 5.5])
i = i+1;
n = n+1;
makepretty_CH
mtitle('freezing breathing frequency')



%%

figure('color',[1 1 1])

Col1 = [1 .5 .5];
Col2 =[.5 .5 1];
x = 0;
Mouse=Drugs_Groups_UMaze_CH(group);

subplot(141)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).Fear,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).Fear,'color',Col2);
xlim([0 10])
ylim([0 1.1])
title('Fear')
a.mainLine.LineWidth = 2;
makepretty_CH
subplot(142)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).CondPre,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).CondPre,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPre')
makepretty_CH
subplot(143)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).CondPost,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).CondPost,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('CondPost')
makepretty_CH
subplot(144)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).Cond,'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).Cond,'color',Col2);
a.mainLine.LineWidth = 2;
xlim([0 10])
ylim([0 1.1])
title('Cond')
makepretty_CH

%% SLEEP FEATURES

Cols={[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3]};
X=[1:3];
Legends={'Pre','PostPre','PostPost',};

for group = Group
figure('color',[1 1 1])
subplot(222)
MakeSpreadAndBoxPlot3_SB({Frag_REM.(Name{group}).SleepPre Frag_REM.(Name{group}).SleepPostPre Frag_REM.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1,'optiontest','ttest');
title('REM fragmentation')
makepretty_CH
subplot(221)
MakeSpreadAndBoxPlot3_SB({LatencyToSleep.(Name{group}).SleepPre LatencyToSleep.(Name{group}).SleepPostPre LatencyToSleep.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1,'optiontest','ttest');
title('Latency to sleep')
makepretty_CH

subplot(234)
MakeSpreadAndBoxPlot3_SB({Wake_prop.(Name{group}).SleepPre Wake_prop.(Name{group}).SleepPostPre Wake_prop.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1,'optiontest','ttest');
ylabel('Wake proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(235)
MakeSpreadAndBoxPlot3_SB({REM_prop.(Name{group}).SleepPre REM_prop.(Name{group}).SleepPostPre REM_prop.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1,'optiontest','ttest');
ylabel('REM proportion all')
% ylim([0.1 0.8])
makepretty_CH
subplot(236)
MakeSpreadAndBoxPlot3_SB({REM_prop2.(Name{group}).SleepPre REM_prop2.(Name{group}).SleepPostPre REM_prop2.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1,'optiontest','ttest');
ylabel('REM proportion sleep')
% ylim([0 0.16])
makepretty_CH
mtitle(Name{group})
end

%
Col1 = [0.3 0.3 0.3];
Col2 = [0.7 0.7 0.7];

time = linspace(1,100,10);
figure
j = 1;
for sess = 1:3
    subplot(3,3,j), hold on
    a1 = errorbar(time, nanmean(WakePropTemp.Baseline.(Session_type{sess})),stdError(WakePropTemp.Baseline.(Session_type{sess})),'color',Col1);
    a2 = errorbar(time, nanmean(WakePropTemp.RipControlSleep.(Session_type{sess})),stdError(WakePropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
    ylabel(Session_type{sess})
    xlabel('time (minutes)')
    title('Wake Prop')
    legend([a1 a2],'Baseline','RipControl')
    makepretty_CH
    j = j+1;
    subplot(3,3,j), hold on
    a1 = errorbar(time, nanmean(NREMPropTemp.Baseline.(Session_type{sess})),stdError(NREMPropTemp.Baseline.(Session_type{sess})),'color',Col1);
    a2 = errorbar(time, nanmean(NREMPropTemp.RipControlSleep.(Session_type{sess})),stdError(NREMPropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
    ylabel(Session_type{sess})
    xlabel('time (minutes)')
    title('NREM Prop')
    legend([a1 a2],'Baseline','RipControl')
    makepretty_CH
    j = j+1;
    subplot(3,3,j), hold on
    a1 = errorbar(time, nanmean(REMPropTemp.Baseline.(Session_type{sess})),stdError(REMPropTemp.Baseline.(Session_type{sess})),'color',Col1);
    a2 = errorbar(time, nanmean(REMPropTemp.RipControlSleep.(Session_type{sess})),stdError(REMPropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
    j = j+1;
    ylim([0 0.3])
    xlabel('time (minutes)')
    ylabel(Session_type{sess})
    title('REM Prop')
    legend([a1 a2],'Baseline','RipControl')
    makepretty_CH
end






