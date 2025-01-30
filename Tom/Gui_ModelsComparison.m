function Gui_ModelsComparison(DATAtable, structModels1, structModels2, name1, name2, coef1, coef2)
%UNTITLED Summary of this function goes here

    if nargin < 7
        coef2 = struct([]);
    end 
    if nargin < 6
        coef1 = struct([]);
    end 
    
    %Remove Mice that don't appear in both models
    MiceModel1 = fieldnames(structModels1);
    MiceModel2 = fieldnames(structModels2);
    Mice = {};
    for i = 1:length(MiceModel1)
        if any(~cellfun('isempty',(strfind(MiceModel2, MiceModel1{i}))))
            Mice{end+1} = MiceModel1{i};
        else 
            disp(['Warning : '  MiceModel1{i} ' not in model2'])
        end 
    end 
    for i = 1:length(Mice)
        if ~any(~cellfun('isempty',(strfind(MiceModel2, Mice{i}))))
            disp(['Warning : '  Mice{i} ' not in model1'])
        end 
    end 
    
    %Selection of The Predicted value 
    if any("OB_Frequency" == string(structModels1.(Mice{1}).Variables.Properties.VariableNames))
        OBFreq = 'OB_Frequency';
    elseif any("OBFrequencySafe" == string(structModels1.(Mice{1}).Variables.Properties.VariableNames))
        OBFreq = 'OBFrequencySafe';
    else 
        warning('OB Frequency was not found in predictor table')
    end 
    
    
    %Select Only Several Interactions Between Coefficients of Predictors
    NamePred1 = structModels1.(Mice{1}).Variables.Properties.VariableNames;
    NamePred2 = structModels2.(Mice{1}).Variables.Properties.VariableNames;
    NamePred1(strcmp(NamePred1, OBFreq)) = [];
    NamePred2(strcmp(NamePred2, OBFreq)) = [];
    NamePred1 = ['Constant' NamePred1];
    NamePred2 = ['Constant' NamePred2];
    listPairedPredictors = cell(length(NamePred1)*length(NamePred2), 1);
    for i = 1:length(NamePred1)
        for j = 1:length(NamePred2)
            listPairedPredictors{(i-1)*length(NamePred2)+j} = [NamePred1{i} '-' NamePred2{j}];
        end 
    end 
    [indexBetas,~] = listdlg('ListString',listPairedPredictors);
    
    %initial Load
    ModelsComparison(DATAtable, structModels1, structModels2, name1, name2, coef1, coef2, Mice, Mice{1},indexBetas,OBFreq,1)
    
    % PopUpMenu to select the mouse
    MenuSelection = uicontrol('Style', 'popupmenu', 'String', Mice, 'Position', [20, 20, 80, 120], 'Callback', @SelectMouse);
    
    %Function associated to popupmenu to select 
    function SelectMouse(~, ~)
        iMouse = MenuSelection.Value;
        ModelsComparison(DATAtable, structModels1, structModels2, name1, name2, coef1, coef2, Mice, Mice{iMouse}, indexBetas, OBFreq,0)
    end 
end

