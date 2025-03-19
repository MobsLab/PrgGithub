
clear all

GetEmbReactMiceFolderList_BM

Session_type={'TestPre','Cond','CondPre','CondPost','TestPost'};
sizeMap = 50;
sizeMap2 = 9;
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipInhibControl'};

for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
        Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition'));
        Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = tsd(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess})) , Position.(Mouse_names{mouse}).(Session_type{sess}));

        if or(sess==2 , or(sess==3 , sess==4))
            StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}) = and(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}),BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
            UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
            
            Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            clear Range_to_use Stim_times Stim_times_Blocked;
            Range_to_use = Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times = Start(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times_Blocked = Start(StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}));
            
            for stim=1:length(Stim_times)
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times(stim));
            end
            try
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})=rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(find(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})~=0));
            end
            for stim=1:length(Stim_times_Blocked)
                rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times_Blocked(stim));
            end
            try
                PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess}),:);
                PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess}),:);
            end
         end
    end
    disp(Mouse_names{mouse})
end

PositionStimExplo.M777.CondPre(12,:)=NaN;
PositionStimExplo.M1001.CondPre(6,1)=0.2; PositionStimExplo.M1001.CondPre(6,12)=0.65;
PositionStimExplo.M1096.CondPre(13,:)=NaN; PositionStimExplo.M1096.CondPost(1,:)=NaN;
PositionStimExplo.M740.CondPre(1:3,:)=NaN; % no explanation

% gather data
for mouse=1:length(Mouse_names)
    for sess=1:length(Session_type)
        %try
        if or(sess==2 , sess==3)
            try
                [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
            catch
                try
                    [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;0;0;0;1;0;1] , sizeMap , sizeMap);
                catch
                    [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;0;0;0;0;0;1;0;1] , sizeMap , sizeMap);
                end
            end
        else
            [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
        end
        OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})/sum(OccupMap.(Mouse_names{mouse}).(Session_type{sess})(:));
        OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})';
        
        OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
        OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
        
        OccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(OccupMap.(Mouse_names{mouse}).(Session_type{sess}));
        OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
        
        if or(sess==2 , sess==3)
            try
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
                
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2)-hist2d([PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
            end
        end
        disp(Mouse_names{mouse})
        %end
    end
end

% Gather by drug group
clear StimOccupMap_squeeze StimOccupMap_log_squeeze FreeStimOccupMap_squeeze FreeStimOccupMap_log_squeeze OccupMap_log_squeeze OccupMap_squeeze
for group=[21 22]%1:12%length(Drug_Group)
    
Mouse=Drugs_Groups_UMaze_BM(group);
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            OccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
            SpeedMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = SpeedMap.(Mouse_names{mouse}).(Session_type{sess});
            
            if or(sess==2 , sess==3)
                try
                    StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                    FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                catch
                    StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap2,sizeMap2);
                    FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap2,sizeMap2);
                end
            end
        end
        try
            OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(OccupMap.(Drug_Group{group}).(Session_type{sess})));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(StimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
        end
        SpeedMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(SpeedMap.(Drug_Group{group}).(Session_type{sess})));
    end
end


%% figures
%% Occupancy maps
for group=[13 16]%1:length(Drug_Group)
    figure; n=1;
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for mouse=1:length(Mouse)
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
        subplot(length(Mouse),4,4*(mouse-1)+1);
        imagesc(OccupMap_log.(Mouse_names{mouse}).TestPre)
        axis xy; caxis([-10 -5])
        if mouse==1; title('Test Pre'); end
        ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        Maze_Frame_BM
        end
        subplot(length(Mouse),4,4*(mouse-1)+2);
        imagesc(OccupMap_log.(Mouse_names{mouse}).CondPre)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+3);
        imagesc(OccupMap_log.(Mouse_names{mouse}).CondPost)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Post'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+4);
        imagesc(OccupMap_log.(Mouse_names{mouse}).TestPost)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
        a=suptitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;
    end
end


