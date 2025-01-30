cd ('/media/dataMOBS70/Souris 648-TG108/12122017/VLPO-sleep Baseline day3_171212_093259/')

% get info about intan recording
read_Intan_RHD2000_file

%% Make your .xls file
%% Make your .xml file for LFP amplifier.xml
%% Make your .xml file for spike amplifier_SpikeRef.xml
%% Add your mouse to CallRefFunction_Thierry and CallRefFunctionSpikes_Thierry




% Get all the info you need
GetBasicInfoRecord
GetMouseInfo_Thierry

% call in terminal all the preprocessing codes
ExecuteNDM_Thierry

%% check your files

% create matlab compatible files
SetCurrentSession(NewFolderName)
MakeData_Main_Thierry

  
