cd ('/media/mobsmorty/dataMOBS70/Souris 648-TG108/29112017/VLPO-sleep Baseline day3_171212_093259/')

% get info about intan recording
read_Intan_RHD2000_file

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

GetBasicInfoRecord
GetMouseInfo_Thierry
% change the info in CallRefFunction_Thierry
%%if ExpeInfo.nmouse==648
%%RefSubtraction_multi('amplifier.dat',16,1,'M648',0:15,4,[]);
% elseif ExpeInfo.nmouse==649
%     RefSubtraction_multi('amplifier.dat',16,1,'M649',0:15,7,[]);
% etc...

% call in terminal all the preprocessing codes
ExecuteNDM_Thierry

%% check your files
SetCurrentSession
% create matlab compatible files
%% dans terminal
%%KlustaKwiknew M648_12122017_BaselineSleep_SpikeRef 1    
MakeData_Main_Thierry

%% sleep scoring
SleepScoringOBGamma

%% Low Spectrums
Faire_les_Low_Spectrum

%% Figures(in dvpt)
    %A lancer directement
Nb_Start_Mid_End_Stim_dans_REM
FiguresID_V1
[Ordered_REM] = Ordered_REM_Julien()
Figure_AverageSpectrum_avec_Theta_et_ratioThetaDelta
%Figures_AverageSpectrums_EndStim
%Figures_AverageSpectrums_MidStim
%Panel_HPC_REM_differents_temps_StartStim

%Figures_Bandes_StimvsBaseline


%%%%%%%%%Parcours Figures mémoire 
%%%stim dans les 30s au debut du REM
[MatTotal,MatCellArray,timeREM,vectTotal,vect,tps2]=ParcoursTransitionSleepOpto 

[MatTotalB,MatCellArrayB,timeREMB,vectTotalB,vectB,tpsB]=ParcoursTransitionSleepBaseline

%%% toutes les tim dans le REM
[MatTotal,MatCellArray,timeREM,vectTotal,vect,tps2]=ParcoursTransitionSleepOptoV2AllStim

[MatTotal,MatCellArray,timeREM,vectTotalB,vect,tps2]=ParcoursTransitionSleepBaselineSimulatedV2AllStim