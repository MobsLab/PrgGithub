
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat')

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','All','All_Saline'};
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};

SessNames={'TestPost_PostDrug'};

Dir=PathForExperimentsEmbReact(SessNames{1});

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse2(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze2_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                FreezingProportion.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Ratio.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneOccupancy.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                OccupancyMeanTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                StimNumb.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb.(Session_type{sess}).(Mouse_names{mouse});
                StimNumb_Blocked.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse});
                ExtraStim.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneEntries.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEntries.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                Total_Time.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Total_Time.(Session_type{sess}).(Mouse_names{mouse});
                
                Latency.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Latency.Shock.(Session_type{sess}).(Mouse_names{mouse});
                
                FreezingTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) ;
                
                RA.(Drug_Group{group}).(Session_type{sess})(mouse) = RA.(Session_type{sess}).(Mouse_names{mouse});
                Stim_By_SZ_entries.(Drug_Group{group}).(Session_type{sess})(mouse) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse})./ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end

Cols1 = {[1 .5 .5],[.5 .5 1]};
X1 = [1:2];
Legends1 = {'Shock','Safe'};
NoLegends1 = {'',''};


figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.All_Saline.Cond*100 ZoneOccupancy.Safe.All_Saline.Cond*100} , Cols1 , X1 , Legends1 , 'showpoints',0,'paired',1);
subplot(122)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.All_Saline.Cond*100 FreezingProportion.Safe.All_Saline.Cond*100} , Cols1 , X1 , Legends1 , 'showpoints',0,'paired',1);



figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.All.Cond*100 ZoneOccupancy.Safe.All.Cond*100} , Cols1 , X1 , Legends1 , 'showpoints',0,'paired',1);
subplot(122)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.All.Cond*100 FreezingProportion.Safe.All.Cond*100} , Cols1 , X1 , Legends1 , 'showpoints',0,'paired',1);



%%
figure
subplot(131);
imagesc(SmoothDec(OccupMap_squeeze.Unblocked.SalineBM_Short.Cond,.7))
axis xy; caxis([0 1.5e-3])
title('Saline'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM

subplot(132);
imagesc(SmoothDec(OccupMap_squeeze.Unblocked.Diazepam_Short.Cond,.7))
axis xy; caxis([0 1.5e-3])
title('Diazepam'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM

subplot(133);
imagesc(SmoothDec(OccupMap_squeeze.Unblocked.RipInhib.Cond,.7))
axis xy; caxis([0 1.5e-3])
title('Rip Inhib'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM

colormap jet



figure; n=1;
for group=[5 6 13]
    
    subplot(3,3,1+(n-1)*3);
    imagesc(OccupMap_squeeze.Unblocked.(Drug_Group{group}).TestPre)
    axis xy; caxis ([0 8e-4])
    if n==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(3,3,2+(n-1)*3);
    imagesc(OccupMap_squeeze.Unblocked.(Drug_Group{group}).Cond)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if n==1; title('Cond'); end
    Maze_Frame_BM
    
    subplot(3,3,3+(n-1)*3);
    imagesc(OccupMap_squeeze.Unblocked.(Drug_Group{group}).TestPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if n==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    n=n+1;
end
a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;
 
% Similarity index
figure; 
sess=2;
subplot(131)
MakeSpreadAndBoxPlot2_SB({(Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,1)./Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,2)./Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,3)./Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,1))-1} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1)
title('Saline')
ylim([-.5 1.2])
hline(0,'--k')
ylabel('similarity index')

subplot(132)
MakeSpreadAndBoxPlot2_SB({(Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,1)./Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,2)./Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,3)./Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,1))-1} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1)
title('Diazepam')
ylim([-.5 1.2])
hline(0,'--k')
ylabel('similarity index')

subplot(133)
MakeSpreadAndBoxPlot2_SB({(Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,1)./Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,2)./Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,1))-1 (Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,3)./Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,1))-1} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1)
title('Rip Inhib')
ylim([-.5 1.2])
hline(0,'--k')
ylabel('similarity index')



%%

Cols1 = {[0 0 1],[0 1 0]};
X1 = [1:4];
Legends1 = {'Saline','Diazepam','Saline','Diazepam'};
NoLegends1 = {'',''};


figure
subplot(141)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){5}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){6}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){5}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){6}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 35])
ylabel('% time freezing')
subplot(142)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){6}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){6}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(143)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){5} ZoneEntries.Figure.Shock.(Session_type{sess}){6} ZoneEntries.Figure.Safe.(Session_type{sess}){5} ZoneEntries.Figure.Safe.(Session_type{sess}){6}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4.7])
subplot(144)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.Figure.(Session_type{sess}){5} Ripples.Shock.Figure.(Session_type{sess}){6} Ripples.Safe.Figure.(Session_type{sess}){5} Ripples.Safe.Figure.(Session_type{sess}){6}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('rip. density (Hz)')
ylim([0 1.7])


Legends1 = {'Saline','Rip Inhib','Saline','Rip Inhib'};

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){5}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){13}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){5}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 67])
ylabel('% time freezing')
subplot(132)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){13}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(133)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){5} ZoneEntries.Figure.Shock.(Session_type{sess}){13} ZoneEntries.Figure.Safe.(Session_type{sess}){5} ZoneEntries.Figure.Safe.(Session_type{sess}){13}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4])


%%

Legends1 = {'Saline','Chronic Flx','Saline','Chronic Flx'};


figure; 
subplot(141)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){1}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){2}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){1}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){2}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 25])
ylabel('% time freezing')
subplot(142)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){1}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){2}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){1}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){2}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 100])
ylabel('% session time')
subplot(143)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){1} ZoneEntries.Figure.Shock.(Session_type{sess}){2} ZoneEntries.Figure.Safe.(Session_type{sess}){1} ZoneEntries.Figure.Safe.(Session_type{sess}){2}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 2.5])
subplot(144)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.Figure.(Session_type{sess}){1} Ripples.Shock.Figure.(Session_type{sess}){2} Ripples.Safe.Figure.(Session_type{sess}){1} Ripples.Safe.Figure.(Session_type{sess}){2}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('rip. density (Hz)')
ylim([0 1.2])





% Behaviour
Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = [1:4];
Legends = {'Saline','Chronic Flx','Saline','Chronic Flx'};


sess=5;
OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess})(7)=3.662; 
OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess})([4 6 7])=[2.823 NaN 2.594]; 
OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess})([1 5 7])=[57.37 54.93 59.81];
sess=1;
OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess})(7)=2.747; 
OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess})([4 7])=[2.747 3.357]; 
OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})(7)=2.747; 
OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})([4 7])=[2.747 3.357]; 
sess=2;
OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})([4:6])=NaN; 
OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})([4:6])=NaN; 


figure
subplot(141); sess=5;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess})  OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB Low')
ylabel('Frequency (Hz)')
ylim([0 6])
subplot(142)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB High')
subplot(143)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) Ripples.Shock.ChronicFlx.(Session_type{sess})  Ripples.Safe.SalineSB.(Session_type{sess}) Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 1.2])
title('Ripples')
subplot(144)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess})  ,HR.Shock.ChronicFlx.(Session_type{sess}) , HR.Safe.SalineSB.(Session_type{sess}) HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Heart rate')


















