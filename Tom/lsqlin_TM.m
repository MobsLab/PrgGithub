function model = lsqlin_TM(predictors,observation,constraintMatrix,constraintVector)
%LSQLIN_TM fit of lsqlin function with a LinearModelTM in Response
%All inputs are the same as in lsqlin EXCEPT that predictors and
%observation should be table
%Output is a LinearModelTM object corresponding to input
    opts = optimoptions(@lsqlin, 'Display', 'off');
    [coefficients, ~, residuals] = lsqlin(table2array(predictors), ...
        table2array(observation), constraintMatrix, constraintVector, ...
        [],[],[],[],[],opts);
    prediction = residuals + table2array(observation);
    variables = [predictors observation];
    if any("Constant" == string(variables.Properties.VariableNames))
        variables.Constant = [];
    end 
    [R2Ordinary, ~] = ErrorPredExactAndMean(table2array(observation), prediction);
    model = LinearModelTM(variables,prediction,coefficients,R2Ordinary);
end

