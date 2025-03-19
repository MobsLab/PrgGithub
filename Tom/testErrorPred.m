MiceError = {"M688", "M739", "M849","M1394"};
for i = 1:length(MiceError)
    MouseName = MiceError{i};
    model = Models.Fit8_id.(MouseName);
    observed = model.Variables.OB_FrequencyArray;
    meanedObserved = movmean(observed, 5);
    predicted = model.Fitted.Response;
    [R2_Exact,R2_Meaned] = ErrorPredExactAndMean(observed,predicted);
    figure;
    plot(observed, "gx"), hold on 
    plot(meanedObserved, "bx")
    plot(predicted, 'ro')
    ylabel("OB Frequency")
    xlabel("Observations")
    title([MouseName + ' - R^2 Exact : ' + num2str(R2_Exact) + ' - R^2 Meaned : ' + num2str(R2_Meaned)])
    hold off
end 