function PlotSleepEvolution(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise)
    % PlotSleepEvolution : Trace un hypnogramme des états de sommeil (WakeWiNoise, SWS, REM)
    %
    % Inputs :
    % - WakeWiNoise : périodes d'éveil
    % - SWSEpochWiNoise : périodes de sommeil lent profond
    % - REMEpochWiNoise : périodes de sommeil paradoxal
    %
    % Cette fonction crée un graphique où les états sont codés sur une échelle verticale.

    % Déterminer les limites temporelles globales
    start_time = min([Start(WakeWiNoise, 's'); Start(SWSEpochWiNoise, 's'); Start(REMEpochWiNoise, 's')]);
    end_time = max([End(WakeWiNoise, 's'); End(SWSEpochWiNoise, 's'); End(REMEpochWiNoise, 's')]);
    
    % Créer un vecteur temporel à résolution fixe (par ex., 1 seconde)
    time_resolution = 1; % Résolution en secondes
    time_vector = start_time:time_resolution:end_time;
    
    % Initialiser un vecteur pour les états (par défaut : bruit ou non-classifié)
    state_vector = -1 * ones(size(time_vector)); % -1 : Non-classifié

    % Affecter les états en fonction des périodes
    for i = 1:length(time_vector)
        t = time_vector(i); % Temps actuel

        % Vérifier si le temps appartient à une période WakeWiNoise
        if any(t >= Start(WakeWiNoise, 's') & t <= End(WakeWiNoise, 's'))
            state_vector(i) = 4; % WakeWiNoise
        end
        
        % Vérifier si le temps appartient à une période SWS
        if any(t >= Start(SWSEpochWiNoise, 's') & t <= End(SWSEpochWiNoise, 's'))
            state_vector(i) = 1; % SWS
        end

        % Vérifier si le temps appartient à une période REM
        if any(t >= Start(REMEpochWiNoise, 's') & t <= End(REMEpochWiNoise, 's'))
            state_vector(i) = 3; % REM
        end
    end

    % Créer la figure
    figure('Color', [1 1 1]);
    hold on;

    % Tracer les états en fonction du temps
    plot(time_vector, state_vector, 'k', 'LineWidth', 2); % Ligne principale

    % Ajouter des couleurs pour chaque état
    plot(time_vector(state_vector == 4), 4 * ones(sum(state_vector == 4), 1), 'b.', 'MarkerSize', 10); % WakeWiNoise
    plot(time_vector(state_vector == 1), 1 * ones(sum(state_vector == 1), 1), 'r.', 'MarkerSize', 10); % SWS
    plot(time_vector(state_vector == 3), 3 * ones(sum(state_vector == 3), 1), 'g.', 'MarkerSize', 10); % REM

    % Ajuster les limites et labels
    ylim([-1.5 4.5]);
    yticks([-1, 1, 3, 4]);
    yticklabels({'Non-classifié', 'SWS', 'REM', 'WakeWiNoise'});
    xlabel('Temps (secondes)');
    ylabel('État de sommeil');
    title('Évolution des états de sommeil');
    grid on;
    hold off;
end
