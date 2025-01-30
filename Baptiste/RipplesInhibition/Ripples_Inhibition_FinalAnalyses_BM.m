

Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18],[.45, .75, 0],[.43, .08, .18]};
X = 1:6;
Legends = {'Saline','Diazepam','Rip sham 1','Rip inhib 1','Rip sham 2','Rip inhib 2'};
NoLegends = {'','','','','',''};
ind=X;

Cols2 = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X2 = 1:4;
Legends2 = {'Saline','Diazepam','Rip sham all','Rip inhib all'};
NoLegends2 = {'','','',''};
ind=X;



%% significative differences
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Dist_Traveled_Unblocked_Active.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(Speed.(Session_type{sess}).(Mouse_names{mouse}) , ActiveEpoch_Unblocked.(Session_type{sess}).(Mouse_names{mouse}))));
            
        end
    end
    n=n+1;
end

% distance traveled
figure; n=1;
for sess=[1 2 4]
    subplot(1,3,n)
    MakeSpreadAndBoxPlot3_SB(Dist_Traveled_Unblocked_Active.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('distance traveled (a.u.)'); end
    title(Session_type{sess})
    ylim([0 13])
    n=n+1;
end

% freezing proportion
figure
for side=1:3
    subplot(2,3,side)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{side}).Cond,Cols,X,NoLegends,'showpoints',1,'paired',0);
    title(Side{side})
    
    subplot(2,3,side+3)
    MakeSpreadAndBoxPlot3_SB(Proportionnal_Time_Freezing_ofZone.(Side{side}).Ext,Cols,X,Legends,'showpoints',1,'paired',0);
end





clear A
for side=1:3
    for sess=1:6
        
        A.(Side{side}).(Session_type{sess}){1} = Proportional_TimeFz.(Side{side}).(Session_type{sess}){1};
        A.(Side{side}).(Session_type{sess}){2} = Proportional_TimeFz.(Side{side}).(Session_type{sess}){2};
        A.(Side{side}).(Session_type{sess}){3} = [Proportional_TimeFz.(Side{side}).(Session_type{sess}){3} Proportional_TimeFz.(Side{side}).(Session_type{sess}){5}];
        A.(Side{side}).(Session_type{sess}){4} = [Proportional_TimeFz.(Side{side}).(Session_type{sess}){4} Proportional_TimeFz.(Side{side}).(Session_type{sess}){6}];
        
    end
end

figure; sess=2;
for side=1:3
    subplot(1,3,side)
    MakeSpreadAndBoxPlot3_SB(A.(Side{side}).(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
    if side==1; ylabel('freezing proportion, Cond'); end
    title(Side{side})
end

figure; sess=3;
for side=1:3
    subplot(1,3,side)
    MakeSpreadAndBoxPlot3_SB(A.(Side{side}).(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
    if side==1; ylabel('freezing proportion, Ext'); end
    title(Side{side})
end


figure; n=1;
for sess=[2 3]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 17])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot3_SB(FzEMeanDuration.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('time (s)'); end
    ylim([0 20])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    
    n=n+1;
end
a=suptitle('Freezing episodes mean duration'); a.FontSize=20;


figure
MakeSpreadAndBoxPlot3_SB(FzEpNumber.Shock.Cond,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing shock, ep number (#)')

figure
MakeSpreadAndBoxPlot3_SB(FzEpNumber.Shock.Ext,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing shock, ep number (#)')



figure; n=1;
for sess=[2 3]
    subplot(3,2,n)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.All.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'All'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([0 5.1])
    
    subplot(3,2,n+2)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Shock.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    %     ylim([0 4])
    if n==1; u=text(-1,1.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    subplot(3,2,n+4)
    MakeSpreadAndBoxPlot3_SB(FzEpNumber.Safe.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('#'); end
    %     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Freezing episodes number'); a.FontSize=20;


% OB
group1 = 7; group2 = 8;

figure
subplot(221)
[~ , ~ , Freq_Max.(Drug_Group{group1}).Cond.Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group1}).Cond.ob_low.mean(:,5,:)) , 'color' , 'r' , 'threshold' , 39);
[~ , ~ , Freq_Max.(Drug_Group{group2}).Cond.Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group2}).Cond.ob_low.mean(:,5,:)) , 'color' , [1 .5 .5] , 'threshold' , 39);
xlim([0 10]), ylim([0 1])

subplot(222)
[~ , ~ , Freq_Max.(Drug_Group{group1}).Cond.Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group1}).Cond.ob_low.mean(:,6,:)) , 'color' , 'b' , 'threshold' , 26);
[~ , ~ , Freq_Max.(Drug_Group{group2}).Cond.Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group2}).Cond.ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'threshold' , 26);
xlim([0 10]), ylim([0 1])

