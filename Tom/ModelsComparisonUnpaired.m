function handles = ModelsComparisonUnpaired(structModels1, structModels2, name1, name2, Mice1, Mice2, coef1, coef2, isNewFigure, selectedPoints, indexBetas)
%2MODELSCOMAPARISON Figure to compare 2 models 

    handles = {};
    
    if nargin < 8
        coef2 = struct([]);
    end 
    if nargin < 7
        coef1 = struct([]);
    end 

    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};

    
    %Selection of The Predicted value 
    if any("OB_Frequency" == string(structModels1.(Mice1{1}).Variables.Properties.VariableNames))
        OBFreq = 'OB_Frequency';
    elseif any("OBFrequencySafe" == string(structModels1.(Mice1{1}).Variables.Properties.VariableNames))
        OBFreq = 'OBFrequencySafe';
    else 
        warning('OB Frequency was not found in predictor table')
    end 

    NamePred1 = structModels1.(Mice1{1}).Variables.Properties.VariableNames;
    NamePred2 = structModels2.(Mice2{1}).Variables.Properties.VariableNames;
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
    
   
    hasSelectedPoints1 = length(selectedPoints) >= 1 && any(logical(selectedPoints(1,:)));
    hasSelectedPoints2 = size(selectedPoints, 1) >= 2 && any(logical(selectedPoints(2,:)));
    
    MiceNumber1 = length(Mice1);
    MiceNumber2 = length(Mice2);

    AggregatedR2_1 = zeros(MiceNumber1,1);
    AggregatedR2_2 = zeros(MiceNumber2,1);
    AggregatedR2Meaned_1 = zeros(MiceNumber1,1);
    AggregatedR2Meaned_2 = zeros(MiceNumber2,1);
%     AggregatedCoefs1 = zeros(size(coef1.SigGT.(chosenMouse),1), size(coef1.SigGT.(chosenMouse),2), MiceNumber);
%     AggregatedCoefs2 = zeros(size(coef2.SigGT.(chosenMouse),1), size(coef2.SigGT.(chosenMouse),2), MiceNumber);
    
    i1 = ceil(indexBetas / length(NamePred2));
    i2 = mod(indexBetas-1, length(NamePred2))+1;
    
    
    %load Data 
    for i = 1:MiceNumber1
        model1 = structModels1.(Mice1{i});
        
        AggregatedR2_1(i) = model1.Rsquared.Ordinary;
        [~,R2Meaned_1] = ErrorPredExactAndMean(model1.Variables.(OBFreq), model1.Fitted.Response);
        AggregatedR2Meaned_1(i) = R2Meaned_1;
        
        for j = 1:length(i1)
            AggregatedBetas(i,2*j-1) = model1.Coefficients.Estimate(i1(j));
        end 
        
        
        if hasCoef1
            coefMouse1 = coef1.SigGT.(Mice1{i});
            minn1 = min(min(coefMouse1));
            maxx1 = max(max(coefMouse1));
            AggregatedCoefs1(:,:,i) = (coefMouse1 - minn1) / (maxx1 - minn1) ;
        end 
    end 
    
    
    for i = 1:MiceNumber2
        model2 = structModels2.(Mice2{i});

        AggregatedR2_2(i) = model2.Rsquared.Ordinary;
        [~,R2Meaned_2] = ErrorPredExactAndMean(model2.Variables.(OBFreq), model2.Fitted.Response);
        AggregatedR2Meaned_2(i) = R2Meaned_2;
        
        for j = 1:length(i2)
            AggregatedBetas(i,2*j) =  model2.Coefficients.Estimate(i2(j));
        end 
        
        if hasCoef2 
            coefMouse2 = coef2.SigGT.(Mice2{i});
            minn2 = min(min(coefMouse2));
            maxx2 = max(max(coefMouse2));
            AggregatedCoefs2(:,:,i) = (coefMouse2 - minn2) / (maxx2 - minn2) ;
        end   
    end 

    
    if isNewFigure 
        if hasCoef2 || hasCoef1
            figure; 
            if hasCoef1 
                plot(mean(mean(AggregatedCoefs1, 3)))
            end
            hold on
            if hasCoef2
                plot(mean(mean(AggregatedCoefs2, 3)))
            end 
            set(gca, 'XTicklabel', [])
            title('Mean of R² for All Mice depending on LP')
            xlabel('Learning Point')
            ylabel('R²')
            
            r1 = zeros(MiceNumber1,1);
            c1 = zeros(MiceNumber1,1);
            r2 = zeros(MiceNumber2,1);
            c2 = zeros(MiceNumber2,1);
            for i = 1:MiceNumber1
                [r1(i),c1(i)] = find(coef1.SigGT.(Mice1{i}) == max(max(coef1.SigGT.(Mice1{i}))), 1);
            end 
            for i = 1:MiceNumber2
                [r2(i),c2(i)] = find(coef2.SigGT.(Mice2{i}) == max(max(coef2.SigGT.(Mice2{i}))), 1);
            end 
            
            figure;
            MakeSpreadAndBoxPlot3_ECSB({c1 c2}, colors(1:2), 1:2, {name1 name2}, 'paired', 0)
            xlim([0.5 2.5])
            ylabel('LearnPoint')
            set(gca,'FontSize',9,'Linewidth',1)
            set(gca,'YAxisLocation','right')
            set(gca, 'yticklabel', {[]})
            camroll(-90)
            title('Comparison of Learning Points')
            
        end
        
        
        
        
        figure;
    end 
    
    
    delete(subplot(2,5,1))
    subplot(2,5,1)
    
    [~,~,~,handle] = MakeSpreadAndBoxPlot3_ECSBTM({AggregatedR2_1 AggregatedR2_2},...
    [colors(1) colors(2)],...
    1:2,{name1 name2},'paired',0,'showpoints',1);
    handles{end +1} = handle;

    
