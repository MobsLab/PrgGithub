
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
% Session_type={'Cond','Ext'};
% Session_type={'TestPre','Cond','TestPost'};
% Session_type={'TestPost'};
% Group=[7 8];

sizeMap = 100;
sizeMap2 = 9;
Type={'All','Blocked','Unblocked','Freeze','Freeze_Unblocked','Freeze_Blocked','Active','Active_Unblocked','Active_Blocked','Ripples','Ripples_Blocked','Ripples_Unblocked','VHC','VHC_Blocked','VHC_Unblocked'};
Place={'ShockDoor','ShockWall','SafeDoor','SafeWall'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            try
                Sessions_List_ForLoop_BM
                
                Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
                Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
                Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
                
                BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
                
                TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
                UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
                FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
                ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess});
                try
                    StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
                catch
                    StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet([],[]);
                end
                try
                    Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch');
                catch
                    Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet([],[]);
                end
                try
                    VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
                catch
                    VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet([],[]);
                end
                % generate tsd
                Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
                Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
                Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}));
                Position_tsd_Active.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                
                Position_tsd_Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Active_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                
                Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
                Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
                
                Position_tsd_Freeze_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
                Position_tsd_Freeze_Blocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
                Position_tsd_Freeze_Unblocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
                
                % convert tsd in data
                Position.All.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position.Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position.Active.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Active.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Active_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Active_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position.Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position.Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
                Position.Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
                
                Position.VHC.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_VHC.(Mouse_names{mouse}).(Session_type{sess}));
                Position.VHC_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked_VHC.(Mouse_names{mouse}).(Session_type{sess}));
                Position.VHC_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked_VHC.(Mouse_names{mouse}).(Session_type{sess}));
                
                if ~isempty(Start(StimEpoch.(Mouse_names{mouse}).(Session_type{sess})))
                    Stim_times.(Mouse_names{mouse}).(Session_type{sess}) = Range(ts(Start(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
                    Stim_times_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Range(ts(Start(and(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess})))));
                    clear Range_to_use
                    Range_to_use = Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
                    
                    for stim=1:length(Stim_times.(Mouse_names{mouse}).(Session_type{sess}))
                        rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times.(Mouse_names{mouse}).(Session_type{sess})(stim));
                    end
                    try
                        rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})=rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(find(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})~=0));
                    end
                    for stim=1:length(Stim_times_Blocked.(Mouse_names{mouse}).(Session_type{sess}))
                        rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times_Blocked.(Mouse_names{mouse}).(Session_type{sess})(stim));
                    end
                    try
                        PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess}),:);
                        PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess}),:);
                    end
                end
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
                    Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
                    OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = hist2d([Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , sizeMap , sizeMap);
                    
                    OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})/sum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(:));
                    OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})';
                    
                    OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = log(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}));
                    OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(OccupMap_log.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
                    
                    for place=1:length(Place)
                        if place==1
                            ind1=16; ind2=29; ind3=2; ind4=20; Ind1=2; Ind2=29; Ind3=2; Ind4=20;
                        elseif place==2
                            ind1=2; ind2=15; ind3=2; ind4=20; Ind1=2; Ind2=29; Ind3=2; Ind4=20;
                        elseif place==3
                            ind1=16; ind2=29; ind3=33; ind4=50; Ind1=2; Ind2=29; Ind3=33; Ind4=50;
                        else
                            ind1=2; ind2=15; ind3=33; ind4=50; Ind1=2; Ind2=29; Ind3=33; Ind4=50;
                        end
                        
                        Map_Occup = OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                        Occupation.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}).(Place{place}) = sum(Map_Occup(ind1:ind2 , ind3:ind4))/sum(Map_Occup(Ind1:Ind2 , Ind3:Ind4));
                        clear Map_Occup
                        
                        Tigmo_score.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = ...
                            (nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(2:5,[2:18 35:50]))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:50,[2:4 48:50]))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:43,[16:18 35:37]))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(48:50,5:47))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(44:46,19:34))));
                        
                        Tigmo_score_shock.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = ...
                            (nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(2:5,2:18))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:43,2:4))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:43,16:18))))/...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(1:43,1:18)));
                        
                        Tigmo_score_safe.(Type{type}).(Mouse_names{mouse}).(Session_type{sess}) = ...
                            (nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(2:5,35:50))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:50,48:50))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(6:43,35:37))) +...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(48:50,35:47))))/...
                            nansum(nansum(OccupMap.(Type{type}).(Mouse_names{mouse}).(Session_type{sess})(1:50,35:50)));
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
                Tigmo_score_all.(Type{type}).(Session_type{sess}){n}(mouse) = Tigmo_score.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                Tigmo_score_all_shock.(Type{type}).(Session_type{sess}){n}(mouse) = Tigmo_score_shock.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                Tigmo_score_all_safe.(Type{type}).(Session_type{sess}){n}(mouse) = Tigmo_score_safe.(Type{type}).(Mouse_names{mouse}).(Session_type{sess});
                
                try; ExtraStimNumber.(Session_type{sess}){n}(mouse) = length(PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess}))-length(PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})); end
            end
            
            try
                OccupMap_squeeze.(Type{type}).(Session_type{sess}){n} = squeeze(nanmean(OccupMap.(Type{type}).(Session_type{sess}){n}));
                OccupMap_log_squeeze.(Type{type}).(Session_type{sess}){n} = log(OccupMap_squeeze.(Type{type}).(Session_type{sess}){n});
                OccupMap_log_squeeze.(Type{type}).(Session_type{sess})(OccupMap_log_squeeze.(Type{type}).(Session_type{sess}){n}==-Inf) = -1e4;
            end
            end
        end    
    end
    n=n+1;
end

% for type=1:length(Type)
%     for sess=1:length(Session_type) % generate all data required for analyses
%         for place=1:length(Place)
%             n=1;
%             for group=Group
%                 try
%                     Occupation.(Type{type}).(Session_type{sess}).(Place{place}){n} = Occupation.(Type{type}).(Session_type{sess}).(Place{place}){n};
%                 end
%                 n=n+1;
%             end
%         end
%     end
% end




