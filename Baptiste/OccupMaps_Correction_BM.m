
Mouse=[11200 11206 11207 11251 11252 11253 11254];

figure
for mouse=1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    subplot(length(Mouse),4,4*(mouse-1)+1);
    imagesc(OccupMap.Unblocked.(Mouse_names{mouse}).TestPre)
    axis xy; caxis([0 .001])
    if mouse==1; title('Test Pre'); end
    ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+2);
    imagesc(OccupMap.Unblocked.(Mouse_names{mouse}).CondPre)
    axis xy; caxis([0 .001]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+3);
    imagesc(OccupMap.Unblocked.(Mouse_names{mouse}).CondPost)
    axis xy; caxis([0 .001]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+4);
    imagesc(OccupMap.Unblocked.(Mouse_names{mouse}).TestPost)
    axis xy; caxis([0 .001]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=sgtitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;


%% dimension reduction
figure; c=.06;
for mouse=1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    subplot(length(Mouse),4,4*(mouse-1)+1);
    imagesc(OccupMap_reduced.Unblocked.(Mouse_names{mouse}).TestPre)
    axis xy; caxis([0 c])
    if mouse==1; title('Test Pre'); end
    ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+2);
    imagesc(OccupMap_reduced.Unblocked.(Mouse_names{mouse}).CondPre)
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+3);
    imagesc(OccupMap_reduced.Unblocked.(Mouse_names{mouse}).CondPost)
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+4);
    imagesc(OccupMap_reduced.Unblocked.(Mouse_names{mouse}).TestPost)
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=sgtitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;

%% correct by TestPre
clear StimOccupMap_squeeze StimOccupMap_log_squeeze FreeStimOccupMap_squeeze FreeStimOccupMap_log_squeeze OccupMap_log_squeeze OccupMap_squeeze
n=1; Group=[1:4 9 11 14 18 17];

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        for type=2%1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                if sess==1
                    OccupMap_corr.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap_reduced.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                else
                    OccupMap_corr.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap_reduced.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})-OccupMap_reduced.(Type{type}).(Mouse_names{mouse}).TestPre;
                end
            end
        end
    end
end

Mouse=[11200 11206 11207 11251 11252 11253 11254];
figure; ax1=-.02; ax2=.04;
for mouse=1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    subplot(length(Mouse),4,4*(mouse-1)+1);
    imagesc(OccupMap_reduced.Unblocked.(Mouse_names{mouse}).TestPre)
    axis xy; caxis([0 c])
    if mouse==1; title('Test Pre'); end
    ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+2);
    imagesc(OccupMap_corr.Unblocked.(Mouse_names{mouse}).CondPre)
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+3);
    imagesc(OccupMap_corr.Unblocked.(Mouse_names{mouse}).CondPost)
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+4);
    imagesc(OccupMap_corr.Unblocked.(Mouse_names{mouse}).TestPost)
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=sgtitle('Occup map, TestPre correction'); a.FontSize=20;


%% gather by drug group
n=1;
for group=Group
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for type=2%1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                OccupMap_reduced.(Type{type}).(Session_type{sess}){n}(mouse,:,:) = OccupMap_corr.Unblocked.(Mouse_names{mouse}).(Session_type{sess});
            end
            try
                OccupMap_reduced_squeeze.(Type{type}).(Session_type{sess}){n} = squeeze(nanmean(OccupMap_reduced.(Type{type}).(Session_type{sess}){n}));
            end
        end
    end
    n=n+1;
end

figure; c=.06; m=1; type=2; Group=[1:4]; ax1=-.02; ax2=.04;
for group=Group
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPre{group})
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPre{group})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPost{group})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPost{group})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end
a=sgtitle('Occup map, by drugs group'); a.FontSize=20;



figure; c=.06; m=1; type=2; Group=[9 11 14];
for group=Group
    
    if group==9; n=5;
    elseif group==11; n=6;
    elseif group==14; n=7; end
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPre{n})
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPre{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPost{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPost{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end



figure; c=.06; m=1; type=2; Group=[9 11 18 17];
for group=Group
    
    if group==9; n=5;
    elseif group==11; n=6;
    elseif group==18; n=8; 
    elseif group==17; n=9; end
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPre{n})
    axis xy; caxis([0 c]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPre{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPost{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPost{n})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end



figure; c=.06; m=1; type=2; ax1=-.02; ax2=.04; Group=[2 3 4 11 14 17];
for group=Group
    
    if group==2; g1=1; g2=2;
    elseif group==3; g1=1; g2=3;
    elseif group==4; g1=1; g2=4;
    elseif group==11; g1=5; g2=6;
    elseif group==14; g1=5; g2=7;
    elseif group==17; g1=8; g2=9; end
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPre{g2}-OccupMap_reduced_squeeze.(Type{type}).TestPre{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPre{g2}-OccupMap_reduced_squeeze.(Type{type}).CondPre{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).CondPost{g2}-OccupMap_reduced_squeeze.(Type{type}).CondPost{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPost{g2}-OccupMap_reduced_squeeze.(Type{type}).TestPost{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end




figure; c=.06; m=1; type=2; Group=[1:4];
for group=Group
        
    subplot(2,2,group);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).Cond{group})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    title(Drug_Group{group})
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end


figure; c=.06; m=1; type=2; Group=[9 11 14 18 17];
for group=Group
        
    subplot(2,3,m);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).Cond{m+4})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    title(Drug_Group{group})
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end



figure; c=.06; m=1; type=2; ax1=-.02; ax2=.04; Group=[2 3 4 11 14 17];
for group=Group
    
    if group==2; g1=1; g2=2;
    elseif group==3; g1=1; g2=3;
    elseif group==4; g1=1; g2=4;
    elseif group==11; g1=5; g2=6;
    elseif group==14; g1=5; g2=7;
    elseif group==17; g1=8; g2=9; end
    
    subplot(length(Group),1,m);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).Cond{g2}-OccupMap_reduced_squeeze.(Type{type}).Cond{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_reduced_squeeze.(Type{type}).TestPost{g2}-OccupMap_reduced_squeeze.(Type{type}).TestPost{g1})
    axis xy; caxis([ax1 ax2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end







