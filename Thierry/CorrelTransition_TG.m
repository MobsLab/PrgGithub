% Générer les noms des transitions possibles
state_labels = {'Wake', 'SWS', 'REM'};
num_states = length(state_labels); % 3 états : Wake, SWS, REM

% Créer une liste des combinaisons de transitions (ex : 'Wake -> SWS')
transition_labels = cell(num_states * num_states, 1); % Initialiser la liste des labels
idx = 1; % Index pour remplir les labels
for from_state = 1:num_states
    for to_state = 1:num_states
        transition_labels{idx} = [state_labels{from_state}, ' -> ', state_labels{to_state}];
        idx = idx + 1;
    end
end

% Calcul des corrélations entre les transitions
corr_controls = corr(reshape(group_transitions.Controles, [], num_states * num_states));
corr_mutants = corr(reshape(group_transitions.Mutants, [], num_states * num_states));

% Visualisation des matrices de corrélation
figure;

% Matrice de corrélation pour les Contrôles
subplot(1, 2, 1);
imagesc(corr_controls); % Afficher la heatmap
colorbar; % Ajouter une barre de couleur
title('Corrélations des transitions - Contrôles');
xlabel('Transitions');
ylabel('Transitions');
xticks(1:num_states * num_states); % Positionner les ticks sur les axes
yticks(1:num_states * num_states);
xticklabels(transition_labels); % Assigner les labels des transitions sur l'axe X
yticklabels(transition_labels); % Assigner les labels des transitions sur l'axe Y
xtickangle(45); % Incliner les labels sur l'axe X pour plus de lisibilité
set(gca, 'TickLength', [0 0]); % Supprimer les petits ticks sur les axes

% Matrice de corrélation pour les Mutants
subplot(1, 2, 2);
imagesc(corr_mutants); % Afficher la heatmap
colorbar; % Ajouter une barre de couleur
title('Corrélations des transitions - Mutants');
xlabel('Transitions');
ylabel('Transitions');
xticks(1:num_states * num_states); % Positionner les ticks sur les axes
yticks(1:num_states * num_states);
xticklabels(transition_labels); % Assigner les labels des transitions sur l'axe X
yticklabels(transition_labels); % Assigner les labels des transitions sur l'axe Y
xtickangle(45); % Incliner les labels sur l'axe X pour plus de lisibilité
set(gca, 'TickLength', [0 0]); % Supprimer les petits ticks sur les axes


diff_corr = corr_controls - corr_mutants;
figure;
imagesc(diff_corr);
colorbar;
title('Différence des corrélations entre Contrôles et Mutants');
xlabel('Transitions');
ylabel('Transitions');


% Trouver les indices des plus grandes différences
[rows, cols] = find(abs(diff_corr) > 0.5);

% Afficher les résultats
disp('Transitions avec des différences significatives :');
for k = 1:length(rows)
    fprintf('Transition %d -> %d : Différence = %.2f\n', rows(k), cols(k), diff_corr(rows(k), cols(k)));
end
