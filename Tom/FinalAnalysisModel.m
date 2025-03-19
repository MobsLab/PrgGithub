global DATAtable 
global Models 


coefFinalAnalysisCES = PipeLineSelectionPred_TM(DATAtable, {'CumulEntryShockZone', 'ExpTimeSinceLastShockGlobal'},...
    "FinalAnalysisCES", "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtable, Models.FinalAnalysisCES, "FinalAnalysisCES", coefFinalAnalysisCES)


coefFinalAnalysisCESFixed = PipeLineSelectionPred_TM(DATAtable, {'CumulEntryShockZone', 'ExpTimeSinceLastShockGlobal'},...
    "FinalAnalysisCESFixed", "fixedConstantxlearningSigGT");

GuiDashboard_TM(DATAtable, Models.FinalAnalysisCESFixed, "FinalAnalysisCESFixed", coefFinalAnalysisCESFixed)


coefFinalAnalysisFixed = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'},...
    "FinalAnalysisFixed", "fixedConstantxlearningSigGT");

GuiDashboard_TM(DATAtableCleared, Models.FinalAnalysisFixed, "FinalAnalysisFixed", coefFinalAnalysisFixed)




coefFinalAnalysisGT = PipeLineSelectionPred_TM(DATAtable, {'GlobalTime', 'ExpTimeSinceLastShockGlobal'},...
    "FinalAnalysisGT", "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtable, Models.FinalAnalysisGT, "FinalAnalysisGT", coefFinalAnalysisGT)


coefFinalAnalysis = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'}, ...
    "FinalAnalysis", "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtableCleared, Models.FinalAnalysis, "FinalAnalysis", coefFinalAnalysis)


coefFinalFullLearn = PipeLineSelectionPred_TM(DATAtableCleared, {},...
    "FinalFullLearn", "constraintsxlearningSigGTxlearningExpTSLS");

GuiDashboard_TM(DATAtableCleared, Models.FinalFullLearn, "FinalFullLearn", coefFinalFullLearn)

GuiDashboard_TM(DATAtable, Models.FinalFullLearnCES, "FinalFullLearnCES", coefFinalFullLearnCES)


%Remove outliers 'M425';'M1147';'M1170';
MouseToRemove = {'M425';'M1147';'M1170'};
Mice = {'M404';'M437';'M439';'M469';'M471';'M483';'M484';'M485';'M490';'M507';'M508';'M509';'M510';'M512';'M514';'M561';'M567';'M568';'M566';'M688';'M739';'M777';'M779';'M849';'M893';'M1096';'M1144';'M1146';'M1171';'M9184';'M1189';'M9205';'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};
MiceNumber = length(Mice);
DATAtableCleared = rmfield(DATAtable, MouseToRemove);
Models.FinalAnalysisGTCleared = rmfield(Models.FinalAnalysisGT, MouseToRemove);
Models.FinalAnalysisCESCleared = rmfield(Models.FinalAnalysisCES, MouseToRemove);
coefFinalAnalysisGTCleared.SigGT = rmfield(coefFinalAnalysisGT.SigGT, MouseToRemove);
coefFinalAnalysisCESCleared.SigGT = rmfield(coefFinalAnalysisCES.SigGT, MouseToRemove);

GuiDashboard_TM(DATAtableCleared, Models.FinalAnalysisGTCleared, "FinalAnalysisGTCleared", coefFinalAnalysisGTCleared)
GuiDashboard_TM(DATAtableCleared, Models.FinalAnalysisCESCleared, "FinalAnalysisCESCleared", coefFinalAnalysisCESCleared)

%Automated Removal of outliers 
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableCleared = DATAtable;
Mice = fieldnames(DATA.Cond);
MiceNumber = length(Mice);
MiceCleared = {};
for i=1:MiceNumber 
    %disp([Mice{i} ' : ' num2str(height(DATAtable.(Mice{i}))) ', ' num2str(sum(DATAtable.(Mice{i}).Position > thresholdIsSafe))])
    if height(DATAtable.(Mice{i})) < thresholdNumObservation  
        DATAtableCleared = rmfield(DATAtableCleared, Mice{i}); 
        disp(['Removal of ' Mice{i} ' : Lack of points (' num2str(height(DATAtable.(Mice{i}))) ')'])
    elseif sum(DATAtable.(Mice{i}).Position > thresholdIsSafe) < thresholdFreezSafeExistence
        DATAtableCleared = rmfield(DATAtableCleared, Mice{i}); 
        disp(['Removal of ' Mice{i} ' : Not Enough Freeze Safe (' num2str(sum(DATAtable.(Mice{i}).Position > thresholdIsSafe)) ')'])
    else
        MiceCleared{end+1} = Mice{i};
    end 

end 

%Automated Removal of outliers for WaveLet Mouse
thresholdNumObservation = 50;
thresholdIsSafe = 0.5;
thresholdFreezSafeExistence = 10;
DATAtableClearedWV = DATAtableWV;
Mice = fieldnames(DATA.Cond);
MiceWVNumber = length(MiceWV);
MiceWVCleared = {};
for i=1:MiceWVNumber 
    %disp([MiceWV{i} ' : ' num2str(height(DATAtable.(MiceWV{i}))) ', ' num2str(sum(DATAtable.(MiceWV{i}).Position > thresholdIsSafe))])
    if height(DATAtableWV.(MiceWV{i})) < thresholdNumObservation  
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Lack of points (' num2str(height(DATAtableWV.(MiceWV{i}))) ')'])
    elseif sum(DATAtableWV.(MiceWV{i}).Position > thresholdIsSafe) < thresholdFreezSafeExistence
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Not Enough Freeze Safe (' num2str(sum(DATAtableWV.(MiceWV{i}).Position > thresholdIsSafe)) ')'])
    elseif size(DATAtableWV.(MiceWV{i}),1) ~=  size(DATAtable.(MiceWV{i}),1)
        DATAtableClearedWV = rmfield(DATAtableClearedWV, MiceWV{i}); 
        disp(['Removal of ' MiceWV{i} ' : Not the same Array Size (' num2str([size(DATAtableWV.(MiceWV{i}),1)  size(DATAtable.(MiceWV{i}),1)]) ')'])
    
    else
        MiceWVCleared{end+1} = MiceWV{i};
    end 

end 


model = Models.FinalAnalysisCES;
thresholdPosition = 0.25;
BetaConstant = zeros(MiceNumber,1);
MeanOBShock = zeros(MiceNumber,1);
for i = 1:MiceNumber
    BetaConstant(i) = model.(Mice{i}).Coefficients.Estimate(1);
    MeanOBShock(i) = mean(DATAtable.(Mice{i}).OB_FrequencyArray(...
        DATAtable.(Mice{i}).PositionArray <= thresholdPosition));
end 

figure;
plot(BetaConstant, MeanOBShock, 'x')
xlabel("Model Constant")
ylabel("Mean OB Shock")
xlim([3 6])
ylim([3 6])






%
MN = length(Mouse);
for i = 1:MN
    MouseName = ['M' num2str(Mouse(i))];
    if find(strcmp(fieldnames(DATAtable), MouseName))
        DATAtable.(MouseName).GlobalTimeReduced = round(DATAtable.(MouseName).GlobalTime) ...
        - mod(round(DATAtable.(MouseName).GlobalTime), 2);
        DATAtable.(MouseName).EyelidDensityBM = EyelidNumber_Tom{1,i}(DATAtable.(MouseName).GlobalTimeReduced/2)';
        DATAtable.(MouseName).CumulEntryShockZoneDensityBM = SZEntriesNumber_Tom{1,i}(DATAtable.(MouseName).GlobalTimeReduced/2)';
    end 
end 



coefEssentialDensity = PipeLineSelectionPred_TM(DATAtableCleared, {'EyelidDensityBM',...
    'CumulEntryShockZoneDensityBM','ExpTimeSinceLastShockGlobal'}, 'EssentialDensity', ...
    "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtableCleared, Models.EssentialDensity, "EssentialDensity", coefEssentialDensity)


coefSigCES = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'},...
    'SigCES', "constraintsxlearningSigCES");

GuiDashboard_TM(DATAtableCleared, Models.SigCES, "SigCES", coefSigCES)



global DATAtableDZP

coefFinalAnalysisDZP = PipeLineSelectionPred_TM(DATAtableDZP, {'ExpTimeSinceLastShockGlobal'}, ...
    "FinalAnalysisDZP", "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtableDZP, Models.FinalAnalysisDZP, "FinalAnalysisDZP", coefFinalAnalysisDZP)

Gui_ModelsComparisonUnpaired(Models.FinalAnalysisDZP, Models.FinalAnalysis, ...
    "Optim GT DZP", "Optim GT Saline", MiceDZP, MiceCleared, coefFinalAnalysisDZP, coefFinalAnalysis)



coefAnalysisDZPOld = PipeLineSelectionPred_TM(DATAtableDZP, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisDZPOld", "learningSigGT");

coefAnalysisDZP = PipeLineSelectionPred_TM(DATAtableDZP, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisDZP", "noConstraintsxlearningSigGT");

coefAnalysisDZPCorrected = PipeLineSelectionPred_TM(DATAtableDZP, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisDZPCorrected", "noConstraintsxlearningSigGTxcorrection");


Gui_ModelsComparison(DATAtableDZP, Models.AnalysisDZPOld, Models.AnalysisDZP, ...
    "DZP Old", "DZP", coefAnalysisDZPOld, coefAnalysisDZP)

Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.AnalysisDZPCorrected, ...
    "DZP", "DZP Corrected", MiceDZP, MiceDZP, coefAnalysisDZP, coefAnalysisDZPCorrected)

Gui_ModelsComparison(DATAtableDZP, Models.AnalysisDZP, Models.AnalysisDZPCorrected, ...
    "DZP", "DZP Corrected", coefAnalysisDZP, coefAnalysisDZPCorrected)

GuiDashboard_TM(DATAtableDZP, Models.AnalysisDZP, "AnalysisDZP", coefAnalysisDZP)

GuiDashboard_TM(DATAtableDZP, Models.AnalysisDZPCorrected, "AnalysisDZPCorrected", coefAnalysisDZPCorrected)

Gui_ModelsComparison(DATAtableDZP, Models.FinalAnalysisDZP, Models.AnalysisDZP, ...
    "Optim GT DZP Constraint", "Optim GT DZP", coefFinalAnalysisDZP, coefAnalysisDZP)

Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.FinalAnalysis, ...
    "Optim GT DZP NoConstraints", "Optim GT Saline", MiceDZP, MiceCleared, coefAnalysisDZP, coefFinalAnalysis)

Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.AnalysisCorrected, ...
    "DZP", "Saline Corrected", MiceDZP, MiceCleared, coefAnalysisDZP, coefAnalysisCorrected)




coefAnalysis = PipeLineSelectionPred_TM(DATAtable, {'ExpTimeSinceLastShockGlobal'}, ...
    "Analysis", "noConstraintsxlearningSigGT");

Gui_ModelsComparison(DATAtable, Models.FinalAnalysis, Models.Analysis, ...
    "OptimGT Saline", "OptimGT NoC Saline", coefFinalAnalysis, coefAnalysis)

GuiDashboard_TM(DATAtableCleared, Models.Analysis, "Analysis", coefAnalysis)

GuiDashboard_TM(DATAtableCleared, Models.AnalysisLSQLIN, "AnalysisLSQLIN", coefAnalysisLSQLIN)



coefAnalysisLSQLIN = PipeLineSelectionPred_TM(DATAtable, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisLSQLIN", "noConstraintsxlearningSigGT");

Gui_ModelsComparison(DATAtable, Models.Analysis, Models.AnalysisLSQLIN, ...
    "No Contraints FITGLM", "No Contraints LSQLIN", coefAnalysis, coefAnalysisLSQLIN)



coefFinalFullLearnDZP = PipeLineSelectionPred_TM(DATAtableDZP, {},...
    "FinalFullLearnDZP", "constraintsxlearningSigGTxlearningExpTSLS");

GuiDashboard_TM(DATAtableDZP, Models.FinalFullLearnDZP, 'FinalFullLearnDZP', coefFinalFullLearnDZP)


coefFinalAnalysisWV = PipeLineSelectionPred_TM(DATAtableWV, {'ExpTimeSinceLastShockGlobal'}, ...
    "FinalAnalysisWV", "constraintsxlearningSigGT");

GuiDashboard_TM(DATAtableClearedWV, Models.FinalAnalysisWV, 'FinalAnalysisWV', coefAnalysisLSQLIN)

Gui_ModelsComparison(DATAtableClearedWV, Models.FinalAnalysisWV, Models.FinalAnalysis, 'Wavelet Method', ...
    'Spectro Method', coefAnalysisLSQLIN, coefFinalAnalysis)

coefAnalysisWV = PipeLineSelectionPred_TM(DATAtableWV, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisWV", "noConstraintsxlearningSigGTxcorrection");

GuiDashboard_TM(DATAtableWV, Models.AnalysisWV, 'AnalysisWV', coefAnalysisWV)


coefAnalysisSBF = PipeLineSelectionPred_TM(DATAtableSBF, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisSBF", "noConstraintsxlearningSigGTxcorrection");

GuiDashboard_TM(DATAtableSBF, Models.AnalysisSBF, 'AnalysisSBF', coefAnalysisSBF)


for i = 1:length(MiceDZP)
    disp([MiceDZP{i} ' - ' num2str(max(DATAtableDZP.(MiceDZP{i}).EyelidNumber))])
end 



MiceDZP = fieldnames(DATAtableDZP);
Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.FinalAnalysisDZP, ...
    "DZP NoConstraints", "DZP", MiceDZP, MiceDZP, coefAnalysisDZP, coefFinalAnalysisDZP)


Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.Analysis, ...
    "Optim GT DZP NoC", "Optim GT Saline NoC", MiceDZP, MiceCleared, coefAnalysisDZP, coefAnalysis)


Gui_ModelsComparison(DATAtableCleared, FullLearning.Models.FinalFullLearn, Models.FinalAnalysis, ...
    "Optim ExpTSLS", "Fixed ExpTSLS")


MiceShortEyelid = {'M1171' 'M1189'   'M1392' 'M1394'}; %'M1251' 'M1253' 'M1254'  %'M1144'  
%Removal because lack of points : 'M1147' 'M1170' 'M9205' 
Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.Analysis, ...
    "DZP", "Saline Eyelid Short", MiceDZP, MiceShortEyelid, coefAnalysisDZP, coefAnalysis)

Gui_ModelsComparisonUnpaired(Models.AnalysisDZP, Models.AnalysisCorrected, ...
    "DZP", "Saline Short Corrected", MiceDZP, MiceShortEyelid, coefAnalysisDZP, coefAnalysisCorrected)

Gui_ModelsComparisonUnpaired(Models.AnalysisCorrected, Models.AnalysisCorrected, ...
    "DZP", "Saline Short Corrected", MicePAG, MicePAG, coefAnalysisCorrected, coefAnalysisCorrected)



Gui_ModelsComparison(DATAtablePAG, Models.FinalAnalysis, Models.TowardGeneralPAG, ...
    "Optim SigGT", "Fixed SigGT PAG", coefFinalAnalysis)


Gui_ModelsComparison(DATAtableCleared, Models.FinalAnalysis, Models.TowardGeneralGlobal, ...
    "Optim SigGT", "Fixed SigGT")






coefFit8 = PipeLineSelectionPred_TM(DATAtableCleared, {'Position' 'GlobalTime' ...
    'TimeSinceLastShock' 'CumulTimeSpentFreezing' 'SigPositionxTimeSinceLastShock'}, ...
    "Fit8PreviousModel", "learningSigGT");






coefAnalysisCorrected = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisCorrected", "noConstraintsxlearningSigGTxcorrection");
GuiDashboard_TM(DATAtableCleared, Models.AnalysisCorrected, "AnalysisCorrected", coefAnalysisCorrected)
Gui_ModelsComparison(DATAtableCleared, Models.AnalysisCorrected, Models.Analysis, ...
    "Correction", "Before Correction", coefAnalysisCorrected, coefAnalysis)

Gui_ModelsComparisonUnpaired(Models.AnalysisCorrected, Models.Analysis, ...
    "Correction", "Before Correction", MiceCleared, MiceCleared, coefAnalysisCorrected, coefAnalysis)


coefMeanEpisod = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'}, ...
    "MeanEpisod", "noConstraintsxlearningSigGTxcorrection");


GuiDashboard_TM(DATAtableCleared, Models.MeanEpisod, "MeanEpisod", coefMeanEpisod)


coefWithoutExp = PipeLineSelectionPred_TM(DATAtableCleared, {'TimeSinceLastShock'}, ...
    "WithoutExp", "noConstraintsxlearningSigGTxcorrection");

PanelLinearModel(DATAtableCleared, Models.WithoutExp, 'WithoutExp')


PanelLinearModel(DATAtableDZP, Models.AnalysisDZP, 'AnalysisDZP')


Gui_ModelsComparisonUnpaired(Models.AnalysisCorrected,Models.AnalysisDZPCorrected,  ...
    "Saline", "Diazepam",  MiceEyelidCleared, MiceDZP, coefAnalysisCorrected, coefAnalysisDZPCorrected)
