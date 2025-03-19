
Group={'SD','DZP'};
FreeExplo_Path_BM

for group=1:2
    for mouse=1:8
        try
            Speed.(Group{group}).Hab{mouse} = ConcatenateDataFromFolders_SB({PathExplo.(Group{group}){mouse}{1}},'speed');
            Speed.(Group{group}).TestPre{mouse} = ConcatenateDataFromFolders_SB(PathExplo.(Group{group}){mouse}(2:5),'speed');
            SPEED.(Group{group}).Hab(mouse) = nanmean(Data(Speed.(Group{group}).Hab{mouse}));
            SPEED.(Group{group}).TestPre(mouse) = nanmean(Data(Speed.(Group{group}).TestPre{mouse}));
            SPEED.(Group{group}).Hab(SPEED.(Group{group}).Hab==0) = NaN;
            SPEED.(Group{group}).TestPre(SPEED.(Group{group}).TestPre==0) = NaN;
            
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
            
            FreezeProp.(Group{group}).Hab(mouse) = sum(DurationEpoch(FreezeEpoch.(Group{group}).Hab{mouse}))/max(Range(Position.(Group{group}).Hab{mouse}));
            FreezeProp.(Group{group}).TestPre(mouse) = sum(DurationEpoch(FreezeEpoch.(Group{group}).TestPre{mouse}))/max(Range(Position.(Group{group}).TestPre{mouse}));
            D = Data(Speed.(Group{group}).Hab{mouse}); D=D(D<2);
            ImmobilityTime.(Group{group}).Hab(mouse) = length(D)/length(Data(Speed.(Group{group}).Hab{mouse}));
            D = Data(Speed.(Group{group}).TestPre{mouse}); D=D(D<2);
            ImmobilityTime.(Group{group}).TestPre(mouse) = length(D)/length(Data(Speed.(Group{group}).TestPre{mouse}));
        end
    end
end
Thigmo_score.DZP.Hab(1:3)=NaN;
Thigmo_score.DZP.TestPre(1:3)=NaN;
Thigmo_score_NoFreeze.DZP.Hab(1:3)=NaN;
Thigmo_score_NoFreeze.DZP.TestPre(1:3)=NaN;
FreezeProp.DZP.Hab(1:3)=NaN;
FreezeProp.DZP.TestPre(1:3)=NaN;

%%
GetEmbReactMiceFolderList_BM

Session_type={'Habituation','TestPre'};
Mouse=[688 739 777 779 849 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:2
        
        Sessions_List_ForLoop_BM
        
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'AlignedPosition');
        if sess==1
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = or(or(intervalSet(0,5*60e4) , intervalSet(15*60e4,18*60e4)) , or(intervalSet(30*60e4,35*60e4) , intervalSet(45*60e4,48*60e4)));
        else
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet([],[]);
        end
        TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
        UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
        
        Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
    end
    disp(Mouse_names{mouse})
end
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    FreezeEpoch.Saline.Hab{mouse} = ConcatenateDataFromFolders_SB(HabSess.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
    FreezeEpoch.Saline.TestPre{mouse} = ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
    
    Position_NoFreeze.Saline.Hab{mouse} = Restrict(Position_tsd_Unblocked.(Mouse_names{mouse}).Habituation , intervalSet(0,max(Range(Position_tsd_Unblocked.(Mouse_names{mouse}).Habituation)))-FreezeEpoch.Saline.Hab{mouse});
    Position_NoFreeze.Saline.TestPre{mouse} = Restrict(Position_tsd_Unblocked.(Mouse_names{mouse}).TestPre , intervalSet(0,max(Range(Position_tsd_Unblocked.(Mouse_names{mouse}).TestPre)))-FreezeEpoch.Saline.TestPre{mouse});
    
    Thigmo_score.Saline.Hab(mouse) = Thigmo_From_Position_BM(Position_tsd_Unblocked.(Mouse_names{mouse}).Habituation);
    Thigmo_score.Saline.TestPre(mouse) = Thigmo_From_Position_BM(Position_tsd_Unblocked.(Mouse_names{mouse}).TestPre);
    Thigmo_score_NoFreeze.Saline.Hab(mouse) = Thigmo_From_Position_BM(Position_NoFreeze.Saline.Hab{mouse});
    Thigmo_score_NoFreeze.Saline.TestPre(mouse) = Thigmo_From_Position_BM(Position_NoFreeze.Saline.TestPre{mouse});
    
    FreezeProp.Saline.Hab(mouse) = sum(DurationEpoch(FreezeEpoch.Saline.Hab{mouse}))/max(Range(Position_tsd_Unblocked.(Mouse_names{mouse}).Habituation));
    FreezeProp.Saline.TestPre(mouse) = sum(DurationEpoch(FreezeEpoch.Saline.TestPre{mouse}))/max(Range(Position_tsd_Unblocked.(Mouse_names{mouse}).TestPre));
end



Cols = {[.5 1 .5],[1 .5 1],[.5 .3 1],[.3 1 .3],[1 .3 1],[.3 .1 1]};
Legends = {'Saline Hab','SD Hab','DZP Hab','Saline TestPre','SD TestPre','DZP TestPre'};
X = [1:6];
NoLegends = {'','','','','',''};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Thigmo_score.Saline.Hab Thigmo_score.SD.Hab Thigmo_score.DZP.Hab Thigmo_score.Saline.TestPre Thigmo_score.SD.TestPre Thigmo_score.DZP.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxism all')

subplot(132)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Saline.Hab FreezeProp.SD.Hab FreezeProp.DZP.Hab FreezeProp.Saline.TestPre FreezeProp.SD.TestPre FreezeProp.DZP.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
title('Freezing proportion')

subplot(133)
MakeSpreadAndBoxPlot3_SB({Thigmo_score_NoFreeze.Saline.Hab Thigmo_score_NoFreeze.SD.Hab Thigmo_score_NoFreeze.DZP.Hab Thigmo_score_NoFreeze.Saline.TestPre Thigmo_score_NoFreeze.SD.TestPre Thigmo_score_NoFreeze.DZP.TestPre},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('thigmo score (a.u.)')
title('Thigmotaxism non freezing')








