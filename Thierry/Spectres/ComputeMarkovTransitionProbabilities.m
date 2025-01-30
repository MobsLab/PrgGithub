function transition_probabilities = ComputeMarkovTransitionProbabilities(transition_counts)
    % ComputeMarkovTransitionProbabilities : Calcule les probabilités de transition basées sur un modèle de Markov.
    %
    % Input :
    % - transition_counts : matrice des transitions (nombre de transitions entre états)
    %
    % Output :
    % - transition_probabilities : matrice des probabilités de transition (Markov)

    %%Utilisation
    %transition_counts = CountTransitionsCorrected(Wake, SWSEpoch, REMEpoch);
    %transition_probabilities = ComputeMarkovTransitionProbabilities(transition_counts);


    % Initialiser la matrice des probabilités
    num_states = size(transition_counts, 1);
    transition_probabilities = zeros(num_states, num_states);

    % Calculer les probabilités de transition pour chaque état
    for i = 1:num_states
        total_transitions = sum(transition_counts(i, :)); % Total des transitions depuis l'état i
        if total_transitions > 0
            transition_probabilities(i, :) = transition_counts(i, :) / total_transitions;
        else
            % Si pas de transitions sortantes, attribuer une ligne nulle
            transition_probabilities(i, :) = 0;
        end
    end

    % Afficher la matrice des probabilités
    disp('Matrice des probabilités de transition (Markov) :');
    disp(array2table(transition_probabilities, ...
        'VariableNames', {'Wake', 'SWS', 'REM'}, ...
        'RowNames', {'Wake', 'SWS', 'REM'}));
end
