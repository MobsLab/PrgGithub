%% Stop Acquisition
% This script stop a acquisition and clear things to properly end it.
%
% by antoine.delhomme@espci.fr

%% Clear things
c = fix(clock);
fprintf('Acquisition stopped at %02d:%02d.\n', [c(4), c(5)]);

% Stop the session
if exist('s', 'var') && ~s.IsDone
    fprintf('\tSession is stopped.\n');
	stop(s);
end

% Delete the listener
if exist('lh', 'var') && isvalid(lh)
    fprintf('\tListener is deleted.\n');
    delete(lh);
end

% Close output files
if exist('fileIDs', 'var') && ~isempty(fileIDs)
    fprintf('\tFiles are closed.\n');
    for fileID = fileIDs
        fclose(fileID);
    end
    fileIDs = [];
end