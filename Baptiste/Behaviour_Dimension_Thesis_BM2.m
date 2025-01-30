
clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Session_type={'Habituation','TestPre','Cond','TestPost','Ext'};

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','Diazepam'};
NoLegends = {'','','',''};

ind=1:4;
Group=[22];

Side = {'All','Shock','Safe'};
Zones_Lab={'Shock','Shock middle','Middle','Safe middle','Safe'};


%%
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            try
                Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse}))));
                TotalTime.(Session_type{sess}).(Mouse_names{mouse}) = sum(DurationEpoch(TotEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
                ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) - FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse});
                Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = and(ActiveEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
                Position.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'alignedposition');
                Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Position.(Session_type{sess}).(Mouse_names{mouse}) , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
                for zones=1:5
                    Zone_c.(Session_type{sess}).(Mouse_names{mouse}){zones} = and(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){zones} , Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                end
                
                ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=Zone_c.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=or(Zone_c.(Session_type{sess}).(Mouse_names{mouse}){2},Zone_c.(Session_type{sess}).(Mouse_names{mouse}){5});
                
                [ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})] =...
                    Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                
                
                ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                Zone2.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2};
                
                FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
                FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
                
                TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse})));
                
                %   1) stims density
                StimNumber.(Session_type{sess}){n}(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
                StimDensity.(Session_type{sess}){n}(mouse) = length(Start(and(StimEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))./(max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})))/60e4);
                
                % 2) shock zone entries
                ShockEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                SafeEntriesZone.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                ShockZoneEntries_Density.(Session_type{sess}){n}(mouse) = ShockEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                SafeZoneEntries_Density.(Session_type{sess}){n}(mouse) = SafeEntriesZone.(Session_type{sess}){n}(mouse)./(TimeSpent_Unblocked_Active.(Session_type{sess}){n}(mouse)/60e4);
                %
                % 3) freezing proportion, aversiveness
                FreezingAll_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(ShockZone.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_prop.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/sum(DurationEpoch(SafeZone.(Session_type{sess}).(Mouse_names{mouse})));
                
                % 4) thigmo
                [Thigmo_score.(Session_type{sess}){n}(mouse), ~] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
                % 5) occupancy
                ShockZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(ShockZone.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                SafeZone_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(SafeZone.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                Zone2_Occupancy.(Session_type{sess}){n}(mouse) = (sum(DurationEpoch(and(Zone2.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}))))/1e4)/TotalTime.(Session_type{sess}).(Mouse_names{mouse});
                %
                % 6) duration
                Freezing_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezingShock_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                FreezingSafe_Dur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
                
                % 7) latency
                clear Sta Sto
                Sta  = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Shock.(Session_type{sess}){n}(mouse) = Sta(1);
                Sto  = Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Safe.(Session_type{sess}){n}(mouse) = Sto(1);
                
                % 8) proportion for expe duration
                Freezing_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingShock_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingShock.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                FreezingSafe_DurProp.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse})))/max(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                
                % Mean speed
                MeanSpeed.(Session_type{sess}){n}(mouse) = nanmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));
                
            end
            disp(Mouse_names{mouse})
        end
        Ratio_ZoneEntries.(Session_type{sess}){n} = ShockEntriesZone.(Session_type{sess}){n}./SafeEntriesZone.(Session_type{sess}){n};
    end
    n=n+1;
end



MeanSpeed.Cond{1}(MeanSpeed.Cond{1}>40) = nanmedian(MeanSpeed.Cond{1});
StimNumber.Cond{1}(23) = NaN;
Latency_Shock.TestPre{1}(24)=nanmedian(Latency_Shock.TestPre{1});


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
a=barh([1],[-nanmean(Thigmo_score.TestPre{1})+.25],'stacked'); hold on
errorbar(-nanmean(Thigmo_score.TestPre{1})+.25,1,nanstd(Thigmo_score.TestPre{1})/sqrt(length(Thigmo_score.TestPre{1})),0,'.','horizontal','Color','k');
a.FaceColor=[.3 .3 .3]; 

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


