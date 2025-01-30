%% Définition des chemins d'enregistrements
enregistrements_controles = { ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343/' ...
};

enregistrements_mutants = { ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657/', ...
    '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852/' ...
};

groups = {'Controles', 'Mutants'};
enregistrements = {enregistrements_controles, enregistrements_mutants};

%% Initialisation des structures pour les résultats
num_groups = 2; % Nombre de groupes (Contrôles, Mutants)
num_states = 3; % États : Wake, SWS, REM

% Structures pour les données
num_episodes = cell(1, num_groups);         % Nombre d'épisodes par souris
episode_durations = cell(1, num_groups);    % Durées des épisodes par souris
mean_episode_durations = cell(1, num_groups); % Moyennes des durées d'épisodes par souris

% Initialisation
for g = 1:num_groups
    num_mice = length(enregistrements{g}); % Nombre de souris dans chaque groupe
    num_episodes{g} = zeros(num_mice, num_states);
    episode_durations{g} = cell(num_mice, num_states);
    mean_episode_durations{g} = zeros(num_mice, num_states);
end

%% Calcul des métriques
for g = 1:num_groups % Parcours des groupes
    num_mice = length(enregistrements{g});
    for i = 1:num_mice % Parcours des souris
        accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
        else
            error(['Fichier introuvable : ', accelero_path]);
        end

        % Wake
        [durWake, ~] = DurationEpoch(Wake);
        num_episodes{g}(i, 1) = length(durWake);
        episode_durations{g}{i, 1} = durWake / 1e4; % En secondes
        mean_episode_durations{g}(i, 1) = mean(episode_durations{g}{i, 1}, 'omitnan');

        % SWS
        [durSWS, ~] = DurationEpoch(SWSEpoch);
        num_episodes{g}(i, 2) = length(durSWS);
        episode_durations{g}{i, 2} = durSWS / 1e4; % En secondes
        mean_episode_durations{g}(i, 2) = mean(episode_durations{g}{i, 2}, 'omitnan');

        % REM
        [durREM, ~] = DurationEpoch(REMEpoch);
        num_episodes{g}(i, 3) = length(durREM);
        episode_durations{g}{i, 3} = durREM / 1e4; % En secondes
        mean_episode_durations{g}(i, 3) = mean(episode_durations{g}{i, 3}, 'omitnan');
    end
end

%% Affichage des résultats et graphiques
states = {'Wake', 'NREM', 'REM'}; % États à afficher
control_edge_color = [0, 0, 1];  % Bleu pour les Contrôles
mutant_edge_color = [1, 0, 0];   % Rouge pour les Mutants
bar_width = 0.35;                % Largeur des barres

% Graphique comparatif des moyennes des durées des épisodes
figure('Name', 'Comparaison des Durées Moyennes des Épisodes');
for state_idx = 1:num_states
    % Données pour les comparaisons
    ctrl_means = mean_episode_durations{1}(:, state_idx); % Moyennes des Contrôles
    mut_means = mean_episode_durations{2}(:, state_idx); % Moyennes des Mutants

    % Test statistique Mann-Whitney
    p_value_mannwhitney = ranksum(ctrl_means, mut_means);

    % Moyennes et SEM
    mean_ctrl = mean(ctrl_means, 'omitnan');
    mean_mut = mean(mut_means, 'omitnan');
    sem_ctrl = std(ctrl_means, 'omitnan') / sqrt(sum(~isnan(ctrl_means)));
    sem_mut = std(mut_means, 'omitnan') / sqrt(sum(~isnan(mut_means)));

    % Graphique
    subplot(1, 3, state_idx);
    hold on;

    % Barres pour les Moyennes
    bar(1 - 0.2, mean_ctrl, bar_width, 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5);
    bar(2 + 0.2, mean_mut, bar_width, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5);

    % Barres d'erreur
    errorbar(1 - 0.2, mean_ctrl, sem_ctrl, 'k.', 'LineWidth', 1.5, 'CapSize', 10);
    errorbar(2 + 0.2, mean_mut, sem_mut, 'k.', 'LineWidth', 1.5, 'CapSize', 10);

    % Points individuels
    scatter(ones(size(ctrl_means)) * (1 - 0.2), ctrl_means, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', control_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);
    scatter(ones(size(mut_means)) * (2 + 0.2), mut_means, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', mutant_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);

    % Étoiles pour la significativité
    y_max = max([mean_ctrl + sem_ctrl, mean_mut + sem_mut]) * 1.2;
    if p_value_mannwhitney < 0.001
        text(1.5, y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 18, 'Color', 'k');
    elseif p_value_mannwhitney < 0.01
        text(1.5, y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 18, 'Color', 'k');
    elseif p_value_mannwhitney < 0.05
        text(1.5, y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 18, 'Color', 'k');
    else
        text(1.5, y_max, 'ns', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
    end

    % Affichage des P-values
    p_text_y_pos = y_max * 1.1;
    text(1.5, p_text_y_pos, ['p = ', num2str(p_value_mannwhitney, '%.3f')], ...
        'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'k', 'FontAngle', 'italic');

    % Personnalisation du graphique
    title(states{state_idx});
    ylabel('Durée moyenne (s)');
    xticks([1, 2]);
    xticklabels({'Control', 'Mutant'});
    ylim([0, p_text_y_pos * 1.2]);
    set(gca, 'FontSize', 12);
    hold off;
end