function ModelsComparison(DATAtable, structModels1, structModels2, name1, name2, coef1, coef2, Mice, chosenMouse, indexBetas, OBFreq, isNewFigure)
%2MODELSCOMAPARISON Figure to compare 2 models 

    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};


    NamePred1 = structModels1.(Mice{1}).Variables.Properties.VariableNames;
    NamePred2 = structModels2.(Mice{1}).Variables.Properties.VariableNames;
    NamePred1(strcmp(NamePred1, OBFreq)) = [];
    NamePred2(strcmp(NamePred2, OBFreq)) = [];
    NamePred1 = ['Constant' NamePred1];
    NamePred2 = ['Constant' NamePred2];
    listPairedPredictors = cell(length(NamePred1)*length(NamePred2), 1);
    for i = 1:length(NamePred1)
        for j = 1:length(NamePred2)
            listPairedPredictors{(i-1)*length(NamePred2)+j} = [NamePred1{i}; " - "; NamePred2{j}];
        end 
    end 
    
    hasCoef1 = ~isempty(fieldnames(coef1));
    hasCoef2 = ~isempty(fieldnames(coef2));
    
    MiceNumber = length(Mice);
    indexMouse = find(strcmp(Mice, chosenMouse));

    AggregatedR2_1 = zeros(MiceNumber,1);
    AggregatedR2_2 = zeros(MiceNumber,1);
    AggregatedR2Meaned_1 = zeros(MiceNumber,1);
    AggregatedR2Meaned_2 = zeros(MiceNumber,1);
