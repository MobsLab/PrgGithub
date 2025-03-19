%% Simple Analysis
% This script performs a simple analysis of data.
%
% by antoine.delhomme@espci.fr

%% Parameters
% Data parameters
% _dataDir_ : name of the dir in which data are saved
dataDir = 'C:\Users\Karim\Documents\Antoine\04 - Data\';
acqID = 3;

%% Load data files
% List files that correspond to acqID
d = dir(sprintf('%sacq_%04d*.dat', acqID));

% fileIDs will contain the IF of each opened files
fileIDs = [];

for channel = channels
    % For each channel, prepare an output file
    outFileName = sprintf('act_%04d#%d.dat', [str2double(d(end).name(5:8)) + 1, channel]);
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