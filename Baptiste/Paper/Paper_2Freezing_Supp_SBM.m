
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 1 : Protocols & freezing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
edit Example_Trajectories_Paper_FreezingMaze_BM.m


%% time, breathing & episodes length
edit Blocked_vs_Explo_SessionsAnalysis_BM.m


%% tail temperature
edit TailTemperature_Freezing_UMaze_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 2 : 2 freezing depending on factors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit Freezing_Depending_OnFactors_BM.m


%% calibration
edit Calibration_Features_Eyelid_BM.m

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %   Temporal features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit OBFreq_TimeSinceLastStim_BM.m


edit Control_TemporalBiased_Features_Freezing_Maze_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 3 : analogy 2 sound conditionning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit FreezingComparison_Maze_SoundCond_BM.m


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


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 4 : ROC curves & physio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ROC_curves.mat')
% or after 
% edit ROC_curves_BodyParametersFreezingUMaze_BM.m



%% OB gamma
edit OB_Gamma_During_Freezing_UMaze_BM.m



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 6 : Rip control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit Control_Rip_Features_RipInhib_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 7 : Ripples on breathing phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit Ripples_Phase_on_Breathing_BM.m
load('/media/nas7/ProjetEmbReact/DataEmbReact/Ripples_On_Breathing_Phase.mat')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 9 : Reactivations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit RipplesReactiavtion_UMaze_Wake_Figures_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 10 : analogy 2 freezing with active / quiet wake / sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit Analogy_Fz_OtherStates_BM.m

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 12 : More sleep / SD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 13 : Fluo extended
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit FluoChronic_SumUp_Paper_BM.m

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sup 14 : Rip Inhib extended
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit RipInhib_SumUp_Paper_BM.m





