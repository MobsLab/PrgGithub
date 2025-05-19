
Name = {'RipControlSleepAll','RipInhibSleepAll','RipControlSleep','RipInhibSleep','RipControlWake','RipInhibWake','Baseline','TrueBaseline','Saline','SalineLong','SalineCourt','All'};
Session_type={'TestPre','TestPostPre','TestPostPost','CondPre','CondPost','ExtPre','ExtPost','Cond'};
group = 8;
% group = 9;

%% BEHAVIOUR
% They avoid the shock zone, and freeze in the corners

figure('color',[1 1 1])

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

subplot(241)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPre PropSafeZone.(Name{group}).TestPre},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 0.8]);
ylabel('Prop of time');
title('Test Pre')
makepretty_CH
subplot(242)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPostPre PropSafeZone.(Name{group}).TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 0.8]);
title('Test PostPre')
makepretty_CH
subplot(243)
MakeSpreadAndBoxPlot3_SB({PropShockZone.(Name{group}).TestPostPost PropSafeZone.(Name{group}).TestPostPost },Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 0.8]);
title('Test PostPost')
makepretty_CH
subplot(245)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPre SafeZoneEntries.(Name{group}).TestPre},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 50]);
title('Test Pre')
ylabel('# of entries');
makepretty_CH
subplot(246)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPostPre SafeZoneEntries.(Name{group}).TestPostPre},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 50]);
title('Test PostPre')
makepretty_CH
subplot(247)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries.(Name{group}).TestPostPost SafeZoneEntries.(Name{group}).TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 50]);
title('Test PostPost')
makepretty_CH

subplot(244)
MakeSpreadAndBoxPlot3_SB({FreezeShock_Prop.(Name{group}).Cond FreezeSafe_Prop.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 0.15]);
title('Freezing prop')
makepretty_CH
 
Cols={[.65, .75, 0],[.65, .75, 0],[.65, .75, 0]};
X=[1:3];
Legends={'TestPre','TestPostPre','TestPostPost'};
  
subplot(248)
MakeSpreadAndBoxPlot3_SB({Thigmo_Active.(Name{group}).TestPre Thigmo_Active.(Name{group}).TestPostPre Thigmo_Active.(Name{group}).TestPostPost},Cols,X,Legends,'showpoints',1,'paired',1);
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
Sessions = {'TestPre','CondPre','TestPostPre','CondPost','TestPostPost'};
n = 1;
Mouse=Drugs_Groups_UMaze_CH(group);
for i = 1:5
    subplot(1,5,i)
    a = movmean(OccupMap_squeeze.Unblocked.(Sessions{i}){1},[0 2],2);
    b = movmean(OccupMap_squeeze.Unblocked.(Sessions{i}){1},[2 0],1);
    
    imagesc(movmean(a,[1 0],1)), axis xy, caxis([0 0.0002]);
    colormap pink
    title(Sessions{i})
    makepretty
end



%%

