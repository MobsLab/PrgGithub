% 1199
% results = '/media/mobs/DimaERC2/TEST1_Basile/TEST/results/'
% 1161
% results = '/media/mobs/DimaERC2/DataERC2/M1161/TEST/results/'
% windowSizeMS=[36,200,504]
% 905
% results = '/media/mobs/DimaERC2/DataERC2/M905/TEST/results/'
% 1336
% results = '/media/mobs/DimaERC2/Known_M1336/TEST/results/'
function meanLinearError_Vitesse(V, windowSizeMS, results, LinearPredTsd36,LinearPredTsd200,LinearPredTsd504,LinearTrueTsd36,LinearTrueTsd200,LinearTrueTsd504,LossPredTsd36,LossPredTsd200,LossPredTsd504,EpochOK36,EpochOK200,EpochOK504)
    % This function aims at plotting the mean linear error against the speed of
    % the mouse for time windows of 36 ms, 200 ms and 504 ms
    % First load the data with the `loadData` function and define the good and
    % bad epochs with the `good_bad` function
    
    % windowSizeMS : list containing the window Sizes in ms, e.g. [36,200,504]
    % results : path to the results

    %figure, hist(Data(V),10000) % Plotting the histogramm

    dV = Data(V);
    Vmax = 0;
    for i = 1:length(dV);
        if dV(i) > Vmax;
            Vmax = dV(i);
        end
    end
    
    for p = 1:length(windowSizeMS);
    
        windowSize = windowSizeMS(p);
        ws = windowSize;
        resultsPath=strcat(results,num2str(windowSize));

        % For each point we are going to plot, let's not take only the predictions
        % corresponding to Vpoint (the precise speed of this point on the x-axe), otherwise
        % we would not get a lot of points. Let's take the predictions
        % corresponding to an interval of speeds between Vpoint and Vpoint+0.3.
        % In order to do that we need to define such intervals between 0 and Vmax :
        % so we will have [0,0.3], [0.5,0.8], .... , [Vmax,Vmax+0.3]

        % Initialize the variable
        eval(sprintf('meanLinearErrorVit%d = []',ws));
        eval(sprintf('meanLossPredVit%d=[]',ws));
        % Iterate over the range of speeds
        for vit = 0:15
            intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
            intervalTop = thresholdIntervals(V, vit + 0.3, 'Direction', 'Below');
            interval = intersect(intervalBottom, intervalTop);
            % Compute mean linear error for this range of speeds
            eval(sprintf('linearError_vit = abs(Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval)))))',ws,ws));
            meanLinearError_vit = mean(linearError_vit);
            eval(sprintf('meanLinearErrorVit%d = [meanLinearErrorVit%d, meanLinearError_vit]',ws,ws));
            % Compute mean predicted loss for this range of speed
            lossPred_vit = eval(sprintf('abs(Data(Restrict(LossPredTsd%d, Range(Restrict(V, interval)))))',ws));
            meanLossPred_vit = mean(lossPred_vit);
            eval(sprintf('meanLossPredVit%d = [meanLossPredVit%d,meanLossPred_vit]',ws,ws));
        end
