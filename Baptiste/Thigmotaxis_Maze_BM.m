

GetEmbReactMiceFolderList_BM
Mouse = Drugs_Groups_UMaze_BM(22);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    AlignedPosition = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'alignedposition');
    Zone = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch','epochname' , 'zoneepoch_behav');
    Speed = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'speed');
    Smooth_Speed = tsd(Range(Speed) , movmean(Data(Speed),10));
    Moving = thresholdIntervals(Smooth_Speed , 5 , 'Direction' , 'Above');
    Moving = mergeCloseIntervals(Moving , 1e4);
    Moving = dropShortIntervals(Moving , 1e4);
    [Thigmo_score_moving(mouse), OccupMap] = Thigmo_From_Position_BM(Restrict(AlignedPosition , Moving));
    [Thigmo_score(mouse), OccupMap] = Thigmo_From_Position_BM(AlignedPosition);
    
    [Thigmo_score_moving_shock(mouse), OccupMap] = Thigmo_From_Position_BM(Restrict(Restrict(AlignedPosition , Zone{1}) , Moving));
    [Thigmo_score_shock(mouse), OccupMap] = Thigmo_From_Position_BM(Restrict(AlignedPosition , Zone{1}));
    
    [Thigmo_score_moving_safe(mouse), OccupMap] = Thigmo_From_Position_BM(Restrict(Restrict(AlignedPosition , or(Zone{2},Zone{5})) , Moving));
    [Thigmo_score_safe(mouse), OccupMap] = Thigmo_From_Position_BM(Restrict(AlignedPosition , or(Zone{2},Zone{5})));
    
    disp(mouse)
end



figure
subplot(121)
PlotCorrelations_BM(Thigmo_score_moving_shock , PCVal)
subplot(122)
PlotCorrelations_BM(Thigmo_score_shock , PCVal)

figure
subplot(121)
PlotCorrelations_BM(Thigmo_score_moving_shock , HR_Bef_end_Act-HR_Wake_FirstHour_SleepPre)
subplot(122)
PlotCorrelations_BM(Thigmo_score_shock , HR_Bef_end_Act-HR_Wake_FirstHour_SleepPre)


