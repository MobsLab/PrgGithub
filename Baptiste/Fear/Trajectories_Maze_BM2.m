
clear all

GetEmbReactMiceFolderList_BM

Session_type={'TestPre','Cond','CondPre','CondPost','TestPost'};
sizeMap = 50; % 20
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
Type={'Blocked','Unblocked','Freeze','Freeze_Unblocked','Freeze_Blocked','Ripples','Ripples_Blocked','Ripples_Unblocked','VHC','VHC_Blocked','VHC_Unblocked'};
Place={'ShockDoor','ShockWall','SafeDoor','SafeWall'};
Group=1:8;

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            
            Sessions_List_ForLoop_BM
            
            Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
            Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition'));
            Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
            Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = tsd(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess})) , Position.(Mouse_names{mouse}).(Session_type{sess}));

            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            
            TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
            UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
            FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
            try
                Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch');
            end
            try
                VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
            end
            Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
            Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
            try
                Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
                Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
            end
            try
                Position_tsd_Freeze_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Freeze_Blocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
                Position_tsd_Freeze_Unblocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
            end
            
            Position.Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
            Position.Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
            Position.Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}));
            Position.Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
            try
                Position.Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
            end
            try
                Position.Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
            end
            try
                Position.VHC.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_VHC.(Mouse_names{mouse}).(Session_type{sess}));
                Position.VHC_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked_VHC.(Mouse_names{mouse}).(Session_type{sess}));
                Position.VHC_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked_VHC.(Mouse_names{mouse}).(Session_type{sess}));
            end
        end
        disp(Mouse_names{mouse})
    end
end

% gather data
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            for type=1:length(Type)
                try
                    [OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) ] = hist2d([Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , sizeMap , sizeMap);
                    
                    OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})/sum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:));
                    OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})';
                    
                    OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = log(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}));
                    OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
                    
                    for place=1:length(Place)
                        if place==1
                            ind1=16; ind2=29; ind3=2; ind4=20; Ind1=2; Ind2=29; Ind3=2; Ind4=20; % close shock door
                        elseif place==2
                            ind1=1; ind2=15; ind3=2; ind4=20; Ind1=2; Ind2=29; Ind3=2; Ind4=20; % close shock wall
                        elseif place==3
                            ind1=16; ind2=29; ind3=33; ind4=50; Ind1=2; Ind2=29; Ind3=33; Ind4=50; % close safe door
                        else
                            ind1=2; ind2=15; ind3=33; ind4=50; Ind1=2; Ind2=29; Ind3=33; Ind4=50; % close safe wall
                        end
                        
                        Map_Occup = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                        Occupation.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}).(Place{place}) = sum(Map_Occup(ind1:ind2 , ind3:ind4))/sum(Map_Occup(Ind1:Ind2 , Ind3:Ind4));
                        clear Map_Occup
                    end
                end
            end
            disp(Mouse_names{mouse})
        end
    end
end

% Gather by drug group
clear StimOccupMap_squeeze StimOccupMap_log_squeeze FreeStimOccupMap_squeeze FreeStimOccupMap_log_squeeze OccupMap_log_squeeze OccupMap_squeeze
n=1;
for group=Group
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for type=1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                try
                    OccupMap.(Type{type}).(Session_type{sess}){n}(mouse,:,:) = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                catch
                    OccupMap.(Type{type}).(Session_type{sess}){n}(mouse,:,:) = NaN(sizeMap,sizeMap);
                end
                for place=1:length(Place)
                    try
                        Occupation.(Type{type}).(Session_type{sess}).(Place{place}){n}(mouse) = Occupation.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}).(Place{place});
                    end
                end
            end
            try
                OccupMap_squeeze.(Type{type}).(Session_type{sess}){n} = squeeze(nanmean(OccupMap.(Type{type}).(Session_type{sess}){n}));
                OccupMap_log_squeeze.(Type{type}).(Session_type{sess}){n} = log(OccupMap_squeeze.(Type{type}).(Session_type{sess}){n});
                OccupMap_log_squeeze.(Type{type}).(Session_type{sess})(OccupMap_log_squeeze.(Type{type}).(Session_type{sess}){n}==-Inf) = -1e4;
            end
        end
    end
    n=n+1;
end

for type=1:length(Type)
    for sess=1:length(Session_type) % generate all data required for analyses
        for place=1:length(Place)
            n=1;
            for group=Group
                try
                    Occupation.(Type{type}).(Session_type{sess}).(Place{place}){n} = Occupation.(Type{type}).(Session_type{sess}).(Place{place}){n};
                end
                n=n+1;
            end
        end
    end
end