%     text(0.7, median(AggregatedR2_1), sprintf('%.3f', median(AggregatedR2_1)), 'FontSize', 8)
%     text(2.03, median(AggregatedR2_2), sprintf('%.3f', median(AggregatedR2_2)), 'FontSize', 8)
    title('Comparison of Accuracy')
    ylabel('R²')
    if hasSelectedPoints1
        h1 = plotSpread(AggregatedR2_1(nonzeros(selectedPoints(1,:))),'xValues', 1, 'distributionColors',[0.9 0 0],'spreadWidth',1);
        set(h1{1},'MarkerSize',15)
    end     
    if hasSelectedPoints2
        h1 = plotSpread(AggregatedR2_2(nonzeros(selectedPoints(2,:))),'xValues', 2, 'distributionColors',[0.9 0 0],'spreadWidth',1);
        set(h1{1},'MarkerSize',15)
    end 
    xlim([0.5,2.5])
    ylim([0 1])
    set(gca,'FontSize',9,'Linewidth',1)
    
    
    delete(subplot(2,5,2));
    subplot(2,5,2)
    [~,~,~,handle] = MakeSpreadAndBoxPlot3_ECSBTM({AggregatedR2Meaned_1 AggregatedR2Meaned_2},...
    [colors(1) colors(2)],...
    1:2,{name1 name2},'paired',0);
    handles{end +1} = handle;
    title('R2 Meaned')
    if hasSelectedPoints1
        h1 = plotSpread(AggregatedR2Meaned_1(nonzeros(selectedPoints(1,:))),'xValues', 1, 'distributionColors',[0.9 0 0],'spreadWidth',1);
        set(h1{1},'MarkerSize',15)
    end     
    if hasSelectedPoints2
        h1 = plotSpread(AggregatedR2Meaned_2(nonzeros(selectedPoints(2,:))),'xValues', 2, 'distributionColors',[0.9 0 0],'spreadWidth',1);
        set(h1{1},'MarkerSize',15)
    end 
    xlim([0.5,2.5])
    ylim([0 1])
%     text(0.7, median(AggregatedR2Meaned_1), sprintf('%.3f', median(AggregatedR2Meaned_1)), 'FontSize', 8)
%     text(2.03, median(AggregatedR2Meaned_2), sprintf('%.3f', median(AggregatedR2Meaned_2)), 'FontSize', 8)
    set(gca,'FontSize',9,'Linewidth',1)


    for i = 1:length(indexBetas)
        if length(indexBetas) > 3
            indicsp = 2 + mod(i-1,3) + 1 + floor((i-1)/3) * 5;
        else 
            indicsp = [2+i 7+i];
        end
        delete(subplot(4,5,indicsp))
        subplot(4,5,indicsp)
        [a,b,c,handle] = MakeSpreadAndBoxPlot3_ECSBTM({AggregatedBetas(1:MiceNumber1,2*i-1) AggregatedBetas(1:MiceNumber2,2*i)},...
            [colors(1) colors(2)],...
            1:2, {name1 name2}, 'paired',0,'showpoints',1); hold on
        handles{end +1} = handle;
        ylabel('Breathing (Hz)')
