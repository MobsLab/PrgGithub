
% GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

Session_type={'Habituation','TestPre'};%,'Cond','TestPost'};
% Session_type={'Habituation'};

Mouse=[490 507 508 509 510 512 514];
%[688 739 777 779 849 893 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
        Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
        Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
        
        TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
        
        BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
        UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
        
        FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
%         try
%             Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples_epoch');
%         end
%         try
%             EyelidEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
%         end
%         try
%             Position_tsd_Eyelid.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , EyelidEpoch.(Mouse_names{mouse}).(Session_type{sess}));
%             Position_tsd_Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , EyelidEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%             Position_tsd_Unblocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , EyelidEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%         end
        
        Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
        Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
%         Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}));
%         Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%         Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%         try
%             Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%             Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
%             Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , Ripples_Epoch.(Mouse_names{mouse}).(Session_type{sess}))));
%         end
%         try
%             Position_tsd_Freeze_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}) , FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess})));
%             Position_tsd_Freeze_Blocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
%             Position_tsd_Freeze_Unblocked_VHC.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , and(FreezeEpoch.(Mouse_names{mouse}).(Session_type{sess}) , VHCStimEpoch.(Mouse_names{mouse}).(Session_type{sess}))));
%         end
%         
%         Position.Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
%         Position.Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
%         Position.Freeze.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}));
%         Position.Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
%         try
%             Position.Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
%         end
%         try
%             Position.Ripples.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
%             Position.Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
%             Position.Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}));
%         end
    end
    disp(Mouse_names{mouse})
end



for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        POSITION.All.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}),'s');
        POSITION.All.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.(Mouse_names{mouse}).(Session_type{sess})(:,1);
        POSITION.All.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.(Mouse_names{mouse}).(Session_type{sess})(:,2);
        
%         POSITION.Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.Free.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Free.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Free.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
        
%         POSITION.All_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.All_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Freeze.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.All_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Freeze.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.Blocked_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Blocked_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Blocked_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Freeze_Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.Free_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Free_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Free_Fz.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Freeze_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.All_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze_Ripples.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.All_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.All_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze_Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Blocked_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Ripples_Blocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.Free_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Freeze_Unblocked_Ripples.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         POSITION.Free_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,2) = Position.Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1);
%         POSITION.Free_Ripples.(Mouse_names{mouse}).(Session_type{sess})(:,3) = Position.Ripples_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);
%         
%         POSITION.All_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Eyelid.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         D = Data(Position_tsd_Eyelid.(Mouse_names{mouse}).(Session_type{sess}));
%         POSITION.All_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,2) = D(:,1);
%         POSITION.All_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,3) = D(:,2);
%         
%         POSITION.Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         D = Data(Position_tsd_Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}));
%         POSITION.Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,2) = D(:,1);
%         POSITION.Blocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,3) = D(:,2);
%         
%         POSITION.Free_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,1) = Range(Position_tsd_Unblocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}),'s');
%         D = Data(Position_tsd_Unblocked_Eyelid.(Mouse_names{mouse}).(Session_type{sess}));
%         POSITION.Free_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,2) = D(:,1);
%         POSITION.Free_Eyelid.(Mouse_names{mouse}).(Session_type{sess})(:,3) = D(:,2);
        
    end
end

% to generate variables usefull as thigmotaxism, immobility time, speed,...
edit Correlation_Matrices_Behaviour_Maze_BM.m
% D = Data(Speed.(Session_type{sess}).(Mouse_names{mouse})); D=D(D<2);
% ImmobilityTime.(Session_type{sess})(mouse) = length(D)/length(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})));



Drugs.Saline_Long = [688 739 777 779 849 893];
Drugs.Chronic_FLX = [875 876 877 1001 1002 1095 1130];
Drugs.Acute_FLX = [740 750 775 778 794];
Drugs.Midazolam = [829 851 857 858 859 1005 1006];
Drugs.Saline_Short = [1170 1171 9184 1189 9205 1391 1392 1393 1394];
Drugs.Diazepam = [11200 11206 11207 11251 11252 11253 11254];

cd('/media/nas6/ProjetEmbReact/DataEmbReact')
save('Data_For_Elisa_MwEPM.mat','Mouse','POSITION','Drugs')



