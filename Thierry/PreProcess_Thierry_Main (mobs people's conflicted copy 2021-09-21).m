cd ('/media/mobsmorty/dataMOBS70/Souris 648-TG108/29112017/VLPO-sleep Baseline day3_171212_093259/')

set(0,'DefaultFigureWindowStyle','docked')
% get info about intan recording
read_Intan_RHD2000_file

%% Pour séparer le.dat de 2 souris
% RefSubtraction_multi('amplifier.dat',32,2,'M675',0:15,4,[],'M645',16:31,20,[]); %32=nombre de voies; %2=nombre de souris
% RefSubtraction_multi('amplifier.dat',32,2,'M675',0:15,4,[],'M645',16:31,20,[]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1055',[0:31],8,[64,65,66,70],'M1052',[32:63],57,[67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1052',[0:31],25,[64,65,66,70],'M1055',[32:63],40,[67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1052',[0:31],25,[64,65,66,70],'M1055',[32:63],40,[67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1055',[0:31],8,[64,65,66,70],'M1052',[32:63],57,[67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1052',[0:31],25,[64,65,66,70],'M1055',[40],40,[32:39,41:63,67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',71,2,'M1052',[0:31],25,[64,65,66,70],'M1055',[40],40,[32:39,41:63,67,68,69,70]);
%RefSubtraction_multi('amplifier.dat',36,1,'M1052',[0:31],25,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1076',[0:31],24,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1074',[0:31],24,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1075',[0:31],25,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1074',[8],8,[0:31,32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1076',[0:31],24,[64,65,66,70],'M1055',[32:63],40,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1055',[8],8,[0:31,64,65,66,70],'M1075',[32:63],41,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1055',[0:31],8,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',71,1,'M1055',[8],8,[0:31,64,65,66]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1110',[10],10,[0:9,11:31,64,65,66,70],'M1109',[42],42,[32:41,43:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1109',[10],10,[0:9,11:31,64,65,66,70],'M1110',[32:63],42,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1110',[10],10,[0:9,11:31,64,65,66,70],'M1109',[42],42,[32:41,43:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1112',[8],8,[0:7,9:31,64,65,66,70],'M1111',[32:63],41,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1111',[9],9,[0:8,10:31,64,65,66,70],'M1112',[32:63],40,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1105',[22],22,[0:21,23:31,64,65,66,70],'M1106',[42],42,[32:41,43:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1105',[22],22,[0:21,23:31,64,65,66,70],'M1106',[42],42,[32:41,43:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',1,3,'M1105',[22],22,[0:21,23:31,96,97,98,105],'M1107',[40],40,[32:39,41:63,99,100,101,105],'M1106',[74],74,[64:73,75:95,102,103,104,105]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1109',[10],10,[0:9,11:31,32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',141,4,'M1105',[22],22,[0:21,23:31,128,129,130,140],'M1106',[42],42,[32:41,43:63,131,132,133,140],'M1107',[72],72,[64:71,73:95,134,135,136,140],'M1112',[104],104,[96:103,105:127,137,138,139,140]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1137',[0:31],8,[64,65,66,70],'M1136',[40],40,[32:39,41:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1136',[8],8,[0:7,9:31,64,65,66,70],'M1137',[32:63],40,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1075',[0:31],25,[96,97,98,105],'M1107',[40],40,[32:39,41:63,99,100,101,105],'M1112',[72],72,[64:71,73:95,102,103,104,105]);
% RefSubtraction_multi('amplifier.dat',141,4,'M1105',[22],22,[0:21,23:31,128,129,130,140],'M1106',[42],42,[32:41,43:63,131,132,133,140],'M1107',[72],72,[64:71,73:95,134,135,136,140],'M1112',[104],104,[96:103,105:127,137,138,139,140]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1150',[0:31],8,[96,97,98,105],'M1149',[40],40,[32:39,41:63,99,100,101,105],'M1148',[72],72,[64:71,73:95,102,103,104,105]);

% RefSubtraction_multi('amplifier.dat',71,2,'M1109',[10],10,[0:9,11:31,64,65,66,70],'M1137',[32:63],40,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',141,4,'M1105',[0:31],24,[128,129,130,140],'M1106',[40],40,[32:39,41:63,131,132,133,140],'M1109',[74],74,[64:73,75:95,134,135,136,140],'M1137',[104],104,[96:103,105:127,137,138,139,140]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1148',[8],8,[0:7,9:31,64,65,66,70],'M1149',[40],40,[32:39,41:63,67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1150',[0:31],8,[96,97,98,105],'M1149',[40],40,[32:39,41:63,99,100,101,105],'M1148',[72],72,[64:71,73:95,102,103,104,105]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1105',[22],22,[0:21,23:31,96,97,98,105],'M1107',[40],40,[32:39,41:63,99,100,101,105],'M1106',[74],74,[64:73,75:95,102,103,104,105]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1148',[0:31],8,[96,97,98,105],'M1149',[40],40,[32:39,41:63,99,100,101,105],'M1150',[72],72,[64:71,73:95,102,103,104,105]);

% RefSubtraction_multi('amplifier.dat',71,2,'M1179',[8],8,[0:7,9:31,64,65,66,70],'M1180',[32:63],56,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1180',[0:31],24,[64,65,66,70],'M1179',[32:63],40,[67,68,69,70]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1181',[8],8,[0:7,9:31,64,65,66,70],'M1180',[32:63],56,[67,68,69,70]);

% RefSubtraction_multi('amplifier.dat',36,1,'M1150',[0:31],8,[32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',36,1,'M1197',[9],9,[0:8,10:31,32,33,34,35]);
% RefSubtraction_multi('amplifier.dat',106,3,'M1196',[9],9,[0:8,10:31,96,97,98,105],'M1197',[41],41,[32:40,42:63,99,100,101,105],'M1198',[73],73,[64:72,74:95,102,103,104,105]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1196',[0:31],9,[64,65,66,70],'M1197',[41],41,[32:40,42:63,67,68,69,70]);

% RefSubtraction_multi('amplifier.dat',106,3,'M1148',[8],8,[0:7,9:31,96,97,98,105],'M1149',[40],40,[32:39,41:63,99,100,101,105],'M1150',[72],72,[64:71,73:95,102,103,104,105]);

% RefSubtraction_multi('amplifier.dat',141,4,'M1217',[8],8,[0:7,9:31,128,129,130,140],'M1218',[40],40,[32:39,41:63,131,132,133,140],'M1219',[73],73,[64:72,74:95,134,135,136,140],'M1220',[104],104,[96:103,105:127,137,138,139,140]);
% RefSubtraction_multi('amplifier.dat',71,2,'M1217',[8],8,[0:7,9:31,64,65,66,70],'M1218',[40],40,[32:39,41:63,67,68,69,70]);
RefSubtraction_multi('amplifier.dat',71,2,'M1219',[9],9,[0:8,10:31,64,65,66,70],'M1220',[40],40,[32:39,41:63,67,68,69,70]);

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
% SleepScoringOBGamma
SleepScoring_Accelero_OBgamma


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




