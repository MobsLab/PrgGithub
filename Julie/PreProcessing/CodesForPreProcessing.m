% CodesForPreProcessing

PreProcessJL


%% create makedataBulbeInputs
GenMakeDataInputs % 


%% create InfoLFP
%read LFP info from xls file and write it into InfoLFP
GenInfoLFPFromSpreadSheet


%% create ChannelsToAnalyse
GenChannelsToAnalyse


SetCurrentSession
MakeData_LFP
MakeData_Accelero
MakeData_RecordingTime