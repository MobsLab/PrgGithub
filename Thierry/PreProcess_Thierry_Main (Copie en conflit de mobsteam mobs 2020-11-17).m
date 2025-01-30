cd ('/media/mobsmorty/dataMOBS70/Souris 648-TG108/29112017/VLPO-sleep Baseline day3_171212_093259/')

set(0,'DefaultFigureWindowStyle','docked')

% get info about intan recording
read_Intan_RHD2000_file

%% Pour séparer le.dat de 2 souris
% RefSubtraction_multi('amplifier.dat',32,2,'M675',0:15,4,[],'M645',16:31,20,[]); %32=nombre de voies; %2=nombre de souris
% RefSubtraction_multi('amplifier.dat',32,2,'M675',0:15,4,[],'M645',16:31,20,[]);
%% Make your .xls file
%% Make your .xml file for LFP amplifier.xml %% Baseline sleep
%% Make your .xml file for spike amplifier_SpikeRef.xml
%% Add your mouse to CallRefFunction_Thierry and CallRefFunctionSpikes_Thierry

%%if ExpeInfo.nmouse==648
%%RefSubtraction_multi('amplifier.dat',16,1,'M648',0:15,4,[]);
% elseif ExpeInfo.nmouse==649
%     RefSubtraction_multi('amplifier.dat',16,1,'M649',0:15,7,[]);
% etc...

% Get all the info you need

GetBasicInfoRecord_Thierry
GetMouseInfo_Thierry
% change the info in CallRefFunction_Thierry
%%if ExpeInfo.nmouse==648
%%RefSubtraction_multi('amplifier.dat',16,1,'M648',0:15,4,[]);
% elseif ExpeInfo.nmouse==649
%     RefSubtraction_multi('amplifier.dat',16,1,'M649',0:15,7,[]);
% etc...

% call in terminal all the preprocessing codes
ExecuteNDM_Thierry
% appelle toutes les fonction Preprocessing
% merge toutes les digin en une 
% fusion avec amplifier.dat
% filtrage divers
% sampling de 20000 Hz à 1250Hz
% va chercher les infos accelero / analogique / fichier spikes pour la PCA

%% check your files
SetCurrentSession

%% dans terminal
%%KlustaKwiknew M648_12122017_BaselineSleep_SpikeRef 1   

MakeData_Main_Thierry
% create matlab compatible files

%% sleep scoring
SleepScoringOBGamma

%% Low Spectrums
Faire_les_Low_Spectrum

% Fonction pour trier les stim en fonction des états
% Start= nombre de stim dans le REM à 0 sec
% Mid = nombre de stim dans le REM à 30 sec (défini par la digin)
% End = nombre de stim dans le REM à 60 sec 
Nb_Start_Mid_End_Stim_dans_REM

% défini pour chaque stim les états avant et après  
[Result] = Analyse_Stim_Ap()
%%défini les transitions
[TransREMSWS,TransSWSREM,TransSWSWake,TransSWSSWS,TransSWSNoise,TransREMWake,TransREMNoise,TransREMREM,TransWakeSWS,TransWakeREM,TransWakeNoise,TransWakeWake,TransNoiseSWS,TransNoiseREM, TransNoiseWake,TransNoiseNoise] = Ordered_Analyse_Stim_Ap(Result)

%% Figures
FiguresID_V1

%%% Parcours figures avec toutes les stim dans le REM:
%%% AJOUTER LES NUITS DANS LES PATH DES PARCOURS
[MatTotal,MatCellArray,timeREM,vectTotal,vect,tps2]=ParcoursTransitionSleepOptoV2AllStim

[MatTotal,MatCellArray,timeREM,vectTotalB,vect,tps2]=ParcoursTransitionSleepBaselineSimulatedV2AllStim

