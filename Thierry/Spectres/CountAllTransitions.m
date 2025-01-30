function transition_matrix = CountAllTransitions(Wake, SWSEpoch, REMEpoch)
    % CountAllTransitions : Compte les transitions entre tous les états de sommeil.
    %
    % Inputs :
    % - Wake : périodes d'éveil
    % - SWSEpoch : périodes de sommeil lent profond
    % - REMEpoch : périodes de sommeil paradoxal
    %
    % Output :
    % - transition_matrix : matrice des transitions entre les états

    %%Utilisation
     % load('SleepScoring_Accelero.mat', 'Wake', 'SWSEpoch', 'REMEpoch');
     % transition_matrix = CountAllTransitions(Wake, SWSEpoch, REMEpoch);
     %%figure;
     % heatmap(state_labels, state_labels, transition_matrix, 'Title', 'Transition Matrix', ...
     %'XLabel', 'To State', 'YLabel', 'From State');




    
    % Définir les états et leurs codes
    state_codes = [4, 1, 3]; % Wake = 4, SWS = 1, REM = 3
    state_labels = {'Wake', 'SWS', 'REM'};
    num_states = length(state_codes);
    
    % Fusionner toutes les périodes dans une séquence chronologique
    all_times = sort([Start(Wake, 's'); Start(SWSEpoch, 's'); Start(REMEpoch, 's')]);
    states = zeros(size(all_times));  % Initialise les états à 0 (autres/artefacts)
    
    % Attribuer les états aux périodes correspondantes
    states(ismember(all_times, Start(Wake, 's'))) = 4;   % Wake
    states(ismember(all_times, Start(SWSEpoch, 's'))) = 1; % SWS
    states(ismember(all_times, Start(REMEpoch, 's'))) = 3; % REM
    
    % Identifier les transitions
    transitions = [states(1:end-1), states(2:end)];
    
    % Initialiser la matrice des transitions
    transition_matrix = zeros(num_states, num_states);
    
    % Parcourir les combinaisons d'états et compter les transitions
    for from_idx = 1:num_states
        for to_idx = 1:num_states
            transition_matrix(from_idx, to_idx) = sum(transitions(:, 1) == state_codes(from_idx) & ...
                                                      transitions(:, 2) == state_codes(to_idx));
        end
    end
    
    % Afficher les résultats
    disp('Matrice des transitions :');
    disp(array2table(transition_matrix, 'VariableNames', state_labels, 'RowNames', state_labels));
end
