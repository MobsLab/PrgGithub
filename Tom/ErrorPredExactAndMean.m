function [R2_Exact,R2_Meaned] = ErrorPredExactAndMean(Obs,Pred)
%ERRORPREDICTIONEXACT&MEAN return R2 entre observation et prédiction 
%[R2_Exact, R2_Meaned] = double, double (entre -1 et 1)
%pour R2_meaned, moyenne glissante de pas 8 
    R2_Exact = 1 - sum((Obs - Pred).^2) / sum((Obs - mean(Obs)).^2);
    MeanedObs = movmean(Obs, 8);
    R2_Meaned = 1 - sum((MeanedObs - Pred).^2) / sum((MeanedObs - mean(MeanedObs)).^2);
end

