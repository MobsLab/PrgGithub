%% Simple Acquisition
% This script performs an activity acquisition through a NI-DAQ. It was
% designed to gather data in order to build an algorithm to distinguish
% wake epoch from sleep epoch.
%
% by antoine.delhomme@espci.fr

%% Parameters
% Data parameters
% _dataDir_ : name of the dir in which data are saved
dataDir = 'C:\Users\MOBSmembers\Documents\AntoineDelhomme\AntoineDelhomme\Data\';
addpath(genpath('C:\Users\MOBSmembers\Documents\AntoineDelhomme\AntoineDelhomme\File Antoine\03 - Code\02 - Acquisition'))
% Acquisition parameters
% _channels_        channels to acquire
% _sampleRate_      number of samples by second
% _displayRate_     every displayRate, the display is updated (in s)
channels = 1:8;
sampleRate = 100;
displayRate = 3; % display data every n seconds

%% Init data files
% Get the new file data id
d = dir(strcat(dataDir, '*.dat'));
outFileNameID = str2double(d(end).name(5:8)) + 1;

% fileIDs will contain the IF of each opened files
fileIDs = [];
cd(dataDir)
for channel = channels
    % For each channel, prepare an output file
    outFileName = sprintf('act_%04d#%d.dat', [outFileNameID, channel]);
    outFile = strcat(dataDir, outFileName);

    % Verify that no data will be overiden.
    if exist(outFile, 'file') == 2
        % This file already exists.
        % Close previously opened files ...
        for fileID = fileIDs
            fclose(fileID);
        end
        % ... and raise an error.
        error('simple_acquisition:IOError', 'The output file already exists. (%s)', outFileName);
    else
        fileIDs = [ fileIDs, fopen(outFile, 'wt') ];
    end

    if fileIDs(end) < 0
        % This file cannot be opend properly.
        % Close previously opened files ...
        for fileID = fileIDs
            fclose(fileID);
        end
        % ... and raise an error.
        error('simple_acquisition:IOError', 'The output file cannot be opened. (%s)', outFileName);
    end
end


%% Init the plot figure
figure(1); clf;
nbOfFig_x = 4;
nbOfFig_y = 2;
% hPlots will stock a handler for each plot
hPlots = [];
for figureID = 1:length(channels)
    subplot(nbOfFig_y, nbOfFig_x, figureID);
    hPlots = [hPlots, plot(NaN)];
    title(sprintf('Channel #%d', channels(figureID)));
    xlabel('time (s)');
    ylabel('signal (ua)');
    ylim([1.5 3.5]);
    %xlim([1, 4 * displayRate * sampleRate]);
end

%% Init the session for the National Instrument device
% Create the session
s = daq.createSession('ni');

% Add inputs
ch = addAnalogInputChannel(s, 'Dev1', channels-1, 'Voltage');
for i =1:8
    ch(i).TerminalConfig = 'SingleEnded';
end
% Set the session rate and duration of acquisition
% If the acquisition has to be time limited, use
%   s.DurationInSeconds = 3;
% else, use
%   s.IsContinuous = true;
% To stop an acquisition in continuous mode, use
%   stop(s);
%   delete(lh);
s.Rate = sampleRate;
s.IsContinuous = true;

% Set the notify rate
s.NotifyWhenDataAvailableExceeds = displayRate * sampleRate;

% Add a listener to the DataAvailable event to plot the data
lh = addlistener(s, 'DataAvailable', ...
    @(src, event) acq_plotAndWrite(src, event, fileIDs, hPlots, sampleRate));

%% Start the acquisition
% To end the acquisition, call stop_acquisition().
c = fix(clock);
fprintf('Acquisition launched at %02d:%02d.\n', [c(4), c(5)]);
fprintf('\tData saved in %s.\n', outFile);
startBackground(s);