figure; n=1;
for group=[13 16]%1:4%length(Drug_Group)
    
    subplot(4,4,1+n*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
    axis xy; caxis ([0 8e-4])
    if group==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(4,4,2+n*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPre)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(4,4,3+n*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(4,4,4+n*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Test Post'); end
    Maze_Frame_BM
    
    n=n+1;
    colormap jet
end
a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;
  

figure
for group=5:8
    
    subplot(4,4,1+(group-5)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
    axis xy; caxis ([0 8e-4])
    if group==5; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(4,4,2+(group-5)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPre)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==5; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(4,4,3+(group-5)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==5; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(4,4,4+(group-5)*4);
    imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
    axis xy; caxis ([0 8e-4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==5; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;
  

%% Speed map
for group=1%:length(Drug_Group)
    figure; n=1;
    
    Drugs_Groups_UMaze_BM
    
    for mouse=1:length(Mouse)
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            subplot(length(Mouse),4,4*(mouse-1)+1);
            imagesc(SpeedMap.(Mouse_names{mouse}).TestPre')
            axis xy; caxis([0 25])
            if mouse==1; title('Test Pre'); end
            ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
            Maze_Frame_BM
        end
        
        subplot(length(Mouse),4,4*(mouse-1)+2);
        imagesc(SpeedMap.(Mouse_names{mouse}).CondPre')
        axis xy; caxis([0 25]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+3);
        imagesc(SpeedMap.(Mouse_names{mouse}).CondPost')
        axis xy; caxis([0 25]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Post'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+4);
        imagesc(SpeedMap.(Mouse_names{mouse}).TestPost')
        axis xy; caxis([0 25]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
        a=suptitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;
    end
end


figure;
for group=1:4%length(Drug_Group)
    
    subplot(4,4,1+(group-1)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPre')
    axis xy; caxis([2 20])
    if group==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(4,4,2+(group-1)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).CondPre')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    
    subplot(4,4,3+(group-1)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).CondPost')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Post'); end
    Maze_Frame_BM
    
    
    subplot(4,4,4+(group-1)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPost')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=suptitle('Speed maps for all drugs groups'); a.FontSize=20;
  

figure;
for group=5:8%length(Drug_Group)
    
    subplot(4,4,1+(group-5)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPre')
    axis xy; caxis([2 20])
    if group==1; title('Test Pre'); end
    ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    Maze_Frame_BM
    
    subplot(4,4,2+(group-5)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).CondPre')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    
    subplot(4,4,3+(group-5)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).CondPost')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Post'); end
    Maze_Frame_BM
    
    
    subplot(4,4,4+(group-5)*4);
    imagesc(SpeedMap_squeeze.(Drug_Group{group}).TestPost')
    axis xy; caxis([2 20]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end
a=suptitle('Speed maps for all drugs groups'); a.FontSize=20;
  

%% Trajetories TestPre, Cond Pre, Cond Post, TestPost. Stim on cond & test post sessions
GetEmbReactMiceFolderList_BM

for group=5:8
    
    figure; n=1;
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            subplot(length(Mouse),4,4*n-3)
        plot(Position.(Mouse_names{mouse}).TestPre(:,1),Position.(Mouse_names{mouse}).TestPre(:,2));
        xlim([0 1]); ylim([0 1])
        if mouse==1; title('Test Pre'); end
        ylabel(Mouse_names{mouse}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        end
        subplot(length(Mouse),4,4*n-2)
        plot(Position.Unblocked.(Mouse_names{mouse}).CondPre(:,1),Position.Unblocked.(Mouse_names{mouse}).CondPre(:,2));
        hold on
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
        plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10);
        xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        
        subplot(length(Mouse),4,4*n-1)
        plot(Position.Unblocked.(Mouse_names{mouse}).CondPost(:,1),Position.Unblocked.(Mouse_names{mouse}).CondPost(:,2));
        hold on
        try
            plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
            plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
        end
        xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Post'); end
        
        subplot(length(Mouse),4,4*n)
        try
            plot(Position.(Mouse_names{mouse}).TestPost(:,1),Position.(Mouse_names{mouse}).TestPost(:,2)); hold on
            plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
            plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10);
            plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
            plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
        end
        xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post');
        f=get(gca,'Children'); l=legend([f(4),f(3),f(2),f(1)],'stim explo pre','stim blocked pre','stim explo post','stim blocked post'); l.Position=[0.8 0.9 0.1 0.1]; end
        
        n=n+1;
    end
    a=suptitle(['Trajectories, ' Drug_Group{group}]); a.FontSize=20;
end


% plot only TestPost and stim with it
for group=1:length(Drug_Group)
    figure; n=1;
    
    Drugs_Groups_UMaze_BM
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try
            subplot(2,4,n)
            plot(Position.(Mouse_names{mouse}).TestPost(:,1),Position.(Mouse_names{mouse}).TestPost(:,2));
            hold on
            plot(PositionStimExplo.(Mouse_names{mouse}).Cond(:,1) , PositionStimExplo.(Mouse_names{mouse}).Cond(:,2),'.r','MarkerSize',10);
            plot(PositionStimBlocked.(Mouse_names{mouse}).Cond(:,1) , PositionStimBlocked.(Mouse_names{mouse}).Cond(:,2),'.b','MarkerSize',10);
            xlim([0 1]); ylim([0 1])
            %if mouse==1; title('Test Post'); end
            if mouse==1; legend('trajectories','CondStim','CondBlockedStim'); end
            
            n=n+1;
        end
    end
    a=suptitle(Drug_Group{group}); a.FontSize=10;
end


%% Stim maps
figure
for group=1:length(Drug_Group)
    
    subplot(2,4,group)
    
    Drugs_Groups_UMaze_BM
    
    stim_numb=0;
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        if mouse==1
            plot(Position.(Mouse_names{mouse}).TestPre(:,1),Position.(Mouse_names{mouse}).TestPre(:,2));
            hold on
        end
        
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.r','MarkerSize',10);
        xlim([0 1]); ylim([0 1])
        
        n=n+1;
        stim_numb=stim_numb+size(PositionStimExplo.(Mouse_names{mouse}).CondPre,1)+size(PositionStimExplo.(Mouse_names{mouse}).CondPost,1);
    end
    title(['stim numb = ' num2str(stim_numb) ' , mice numb = ' num2str(length(Mouse))])
end


figure;
for group=1:length(Drug_Group)
    
    subplot(length(Drug_Group),2,1+(group-1)*2);
    imagesc(StimOccupMap_log_squeeze.(Drug_Group{group}).CondPre)
    axis xy; caxis([-5 -1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    ylabel(Drug_Group{group});
    Maze_Frame_BM2
    
    subplot(length(Drug_Group),2,2+(group-1)*2);
    imagesc(StimOccupMap_log_squeeze.(Drug_Group{group}).CondPost)
    axis xy; caxis([-5 -1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Post'); end
    Maze_Frame_BM2

    colormap jet
end
a=suptitle('Stim density maps for all drugs groups (all stims)'); a.FontSize=20;
      

figure;
for group=1:length(Drug_Group)
    
    subplot(length(Drug_Group),2,1+(group-1)*2);
    imagesc(FreeStimOccupMap_log_squeeze.(Drug_Group{group}).CondPre)
    axis xy; caxis([-5 -1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Pre'); end
    ylabel(Drug_Group{group});
    Maze_Frame_BM2
    
    subplot(length(Drug_Group),2,2+(group-1)*2);
    imagesc(FreeStimOccupMap_log_squeeze.(Drug_Group{group}).CondPost)
    axis xy; caxis([-5 -1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if group==1; title('Cond Post'); end
    Maze_Frame_BM2
    
    colormap jet
end
a=suptitle('Stim density maps for all drugs groups (stims when free)'); a.FontSize=20;







for group=5:8
figure; n=1;
Mouse=Drugs_Groups_UMaze_BM(group);
for mouse=1:length(Mouse)
Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
subplot(5,9,mouse)
plot(Position.(Mouse_names{mouse}).TestPre(:,1),Position.(Mouse_names{mouse}).TestPre(:,2));
xlim([0 1]); ylim([0 1])
title(Mouse_names{mouse})
if mouse==1; ylabel('Test Pre'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]); end
subplot(5,9,mouse+9)
plot(Position.Unblocked.(Mouse_names{mouse}).CondPre(:,1),Position.Unblocked.(Mouse_names{mouse}).CondPre(:,2));
hold on
plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10);
xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if mouse==1; ylabel('Cond Pre'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]); end
subplot(5,9,mouse+9*2)
plot(Position.Unblocked.(Mouse_names{mouse}).CondPost(:,1),Position.Unblocked.(Mouse_names{mouse}).CondPost(:,2));
hold on
try
plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
end
xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if mouse==1; ylabel('Cond Post'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]); end
subplot(5,9,mouse+9*3)
try
plot(Position.(Mouse_names{mouse}).TestPost(:,1),Position.(Mouse_names{mouse}).TestPost(:,2)); hold on
plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10);
plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
end
xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if mouse==1; f=get(gca,'Children'); l=legend([f(4),f(3),f(2),f(1)],'stim explo pre','stim blocked pre','stim explo post','stim blocked post'); l.Position=[0.8 0.9 0.1 0.1]; end
if mouse==1; ylabel('Test Post'); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]); end
subplot(5,9,mouse+9*4)
imagesc(OccupMap.Unblocked.(Mouse_names{mouse}).TestPost), axis xy, caxis([0 8e-4])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM
if mouse==1; ylabel('Test Post'); end
u=text(0,-15,num2str(Tigmo_score.Unblocked.(Mouse_names{mouse}).TestPost)); %set(u,'FontSize',15);
end
n=n+1;
a=suptitle(['Trajectories, ' Drug_Group{group}]); a.FontSize=20;
end






%% Explained variance
for mouse=1:length(Mouse_names)
    [EV.(Mouse_names{mouse}), REV.(Mouse_names{mouse})] = ExplainedVariance_Behavior(OccupMap.(Mouse_names{mouse}).TestPre,...
        OccupMap.(Mouse_names{mouse}).Cond, OccupMap.(Mouse_names{mouse}).TestPost);
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        EV_all.(Drug_Group{group})(mouse)=EV.(Mouse_names{mouse})*100;
        REV_all.(Drug_Group{group})(mouse)=REV.(Mouse_names{mouse})*100;
        
    end
end

% Figures
Cols = {[0.5,0.5,0.5] , [0.6350, 0.0780, 0.1840]};
X = [1,2];
Legends = {'EV','REV'};

figure
for group=1:8
    subplot(1,8,group)
    
    MakeSpreadAndBoxPlot2_SB({EV_all.(Drug_Group{group}) , REV_all.(Drug_Group{group})} , Cols , X , Legends , 'showpoints',0,'paired',1); makepretty; xtickangle(45);
    title(Drug_Group{group})
    ylim([0 60])
    
end

a=suptitle('Behavioral explained variance, UMaze, drugs'); a.FontSize=10;



% EV/REV to correct based on Sophie's advices






