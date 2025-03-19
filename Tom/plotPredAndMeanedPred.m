function plotPredAndMeanedPred(observed,predicted, MouseName)
% observed, predicted = double array same size 
% plot observed points, predcited ones and meaned predicted ones 
    colors = {[0 0.4470 0.7410] [0.8500 0.3250 0.0980] [0.9290 0.6940 0.1250]...
        [0.4940 0.1840 0.5560] [0.4660 0.6740 0.1880] [0.3010 0.7450 0.9330]...
        [0.6350 0.0780 0.1840] [1 0.2706 0.2274] [0.3725 0.5176 0.9921] [1 0.8351 0.0274]...
        [0 0.6392 0.6392] [0.8039 0.5176 0.3764]};

    meanedObserved = movmean(observed, 8);
    [R2_Exact,R2_Meaned] = ErrorPredExactAndMean(observed,predicted);
    figure;
    plot(observed, "x", 'Color', colors{1}), hold on 
    plot(meanedObserved, "x", 'Color', colors{2})
    plot(predicted, 'o', 'Color', colors{3})
    ylabel("OB Frequency")
    xlabel("Observations")
    title(MouseName + ' - R^2 Exact : ' + num2str(R2_Exact) + ' - R^2 Meaned : ' + num2str(R2_Meaned))
    hold off
end

