%%% CondOldJumpCatcher - catches and plot the amplitudes of jumps 
%
% This function looks for the positive extremum in the accelerometer
% reponse, triggered on stimulation. In other words, it catches the
% amplitude of the stimulation induced jump.
% This version works with old data where behavioral resources are not
% concatenated. New version - JumpCatcher.m
%
% 04.10.2018 Dima
%
%
% function CondJumpCatcher(mice,artS, saveresults, varargin)
%
% INPUT:
% - mice                           - vector with numbers of mice. It will be searched in PathForExperimentsERC_Dima.m
% - artS                           - time around the small stimulation epoch (in s)
% - saveresults                    - save extremi or not (0 or 1)
% - tBig (optional)                - time around the big stimulation epoch (in s) - used just for plotting (default = 5)
% - Smoothing (optional)           - Smoothing factor for accelerometer (default = 5)
% - PlotFig (optional)             - Do you want to plot a figure (0 - no, 1 - yes) (default = 1)
% - SaveFig (optional)             - Do you want to save a figure (0 - no, 1 - yes) (default = 0)
%
% OUTPUT:
% - extremi in behavResources.mat 
% - plot showing the triggered accelerometer response (optional)
%
%
%   see also JumpCatcher
%       
%

function CondOldJumpCatcher(mice,artS, saveresults, varargin)
%% CHECK INPUTS

if nargin < 3 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'tbig'
            artB = varargin{i+1};
            if ~isa(artB,'numeric') && artB <= 0
                error('Wrong value for the big epoch limits');
            end
        case 'smoothing'
            sm = varargin{i+1};
            if ~isa(sm,'numeric') && sm <= 1
                error('Wrong value for smoothing factor');
            end
        case 'plotfig'
            ploto = varargin{i+1};
            if ploto ~= 0 && ploto ~=1
                error('Wrong value for PlotFig');
            end
        case 'savefig'
            savefig = varargin{i+1};
            if savefig ~= 0 && savefig ~=1
                error('Wrong value for SaveFig');
            end 
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%% Parameters (default)
try
   mice;
catch
   mice = 711;
end

try
   artS;
catch
   artS = 1.5;
end

try
   saveresults;
catch
   saveresults = 0; 
end

try
   artB;
catch
   artB = 5; 
end

try
   sm;
catch
   sm = 5; 
end

try
   ploto;
catch
   ploto = 1; 
end

try
   savefig;
catch
   savefig = 1; 
end

%% Get directories
Dir = PathForExperimentsERC_Dima('Cond');
Dir = RestrictPathForExperiment(Dir,'nMice', mice);

