clear all
ParamBinNumber = 6;
TempBinSize = [0.2,1];

%% Get all tuning for PFC
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/PFCTuningByVarAndPeriod';
mkdir(SaveFolder)
Variables = {'HR','BR','speed','position'};
Periods = {'Freezing','All','Sleep','Wake','Wake_Explo','Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze','All_Home'};

for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['PFC_', Variables{vv}, Periods{pp}])
            PFC_InteroceptiveTuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

% Only do position on UMaze
Variables = {'position'};
Periods = {'Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['PFC_', Variables{vv}, Periods{pp}])
            PFC_InteroceptiveTuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

clear all
ParamBinNumber = 6;
TempBinSize = [0.2,1];
%% Get all tuning for HPC

SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/HPCTuningByVarAndPeriod';
Variables = {'HR','BR','speed'};
Periods = {'Freezing','All','Sleep','Wake','Wake_Explo','Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze','All_Home'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['HPC_', Variables{vv}, Periods{pp}])
            HPC_TuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

% Only do position on UMaze
Variables = {'position'};
Periods = {'Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['HPC_', Variables{vv}, Periods{pp}])
            HPC_TuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end


%% Smaller binsizes for parameter
clear all
ParamBinNumber = 20;
TempBinSize = [0.2,1];

%% Get all tuning for PFC
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/PFCTuningByVarAndPeriod';
Variables = {'HR','BR','speed','position'};
Periods = {'Freezing','All','Sleep','Wake','Wake_Explo','Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze','All_Home'};

for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['PFC_', Variables{vv}, Periods{pp}])
            PFC_InteroceptiveTuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

% Only do position on UMaze
Variables = {'position'};
Periods = {'Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['PFC_', Variables{vv}, Periods{pp}])
            PFC_InteroceptiveTuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

clear all
ParamBinNumber = 20;
TempBinSize = [0.2,1];
%% Get all tuning for HPC

SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/HPCTuningByVarAndPeriod';
Variables = {'HR','BR','speed'};
Periods = {'Freezing','All','Sleep','Wake','Wake_Explo','Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze','All_Home'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['HPC_', Variables{vv}, Periods{pp}])
            HPC_TuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end

% Only do position on UMaze
Variables = {'position'};
Periods = {'Habituation','Conditionning',...
    'Conditionning_NoFreeze','Habituation_NoFreeze','Umaze_NoFreeze'};
for tt = 1:length(TempBinSize)
    for vv = 1:length(Variables)
        for pp = 1:length(Periods)
            disp(['HPC_', Variables{vv}, Periods{pp}])
            HPC_TuningCurves_ByState_V3(Variables{vv}, Periods{pp},ParamBinNumber,TempBinSize(tt),SaveFolder);
        end
    end
end
