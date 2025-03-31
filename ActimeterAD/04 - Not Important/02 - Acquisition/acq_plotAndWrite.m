function acq_plotAndWrite( src, event, fileIDs, hPlots, sampleRate )
%ACQ_PLOTANDWRITE Function called at each iteration of an acquisition
%   This function may be called at each iteration of an acquisition. It
%   plots data and write them in a file
%
%   by antoine.delhomme@espci.fr

% The dataBuffer will contain last ploted data
persistent dataBuffer

% Define some aliases
% _nbOfFigures_     nb of figures that will be updated
% _blockLength_     data are capture by block, this is the size of a block
% _nbOfBlocks_      nb of blocks to display
nbOfFigures = length(hPlots);
blockLength = length(event.TimeStamps);
nbOfBlocks = 4;
% Define the format in which data will be written
format = '%.4f %.4f\n';

% Init the dataBuffer if necessary
if isempty(dataBuffer)
    dataBuffer = zeros(nbOfBlocks * blockLength, nbOfFigures);
end

for figureID = 1:nbOfFigures
    % Update the dataBuffer
    dataBuffer(1:(end - blockLength), figureID) = dataBuffer((blockLength + 1):end, figureID);
    dataBuffer((end - blockLength + 1):end, figureID) = event.Data(:, figureID);
    
    % Compute the fft
    n = nbOfBlocks * blockLength;
    D = fft(dataBuffer(:, figureID) - mean(dataBuffer(:, figureID)));
    D = abs(D(1:(floor(n/2)+1)));
    % Get the frequency of the main pick and convert it in Hz, this is the
    % breath frequency.
    [~, f] = max(D);
    f = (f - 1)*sampleRate/n;
    
    % Plot data
    set(hPlots(figureID), 'XData', (-(nbOfBlocks-1)*blockLength:blockLength-1)/sampleRate + event.TimeStamps(1));
    set(hPlots(figureID), 'YData', dataBuffer(:, figureID));
    %set(hPlots(figureID), 'Title', sprintf('%f Hz', f));
    drawnow;
    
    % Write data
    fprintf(fileIDs(figureID), format, [event.TimeStamps'; event.Data(:, figureID)']);
end

% Compute correlations
% corr1_2 = corr(event.Data(:, 1), event.Data(:, 2));
% corr1_3 = corr(event.Data(:, 1), event.Data(:, 3));
% corr1_4 = corr(event.Data(:, 1), event.Data(:, 4));
% corr2_3 = corr(event.Data(:, 2), event.Data(:, 3));
% corr2_4 = corr(event.Data(:, 2), event.Data(:, 4));
% corr3_4 = corr(event.Data(:, 3), event.Data(:, 4));
% 
% fprintf('%0.4f\n', corr1_2);
% fprintf('%0.4f %0.4f\n', [corr1_3, corr2_3]);
% fprintf('%0.4f %0.4f %0.4f\n', [corr1_4, corr2_4, corr3_4]);
% fprintf('\n');

end

