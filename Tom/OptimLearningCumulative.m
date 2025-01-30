global Models

coefLearningCumulative = PipeLineSelectionPred_TM(DATAtable, {'ExpTimeSinceLastShockGlobal'}, ...
    'LearningCumulative', 'learningCumulative');

GuiDashboard_TM(DATAtable, Models.LearningCumulative, 'LearningCumulative', coefLearningCumulative);