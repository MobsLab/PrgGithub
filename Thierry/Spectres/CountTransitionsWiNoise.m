function transition_counts = CountTransitionsCorrected(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise)
    % CountTransitionsCorrected : Calcule le nombre de transitions entre états différents
    % (WakeWiNoise, SWSEpochWiNoiseWiNoise, REMEpochWiNoise), en excluant les transitions répétées (ex: WakeWiNoise → WakeWiNoise).
    %
    % Inputs :
    % - WakeWiNoise : périodes d'éveil
    % - SWSEpochWiNoiseWiNoise : périodes de sommeil lent profond
    % - REMEpochWiNoise : périodes de sommeil paradoxal
    %
    % Output :
    % - transition_counts : matrice contenant le nombre de transitions entre les états

    %%Utilisation
    %load('SleepScoring_Accelero.mat', 'WakeWiNoise', 'SWSEpochWiNoise', 'REMEpochWiNoise');
    %transition_counts = CountTransitionsCorrected(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise);



    % Définir les états et leurs codes
    state_codes = [4, 1, 3]; % WakeWiNoise = 4, SWSEpochWiNoise = 1, REMEpochWiNoise = 3
    state_labels = {'WakeWiNoise', 'SWSEpochWiNoise', 'REMEpochWiNoise'};
    num_states = length(state_codes);
    
    % Déterminer les limites temporelles globales
    start_time = min([Start(WakeWiNoise, 's'); Start(SWSEpochWiNoise, 's'); Start(REMEpochWiNoise, 's')]);
    end_time = max([End(WakeWiNoise, 's'); End(SWSEpochWiNoise, 's'); End(REMEpochWiNoise, 's')]);
    
    % Créer un vecteur temporel à résolution fixe (par exemple, 1 seconde)
    time_resolution = 1; % Résolution en secondes
    time_vector = start_time:time_resolution:end_time;
    
    % Initialiser un vecteur pour les états
    state_vector = -1 * ones(size(time_vector)); % -1 : Non-classifié

    % Affecter les états en fonction des périodes
    for i = 1:length(time_vector)
        t = time_vector(i); % Temps actuel

        % Vérifier si le temps appartient à une période WakeWiNoise
        if any(t >= Start(WakeWiNoise, 's') & t <= End(WakeWiNoise, 's'))
            state_vector(i) = 4; % WakeWiNoise
        end
        
        % Vérifier si le temps appartient à une période SWSEpochWiNoise
        if any(t >= Start(SWSEpochWiNoise, 's') & t <= End(SWSEpochWiNoise, 's'))
            state_vector(i) = 1; % SWSEpochWiNoise
        end

        % Vérifier si le temps appartient à une période REMEpochWiNoise
        if any(t >= Start(REMEpochWiNoise, 's') & t <= End(REMEpochWiNoise, 's'))
            state_vector(i) = 3; % REMEpochWiNoise
        end
    end
    
    % Supprimer les périodes non classifiées
    state_vector = state_vector(state_vector ~= -1);

    % Supprimer les répétitions consécutives dans les états
    state_vector_cleaned = state_vector([1, find(diff(state_vector) ~= 0) + 1]);

    % Calculer les transitions entre états
    transitions = [state_vector_cleaned(1:end-1)', state_vector_cleaned(2:end)'];
    transition_counts = zeros(num_states, num_states); % Initialiser la matrice de transitions

    % Parcourir les combinaisons d'états et compter les transitions
    for from_idx = 1:num_states
        for to_idx = 1:num_states
            transition_counts(from_idx, to_idx) = sum(transitions(:, 1) == state_codes(from_idx) & ...
                                                      transitions(:, 2) == state_codes(to_idx));
        end
    end

    % Afficher les résultats
    disp('Matrice des transitions (sans répétitions) :');
    disp(array2table(transition_counts, 'VariableNames', state_labels, 'RowNames', state_labels));
end
