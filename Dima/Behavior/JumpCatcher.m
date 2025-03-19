%%% JumpCatcher - catches and plot the amplitudes of jumps 
%
% This function looks for the positive extremum in the accelerometer
% reponse, triggered on stimulation. In other words, it catches the
% amplitude of the stimulation induced jump.
% There is a version that works with old data where behavioral resources are not
% concatenated. New version - CondOldJumpCatcher.m
%
% 04.10.2018 Dima Bryzgalov
%
% Calculate the amplitude of a jump
%
% function CondJumpCatcher(mice,tSmall, saveresults, varargin)
%
% INPUT:
% - mice                           - vector with numbers of mice. It will be searched in PathForExperimentsERC_Dima.m
% - ExPhase                        - which experimental phase do you want to find jumps into ('Calib', 'Cond', etc)?
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

function JumpCatcher(mice, ExPhase, artS, saveresults, varargin)
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
   mice = 797;
end

try
   ExPhase;
catch
   ExPhase = 'Calib';
end

try
   artS;
catch
   artS = 1;
end

try
   saveresults;
catch
   saveresults = 1; 
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
Dir = PathForExperimentsERC_Dima(ExPhase);
Dir = RestrictPathForExperiment(Dir,'nMice', mice);

for k = 1:length(Dir.path)
    for j = 1:length(Dir.path{k})
    
        %% Get data
        Acc{k}{j} = load([Dir.path{k}{j} '/behavResources.mat'],'MovAcctsd', 'TTLInfo');

        %% Prepare data
        % Accelero
        MovAcctsd{k}{j} = Acc{k}{j}.MovAcctsd;
        % Stimulations
        StimEpoch{k}{j} = Acc{k}{j}.TTLInfo.StimEpoch;

        %% Trigger accelerometer on stimulations

        % Epochs
        BigEpoch{k}{j} = intervalSet((Start(StimEpoch{k}{j})-artB*1E4), End(StimEpoch{k}{j})+artB*1E4);
        SmallEpoch{k}{j} = intervalSet((Start(StimEpoch{k}{j})-artS*1E4), End(StimEpoch{k}{j})+artS*1E4);

        A{k}{j} = 500; % No reason - it works
        for i=1:length(Start(BigEpoch{k}{j}))
            try
                AccBigData{k}{j}(i, 1:A{k}{j}) = Data(Restrict(MovAcctsd{k}{j}, subset(BigEpoch{k}{j},i)));
                delme1 = runmean(AccBigData{k}{j}(i, A{k}{j}/2+1:end),sm);
                delme2 = runmean(AccBigData{k}{j}(i, 1:A{k}{j}/2),sm);
                AccBigData{k}{j}(i,1:A{k}{j}) = [delme2 delme1];
            catch
                rmme = Data(Restrict(MovAcctsd{k}{j}, subset(BigEpoch{k}{j},i)));
                AccBigData{k}{j}(i, 1:A{k}{j}) = rmme(1:end-1);
                delme1 = runmean(AccBigData{k}{j}(i, A{k}{j}/2+1:end),sm);
                delme2 = runmean(AccBigData{k}{j}(i, 1:A{k}{j}/2),sm);
                AccBigData{k}{j}(i,1:A{k}{j}) = [delme2 delme1];
            end
        end
        lBig{k}{j} = A{k}{j};

        % Average Big
        AccBigDataMean{k}{j} = mean(AccBigData{k}{j},1);
        AccBigDataSTD{k}{j} = std(AccBigData{k}{j},1);

        A{k}{j} = 100; % No reason - it works
        for i=1:length(Start(SmallEpoch{k}{j}))
            try
                AccSmallData{k}{j}(i, 1:A{k}{j}) = Data(Restrict(MovAcctsd{k}{j}, subset(SmallEpoch{k}{j},i)));
                delme1 = runmean(AccSmallData{k}{j}(i, A{k}{j}/2+1:end),sm);
                delme2 = runmean(AccSmallData{k}{j}(i, 1:A{k}{j}/2),sm);
                AccSmallData{k}{j}(i,1:A{k}{j}) = [delme2 delme1];
            catch
                rmme = Data(Restrict(MovAcctsd{k}{j}, subset(SmallEpoch{k}{j},i)));
                AccSmallData{k}{j}(i, 1:A{k}{j}) = rmme(1:end-1);
                delme1 = runmean(AccSmallData{k}{j}(i, A{k}{j}/2+1:end),sm);
                delme2 = runmean(AccSmallData{k}{j}(i, 1:A{k}{j}/2),sm);
                AccSmallData{k}{j}(i,1:A{k}{j}) = [delme2 delme1];
            end
        end
        lSmall{k}{j} = A{k}{j};

        % Average Small
        AccSmallDataMean{k}{j} = mean(AccSmallData{k}{j},1);
        AccSmallDataSTD{k}{j} = std(AccSmallData{k}{j},1);

        clear rmme delme1 delme2

        %% Get time
        % BigEpoch
        [rBig{k}{j},iBig{k}{j}] = Sync(Range(MovAcctsd{k}{j})/1e4,Start(StimEpoch{k}{j})/1e4,'durations',[-artB artB]);
        [m,tBig{k}{j}] = SyncMap(rBig{k}{j},iBig{k}{j},'durations', [-artB artB], 'nBins', lBig{k}{j});
        % Small Epoch
        [rSmall{k}{j},iSmall{k}{j}] = Sync(Range(MovAcctsd{k}{j})/1e4,Start(StimEpoch{k}{j})/1e4,'durations',[-artS artS]);
        [m,tSmall{k}{j}] = SyncMap(rSmall{k}{j},iSmall{k}{j},'durations', [-artS artS], 'nBins', lSmall{k}{j});
        
        %% Find the maximum after and before the stimulation
        ID_TimeMoreZeroBig{k}{j} = find(tBig{k}{j}>0, 1,'first');
        ID_TimeLessZeroBig{k}{j} = find(tBig{k}{j}<0, 1,'last');
        MBigAfter{k}{j} = max(AccBigDataMean{k}{j}(ID_TimeMoreZeroBig{k}{j}:end)); % Find max after stimulation
        MBigBefore{k}{j} = max(AccBigDataMean{k}{j}(1:ID_TimeLessZeroBig{k}{j})); % Find max before stimulation
        ind_maxBigAfter{k}{j} = find(AccBigDataMean{k}{j}==MBigAfter{k}{j});
        ind_maxBigBefore{k}{j} = find(AccBigDataMean{k}{j}==MBigBefore{k}{j});
    

        ID_TimeMoreZeroSmall{k}{j} = find(tSmall{k}{j}>0, 1,'first');
        ID_TimeLessZeroSmall{k}{j} = find(tSmall{k}{j}<0, 1,'last');
        MSmallAfter{k}{j} = max(AccSmallDataMean{k}{j}(ID_TimeMoreZeroSmall{k}{j}:end)); % Find max after stimulation
        MSmallBefore{k}{j} = max(AccSmallDataMean{k}{j}(1:ID_TimeLessZeroSmall{k}{j})); % Find max before stimulation
        ind_maxSmallAfter{k}{j} = find(AccSmallDataMean{k}{j}==MSmallAfter{k}{j});
        ind_maxSmallBefore{k}{j} = find(AccSmallDataMean{k}{j}==MSmallBefore{k}{j});
        
        AccRatio{k}{j} = MSmallAfter{k}{j}/MSmallBefore{k}{j};
        
        disp(['StartleIndex = ' num2str(AccRatio{k}{j})]);
        
        
        %% Plot
        if ploto
            fb{k}{j} = figure('units','normalized', 'outerposition',[0 0 1 0.6]);
            subplot(121)
            shadedErrorBar(tBig{k}{j}, AccBigDataMean{k}{j}, AccBigDataSTD{k}{j}, 'k', 1);
            hold on
            plot(tBig{k}{j}(ind_maxBigAfter{k}{j}), AccBigDataMean{k}{j}(ind_maxBigAfter{k}{j}), 'r*', 'MarkerSize', 16);
            hold on
            plot(tBig{k}{j}(ind_maxBigBefore{k}{j}), AccBigDataMean{k}{j}(ind_maxBigBefore{k}{j}), 'b*', 'MarkerSize', 16);
            ylabel('Amplitude of accelerometer');
            xlabel('Time in sec');
            set(gca, 'FontSize',13);
            line([0 0],ylim,'color','r', 'LineWidth', 3)
            
            subplot(122)
            shadedErrorBar(tSmall{k}{j}, AccSmallDataMean{k}{j}, AccSmallDataSTD{k}{j}, 'k', 1);
            hold on
            plot(tSmall{k}{j}(ind_maxSmallAfter{k}{j}), AccSmallDataMean{k}{j}(ind_maxSmallAfter{k}{j}), 'r*',  'MarkerSize', 16);
            hold on
            plot(tSmall{k}{j}(ind_maxSmallBefore{k}{j}), AccSmallDataMean{k}{j}(ind_maxSmallBefore{k}{j}), 'b*',  'MarkerSize', 16);
            set(gca,'YTickLabel',[]);
            xlabel('Time in sec');
            set(gca, 'FontSize',13);
            line([0 0],ylim,'color','r', 'LineWidth', 3)
            
            %% Supertitle
            templ1 = 'Mouse';
            templ2 = '.5V';
            templ3 = 'V';
            ind1 = strfind(Dir.path{k}{j}, templ1);
            ind2 = strfind(Dir.path{k}{j}, templ2);
            ind3 = strfind(Dir.path{k}{j}, templ3);
            if ~isempty(ind2)
                mtit(fb{k}{j}, [Dir.path{k}{j}(ind1:ind1+8) ' Calib-' Dir.path{k}{j}(ind2-1:ind2+2)], 'fontsize',14);
            else
                mtit(fb{k}{j}, [Dir.path{k}{j}(ind1:ind1+8) ' Calib-' Dir.path{k}{j}(ind3-3:ind3)], 'fontsize',14);
            end
            
            %%
            if savefig
                saveas(fb{k}{j}, [Dir.path{k}{j} 'AccTrigStim.fig']);
                saveFigure(fb{k}{j},'AccTriggStim',Dir.path{k}{j});
            end
        end
        
        %% Save
        if saveresults
            StartleStimMaxAmp = MSmallAfter{k}{j};
            BeforeStartleMaxAmp = MSmallBefore{k}{j};
            StartleIndex = AccRatio{k}{j};
            if exist([Dir.path{k}{j} 'behavResources.mat']) == 2
                save([Dir.path{k}{j} 'behavResources.mat'], 'StartleStimMaxAmp', 'BeforeStartleMaxAmp', 'StartleIndex', '-append');
            else
                save([Dir.path{k}{j} 'behavResources.mat'], 'StartleStimMaxAmp', 'BeforeStartleMaxAmp', 'StartleIndex');
            end
        end
        
        
    end
end

end