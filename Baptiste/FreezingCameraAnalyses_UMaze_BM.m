

clear all
GetEmbReactMiceFolderList_BM

Session_type={'Cond','Ext'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','Saline','Diazepam','RipControl','RipInhib','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','SalineMaze1Time1','DZPMaze1Time1','DZPMaze4Time1'};

Cols = {[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
X = [1:4];
Legends = {'Saline','Diazepam','Rip sham','Rip inhib'};
NoLegends = {'','','',''};

ind=1:4;
Group=5:8;

thtps_immob=10;

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            BlockedEpoch.(Session_type{sess}){n}{mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            ImDiffTsd = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'imdiff');
            
            NewImDiff=tsd(Range(ImDiffTsd),runmean(Data(ImDiffTsd),ceil(.02/median(diff(Range(ImDiffTsd,'s'))))));
            Freeze_Epoch=thresholdIntervals(NewImDiff,thtps_immob,'Direction','Below');
            Freeze_Epoch=mergeCloseIntervals(Freeze_Epoch,0.3*1e4);
            FreezeEpoch.(Session_type{sess}){n}{mouse}=dropShortIntervals(Freeze_Epoch,2*1e4);
            
            ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
            ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            
            FreezeShock.(Session_type{sess}){n}{mouse} = and(FreezeEpoch.(Session_type{sess}){n}{mouse} , ShockZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            FreezeSafe.(Session_type{sess}){n}{mouse} = and(FreezeEpoch.(Session_type{sess}){n}{mouse} , SafeZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            FreezeDuration_All.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}){n}{mouse}))/60e4;
            FreezeDuration_Shock.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeShock.(Session_type{sess}){n}{mouse}))/60e4;
            FreezeDuration_Safe.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(FreezeSafe.(Session_type{sess}){n}{mouse}))/60e4;
            
            disp(Mouse_names{mouse})
        end
        n=n+1;
    end
end


figure, sess=1;
subplot(131)
MakeSpreadAndBoxPlot3_SB(FreezeDuration_All.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (min)')
title('All')
subplot(132)
MakeSpreadAndBoxPlot3_SB(FreezeDuration_Shock.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Shock')
subplot(133)
MakeSpreadAndBoxPlot3_SB(FreezeDuration_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
title('Safe')

a=suptitle(['Freezing duration, ' (Session_type{sess}) ' sessions']); a.FontSize=20;






