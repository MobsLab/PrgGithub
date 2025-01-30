%% Recap pour traiter les données Sleep en jouant les sons : Part3_Audiodream_AlexaneFauveau
% Systématiquement en ouvrant Matlab : home -> nomdel'ordi -> Dropbox ->
% Kteam -> PrgMatlab -> Click droit et Addd to path -> Selected Folders and
% Subfolders

% /home/gruffalo/Dropbox/Kteam
FolderPath_3Sound_Audiodream_AF   % Path with all paths

%% AVEC DONNEES ELECTROPHYSIOLOGIQUES :
%% PREMIERE ETAPE : Recupérer les temps des sons et des synchronisations sur INTAN
Soundtime_CodeRapport_AF

% ATTENTION : je ne sais pas pourquoi TTLInfo.Sounds a un son de plus je
% crois, à vérifier

%% DEUXIEME ETAPE : Synchronizer INTAN et Piézo et faire le SleeScoring
Synchronize_Piezo_Intan_Sound_AF % => Modifier les path avant ! 

% Ce code est fait pour analyser les souris 1615 à 1620, en respectant leur
% position sur les cages piézo. 
% Si vous utiliser ce code pour d'autres souris, rectifier le avant. 

% Pour positionner le threshold: Proche de la première courbe, puis
% vérifier le résultat sur les données brutes. Recommencer si c'est moche. 



%% TROISIEME ETAPE: analyser les résultats post-stim
SoundAnalysis_CodeRapport_AF % For now, the WakeTime seems to works. But 
% not the MeanValuesPostStim blabla, done with PlotRipRaw. Maybe try
% mETAverage (Karim knows how to use it).

Soundanalysis_Wakeornot_AF % Just to plot data sleep/raw and moment of stim