% This code is the first code of Heloise
% 
% It will compare the average heart rate during calibration day
%

%% Get the data

% Get all paths
Dir = PathForExperiment_Heloise('CalibPAG');

% Load the data
for i=1:length(Dir.path)
    HR{i} = load([Dir.path{i}{1} 'HeartBeatInfo.mat']);
    stiminfo{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'StimEpoch','SessionEpoch');
    
    %Load SleepScoring based on OB or on Accelero
    if exist ('SleepScoring_OBGamma.mat')
        sleep{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'SWSEpoch','REMEpoch','Wake','Sleep');
    else
        sleep{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'SWSEpoch','REMEpoch','Wake','Sleep');
    end
end
    
%% Prepare arrays for calculations

% Split WakeEpoch in two
for i=1:length(Dir.path)
    % Wake time in the home cage
    TotalHomeTimeEpoch{i} = or(stiminfo{i}.SessionEpoch.PreSleep,stiminfo{i}.SessionEpoch.PostSleep);
    WakeHomeEpoch{i} = and(sleep{i}.Wake,TotalHomeTimeEpoch{i});
    
    % Wake time in the calibration open field
    % Exclude Pre- and Post-Sleeps
    fnames = fieldnames(stiminfo{i}.SessionEpoch);
    id_del = zeros(1,length(fnames));
    for j = 1:length(fnames)
        if strcmp(fnames{j},'PreSleep')
            id_del(j) = j;
        elseif strcmp(fnames{j},'PostSleep')
            id_del(j) = j;
        end
    end
    id_del = nonzeros(id_del);
    
    fnames(id_del) = [];
    
    % Concatenate all calibration epochs
    CalibEpoch{i} = stiminfo{i}.SessionEpoch.(fnames{1});
    for j = 2:length(fnames)
        CalibEpoch{i} = or(CalibEpoch{i},stiminfo{i}.SessionEpoch.(fnames{j}));
    end
    % Create Wake Epoch during calibrations
    CalibWakeEpoch{i} = and(CalibEpoch{i},sleep{i}.Wake);
    % Create 10s-long StimEpoch
    StimEpochExt{i} = intervalSet(Start(stiminfo{i}.StimEpoch),Start(stiminfo{i}.StimEpoch)+10e4);
    % Create WakeEpoch during calibrations without stimulations
    CalibWakeNOStimEpoch{i} = CalibWakeEpoch{i} - StimEpochExt{i};
    
end

for i=1:length(Dir.path)
    NREMSleep_HR{i} = Restrict(HR{i}.EKG.HBRate,sleep{i}.SWSEpoch);
    REMSleep_HR{i} = Restrict(HR{i}.EKG.HBRate,sleep{i}.REMEpoch);
    WakeHome_HR{i} = Restrict(HR{i}.EKG.HBRate,WakeHomeEpoch{i});
    WakeCalib_HR{i} = Restrict(HR{i}.EKG.HBRate,CalibWakeNOStimEpoch{i});
end

%% Do Calculations

for i=1:length(Dir.path)
    NREMSleep_i(i) = mean(Data(NREMSleep_HR{i}));
    REMSleep_i(i) = mean(Data(REMSleep_HR{i}));
    WakeHome_i(i) = mean(Data(WakeHome_HR{i}));
    WakeCalib_i(i) = mean(Data(WakeCalib_HR{i}));
end

%% Separate PreSleep and PostSleep
for i=1:length(Dir.path)
    PreSleep{i} = (stiminfo{i}.SessionEpoch);
    for k = 1:length(fnames)
        if strcmp(fnames{k},'PreSleep')
            PreSleep(k) = x;
        elseif strcmp(fnames{k},'PostSleep')
            PostSleep(k) = y;
        end
    end 
 for i=1:length(Dir.path)
     PreSleep_HR{i} = Restrict(HR{i}.EKG.HBRate,x);
     PostSleep_HR{i} = Restrict(HR{i}.EKG.HBRate,y);
     PreSleep_i(i) = mean(Data(PreSleep_HR{i}));
     PostSleep_i(i) = mean(Data(PostSleep_HR{i}));
 end
end 
    

%% See the dynamic of Hear Rate (HR) 10 seconds after stimulation
for i=1:length(Dir.path)
    st{i} = Start(stiminfo{i}.SessionEpoch);
    %Add -10s and +10s to the start and restrict HR to that Epoch
    for k = 1:length(fnames)
    NewIS = intervalSet(st-10*1e4, st+10*1e4);
    NewHR = Restrict(HR,NewIS)
    end
end
    
    
%% Plotting
bar, plot, plotErrorBarN_DB
    
