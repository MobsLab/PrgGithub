%%% FindPCellParameters

% Two ways:
% 
% - Simple place field contruction and spatial info
% - Cross validated measure

%% Parameters

% Mice in the analysis
% nmouse = [797 798 828 861 882 905 906 911 912 977 994];
nmouse = [797];
% nmouse = [906 912]; % Had PreMazes
% nmouse = [905 911]; % Did not have PreMazes

% Paths retrieved
% Dir = PathForExperimentsERC_Dima('UMazePAG'); 
Dir = PathForExperimentsERC_DimaMAC('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

% Size of the map
mapsize = [35 50 60 75 100 125 150 500 800];

% Smoothing
smo = linspace(1,4,8);

% Threshold on speed (im cm/s, epoch with lower are not considered)
speed_thresh = 2.5;

% How much time do you need to construct place field?
inclThresh = 4*60; % in sec

% Do you want to save a figure?
sav = false;

% Paths and names to save
pathfig = '/MOBS_workingON/Dima/Ongoing_results/PlaceField_Final/Stability/'; % without dropbox path



%% Preallocaion

spikes = cell(1,length(Dir.path));
behav = cell(1,length(Dir.path));

LocomotionEpoch = cell(1,length(Dir.path));
UMazeMovingEpoch = cell(1,length(Dir.path));

spInfo = cell(1,length(Dir.path));
Specificity = cell(1,length(Dir.path));

Lfinal = cell(1,length(Dir.path));
LfSpk = cell(1,length(Dir.path));

%% Main loop

for i=1:length(Dir.path)
    spikes{i} = load([Dir.path{i}{1} 'SpikeData.mat'], 'S');
    behav{i} = load([Dir.path{i}{1} 'behavResources.mat'],'SessionEpoch','CleanVtsd','CleanAlignedXtsd','CleanAlignedYtsd');
    
    % Allocation
    spInfo{i} = nan(length(spikes{i}.S), length(mapsize), length(smo));
    Specificity{i} = nan(length(spikes{i}.S), length(mapsize), length(smo));
    
    Lfinal{i} = nan(length(spikes{i}.S), length(mapsize), length(smo));
    LfSpk{i} = nan(length(spikes{i}.S), length(mapsize), length(smo));
    
    % Get Epochs
    % Locomotion threshold
    LocomotionEpoch{i} = thresholdIntervals(tsd(Range(behav{i}.CleanVtsd),movmedian(Data(behav{i}.CleanVtsd),5)),speed_thresh,'Direction','Above'); % smoothing = 5
    
    % Get resulting epochs
    UMazeMovingEpoch{i} = and(behav{i}.SessionEpoch.Hab, LocomotionEpoch{i});
    
    if (sum(End(UMazeMovingEpoch{i})- Start(UMazeMovingEpoch{i})))/1e4 >= inclThresh
        
        % Calculate spatial info
        for j=1:length(spikes{i}.S)
            
            if ~isempty(Data(Restrict(spikes{i}.S{j}, UMazeMovingEpoch{i})))
                
                for ms = 1:length(mapsize)
                    
                    for ss = 1:length(smo)
                        
                        [Lfinal{i}(j,ms,ss),LfSpk{i}(j,ms,ss)] = PlaceCellCrossValidation(Restrict(spikes{i}.S{j}, UMazeMovingEpoch{i}),...
                            Restrict(behav{i}.CleanAlignedXtsd, UMazeMovingEpoch{i}), Restrict(behav{i}.CleanAlignedYtsd, UMazeMovingEpoch{i}),...
                             'SizeMap', mapsize(ms), 'Smoothing', smo(ss), 'Verbose', false);
                        
%                         [~, ~, stats, ~, ~, FR]=PlaceField_DB(Restrict(spikes{i}.S{j}, UMazeMovingEpoch{i}),...
%                             Restrict(behav{i}.CleanAlignedXtsd, UMazeMovingEpoch{i}), Restrict(behav{i}.CleanAlignedYtsd, UMazeMovingEpoch{i}),...
%                             'SizeMap', mapsize(ms), 'Smoothing', smo(ss), 'LargeMatrix', false, 'PlotResults', 0, 'PlotPoisson', 0);
%                         
%                         if ~isempty(stats.spatialInfo) && ~isempty(FR) && FR > 0.25
%                             spInfo{i}(j,ms,ss) = stats.spatialInfo;
%                             Specificity{i}(j,ms,ss) = stats.specificity;
%                         end
%                         
%                         clear stats FR

                        
                    end
                    
                end
                
            end
            
        end
        
    end
end

%% Treat the arrays