%         vit=16
%         intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
%         intervalTop = thresholdIntervals(V, Vmax, 'Direction', 'Below');
%         interval = intersect(intervalBottom, intervalTop);
%         % Compute mean linear error for this range of speeds
%         eval(sprintf('linearError_vit = abs(Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval)))))',ws,ws));
%         meanLinearError_vit = mean(linearError_vit);
%         eval(sprintf('meanLinearErrorVit%d = [meanLinearErrorVit%d, meanLinearError_vit]',ws,ws));
%         % Compute mean predicted loss for this range of speed
%         lossPred_vit = eval(sprintf('abs(Data(Restrict(LossPredTsd%d, Range(Restrict(V, interval)))))',ws));
%         meanLossPred_vit = mean(lossPred_vit);
%         eval(sprintf('meanLossPredVit%d = [meanLossPredVit%d,meanLossPred_vit]',ws,ws));

        meanLinearErrorVit = eval(sprintf('meanLinearErrorVit%d',ws));
        meanLossPredVit = eval(sprintf('meanLossPredVit%d',ws));
        % Save to the .mat file (overwrite if it already exists)
        save(strcat(resultsPath, '/meanLinearError_V.mat'), 'meanLinearErrorVit');
        save(strcat(resultsPath, '/meanLossPred_V.mat'), 'meanLossPredVit');

        %Standard Error of the mean
        % Initialize the variable
        eval(sprintf('stand_meanLinearErrorVit%d = []',ws));
        eval(sprintf('stand_meanLossPredVit%d=[]',ws));
        % Iterate over the range of speeds
        for vit = 0:15
            intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
            intervalTop = thresholdIntervals(V, vit + 0.3, 'Direction', 'Below');
            interval = intersect(intervalBottom, intervalTop);
            % Compute mean linear error for this range of speeds
            eval(sprintf('carr_meanLinearError_vit = (Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval))))).^2',ws,ws));
            Scarr_meanLinearError_vit = sum(carr_meanLinearError_vit)/(length(carr_meanLinearError_vit)-1);
            stand_meanLinearError_vit = (Scarr_meanLinearError_vit/length(carr_meanLinearError_vit))^(1/2);
            eval(sprintf('stand_meanLinearErrorVit%d = [stand_meanLinearErrorVit%d, stand_meanLinearError_vit]',ws,ws));
        end
