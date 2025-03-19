function SlidingWindowMarkovProbabilities(Wake, SWSEpoch, REMEpoch, bin_size, window_size)
    % SlidingWindowMarkovProbabilities : Calcule les probabilités de transition dans des fenêtres glissantes.
    %
    % Inputs :
    % - Wake : périodes d'éveil
    % - SWSEpoch : périodes de sommeil lent profond
    % - REMEpoch : périodes de sommeil paradoxal
    % - bin_size : taille des bins en secondes (ex : 10s)
    % - window_size : taille des fenêtres glissantes en secondes (ex : 60s)
    %
    % Output :
    % - Affiche les probabilités de transition par fenêtre.

    % Déterminer les limites temporelles globales
    start_time = min([Start(Wake, 's'); Start(SWSEpoch, 's'); Start(REMEpoch, 's')]);
    end_time = max([End(Wake, 's'); End(SWSEpoch, 's'); End(REMEpoch, 's')]);

    % Créer des bins temporels
    time_bins = start_time:bin_size:end_time;
    num_bins = length(time_bins) - 1;

    % Initialiser un vecteur pour les états des bins
    bin_states = zeros(num_bins, 1); % 0 = non-classifié, 1 = Wake, 2 = SWS, 3 = REM

    % Attribuer un état dominant à chaque bin
    for i = 1:num_bins
        bin_start = time_bins(i);
        bin_end = time_bins(i + 1);

        % Vérifier si une période chevauche le bin (au moins une fois)
        if any(Start(Wake, 's') < bin_end & End(Wake, 's') > bin_start)
            bin_states(i) = 1; % Wake
        elseif any(Start(SWSEpoch, 's') < bin_end & End(SWSEpoch, 's') > bin_start)
            bin_states(i) = 2; % SWS
        elseif any(Start(REMEpoch, 's') < bin_end & End(REMEpoch, 's') > bin_start)
            bin_states(i) = 3; % REM
        end
    end

    % Vérifier les états des bins
    disp('États des bins :');
    disp(bin_states');

    % Calcul des probabilités dans des fenêtres glissantes
    num_windows = floor((num_bins * bin_size - window_size) / bin_size) + 1;
    transition_probabilities = zeros(num_windows, 3, 3); % [Window, From State, To State]

    for w = 1:num_windows
        % Définir les limites de la fenêtre glissante
        window_start = (w - 1) * bin_size + 1;
        window_end = window_start + window_size / bin_size - 1;

        if window_end > num_bins
            break;
        end

        % Extraire les états des bins dans la fenêtre
        window_states = bin_states(window_start:window_end);

        % Initialiser une matrice des transitions pour la fenêtre
        transition_counts = zeros(3, 3);

        % Calculer les transitions entre états
        for j = 1:length(window_states) - 1
            from_state = window_states(j);
            to_state = window_states(j + 1);

            if from_state > 0 && to_state > 0
                transition_counts(from_state, to_state) = transition_counts(from_state, to_state) + 1;
            end
        end

        % Normaliser pour obtenir les probabilités de transition
        for k = 1:3
            total_transitions = sum(transition_counts(k, :));
            if total_transitions > 0
                transition_probabilities(w, k, :) = transition_counts(k, :) / total_transitions;
            end
        end
    end

    % Afficher les résultats
    for w = 1:num_windows
        fprintf('Fenêtre %d (de %d à %d secondes) :\n', w, (w - 1) * bin_size, w * bin_size + window_size);
        disp(array2table(squeeze(transition_probabilities(w, :, :)), ...
            'VariableNames', {'Wake', 'SWS', 'REM'}, ...
            'RowNames', {'Wake', 'SWS', 'REM'}));
    end
end
