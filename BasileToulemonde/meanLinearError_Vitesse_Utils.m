% This script aims at renaming the meanLinearError and meanLossPred
% in a loop to store one for each windowSizeMS
windowSizeMS=[36,200,504]

dV = Data(V)
Vmax = 0
for i = 1:length(dV);
    if dV(i) > Vmax;
        Vmax = dV(i)
    end
end


for p = 1:length(windowSizeMS);
    
    windowSize = windowSizeMS(p);
    ws = windowSize
    resultsPath=strcat("/media/mobs/DimaERC2/DataERC2/M1161/TEST/results/",num2str(windowSize))
    
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
    vit=16
    intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
    intervalTop = thresholdIntervals(V, Vmax, 'Direction', 'Below');
    interval = intersect(intervalBottom, intervalTop);
    % Compute mean linear error for this range of speeds
    eval(sprintf('linearError_vit = abs(Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval)))))',ws,ws));
    meanLinearError_vit = mean(linearError_vit);
    eval(sprintf('meanLinearErrorVit%d = [meanLinearErrorVit%d, meanLinearError_vit]',ws,ws));
    % Compute mean predicted loss for this range of speed
    lossPred_vit = eval(sprintf('abs(Data(Restrict(LossPredTsd%d, Range(Restrict(V, interval)))))',ws));
    meanLossPred_vit = mean(lossPred_vit);
    eval(sprintf('meanLossPredVit%d = [meanLossPredVit%d,meanLossPred_vit]',ws,ws));
    
    meanLinearErrorVit = eval(sprintf('meanLinearErrorVit%d',ws))
    meanLossPredVit = eval(sprintf('meanLossPredVit%d',ws))
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
    vit=16
    intervalBottom = thresholdIntervals(V, vit, 'Direction', 'Above');
    intervalTop = thresholdIntervals(V, vit + 0.3, 'Direction', 'Below');
    interval = intersect(intervalBottom, intervalTop);
    % Compute mean linear error for this range of speeds
    eval(sprintf('carr_meanLinearError_vit = (Data(Restrict(LinearPredTsd%d, Range(Restrict(V, interval)))) - Data(Restrict(LinearTrueTsd%d, Range(Restrict(V, interval))))).^2',ws,ws));
    Scarr_meanLinearError_vit = sum(carr_meanLinearError_vit)/(length(carr_meanLinearError_vit)-1);
    stand_meanLinearError_vit = (Scarr_meanLinearError_vit/length(carr_meanLinearError_vit))^(1/2);
    eval(sprintf('stand_meanLinearErrorVit%d = [stand_meanLinearErrorVit%d, stand_meanLinearError_vit]',ws,ws));
    
    stand_meanLinearErrorVit = eval(sprintf('stand_meanLinearErrorVit%d',ws))
    % Save to the .mat file (overwrite if it already exists)
    save(strcat(resultsPath, '/stand_meanLinearError_V.mat'), 'stand_meanLinearErrorVit');
    
end