%% Freezing quantif
figure
a=barh([1],[-nanmean(FreezingShock_DurProp.Cond{1})-nanmean(FreezingShock_DurProp.Ext{1})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_DurProp.Cond{1})-nanmean(FreezingShock_DurProp.Ext{1}),1,nanstd([FreezingShock_DurProp.Cond{1} + FreezingShock_DurProp.Ext{1}])/sqrt(length(FreezingShock_DurProp.Ext{1})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([1],[nanmean(FreezingSafe_DurProp.Cond{1}) + nanmean(FreezingSafe_DurProp.Ext{1})],'stacked'); 
errorbar(nanmean(FreezingSafe_DurProp.Cond{1}) + nanmean(FreezingSafe_DurProp.Ext{1}),1,0,nanstd([FreezingSafe_DurProp.Cond{1} + FreezingSafe_DurProp.Ext{1}])/sqrt(length(FreezingSafe_DurProp.Cond{1})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1];

plot(-[FreezingShock_DurProp.Cond{1} + FreezingShock_DurProp.Ext{1}] , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [.7 .3 .3] , 'MarkerSize',10)
plot([FreezingSafe_DurProp.Cond{1} + FreezingSafe_DurProp.Ext{1}] , (rand(1,length(Mouse))/2)-.25+1 , '.' , 'Color' , [.3 .3 .7] , 'MarkerSize',10)

xlabel('freezing duration (prop)')
yticklabels({''})
makepretty_BM2
xlim([-.8 .8])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % Figure 2: Behavioral dimensions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Behavioral measures
Cols={[.5 .5 .5],[.4 .4 .4],[.3 .3 .3],[.2 .2 .2]};
X = [1:4];
Legends = {'Hab','Test Pre','Cond','Test Post'};

Cols3={[.3 .3 .3],[.6 .6 .6]};
X3 = [1:2];
Legends3 = {'Test Pre','Test Post'};


% behaviour moving
figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({MeanSpeed.Habituation{1} MeanSpeed.TestPre{1} MeanSpeed.Cond{1} MeanSpeed.TestPost{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Speed (cm/s)')

subplot(142)
MakeSpreadAndBoxPlot3_SB({ShockZoneEntries_Density.Habituation{1} ShockZoneEntries_Density.TestPre{1} ShockZoneEntries_Density.Cond{1} ShockZoneEntries_Density.TestPost{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SZ entries (#/min)')

subplot(143)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPre{1} ShockZone_Occupancy.TestPost{1}},Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)')

subplot(144)
MakeSpreadAndBoxPlot3_SB({Latency_Shock.TestPre{1} Latency_Shock.TestPost{1}},Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('SZ latency (s)')


% others
% Freezing
Cols1={[.3 .3 .3],[.6 .6 .6]};
Cols2={[1 .5 .5],[.8 .3 .3]};
Cols3={[.5 .5 1],[.3 .3 .8]};
X=[1:2];
Legends={'Cond','Recall'};

figure
subplot(151)
A = Freezing_Dur.Cond{1}/60; 
B = Freezing_Dur.Ext{1}/60; 
MakeSpreadAndBoxPlot3_SB({A B},Cols1,X,Legends,'showpoints',1,'paired',0);
ylabel('Freeze time (min)'), ylim([0 30])

subplot(152)
A = FreezingShock_Dur.Cond{1}; 
B = FreezingShock_Dur.Ext{1}; 
MakeSpreadAndBoxPlot3_SB({A B},Cols2,X,Legends,'showpoints',1,'paired',0);
ylabel('Freeze time shock (min)'), ylim([0 30])

subplot(153)
A = FreezingSafe_Dur.Cond{1}; 
B = FreezingSafe_Dur.Ext{1}; 
MakeSpreadAndBoxPlot3_SB({A B},Cols3,X,Legends,'showpoints',1,'paired',0);
ylabel('Freeze time safe (min)'), ylim([0 30])


% Aversive stims
Cols1={[.3 .3 .3]};
X=[1];
Legends={'Cond'};

subplot(154)
A = StimDensity.Cond{1};
MakeSpreadAndBoxPlot4_SB({StimNumber.Cond{1}},Cols1,X,Legends,'showpoints',1,'paired',0);
ylabel('Shocks (#)')

subplot(155)
MakeSpreadAndBoxPlot3_SB({Thigmo_score.Habituation{1} Thigmo_score.TestPre{1} Thigmo_score.Cond{1} Thigmo_score.TestPost{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Thigmotaxis (a.u.)')


%% Correlations between variables
% Within same epoch
figure
subplot(121)
A = MeanSpeed.Cond{1}; 
B = FreezingSafe_prop.Cond{1};
PlotCorrelations_BM(log10(A) , log10(B) , 'method','pearson')
xlabel('Speed, Cond (cm/s)'), ylabel('Freeze time safe, Cond (log scale)')
axis square, grid on

subplot(122)
A = FreezingShock_Dur.Cond{1};
B = FreezingSafe_Dur.Cond{1};
PlotCorrelations_BM(log10(A) , log10(B) , 'method','pearson')
xlabel('Freeze time shock, Cond (log scale)'), ylabel('Freeze time safe, Cond (log scale)')
axis square, grid on


% Predictability
figure
subplot(121)
A = MeanSpeed.TestPre{1};
B = FreezingSafe_Dur.Cond{1}; 
PlotCorrelations_BM(A , B); axis square
xlabel('Speed, Test Pre'), ylabel('Safe freezing duration (min)'), xlim([3 9]), ylim([0 25])
grid on

subplot(122)
A = MeanSpeed.TestPre{1};
B = StimNumber.Cond{1}; B(B>15)=NaN; 
PlotCorrelations_BM(A , B); axis square
xlabel('Speed, Test Pre'), ylabel('Aversive stimulations (#)')
grid on


% along time
figure
subplot(131)
PlotCorrelations_BM(MeanSpeed.Habituation{1} , MeanSpeed.TestPre{1})
axis square
xlabel('Speed, Hab (cm/s)'), ylabel('Speed, Test Pre (cm/s)')

subplot(132)
A = ShockZone_Occupancy.Habituation{1}; A(A==0) = NaN;
PlotCorrelations_BM(A , ShockZone_Occupancy.TestPre{1})
xlabel('SZ occupancy, Hab (prop)'), ylabel('SZ occupancy, Test Pre (prop)')
axis square

subplot(133)
A = Thigmo_score.Habituation{1}; A(A==0) = NaN;
PlotCorrelations_BM(A , Thigmo_score.TestPre{1})
xlabel('Thigmotaxis, Hab (a.u.)'), ylabel('Thigmotaxis, Hab (a.u.)')
axis square


% not conserved
figure
A = ShockZoneEntries_Density.Habituation{1}; A(A==0) = NaN;
PlotCorrelations_BM(A , ShockZoneEntries_Density.TestPre{1})

figure
A = Latency_Shock.TestPre{1}; A(A>100) = NaN;
PlotCorrelations_BM(Latency_Shock.TestPost{1} , A)


%
figure
subplot(131)
[Data_corr1,p1] = corr([Thigmo_score.TestPre{1} ; Thigmo_score.Cond{1} ; Thigmo_score.TestPost{1}]','type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:4]), yticks([1:4])
xticklabels({'Test Pre','Cond','Test Post'}), yticklabels({'Test Pre','Cond','Test Post'})
xtickangle(45)
axis square
makepretty_BM
colorbar

subplot(132)
[Data_corr1,p1] = corr([MeanSpeed.TestPre{1} ; MeanSpeed.Cond{1} ; MeanSpeed.TestPost{1}]','type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:4]), yticks([1:4])
xticklabels({'Test Pre','Cond','Test Post'}), yticklabels({'Test Pre','Cond','Test Post'})
xtickangle(45)
axis square
makepretty_BM
colorbar

subplot(133)
[Data_corr1,p1] = corr([ShockZoneEntries_Density.TestPre{1} ; ShockZoneEntries_Density.Cond{1} ; ShockZoneEntries_Density.TestPost{1}]','type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:4]), yticks([1:4])
xticklabels({'Test Pre','Cond','Test Post'}), yticklabels({'Hab','Test Pre','Cond','Test Post'})
xtickangle(45)
axis square
makepretty_BM
colorbar





%% Dimensions 
% by sessions
figure
A = [ShockZone_Occupancy.TestPre{1} ; ShockZoneEntries_Density.TestPre{1} ; MeanSpeed.TestPre{1} ; -Latency_Shock.TestPre{1} ; Thigmo_score.TestPre{1}];
[Data_corr1,p1] = corr(zscore(A'),'type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:5]), yticks([1:5])
xticklabels({'SZ occupancy','SZ entries','Speed','SZ latency','Thigmotaxis'}), yticklabels({'SZ occupancy','SZ entries','Speed','SZ latency','Thigmotaxis'})
xtickangle(45)
axis square, axis xy


figure
A = [ShockZoneEntries_Density.Cond{1} ; ShockZone_Occupancy.Cond{1} ; StimDensity.Cond{1} ; ...
      MeanSpeed.Cond{1} ; Thigmo_score.Cond{1} ; log10(FreezingShock_Dur.Cond{1}) ; log10(Freezing_Dur.Cond{1}) ;...
    log10(FreezingSafe_Dur.Cond{1})];
ind = ~sum(isnan(A));
[Data_corr1,p1] = corr(zscore(A(:,ind)'),'type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:8]), yticks([1:8])
xticklabels({'SZ entries','SZ occupancy','Shocks','Speed','Thigmotaxis','Fz shock','Fz total','Fz safe'})
yticklabels({'SZ entries','SZ occupancy','Shocks','Speed','Thigmotaxis','Fz shock','Fz total','Fz safe'})
xtickangle(45)
axis square, axis xy



figure
A = [ShockZone_Occupancy.TestPost{1} ; ShockZoneEntries_Density.TestPost{1} ; MeanSpeed.TestPost{1} ;  -Latency_Shock.TestPost{1} ; Thigmo_score.TestPost{1}];
[Data_corr1,p1] = corr(zscore(A'),'type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:5]), yticks([1:5])
xticklabels({'SZ occupancy','SZ entries','Speed','SZ latency','Thigmotaxis'}), yticklabels({'SZ occupancy','SZ entries','Speed','SZ latency','Thigmotaxis'})
xtickangle(45)
axis square, axis xy



figure
A = [FreezingShock_DurProp.Ext{1} ; Freezing_DurProp.Ext{1} ; FreezingSafe_DurProp.Ext{1}];
[Data_corr1,p1] = corr(zscore(A'),'type','pearson');
imagesc(Data_corr1), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:5]), yticks([1:5])
xticklabels({'Fz shock','Fz total','Fz safe'}), yticklabels({'Fz shock','Fz total','Fz safe'})
xtickangle(45)
axis square, axis xy



% Sum up
A = [ShockZone_Occupancy.TestPre{1} ; ShockZoneEntries_Density.TestPre{1} ; MeanSpeed.TestPre{1} ; Thigmo_score.TestPre{1};...
    ShockZoneEntries_Density.Cond{1} ; ShockZone_Occupancy.Cond{1} ; StimDensity.Cond{1} ; MeanSpeed.Cond{1} ;...
    Thigmo_score.Cond{1} ; log10(FreezingShock_DurProp.Cond{1}) ; log10(Freezing_DurProp.Cond{1}) ; log10(FreezingSafe_DurProp.Cond{1});  ...
    ShockZone_Occupancy.TestPost{1} ; ShockZoneEntries_Density.TestPost{1} ; MeanSpeed.TestPost{1} ;  Latency_Shock.TestPost{1} ;...
    Thigmo_score.TestPost{1};];

Params = {'SZ occupancy Pre','SZ entries Pre','Speed Pre','Thigmotaxis Pre',...
    'SZ entries Cond','SZ occupancy Cond','Shocks','Speed Cond',...
    'Thigmotaxis Cond','Fz shock Cond','Fz total Cond','Fz safe Cond',...
    'SZ occupancy Post','SZ entries Post','Speed Post','SZ latency Post', 'Thigmotaxis Post'};

ind = and(~sum(isnan(A)) , ~sum(A==-Inf));

[z,mu,sigma] = zscore(A');
[z,mu,sigma] = zscore(A(:,ind)');
[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(z , Mouse , Params);


clear a, a=v1(7); v1(7)=v1(9); v1(9)=a;
clear a, a=eig1(7,:); eig1(7,:)=eig1(9,:); eig1(9,:)=a;

clear a, a=v1(8); v1(8)=v1(17); v1(17)=a;
clear a, a=eig1(8,:); eig1(8,:)=eig1(17,:); eig1(17,:)=a;

clear a, a=v1(10); v1(10)=v1(16); v1(16)=a;
clear a, a=eig1(10,:); eig1(10,:)=eig1(16,:); eig1(16,:)=a;

clear a, a=v1(11); v1(11)=v1(13); v1(13)=a;
clear a, a=eig1(11,:); eig1(11,:)=eig1(13,:); eig1(13,:)=a;

clear a, a=v1(9); v1(9)=v1(8); v1(8)=a;
clear a, a=eig1(9,:); eig1(9,:)=eig1(8,:); eig1(8,:)=a;

clear a, a=v1(11); v1(11)=v1(9); v1(9)=a;
clear a, a=eig1(11,:); eig1(11,:)=eig1(9,:); eig1(9,:)=a;





for pc=1:size(eig1,2)
    for mouse=1:round(size(z,1))
        
        PC_values_all{pc}(mouse) = eig1(:,pc)'*z(mouse,v1)';
        
    end
end


figure
subplot(141)
imagesc(corr(z(:,v1)))
axis xy, colormap redblue, axis square
xticks([1:20]), yticks([1:20]), xticklabels(Params(v1)), yticklabels(Params(v1)), xtickangle(45)
caxis([-1 1])

subplot(142)
imagesc(eig1(:,1)*eig1(:,1)')
axis xy, colormap redblue, axis square
caxis([-.06 .06])
xticklabels({''}), yticklabels({''})

subplot(143)
imagesc(eig1(:,2)*eig1(:,2)')
axis xy, colormap redblue, axis square
xticklabels({''}), yticklabels({''})
caxis([-.1 .1])

subplot(144)
imagesc(eig1(:,3)*eig1(:,3)')
axis xy, colormap redblue, axis square
caxis([-.15 .3])
xticklabels({''}), yticklabels({''})



X = [64 17 11];
figure
bar(X,'FaceColor',[0 0 0]), xticklabels({'λ1','λ2','λ3','λ4','λ5'})
box off
ylabel('% var explained'), ylim([0 70])



figure
subplot(121)
PlotCorrelations_BM(FreezingSafe_DurProp.Cond{1} , PC_values_all{1})
axis square
xlabel('Freezing safe time, Cond (min)'), ylabel('PC1 values')
xlim([0 .35]), ylim([-6 5])

subplot(122)
PlotCorrelations_BM(Thigmo_score.Cond{1} , PC_values_all{2})
axis square
xlabel('Thigmotaxis, Cond (a.u.)'), ylabel('PC2 values')
xlim([.4 .9]), ylim([-3 4])



figure
subplot(121)
PlotCorrelations_BM(PC_values_all{1} , ShockZoneEntries_Density.TestPre{1})
axis square
xlabel('PC1 values'), ylabel('SZ entries, Test Pre (#/s)')

subplot(122)
PlotCorrelations_BM(PC_values_all{1} , ShockZoneEntries_Density.TestPost{1})
axis square
xlabel('PC1 values'), ylabel('SZ entries, Test Post (#/s)')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % Individuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identif using k-means, to do on Matlab 2021
addpath(genpath('/home/ratatouille/Documents/MATLAB/'))
addpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/'))

rmpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/mvgc_v1.0/'));
rmpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion'))


load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/PC_Behav.mat')
clear IDX C SUMD D
z = [-PC_values_all{1} ; PC_values_all{2}]';

for k=1:10
    [IDX{k}, C{k}, SUMD{k}, D{k}] = kmeans_BM(z(:,1:2),k);
    mean_square_dist(k) = sum(sqrt(SUMD{k}));
    for i=1:k
        mean_square_dist2{k}{i} = D{k}(find(IDX{k}==i),i);
    end
end

for k=1:10
    MSD{k} = [];
    for i=1:k
        MSD{k} = [MSD{k} ; mean_square_dist2{k}{i}];
    end
    MSD_f(k) = sum(sqrt(MSD{k}));
end

figure
plot(MSD_f,'k'), hold on, 
xlabel('k number'), ylabel('sum of squared distance')
makepretty
plot(MSD_f,'.','MarkerSize',30,'Color','k')
xticks([0:2:10])


clear IDX C SUMD D
[IDX, C, SUMD, D] = kmeans_BM(z(:,1:2),4);



figure
[DIST_intra{1}] = Make_PCA_Plot_BM(PC_values_all{1}(and(PC_values_all{1}<0 , PC_values_all{2}<0)) , PC_values_all{2}(and(PC_values_all{1}<0 , PC_values_all{2}<0)) , 'color' , [.5 .3 .8]);
[DIST_intra{2}] = Make_PCA_Plot_BM(PC_values_all{1}(and(PC_values_all{1}<0 , PC_values_all{2}>0)) , PC_values_all{2}(and(PC_values_all{1}<0 , PC_values_all{2}>0)) , 'color' , [.8 .3 .5]);
[DIST_intra{3}] = Make_PCA_Plot_BM(PC_values_all{1}(and(PC_values_all{1}>0 , PC_values_all{2}<0)) , PC_values_all{2}(and(PC_values_all{1}>0 , PC_values_all{2}<0)) , 'color' , [.3 .5 .8]);
[DIST_intra{4}] = Make_PCA_Plot_BM(PC_values_all{1}(and(PC_values_all{1}>0 , PC_values_all{2}>0)) , PC_values_all{2}(and(PC_values_all{1}>0 , PC_values_all{2}>0)) , 'color' , [.8 .5 .3]);
axis square, grid on
xlabel('PC1 values'), ylabel('PC2 values')
xlim([-4 4])

SUM2= [];
for i=1:4
    SUM2 = [SUM2 DIST_intra{i}];
end
plot(4 , sum(sqrt(SUM2)) , '.r' , 'MarkerSize' , 40)





% checking parameters 
Cols = {[.5 .3 .8],[.8 .3 .5],[.3 .5 .8],[.8 .5 .3]};
X = [1:4];
Legends = {'Fear- Anx-','Fear- Anx+','Fear+ Anx-','Fear+ Anx+'};

ind1 = and(PC_values_all{1}<0 , PC_values_all{2}>0);
ind2 = and(PC_values_all{1}<0 , PC_values_all{2}<0);
ind3 = and(PC_values_all{1}>0 , PC_values_all{2}>0);
ind4 = and(PC_values_all{1}>0 , PC_values_all{2}<0);

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({FreezingSafe_Dur.Cond{1}(ind1)/60 FreezingSafe_Dur.Cond{1}(ind2)/60,...
    FreezingSafe_Dur.Cond{1}(ind3)/60 FreezingSafe_Dur.Cond{1}(ind4)/60},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Fz safe time, Cond (min)')

subplot(132)
MakeSpreadAndBoxPlot3_SB({Thigmo_score.Cond{1}(ind1) Thigmo_score.Cond{1}(ind2),...
    Thigmo_score.Cond{1}(ind3) Thigmo_score.Cond{1}(ind4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Thigmotaxis, Cond (a.u.)')

subplot(133)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1}(ind1) ShockZone_Occupancy.TestPost{1}(ind2),...
    ShockZone_Occupancy.TestPost{1}(ind3) ShockZone_Occupancy.TestPost{1}(ind4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SZ entries, Test Post (#/s)')



% physio
figure
subplot(131)
D = DATA_SAL(1,31:60);
MakeSpreadAndBoxPlot3_SB({D(ind1) D(ind2) D(ind3) D(ind4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Breathing, safe Fz (Hz)')

subplot(132)
D = DATA_SAL(7,1:30);
MakeSpreadAndBoxPlot3_SB({D(ind1) D(ind2) D(ind3) D(ind4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('HPC theta, shock Fz (Hz)')

Cols2 = {[.3 .3 .3],[.8 .5 .3]};
X2 = [1:2];
Legends2 = {'Fear- Anx+ (1)','Fear- Anx+ (2)'};

subplot(133)
D = DATA_SAL(5,1:30);
MakeSpreadAndBoxPlot3_SB({D(ind1) D(ind2) D(ind3) D(ind4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB gamma power, shock Fz (a.u.)')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % Behavior - Physio correlations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Group=22;
Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition');

        [OutPutData2.(Session_type{sess}) , ~ , ~] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'ob_low');
end


Params = {'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta'};

clear DATA_SAL
figure, [~ , ~ , Freq_Max_Shock_SAL] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe_SAL] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Session_type{sess}).ob_low.mean(:,6,:))); close
figure, [~ , ~ , Freq_Max_Safe_Act] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Session_type{sess}).ob_low.mean(:,3,:))); close

ind_mouse=1:length(Mouse);

DATA_SAL(1,:) = [Freq_Max_Shock_SAL(ind_mouse) Freq_Max_Safe_SAL(ind_mouse) Freq_Max_Safe_Act];

n=2;
for par=[2:8]
    DATA_SAL(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,3)'];
    n=n+1;
end


DATA_SAL(1,[3 18]) = NaN;
DATA_SAL(3,43)=NaN;

figure
for pc=1:2
    for param=1:8
        subplot(2,8,(pc-1)*8+param)
        [R_so(pc,param),P_so(pc,param)] = PlotCorrelations_BM(DATA_SAL(param,1:30) , PC_values_all{pc});
    end
end
close
figure
subplot(211)
imagesc(R_so), colormap redblue
caxis([-1 1])
hold on
[r,c] = ind2sub([2 8],find(and(P_so<.05 , abs(R_so)>.35)));
plot(c,r,'*k')
yticks([1:2]), xticklabels({''}), yticklabels({'PC1','PC2','PC3'})

figure
for pc=1:2
    for param=1:8
        subplot(2,8,(pc-1)*8+param)
        [R_sa(pc,param),P_sa(pc,param)] = PlotCorrelations_BM(DATA_SAL(param,31:60) , PC_values_all{pc});
    end
end
close
subplot(212)
imagesc(R_sa), colormap redblue
caxis([-1 1])
hold on
[r,c] = ind2sub([2 8],find(and(P_sa<.05 , abs(R_sa)>.35)));
plot(c,r,'*k')
yticks([1:2]), xticklabels({''}), yticklabels({'PC1','PC2','PC3'})

% figure
% for pc=1:2
%     for param=1:8
%         subplot(2,8,(pc-1)*8+param)
%         try, [R_act(pc,param),P_act(pc,param)] = PlotCorrelations_BM(DATA_SAL(param,61:90) , PC_values_all{pc}); end
%     end
% end
% close
% subplot(313)
% imagesc(R_act), colormap redblue
% caxis([-1 1])
% hold on
% [r,c] = ind2sub([2 8],find(and(P_act<.05 , abs(R_act)>.35)));
% plot(c,r,'*k')
xticks([1:8]), xticklabels({'Breathing','Heart rate','Heart rate var','OB gamma frequency','OB gamma power','Ripples occurence','HPC theta frequency','HPC theta-delta'})
yticks([1:2]), xtickangle(45), yticklabels({'PC1','PC2'})



% what can we infer ?
figure
subplot(121)
PlotCorrelations_BM(Freq_Max_Safe_SAL , FreezingSafe_Dur.Cond{1}/60)
axis square
xlabel('Breathing safe Fz, Cond (Hz)'), ylabel('Freeze time Safe Fz, Cond'), xlim([1 6])

subplot(122)
A = Thigmo_score.TestPre{1}; A(A<.3)=NaN;
B = OutPutData.Cond.hpc_theta_freq.mean(:,5); %B(B<5.8)=NaN;
PlotCorrelations_BM(B , A)
axis square
ylabel('HPC theta frequency shock Fz, Cond (Hz)'), xlabel('Thigmotaxis, Test Pre (a.u.)')
xlim([5.3 7.5])




%% tools
figure
for i=1:3
    for param=1:8
        subplot(3,8,(i-1)*8+param)
        
        if i==1
            D = DATA_SAL(:,1:30);
        elseif i==2
            D = DATA_SAL(:,31:60);
        else
            D = DATA_SAL(:,61:90);
        end
        
        MakeSpreadAndBoxPlot3_SB({D(param,IDX==3) D(param,IDX==1) D(param,IDX==2) D(param,IDX==5) D(param,IDX==4)},Cols,X,Legends,'showpoints',1,'paired',0);
        
    end
end











%% others



Mouse(find(and(and(PC_values_all{1}<-1 , abs(PC_values_all{2})<1) , abs(PC_values_all{3})<1)))

figure
clear D
D = Data(Restrict(Position.Cond.M666 , UnblockedEpoch.Cond.M666));
subplot(121)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off

clear D
D = Data(Restrict(Position.Cond.M1392 , UnblockedEpoch.Cond.M1392));
subplot(122)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off


Mouse(find(and(and(abs(PC_values_all{1})<1 , PC_values_all{2}>1) , abs(PC_values_all{3})<1)))

figure
clear D
D = Data(Restrict(Position.Cond.M669 , UnblockedEpoch.Cond.M669));
subplot(121)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off
title('High PC2')

clear D
D = Data(Restrict(Position.Cond.M777 , UnblockedEpoch.Cond.M777));
subplot(122)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off
title('Low PC2')


Mouse(find(and(and(abs(PC_values_all{1})<1 , abs(PC_values_all{2})<1) , PC_values_all{3}<-1)))

figure
clear D
D = Data(Restrict(Position.Cond.M1171 , UnblockedEpoch.Cond.M1171));
subplot(121)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off
title('High PC3')

clear D
D = Data(Restrict(Position.Cond.M1144 , UnblockedEpoch.Cond.M1144));
subplot(122)
plot(D(:,1) , D(:,2))
xlim([0 1]), ylim([0 1]), axis square, axis off
title('Low PC3')












idx(PC_values_all{1}>median(PC_values_all{1}))=1;
idx(PC_values_all{1}<=median(PC_values_all{1}))=2;
idx(ShockZone_Occupancy.TestPost{1}>.055)=3;

Legends = {'freezing strat','shocks strat','bad memory'};

figure
subplot(121)
A = PC_values_all{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('PC1 values')

subplot(122)
A = ShockZone_Occupancy.TestPost{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SZ occupancy, Test Post')


Cols = {[.5 .3 .8],[.7 .5 .8],[.8 .5 .3],[.8 .7 .5],[.3 .3 .3]};
X = [1:5];
Legends = {'Fear+ Anx-','Fear+ Anx+','Fear- Anx-','Fear- Anx+','no learning'};

figure
subplot(151)
A = FreezingShock_Dur.Cond{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Fz shock time, Cond (min)')
subplot(152)
A = FreezingSafe_Dur.Cond{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Fz safe time, Cond (min)')
subplot(153)
A = (4*sqrt(FreezingShock_Dur.Cond{1}))./FreezingSafe_Dur.Cond{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0)
% A = FreezingShock_Dur.Cond{1}./FreezingSafe_Dur.Cond{1};
% MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('ratio safe/shock')

subplot(154)
A = StimNumber.Cond{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shocks (#)')

subplot(155)
A = ShockZone_Occupancy.TestPost{1};
MakeSpreadAndBoxPlot3_SB({A(idx==1) A(idx==2) A(idx==3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SZ occupancy, Test Post')






