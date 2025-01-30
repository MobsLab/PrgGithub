


Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'Saline','Chronic flx'};


Cols = {[1 .5 .5],[.5 .5 1],[.7 .3 .3],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% Generate data part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

% Occup map and trajectories
Group=[1 2];
GetEmbReactMiceFolderList_BM
Session_type={'Cond','TestPost'};

Trajectories_Function_Maze_BM


% OB Low
clear all
Group=[1 2];
Session_type={'Fear'};
Drug_group={'Saline','ChronicFlx'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_group{group}).(Session_type{sess}) , Epoch1.(Drug_group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'ob_low');
    end
end


figure
[~,~,Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,5,:)));
[~,~,Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,6,:)));
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% FIGURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

%% a) Learning is the same
% edit SumUp_Diazepam_RipInhib_Maze_BM.m

% stims number
figure
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-16 StimNumber.Cond{2}-16},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('aversive stimulations (#)')
makepretty_BM2



% TestPost occupancy
figure
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('proportion of time'), ylim([0 .35])
makepretty_BM2



% Occup map
figure
subplot(121)
imagesc(SmoothDec(OccupMap_squeeze.All.TestPost{1},2))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


subplot(122)
imagesc(SmoothDec(OccupMap_squeeze.All.TestPost{2},2))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;



%% b) no more shock fz
figure
a=barh([2 1],[-nanmean(FreezingShock_prop.Cond{1}); -nanmean(FreezingShock_prop.Cond{2})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_prop.Cond{1}),2,nanstd(FreezingShock_prop.Cond{1})/sqrt(length(FreezingShock_prop.Cond{1})),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_prop.Cond{2}),1,nanstd(FreezingShock_prop.Cond{2})/sqrt(length(FreezingShock_prop.Cond{2})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_prop.Cond{1}); nanmean(FreezingSafe_prop.Cond{2})],'stacked'); 
errorbar(nanmean(FreezingSafe_prop.Cond{1}),2,0,nanstd(FreezingSafe_prop.Cond{1})/sqrt(length(FreezingSafe_prop.Cond{1})),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_prop.Cond{2}),1,0,nanstd(FreezingSafe_prop.Cond{2})/sqrt(length(FreezingSafe_prop.Cond{2})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing proportion')
yticklabels({'Chronic flx','Saline'}), 
makepretty_BM2
xlim([-.2 .2])

[p(1),h,stats] = ranksum(FreezingShock_prop.Cond{1} , FreezingShock_prop.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_prop.Cond{1} , FreezingSafe_prop.Cond{2});
p

lim=-.08;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.1,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.18;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.19,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




FreezingShock_Dur.Cond{1} = FreezingShock_Dur.Cond{1}/60;
FreezingShock_Dur.Cond{2} = FreezingShock_Dur.Cond{2}/60;
FreezingSafe_Dur.Cond{1} = FreezingSafe_Dur.Cond{1}/60;
FreezingSafe_Dur.Cond{2} = FreezingSafe_Dur.Cond{2}/60;


figure
a=barh([2 1],[-nanmean(FreezingShock_Dur.Cond{1}); -nanmean(FreezingShock_Dur.Cond{2})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_Dur.Cond{1}),2,nanstd(FreezingShock_Dur.Cond{1})/sqrt(length(FreezingShock_Dur.Cond{1})),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_Dur.Cond{2}),1,nanstd(FreezingShock_Dur.Cond{2})/sqrt(length(FreezingShock_Dur.Cond{2})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_Dur.Cond{1}); nanmean(FreezingSafe_Dur.Cond{2})],'stacked'); 
errorbar(nanmean(FreezingSafe_Dur.Cond{1}),2,0,nanstd(FreezingSafe_Dur.Cond{1})/sqrt(length(FreezingSafe_Dur.Cond{1})),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_Dur.Cond{2}),1,0,nanstd(FreezingSafe_Dur.Cond{2})/sqrt(length(FreezingSafe_Dur.Cond{2})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing time (min)')
yticklabels({'Chronic flx','Saline'}), 
makepretty_BM2
xlim([-8.5 8.5])

[p(1),h,stats] = ranksum(FreezingShock_Dur.Cond{1} , FreezingShock_Dur.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_Dur.Cond{1} , FreezingSafe_Dur.Cond{2});
p

lim=-1.67;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-2,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=7.5;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(7.83,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


% box plots
figure
MakeSpreadAndBoxPlot3_SB({FreezingShock_prop.Cond{1} FreezingSafe_prop.Cond{1}...
    FreezingShock_prop.Cond{2} FreezingSafe_prop.Cond{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('freezing proportion')
makepretty_BM2


%% c) Shock freezing is safe
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

figure
[~,~,Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.ChronicFlx.Fear.ob_low.mean(:,5,:)), 'color' , [.7 .3 .3], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~,Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.ChronicFlx.Fear.ob_low.mean(:,6,:)), 'color' , [.3 .3 .7], 'smoothing' , 3 , 'dashed_line' , 0);

figure
[~,~,Freq_Max3] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,5,:)), 'color' , [.7 .3 .3], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~,Freq_Max4] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,6,:)), 'color' , [.3 .3 .7], 'smoothing' , 3 , 'dashed_line' , 0);