rowReduce = 10;  % first dimension
colReduce = 10;  % second dimension
for type=1:length(Type)
    for sess=1:length(Session_type) % generate all data required for analyses
        n=1;
        for group=Group
            Mouse=Drugs_Groups_UMaze_BM(group);
            try
                
                [subsAi, subsAj] = ndgrid(1:size(OccupMap_squeeze.(Type{type}).(Session_type{sess}){n},1), 1:size(OccupMap_squeeze.(Type{type}).(Session_type{sess}){n},2));
                subsBi = 1 + floor((subsAi-1)/rowReduce);
                subsBj = 1 + floor((subsAj-1)/colReduce);
                OccupMap_reduced.(Type{type}).(Session_type{sess}){n} = accumarray([subsBi(:) subsBj(:)], OccupMap_squeeze.(Type{type}).(Session_type{sess}){n}(:));
                
            end
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                OccupMap_reduced.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = accumarray([subsBi(:) subsBj(:)], OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:));
            end
            n=n+1;
        end
    end
end


for type=1:length(Type)
    for sess=1:length(Session_type) % generate all data required for analyses
        n=1;
        for group=Group
                Mouse=Drugs_Groups_UMaze_BM(group);
%                 OccupMap_squeeze.(Type{type}).(Session_type{sess}){n}(1:16,9:14) = NaN;
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                OccupMap_reduced.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(1:8,5:6) = NaN;
            end
            n=n+1;
        end
    end
end


%% maps per mouse
for group=7
    figure; n=1;
    
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    for mouse=1:length(Mouse)
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            subplot(length(Mouse),4,4*(mouse-1)+1);
            imagesc(OccupMap_log.Unblocked.(Mouse_names{mouse}).TestPre)
            axis xy; caxis([-10 -5])
            if mouse==1; title('Test Pre'); end
            ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
            Maze_Frame_BM
        end
        subplot(length(Mouse),4,4*(mouse-1)+2);
        imagesc(OccupMap_log.Unblocked.(Mouse_names{mouse}).CondPre)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Pre'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+3);
        imagesc(OccupMap_log.Unblocked.(Mouse_names{mouse}).CondPost)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Cond Post'); end
        Maze_Frame_BM
        
        subplot(length(Mouse),4,4*(mouse-1)+4);
        imagesc(OccupMap_log.Unblocked.(Mouse_names{mouse}).TestPost)
        axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        if mouse==1; title('Test Post'); end
        Maze_Frame_BM
        
        colormap jet
    end
    a=suptitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;
end



%% Maps per drug group
Type={'Blocked','Unblocked','Freeze','Freeze_Unblocked','Freeze_Blocked','Ripples','Ripples_Blocked','Ripples_Unblocked','VHC','VHC_Blocked','VHC_Unblocked'};
col_val=3e-3;


figure; m=1; type=1;
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