for k = 1:length(Dir.path)
    %% Get data
    for i=1:length(Dir.path{k})
        Acc{k}{i} = load([Dir.path{k}{i} '/behavResources.mat'],'MovAcctsd', 'TTLInfo');
    end

    %% Concatenate data
    for i=1:length(Dir.path{k})
        LFPTime{k}{i} = Range(Acc{k}{i}.MovAcctsd);
        LFPduration{k}(i) = LFPTime{k}{i}(end)-LFPTime{k}{i}(1);
        LFPoffset{k}(i) = LFPTime{k}{i}(1);
    end

    % MovAcctsd
    for i=1:length(Dir.path{k})
        AccTimeTemp{k}{i} = Range(Acc{k}{i}.MovAcctsd);
        AccDataTemp{k}{i} = Data(Acc{k}{i}.MovAcctsd);
    end
    for i = 1:(length(Dir.path{k})-1)
        AccTimeTemp{k}{i+1} = AccTimeTemp{k}{i+1}+sum(LFPduration{k}(1:i)+LFPoffset{k}(i+1));
    end
    AccTime{k} = AccTimeTemp{k}{1};
    for i = 2:length(Dir.path{k})
        AccTime{k} = [AccTime{k}; AccTimeTemp{k}{i}];
    end

    AccData{k} = AccDataTemp{k}{1};
    for i = 2:length(Dir.path{k})
        AccData{k} = [AccData{k}; AccDataTemp{k}{i}];
    end
    % Conctenated MovAcctsd
    MovAcctsd{k} = tsd(AccTime{k}, AccData{k});

    % Stimulations
    for i = 1:length(Dir.path{k})
        StartStimTemp{k}{i} = Start(Acc{k}{i}.TTLInfo.StimEpoch);
        EndStimTemp{k}{i} = End(Acc{k}{i}.TTLInfo.StimEpoch);
    end
    for i = 1:(length(Dir.path{k})-1)
        StartStimTemp{k}{i+1} = StartStimTemp{k}{i+1} + sum(LFPduration{k}(1:i)) + LFPoffset{k}(i+1);
        EndStimTemp{k}{i+1} = EndStimTemp{k}{i+1} + sum(LFPduration{k}(1:i)) + LFPoffset{k}(i+1);
    end
    StartStim{k} = StartStimTemp{k}{1};
    EndStim{k} = EndStimTemp{k}{1};
    for i = 2:length(Dir.path{k})
        StartStim{k} = [StartStim{k}; StartStimTemp{k}{i}];
        EndStim{k} = [EndStim{k}; EndStimTemp{k}{i}];
    end
    % Concteanated stimulations
    StimEpoch{k} = intervalSet(StartStim{k}, EndStim{k});
    last{k} = i;

    %% Trigger accelerometer on stimulations

    % Epochs
    BigEpoch{k} = intervalSet((Start(StimEpoch{k})-artB*1E4), End(StimEpoch{k})+artB*1E4);
    SmallEpoch{k} = intervalSet((Start(StimEpoch{k})-artS*1E4), End(StimEpoch{k})+artS*1E4);

    A{k} = 500; % No reason - it works
    for i=1:length(Start(BigEpoch{k}))
        try
            AccBigData{k}(i, 1:A{k}) = Data(Restrict(MovAcctsd{k}, subset(BigEpoch{k},i)));
            delme1 = runmean(AccBigData{k}(i, A{k}/2+1:end),sm);
            delme2 = runmean(AccBigData{k}(i, 1:A{k}/2),sm);
            AccBigData{k}(i,1:A{k}) = [delme2 delme1];
        catch
            rmme = Data(Restrict(MovAcctsd{k}, subset(BigEpoch{k},i)));
            AccBigData{k}(i, 1:A{k}) = rmme(1:end-1);
            delme1 = runmean(AccBigData{k}(i, A{k}/2+1:end),sm);
            delme2 = runmean(AccBigData{k}(i, 1:A{k}/2),sm);
            AccBigData{k}(i,1:A{k}) = [delme2 delme1];
        end
    end
    lBig{k} = A{k};

    % Average Big
    AccBigDataMean{k} = mean(AccBigData{k},1);

    A{k} = 100; % No reason - it works
    for i=1:length(Start(SmallEpoch{k}))
        try
            AccSmallData{k}(i, 1:A{k}) = Data(Restrict(MovAcctsd{k}, subset(SmallEpoch{k},i)));
            delme1 = runmean(AccSmallData{k}(i, A{k}/2+1:end),sm);
            delme2 = runmean(AccSmallData{k}(i, 1:A{k}/2),sm);
            AccSmallData{k}(i,1:A{k}) = [delme2 delme1];
        catch
            rmme = Data(Restrict(MovAcctsd{k}, subset(SmallEpoch{k},i)));
            AccSmallData{k}(i, 1:A{k}) = rmme(1:end-1);
            delme1 = runmean(AccSmallData{k}(i, A{k}/2+1:end),sm);
            delme2 = runmean(AccSmallData{k}(i, 1:A{k}/2),sm);
            AccSmallData{k}(i,1:A{k}) = [delme2 delme1];
        end
    end
    lSmall{k} = A{k};

    % Average Small
    AccSmallDataMean{k} = mean(AccSmallData{k},1);
    AccSmallDatastd{k} = std(AccSmallData{k},1);

    clear rmme delme1 delme2

    %% Get time
    % BigEpoch
    [rBig{k},iBig{k}] = Sync(Range(MovAcctsd{k})/1e4,Start(StimEpoch{k})/1e4,'durations',[-artB artB]);
    [m,tBig{k}] = SyncMap(rBig{k},iBig{k},'durations', [-artB artB], 'nBins', lBig{k});
    % Small Epoch
    [rSmall{k},iSmall{k}] = Sync(Range(MovAcctsd{k})/1e4,Start(StimEpoch{k})/1e4,'durations',[-artS artS]);
    [m,tSmall{k}] = SyncMap(rSmall{k},iSmall{k},'durations', [-artS artS], 'nBins', lSmall{k});

    %% Find the maximum after and before the stimulation
    ID_TimeMoreZeroBig{k} = find(tBig{k}>0, 1,'first');
    ID_TimeLessZeroBig{k} = find(tBig{k}<0, 1,'last');
    MBigAfter{k} = max(AccBigDataMean{k}(ID_TimeMoreZeroBig{k}:end)); % Find max after stimulation
    MBigBefore{k} = max(AccBigDataMean{k}(1:ID_TimeLessZeroBig{k})); % Find max before stimulation
    ind_maxBigAfter{k} = find(AccBigDataMean{k}==MBigAfter{k});
    ind_maxBigBefore{k} = find(AccBigDataMean{k}==MBigBefore{k});
    

    ID_TimeMoreZeroSmall{k} = find(tSmall{k}>0, 1,'first');
    ID_TimeLessZeroSmall{k} = find(tSmall{k}<0, 1,'last');
    MSmallAfter{k} = max(AccSmallDataMean{k}(ID_TimeMoreZeroSmall{k}:end)); % Find max after stimulation
    MSmallBefore{k} = max(AccSmallDataMean{k}(1:ID_TimeLessZeroSmall{k})); % Find max before stimulation
    ind_maxSmallAfter{k} = find(AccSmallDataMean{k}==MSmallAfter{k});
    ind_maxSmallBefore{k} = find(AccSmallDataMean{k}==MSmallBefore{k});
    
    AccRatio{k} = MSmallAfter{k}/MSmallBefore{k};
    
    disp(['StartleIndex = ' num2str(AccRatio{k})]);

    %% Plot
    if ploto
        fb{k} = figure('units','normalized', 'outerposition',[0 0 1 0.6]);
        subplot(121)
        plot(tBig{k}, AccBigDataMean{k}, 'k', 'LineWidth', 2);
        hold on
        plot(tBig{k}(ind_maxBig{k}), AccBigDataMean{k}(ind_maxBig{k}), 'r*', 'MarkerSize', 16);
        ylabel('Amplitude of accelerometer');
        xlabel('Time in sec');
        set(gca, 'FontSize',13);
        line([0 0],ylim,'color','r', 'LineWidth', 3)

        subplot(122)
        plot(tSmall{k}, AccSmallDataMean{k}, 'k', 'LineWidth', 2);
        hold on
        plot(tSmall{k}(ind_maxSmallAfter{k}), AccSmallDataMean{k}(ind_maxSmallAfter{k}), 'r*',  'MarkerSize', 16);
        hold on
        plot(tSmall{k}(ind_maxSmallBefore{k}), AccSmallDataMean{k}(ind_maxSmallBefore{k}), 'b*',  'MarkerSize', 16);
        ylabel('Amplitude of accelerometer');
        xlabel('Time in sec');
        set(gca, 'FontSize',13);
        line([0 0],ylim,'color','r', 'LineWidth', 3)
        
        mtit(fb{k}, ['Mouse ' num2str(mice(k))], 'fontsize',14);
        
        if savefig
            saveas(fb{k}, [Dir.path{k}{1}(1:end-6) 'AccTrigStim.fig']);
            saveFigure(fb{k},'AccTriggStim',Dir.path{k}{1}(1:end-6));
        end
    end

    %% Save
    if saveresults
        StartleStimMaxAmp = MSmallAfter{k};
        BeforeStartleMaxAmp = MSmallBefore{k};
        StartleIndex = AccRatio{k};
        if exist([Dir.path{k}{1} 'behavResources.mat']) == 2
            save([Dir.path{k}{1} 'behavResources.mat'], 'StartleStimMaxAmp', 'BeforeStartleMaxAmp', 'StartleIndex', '-append');
        else
            save([Dir.path{k}{1} 'behavResources.mat'], 'StartleStimMaxAmp', 'BeforeStartleMaxAmp', 'StartleIndex');
        end
    end


end
end