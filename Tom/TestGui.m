global currentDataIndex x y ax

% Création des données
x = 1:10;
y = rand(10, 2);

% Initialisation de l'index des données

currentDataIndex = 1;

% Création de la figure
fig = figure('Name', 'Graphique avec Flèches', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

% Création de l'axe du graphique
ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.8, 0.8]);

% Affichage initial des données
plot(ax, x, y(:, currentDataIndex), 'o-');
title(ax, ['Données ', num2str(currentDataIndex)]);

% Création des boutons de navigation
btnPrev = uicontrol('Style', 'pushbutton', 'String', 'Précédent', 'Position', [20, 20, 80, 30], 'Callback', @prevCallback);
btnNext = uicontrol('Style', 'pushbutton', 'String', 'Suivant', 'Position', [120, 20, 80, 30], 'Callback', @nextCallback);

% Fonction de rappel pour le bouton "Précédent"
function prevCallback(~, ~)
    global currentDataIndex 
    if currentDataIndex > 1
        currentDataIndex = currentDataIndex - 1;
        updatePlot();
    end
end

% Fonction de rappel pour le bouton "Suivant"
function nextCallback(~, ~)
    global currentDataIndex y 
    if currentDataIndex < size(y,2)
        currentDataIndex = currentDataIndex + 1;
        updatePlot();
    end
end

% Fonction pour mettre à jour le graphique
function updatePlot()
    global currentDataIndex x y ax
    plot(ax, x, y(:, currentDataIndex), 'o-');
    title(ax, ['Données ', num2str(currentDataIndex)]);
end