figure; m=1; type=2;
for group=Group
    
    subplot(length(Group),4,1+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy; caxis([0 1e-2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    ylabel(Drug_Group{group});
    if m==1; title('Test Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,2+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).CondPre{m}./OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy; caxis([0 4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,3+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).CondPost{m}./OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy; caxis([0 4]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Group),4,4+(m-1)*4);
    imagesc(OccupMap_squeeze.(Type{type}).TestPost{m}./OccupMap_squeeze.(Type{type}).TestPre{m})
    axis xy; caxis([0 2]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if m==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
    m=m+1;
end



for type=1:length(Type)
    for sess=1:length(Session_type) % generate all data required for analyses
        n=1;
        for group=Group
            try
                OccupMap_squeeze.(Type{type}).(Session_type{sess}){n}(1:16,9:14) = NaN;
            end
            n=n+1;
        end
    end
end


%% Stats distance to door per drug group
Cols={[0, 0, 1],[1, 0 0],[0, 1, 0],[1 1 0]};
X=[1:4];
NoLegends = {'','','',''};

type=1;
for panel=2%:4
    figure
    
    if panel==1; Group=1:4;
    elseif panel==2; Group=5:8;
    elseif panel==3; Group=[7 8 1 2];
    else; Group=9:12;
    end
    Legends=Drug_Group(Group);
    
    m=1;
    for place=[1 3]
        subplot(2,2,m)
        MakeSpreadAndBoxPlot2_SB({Occupation.(Type{type}).(Session_type{3}).(Place{place}){Group}},Cols,X,NoLegends,'showpoints',1,'paired',0);
        if place==1; ylabel(Session_type{3}); end
        hline(.5 , '--r')
        title(Place{place})
                
        subplot(2,2,m+2)
        MakeSpreadAndBoxPlot2_SB({ Occupation.(Type{type}).(Session_type{4}).(Place{place}){Group} },Cols,X,Legends,'showpoints',1,'paired',0);
        if place==1; ylabel(Session_type{4}); end
        hline(.5 , '--r')
        m=m+1;
    end
    
    a=suptitle(['Occupancy maps ' Type{type}]); a.FontSize=20;
end



%% Matrix norm
GetEmbReactMiceFolderList_BM
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        clear R S
        R = reshape(OccupMap.Unblocked.(Mouse_names{mouse}).(Session_type{sess})  , 5, 10, 5, 10);
        S = sum(sum(R, 1), 3) * (1/25);
        OccupMap_reshaped.Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = reshape(S, 10, 10);
    end
end
    for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        clear R S
        R = reshape(OccupMap_squeeze.Unblocked.(Drug_Group{group}).(Session_type{sess}), 5, 10, 5, 10);
        S = sum(sum(R, 1), 3) * (1/25);
        OccupMap_squeeze_reshaped.Unblocked.(Drug_Group{group}).(Session_type{sess}) = reshape(S, 10, 10);
    end
end

for group1=1:length(Drug_Group)
    for group2=1:length(Drug_Group)
    for sess=1:length(Session_type)
            Norm_Value(group1 , group2 , sess) = norm(OccupMap_squeeze_reshaped.Unblocked.(Drug_Group{group1}).(Session_type{sess})-OccupMap_squeeze_reshaped.Unblocked.(Drug_Group{group2}).(Session_type{sess}));
        end
    end
end

figure
for sess=1:length(Session_type)
    subplot(2,2,sess)
    imagesc(-squeeze(Norm_Value(:,:,sess)))
    m=max(max(max(Norm_Value)));
    caxis([-m*.7 0])
    if or(sess==1 , sess==3); yticks([1:14]); yticklabels(Drug_Group) ;
    else; yticks([1:14]); yticklabels({'','','','','','','','','','','','','',''}) ; end
    if or(sess==3 , sess==4); xticks([1:14]); xticklabels(Drug_Group) ; xtickangle(45);
    else; xticks([1:14]); xticklabels({'','','','','','','','','','','','','',''}) ; end
    title(Session_type{sess})
    axis square
end
colormap jet
a=suptitle('Similarity index, exploration maps, drugs groups, UMaze'); a.FontSize=20;

for sess=1:length(Session_type)
    n=1;
    for group=[5 6 13] % defining mice that will be compared
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            n=1;
            for group2=[5 6 13] % defining group to compare mice with
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                Norm_Value_PerMouse.(Drug_Group{group}).(Session_type{sess})(mouse, n) = 1/norm(OccupMap_reshaped.Unblocked.(Mouse_names{mouse}).(Session_type{sess})-OccupMap_squeeze_reshaped.Unblocked.(Drug_Group{group2}).(Session_type{sess}));
                n=n+1;
                
            end
        end
        Norm_Value_PerMouse_Corrected.(Drug_Group{group}).(Session_type{sess}) = Norm_Value_PerMouse.(Drug_Group{group}).(Session_type{sess});
    end
end

figure; sess=2;
subplot(131)
MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse.(Drug_Group{5}).(Session_type{sess})(:,1) Norm_Value_PerMouse.(Drug_Group{5}).(Session_type{sess})(:,2) Norm_Value_PerMouse.(Drug_Group{5}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1);
title('Saline')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse.(Drug_Group{6}).(Session_type{sess})(:,1) Norm_Value_PerMouse.(Drug_Group{6}).(Session_type{sess})(:,2) Norm_Value_PerMouse.(Drug_Group{6}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1)
title('Diazepam')
subplot(133)
MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse.(Drug_Group{13}).(Session_type{sess})(:,1) Norm_Value_PerMouse.(Drug_Group{13}).(Session_type{sess})(:,2) Norm_Value_PerMouse.(Drug_Group{13}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1);
title('Rip Inhib')

Session_type={'TestPre','Cond','TestPost'};
figure; 
for sess=1:3
    subplot(3,3,sess)
    MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,1) Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,2) Norm_Value_PerMouse_Corrected.(Drug_Group{5}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'','',''} , 'showpoints',0,'paired',1);
    if sess==1; ylabel('Saline'); end
    title(Session_type{sess})
    
    subplot(3,3,sess+3)
    MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,1) Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,2) Norm_Value_PerMouse_Corrected.(Drug_Group{6}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'','',''} , 'showpoints',0,'paired',1)
    if sess==1; ylabel('Diazepam'); end
    
    subplot(3,3,sess+6)
    MakeSpreadAndBoxPlot2_SB({Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,1) Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,2) Norm_Value_PerMouse_Corrected.(Drug_Group{13}).(Session_type{sess})(:,3)} , {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83]} , [1:3] , {'Saline','Diazepam','Rip Inhib'} , 'showpoints',0,'paired',1);
    if sess==1; ylabel('Rip Inhib'); end
end





%%