% Cols={[1 .5 .5],[.5 .5 1]};
% X=[1:2];
% Legends={'Shock','Safe'};
% 
% figure
% subplot(121)
% MakeSpreadAndBoxPlot3_SB({GammaPower_Shock_mean.(Name{group}).Cond GammaPower_Safe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1,);
% title('Gamma Power')
% makepretty_CH
% 
% subplot(122)
% MakeSpreadAndBoxPlot3_SB({ThetaPower_Shock_mean.(Name{group}).Cond ThetaPower_Safe_mean.(Name{group}).Cond},Cols,X,Legends,'showpoints',1,'paired',1,);
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
% looking at the breathing or the mean spectrums
figure('color',[1 1 1])
Sessions = {'Cond','CondPre','ExtPre','CondPost','ExtPost'}
Mouse=Drugs_Groups_UMaze_CH(group);
for i = 1:5
    subplot(1,5,i)
    
    Cols = {[1 .5 .5],[.5 .5 1]};
    X=[1:2];
    Legends={'Shock','Safe'};
    
    MakeSpreadAndBoxPlot3_SB({RespiFzShock_mean.(Name{group}).(Sessions{i}) RespiFzSafe_mean.(Name{group}).(Sessions{i})},Cols,X,Legends,'showpoints',1,'paired',1);
    ylim([1.5 6.5])
    makepretty_CH
    title(Sessions{i})
    makepretty_CH
end

mtitle('freezing breathing frequency')


figure('color',[1 1 1])
Sessions = {'Cond','CondPre','ExtPre','CondPost','ExtPost'};
Mouse=Drugs_Groups_UMaze_CH(group);
for i = 1:5
    subplot(1,5,i)
    
    Cols = {[1 .5 .5],[.5 .5 1]};
    X=[1:2];
    Legends={'Shock','Safe'};
    
    MakeSpreadAndBoxPlot3_SB({HR_Fz_Shock_mean.(Name{group}).(Sessions{i}) HR_Fz_Safe_mean.(Name{group}).(Sessions{i})},Cols,X,Legends,'showpoints',1,'paired',1)
    makepretty_CH
    title(Sessions{i});
    makepretty_CH
end

mtitle('Heart Rate');

figure('color',[1 1 1])
Sessions = {'Cond','CondPre','ExtPre','CondPost','ExtPost'};
Mouse=Drugs_Groups_UMaze_CH(group);
for i = 1:5
    subplot(1,5,i)
    
    Cols = {[1 .5 .5],[.5 .5 1]};
    X=[1:2];
    Legends={'Shock','Safe'};
    
    MakeSpreadAndBoxPlot3_SB({HRVar_Fz_Shock_mean.(Name{group}).(Sessions{i}) HRVar_Fz_Safe_mean.(Name{group}).(Sessions{i})},Cols,X,Legends,'showpoints',1,'paired',1)
    makepretty_CH
    title(Sessions{i});
    makepretty_CH
end

mtitle('Heart Rate Variability');



%%
Sessions = {'Fear','CondPre','ExtPre','CondPost','ExtPost'};

figure('color',[1 1 1])

Col1 = [1 .5 .5];
Col2 =[.5 .5 1];
x = 0;
Mouse=Drugs_Groups_UMaze_CH(group);
for i = 1:5
subplot(1,5,i)
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzShock.(Name{group}).(Sessions{i}),'color',Col1);
a.mainLine.LineWidth = 2;
hold on
a = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzSafe.(Name{group}).(Sessions{i}),'color',Col2);
xlim([0 10])
ylim([0 1.1])
title(Sessions{i})
a.mainLine.LineWidth = 2;
makepretty_CH
end

%% SLEEP FEATURES

Cols={[0.3 0.3 0.3],[0.3 0.3 0.3],[0.3 0.3 0.3]};
X=[1:3];
Legends={'Pre','PostPre','PostPost',};

