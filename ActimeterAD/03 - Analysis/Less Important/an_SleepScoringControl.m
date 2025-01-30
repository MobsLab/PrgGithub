% sleepScoringControl
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

acqIDs = [20];
channelIDs = [1:12];

for acqID = acqIDs
    figure, clf,
    
    title(sprintf('Acqusition #%d', acqID));
    hold on;
    for channelID = channelIDs
        % Load data
        a = Activity(acqID, channelID);
        % Update the activity
        %a.activity = [0, 0, 0, a.applyForEachGroup(@GetActivity3, 0)];
        % Compute the sleep scoring
        a.computeSleepScoring();
        
        plot(a.timeStamps_sign, channelID + (a.data - mean(a.data))/4, 'b');
        plot(a.timeStamps_block, channelID + (a.activity/4), 'g');
        plot(a.timeStamps_block, channelID + (a.sleepScoring/4), 'r');
        drawnow;
    end
    hold off;
end