figure
MakeSpreadAndBoxPlot3_SB(Occupation.Blocked.Cond.ShockDoor,Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(Occupation.Blocked.Cond.SafeWall,Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(Occupation.Blocked.Ext.ShockDoor,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Freeze_Blocked.Cond.ShockDoor,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Freeze_Blocked.Cond.ShockWall,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Freeze_Blocked.Cond.SafeDoor,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Freeze_Blocked.Cond.SafeWall,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Freeze_Blocked.Ext.ShockWall,Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(Occupation.Active_Blocked.Cond.ShockDoor,Cols,X,Legends,'showpoints',1,'paired',0);


for i=1:4
    Ratio_to_use1{i} = log(Occupation.Blocked.Cond.ShockDoor{i}./Occupation.Blocked.Cond.ShockWall{i});
    Ratio_to_use10{i} = log(Occupation.Blocked.Ext.ShockDoor{i}./Occupation.Blocked.Ext.ShockWall{i});
    Ratio_to_use1bis{i} = Occupation.Blocked.Cond.ShockDoor{i}./Occupation.Blocked.Cond.ShockWall{i};
    Ratio_to_use2{i} = log(Occupation.Blocked.Cond.SafeDoor{i}./Occupation.Blocked.Cond.SafeWall{i});
    Ratio_to_use3{i} = log(Occupation.Blocked.Ext.SafeDoor{i}./Occupation.Blocked.Ext.SafeWall{i});
    Ratio_to_use4{i} = log(Occupation.Blocked.Ext.ShockDoor{i}./Occupation.Blocked.Ext.ShockWall{i});
    Ratio_to_use5{i} = Occupation.Freeze_Blocked.Cond.ShockDoor{i}./Occupation.Freeze_Blocked.Cond.ShockWall{i};
    Ratio_to_use6{i} = Occupation.Freeze_Blocked.Cond.SafeDoor{i}./Occupation.Freeze_Blocked.Cond.SafeWall{i};
    Ratio_to_use5{i}(Ratio_to_use5{i}==-Inf)=NaN;
    Ratio_to_use6{i}(Ratio_to_use6{i}==-Inf)=NaN;
    Ratio_to_use7{i} = Occupation.Freeze_Blocked.Ext.ShockDoor{i}./Occupation.Freeze_Blocked.Ext.ShockWall{i};
    
%     Ratio_to_use8{i} = log(Occupation.Blocked.Cond.ShockDoor{i}./Occupation.Blocked.Cond.SafeDoor{i});
%     Ratio_to_use9{i} = log(Occupation.Blocked.Cond.ShockWall{i}./Occupation.Blocked.Cond.SafeWall{i});
Occupation.Freeze_Blocked.Cond.SafeDoor{i}(Occupation.Freeze_Blocked.Cond.SafeDoor{i}==0)=.01;
   Ratio_to_use8{i} = log(Occupation.Freeze_Blocked.Cond.ShockDoor{i}./Occupation.Freeze_Blocked.Cond.SafeDoor{i});
    Ratio_to_use9{i} = log(Occupation.Freeze_Blocked.Cond.ShockWall{i}./Occupation.Freeze_Blocked.Cond.SafeWall{i});
    
end

figure
MakeSpreadAndBoxPlot3_SB(Ratio_to_use8,Cols,X,Legends,'showpoints',1,'paired',0);
set(gca , 'Yscale','log')

ylabel('prop')
title('Proportion')


% keep
figure
MakeSpreadAndBoxPlot3_SB(Ratio_to_use1,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('log scale')
title('Occupancy Door/Wall, shock side, Cond sessions')




figure
MakeSpreadAndBoxPlot3_SB(Ratio_to_use8,Cols,X,Legends,'showpoints',1,'paired',0);
  




figure
MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_In_Zones.CondPre{3},Cols,X,Legends,'showpoints',1,'paired',0);
figure
MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{3},Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{5},Cols,X,Legends,'showpoints',1,'paired',0);


for i=1:4
    F{i} = DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{3}{i}+DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{4}{i};
    F2{i} = DATA.Absolute_Time_In_Zones.CondPre{3}{i}+DATA.Absolute_Time_In_Zones.CondPre{4}{i};
    F2{i}(F2{i}==0)=NaN;
    F{i}(F{i}==0)=NaN;
    F3{i} = F{i}./F2{i};
end

for i=1:4
    F{i} = DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{3}{i}+DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{4}{i}+DATA.Absolute_Time_Spent_Freezing_In_Zones.CondPre{5}{i};
    F2{i} = DATA.Absolute_Time_In_Zones.CondPre{3}{i}+DATA.Absolute_Time_In_Zones.CondPre{4}{i}+DATA.Absolute_Time_In_Zones.CondPre{5}{i};
    F2{i}(F2{i}==0)=NaN;
    F{i}(F{i}==0)=NaN;
    F3{i} = F{i}./F2{i};
end


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(F,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (min)')
title('Time spent not in arms Maze')

subplot(122)
MakeSpreadAndBoxPlot3_SB(F3,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
title('Aversiveness of this zone')




