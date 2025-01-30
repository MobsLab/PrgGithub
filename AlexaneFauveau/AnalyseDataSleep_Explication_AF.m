%% Recap pour traiter les données Sleep
% Systématiquement en ouvrant Matlab : home -> nomdel'ordi -> Dropbox ->
% Kteam -> PrgMatlab -> Click droit et Addd to path -> Selected Folders and
% Subfolders

% /home/gruffalo/Dropbox/Kteam

%% AVEC DONNEES ELECTROPHYSIOLOGIQUES :
%% PREMIERE ETAPE : Séparer les données INTAN des souris
% A effectuer si on enregistre plusieurs souris en même temps

% >> RefSubtraction_multi('nomdufichier',nbchannel, nbsouris,'nomsouris',[],[],[0:31],'nomsouris',[],[],[32:63])

% Pour 2 souris :
RefSubtraction_multi('amplifier.dat',64, 2,'nomsouris',[],[],[0:31],'nomsouris',[],[],[32:63])
RefSubtraction_multi('auxiliary.dat',6, 2,'nomsouris',[],[],[0:2],'nomsouris',[],[],[3:5])

% Pour 4 souris : 
RefSubtraction_multi('amplifier.dat',128, 4,'M1563',[],[],[0:31],'M1569',[],[],[32:63],'M1568',[],[],[64:95],'M1566',[],[],[96:127])
RefSubtraction_multi('auxiliary.dat',12, 4,'M1563',[],[],[0:2],'M1569',[],[],[3:5],'M1568',[],[],[6:8],'M1566',[],[],[9:11])
% Changer les numéros de channel au besoin : 

% Le faire pour les : 
% - amplifier.dat (en général 32 voies par souris)
% - auxiliary.dat (en général 3 voies par souris)

% Puis dans des fichiers séparés : mettre les fichiers amplifier et
% auxiliary et  les renommer correctement + plus copier les fichiers
% digitalin, digitalout, info, time et supply.

%% DEUXIEME ETAPE : Faire le pré-processing des données (échantilloner et filtrer)

% >> GUI_StepOne_ExperimentInfo

% Une page s'ouvre: changer les informations
% I am done
% -> Next step

% Une nouvelle page s'ouvre. Donner les numéros de voies (en général:
% 32,3,1,0) et NumDigital Inputs = 4

% Cliquer sur Channel Identity, et identifier les voies associer à chaque
% structures. 
% Bulb : respi and gamma ocillation 
% HPC : ripples et theta pdt REM
% PFC : desynchronize pdt NREM et forme des bulles

% Cliquer sur Digital Identity (en général: ONOFF ; CameraSync ; STIM ;
% STIM2)

% Cliquer sur Channel to analyse :
% Bulb : deep -> gamma ; sup -> pas de gamma
% PFC : sup -> forme la parties inférieures des boucles et spindles
% HPC: deep -> sharp wave très prononcé


% Next step : indiquer si données électrophy, syst, données behav, etc. 
% Donner les données electrophysiologies puis celle de comportement. Nommer
% le fichier. 
% Cocher Ref s'il N'y a PAS de ref

% I am done
% -> recliquer sur le path 
% I am done
%% DANS le cas où on n'a pas de supply.dat
% Ne pas cliquer sur le dernier I am done. A la place fermer la fenêtre et
% effectuer le code : 
% >> LastStepDoPreProcessing_NoSupply


%% Si problème au moment du LFP : 
% Effacer les Hab... sauf le .dat. Le renommer amplifier.dat et le copier
% avec le Expe Info dans le fichier XXXX_BaselineSleepX
% >> WriteExpeInfoToXml(ExpeInfo)
% 
% Refaire le GUI_StepOne_ExperimentInfo, et cocher le ref et merged done à
% la fin.
% Puis de nouveau LastStepDoPreProcessing_NoSupply

%% 2BIS : utiliser le code Correction_Digital_IN_AF
% >> Correction_Digital_IN_AF  /!\ Change the name of Filename by the name
% of the xml file

%% TROISIEME ETAPE :  Faire le SleepScoring

% Se mettre dans le fichier avec le .dat. Si problème pdt le SleepScoring,
% stop et suppr les 3 fichiers SleepScoring et recommencer ou
% >>SleepScoring_Accelero_OBgamma('Recompute',1)

% >> SleepScoring_Accelero_OBgamma

% En premier définir les High Noises. Si satisfait y sinon, n et définir le
% seuil
% Même chose avec les Ground noises
% ThresholdNoiseEpoch -> n 
% Weirdnoise epoch -> y si il y a eu des problèmes au moment de
% l'enregistrement (par exemple : oublier d'éteindre l'enregistrement, etc)

% Définir le threshold avec le Gamma power: déplacer le threshold au moment
% où on quitte la courbe
% Explication : gamma faible -> sommeil ; gamma élevé -> éveil

% Définir les immobilités Epoch 

% Même chose que Gamma pour le Theta / Delta Ratio
% Explication : ratio faible -> NREM ; ratio élevé -> REM





%% AVEC LES DONNEES PIEZO :

% Effectuer le code : 
% >> Synchronize_Intan_Piezo_Audiodream  %A modif avant !!!