subplot(223)
[~ , ~ , Freq_Max.(Drug_Group{group1}).Ext.Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group1}).Ext.ob_low.mean(:,5,:)) , 'color' , 'r' , 'threshold' , 26);
[~ , ~ , Freq_Max.(Drug_Group{group2}).Ext.Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group2}).Ext.ob_low.mean(:,5,:)) , 'color' , [1 .5 .5] , 'threshold' , 26);
xlim([0 10]), ylim([0 1])

subplot(224)
[~ , ~ , Freq_Max.(Drug_Group{group1}).Ext.Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group1}).Ext.ob_low.mean(:,6,:)) , 'color' , 'b' , 'threshold' , 26);
[~ , ~ , Freq_Max.(Drug_Group{group2}).Ext.Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Drug_Group{group2}).Ext.ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'threshold' , 26);
xlim([0 10]), ylim([0 1])



Cols = {[1 .5 .5],[1 .3 .3],[.5 .5 1],[.3 .3 1]};
X = 1:4;
Legends = {'Shock Rip Control','Shock Rip Inhib','Safe Rip Control','Safe Rip Inhib'};
NoLegends = {'','','',''};
ind=X;

OB_MaxFreq_Maze_BM

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({...
    OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
    OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 6.5])
ylabel('Frequency (Hz)')
title('Cond')

