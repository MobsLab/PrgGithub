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



  