Cols = {[1 .5 .5],[.5 .5 1]};
X = [1 2.5];
Legends = {'Shock','Safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Thigmo_score_moving_shock Thigmo_score_moving_safe},Cols,X,Legends,'showpoints',0,'paired',1);

subplot(122)
MakeSpreadAndBoxPlot3_SB({Thigmo_score_shock Thigmo_score_safe},Cols,X,Legends,'showpoints',0,'paired',1);








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

GetEmbReactMiceFolderList_BM
Group=1:8;
Session_type={'Habituation','TestPre','Cond','CondPre','CondPost','TestPost'};

Trajectories_Function_Maze_BM

%% all groups
Cols = {[0, 0, 1],[1, 0, 0],[1, .5, .5],[0, .5, 0],[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
Legends = {'Saline_long','Chronic_Flx','Acute_Flx','Midazolam','Saline_short','DZP','RipControl','RipInhib'};
X = [1:8];
NoLegends = {'','','','','','','',''};

% evolution along sessions for Saline
for sess=1:length(Session_type)
    A.(Session_type{sess}) = [Tigmo_score_all.Unblocked.(Session_type{sess}){1} Tigmo_score_all.Unblocked.(Session_type{sess}){5}];
end

figure
MakeSpreadAndBoxPlot2_SB({A.Habituation A.TestPre A.CondPre A.CondPost A.TestPost},{[1 .85 .85],[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},[1:5],{'Habituation','TestPre','CondPre','CondPost','TestPost'},'showpoints',0,'paired',1);
title('Thigmotaxis, Saline n=16')
ylim([.3 1.12]), ylabel('tigmo score (a.u.)')


% Comparison of all drugs groups
figure
for sess=1:length(Session_type)
    subplot(1,6,sess)
    MakeSpreadAndBoxPlot2_SB(Tigmo_score_all.Unblocked.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([0 1.15])
end


figure
PlotCorrelations_BM(A.Habituation,A.TestPre)
axis square, axis xy
xlabel('thigmotaxism, Hab'), ylabel('thigmotaxism, TestPre')
title('Correlations variables Hab-TestPre')

%% correlations
figure
PlotCorrelations_BM(Tigmo_score_all2,Fz_time_all_2)

figure
PlotCorrelations_BM(Tigmo_score_all.Unblocked.Cond{1},FreezingTime.Figure.All.Cond{5})
xlabel('tigmotaxis score (a.u.)')
ylabel('freezing time (min)')
axis square
title('Freezing duration = f(tigmo score), cond sessions, Saline n=9')



figure
PlotCorrelations_BM(Tigmo_score_all.Unblocked.TestPre{1},FreezingTime.Figure.All.Cond{5})
xlabel('tigmotaxis score (a.u.)')
ylabel('freezing time (min)')
axis square
title('Freezing duration (cond) = f(tigmo score, Test Pre), Saline n=9')




figure; n=1;
for sess=1:5
    subplot(1,5,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'optiontest','ttest'); 
    if sess==1; ylabel('thigmo score (a.u.'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.5,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0.2 1.2])
   
    n=n+1;
end



%%

Cols = {[.65, .75, 0],[.63, .08, .18]};
X = 1:2;
Legends = {'Rip sham','Rip inhib'};
NoLegends = {'',''};


figure
for sess=1:4
    for type=1:7
        subplot(4,7,7*(sess-1)+type)
        MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.(Type{type}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0)
        if sess==1; title(Type{type}); end
        if type==1; ylabel(Session_type{sess}); end
    end
end


%%
Group=1:22;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze2_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            try
                Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
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
                
                ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                
                % 4) thigmo
                [Thigmo_score.(Session_type{sess}){n}(mouse), ~] = Thigmo_From_Position_BM(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}));
                
            end
        end
    end
end



A=[];
for group=[1:5 7:15 17:22]
    Mouse=Drugs_Groups_UMaze2_BM(group);
    
    A = [A ; Thigmo_score.TestPre{group}'];
end

A(A==0)=NaN;

for m=1:8
    PathExplo.SD{m}{1}=['/media/nas7/Modelling_Behaviour/Others/10' num2str(m) '/FEAR-Mouse-10' num2str(m) '-08082023-Hab_00/'];
    i=2;
    for c=0:3
        PathExplo.SD{m}{i}=['/media/nas7/Modelling_Behaviour/Others/10' num2str(m) '/FEAR-Mouse-10' num2str(m) '-08082023-TestPre_0',num2str(c)];
        i=i+1;
    end
end

Group={'SD','DZP'};
for group=1%:2
    for mouse=1:8
        %         try
        FreezeEpoch.(Group{group}).Hab{mouse} = ConcatenateDataFromFolders_SB({PathExplo.(Group{group}){mouse}{1}},'epoch','epochname','freeze_epoch_camera');
        FreezeEpoch.(Group{group}).TestPre{mouse} = ConcatenateDataFromFolders_SB(PathExplo.(Group{group}){mouse}(2:5),'epoch','epochname','freeze_epoch_camera');
        
        Position.(Group{group}).Hab{mouse} = ConcatenateDataFromFolders_SB({PathExplo.(Group{group}){mouse}{1}},'AlignedPosition');
        Position.(Group{group}).TestPre{mouse} = ConcatenateDataFromFolders_SB(PathExplo.(Group{group}){mouse}(2:5),'AlignedPosition');
        Position_NoFreeze.(Group{group}).Hab{mouse} = Restrict(Position.(Group{group}).Hab{mouse} , intervalSet(0,max(Range(Position.(Group{group}).Hab{mouse})))-FreezeEpoch.(Group{group}).Hab{mouse});
        Position_NoFreeze.(Group{group}).TestPre{mouse} = Restrict(Position.(Group{group}).TestPre{mouse} , intervalSet(0,max(Range(Position.(Group{group}).TestPre{mouse})))-FreezeEpoch.(Group{group}).TestPre{mouse});
        
        Thigmo_score.(Group{group}).Hab(mouse) = Thigmo_From_Position_BM(Position.(Group{group}).Hab{mouse});
        Thigmo_score.(Group{group}).TestPre(mouse) = Thigmo_From_Position_BM(Position.(Group{group}).TestPre{mouse});
        Thigmo_score_NoFreeze.(Group{group}).Hab(mouse) = Thigmo_From_Position_BM(Position_NoFreeze.(Group{group}).Hab{mouse});
        Thigmo_score_NoFreeze.(Group{group}).TestPre(mouse) = Thigmo_From_Position_BM(Position_NoFreeze.(Group{group}).TestPre{mouse});
        
        %         end
    end
end

%
clear F
F(1:length(A),1)=A;
F(1:length([Thigmo_score.TestPre{9}([1 3:5 7 8 10 12]) Thigmo_score.TestPre{11}]),2)=[Thigmo_score.TestPre{9}([1 3:5 7 8 10 12]) Thigmo_score.TestPre{11}];
F(1:length([Thigmo_score.TestPre{10} Thigmo_score.TestPre{12}]),3)=[Thigmo_score.TestPre{10} Thigmo_score.TestPre{12}];
F(1:length(Thigmo_score.SD.TestPre),4)=Thigmo_score.SD.TestPre;
F(F==0)=NaN;

figure
violinplot(F)
AddStats_BM(F)
AddStats_BM(F,'optiontest','ttest','paired',0,'no_check_distrib',1)
ylabel('thigmo score (a.u.)')
xticklabels({'All','Saline','Diazepam','SD'}), xtickangle(45)












