PanelLinearModel(DATAtableCleared, Models.FinalAnalysis, 'FinalAnalysis')
PanelLinearModel(DATAtableCleared, Models.Analysis, 'Analysis')
PanelLinearModel(DATAtableCleared, Models.FinalAnalysisCES, 'FinalAnalysisCES')
PanelLinearModel(DATAtableCleared, Models.FinalAnalysisGT, 'FinalAnalysisGT')
PanelLinearModel(DATAtableCleared, Models.SigCES, 'SigCES')
PanelLinearModel(DATAtableCleared, Models.Fit8PreviousModel, 'Fit8PreviousModel')



BetaSigGT = -1.273; 
BetaExpTSLS = 1.277;
Constant = 4;

for i = 1:MiceNumber 
    Prediction.(FinalGlobal).(Mice{i}) = Constant + ...
        BetaExpTSLS * DATAtable.(Mice{i}).ExpTimesSinceLastShockGeneral + ...
        BetaSigGT * DATAtable.(Mice{i}).SigPostionxSigGlobalTimeGeneral;
end 


PipeLineSelectionPreditors( ,[BetaExpTSLS, 'ExpTimeSincelastShock'])

for i = 1 : length(Offsets)
    Offset = Offset + Offsets(i,1) * DATAtable.(Mice{i}).(Offsets(i,2));
end 