%         vit=16
%         intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
%         intervalTop = thresholdIntervals(V, Vmax, 'Direction', 'Below');
%         interval = intersect(intervalBottom, intervalTop);
%         % Compute mean linear error for this range of speeds
%         eval(sprintf('carr_meanLinearError_vit = (Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval))))).^2',ws,ws));
%         Scarr_meanLinearError_vit = sum(carr_meanLinearError_vit)/(length(carr_meanLinearError_vit)-1);
%         stand_meanLinearError_vit = (Scarr_meanLinearError_vit/length(carr_meanLinearError_vit))^(1/2);
%         eval(sprintf('stand_meanLinearErrorVit%d = [stand_meanLinearErrorVit%d, stand_meanLinearError_vit]',ws,ws));

        stand_meanLinearErrorVit = eval(sprintf('stand_meanLinearErrorVit%d',ws));
        % Save to the .mat file (overwrite if it already exists)
        save(strcat(resultsPath, '/stand_meanLinearError_V.mat'), 'stand_meanLinearErrorVit');

    end

    %% Plot the results and take predicted loss into account
    
    color = ['r','g','b'];
    % colorMap = jet(length(Data(LossPredTsd))); 
    marker = {'o', 's', '^'};
    vit = 0:15;
    figure,
    hold on;
    windowSizeMS=[36,200,504];
    minLoss = 10;
    maxLoss = 0;

    for h = 1:length(windowSizeMS)
        windowSize = windowSizeMS(h);
        ws=windowSize;
        resultsPath=strcat(results,num2str(windowSize));
        clear meanLinearErrorVit meanLossPredVit stand_meanLinearErrorVit
        load(strcat(resultsPath, '/meanLinearError_V.mat'));
        load(strcat(resultsPath, '/meanLossPred_V.mat'));
        load(strcat(resultsPath, '/stand_meanLinearError_V.mat'));
        er=errorbar(vit, eval(sprintf('meanLinearErrorVit%d',ws)), eval(sprintf('stand_meanLinearErrorVit%d',ws)), 'Color', color(h));
        hold on;
    end

    for k = 1:length(windowSizeMS)
        windowSize = windowSizeMS(k);
        ws = windowSize;
        resultsPath=strcat(results,num2str(windowSize));
        load(strcat(resultsPath, '/meanLinearError_V.mat'));
        load(strcat(resultsPath, '/meanLossPred_V.mat'));
        for j = 1:16
    %         [~, idx] = min(abs(meanLossPred(j) - linspace(min(meanLossPred), max(meanLossPred), size(colorMap, 1))));
            if eval(sprintf('meanLossPredVit%d(j)',ws)) < 5
    %             plot(vit(j), meanLinearError(j), 'Color', colorMap(idx, :), 'Marker', marker{k}, 'markersize', 15);
                plot(vit(j), eval(sprintf('meanLinearErrorVit%d(j)',ws)) , 'Color', 'k', 'Marker', 'o', 'markersize', 10);
            else
                plot(vit(j), eval(sprintf('meanLinearErrorVit%d(j)',ws)), 'Color', 'k', 'Marker', 'x', 'markersize', 10);
            end
        end
        if min(meanLossPredVit) < minLoss
            minLoss = min(meanLossPredVit);
        end
        if max(meanLossPredVit) > maxLoss
            maxLoss = max(meanLossPredVit);
        end
    end

    % Adding the theta power to illustrate the fact that we are better at
    % decoding when we can rely on theta sequences 
    %Fil=FilterLFP(LFP,[5 10],1024)

    % c = colorbar;
    % caxis([minLoss, maxLoss]);
    % c.Label.String = 'Mean Predicted Loss';
    legend(cellstr(num2str(windowSizeMS')), 'Location', 'best');
    xlabel('Speed of the Mouse');
    ylabel('Mean Linear Error');
    title('Mean Linear Error vs. Speed for Different Window Sizes');
    vit = 0;
    
    for h = 1:length(windowSizeMS);

        windowSize = windowSizeMS(h);
        ws = windowSize;
        resultsPath=strcat(results,num2str(windowSize));

        % Initialize the variable
        eval(sprintf('meanLinearErrorVitgood%d = []',ws));
        eval(sprintf('meanLossPredVitgood%d=[]',ws));
        % Iterate over the range of speeds
        for vit = 0:15
            intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
            intervalTop = thresholdIntervals(V, vit + 0.3, 'Direction', 'Below');
            interval = intersect(intervalBottom, intervalTop);
            % Compute mean linear error for this range of speeds
            eval(sprintf('linearError_vitgood = abs(Data(Restrict(Restrict(LinearPredTsd%d,EpochOK%d), Range(Restrict(V, interval)))) - Data(Restrict(Restrict(LinearTrueTsd%d,EpochOK%d), Range(Restrict(V, interval)))))',ws,ws,ws,ws));
            meanLinearError_vitgood = mean(linearError_vitgood);
            eval(sprintf('meanLinearErrorVitgood%d = [meanLinearErrorVitgood%d, meanLinearError_vitgood]',ws,ws));
        end
%         vit=16
%         intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
%         intervalTop = thresholdIntervals(V, Vmax, 'Direction', 'Below');
%         interval = intersect(intervalBottom, intervalTop);
%         % Compute mean linear error for this range of speeds
%         eval(sprintf('linearError_vitgood = abs(Data(Restrict(Restrict(LinearPredTsd%d,GoodEpoch%d), Range(Restrict(V, interval)))) - Data(Restrict(Restrict(LinearTrueTsd%d,GoodEpoch%d), Range(Restrict(V, interval)))))',ws,ws,ws,ws));
%         meanLinearError_vitgood = mean(linearError_vitgood);
%         eval(sprintf('meanLinearErrorVitgood%d = [meanLinearErrorVitgood%d, meanLinearError_vitgood]',ws,ws));

        meanLinearErrorVitgood = eval(sprintf('meanLinearErrorVitgood%d',ws));
        % Save to the .mat file (overwrite if it already exists)
        save(strcat(resultsPath, '/meanLinearError_Vgood.mat'), 'meanLinearErrorVitgood');

        %Standard Error of the mean
        % Initialize the variable
        eval(sprintf('stand_meanLinearErrorVitgood%d = []',ws));
        % Iterate over the range of speeds
        for vit = 0:15
            intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
            intervalTop = thresholdIntervals(V, vit + 0.3, 'Direction', 'Below');
            interval = intersect(intervalBottom, intervalTop);
            % Compute mean linear error for this range of speeds
            eval(sprintf('carr_meanLinearError_vitgood = (Data(Restrict(Restrict(LinearPredTsd%d,EpochOK%d), Range(Restrict(V, interval)))) - Data(Restrict(Restrict(LinearTrueTsd%d,EpochOK%d), Range(Restrict(V, interval))))).^2',ws,ws,ws,ws));
            Scarr_meanLinearError_vitgood = sum(carr_meanLinearError_vitgood)/(length(carr_meanLinearError_vitgood)-1);
            stand_meanLinearError_vitgood = (Scarr_meanLinearError_vitgood/length(carr_meanLinearError_vitgood))^(1/2);
            eval(sprintf('stand_meanLinearErrorVitgood%d = [stand_meanLinearErrorVitgood%d, stand_meanLinearError_vitgood]',ws,ws));
        end
%         vit=16
%         intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
%         intervalTop = thresholdIntervals(V, Vmax, 'Direction', 'Below');
%         interval = intersect(intervalBottom, intervalTop);
%         % Compute mean linear error for this range of speeds
%         eval(sprintf('carr_meanLinearError_vitgood = (Data(Restrict(Restrict(LinearPredTsd%d,GoodEpoch%d), Range(Restrict(V, interval)))) - Data(Restrict(Restrict(LinearTrueTsd%d,GoodEpoch%d), Range(Restrict(V, interval))))).^2',ws,ws,ws,ws));
%         Scarr_meanLinearError_vitgood = sum(carr_meanLinearError_vitgood)/(length(carr_meanLinearError_vitgood)-1);
%         stand_meanLinearError_vitgood = (Scarr_meanLinearError_vitgood/length(carr_meanLinearError_vitgood))^(1/2);
%         eval(sprintf('stand_meanLinearErrorVitgood%d = [stand_meanLinearErrorVitgood%d, stand_meanLinearError_vitgood]',ws,ws));
% 
        stand_meanLinearErrorVitgood = eval(sprintf('stand_meanLinearErrorVitgood%d',ws));
        % Save to the .mat file (overwrite if it already exists)
        save(strcat(resultsPath, '/stand_meanLinearError_Vgood.mat'), 'stand_meanLinearErrorVitgood');

    end

    %% Plot the results

    % colorMap = jet(length(Data(LossPredTsd))); 
    figure,
    hold on;
    vit=0:15;
    for h = 1:length(windowSizeMS)
        windowSize = windowSizeMS(h);
        ws=windowSize;
        resultsPath=strcat(results,num2str(windowSize));
        clear meanLinearErrorVitgood stand_meanLinearErrorVitgood
        load(strcat(resultsPath, '/meanLinearError_Vgood.mat'));
        load(strcat(resultsPath, '/stand_meanLinearError_Vgood.mat'));
        er=errorbar(vit, eval(sprintf('meanLinearErrorVitgood%d',ws)), eval(sprintf('stand_meanLinearErrorVitgood%d',ws)), 'Color', color(h));
        hold on;
    end

    % Adding the theta power to illustrate the fact that we are better at
    % decoding when we can rely on theta sequences 
    %Fil=FilterLFP(LFP,[5 10],1024)

    % c = colorbar;
    % caxis([minLoss, maxLoss]);
    % c.Label.String = 'Mean Predicted Loss';
    legend(cellstr(num2str(windowSizeMS')), 'Location', 'best');
    xlabel('Speed of the Mouse');
    ylabel('Mean Linear Error');
    title('Mean Linear Error vs. Speed for Different Window Sizes (good PL)');
end





    
    
