function PanelLinearModel(DATAtable,structModels,Name)
%PANELMODEL plot a 
%DATAtable: structure of table for each mouse with all the useful DATA
%Model: structure of GeneralizedLinearModel or LinearizedModelTM 

    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};

    Mice1 = fieldnames(DATAtable);
    Mice2 = fieldnames(structModels);
    if length(Mice1) <= length(Mice2)
        Mice = Mice1;
    else 
        Mice = Mice2;
    end 
    MiceNumber = length(Mice);
    
    AggregatedR2 = zeros(MiceNumber,1);
    AggregatedSpearman = zeros(MiceNumber,1);
    AggregatedR2Meaned = zeros(MiceNumber,1);
    AggregatedSSE = zeros(MiceNumber,1);
    
    MeanOfCorrelation = zeros(width(structModels.(Mice{1}).Variables)-1);

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
        
        MeanOfCorrelation = MeanOfCorrelation + corrcoef(table2array(PredictorTable.(Mice{i})(:,1:end - hasSigGT * 2)));
    
        AggregatedBetas(i,:) =  model.Coefficients.Estimate;
        AggregatedR2(i) = model.Rsquared.Ordinary;
        AggregatedSpearman(i) =  corr(model.Variables.(OBFreq), PredictedY.(Mice{i}), 'Type', 'Spearman')^2;
        [~,R2Meaned] = ErrorPredExactAndMean(model.Variables.(OBFreq), PredictedY.(Mice{i}));
        AggregatedR2Meaned(i) = R2Meaned;
        
        
        AggregatedSSE(i) = mean(abs(ObservedY.(Mice{i}) - PredictedY.(Mice{i})));
        %AggregatedSSE(i) = mean(abs(movmean(ObservedY.(Mice{i}), 8) - PredictedY.(Mice{i}))); 

        
    end
    
    variableNames = model.VariableNames;
    variableNames(strcmp(variableNames,OBFreq)) = [];
    
    figure;
    
    subplot(1,3,1);
    imagesc(abs(MeanOfCorrelation)/MiceNumber);
    xticks(1:length(variableNames))
    xticklabels(variableNames)
    xtickangle(45)
    yticks(1:length(variableNames))
    yticklabels(variableNames)
    ytickangle(45)
    set(gca,'FontSize',8,'Linewidth',1)
    caxis([0 1])
    title(Name, 'FontSize', 14) 
    colorbar
    
    
    subplot(1,3,2);
    MakeSpreadAndBoxPlot3_ECSB(AggregatedBetas,...
    colors(1:size(AggregatedBetas,2)),...
    1:size(AggregatedBetas,2),{},'paired',1,'showpoints',0, 'showsigstar', 'none');
    xlim([0.5,size(AggregatedBetas,2)+0.5])
    xtickangle(45);
    xticklabels(['Constant'; variableNames(1:end)])
    plot([0 size(AggregatedBetas,2)+1], [0,0], 'k--')
    ylabel('Betas', 'FontSize', 16)
    
    for i=1:size(AggregatedBetas, 2)
        text(i-0.15, -10-0.2, sprintf('%.3f', median(AggregatedBetas(:, i)))) %min(min(AggregatedBetas))
        [~,p] = ttest(AggregatedBetas(:, i), zeros(size(AggregatedBetas(:, i), 1), 1));
        text(i-0.15,10+0.25, sprintf('%.1e',p)) %max(max(AggregatedBetas))
    end
    set(gca,'FontSize',8,'Linewidth',1)
    ylim([min(min(AggregatedBetas))-0.4 max(max(AggregatedBetas))+0.5])
    ylim([-10.5 10.5])
    
    
    subplot(1,3,3);
    MakeSpreadAndBoxPlot3_ECSB({AggregatedR2 AggregatedR2Meaned, AggregatedSSE},...
    [colors(11) colors(12), colors(10)],...
    1:3,{'R2 Ordinary' 'R2 Meaned', 'Meaned Distance'},'paired',1,'showpoints',0,'showsigstar','none'); 
    xlim([0.5,3.5])
    ylim([0 1])
    text(0.8,0.95, {"R^2_o = "+sprintf('%.3f', median(AggregatedR2))})
    text(1.7,0.95, {"R^2_m = "+sprintf('%.3f', median(AggregatedR2Meaned))})
    text(2.5,0.1, {"Dist_m = "+sprintf('%.3f', median(AggregatedSSE))})
    set(gca,'FontSize',9,'Linewidth',1)
    
    
end

