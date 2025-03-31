function AddMouseToBaselineSleep

% Load ExpeInfo
load('ExpeInfo.mat','ExpeInfo')

if ExpeInfo.SleepSession ==0
    disp('This is not a sleep session!')
    return
else
    
    % Basic info
    Mouse = [ExpeInfo.nmouse];
    Date = {ExpeInfo.date};
    Folder= {cd};

    if isfield(ExpeInfo,'PreProcessingInfo')
        Experimenter = {ExpeInfo.Experimenter};
        
        % Spike info
        Spikes = [ExpeInfo.PreProcessingInfo.DoSpikes];
        SpikeLoc = {};
        if ExpeInfo.PreProcessingInfo.DoSpikes
            for spkgrp = 1:length(ExpeInfo.SpikeGroupInfo.ChanNames)
                Channels_Spikes = str2num(ExpeInfo.SpikeGroupInfo.ChanNames{spkgrp});
                for chan = 1:length(Channels_Spikes)
                    SpikeLoc = [SpikeLoc,ExpeInfo.InfoLFP.structure{Channels_Spikes(chan)+1}];
                end
            end
            
            SpikeRegion = {strjoin( unique(SpikeLoc))};
        end
        
        % Signal quality
        if isfield(ExpeInfo,'TopQualitySignals')
            Ripples = [ExpeInfo.TopQualitySignals.Ripples];
            ThetaInversion = [ExpeInfo.TopQualitySignals.ThetaInversion];
            DeltaWaves = [ExpeInfo.TopQualitySignals.DeltaWaves];
            Spindles = [ExpeInfo.TopQualitySignals.Spindles];
            EMG = [ExpeInfo.TopQualitySignals.EMG];
            EKG = [ExpeInfo.TopQualitySignals.EKG];
            OBgamma = [ExpeInfo.TopQualitySignals.OBgamma];
            OBrespi = [ExpeInfo.TopQualitySignals.OBrespi];
            OBrespiInversion = [ExpeInfo.TopQualitySignals.OBrespi];
        else
            disp('Missing quality info')
            GUITopQualitySignalsCheck
            
            load('ExpeInfo.mat','ExpeInfo')
            Ripples = [ExpeInfo.TopQualitySignals.Ripples];
            ThetaInversion = [ExpeInfo.TopQualitySignals.ThetaInversion];
            DeltaWaves = [ExpeInfo.TopQualitySignals.DeltaWaves];
            Spindles = [ExpeInfo.TopQualitySignals.Spindles];
            EMG = [ExpeInfo.TopQualitySignals.EMG];
            EKG = [ExpeInfo.TopQualitySignals.EKG];
            OBgamma = [ExpeInfo.TopQualitySignals.OBgamma];
            OBrespi = [ExpeInfo.TopQualitySignals.OBrespi];
            OBrespiInversion = [ExpeInfo.TopQualitySignals.OBrespi];
        end
        
    else
        %% Old version of expe info so need to put information by hand
        app = GetMissingExpeInfo_BaselineSleep;
        while isvalid(app), pause(0.1); end
        
        load('ExpeInfo.mat','ExpeInfo')
        Experimenter = {ExpeInfo.Experimenter};

        % Spike info
        Spikes = [ExpeInfo.PreProcessingInfo.DoSpikes];
        SpikeRegion = {ExpeInfo.SpikeRegion};
      
        % Signal quality
        if isfield(ExpeInfo,'TopQualitySignals')
            Ripples = [ExpeInfo.TopQualitySignals.Ripples];
            ThetaInversion = [ExpeInfo.TopQualitySignals.ThetaInversion];
            DeltaWaves = [ExpeInfo.TopQualitySignals.DeltaWaves];
            Spindles = [ExpeInfo.TopQualitySignals.Spindles];
            EMG = [ExpeInfo.TopQualitySignals.EMG];
            EKG = [ExpeInfo.TopQualitySignals.EKG];
            OBgamma = [ExpeInfo.TopQualitySignals.OBgamma];
            OBrespi = [ExpeInfo.TopQualitySignals.OBrespi];
            OBrespiInversion = [ExpeInfo.TopQualitySignals.OBrespi];
        else
            disp('Missing quality info')
            app = GUITopQualitySignalsCheck;
        while isvalid(app), pause(0.1); end

            load('ExpeInfo.mat','ExpeInfo')
            Ripples = [ExpeInfo.TopQualitySignals.Ripples];
            ThetaInversion = [ExpeInfo.TopQualitySignals.ThetaInversion];
            DeltaWaves = [ExpeInfo.TopQualitySignals.DeltaWaves];
            Spindles = [ExpeInfo.TopQualitySignals.Spindles];
            EMG = [ExpeInfo.TopQualitySignals.EMG];
            EKG = [ExpeInfo.TopQualitySignals.EKG];
            OBgamma = [ExpeInfo.TopQualitySignals.OBgamma];
            OBrespi = [ExpeInfo.TopQualitySignals.OBrespi];
            OBrespiInversion = [ExpeInfo.TopQualitySignals.OBrespi];
        end
        
    end
    cd([dropbox filesep 'Kteam'])
    load('AllMice_Sleep.mat')
    Tnew = table(Mouse,Experimenter,Date,Ripples,ThetaInversion,DeltaWaves,...
        Spindles,EMG,EKG,OBgamma,OBrespi,OBrespiInversion,Spikes,SpikeRegion,Folder);
    T = [T;Tnew];
    
    % Write the table to a CSV file and save the table
    currentPath = path;
    restoredefaultpath; rehash toolboxcache
    writetable(T, 'AllMice_Sleep.csv');
    path(currentPath,path);
    save('AllMice_Sleep.mat','T')
    
    % Write to PathForExperiments
    FID = fopen('PathForExperimentsBaselineSleep_MOBS.m','a');
    string1 = [' a=a+1;Dir.path{a}{1}= ''' Folder{1}  ' '' '];
    string2 = 'load([Dir.path{a}{1},''ExpeInfo.mat'']),Dir.ExpeInfo{a}{1}=ExpeInfo;';
    fprintf(FID, '%s', string1);
    fprintf(FID, '%s', newline);
    fprintf(FID, '%s', string2);
    fprintf(FID, '%s', newline);
    fprintf(FID, '%s', newline);
    
end


% %%% Code used to create intial file
% Mouse = [1001];
% Experimenter = {'SB'};
% Date = {'01012025'};
% Ripples = [0];
% ThetaInversion = [0];
% DeltaWaves = [0];
% Spindles = [0];
% EMG = [0];
% EKG = [0];
% OBgamma = [0];
% OBrespi = [0];
% OBrespiInversion = [0];
% Spikes = [0];
% SpikeRegion = {'PFC'};
% Folder= {'SomePlace'};
% 
% T = table(Mouse,Experimenter,Date,Ripples,ThetaInversion,DeltaWaves,...
%     Spindles,EMG,EKG,OBgamma,OBrespi,OBrespiInversion,Spikes,SpikeRegion,Folder);
%  
% % Write the table to a CSV file
% currentPath = path;
% restoredefaultpath; rehash toolboxcache
% writetable(T, 'AllMice_Sleep.csv');
% path(currentPath,path);
% 
% save('AllMice_Sleep.mat','T')
% 