f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(nanmean(Freq_Max1))); set(v1,'LineStyle','--','Color',[1 .5 .5],'LineWidth',2); 
v2=vline(nanmean(nanmean(Freq_Max2))); set(v2,'LineStyle','--','Color',[.5 .5 1],'LineWidth',2)
xticks([0:2:10])
axis square


OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.SalineSB.Ext.Shock OB_Max_Freq.SalineSB.Ext.Safe...
    OB_Max_Freq.ChronicFlx.Ext.Shock OB_Max_Freq.ChronicFlx.Ext.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1 5.5]), ylabel('Breathing (Hz)')
makepretty_BM2

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.SalineSB.Fear.Shock OB_Max_Freq.SalineSB.Fear.Safe...
    OB_Max_Freq.ChronicFlx.Fear.Shock OB_Max_Freq.ChronicFlx.Fear.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1 5.5]), ylabel('Breathing (Hz)')
makepretty_BM2

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max3 Freq_Max4 Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1 5.5]), ylabel('Breathing (Hz)')
makepretty_BM2


%% d) SVM scores
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Flx_Chr.mat')

SVMChoice_Sf(SVMScores_Sf==0) = NaN;
SVMScores_Sf(SVMScores_Sf==0) = NaN;
SVMChoice_Sk(SVMScores_Sk==0) = NaN;
SVMScores_Sk(SVMScores_Sk==0) = NaN;

SVMChoice_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMScores_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMChoice_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;
SVMScores_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;


figure
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('SVM score (a.u.)')
makepretty_BM2
hline(0,'--k')




%% PCA
figure
Make_PCA_Plot_BM(PC_values_shock_sal{1} , PC_values_shock_sal{2} , 'color' , [1 .5 .5])
Make_PCA_Plot_BM(PC_values_safe_sal{1} , PC_values_safe_sal{2} , 'color' , [.5 .5 1])
Make_PCA_Plot_BM(PC_values_shock_drug{1} , PC_values_shock_drug{2} , 'color' , [.7 .3 .3])
Make_PCA_Plot_BM(PC_values_safe_drug{1} , PC_values_safe_drug{2} , 'color' , [.3 .3 .7])
vline(0,'--k'), hline(0,'--k')
xlabel('PC1 value'), ylabel('PC2 value')
f=get(gca,'Children'); legend([f([25 17 9 1])],'Shock Saline','Safe Saline','Shock Chronic flx','Safe Chronic flx');
xlim([-3 4]), ylim([-2.5 2])
grid on





