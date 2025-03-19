

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ZoneAnalysis.mat')

% or 

GetEmbReactMiceFolderList_BM
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type={'TestPre','TestPost'};
for sess=1:2
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        clear ZoneEpoch FreezeEpoch
        ZoneEpoch = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch_behav');
        ZoneEpochDur.(Session_type{sess}){1}(mouse) = sum(DurationEpoch(ZoneEpoch{1}))/720e4;
        ZoneEpochDur.(Session_type{sess}){2}(mouse) = sum(DurationEpoch(ZoneEpoch{2}))/720e4;
        
        disp(mouse)
    end
end
Session_type={'Cond'}; sess=1;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    clear ZoneEpoch FreezeEpoch
    ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch_behav');
    FreezeEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch_withnoise');
    FreezeDur.(Session_type{sess}){1}(mouse) = sum(DurationEpoch(and(FreezeEpoch , ZoneEpoch{1})))/60e4;
    FreezeDur.(Session_type{sess}){2}(mouse) = sum(DurationEpoch(and(FreezeEpoch , or(ZoneEpoch{2} , ZoneEpoch{5}))))/60e4;
    FreezeDur_prop.(Session_type{sess}){1}(mouse) = sum(DurationEpoch(and(FreezeEpoch , ZoneEpoch{1})))/sum(DurationEpoch(ZoneEpoch{1}));
    FreezeDur_prop.(Session_type{sess}){2}(mouse) = sum(DurationEpoch(and(FreezeEpoch , or(ZoneEpoch{2} , ZoneEpoch{5}))))/sum(DurationEpoch(or(ZoneEpoch{2} , ZoneEpoch{5})));
    
    disp(mouse)
end


%% Explo
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ZoneEpochDur.TestPre{1} ZoneEpochDur.TestPre{2}},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1.2]), ylabel('proportion of time')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({ZoneEpochDur.TestPost{1} ZoneEpochDur.TestPost{2}},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1.2]), ylabel('proportion of time')
makepretty_BM2


%% Fz
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(FreezeDur.Cond,Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 25]), ylabel('freezing duration (min)'), set(gca,'YScale','log')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(FreezeDur_prop.Cond,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('freezing proportion')
makepretty_BM2






%% previously in barh
% a=barh([2 1],[-nanmean(FreezingShock_Dur.Cond{1}/60); -nanmean(FreezingShock_Dur.Cond{2}/60)],'stacked'); hold on
% errorbar(-nanmean(FreezingShock_Dur.Cond{1}/60),2,nanstd(FreezingShock_Dur.Cond{1}/60)/sqrt(length(FreezingShock_Dur.Cond{1}/60)),0,'.','horizontal','Color','k');
% errorbar(-nanmean(FreezingShock_Dur.Cond{2}/60),1,nanstd(FreezingShock_Dur.Cond{2}/60)/sqrt(length(FreezingShock_Dur.Cond{2}/60)),0,'.','horizontal','Color','k');
% a.FaceColor=[1 .5 .5]; 
% 
% a=barh([2 1],[nanmean(FreezingSafe_Dur.Cond{1}/60); nanmean(FreezingSafe_Dur.Cond{2}/60)],'stacked'); 
% errorbar(nanmean(FreezingSafe_Dur.Cond{1}/60),2,0,nanstd(FreezingSafe_Dur.Cond{1}/60)/sqrt(length(FreezingSafe_Dur.Cond{1}/60)),'.','horizontal','Color','k');
% errorbar(nanmean(FreezingSafe_Dur.Cond{2}/60),1,0,nanstd(FreezingSafe_Dur.Cond{2}/60)/sqrt(length(FreezingSafe_Dur.Cond{2}/60)),'.','horizontal','Color','k');
% a.FaceColor=[.5 .5 1]; 
% xlabel('freezing duration (min)')
% yticklabels({'Diazepam','Saline'}), 
% makepretty_BM2
% xlim([-8 8])
% 
% [p(1),h,stats] = ranksum(FreezingShock_Dur.Cond{1}/60 , FreezingShock_Dur.Cond{2}/60);
% [p(2),h,stats] = ranksum(FreezingSafe_Dur.Cond{1}/60 , FreezingSafe_Dur.Cond{2}/60);
% p
% 
% lim=-4;
% plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
% text(-4.5,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
% lim=7;
% plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
% text(7.5,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




