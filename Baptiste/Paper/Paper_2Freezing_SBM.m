
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


% proportion
edit Proportion_Freezing_Maze_BM.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : Confusional states & recuperation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sound & context
edit SVMscores_Sound_Ctxt_Maze_BM.m


%% increase HR Test-Pre/Cond
edit HeartRate_TestPre_Cond_Maze_BM.m

%% correl heart
edit HR_EndMaze_StressScore_BM.m


%% Recuperation
edit Recuperation_Maze_SumUp_BM_ScoreSB.m



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3 : HPC SWR/Neurons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mean ripples side or mode
edit MeanBodyParameters_Freezing_Maze_BM.m
edit SWR_DependingOnBreathingMode_BM.m


%% Place cells analysis
edit PLaceCells_Replay_FreezingSafe_BM_SB_VFin.m


%% PCA analysis 
edit RipplesReactiavtion_UMaze_Wake_Figures_BM.m.m



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 4 : Ripples control & inhib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'Rip control','Rip inhib'};


Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = [1 2 3.5 4.5];
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

%% a) Protocol
% edit Ripples_Inhibition_Analysis_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

Ripples_Inhibition_Example_BM

%% b) Safe freezing is shock
edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([1.5 6.5]), ylabel('Breathing (Hz)')
title('Cond')


%% c) Recup
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/PC_values.mat', 'PCVal_Rip')

figure
MakeSpreadAndBoxPlot3_SB(PCVal_Rip,Cols2,X2,Legends2,'showpoints',1,'paired',0,'size_points',15);
ylabel('stress score')
makepretty_BM2



%% d) Learning is the same
edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data_Behav.mat')

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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 5 : Safety learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Temporal evolution
edit Kendall_TemporalEvol_FzMaze_BM.m




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 5 : DIAZEPAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'Saline','DZP'};


Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = [1 2 3.5 4.5];
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};