%         text(0.7, median(AggregatedBetas(1:MiceNumber1,2*i-1)), sprintf('%.3f', median(AggregatedBetas(1:MiceNumber1,2*i-1))), 'FontSize', 8)
%         text(2.03, median(AggregatedBetas(1:MiceNumber2,2*i)), sprintf('%.3f', median(AggregatedBetas(1:MiceNumber2,2*i))), 'FontSize', 8)
%         
%         text(0.7, min(AggregatedBetas(1:MiceNumber1,2*i-1))-0.3, ['Mean: ' sprintf('%.3f', mean(AggregatedBetas(1:MiceNumber1,2*i-1)))], 'FontSize', 8)
%         text(1.8, min(AggregatedBetas(1:MiceNumber2,2*i))-0.3, ['Mean: ' sprintf('%.3f', mean(AggregatedBetas(1:MiceNumber2,2*i)))], 'FontSize', 8)
        plot([0 3], [0,0], 'k--')
        if hasSelectedPoints1
            h1 = plotSpread(AggregatedBetas(nonzeros(selectedPoints(1,:)),2*i-1),'xValues', 1, 'distributionColors',[0.9 0 0],'spreadWidth',1);
            set(h1{1},'MarkerSize',15)
        end     
        if hasSelectedPoints2
            h1 = plotSpread(AggregatedBetas(nonzeros(selectedPoints(2,:)),2*i),'xValues', 2, 'distributionColors',[0.9 0 0],'spreadWidth',1);
            set(h1{1},'MarkerSize',15)
        end 
        xlim([0.5 2.5])
        title(listPairedPredictors{indexBetas(i)})
        set(gca,'FontSize',10,'Linewidth',1)
    end 

    
    if hasCoef1
        
        nRow = 1 + floor(((MiceNumber1 - 1) / 8));
        for i=1:MiceNumber1 
            subplot(nRow * 4,12,nRow * 24 + mod(i-1,8) + 1 + floor((i-1) / 8) * 12)
            
            set(gca,'Yscale','log')
            imagesc(coef1.SigGT.(Mice1{i})), hold on 
            if hasSelectedPoints1 && ismember(i,selectedPoints(1,:))
                color = 'r';
            else 
                color = 'k';
            end 
            set(gca, 'XTicklabel', [])
            set(gca, 'YTicklabel', [])
            title(Mice1{i}, 'Color', color,'FontSize',8)
            [r,c] = find(coef1.SigGT.(Mice1{i}) == max(max(coef1.SigGT.(Mice1{i}))));
            plot(c,r,'r*')
        end
        
        
        subplot(4,6,17)
        GlobalMapNormalized1 = mean(AggregatedCoefs1, 3);
        imagesc(GlobalMapNormalized1), hold on 
        title(['Global Mean ' name1])
        colorbar('eastoutside')
        [r1,c1] = find(GlobalMapNormalized1 == max(max(GlobalMapNormalized1)));
        plot(c1,r1,'r*')

        subplot(4,6,18)
        imagesc(std(AggregatedCoefs1, [], 3))
        title(['Global Std ' name1])
        colorbar('eastoutside')

    end 

    if hasCoef2
        %MiceN = min([MiceNumber2 16]);
        
        nRow = 1 + floor(((MiceNumber2 - 1) / 8));

        for i=1:MiceNumber2 
            subplot(nRow * 4,12,nRow * 36 + mod(i-1,8) + 1 + floor((i-1) / 8) * 12)

            set(gca,'Yscale','log')
            imagesc(coef2.SigGT.(Mice2{i})), hold on 
            if hasSelectedPoints2 && ismember(i,selectedPoints(2,:))
                color = 'r';
            else 
                color = 'k';
            end 
            set(gca, 'XTicklabel', [])
            set(gca, 'YTicklabel', [])
            title(Mice2{i}, 'Color', color, 'FontSize',8)
            [r,c] = find(coef2.SigGT.(Mice2{i}) == max(max(coef2.SigGT.(Mice2{i}))));
            plot(c,r,'r*')
        end
        subplot(4,6,23)
        GlobalMapNormalized = mean(AggregatedCoefs2, 3);
        imagesc(GlobalMapNormalized), hold on 
        title(['Global Mean ' name2])
        colorbar('eastoutside')
        [r,c] = find(GlobalMapNormalized == max(max(GlobalMapNormalized)));
        plot(c,r,'r*')    

        subplot(4,6,24)
        imagesc(std(AggregatedCoefs2, [], 3))
        title(['Global Std ' name2])
        colorbar('eastoutside')
    end  
    

end