%     AggregatedCoefs1 = zeros(size(coef1.SigGT.(chosenMouse),1), size(coef1.SigGT.(chosenMouse),2), MiceNumber);
%     AggregatedCoefs2 = zeros(size(coef2.SigGT.(chosenMouse),1), size(coef2.SigGT.(chosenMouse),2), MiceNumber);
    
    i1 = ceil(indexBetas / length(NamePred2));
    i2 = mod(indexBetas-1, length(NamePred2))+1;
    
    
    %load Data 
    for i = 1:MiceNumber
        model1 = structModels1.(Mice{i});
        model2 = structModels2.(Mice{i});
        PredictorTable1.(Mice{i}) = model1.Variables;
        PredictorTable2.(Mice{i}) = model2.Variables;
        
        
        
        if any("SigPositionxSigGlobalTime" == string(PredictorTable1.(Mice{i}).Properties.VariableNames))
            PredictorTable1.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable1.(Mice{i}).SigGT = PredictorTable1.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable1.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTimeGlobal" == string(PredictorTable1.(Mice{i}).Properties.VariableNames))
            PredictorTable1.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable1.(Mice{i}).SigGT = PredictorTable1.(Mice{i}).SigPositionxSigGlobalTimeGlobal ./ PredictorTable1.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTimeGeneralGlobal" == string(PredictorTable1.(Mice{i}).Properties.VariableNames))
            PredictorTable1.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable1.(Mice{i}).SigGT = PredictorTable1.(Mice{i}).SigPositionxSigGlobalTimeGeneralGlobal ./ PredictorTable1.(Mice{i}).SigPos;
        end
        hasSigGT1 = any("SigGT" == string(PredictorTable1.(Mice{i}).Properties.VariableNames));
        
        if any("SigPositionxSigGlobalTime" == string(PredictorTable2.(Mice{i}).Properties.VariableNames))
            PredictorTable2.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable2.(Mice{i}).SigGT = PredictorTable2.(Mice{i}).SigPositionxSigGlobalTime ./ PredictorTable2.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTimeGlobal" == string(PredictorTable2.(Mice{i}).Properties.VariableNames))
            PredictorTable2.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable2.(Mice{i}).SigGT = PredictorTable2.(Mice{i}).SigPositionxSigGlobalTimeGlobal ./ PredictorTable2.(Mice{i}).SigPos;
        elseif any("SigPositionxSigGlobalTimeGeneralGlobal" == string(PredictorTable2.(Mice{i}).Properties.VariableNames))
            PredictorTable2.(Mice{i}).SigPos = DATAtable.(Mice{i}).SigPosition;
            PredictorTable2.(Mice{i}).SigGT = PredictorTable2.(Mice{i}).SigPositionxSigGlobalTimeGeneralGlobal ./ PredictorTable2.(Mice{i}).SigPos;
        end
        hasSigGT2 = any("SigGT" == string(PredictorTable2.(Mice{i}).Properties.VariableNames));
        
        
        AggregatedR2_1(i) = model1.Rsquared.Ordinary;
        AggregatedR2_2(i) = model2.Rsquared.Ordinary;
        [~,R2Meaned_1] = ErrorPredExactAndMean(model1.Variables.(OBFreq), model1.Fitted.Response);
        AggregatedR2Meaned_1(i) = R2Meaned_1;
        [~,R2Meaned_2] = ErrorPredExactAndMean(model2.Variables.(OBFreq), model2.Fitted.Response);
        AggregatedR2Meaned_2(i) = R2Meaned_2;
        
        
        for j = 1:length(i1)
            AggregatedBetas(i,2*j-1) = model1.Coefficients.Estimate(i1(j));
            AggregatedBetas(i,2*j) =  model2.Coefficients.Estimate(i2(j));
        end 
        
        
        if hasCoef1
            coefMouse1 = coef1.SigGT.(Mice{i});
            minn1 = min(min(coefMouse1));
            maxx1 = max(max(coefMouse1));
            AggregatedCoefs1(:,:,i) = (coefMouse1 - minn1) / (maxx1 - minn1) ;
        end 
        
        if hasCoef2 
            coefMouse2 = coef2.SigGT.(Mice{i});
            minn2 = min(min(coefMouse2));
            maxx2 = max(max(coefMouse2));
            AggregatedCoefs2(:,:,i) = (coefMouse2 - minn2) / (maxx2 - minn2) ;
        end 
       
    end 

    if isNewFigure
        figure; 
    end 
    
    delete(subplot(2,5,1))
    subplot(2,5,1)
    
    MakeSpreadAndBoxPlot3_ECSB({AggregatedR2_1 AggregatedR2_2},...
    [colors(11) colors(11)],...
    1:2,{name1 name2},'paired',1,'showpoints',0,'showsigstar','none');
    xlim([0.5,2.5])
    ylim([0 1])
    plot([1 2], [AggregatedR2_1(indexMouse) AggregatedR2_2(indexMouse)], 'r*-')
    text(0.8,0.95, {"R^2_1 = "+sprintf('%.4f', AggregatedR2_1(indexMouse))})
    text(1.7,0.95, {"R^2_2 = "+sprintf('%.4f', AggregatedR2_2(indexMouse))})
    text(0.7, median(AggregatedR2_1), sprintf('%.3f', median(AggregatedR2_1)), 'FontSize', 8)
    text(2.03, median(AggregatedR2_2), sprintf('%.3f', median(AggregatedR2_2)), 'FontSize', 8)
    title('R2 Ordinary')
    set(gca,'FontSize',9,'Linewidth',1)
    
    delete(subplot(2,5,2));
    subplot(2,5,2)
    MakeSpreadAndBoxPlot3_ECSB({AggregatedR2Meaned_1 AggregatedR2Meaned_2},...
    [colors(12) colors(12)],...
    1:2,{name1 name2},'paired',1,'showpoints',0,'showsigstar','none');
    title('R2 Meaned')
    xlim([0.5,2.5])
    ylim([0 1])
    plot([1 2], [AggregatedR2Meaned_1(indexMouse) AggregatedR2Meaned_2(indexMouse)], 'r*-')
    text(0.8,0.95, {"R^2_1 = "+sprintf('%.4f', AggregatedR2Meaned_1(indexMouse))})
    text(1.7,0.95, {"R^2_2 = "+sprintf('%.4f', AggregatedR2Meaned_2(indexMouse))})
    text(0.7, median(AggregatedR2Meaned_1), sprintf('%.3f', median(AggregatedR2Meaned_1)), 'FontSize', 8)
    text(2.03, median(AggregatedR2Meaned_2), sprintf('%.3f', median(AggregatedR2Meaned_2)), 'FontSize', 8)
    set(gca,'FontSize',9,'Linewidth',1)



    for i = 1:length(indexBetas)
        if length(indexBetas) > 3
            indicsp = 2 + mod(i-1,3) + 1 + floor((i-1)/3) * 5;
        else 
            indicsp = [2+i 7+i];
        end 
        delete(subplot(4,5,indicsp))
        subplot(4,5,indicsp)
        MakeSpreadAndBoxPlot3_ECSB({AggregatedBetas(:,2*i-1) AggregatedBetas(:,2*i)},...
            [colors(i) colors(i)],...
            1:2, {name1 name2}, 'paired',1,'showpoints',0,'showsigstar','none'); hold on 
        plot([0 3], [0,0], 'k--')
        plot([1 2], [AggregatedBetas(indexMouse, 2*i-1) AggregatedBetas(indexMouse, 2*i)], 'r*-')
        xlim([0.5 2.5])
        title(listPairedPredictors{indexBetas(i)})
        set(gca,'FontSize',10,'Linewidth',1)
    end 

    

    delete(subplot(2,5,6:8))
    subplot(2,5,6:8)
    x = 1:length(structModels1.(chosenMouse).Variables.(OBFreq));
    
    yyaxis left
    plot(x, structModels1.(chosenMouse).Variables.(OBFreq), 'x', 'Color', colors{1}), hold on 
    plot(x, movmean(structModels1.(chosenMouse).Variables.(OBFreq), 8), 'x', 'Color', [0.85 0.85 0.85])
    plot(x,  structModels1.(chosenMouse).Fitted.Response, 'o', 'Color', colors{2})
    plot(x,  structModels2.(chosenMouse).Fitted.Response, 'o', 'Color', colors{3})
    ylabel('Frequency (Hz)')

    yyaxis right
    ylim([0 1])
    plot(x, DATAtable.(chosenMouse).Position, 'Color', colors{4}, 'linewidth', 2)
    
    if hasSigGT1
        plot(x, PredictorTable1.(chosenMouse).SigGT, '-', 'Color', colors {11}, 'linewidth', 2)
    end 
    if hasSigGT2
        plot(x, PredictorTable2.(chosenMouse).SigGT, '--', 'Color', colors {11}, 'linewidth', 2)
    end 
    
    ylabel('Linearized Position')
    
    try
        shocks = diff(DATAtable.(chosenMouse).EyelidNumber);
        indexShocks = find(shocks>=1);
        for i = 1:length(indexShocks)
                plot([indexShocks(i) indexShocks(i)], [0 ,10], '--', 'Color', colors{3}), hold on      
        end
    catch ME
        warning("Shocks not available - "+ME.message)
    end
    
    if hasSigGT1 || hasSigGT2
        legendString = {'Observation', 'Obs Meaned', 'Model 1', 'Model 2', 'Position', 'SigGlobalTime 1', 'SigGlobalTime 2', 'Shocks'};
    else 
        legendString = {'Observation', 'Obs Meaned', 'Fitted', 'Position', 'Shocks'};
    end
        
    leg=legend(legendString, 'FontSize', 12, 'Location', 'northeast');
    %     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
    
    
    if isNewFigure 
        if hasCoef1
            subplot(4,5,14)
            GlobalMapNormalized = mean(AggregatedCoefs1, 3);
            imagesc(GlobalMapNormalized), hold on 
            title(['Global Mean ' name1])
            colorbar('eastoutside')
            [r,c] = find(GlobalMapNormalized == max(max(GlobalMapNormalized)));
            plot(c,r,'r*')
            
            subplot(4,5,15)
            imagesc(std(AggregatedCoefs1, [], 3))
            title(['Global Std ' name1])
            colorbar('eastoutside')
        
        end 
        
        if hasCoef2
            subplot(4,5,19)
            GlobalMapNormalized = mean(AggregatedCoefs2, 3);
            imagesc(GlobalMapNormalized), hold on 
            title(['Global Mean ' name2])
            colorbar('eastoutside')
            [r,c] = find(GlobalMapNormalized == max(max(GlobalMapNormalized)));
            plot(c,r,'r*')    
            
            subplot(4,5,20)
            imagesc(std(AggregatedCoefs2, [], 3))
            title(['Global Std ' name2])
            colorbar('eastoutside')
        end 
    end 
end

