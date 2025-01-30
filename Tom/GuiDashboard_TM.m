function GuiDashboard_TM(DATAtable, Models, Name, LearnedParams)
    
    % Test d'existence de l'argument LearnedParams
    if nargin < 4
        LearnedParams = struct([]);
    end 

    % Initialisation de l'index des données
    currentDataIndex = 1;

    ModelStructure = Models;
    Mice1 = fieldnames(DATAtable);
    Mice2 = fieldnames(Models);
    if length(Mice1) <= length(Mice2)
        Mice = Mice1;
    else 
        Mice = Mice2;
    end 
    DashboardModel_TM(DATAtable, Models, Mice{currentDataIndex}, Name, 1, LearnedParams, 'Observation');
    
    % Création des boutons de navigation
    btnPrev = uicontrol('Style', 'pushbutton', 'String', 'Précédent', 'Position', [20, 20, 80, 30], 'Callback', @prevCallback);
    btnNext = uicontrol('Style', 'pushbutton', 'String', 'Suivant', 'Position', [120, 20, 80, 30], 'Callback', @nextCallback);
    btnXGlobal = uicontrol('Style', 'popupmenu', 'String', {"Observation", "GlobalTime"}, 'Position', [40, 60, 120, 40], 'Callback', @updatePlot);

    
    % Fonction de rappel pour le bouton "Précédent"
    function prevCallback(~, ~)        
        if currentDataIndex > 1
            currentDataIndex = currentDataIndex - 1;
            updatePlot();
        end
    end

    % Fonction de rappel pour le bouton "Suivant"
    function nextCallback(~, ~)        
        if currentDataIndex < length(Mice)
            currentDataIndex = currentDataIndex + 1;
            updatePlot();
        end
    end

    % Fonction pour mettre à jour le graphique
    function updatePlot(~, ~)
        str = btnXGlobal.String;
        val = btnXGlobal.Value;
        DashboardModel_TM(DATAtable, ModelStructure, Mice{currentDataIndex},Name, 0, LearnedParams, str{val})
    end

end


