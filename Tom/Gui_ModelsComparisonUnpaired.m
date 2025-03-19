function Gui_ModelsComparisonUnpaired(structModels1, structModels2, name1, name2, Mice1, Mice2, coef1, coef2)
%GUI_MODELSCOMAPRISONUNPAIRED Summary of this function goes here
    
    %Selection of The Predicted value 
    if any("OB_Frequency" == string(structModels1.(Mice1{1}).Variables.Properties.VariableNames))
        OBFreq = 'OB_Frequency';
    elseif any("OBFrequencySafe" == string(structModels1.(Mice1{1}).Variables.Properties.VariableNames))
        OBFreq = 'OBFrequencySafe';
    else 
        warning('OB Frequency was not found in predictor table')
    end 

    NamePred1 = structModels1.(Mice1{1}).Variables.Properties.VariableNames;
    NamePred2 = structModels2.(Mice2{1}).Variables.Properties.VariableNames;
    NamePred1(strcmp(NamePred1, OBFreq)) = [];
    NamePred2(strcmp(NamePred2, OBFreq)) = [];
    NamePred1 = ['Constant' NamePred1];
    NamePred2 = ['Constant' NamePred2];
    listPairedPredictors = cell(length(NamePred1)*length(NamePred2), 1);
    for i = 1:length(NamePred1)
        for j = 1:length(NamePred2)
            listPairedPredictors{(i-1)*length(NamePred2)+j} = [NamePred1{i} ' - ' NamePred2{j}];
        end 
    end 
    
    [indexBetas,~] = listdlg('ListString',listPairedPredictors);

    global handles
    
    handles.(strrep(name1+name2, ' ', '')) = ModelsComparisonUnpaired(structModels1, structModels2, name1, name2, Mice1, Mice2, coef1, coef2, 1, [], indexBetas);

    btnSelect = uicontrol('Style', 'pushbutton', 'String', 'Select Points', 'Position', [40, 40, 120, 40], 'Callback', @SelectCallBack);

    function SelectCallBack(~,~)
        indx = [];
        for k = 1:length(handles.(strrep(name1+name2, ' ', '')))
            h = handles.(strrep(name1+name2, ' ', ''));
            children1 = h{1,k}{1,1}{1,3}.Children;
            for l = 1:length(children1)
                
                if get(children1(l), 'Type') == "line"
                    XData = get(children1(l), 'XData');
                    if length(XData) == length(Mice1)
                        brush = get(children1(l), 'BrushData');
                        if ~isempty(find(logical(brush), 1))
                            indx(1, end+1:end+length(find(logical(brush)))) = find(logical(brush));
                        end 
                    end 
                end 
            end 
            
            children2 = h{1,k}{1,2}{1,3}.Children;
            for l = 1:length(children2)
                if get(children2(l), 'Type') == "line"
                    XData = get(children2(l), 'XData');
                    if length(XData) == length(Mice2)
                        brush = get(children2(l), 'BrushData');
                        if ~isempty(find(logical(brush), 1))
                            indx(2, end+1:end+length(find(logical(brush)))) = find(logical(brush));
                        end 
                    end 
                end 
            end
        end 
        
        disp(indx)
        
        handles.(strrep(name1+name2, ' ', '')) = ModelsComparisonUnpaired(structModels1, structModels2, name1, name2, Mice1, Mice2, coef1, coef2, 0, indx, indexBetas);
    end 
    

end

