%% Tracer les spectres individuels avec styles différents pour contrôles et mutants

% Couleurs pour chaque souris
colors = lines(length(P)); % Palette de couleurs distinctes

figure('Name', 'Spectres individuels des souris (Somato, Wake)', 'Position', [100, 100, 1200, 600]);

% Tracer les spectres pour chaque souris
for i = 1:length(P)
    % Extraire le nom de la souris depuis le chemin
    [~, mouse_name] = fileparts(P{i}); 
    
    % Vérifier si la souris est un contrôle ou un mutant
    if i <= 9
        line_style = '-'; % Contrôles en ligne pleine
    else
        line_style = '--'; % Mutants en pointillés
    end
    
    % Tracer le spectre individuel
    hold on;
    plot(Range_Middle, Range_Middle' .* Somato_MeanSp_Wake(i, :)', ...
        'Color', colors(i, :), 'LineWidth', 1.5, 'LineStyle', line_style, ...
        'DisplayName', mouse_name);
end

% Personnaliser le graphique
xlim([20 100]); % Limites de fréquence
set(gca, 'YScale', 'log'); % Échelle logarithmique pour l'axe Y
xlabel('Frequency (Hz)', 'FontSize', 12);
ylabel('Power (a.u.)', 'FontSize', 12);
title('Spectres individuels des souris (Somato, Wake)', 'FontSize', 16);
legend('Location', 'northeastoutside'); % Position de la légende
box off;
hold off;