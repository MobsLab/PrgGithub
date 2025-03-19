%% Some conventions
% Colors
Cols.Shock_Ctrl = [1 0.5 0.5]; 
Cols.Safe_Ctrl = [0.5 0.5 1]; 
Cols.Shock_FlxChr = [0.7,0.3,0.3];
Cols.Safe_FlxChr = [0.3,0.3,0.7];
Cols.Shock_RipInhib = [1,0.8,0.8];
Cols.Safe_RipInhib = [0.8,0.8,1];

%% Useful places
% Data for figures
'/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/'
% For statsw
https://docs.google.com/spreadsheets/d/1YjbDNbrAc8-lKRNrFsmwyXEinpN2BYV7GmjlievCbBQ/edit?usp=sharing
% Note pad on paper
https://docs.google.com/document/d/15JBBGA7BdG0gwBFOFU0SV3Uk78D262OxBIgkDLFSYh0/edit?usp=sharing


%% Figure 1 - two types of freezing
% Make example
MakeExampleFig1_UmazePaper.m

% Quantification of behaviour

% Quantification of parameters during freezing

% SVM
SVMscores_SomaticOnly_Maze_BM.m
SVMmultiClass_DifferentStates.m

% Compare safe freezing to shock freezing and sleep etc
SVMmultiClass_DifferentStates.m

%% Figure 2 - stress score correlates with recovery imombility
% SDS / DZP / Ripples stress score
LookAtAllStressScore_Rip_DZP_Sal_SDS_UMaze.m
% Code by Baptistes that does the same Recuperation_Maze_SumUp_BM_ScoreSB.m

% Code for "homeostasis" measure of freezing level missing
GetStressScore_Sal_DZP_Rip.m
% Code for correlating stress score with freezing types missing

%% Figure 3 - Hippocampal place cell
% COde for number of ripples


% COde for example data

% Code for place cell activity on ripples
PlaceCells_Replay_Subsampling_FreezingShock_BM_SB_VFin.m
PlaceCells_Replay_Subsampling_FreezingSafe_BM_SB_VFin.m


% Code for reactivation analysis

%% Figure 3 - ripple inhib effect on stress score
ResidualCorrStressScore_Umaze_DZPGroup
ResidualCorrStressScore_Umaze_RipGroup

%% Figure supp
% Mouvement vs other parameters
ROC_curves_BodyParametersFreezingUMaze_SB

%% SVM saline
Finalfigures_DecodePositionWithPhysio_2sbinBy2sBin
Finalfigures_DecodePositionWithPhysio_MouseByMouse

%% SVM fluo chronic
Finalfigures_DecodePositionWithPhysio_FullEp_FlxChr_SVM

%% SVM ripples inhibition
Finalfigures_DecodePositionWithPhysio_FullEp_RipInhib_SVM


%% Codes for reactivation 
%location : /home/mobsrick/Dropbox/Kteam/PrgMatlab/EmbReact/Ephys/Spikes/RipplesReactivationUMaze

% PFc
RipplesReactivation_NewRipplesMethos_SB
% PHC
RipplesReactivationUmazeWake_HPC


%% Ripples correlation with breathing
ROC_curves_BodyParametersFreezingUMaze_SB.m


%% SDS
AnalyseSocialDefeat_CompareUmaze_FigPaper.m


% codes for figures, BM
edit Paper_2Freezing_SBM.m







%%%%
%Figure1



% Figure 4
%
ResidualCorrStressScore_Umaze_RipGroup
