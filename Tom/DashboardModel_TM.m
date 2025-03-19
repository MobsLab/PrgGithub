function DashboardModel_TM(DATAtable, structModels, chosenMouse, Name, isNewFigure, LearnedParams, XBilan)
%structModels = Structure avec des GeneralizedLinearModel
%chosenMouse = nom d'un elt de la structure
%isNewFigure = bool
     

    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};
    
    TimeBlockedShock = [[480 780]; [1920 2220]; [3360 3660]; [4800 5100]];   
    TimeBlockedSafe = [[960 1260]; [2400 2700]; [3840 4140]; [5280 5580]];  
    
    Mice1 = fieldnames(DATAtable);
    Mice2 = fieldnames(structModels);
    if length(Mice1) <= length(Mice2)
        Mice = Mice1;
    else 
        Mice = Mice2;
    end 
    MiceNumber = length(Mice);
    indexMouse = find(strcmp(Mice, chosenMouse));
    ilimProtocollong = 5;
    
    if indexMouse < ilimProtocollong
        isNotProtocolLong = 0;
    else 
        isNotProtocolLong = 1;
    end 
    
    
    hasLearnedSigGT = any(strcmp("SigGT", fieldnames(LearnedParams))) ;
    hasLearnedSigCumulative = any(strcmp("RepartitionMap", fieldnames(LearnedParams))) ;
    hasExpTSLS = any(strcmp("ExpTSLS", fieldnames(LearnedParams)));

    AggregatedR2 = zeros(MiceNumber,1);
    AggregatedSpearman = zeros(MiceNumber,1);
    AggregatedR2Meaned = zeros(MiceNumber,1);
    AggregatedSSE = zeros(MiceNumber,1);
    

    for i = 1:MiceNumber
        model = structModels.(Mice{i});
        PredictorTable.(Mice{i}) = model.Variables;
        PredictedY.(Mice{i}) = model.Fitted.Response;
        
        if any("OB_Frequency" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            ObservedY.(Mice{i}) = PredictorTable.(Mice{i}).OB_Frequency; 
            PredictorTable.(Mice{i}).OB_Frequency = [];
            OBFreq = 'OB_Frequency';
        elseif any("OBFrequencySafe" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            ObservedY.(Mice{i}) = PredictorTable.(Mice{i}).OBFrequencySafe;
            PredictorTable.(Mice{i}).OBFrequencySafe = [];
            OBFreq = 'OBFrequencySafe';
        else 
            warning('OB Frequency was not found in predictor table')
        end 
        
        
        PredictorTable.(Mice{i}).NumObservation = (1:height(PredictorTable.(Mice{i})))';
        if any("SigPositionxTimeSinceLastShock" == string(PredictorTable.(Mice{i}).Properties.VariableNames)) && ...
                any("TimeSinceLastShock" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            PredictorTable.(Mice{i}).SigPos = PredictorTable.(Mice{i}).SigPositionxTimeSinceLastShock ./ PredictorTable.(Mice{i}).TimeSinceLastShock;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTime" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            PredictorTable.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTimeGlobal" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            PredictorTable.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTimeGlobal ./ PredictorTable.(Mice{i}).SigPos; 
        elseif any("SigPositionxSigLearningPred" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            PredictorTable.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigLearningPred ./ PredictorTable.(Mice{i}).SigPos;
        end
        
        hasSigGT = any("SigGT" == string(PredictorTable.(Mice{i}).Properties.VariableNames));
        
        
%         meanPredictors = mean(table2array(PredictorTable.(Mice{i})(:,1:end - 1 - hasSigGT * 2)))';
%         for k = 1:width(PredictorTable.(Mice{i}))
%             if max(PredictorTable.(Mice{i}){:,k}) == 1 && min(PredictorTable.(Mice{i}){:,k}) == 0
%                 meanPredictors(k) = 1;
%             end
%         end
%                 
%         Betas(2:end) = Betas(2:end) .* meanPredictors; % -1 pour NumObservation et -2 pour sigPos et sigGT
        AggregatedBetas(i,:) =  model.Coefficients.Estimate;
        AggregatedR2(i) = model.Rsquared.Ordinary;
        AggregatedSpearman(i) =  corr(model.Variables.(OBFreq), PredictedY.(Mice{i}), 'Type', 'Spearman')^2;
        [~,R2Meaned] = ErrorPredExactAndMean(model.Variables.(OBFreq), PredictedY.(Mice{i}));
        AggregatedR2Meaned(i) = R2Meaned;
        
        
        AggregatedSSE(i) = mean(abs(ObservedY.(Mice{i}) - PredictedY.(Mice{i}))); %/ ...
        %(max(PredictedY.(Mice{i})) - min(PredictedY.(Mice{i})));
        AggregatedSSE(i) = mean(abs(movmean(ObservedY.(Mice{i}), 8) - PredictedY.(Mice{i}))); %/ ...
        %(max(PredictedY.(Mice{i})) - min(PredictedY.(Mice{i})));
            
    end
    
    variableNames = model.VariableNames;
    variableNames(strcmp(variableNames,OBFreq)) = [];
    variableNames = [variableNames; "NumObservation"];

    
    if isNewFigure 
        figure;
    end
    
    
    
    axNE = subplot(4,15,[1:5 16:20]);
    cla

    coefObserved = regress(ObservedY.(chosenMouse), [ones(height(PredictorTable.(chosenMouse)),1) DATAtable.(chosenMouse).Position]); %simple linear regression
    coefPredicted = regress(PredictedY.(chosenMouse), [ones(height(PredictorTable.(chosenMouse)),1) DATAtable.(chosenMouse).Position]);
    plot(DATAtable.(chosenMouse).Position, ObservedY.(chosenMouse), 'x', 'Color', colors{1});
    hold on 
    plot(DATAtable.(chosenMouse).Position, PredictedY.(chosenMouse), 'o','Color', colors{2})
    plot(DATAtable.(chosenMouse).Position,coefObserved(1)+coefObserved(2)*DATAtable.(chosenMouse).Position, 'b', 'Color', colors{1}+0.1)
    plot(DATAtable.(chosenMouse).Position,coefPredicted(1)+coefPredicted(2)*DATAtable.(chosenMouse).Position, 'r', 'Color', colors{2}+0.1);
    hold off 
    xlabel('Position')
    ylabel('OB Frequency')
    leg=legend({'Observation', 'Fitted', 'Observation Regression', 'Fitted Regression'}, 'FontSize', 10, 'Location', 'southwest');
    leg.ItemTokenSize = [20,10];
    legend boxoff
    
    
    indChosen = [1 1];
    
    keptPoints = [];
    
    function SelectInterestingPoints(ax)
        cp = ax.CurrentPoint(1,1:2);
       
        data = PredictorTable.(chosenMouse)(:,{variableNames{indChosen(1)} variableNames{indChosen(2)}});
        dataNormalized = data{:,:} ./ max(data{:,:});
        distance_min = inf;
        j_min = -1;
        cpN = cp ./ max(data{:,:});
        for j = 1:height(data)
            distance_new = norm(cpN - dataNormalized(j,:));
            if distance_new < distance_min
                distance_min = distance_new;
                j_min = j;
            end
        end
        disp([distance_min j_min])
        if any(keptPoints == j_min)
            keptPoints(keptPoints == j_min) = [];
            hold on
            addimg2 = plot(PredictorTable.(chosenMouse){j_min,indChosen(1)},PredictorTable.(chosenMouse){j_min,indChosen(2)}, 'o', 'Color', colors{1});
            addimg2.ButtonDownFcn = @(~,~) SelectInterestingPoints(axNE) ;
            disp("remove")
        elseif j_min >= 0
            keptPoints(end+1) = j_min;
            hold on
            addimg = plot(PredictorTable.(chosenMouse){j_min,indChosen(1)},PredictorTable.(chosenMouse){j_min,indChosen(2)}, 'ro');
            addimg.ButtonDownFcn = @(~,~) SelectInterestingPoints(axNE) ;
        end
    end 
            
        
        
    
    axN = subplot(4,15,[7:10 22:25]);
    imgN = imagesc(abs(corrcoef(table2array(PredictorTable.(chosenMouse)(:,1:end - hasSigGT * 2)))));
    xticks(1:length(variableNames))
    xticklabels(variableNames)
    xtickangle(15)
    yticks(1:length(variableNames))
    yticklabels(variableNames)
    ytickangle(75)
    set(gca,'FontSize',8,'Linewidth',1)
    caxis([0 1])
    title(Name + " - " + chosenMouse, 'FontSize', 14) 
    colorbar
    
    imgN.ButtonDownFcn = @(~,~) SelectPlotFromCorrCoef(axN) ;
    
    function SelectPlotFromCorrCoef(ax)
        cp = ax.CurrentPoint(1,1:2);
        indChosen = round(cp);
        axNE = subplot(4,15,[1:5 16:20]);
        cla
        
        imgNE = scatter(PredictorTable.(chosenMouse){:,indChosen(1)},PredictorTable.(chosenMouse){:,indChosen(2)}, [],DATAtable.(chosenMouse).(OBFreq)); hold on 
        c = colorbar('eastoutside');
        c.Label.String = 'OB Frequency (Hz)';
        imgNE.ButtonDownFcn = @(~,~) SelectInterestingPoints(axNE) ;
        
        if ~isempty(keptPoints)
            imgNEAdd = plot(PredictorTable.(chosenMouse){keptPoints,indChosen(1)},PredictorTable.(chosenMouse){keptPoints,indChosen(2)}, 'ro');
            imgNEAdd.ButtonDownFcn = @(~,~) SelectInterestingPoints(axNE) ;
        end
        
        xlabel(variableNames(indChosen(1)))
        ylabel(variableNames(indChosen(2))) 
    end


    delete(subplot(4,15,[11:15 26:30]))
    axNW = subplot(4,15,[11:15 26:30]);
    [~,~,blockBetas] = MakeSpreadAndBoxPlot3_ECSBTM(AggregatedBetas,...
    colors(1:size(AggregatedBetas,2)),...
    1:size(AggregatedBetas,2),{},'paired',1,'showpoints',0, 'showsigstar', 'none');
    xlim([0.5,size(AggregatedBetas,2)+0.5])
    plot(1:size(AggregatedBetas,2), AggregatedBetas(indexMouse,:), 'r-d')
    xtickangle(45);
    xticklabels(['Constant'; variableNames(1:end-1)])
    plot([0 size(AggregatedBetas,2)+1], [0,0], 'k--')
    ylabel('Betas * mean(predictors)', 'FontSize', 16)
    
    for i=1:size(AggregatedBetas, 2)
        text(i-0.25,-3.5, sprintf('%.3f',AggregatedBetas(indexMouse, i)))
        [~,p] = ttest(AggregatedBetas(:, i), zeros(size(AggregatedBetas(:, i), 1), 1));
        text(i-0.25,6, num2str(p))
    end
    set(gca,'FontSize',8,'Linewidth',1)
    ylim([-4 10])
    
    for i = 1:length(blockBetas)
        blockBetas(i).ButtonDownFcn = @(~,~) ChooseMouse(axNW, AggregatedBetas(:,i)) ;
    end 
    
    function ChooseMouse(ax, data)
        cp = ax.CurrentPoint(1,1:2);
        
        plot(cp, 'xk', 'Parent', ax)
       
        %dataNormalized = data ./ max(max(data);
        distance_min = inf;
        j_min = -1;
        %cpN = cp ./ max(data{:,:});
        for j = 1:length(data)
            distance_new = abs(cp(2) - data(j));
            if distance_new < distance_min
                distance_min = distance_new;
                j_min = j;
            end
        end
        disp([distance_min j_min])
        
        
        DashboardModel_TM(DATAtable, structModels, Mice{j_min},Name, 0, LearnedParams, XBilan);
    end 
    
    
    delete(subplot(4,15,[31:38 46:53]))
    subplot(4,15,[31:38 46:53])
    
    if XBilan == "Observation"
        x = 1:length(ObservedY.(chosenMouse));
        xlabel('Observation')  
        
%         if any("isBlockedShock" == string(DATAtable.(chosenMouse).Properties.VariableNames))
%             yyaxis right
%             for k = 1:height(DATAtable.(chosenMouse))
%                 if DATAtable.(chosenMouse).isBlockedShock(k, 1)
% 
%                     area([k k+1],[1 1], 'FaceColor', 'red', 'FaceAlpha', 0.08, 'linestyle', 'none'), hold on 
%                 end 
%             end
%             for k = 1:height(DATAtable.(chosenMouse))  
%                 if DATAtable.(chosenMouse).isBlockedSafe(k, 1)
%                     area([k k+1],[1 1], 'FaceColor', 'green', 'FaceAlpha', 0.08, 'linestyle', 'none'), hold on 
%                 end 
%             end
%         end
        
    elseif XBilan == "GlobalTime"
        x = DATAtable.(chosenMouse).GlobalTime;
        xlabel('Global Time')
        
        if any("isBlockedShock" == string(DATAtable.(chosenMouse).Properties.VariableNames))
            yyaxis right
            for k = 1:(length(TimeBlockedShock) - isNotProtocolLong)  
                area(TimeBlockedShock(k,:), [1 1], 'FaceColor', 'red', 'FaceAlpha', 0.1, 'linestyle', 'none'), hold on 
            end
            for k = 1:(length(TimeBlockedShock) - isNotProtocolLong)  
                area(TimeBlockedSafe(k,:), [1 1], 'FaceColor', 'green', 'FaceAlpha', 0.1, 'linestyle', 'none'), hold on 
            end
        end 
    end
    
    

    
    yyaxis left
    plot(x, ObservedY.(chosenMouse), 'x', 'Color', colors{1}), hold on 
    %plot(x, movmean(ObservedY.(chosenMouse), 8), 'x', 'Color', [0.85 0.85 0.85])
    plot(x, PredictedY.(chosenMouse), 'o', 'Color', colors{2})
    ylabel('Frequency (Hz)')
    ylim([0 10])
    
    yyaxis right
    ylim([0 1])
    plot(x, 1-DATAtable.(chosenMouse).Position, '.-','Markersize',10,'Color', colors{4}, 'linewidth', 2)
    
    if hasSigGT
        plot(x, PredictorTable.(chosenMouse).SigGT, '-', 'Color', colors {11}, 'linewidth', 2)
    end 
    
    ylabel('Linearized Position')
    
    try
        shocks = diff(DATAtable.(chosenMouse).EyelidNumber);
        indexShocks = find(shocks>=1);
        for i = 1:length(indexShocks)
            if XBilan == "Observation"
                plot([indexShocks(i) indexShocks(i)], [0 ,10], '--', 'Color', colors{3}), hold on 
            elseif XBilan == "GlobalTime"
                plot(DATAtable.(chosenMouse).GlobalTime(indexShocks(i))*[1 1], [0 ,10], '--', 'Color', colors{3}), hold on 
            end         
        end
    catch ME
        warning("Shocks not available - "+ME.message)
    end
    
    if hasSigGT
        legendString = {'Observation',  'Fitted', 'Position', 'SigGlobalTime', 'Shocks'}; %'Obs Meaned',
    else 
        legendString = {'Observation', 'Obs Meaned', 'Fitted', 'Position', 'Shocks'};
    end
        
    leg=legend(legendString, 'FontSize', 12, 'Location', 'northeast');
    %     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
    

    
    delete(subplot(4,15,[40:42 55:57]))
    axS = subplot(4,15,[40:42 55:57]);
    
    [~,~,plotR2] = MakeSpreadAndBoxPlot3_ECSBTM({AggregatedR2 AggregatedR2Meaned, AggregatedSSE},...
    [colors(11) colors(12), colors(10)],...
    1:3,{'R2 Ordinary' 'R2 Meaned', 'Meaned Distance'},'paired',1,'showpoints',0,'showsigstar','none'); hold on 
    xlim([0.5,3.5])
    ylim([0 1])
%    plot([1 2], [AggregatedR2(indexMouse) AggregatedR2Meaned(indexMouse)], 'r*-') 
    plot([1 2 3], [AggregatedR2(indexMouse) AggregatedR2Meaned(indexMouse) AggregatedSSE(indexMouse)], 'r*-')
    text(0.8,0.95, {"R^2_o = "+sprintf('%.3f', AggregatedR2(indexMouse))})
    text(1.7,0.95, {"R^2_m = "+sprintf('%.3f', AggregatedR2Meaned(indexMouse))})
    text(2.5,0.1, {"Dist_m = "+sprintf('%.3f', AggregatedSSE(indexMouse))})
    %text(1.32, mean(AggregatedR2)-0.01, num2str(mean(AggregatedR2)))
    set(gca,'FontSize',9,'Linewidth',1)

    plotR2(1).ButtonDownFcn = @(~,~) ChooseMouse(axS, AggregatedR2);
    plotR2(2).ButtonDownFcn = @(~,~) ChooseMouse(axS, AggregatedR2Meaned);
    
%     yyaxis right
%     [~,~,plotR2] = MakeSpreadAndBoxPlot3_ECSBTM({},...
%     colors(10), 3, {'Meaned Distance'},'paired',1,'showpoints',0,'showsigstar','none');
%     %ylim([0 0.5])
%     plotR2(1).ButtonDownFcn = @(~,~) ChooseMouse(axS, AggregatedSSE);

    
    if hasLearnedSigGT && hasExpTSLS
        delete(subplot(4,15,[43:44 58:59]))
        axSE = subplot(4,15,[43:44 58:59]);
        axSE.YAxis(1).Visible = 'off';

        imagesc(LearnedParams.SigGT.(chosenMouse)), hold on
        [r,c] = find(LearnedParams.SigGT.(chosenMouse) == max(max(LearnedParams.SigGT.(chosenMouse))));
        plot(c,r,'r*')
        colorbar('southoutside')
        xlabel("Learnpoint")
        ylabel("Learnslope")
        axSE.YColor = 'k';
        
        delete(subplot(4,15,[45 60]))
        axSEE = subplot(4,15,[45 60]);
        axSEE.YAxis(1).Visible = 'off';

        imagesc(LearnedParams.ExpTSLS.(chosenMouse)), hold on
        r = find(LearnedParams.ExpTSLS.(chosenMouse) == max(LearnedParams.ExpTSLS.(chosenMouse)));
        plot(1,r,'r*')
        colorbar('southoutside')
        ylabel("Tau-TimeSinceLasstShock")
        axSEE.YColor = 'k';
    
    elseif hasLearnedSigGT && hasLearnedSigCumulative
        
        UnselectPlot()
        
        
        
        
    elseif hasLearnedSigGT
        delete(subplot(4,15,[43:45 58:60]))
        axSE = subplot(4,15,[43:45 58:60]);
        axSE.YAxis(1).Visible = 'off';

        imagesc(LearnedParams.SigGT.(chosenMouse)), hold on
        [r,c] = find(LearnedParams.SigGT.(chosenMouse) == max(max(LearnedParams.SigGT.(chosenMouse))));
        plot(c,r,'r*')
        colorbar('southoutside')
        xlabel("Learnpoint")
        ylabel("Learnslope")
        axSE.YColor = 'k';
        
    elseif hasExpTSLS
        delete(subplot(4,15,[43:45 58:60]))
        axSEE = subplot(4,15,[43:45 58:60]);
        axSEE.YAxis(1).Visible = 'off';

        imagesc(LearnedParams.ExpTSLS.(chosenMouse)), hold on
        r = find(LearnedParams.ExpTSLS.(chosenMouse) == max(LearnedParams.ExpTSLS.(chosenMouse)));
        plot(1,r,'r*')
        colorbar('southoutside')
        ylabel("Tau-TimeSinceLasstShock")
        axSEE.YColor = 'k';
    
    end
    
    
    function SelectSubplot(i,k)
        disp([i,k])
        nCoefCumulEntryShock = size(LearnedParams.All.(chosenMouse), 3);
        nCoefCumulRipples = size(LearnedParams.All.(chosenMouse), 4);
        for indCES = 1:(nCoefCumulEntryShock - 2)           
            for indrip = 1:(nCoefCumulRipples - 1 - indCES)
                delete(subplot(2 * (nCoefCumulEntryShock - 2), 5 * (nCoefCumulRipples - 2),...
                    5 * (nCoefCumulEntryShock - 2) * (nCoefCumulRipples - 2) + ...
                    4 *  (nCoefCumulRipples - 2) + ...
                    5 *  (nCoefCumulRipples - 2) * (indCES - 1) + ...
                    indrip))
            end 
        end 
        subplot(4,5,[15 20])
        disp(size(LearnedParams.All.(chosenMouse)))
        imgbis = imagesc(LearnedParams.All.(chosenMouse)(:, :, i, k));
        colorbar
        imgbis.ButtonDownFcn = @(~,~) UnselectPlot(); 
    end 

    function UnselectPlot()
        nCoefCumulEntryShock = size(LearnedParams.All.(chosenMouse), 3);
        nCoefCumulRipples = size(LearnedParams.All.(chosenMouse), 4);
        LearnedParams.All.(chosenMouse)(LearnedParams.All.(chosenMouse) == -1) = NaN;
        minnn = min(min(min(min(LearnedParams.All.(chosenMouse)))));
        maxxx = max(max(max(max(LearnedParams.All.(chosenMouse)))));
        for indCES = 1:(nCoefCumulEntryShock - 2)           
            for indrip = 1:(nCoefCumulRipples - 1 - indCES)
                delete(subplot(2 * (nCoefCumulEntryShock - 2), 5 * (nCoefCumulRipples - 2),...
                    5 * (nCoefCumulEntryShock - 2) * (nCoefCumulRipples - 2) + ...
                    4 *  (nCoefCumulRipples - 2) + ...
                    5 *  (nCoefCumulRipples - 2) * (indCES - 1) + ...
                    indrip))
                subplot(2 * (nCoefCumulEntryShock - 2), 5 * (nCoefCumulRipples - 2),...
                    5 * (nCoefCumulEntryShock - 2) * (nCoefCumulRipples - 2) + ...
                    4 *  (nCoefCumulRipples - 2) + ...
                    5 *  (nCoefCumulRipples - 2) * (indCES - 1) + ...
                    indrip)
                img = imagesc(LearnedParams.All.(chosenMouse)(:, :, indCES, indrip));
                caxis([minnn maxxx])
                set(gca, 'Xticklabel', [])
                set(gca, 'Yticklabel', [])
                img.ButtonDownFcn = @(~,~) SelectSubplot(indCES,indrip);
                
            end 
        end 
        
        colorbar(axS, 'Position', [0.92 0.1 0.02 0.4])
        caxis(axS, [minnn maxxx]);
    end 
    
end



