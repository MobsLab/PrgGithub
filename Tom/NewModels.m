%Fit 8 sans GlobalTime
coeflearnedFit8CTSF = PipeLineSelectionPred_TM({'PositionArray' 'CumulTimeSpentFreezing' ...
    'TimeSinceLastShockArray' 'SigPositionxTimeSinceLastShock'}, "Fit8CTSF", "learningSigGT");

%Fit 8 sans CumulTimeFreezing
coeflearnedFit8GT = PipeLineSelectionPred_TM({'PositionArray' 'GlobalTimeArray' 'TimeSinceLastShockArray' ...
    'SigPositionxTimeSinceLastShock' }, "Fit8GT", "learningSigGT");

%Fit 8 sans CumulTimeFreezing avec TSF
coeflearnedFit8GTTSF = PipeLineSelectionPred_TM({'PositionArray' 'GlobalTimeArray' 'TimeSinceLastShockArray' ...
    'SigPositionxTimeSinceLastShock' 'TimeSpentFreezing'}, "Fit8GTTSF", "learningSigGT");

%Only essentials 
coeflearnedOnlyEssentials = PipeLineSelectionPred_TM({'SigPositionxTimeSinceLastShock'}, ...
    "OnlyEssentials", "learningSigGT");

%Only essentials2
coeflearnedOnlyEssentials2 = PipeLineSelectionPred_TM({'TimeSinceLastShockArray'}, ...
    "OnlyEssentials2", "learningSigGT");

%Only Intuitive
coeflearnedIntuitive = PipeLineSelectionPred_TM({}, "Intuitive", "learningSigGTxlearningExpTSLS");


%Real Model CumulEntryShock
coefEnrichedCES = PipeLineSelectionPred_TM({'CumulEntryShockZone', 'RipplesDensity'},...
    "EnrichedCES", "learningSigGTxlearningExpTSLS");
%Real Model CumulTimeFreezing
coefEnrichedCTF = PipeLineSelectionPred_TM({'CumulTimeSpentFreezing', 'RipplesDensity'},...
    "EnrichedCTF", "learningSigGTxlearningExpTSLS");
%Real Model EyelidNumber
coefEnrichedEyelid = PipeLineSelectionPred_TM({'EyelidNumber', 'RipplesDensity'},...
    "EnrichedEyelid", "learningSigGTxlearningExpTSLS");

%Intuitive Model CumulEntryShock
coefIntuitiveCES = PipeLineSelectionPred_TM({'CumulEntryShockZone'},...
    "IntuitiveCES", "learningSigGTxlearningExpTSLS");
%Intuitive Model CumulTimeFreezing
coefIntuitiveCTF = PipeLineSelectionPred_TM({'CumulTimeSpentFreezing'},...
    "IntuitiveCTF", "learningSigGTxlearningExpTSLS");
%Intuitive Model EyelidNumber
coefIntuitiveEyelid = PipeLineSelectionPred_TM({'EyelidNumber'},...
    "IntuitiveEyelid", "learningSigGTxlearningExpTSLS");

%Intuitive Model GlobalTime
coefIntuitiveGT = PipeLineSelectionPred_TM({'GlobalTimeArray'},...
    "IntuitiveGT", "learningSigGTxlearningExpTSLS");


GuiDashboard_TM(DATAtable, Models.Fit8CTSF, "Fit8 CumulativeTime", coeflearnedFit8CTSF)
GuiDashboard_TM(DATAtable, Models.Fit8GT, "Fit8 GlobalTime", coeflearnedFit8GT)
GuiDashboard_TM(DATAtable, Models.Fit8GTTSF, "Fit8 GT & TimeSpentFreezing", coeflearnedFit8GTTSF)
GuiDashboard_TM(DATAtable, Models.OnlyEssentials, "OnlyEssentials", coeflearnedOnlyEssentials)
GuiDashboard_TM(DATAtable, Models.OnlyEssentials2, "OnlyEssentials2", coeflearnedOnlyEssentials2)

GuiDashboard_TM(DATAtable, Models.Intuitive, "Intuitive", coeflearnedIntuitive)

GuiDashboard_TM(DATAtable, Models.EnrichedCES, "EnrichedCES", coefEnrichedCES)
GuiDashboard_TM(DATAtable, Models.EnrichedCTF, "EnrichedCTF", coefEnrichedCTF)
GuiDashboard_TM(DATAtable, Models.EnrichedEyelid, "EnrichedEyelid", coefEnrichedEyelid)

GuiDashboard_TM(DATAtable, Models.IntuitiveCES, "IntuitiveCES", coefIntuitiveCES)
GuiDashboard_TM(DATAtable, Models.IntuitiveCTF, "IntuitiveCTF", coefIntuitiveCTF)
GuiDashboard_TM(DATAtable, Models.IntuitiveEyelid, "IntuitiveEyelid", coefIntuitiveEyelid)


GuiDashboard_TM(DATAtable, Models.ConstraintsIntuitive, "ConstraintsIntuitive")


