
%% latencies
Group=[13 15 7:8];


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        for sess=1:length(ExtShockSess.(Mouse_names{mouse}))
            
            cd(ExtShockSess.(Mouse_names{mouse}){sess})
            
            clear Behav
            load('behavResources_SB.mat', 'Behav')
            Active.(Mouse_names{mouse}) = intervalSet(0,max(Range(Behav.MovAcctsd)))-Behav.FreezeAccEpoch;
            UnblockedEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(Behav.MovAcctsd)))-intervalSet(0,300e4);
            ZoneEpoch.(Mouse_names{mouse}) = Behav.ZoneEpoch;
            Active_Unblocked.(Mouse_names{mouse}) = and(Active.(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse}));
            
            for zones=1:5
                Zone_c.(Mouse_names{mouse}){zones} = and(ZoneEpoch.(Mouse_names{mouse}){zones} , Active_Unblocked.(Mouse_names{mouse}));
            end
            
            ShockZoneEpoch.(Mouse_names{mouse})=Zone_c.(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Mouse_names{mouse})=or(Zone_c.(Mouse_names{mouse}){2},Zone_c.(Mouse_names{mouse}){5});
            
            [ShockZoneEpoch_Corrected.(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Mouse_names{mouse})] =...
                Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Mouse_names{mouse}) , SafeZoneEpoch.(Mouse_names{mouse}));
            
            try
                clear Sta Sto
%                 Sta  = Start(ShockZoneEpoch_Corrected.(Mouse_names{mouse}))/1e4;
%                 Latency_Shock(mouse,sess) = Sta(1);
                Sto  = Start(SafeZoneEpoch_Corrected.(Mouse_names{mouse}))/1e4-300;
                Latency_Safe{n}(mouse,sess) = Sto(1);
            end
        end
        
        for sess=1:length(ExtSafeSess.(Mouse_names{mouse}))
            
            cd(ExtSafeSess.(Mouse_names{mouse}){sess})
            
            clear Behav
            load('behavResources_SB.mat', 'Behav')
            Active.(Mouse_names{mouse}) = intervalSet(0,max(Range(Behav.MovAcctsd)))-Behav.FreezeAccEpoch;
            UnblockedEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(Behav.MovAcctsd)))-intervalSet(0,300e4);
            ZoneEpoch.(Mouse_names{mouse}) = Behav.ZoneEpoch;
            
            for zones=1:5
                Zone_c.(Mouse_names{mouse}){zones} = and(ZoneEpoch.(Mouse_names{mouse}){zones} , Active_Unblocked.(Mouse_names{mouse}));
            end
            
            ShockZoneEpoch.(Mouse_names{mouse})=Zone_c.(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Mouse_names{mouse})=or(Zone_c.(Mouse_names{mouse}){2},Zone_c.(Mouse_names{mouse}){5});
            
            [ShockZoneEpoch_Corrected.(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Mouse_names{mouse})] =...
                Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Mouse_names{mouse}) , SafeZoneEpoch.(Mouse_names{mouse}));
            
            try
                clear Sta Sto
                %                 Sta  = Start(ShockZoneEpoch_Corrected.(Mouse_names{mouse}))/1e4;
                %                 Latency_Shock(mouse,sess) = Sta(1);
                Sto  = Start(ShockZoneEpoch_Corrected.(Mouse_names{mouse}))/1e4-300;
                Latency_Shock{n}(mouse,sess) = Sto(1);
            end            
        end
        disp(Mouse_names{mouse})
    end
    n=n+1;
end
    
    
Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = 1:4;
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Latency_Safe{1}(:,1) Latency_Safe{2}(:,1) Latency_Safe{3}(:,1) Latency_Safe{4}(:,1)},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(132)
MakeSpreadAndBoxPlot3_SB({Latency_Safe{1}(:,2) Latency_Safe{2}(:,2) Latency_Safe{3}(:,2) Latency_Safe{4}(:,2)},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(133)
MakeSpreadAndBoxPlot3_SB({Latency_Safe{1}(:,3) Latency_Safe{2}(:,3) Latency_Safe{3}(:,3) Latency_Safe{4}(:,3)},Cols,X,Legends,'showpoints',1,'paired',0);



figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Latency_Shock{1}(:,1) Latency_Shock{2}(:,1) Latency_Shock{3}(:,1) Latency_Shock{4}(:,1)},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(132)
MakeSpreadAndBoxPlot3_SB({Latency_Shock{1}(:,2) Latency_Shock{2}(:,2) Latency_Shock{3}(:,2) Latency_Shock{4}(:,2)},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(133)
MakeSpreadAndBoxPlot3_SB({Latency_Shock{1}(:,3) Latency_Shock{2}(:,3) Latency_Shock{3}(:,3) Latency_Shock{4}(:,3)},Cols,X,Legends,'showpoints',1,'paired',0);






%% others



n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sessions_List_ForLoop_BM
            
            TimeMiddle.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){3})) + sum(DurationEpoch(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){4})) + sum(DurationEpoch(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5}));
            %             Time4.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){4}));
            
        end
    end
    n=n+1;