subplot(122)
MakeSpreadAndBoxPlot3_SB({...
    OB_Max_Freq.RipControl.Ext.Shock OB_Max_Freq.RipInhib.Ext.Shock...
    OB_Max_Freq.RipControl.Ext.Safe OB_Max_Freq.RipInhib.Ext.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([2 6.5])
title('Ext')



%% tendancies
figure; n=1;
for sess=[5 6 4]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    %     ylim([0 5.1])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(SafeEntriesZone.(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; ylabel('entries/min'); end
    %     ylim([0 4])
    if n==1; u=text(-1,1.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    
    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;


figure
MakeSpreadAndBoxPlot3_SB(ShockEntriesZone.TestPost,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('shock zone entries, TestPost (#/min)')

clear A B
for sess=1:6
    
    A.(Session_type{sess}){1} = SafeEntriesZone.(Session_type{sess}){1};
    A.(Session_type{sess}){2} = SafeEntriesZone.(Session_type{sess}){2};
    A.(Session_type{sess}){3} = [SafeEntriesZone.(Session_type{sess}){3} SafeEntriesZone.(Session_type{sess}){5}];
    A.(Session_type{sess}){4} = [SafeEntriesZone.(Session_type{sess}){4} SafeEntriesZone.(Session_type{sess}){6}];
    
    B.(Session_type{sess}){1} = ShockEntriesZone.(Session_type{sess}){1};
    B.(Session_type{sess}){2} = ShockEntriesZone.(Session_type{sess}){2};
    B.(Session_type{sess}){3} = [ShockEntriesZone.(Session_type{sess}){3} ShockEntriesZone.(Session_type{sess}){5}];
    B.(Session_type{sess}){4} = [ShockEntriesZone.(Session_type{sess}){4} ShockEntriesZone.(Session_type{sess}){6}];
    
end

figure, sess=4;
subplot(121)
MakeSpreadAndBoxPlot3_SB(A.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('safe zone entries, TestPost (#/min)')
subplot(122)
MakeSpreadAndBoxPlot3_SB(B.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('shock zone entries, TestPost (#/min)')


%% no effect
figure; n=1;
for sess=[5 6 4]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{2}).(Session_type{sess})([ind]),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 .6])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot3_SB(Proportional_Time_Unblocked.(Side{3}).(Session_type{sess})([ind]),Cols,X,Legends,'showpoints',1,'paired',0);
    if n==1; ylabel('prop time'); end
    if n==1; u=text(-1,.4,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',15); end
    ylim([0 1.1])
    
    n=n+1;
end
a=suptitle('Time in zone / Total time, when free'); a.FontSize=20;



% Zones analysis
figure; p=1; sess=2;
for zones=[1 4 3 5 2]
    
    subplot(3,5,p)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_In_Zones.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Total time','FontSize',15,'FontWeight','bold','Rotation',90); end
    %     ylim([0 32])
    title(Zones_Lab{p})
    
    subplot(3,5,p+5)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Active_In_Zones_Free.(Session_type{sess}){zones} , Cols , X , NoLegends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,5,'Time active','FontSize',15,'FontWeight','bold','Rotation',90); end
    %     ylim([0 30])
    
    subplot(3,5,p+10)
    MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Freezing_In_Zones.(Session_type{sess}){zones} , Cols , X , Legends , 'showpoints',1,'paired',0);
    if zones==1; ylabel('time (min)'); u=text(-1.,1.5,'Time freezing','FontSize',15,'FontWeight','bold','Rotation',90); end
    %     ylim([0 8.5])
    
    p=p+1;
end
a=suptitle(['Time spent in zones, ' Session_type{sess} ' sessions']); a.FontSize=20;


for sess=1:length(Session_type)
    for type=1:length(Type)
        for i=1:6
            Tigmo_score_all.(Type{type}).(Session_type{sess}){i}(Tigmo_score_all.(Type{type}).(Session_type{sess}){i}==0)=NaN;
            Tigmo_score_all_safe.(Type{type}).(Session_type{sess}){i}(Tigmo_score_all.(Type{type}).(Session_type{sess}){i}==0)=NaN;
        end
    end
end

figure, n=1;
for sess=[1 2 4]
    subplot(1,3,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Active_Unblocked.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([.3 1.1])
    n=n+1;
end
a=suptitle('Thigmo score, active/free, all maze'); a.FontSize=20;

figure, n=1;
for sess=[1 2 4]
    subplot(1,3,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([.3 1.2])
    n=n+1;
end
a=suptitle('Thigmo score, active/free, safe side'); a.FontSize=20;

figure, n=1;
for sess=[1 2 4]
    subplot(1,3,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all.Freeze.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([.3 1.2])
    n=n+1;
end
a=suptitle('Thigmo score, freezing, all maze'); a.FontSize=20;

figure, n=1;
for sess=[1 2 4]
    subplot(1,3,n)
    MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Freeze.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    title(Session_type{sess})
    ylim([.3 1.3])
    n=n+1;
end
a=suptitle('Thigmo score, freezing, safe side'); a.FontSize=20;





clear A B
for sess=1:6
    for group=1:6
        
        A.(Session_type{sess}){group} = Tigmo_score_all.Active_Unblocked.(Session_type{sess}){group}-Tigmo_score_all.Active_Unblocked.TestPre{group};
        B.(Session_type{sess}){group} = Tigmo_score_all_safe.Active_Unblocked.(Session_type{sess}){group}-Tigmo_score_all_safe.Active_Unblocked.TestPre{group};
        %         A.(Session_type{sess}){group} = Tigmo_score_all.Freeze_Unblocked.(Session_type{sess}){group}-Tigmo_score_all.Freeze_Unblocked.TestPre{group};
        %         B.(Session_type{sess}){group} = Tigmo_score_all_safe.Freeze_Unblocked.(Session_type{sess}){group}-Tigmo_score_all_safe.Freeze_Unblocked.TestPre{group};
        
    end
end

figure
for sess=1:6
    subplot(2,6,sess)
    MakeSpreadAndBoxPlot3_SB(A.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    
    subplot(2,6,sess+6)
    MakeSpreadAndBoxPlot3_SB(B.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0);
end





%% thigmotaxis
figure; m=1; type=11;
for group=Group
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy; caxis([0 col_val]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).CondPre{m})
    axis xy; caxis([0 col_val]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).CondPost{m})
    axis xy; caxis([0 col_val]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).TestPost{m})
    axis xy; caxis([0 col_val]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end

figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Active_Unblocked.Cond,Cols,X,NoLegends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Active_Unblocked.TestPre,Cols,X,NoLegends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Tigmo_score_all_safe.Active_Unblocked.Cond,Cols,X,NoLegends,'showpoints',1,'paired',0);




for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            for type=1:length(Type)
                
                Time_InCorners.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = ...
                    (nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(32:40,1:10))) +...
                    nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(43:50,1:10))) +...
                    nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(43:50,43:50))));
                
                Time_InCorners2.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = ...
                    (nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(32:40,1:10))) +...
                    nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(43:50,1:10))));
                
            end
        end
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        for type=1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                Time_InCorners.(Type{type}).(Session_type{sess}){n}(mouse) = Time_InCorners.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                Time_InCorners2.(Type{type}).(Session_type{sess}){n}(mouse) = Time_InCorners2.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                
            end
        end
    end
    n=n+1;
