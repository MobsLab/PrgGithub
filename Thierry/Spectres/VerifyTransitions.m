function VerifyTransitions(Wake, SWSEpoch, REMEpoch, bin_size, window_size)
    if nargin < 4
        bin_size = 10; % 10 secondes
    end
    if nargin < 5
        window_size = 60; % 60 secondes
    end

    % Déterminer les limites temporelles globales
    start_time = min([Start(Wake, 's'); Start(SWSEpoch, 's'); Start(REMEpoch, 's')]);
    end_time = max([End(Wake, 's'); End(SWSEpoch, 's'); End(REMEpoch, 's')]);

    % Créer un vecteur de temps avec des bins
    time_bins = start_time:bin_size:end_time; % Bins de temps
    num_bins = length(time_bins) - 1;

    % Initialiser un vecteur pour les états
    bin_states = -1 * ones(num_bins, 1); % -1 : Non-classifié

    % Attribuer un état dominant à chaque bin
    for i = 1:num_bins
        bin_start = time_bins(i);
        bin_end = time_bins(i + 1);

        % Vérifier la présence dans chaque état
        wake_count = sum(Start(Wake, 's') >= bin_start & End(Wake, 's') <= bin_end);
        sws_count = sum(Start(SWSEpoch, 's') >= bin_start & End(SWSEpoch, 's') <= bin_end);
        rem_count = sum(Start(REMEpoch, 's') >= bin_start & End(REMEpoch, 's') <= bin_end);

        % Attribuer l'état dominant
        [max_count, dominant_state] = max([wake_count, sws_count, rem_count]);
        if max_count > 0
            bin_states(i) = dominant_state; % 1: Wake, 2: SWS, 3: REM
        end

        % Afficher le résultat pour chaque bin
        fprintf('Bin [%d - %d] Wake: %d, SWS: %d, REM: %d, State: %d\n', ...
                bin_start, bin_end, wake_count, sws_count, rem_count, bin_states(i));
    end

    % Vérifier les transitions détectées
    disp('États détectés par bin :');
    disp(bin_states);

    % Calculer les transitions
    transition_counts = zeros(3, 3); % From State x To State
    for j = 1:num_bins - 1
        from_state = bin_states(j);
        to_state = bin_states(j + 1);
        if from_state > 0 && to_state > 0
            transition_counts(from_state, to_state) = transition_counts(from_state, to_state) + 1;
        end
    end

    % Afficher la matrice des transitions
    disp('Matrice des transitions :');
    disp(array2table(transition_counts, ...
        'VariableNames', {'Wake', 'SWS', 'REM'}, ...
        'RowNames', {'Wake', 'SWS', 'REM'}));
end