end



figure
MakeSpreadAndBoxPlot3_SB(TimeMiddle.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Time4.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);



figure
for i=1:4
    subplot(1,4,i);
    imagesc(OccupMap_squeeze.All.TestPost{i})
    axis xy; caxis ([0 8e-4])
    %     if group==1; title('Test Pre'); end
    %     ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    %     Maze_Frame_BM
end


figure
for i=1:4
    subplot(1,4,i);
    imagesc(OccupMap_squeeze.Freeze_Blocked.FirstExtSess{i})
    axis xy; caxis ([0 20e-4])
    %     if group==1; title('Test Pre'); end
    %     ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    %     Maze_Frame_BM
end




n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1%:length(Session_type)
            
            Sessions_List_ForLoop_BM
            
            try
                PropTime_Shock.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/(4*180e4);
                PropTime_Safe.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))/(4*180e4);
            end
            try
                Entries_Shock.(Session_type{sess}){n}(mouse) = length(Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
                Entries_Safe.(Session_type{sess}){n}(mouse) = length(Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse})));
            end
            try
                clear Sta Sto
                Sta  = Start(ShockZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Shock.(Session_type{sess}){n}(mouse) = Sta(1);
                Sto  = Start(SafeZoneEpoch_Corrected.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
                Latency_Safe.(Session_type{sess}){n}(mouse) = Sto(1);
            end
            PropTime_Shock.(Session_type{sess}){n}(PropTime_Shock.(Session_type{sess}){n}==0)=NaN; PropTime_Safe.(Session_type{sess}){n}(PropTime_Safe.(Session_type{sess}){n}==0)=NaN;
            Entries_Shock.(Session_type{sess}){n}(Entries_Shock.(Session_type{sess}){n}==0)=NaN; Entries_Safe.(Session_type{sess}){n}(Entries_Safe.(Session_type{sess}){n}==0)=NaN;
            Latency_Shock.(Session_type{sess}){n}(Latency_Shock.(Session_type{sess}){n}==0)=NaN; Latency_Safe.(Session_type{sess}){n}(Latency_Safe.(Session_type{sess}){n}==0)=NaN;
            
        end
    end
    n=n+1;
end




Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = 1:4;
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};


figure
MakeSpreadAndBoxPlot3_SB(PropTime_Shock.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(PropTime_Safe.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);



figure
MakeSpreadAndBoxPlot3_SB(Entries_Shock.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(Entries_Safe.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);



figure
MakeSpreadAndBoxPlot3_SB(Latency_Shock.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(Latency_Safe.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);


OB_Spec.Cond.M1411 = ConcatenateDataFromFolders_SB(CondSess.M1411,'spectrum','prefix','B_Low');




%% OB
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        OB_Spec.Cond.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        OB_Spec_Fz.Cond.(Mouse_names{mouse}) = Restrict(OB_Spec.Cond.(Mouse_names{mouse}),FreezingSafe.Cond.(Mouse_names{mouse}));
        [Sc{n}{mouse},Th,Epoch]=CleanSpectro(OB_Spec_Fz.Cond.(Mouse_names{mouse}),Spectro{3},8);
        
    end
    n=n+1;
end



imagesc(Range(Sc,'s') , Spectro{3} , log10(Data(Sc))'), axis xy

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    figure
    for mouse=1:length(Mouse)
        try
            subplot(2,5,mouse)
            imagesc(Range(Sc{n}{mouse},'s') , Spectro{3} , log10(Data(Sc{n}{mouse}))'), axis xy
        end
    end
    n=n+1;
end





