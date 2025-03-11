
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                                     PAPER SBM                                                        %
%                                                THERE IS 2 FREEZING !!                                                %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2.5];
Legends={'Shock','Safe'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : Task presentation & physio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) Cartoon protocol / trajectories / stats explo

% protocol cartoon 
edit Display_Maze_BM.m


% trajectories & Freeze Occup map
edit Example_Trajectories_Paper_FreezingMaze_BM.m


% Pre Post and Fz stats
edit Explo_Features_PrePost_UMaze.m


%% b) Cartoon recording + neurons + LFP
edit Example_2FzTypes_Paper_BM.m

% Mouse example
edit Example_Panel_Paper_FreezingMaze_BM.m


%% Physio
% mean values
edit MeanBodyParameters_Freezing_Maze_BM.m


% SVM
edit SVMscores_SomaticOnly_Maze_BM.m



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3 : Confusional states & recuperation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sound & context
edit SVMscores_Sound_Ctxt_Maze_BM.m

%% Fluo
edit SVMScores_Fluo_Maze_BM.m


load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

Cols = {[1 .5 .5],[.5 .5 1],[.7 .3 .3],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Safe','Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB({FreezingShock_prop.Fear{1} FreezingSafe_prop.Fear{1} FreezingShock_prop.Fear{2} FreezingSafe_prop.Fear{2}},...
Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion time freezing')
makepretty_BM2



%% Recuperation
edit Recuperation_Maze_SumUp_BM_ScoreSB.m



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : HPC SWR/Neurons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Brain
% box plot for ripples
edit MeanBodyParameters_Freezing_Maze_BM.m



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3 : Breathing and ripples 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) Ripples occurence = f(respi)
edit Ripples_Density_OB_Frequency_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')


%% b) Ripples on breathing phase
edit Ripples_Phase_on_Breathing_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')
% load('/media/nas7/ProjetEmbReact/DataEmbReact/Ripples_On_Breathing_Phase.mat', 'OutPutData' , 'Mean_LFP_respi_shock' , 'Mean_LFP_respi_safe' , 'HistData')


%% c) OB spectrograms around ripples
edit OB_Spectrogram_AroundRipples_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 4 : Ripples control & inhib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'Rip control','Rip inhib'};


Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

%% a) Protocol
% edit Ripples_Inhibition_Analysis_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

Ripples_Inhibition_Example_BM

%% b) Learning is the same
edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

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
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},{[.6 .6 .6],[.3 .3 .3]},[1 2],{'Rip Control','Rip inhib'},'showpoints',1,'paired',0);
ylabel('proportion of time'), ylim([0 .35])
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



%% c) Safe freezing is shock
edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

OB_MaxFreq_Maze_BM


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 5 : Saline & fluo chronic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit FluoChronic_SumUp_Paper_BM.m

%% Fz shock is like the others

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCondSound.mat', 'Freq_Max_Shock_FearSound','Freq_Max1','Freq_Max2')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCtxt.mat', 'Freq_Max_Shock_FearCtxt')

Freq_Max1(46)=4.959;
Freq_Max2(30)=NaN;

Cols = {[1 .5 .5],[.5 .5 1],[.8 .1 .2],[1 .4 .1]};
X = 1:4;
Legends = {'Shock','Safe','Sound','Context'};

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max1(26:end) Freq_Max2(26:end) Freq_Max_Shock_FearSound Freq_Max_Shock_FearCtxt},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 8]), ylabel('Breathing (Hz)')
makepretty_BM2





