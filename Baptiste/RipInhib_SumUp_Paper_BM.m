


Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'RipControl','RipInhib'};


Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% Generate data part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

% Occup map and trajectories
Group=[7 8];
GetEmbReactMiceFolderList_BM
Session_type={'Cond','TestPost'};

Trajectories_Function_Maze_BM


% OB Low
clear all
Group=[1 2];
Session_type={'Fear'};
Drug_group={'RipControl','RipInhib'};

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

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

%% a) Learning is the same
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

% stims number
figure
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-12 StimNumber.Cond{2}-12},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('aversive stimulations (#)')
makepretty_BM2



% TestPost occupancy
clear OccupMap
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:length(Session_type)
            Speed.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}) , 'speed');
            
            NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
            Moving=thresholdIntervals(NewSpeed,2,'Direction','Above');
            Moving=mergeCloseIntervals(Moving,0.3*1e4);
            Moving=dropShortIntervals(Moving,0.3*1e4);
            Pos_Moving.(Session_type{sess}) = Restrict(Position_tsd_Active_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) , Moving);
            D = Data(Pos_Moving.(Session_type{sess}));
            OccupMap.(Session_type{sess}){n}(mouse,:,:) = hist2d([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , 100 , 100);
        end
    end
    n=n+1;
end


figure
subplot(121)
imagesc(squeeze(nanmedian(OccupMap.(Session_type{sess}){1}))'), hold on
axis xy, axis square, caxis([0 5])
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
axis off

subplot(122)
imagesc(squeeze(nanmedian(OccupMap.(Session_type{sess}){2}))'), hold on
axis xy, axis square, caxis([0 10])
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
axis off

colormap hot


figure
for mouse=1:10
    subplot(2,10,mouse)
    imagesc(squeeze(OccupMap.(Session_type{sess}){1}(mouse,:,:))')
    axis xy, axis square, caxis([0 10])
    
    subplot(2,10,mouse+10)
    imagesc(squeeze(OccupMap.(Session_type{sess}){2}(mouse,:,:))')
    axis xy, axis square, caxis([0 10])
end


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



%% b) more shock fz
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
yticklabels({'Rip inhib','Rip control'}), 
makepretty_BM2
xlim([-.35 .35])

[p(1),h,stats] = ranksum(FreezingShock_prop.Cond{1} , FreezingShock_prop.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_prop.Cond{1} , FreezingSafe_prop.Cond{2});
p

lim=-.28;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.32,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.21;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.23,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




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
xlabel('freezing time (s)')
yticklabels({'Rip inhib','Rip control'}), 
makepretty_BM2
xlim([-10 10])

[p(1),h,stats] = ranksum(FreezingShock_Dur.Cond{1} , FreezingShock_Dur.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_Dur.Cond{1} , FreezingSafe_Dur.Cond{2});
p

lim=-5;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-5.5,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=9;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(9.5,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



%% c) Shock freezing is safe
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')


figure
[~,~,Freq_Max1] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*squeeze(OutPutData.RipControl.Cond.ob_low.mean(:,5,:)) , 'threshold' , 26);
[~,~,Freq_Max2] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*squeeze(OutPutData.RipControl.Cond.ob_low.mean(:,6,:)) , 'threshold' , 26);
close
% Freq_Max1(7)=NaN; Freq_Max2(7)=1.373;
% Freq_Max1(8)=2.747; Freq_Max2(8)=NaN;

figure
Plot_MeanSpectrumForMice_BM(Spectro{3}.*squeeze(OutPutData.RipInhib.Cond.ob_low.mean(:,5,:)), 'color' , [1 .8 .8], 'smoothing' , 3 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(Spectro{3}.*squeeze(OutPutData.RipInhib.Cond.ob_low.mean(:,6,:)), 'color' , [.8 .8 1], 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(nanmean(Freq_Max1))); set(v1,'LineStyle','--','Color',[1 .5 .5],'LineWidth',2); 
v2=vline(nanmean(nanmean(Freq_Max2))); set(v2,'LineStyle','--','Color',[.5 .5 1],'LineWidth',2)
xticks([0:2:10])
axis square


OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
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
Make_PCA_Plot_BM(PC_values_shock_sal{1} , PC_values_shock_sal{2} , 'color' , Cols{1})
Make_PCA_Plot_BM(PC_values_safe_sal{1} , PC_values_safe_sal{2} , 'color' , Cols{3})
Make_PCA_Plot_BM(PC_values_shock_drug{1} , PC_values_shock_drug{2} , 'color' , Cols{2})
Make_PCA_Plot_BM(PC_values_safe_drug{1} , PC_values_safe_drug{2} , 'color' , Cols{4})
vline(0,'--k'), hline(0,'--k')
xlabel('PC1 value'), ylabel('PC2 value')
f=get(gca,'Children'); legend([f([27 19 10 1])],'Shock RipControl','Safe RipControl','Shock RipInhib','Safe RipInhib');
xlim([-3 4]), ylim([-3 2.5])
grid on