for group = Group
figure('color',[1 1 1])
subplot(222)
MakeSpreadAndBoxPlot3_SB({Frag_REM.(Name{group}).SleepPre Frag_REM.(Name{group}).SleepPostPre Frag_REM.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
title('REM fragmentation')
makepretty_CH
subplot(221)
MakeSpreadAndBoxPlot3_SB({LatencyToSleep.(Name{group}).SleepPre LatencyToSleep.(Name{group}).SleepPostPre LatencyToSleep.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
title('Latency to sleep')
makepretty_CH

subplot(234)
MakeSpreadAndBoxPlot3_SB({Wake_prop.(Name{group}).SleepPre Wake_prop.(Name{group}).SleepPostPre Wake_prop.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('Wake proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(235)
MakeSpreadAndBoxPlot3_SB({REM_prop.(Name{group}).SleepPre REM_prop.(Name{group}).SleepPostPre REM_prop.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('REM proportion')
% ylim([0.1 0.8])
makepretty_CH
subplot(236)
MakeSpreadAndBoxPlot3_SB({NREM_prop.(Name{group}).SleepPre NREM_prop.(Name{group}).SleepPostPre NREM_prop.(Name{group}).SleepPostPost},Cols,X,Legends,'paired',1,'showpoints',1);
ylabel('NREM proportion')
% ylim([0 0.16])
makepretty_CH
mtitle(Name{group})
end

%
% 
% Session_type={'SleepPre','SleepPostPre','SleepPostPost'};
% 
% Col1 = [0.3 0.3 0.3];
% Col2 = [0.7 0.7 0.7];
% 
% time = linspace(1,100,10);
% figure
% j = 1;
% for sess = 1:3
%     subplot(3,3,j), hold on
%     a1 = errorbar(time, nanmean(WakePropTemp.Baseline.(Session_type{sess})),stdError(WakePropTemp.Baseline.(Session_type{sess})),'color',Col1);
%     a2 = errorbar(time, nanmean(WakePropTemp.RipControlSleep.(Session_type{sess})),stdError(WakePropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
%     ylabel(Session_type{sess})
%     xlabel('time (minutes)')
%     title('Wake Prop')
%     legend([a1 a2],'Baseline','RipControl')
%     makepretty_CH
%     j = j+1;
%     subplot(3,3,j), hold on
%     a1 = errorbar(time, nanmean(NREMPropTemp.Baseline.(Session_type{sess})),stdError(NREMPropTemp.Baseline.(Session_type{sess})),'color',Col1);
%     a2 = errorbar(time, nanmean(NREMPropTemp.RipControlSleep.(Session_type{sess})),stdError(NREMPropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
%     ylabel(Session_type{sess})
%     xlabel('time (minutes)')
%     title('NREM Prop')
%     legend([a1 a2],'Baseline','RipControl')
%     makepretty_CH
%     j = j+1;
%     subplot(3,3,j), hold on
%     a1 = errorbar(time, nanmean(REMPropTemp.Baseline.(Session_type{sess})),stdError(REMPropTemp.Baseline.(Session_type{sess})),'color',Col1);
%     a2 = errorbar(time, nanmean(REMPropTemp.RipControlSleep.(Session_type{sess})),stdError(REMPropTemp.RipControlSleep.(Session_type{sess})),'color',Col2);
%     j = j+1;
%     ylim([0 0.3])
%     xlabel('time (minutes)')
%     ylabel(Session_type{sess})
%     title('REM Prop')
%     legend([a1 a2],'Baseline','RipControl')
%     makepretty_CH
% end
% 
% 


Session_type={'SleepPre','SleepPostPre','SleepPostPost'};

Col1 = [0.6, 0.8, 1];
Col2 = [0.2, 0.4, 0.8];
Col3 = [0, 0, 0.5];

time = linspace(1,100,10);

figure

subplot(311), hold on
a1 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPre),stdError(WakePropTemp.(Name{group}).SleepPre),'color',Col1);
a2 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPostPre),stdError(WakePropTemp.(Name{group}).SleepPostPre),'color',Col2);
a3 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPostPost),stdError(WakePropTemp.(Name{group}).SleepPostPost),'color',Col3);

ylabel('Wake')
xlabel('time (minutes)')
legend([a1 a2 a3],'SleepPre','SleepPostPre','SleepPostPost')
makepretty_CH


subplot(312), hold on
a1 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPre),stdError(NREMPropTemp.(Name{group}).SleepPre),'color',Col1);
a2 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPostPre),stdError(NREMPropTemp.(Name{group}).SleepPostPre),'color',Col2);
a3 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPostPost),stdError(NREMPropTemp.(Name{group}).SleepPostPost),'color',Col3);

ylabel('NREM')
xlabel('time (minutes)')
makepretty_CH



subplot(313), hold on
a1 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPre),stdError(REMPropTemp.(Name{group}).SleepPre),'color',Col1);
a2 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPostPre),stdError(REMPropTemp.(Name{group}).SleepPostPre),'color',Col2);
a3 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPostPost),stdError(REMPropTemp.(Name{group}).SleepPostPost),'color',Col3);

ylabel('REM')
xlabel('time (minutes)')
makepretty_CH




Session_type={'SleepPre','SleepPostPre','SleepPostPost'};

Col1 = [0,0,1];
Col2 = [1,0,0];
Col3 = [0,1,0];

time = linspace(1,100,10);

figure

subplot(311), hold on
a1 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPre),stdError(WakePropTemp.(Name{group}).SleepPre),'color',Col1);
a2 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPre),stdError(NREMPropTemp.(Name{group}).SleepPre),'color',Col2);
a3 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPre),stdError(REMPropTemp.(Name{group}).SleepPre),'color',Col3);

ylabel('SleepPre')
xlabel('time (minutes)')
legend([a1 a2 a3],'Wake','NREM','REM')
makepretty_CH

subplot(312), hold on
a1 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPostPre),stdError(WakePropTemp.(Name{group}).SleepPostPre),'color',Col1);
a2 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPostPre),stdError(NREMPropTemp.(Name{group}).SleepPostPre),'color',Col2);
a3 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPostPre),stdError(REMPropTemp.(Name{group}).SleepPostPre),'color',Col3);

ylabel('SleepPostPre')
xlabel('time (minutes)')
legend([a1 a2 a3],'Wake','NREM','REM')
makepretty_CH

subplot(313), hold on
a1 = errorbar(time, nanmean(WakePropTemp.(Name{group}).SleepPostPost),stdError(WakePropTemp.(Name{group}).SleepPostPost),'color',Col1);
a2 = errorbar(time, nanmean(NREMPropTemp.(Name{group}).SleepPostPost),stdError(NREMPropTemp.(Name{group}).SleepPostPost),'color',Col2);
a3 = errorbar(time, nanmean(REMPropTemp.(Name{group}).SleepPostPost),stdError(REMPropTemp.(Name{group}).SleepPostPost),'color',Col3);

ylabel('SleepPostPost')
xlabel('time (minutes)')
legend([a1 a2 a3],'Wake','NREM','REM')
makepretty_CH


    
    


