function DashboardModel_TM_old(model)
%model = GeneralizedLinearModel 
    PredictorTable = model.Variables;
    ObservedY = PredictorTable.OB_FrequencyArray; 
    PredictedY = model.Fitted.Response;
    Betas = model.Coefficients.Estimate;
    PredictorTable.OB_FrequencyArray = [];
    PredictorTable.SigPos = PredictorTable.SigPositionxTimeSinceLastShock ./ PredictorTable.TimeSinceLastShockArray;
    PredictorTable.SigGT = PredictorTable.SigPositionxFit8SigGlocalTime ./ PredictorTable.SigPos;
    
    figure;
    subplot(4,3,[1,4])
    coefObserved = [ones(model.NumObservations,1) PredictorTable.PositionArray] ./ ObservedY; %simple linear regression
    coefPredicted = [ones(model.NumObservations,1) PredictorTable.PositionArray] ./ PredictedY;
    scatter(PredictorTable.PositionArray, ObservedY)
    hold on 
    scatter(PredictorTable.PositionArray, PredictedY)
    plot(PredictorTable.PositionArray,coefObserved(1)+coefObserved(2)*PredictorTable.PositionArray)
    plot(PredictorTable.PositionArray,coefPredicted(1)+coefPredicted(2)*PredictorTable.PositionArray)
    hold off
    
    
    subplot(4,3,[2,5])
    imagesc(corrcoef(table2array(PredictorTable(:,1:end-2))))
    xticks(1:length(model.VariableNames))
    xticklabels(model.VariableNames)
    xtickangle(45)
    yticks(1:length(model.VariableNames))
    yticklabels(model.VariableNames)

    
    subplot(4,3,[3,6])
    
    dataAggrege = [ones(model.NumObservations,1) table2array(PredictorTable)]; %add constant
    colors = {[0.8 0.2 0.2],[0.2 0.8 0.2],[0.2 0.2 0.8],[0.5 0.5 0.2],[0.2 0.5 0.5],[0.5 0.2 0.5],[0.5 0.5 0.5],[0.2 0.8 0.8],[0.5 0.8 0]};
    for i=1:length(Betas)
        ProportionBetaX(:,i) = dataAggrege(:,i)*Betas(i)./PredictedY;
    end
    MakeSpreadAndBoxPlot3_ECSB(ProportionBetaX(1:100:end,:),...
    colors(1:length(Betas)),...
    1:length(Betas),{'Constant', model.VariableNames{:}},'paired',1,'showpoints',0, 'showsigstar', 'none')
    xlim([0.5,length(Betas)+0.5])
    
    
    
    
    subplot(4,3,[7,8,10,11])
    x = 1:length(ObservedY);
    plot(x, ObservedY, 'x'), hold on 
    plot(x, PredictedY, 'o'), hold on
    ylabel('Frequency (Hz)', 'FontSize', 20)

    yyaxis right
    plot(x, PredictorTable.PositionArray)
    plot(x, PredictorTable.SigGT, '-', 'Color', [0.25 0.80 0.54])
    ylabel('Linearized Position', 'FontSize', 20)

    xlabel('Observation', 'FontSize', 20)

    leg=legend({'Train data', 'Fitted value', 'Position', 'SigGlobalTime'}, 'FontSize', 12, 'Location', 'southwest');
    %     leg.ItemTokenSize = [ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+20, ceil((1-time_shift)*length(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(Example_mice_names{mousenum})))*0.2+25];
    leg.ItemTokenSize = [20,10];
    legend boxoff
    
    

end

