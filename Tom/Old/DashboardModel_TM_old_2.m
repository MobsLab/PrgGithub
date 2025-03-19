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
    
    Mice = fieldnames(structModels);
    MiceNumber = length(Mice);
    indexMouse = find(strcmp(Mice, chosenMouse));
    ilimProtocollong = 5;
    
    if indexMouse < ilimProtocollong
        isNotProtocolLong = 0;
    else 
        isNotProtocolLong = 1;
    end 
    
    hasSigGT = any(strcmp("SigGT", fieldnames(LearnedParams)));
    hasExpTSLS = any(strcmp("ExpTSLS", fieldnames(LearnedParams)));

    AggregatedR2 = zeros(MiceNumber,1);
    AggregatedSpearman = zeros(MiceNumber,1);
    AggregatedR2Meaned = zeros(MiceNumber,1);
    

    for i = 1:MiceNumber
        model = structModels.(Mice{i});
        PredictorTable.(Mice{i}) = model.Variables;
        
        if any("OB_FrequencyArray" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            ObservedY.(Mice{i}) = PredictorTable.(Mice{i}).OB_FrequencyArray; 
            PredictorTable.(Mice{i}).OB_FrequencyArray = [];
            OBFreq = 'OB_FrequencyArray';
        elseif any("OBFrequencySafe" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            ObservedY.(Mice{i}) = PredictorTable.(Mice{i}).OBFrequencySafe;
            PredictorTable.(Mice{i}).OBFrequencySafe = [];
            OBFreq = 'OBFrequencySafe';
        else 
            warning('OB Frequency was not found in predictor table')
        end 
        
        PredictedY.(Mice{i}) = model.Fitted.Response;
        Betas = model.Coefficients.Estimate;
        
        PredictorTable.(Mice{i}).NumObservation = (1:height(PredictorTable.(Mice{i})))';
        if any("SigPositionxTimeSinceLastShock" == string(PredictorTable.(Mice{i}).Properties.VariableNames)) && ...
                any("TimeSinceLastShockArray" == string(PredictorTable.(Mice{i}).Properties.VariableNames))
            PredictorTable.(Mice{i}).SigPos = PredictorTable.(Mice{i}).SigPositionxTimeSinceLastShock ./ PredictorTable.(Mice{i}).TimeSinceLastShockArray;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable.(Mice{i}).SigPos;
        elseif hasSigGT
            PredictorTable.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPositionArray;
            PredictorTable.(Mice{i}).SigGT = PredictorTable.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable.(Mice{i}).SigPos;
        end
        
        meanPredictors = mean(table2array(PredictorTable.(Mice{i})(:,1:end - 1 - hasSigGT * 2)))';
        for k = 1:width(PredictorTable.(Mice{i}))
            if max(PredictorTable.(Mice{i}){:,k}) == 1 && min(PredictorTable.(Mice{i}){:,k}) == 0
                meanPredictors(k) = 1;
            end
        end
                
        Betas(2:end) = Betas(2:end) .* meanPredictors; % -1 pour NumObservation et -2 pour sigPos et sigGT
        AggregatedBetas(i,:) =  Betas;
        AggregatedR2(i) = model.Rsquared.Ordinary;
        AggregatedSpearman(i) =  corr(model.Variables.(OBFreq), PredictedY.(Mice{i}), 'Type', 'Spearman')^2;
        [~,R2Meaned] = ErrorPredExactAndMean(model.Variables.(OBFreq), PredictedY.(Mice{i}));
        AggregatedR2Meaned(i) = R2Meaned;
    end
    
    variableNames = model.VariableNames;
    variableNames(strcmp(variableNames,OBFreq)) = [];
    variableNames = [variableNames; "NumObservation"];

    
    if isNewFigure 
        figure;
    end
    
    
    
    axNE = subplot(4,15,[1:5 16:20]);
    cla

    coefObserved = regress(ObservedY.(chosenMouse), [ones(height(PredictorTable.(chosenMouse)),1) DATAtable.(chosenMouse).PositionArray]); %simple linear regression
    coefPredicted = regress(PredictedY.(chosenMouse), [ones(height(PredictorTable.(chosenMouse)),1) DATAtable.(chosenMouse).PositionArray]);
    plot(DATAtable.(chosenMouse).PositionArray, ObservedY.(chosenMouse), 'x', 'Color', colors{1});
    hold on 
    plot(DATAtable.(chosenMouse).PositionArray, PredictedY.(chosenMouse), 'o','Color', colors{2})
    plot(DATAtable.(chosenMouse).PositionArray,coefObserved(1)+coefObserved(2)*DATAtable.(chosenMouse).PositionArray, 'b', 'Color', colors{1}+0.1)
    plot(DATAtable.(chosenMouse).PositionArray,coefPredicted(1)+coefPredicted(2)*DATAtable.(chosenMouse).PositionArray, 'r', 'Color', colors{2}+0.1);
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
    xtickangle(45)
    yticks(1:length(variableNames))
    yticklabels(variableNames)
    ytickangle(45)
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
    subplot(4,15,[11:15 26:30])
    a = MakeSpreadAndBoxPlot3_ECSB(AggregatedBetas,...
    colors(1:size(AggregatedBetas,2)),...
    1:size(AggregatedBetas,2),{},'paired',1,'showpoints',0, 'showsigstar', 'none');
    xlim([0.5,size(AggregatedBetas,2)+0.5])
    plot(1:size(AggregatedBetas,2), AggregatedBetas(indexMouse,:), 'r-d')
    xtickangle(45);
    xticklabels(['Constant'; variableNames(1:end-1)])
    plot([0 size(AggregatedBetas,2)+1], [0,0], 'k--')
    ylabel('Betas * mean(predictors)', 'FontSize', 16)
    for i=1:size(AggregatedBetas, 2)
        text(i-0.25,min(min(AggregatedBetas))-0.3, sprintf('%.3f',AggregatedBetas(indexMouse, i)))
    end
    set(gca,'FontSize',8,'Linewidth',1)
    
    
    delete(subplot(4,15,[31:38 46:53]))
    subplot(4,15,[31:38 46:53])
    
    if XBilan == "Observation"
        x = 1:length(ObservedY.(chosenMouse));
        xlabel('Observation')  
        
        if any("isBlockedShock" == string(DATAtable.(chosenMouse).Properties.VariableNames))
            yyaxis right
            for k = 1:height(DATAtable.(chosenMouse))
                if DATAtable.(chosenMouse).isBlockedShock(k, 1)

                    area([k k+1],[1 1], 'FaceColor', 'red', 'FaceAlpha', 0.08, 'linestyle', 'none'), hold on 
                end 
            end
            for k = 1:height(DATAtable.(chosenMouse))  
                if DATAtable.(chosenMouse).isBlockedSafe(k, 1)
                    area([k k+1],[1 1], 'FaceColor', 'green', 'FaceAlpha', 0.08, 'linestyle', 'none'), hold on 
                end 
            end
        end
        
    elseif XBilan == "GlobalTime"
        x = DATAtable.(chosenMouse).GlobalTimeArray;
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
    plot(x, movmean(ObservedY.(chosenMouse), 8), 'x', 'Color', [0.85 0.85 0.85])
    plot(x, PredictedY.(chosenMouse), 'o', 'Color', colors{2})
    ylabel('Frequency (Hz)')

    yyaxis right
    ylim([0 1])
    plot(x, DATAtable.(chosenMouse).PositionArray, 'Color', colors{4})
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
                plot(DATAtable.(chosenMouse).GlobalTimeArray(indexShocks(i))*[1 1], [0 ,10], '--', 'Color', colors{3}), hold on 
            end         
        end
    catch ME
        warning("Shocks not available - "+ME.message)
    end
    
    if hasSigGT
        legendString = {'Observation', 'Obs Meaned', 'Fitted', 'Position', 'SigGlobalTime', 'Shocks'};
    else 
        legendString = {'Observation', 'Obs Meaned', 'Fitted', 'Position', 'Shocks'};
    end
        
    leg=legend(legendString, 'FontSize', 12, 'Location', 'northeast');
    %     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
    

    
    delete(subplot(4,15,[40:42 55:57]))
    subplot(4,15,[40:42 55:57])
    
    a = MakeSpreadAndBoxPlot3_ECSB({AggregatedR2 AggregatedR2Meaned},...
    [colors(11) colors(12)],...
    1:2,{'R2 Ordinary' 'R2 Meaned'},'paired',1,'showpoints',0,'showsigstar','none');
    xlim([0.5,2.5])
    ylim([0 1])
    plot([1 2], [AggregatedR2(indexMouse) AggregatedR2Meaned(indexMouse)], 'r*-')
    text(0.8,0.95, {"R^2_o = "+sprintf('%.4f', AggregatedR2(indexMouse))})
    text(1.7,0.95, {"R^2_m = "+sprintf('%.4f', AggregatedR2Meaned(indexMouse))})
    %text(1.32, mean(AggregatedR2)-0.01, num2str(mean(AggregatedR2)))
    set(gca,'FontSize',9,'Linewidth',1)

    
    if hasSigGT && hasExpTSLS
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
    
    elseif hasSigGT
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
    
end



