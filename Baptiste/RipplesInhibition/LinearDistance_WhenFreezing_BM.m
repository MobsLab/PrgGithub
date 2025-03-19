
clear all
GetAllSalineSessions_BM

Session_type={'Cond'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','Saline','Diazepam','RipControl','RipInhib','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','SalineMaze1Time1','DZPMaze1Time1','DZPMaze4Time1'};

Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = [1:4];
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};

ind=1:4;
Group=11;

for sess=1
    Sessions_List_ForLoop_BM
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                LinearDist.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'linearposition');
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(LinearDist.(Session_type{sess}).(Mouse_names{mouse}))));
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_BM(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'blockedepoch');
                UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
                ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
                ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
                SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
                
                LinearDist_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                LinearDist_FzUnblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LinearDist.(Session_type{sess}).(Mouse_names{mouse}) , and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                
                %                 LinearDist_Data.(Session_type{sess}){n}(mouse) = nanmean(Data(LinearDist.(Session_type{sess}){n}{mouse}));
                %                 LinearDist_Data_Fz.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , FreezeEpoch.(Session_type{sess}){n}{mouse})));
                %                 LinearDist_Data_Unblocked.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , UnblockedEpoch.(Session_type{sess}){n}{mouse})));
                %
                %                 LinearDist_BlockedShock.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , and(BlockedEpoch.(Session_type{sess}){n}{mouse} , ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
                %                 LinearDist_BlockedSafe.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , and(BlockedEpoch.(Session_type{sess}){n}{mouse} , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})))));
                %
                %                 LinearDist_Data_FzBlocked.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , and(FreezeEpoch.(Session_type{sess}){n}{mouse} , BlockedEpoch.(Session_type{sess}){n}{mouse}))));
                %                 LinearDist_BlockedShockFz.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , and(BlockedEpoch.(Session_type{sess}){n}{mouse} , and(ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}){n}{mouse})))));
                %                 LinearDist_BlockedSafeFz.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(LinearDist.(Session_type{sess}){n}{mouse} , and(BlockedEpoch.(Session_type{sess}){n}{mouse} , and(SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}){n}{mouse})))));
                
            end
            disp(Mouse_names{mouse})
        end
        n=n+1;
    end
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        h=histogram(Data(LinearDist_Fz.Cond.(Mouse_names{mouse})),'BinLimits',[0 1],'NumBins',25);
        FreezingDistrib{1}(mouse,:) = h.Values;
    end
    if sum(FreezingDistrib{1}(mouse,:))==0
        FreezingDistrib{1}(mouse,:) = NaN;
    end
end


save('/media/nas7/ProjetEmbReact/DataEmbReact/BehaviourAlongMaze.mat','FreezingDistrib','-append')





for sess=1:length(Session_type)
    for i=1:4
        LinearDist_BlockedSafe_Corr.(Session_type{sess}){i} = 1-LinearDist_BlockedSafe.(Session_type{sess}){i};
        Ratio.(Session_type{sess}){i} = LinearDist_BlockedShock.(Session_type{sess}){i}./LinearDist_BlockedSafe.(Session_type{sess}){i};
        RatioFz.(Session_type{sess}){i} = LinearDist_BlockedShockFz.(Session_type{sess}){i}./LinearDist_BlockedSafeFz.(Session_type{sess}){i};
    end
end

figure; sess=1;
subplot(131)
MakeSpreadAndBoxPlot3_SB(LinearDist_BlockedShock.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('linear dist (a.u.)')
title('Shock zone')
subplot(132)
MakeSpreadAndBoxPlot3_SB(LinearDist_BlockedSafe_Corr.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Safe zone')
subplot(133)
MakeSpreadAndBoxPlot3_SB(Ratio.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Ratio shock/safe')
a=suptitle('Linear distance when blocked, Cond sessions'); a.FontSize=20;

figure; sess=1;
subplot(131)
MakeSpreadAndBoxPlot3_SB(LinearDist_BlockedShockFz.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('linear dist (a.u.)')
title('Shock zone')
subplot(132)
MakeSpreadAndBoxPlot3_SB(LinearDist_BlockedSafeFz.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Safe zone')
subplot(133)
MakeSpreadAndBoxPlot3_SB(RatioFz.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Ratio shock/safe')
a=suptitle('Linear distance when blocked, Cond sessions'); a.FontSize=20;


figure; sess=1;
MakeSpreadAndBoxPlot3_SB(LinearDist_Data_FzBlocked.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);


