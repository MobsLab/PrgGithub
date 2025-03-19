% Noms des états
state_labels = {'Wake', 'SWS', 'REM'};
num_states = length(state_labels); % Nombre d'états

%% Étape 1 : Calcul des matrices de transition moyennes pour chaque groupe
% Initialiser les matrices de transition moyennes
mean_transition_controls = zeros(num_states, num_states);
mean_transition_mutants = zeros(num_states, num_states);

% Pour chaque souris et chaque fenêtre, additionner les matrices de transition
for g = 1:length(groups)
    group_name = groups{g};
    mice_names = fieldnames(data.(group_name));
    
    % Initialiser une matrice pour la somme des transitions du groupe
    total_transitions = zeros(num_states, num_states);
    total_bins_in_group = 0; % Nombre total de transitions dans le groupe
    
    for i = 1:length(mice_names)
        mouse_name = mice_names{i};
        
        % Extraire les données des transitions pour la souris
        mouse_transitions = group_transitions.(group_name)(:, :, :, i);
        
        % Somme des matrices de transition sur toutes les fenêtres pour cette souris
        mouse_transition_sum = sum(mouse_transitions, 3); % Somme sur les fenêtres
        total_transitions = total_transitions + mouse_transition_sum;
        
        % Ajouter le nombre total de bins (transitions possibles)
        total_bins_in_group = total_bins_in_group + sum(mouse_transition_sum(:));
    end
    
    % Calculer la matrice de transition moyenne pour ce groupe
    if strcmp(group_name, 'Controles')
        mean_transition_controls = total_transitions ./ total_bins_in_group;
    elseif strcmp(group_name, 'Mutants')
        mean_transition_mutants = total_transitions ./ total_bins_in_group;
    end
end

%% Étape 2 : Visualiser les matrices de transition
figure;

% Matrice de transition pour les Contrôles
subplot(1, 2, 1);
imagesc(mean_transition_controls);
colorbar;
title('Matrice de transition - Contrôles');
xlabel('Vers l''état');
ylabel('Depuis l''état');
xticks(1:num_states);
yticks(1:num_states);
xticklabels(state_labels);
yticklabels(state_labels);
set(gca, 'TickLength', [0 0]); % Supprimer les ticks mineurs
axis square;

% Matrice de transition pour les Mutants
subplot(1, 2, 2);
imagesc(mean_transition_mutants);
colorbar;
title('Matrice de transition - Mutants');
xlabel('Vers l''état');
ylabel('Depuis l''état');
xticks(1:num_states);
yticks(1:num_states);
xticklabels(state_labels);
yticklabels(state_labels);
set(gca, 'TickLength', [0 0]); % Supprimer les ticks mineurs
axis square;

%% Étape 3 : Comparer les matrices de transition
% Calculer la différence entre les matrices de transition
diff_matrix = mean_transition_controls - mean_transition_mutants;

% Visualisation de la différence entre les matrices
figure;
imagesc(diff_matrix);
colorbar;
title('Différence des matrices de transition (Contrôles - Mutants)');
xlabel('Vers l''état');
ylabel('Depuis l''état');
xticks(1:num_states);
yticks(1:num_states);
xticklabels(state_labels);
yticklabels(state_labels);
set(gca, 'TickLength', [0 0]); % Supprimer les ticks mineurs
axis square;

% Calculer la norme de Frobenius (distance globale entre matrices)
frob_norm = norm(diff_matrix, 'fro');
disp(['Distance globale entre matrices (norme de Frobenius) : ', num2str(frob_norm)]);

%% Étape 4 : Simulation des transitions
% Simuler des séquences d'états pour Contrôles et Mutants
num_steps = 100; % Nombre d'étapes dans la simulation
initial_state = 1; % État initial : 1 = Wake

% Simulation pour les Contrôles
simulated_states_controls = simulate_markov_chain(mean_transition_controls, initial_state, num_steps);

% Simulation pour les Mutants
simulated_states_mutants = simulate_markov_chain(mean_transition_mutants, initial_state, num_steps);

% Visualisation des séquences simulées
figure;
subplot(2, 1, 1);
plot(1:num_steps, simulated_states_controls, '-o', 'Color', [0.3, 0.7, 0.9]);
xlabel('Étapes');
ylabel('État');
yticks(1:num_states);
yticklabels(state_labels);
title('Simulation des transitions - Contrôles');
grid on;

subplot(2, 1, 2);
plot(1:num_steps, simulated_states_mutants, '-o', 'Color', [0.9, 0.5, 0.3]);
xlabel('Étapes');
ylabel('État');
yticks(1:num_states);
yticklabels(state_labels);
title('Simulation des transitions - Mutants');
grid on;



%%%%
% Calcul de la durée moyenne dans chaque état pour les Contrôles
durations_controls = zeros(1, num_states);
for s = 1:num_states
    durations_controls(s) = sum(simulated_states_controls == s) / num_steps;
end
disp('Durée moyenne dans chaque état - Contrôles :');
disp(durations_controls);

% Calcul de la durée moyenne dans chaque état pour les Mutants
durations_mutants = zeros(1, num_states);
for s = 1:num_states
    durations_mutants(s) = sum(simulated_states_mutants == s) / num_steps;
end
disp('Durée moyenne dans chaque état - Mutants :');
disp(durations_mutants);
%%%%


%%%
% Fréquence des transitions pour les Contrôles
transition_counts_controls = zeros(num_states, num_states);
for step = 1:num_steps - 1
    from_state = simulated_states_controls(step);
    to_state = simulated_states_controls(step + 1);
    transition_counts_controls(from_state, to_state) = ...
        transition_counts_controls(from_state, to_state) + 1;
end
disp('Fréquence des transitions - Contrôles :');
disp(transition_counts_controls);

% Fréquence des transitions pour les Mutants
transition_counts_mutants = zeros(num_states, num_states);
for step = 1:num_steps - 1
    from_state = simulated_states_mutants(step);
    to_state = simulated_states_mutants(step + 1);
    transition_counts_mutants(from_state, to_state) = ...
        transition_counts_mutants(from_state, to_state) + 1;
end
disp('Fréquence des transitions - Mutants :');
disp(transition_counts_mutants);
%%%%