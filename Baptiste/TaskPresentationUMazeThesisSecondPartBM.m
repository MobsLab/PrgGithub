%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % Figure 1: Task presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% behavior shock/safe
% Shock-Safe
Cols = {[1 .5 .5],[.5 .5 1]};
X = [1 2];
Legends = {'Shock','Safe'};

figure
subplot(161)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPre{1} Zone2_Occupancy.TestPre{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('proportion of time'), ylim([0 1]), makepretty_BM
subplot(162)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} Zone2_Occupancy.TestPost{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('proportion of time'), ylim([0 1]), makepretty_BM

subplot(163)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.TestPre{1} SafeZoneEntries_Density.TestPre{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('entries (#/min)'), ylim([0 4.5]), makepretty_BM
subplot(164)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.TestPost{1} SafeZoneEntries_Density.TestPost{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('entries (#/min)'), ylim([0 4.5]), makepretty_BM

subplot(165)
MakeSpreadAndBoxPlot3_SB({Latency_Shock.TestPre{1} Latency_Safe.TestPre{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('latency (s)'), ylim([0 800]), makepretty_BM
subplot(166)
MakeSpreadAndBoxPlot3_SB({Latency_Shock.TestPost{1} Latency_Safe.TestPost{1}},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('latency (s)'), ylim([0 800]), makepretty_BM


%% Freezing quantif
figure
subplot(121)
imagesc(SmoothDec(OccupMap_squeeze.Freeze_Blocked.Fear{1},2))
axis xy, axis off, hold on, axis square, c=caxis; %caxis([0 1e-3])
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
title('Blocked')

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


figure
A = FreezingShock_Dur.Cond{1} + FreezingShock_Dur.Ext{1}; A=A/60;
B = FreezingSafe_Dur.Cond{1} + FreezingSafe_Dur.Ext{1}; B=B/60;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('freezing duration (min)')
makepretty_BM2

% figure
% a=barh([1],[-nanmean(FreezingShock_DurProp.Cond{1})-nanmean(FreezingShock_DurProp.Ext{1})],'stacked'); hold on
% errorbar(-nanmean(FreezingShock_DurProp.Cond{1})-nanmean(FreezingShock_DurProp.Ext{1}),1,nanstd([FreezingShock_DurProp.Cond{1} + FreezingShock_DurProp.Ext{1}])/sqrt(length(FreezingShock_DurProp.Ext{1})),0,'.','horizontal','Color','k');
% a.FaceColor=[1 .5 .5]; 
% 
% a=barh([1],[nanmean(FreezingSafe_DurProp.Cond{1}) + nanmean(FreezingSafe_DurProp.Ext{1})],'stacked'); 
% errorbar(nanmean(FreezingSafe_DurProp.Cond{1}) + nanmean(FreezingSafe_DurProp.Ext{1}),1,0,nanstd([FreezingSafe_DurProp.Cond{1} + FreezingSafe_DurProp.Ext{1}])/sqrt(length(FreezingSafe_DurProp.Cond{1})),'.','horizontal','Color','k');
% a.FaceColor=[.5 .5 1];
% 
% plot(-[FreezingShock_DurProp.Cond{1} + FreezingShock_DurProp.Ext{1}] , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [.7 .3 .3] , 'MarkerSize',10)
% plot([FreezingSafe_DurProp.Cond{1} + FreezingSafe_DurProp.Ext{1}] , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [.3 .3 .7] , 'MarkerSize',10)
% 
% xlabel('freezing duration (prop)')
% yticklabels({''})
% makepretty_BM2
% xlim([-.8 .8])



%% thigmo
mouse=3;
for sess=1:length(Session_type)
    NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
    Moving=thresholdIntervals(NewSpeed,1,'Direction','Above');
    Moving=mergeCloseIntervals(Moving,0.3*1e4);
    Moving=dropShortIntervals(Moving,0.3*1e4);
    Pos_Moving.(Session_type{sess}) = Restrict(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , Moving);
    D = Data(Pos_Moving.(Session_type{sess}));
    OccupMap.(Session_type{sess}) = hist2d([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , 100 , 100);
end
  
figure
subplot(121)
imagesc(SmoothDec(OccupMap.TestPre'  ,2))
axis xy, axis off, hold on, axis square, c=caxis; caxis([0 2])
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[7 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

subplot(122)
imagesc(SmoothDec(OccupMap.TestPost'  ,2))
axis xy, axis off, hold on, axis square, caxis([0 2]), c=caxis; 
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

colormap gray


figure
A = Thigmo_score.TestPre{1};
B = Thigmo_score.TestPost{1};
MakeSpreadAndBoxPlot3_SB({A B},{[.3 .3 .3],[.5 .5 .5]},X,{'Test Pre','Test Post'},'showpoints',0,'paired',1)
ylabel('thigmo score (a.u.)')
makepretty_BM2


figure
a=barh([1],[-nanmean(Thigmo_score.TestPre{1})+.25],'stacked'); hold on
errorbar(-nanmean(Thigmo_score.TestPre{1})+.25,1,nanstd(Thigmo_score.TestPre{1})/sqrt(length(Thigmo_score.TestPre{1})),0,'.','horizontal','Color','k');
a.FaceColor=Cols{5}; 

a=barh([1],[nanmean(Thigmo_score.TestPost{1})-.25],'stacked'); 
errorbar(nanmean(Thigmo_score.TestPost{1})-.25,1,0,nanstd([Thigmo_score.TestPost{1}])/sqrt(length(Thigmo_score.TestPost{1})),'.','horizontal','Color','k');
a.FaceColor=[.6 .6 .6];

plot(-Thigmo_score.TestPre{1}+.25 , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [0 0 0] , 'MarkerSize',10)
plot(Thigmo_score.TestPost{1}-.25 , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [0 0 0] , 'MarkerSize',10)

xlabel('thigmo score (a.u.)')
makepretty_BM2
xlim([-.8 .8])
xticks([-.75 -.5 -.25 0 .25 .5 .75])
xticklabels({'-1','-0.75','-0.50','','0.50','0.75'})


