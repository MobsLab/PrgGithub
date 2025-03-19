


Cols3 = {[.6 .6 .6],[.3 .3 .3]};
X3 = 1:2;
Legends3 = {'Rip control','Rip inhib'};



%% behaviour
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

figure
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-12 StimNumber.Cond{2}-12},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('aversive stimulation (#)')
makepretty_BM2

[p,~,~] = signrank(StimNumber.Cond{1}-12, StimNumber.Cond{2}-12)

ylim([0 30])
ylim([0 15])
lim=14;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPre{1} ShockZone_Occupancy.TestPre{2}},Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('shock zone occup, Test Pre (prop)'), ylim([0 .4])
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},{[.6 .6 .6],[.3 .3 .3]},[1 2],{'Rip Control','Rip inhib'},'showpoints',1,'paired',0);
ylabel('shock zone occup, Test Post (prop)'), ylim([0 .4])
makepretty_BM2


% Occup map
load('/media/nas7/ProjetEmbReact/DataEmbReact/OccupMap_Rip_TestPost.mat')

figure
subplot(121)
imagesc(runmean(runmean(squeeze(nanmean(A{1}))',3)',3)), caxis([0 5e-4]), axis xy, axis square, axis off, hold on
% imagesc(squeeze(nanmean(A{1}))), caxis([0 5e-4]), axis xy, axis square, axis off, colormap hot, hold on
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

subplot(122)
imagesc(runmean(runmean(squeeze(nanmean(A{2}))',3)',3)), caxis([0 5e-4]), axis xy, axis square, axis off, hold on
% imagesc(squeeze(nanmean(A{2}))), caxis([0 5e-4]), axis xy, axis square, axis off, colormap hot, hold on
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(FreezingShock_Dur.Cond,Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('Fz duration, shock zone (s)')%, ylim([0 .4])
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_Dur.Cond,Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('Fz duration, safe zone (s)')%, ylim([0 .4])
makepretty_BM2





%% physio
% c) Safe freezing is shock
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([3 6.5]), ylabel('Breathing (Hz)')
makepretty_BM2


% SVM scores
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Ripples.mat')

figure
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('SVM score')
makepretty_BM2
hline(0,'--k')
