end

figure
MakeSpreadAndBoxPlot3_SB(Time_InCorners2.Unblocked.TestPost,Cols,X,NoLegends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Time_InCorners2.Unblocked.Cond,Cols,X,NoLegends,'showpoints',1,'paired',0);



n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
%             [dis.(Session_type{sess}){n}{mouse},dis1.(Session_type{sess}){n}{mouse},dis2.(Session_type{sess}){n}{mouse},U] = GetPointUmazeDistance(Position.All.(Mouse_names{mouse}).(Session_type{sess})(:,1),Position.All.(Mouse_names{mouse}).(Session_type{sess})(:,2));
            dis_mean.(Session_type{sess}){n}(mouse) = nanmean(dis.(Session_type{sess}){n}{mouse});
            dis1_mean.(Session_type{sess}){n}(mouse) = nanmean(dis1.(Session_type{sess}){n}{mouse});
            dis2_mean.(Session_type{sess}){n}(mouse) = nanmean(dis2.(Session_type{sess}){n}{mouse});
        end
    end
    n=n+1;
end


Cols2 = {[.3, .745, .93],[.85, .325, .098]};
X2 = 1:2;
Legends2 = {'Saline','Diazepam'};
NoLegends2 = {'',''};
ind=X;


figure
MakeSpreadAndBoxPlot3_SB(dis_mean.TestPre,Cols2,X2,Legends2,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(dis1_mean.TestPre,Cols2,X2,Legends2,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(dis2_mean.TestPre,Cols2,X2,Legends2,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(dis2_mean.Cond,Cols2,X2,Legends2,'showpoints',1,'paired',0);



n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
           Prop_FarFromWalls.(Session_type{sess}){n}(mouse) = sum(dis1.(Session_type{sess}){n}{mouse}>.05)/length(dis1.(Session_type{sess}){n}{mouse});
            
        end
    end
    n=n+1;
end

figure
MakeSpreadAndBoxPlot3_SB(Prop_FarFromWalls.Cond,Cols,X,NoLegends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Prop_FarFromWalls.TestPre,Cols,X,NoLegends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Prop_FarFromWalls.TestPost,Cols,X,NoLegends,'showpoints',1,'paired',0);




