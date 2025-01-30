% After AllSalineAnalysis_Maze_Paper_SBM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ZoneAnalysis.mat')

%
GetAllSalineSessions_BM
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
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    clear ZoneEpoch FreezeEpoch
    ZoneEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'zoneepoch_behav');
    FreezeEpoch = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'freezeepoch_withnoise');
    FreezeShockDur(mouse) = sum(DurationEpoch(and(FreezeEpoch , ZoneEpoch{1})))/60e4;
    FreezeSafeDur(mouse) = sum(DurationEpoch(and(FreezeEpoch , or(ZoneEpoch{2} , ZoneEpoch{5}))))/60e4;
    FreezeShockDur_prop(mouse) = sum(DurationEpoch(and(FreezeEpoch , ZoneEpoch{1})))/sum(DurationEpoch(ZoneEpoch{1}));
    FreezeSafeDur_prop(mouse) = sum(DurationEpoch(and(FreezeEpoch , or(ZoneEpoch{2} , ZoneEpoch{5}))))/sum(DurationEpoch(or(ZoneEpoch{2} , ZoneEpoch{5})));
    
    disp(mouse)
end

%% Explo
figure
subplot(121)
A = PropTime_Shock.TestPre;
B = PropTime_Safe.TestPre;
ind=or(A>.7,B>.7); % remove mice that spent more than 70% of time in shock zone. 3/51 : 436   469   471.
A(ind) = NaN;
B(ind) = NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)

plot([1 2],[1.1 1.1],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.15,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2


subplot(122)
A = PropTime_Shock.TestPost; A(isnan(A))=0;
B = PropTime_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',0,'paired',1,'showsigstar','none');
ylim([0 1.2])
[h,p] = ttest(A , B)

plot([1 2],[1.1 1.1],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.12,'***','HorizontalAlignment','Center','BackGroundColor','none','Tag','sigstar_stars','FontSize',20);
makepretty_BM2





%% Fz
figure
subplot(121)
A = FreezingShock_Dur.Fear{1}/60; 
B = FreezingSafe_Dur.Fear{1}/60;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',0,'paired',1);
ylim([0 30]), ylabel('freezing duration (min)')
makepretty_BM2


subplot(122)
A = FreezingShock_prop.Fear{1}; 
B = FreezingSafe_prop.Fear{1};
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',0,'paired',1,'showsigstar','none');
ylim([0 1]), ylabel('freezing duration (min)')
[h,p] = ttest(A , B)

plot([1 2],[23 23],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,24,'*','HorizontalAlignment','Center','BackGroundColor','none','Tag','sigstar_stars','FontSize',20);
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




