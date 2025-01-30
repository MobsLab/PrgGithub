function compare_SleepWakeVariables_control_vs_mutant_mean_med()
    % Compare les Means et les medians des variables de sommeil entre groupes de souris contrôles et mutants.
    % Ajoute les erreurs standards de la Mean (SEM) sur les barres et réalise les tests Mann-Whitney.

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

% enregistrements_controles = { ...
%      '/media/nas6/Projet TramiPV/TG1_TG2_BaselineSleep_240531_095224/M2';
%      '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3';
%      '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4';
%      '/media/nas6/Projet TramiPV/Trami_TG5_BaselineSleep_240718_093343';
%  };
% enregistrements_mutants = { ...
%     '/media/nas6/Projet TramiPV/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1';
%     '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8';
%     '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7';
%     '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9';
%    };


    groups = {'Controles', 'Mutants'};
    enregistrements = {enregistrements_controles, enregistrements_mutants};

%% Initialisation des structures pour les résultats
sleep_percentages_total_session = cell(1, 2);  
sleep_percentages_total_sleep = cell(1, 2);
total_durations = cell(1, 2);
num_episodes = cell(1, 2);
episode_durations = cell(1, 2); % Nouvelle structure pour les durées moyennes et médianes

for g = 1:2
    n_enregistrements = length(enregistrements{g});
    sleep_percentages_total_session{g} = zeros(n_enregistrements, 3); % Wake, SWS, REM
    sleep_percentages_total_sleep{g} = zeros(n_enregistrements, 2);   % SWS, REM
    total_durations{g} = zeros(n_enregistrements, 3);                % Wake, SWS, REM
    num_episodes{g} = zeros(n_enregistrements, 3);
    episode_durations{g} = cell(n_enregistrements, 3); % Durée des épisodes pour chaque état

    for i = 1:n_enregistrements
        accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
        else
            error(['Fichier introuvable : ', accelero_path]);
        end

        % Calcul des pourcentages par rapport à la session totale
        SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
        sleep_percentages_total_session{g}(i, :) = SleepStagePerc_totSess(:, 1)';  

        % Calcul des pourcentages par rapport au sommeil total
        SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
        sleep_percentages_total_sleep{g}(i, :) = SleepStagePerc_totSleep(2:3, 1)';

        % Calcul des durées totales et des épisodes
        [durWAKE, durTWAKE] = DurationEpoch(Wake);
        total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600;
        num_episodes{g}(i, 1) = length(durWAKE);
        episode_durations{g}{i, 1} = durWAKE / 1e4; % Durée en secondes

        [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
        total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;
        num_episodes{g}(i, 2) = length(durSWS);
        episode_durations{g}{i, 2} = durSWS / 1e4;

        [durREM, durTREM] = DurationEpoch(REMEpoch);
        total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;
        num_episodes{g}(i, 3) = length(durREM);
        episode_durations{g}{i, 3} = durREM / 1e4;
    end
end

    %% Données pour les graphiques
    data_sets = {sleep_percentages_total_session, sleep_percentages_total_sleep, total_durations, num_episodes};
    y_labels = {'% of time (total session)', '% of time (total sommeil)', 'Total duration (hours)', 'Number of episodes'};
    titles = {'Pourcentage of Wake, NREM, and REM (total session)', ...
              'Pourcentage of Wake and NREM (total sommeil)', ...
              'Total duration of Wake, NREM and REM (hours)', ...
              'Number of episodes in Wake, NREM and REM'};
    colors = [0 0 1; 1 0 0]; % Bleu pour contrôles, rouge pour mutants

%% Génération des graphiques avec comparaisons Mann-Whitney
stats_types = {'Mean', 'Median'};
for stat_type = stats_types
    figure('Name', ['Comparison of ' char(stat_type)]);
    for k = 1:length(data_sets)
        subplot(2, 2, k);
        hold on;
        data_control = data_sets{k}{1}; % Données des contrôles
        data_mutant = data_sets{k}{2}; % Données des mutants

        % Calcul des Means/medians
        if strcmp(stat_type, 'Mean')
            bar_data = [mean(data_control); mean(data_mutant)]; % Moyennes
            sem_control = std(data_control) ./ sqrt(size(data_control, 1)); % SEM pour Contrôles
            sem_mutant = std(data_mutant) ./ sqrt(size(data_mutant, 1));   % SEM pour Mutants
        else
            bar_data = [median(data_control); median(data_mutant)]; % Médianes
            sem_control = zeros(1, size(data_control, 2)); % Pas de SEM pour médianes
            sem_mutant = zeros(1, size(data_mutant, 2));   % Pas de SEM pour médianes
        end

        % Couleurs pour les contours des points
        control_edge_color = [0, 0, 1];  % Bleu pour les Contrôles
        mutant_edge_color = [1, 0, 0];   % Rouge pour les Mutants

        % Création des barres
        bar_width = 0.35; % Largeur des barres réduite pour éviter le chevauchement
        x_control_positions = []; % Positions des barres des Contrôles
        x_mutant_positions = []; % Positions des barres des Mutants
        for j = 1:size(bar_data, 2)
            % Barre pour les Contrôles (décalée vers la gauche)
            x_control = j - 0.2; % Position de la barre des Contrôles
            bar(x_control, bar_data(1, j), bar_width, ...
                'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5);
            x_control_positions = [x_control_positions, x_control]; % Stocker les positions
            
            % Barre pour les Mutants (décalée vers la droite)
            x_mutant = j + 0.2; % Position de la barre des Mutants
            bar(x_mutant, bar_data(2, j), bar_width, ...
                'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5);
            x_mutant_positions = [x_mutant_positions, x_mutant]; % Stocker les positions
        end

        % Ajout des barres d'erreur (SEM) pour les Moyennes
        if strcmp(stat_type, 'Mean')
            % Barres d'erreur pour les Contrôles
            errorbar(x_control_positions, bar_data(1, :), sem_control, ...
                     'k.', 'LineWidth', 1.5, 'CapSize', 10);
            % Barres d'erreur pour les Mutants
            errorbar(x_mutant_positions, bar_data(2, :), sem_mutant, ...
                     'k.', 'LineWidth', 1.5, 'CapSize', 10);
        end

        % Ajout des points individuels pour chaque souris, centrés sur les barres
        for g = 1:2
            group_data = data_sets{k}{g}; % Données du groupe (Contrôles ou Mutants)
            for j = 1:size(group_data, 2)
                % Position des points
                if g == 1
                    x_positions = j - 0.2; % Centrer les points des Contrôles sur leur barre
                    marker_edge_color = control_edge_color; % Contour bleu pour Contrôles
                else
                    x_positions = j + 0.2; % Centrer les points des Mutants sur leur barre
                    marker_edge_color = mutant_edge_color; % Contour rouge pour Mutants
                end

                % Création des points individuels
                scatter(repmat(x_positions, size(group_data, 1), 1), group_data(:, j), ...
                        80, ... % Taille des points
                        'MarkerFaceColor', 'w', ... % Fond blanc
                        'MarkerEdgeColor', marker_edge_color, ... % Couleur du contour
                        'LineWidth', 1.5, ... % Épaisseur du contour
                        'jitter', 'on', ... % Ajout de jitter
                        'jitterAmount', 0.05); % Légère dispersion pour éviter le chevauchement
            end
        end

        % Ajout des labels personnalisés sur l'axe des X
        xticks(1:size(bar_data, 2)); % Positions des ticks
        xticklabels({'Wake', 'NREM', 'REM'}); % Labels pour chaque état
        set(gca, 'FontSize', 14); % Taille de la police des labels et ticks

        % Comparaisons statistiques avec Mann-Whitney
        for j = 1:size(data_control, 2)
            % Test de Mann-Whitney pour comparer Contrôles vs Mutants
            p_val = ranksum(data_control(:, j), data_mutant(:, j));
            y_max = max([bar_data(:, j)]) * 1.1; % Position pour afficher les étoiles

            % Affichage des étoiles de significativité
            if p_val < 0.001
                text(j, y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
            elseif p_val < 0.01
                text(j, y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
            elseif p_val < 0.05
                text(j, y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
            end
        end

        % Ajouter les étiquettes, le titre et la légende
        ylabel(y_labels{k});
        title(titles{k});
        legend({'Control', 'Mutant'}, 'Location', 'Best');
        hold off;
    end
end

%%%%%%%%%      
    %% Initialisation des structures pour les latences
latencies_sws = cell(1, 2); % Latences SWS pour Contrôles et Mutants
latencies_rem = cell(1, 2); % Latences REM pour Contrôles et Mutants

for g = 1:2 % Pour chaque groupe (Contrôles et Mutants)
    n_enregistrements = length(enregistrements{g});
    latencies_sws{g} = NaN(n_enregistrements, 1); % Initialisation des latences SWS
    latencies_rem{g} = NaN(n_enregistrements, 1); % Initialisation des latences REM

    for i = 1:n_enregistrements
        % Charger les données pour chaque souris
        accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'SWSEpoch', 'REMEpoch');
        else
            warning('Fichier introuvable pour : %s', accelero_path);
            continue;
        end

        % Calcul de la latence pour entrer en SWS
        if ~isempty(SWSEpoch) && isa(SWSEpoch, 'intervalSet') && size(Start(SWSEpoch), 1) > 0
            first_start_sws = Start(SWSEpoch); % Obtenir les débuts
            latencies_sws{g}(i) = double(first_start_sws(1)) / 1e4 / 60; % Convertir en minutes
        else
            warning('SWSEpoch est vide ou mal formaté pour %s', accelero_path);
        end

        % Calcul de la latence pour entrer en REM
        if ~isempty(REMEpoch) && isa(REMEpoch, 'intervalSet') && size(Start(REMEpoch), 1) > 0
            first_start_rem = Start(REMEpoch); % Obtenir les débuts
            latencies_rem{g}(i) = double(first_start_rem(1)) / 1e4 / 60; % Convertir en minutes
        else
            warning('REMEpoch est vide ou mal formaté pour %s', accelero_path);
        end
    end
end

%%%%%%

%% Comparaison statistique des latences
% Comparison of medians (Mann-Whitney)
p_value_sws_latency = ranksum(latencies_sws{1}, latencies_sws{2});
p_value_rem_latency = ranksum(latencies_rem{1}, latencies_rem{2});

% Comparison of Means (t-test)
[~, p_value_ttest_sws] = ttest2(latencies_sws{1}, latencies_sws{2}, 'Vartype', 'unequal');
[~, p_value_ttest_rem] = ttest2(latencies_rem{1}, latencies_rem{2}, 'Vartype', 'unequal');

%% Affichage des résultats
disp('Latences en SWS (minutes) :');
disp(['Contrôles - Mean : ', num2str(mean(latencies_sws{1}, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_sws{1}, 'omitnan'))]);
disp(['Mutants - Mean : ', num2str(mean(latencies_sws{2}, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_sws{2}, 'omitnan'))]);
disp(['p-valeurs (T-test / Mann-Whitney) : ', num2str(p_value_ttest_sws), ' / ', num2str(p_value_sws_latency)]);

disp('Latences en REM (minutes) :');
disp(['Contrôles - Mean : ', num2str(mean(latencies_rem{1}, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_rem{1}, 'omitnan'))]);
disp(['Mutants - Mean : ', num2str(mean(latencies_rem{2}, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_rem{2}, 'omitnan'))]);
disp(['p-valeurs (T-test / Mann-Whitney) : ', num2str(p_value_ttest_rem), ' / ', num2str(p_value_rem_latency)]);

%% Affichage graphique des latences SWS et REM avec étoiles de significativité
figure('Name', 'Comparison of Latences SWS et REM');

% Couleurs des groupes
control_edge_color = [0, 0, 1];  % Bleu pour les Contrôles
mutant_edge_color = [1, 0, 0];   % Rouge pour les Mutants

% Largeur des barres
bar_width = 0.35;

%% Graphique pour SWS
subplot(1, 2, 1);
hold on;

% Calcul des médianes et SEM
median_sws = [median(latencies_sws{1}, 'omitnan'), median(latencies_sws{2}, 'omitnan')];
mean_sws = [mean(latencies_sws{1}, 'omitnan'), mean(latencies_sws{2}, 'omitnan')];
sem_sws = [std(latencies_sws{1}, 'omitnan') / sqrt(sum(~isnan(latencies_sws{1}))), ...
           std(latencies_sws{2}, 'omitnan') / sqrt(sum(~isnan(latencies_sws{2})))];

% Création des barres
bar(1 - 0.2, median_sws(1), bar_width, 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5); % Contrôles
bar(2 + 0.2, median_sws(2), bar_width, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5); % Mutants

% Barres d'erreur pour les Moyennes
errorbar(1 - 0.2, mean_sws(1), sem_sws(1), 'k.', 'LineWidth', 1.5, 'CapSize', 10);
errorbar(2 + 0.2, mean_sws(2), sem_sws(2), 'k.', 'LineWidth', 1.5, 'CapSize', 10);

% Points individuels
for g = 1:2
    group_data = latencies_sws{g};
    if g == 1
        x_positions = 1 - 0.2; % Position pour les Contrôles
        marker_edge_color = control_edge_color; % Contour bleu
    else
        x_positions = 2 + 0.2; % Position pour les Mutants
        marker_edge_color = mutant_edge_color; % Contour rouge
    end
    scatter(repmat(x_positions, size(group_data, 1), 1), group_data, ...
            80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', marker_edge_color, ...
            'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);
end

% Test de Mann-Whitney pour SWS
p_val_sws = ranksum(latencies_sws{1}, latencies_sws{2});

% Ajout des étoiles pour les différences significatives
y_max_sws = max([mean_sws(1) + sem_sws(1), mean_sws(2) + sem_sws(2)]) * 1.1; % Position pour les étoiles
if p_val_sws < 0.001
    text(1.5, y_max_sws, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_val_sws < 0.01
    text(1.5, y_max_sws, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_val_sws < 0.05
    text(1.5, y_max_sws, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
end

% Personnalisation de l'axe
title('Latence SWS');
ylabel('Minutes');
xticks([1, 2]);
xticklabels({'Contrôles', 'Mutants'});
set(gca, 'FontSize', 14);
hold off;

%% Graphique pour REM
subplot(1, 2, 2);
hold on;

% Calcul des médianes et SEM
median_rem = [median(latencies_rem{1}, 'omitnan'), median(latencies_rem{2}, 'omitnan')];
mean_rem = [mean(latencies_rem{1}, 'omitnan'), mean(latencies_rem{2}, 'omitnan')];
sem_rem = [std(latencies_rem{1}, 'omitnan') / sqrt(sum(~isnan(latencies_rem{1}))), ...
           std(latencies_rem{2}, 'omitnan') / sqrt(sum(~isnan(latencies_rem{2})))];

% Création des barres
bar(1 - 0.2, median_rem(1), bar_width, 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5); % Contrôles
bar(2 + 0.2, median_rem(2), bar_width, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5); % Mutants

% Barres d'erreur pour les Moyennes
errorbar(1 - 0.2, mean_rem(1), sem_rem(1), 'k.', 'LineWidth', 1.5, 'CapSize', 10);
errorbar(2 + 0.2, mean_rem(2), sem_rem(2), 'k.', 'LineWidth', 1.5, 'CapSize', 10);

% Points individuels
for g = 1:2
    group_data = latencies_rem{g};
    if g == 1
        x_positions = 1 - 0.2; % Position pour les Contrôles
        marker_edge_color = control_edge_color; % Contour bleu
    else
        x_positions = 2 + 0.2; % Position pour les Mutants
        marker_edge_color = mutant_edge_color; % Contour rouge
    end
    scatter(repmat(x_positions, size(group_data, 1), 1), group_data, ...
            80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', marker_edge_color, ...
            'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);
end

% Test de Mann-Whitney pour REM
p_val_rem = ranksum(latencies_rem{1}, latencies_rem{2});

% Ajout des étoiles pour les différences significatives
y_max_rem = max([mean_rem(1) + sem_rem(1), mean_rem(2) + sem_rem(2)]) * 1.1; % Position pour les étoiles
if p_val_rem < 0.001
    text(1.5, y_max_rem, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_val_rem < 0.01
    text(1.5, y_max_rem, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_val_rem < 0.05
    text(1.5, y_max_rem, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
end

% Personnalisation de l'axe
title('Latence REM');
ylabel('Minutes');
xticks([1, 2]);
xticklabels({'Contrôles', 'Mutants'});
set(gca, 'FontSize', 14);
hold off;


%%%%%%%Latences conditionnelles%%%%%%%%%
% Durées minimales en secondes pour les épisodes
min_sws_duration = 10; % SWS
min_rem_duration = 5;  % REM

% Initialisation des structures pour les latences
latencies_sws = cell(1, 2); % Latences SWS pour Contrôles et Mutants
latencies_rem = cell(1, 2); % Latences REM pour Contrôles et Mutants

% Parcourir chaque groupe
for g = 1:2 % 1 = Contrôles, 2 = Mutants
    n_enregistrements = length(enregistrements{g});
    latencies_sws{g} = NaN(n_enregistrements, 1); % Initialisation des latences SWS
    latencies_rem{g} = NaN(n_enregistrements, 1); % Initialisation des latences REM

    % Parcourir chaque souris
    for i = 1:n_enregistrements
        % Charger les données de SleepScoring_Accelero.mat
        accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'SWSEpoch', 'REMEpoch'); % Charger SWSEpoch et REMEpoch
        else
            warning('Fichier introuvable pour : %s', accelero_path);
            continue;
        end

        % LATENCE POUR LE PREMIER ÉPISODE DE SWS
        if ~isempty(SWSEpoch) && isa(SWSEpoch, 'intervalSet')
            % Récupérer les débuts et les fins des épisodes
            starts_sws = Start(SWSEpoch);
            ends_sws = End(SWSEpoch);

            % Parcourir les épisodes pour trouver le premier valide
            for j = 1:length(starts_sws)
                duration_sws = (ends_sws(j) - starts_sws(j)) / 1e4; % Durée en secondes
                if duration_sws >= min_sws_duration
                    latencies_sws{g}(i) = double(starts_sws(j)) / 1e4 / 60; % Convertir en minutes
                    break; % Sortir dès qu'on trouve le premier épisode valide
                end
            end
        else
            warning('SWSEpoch est vide ou mal formaté pour %s.', accelero_path);
        end

        % LATENCE POUR LE PREMIER ÉPISODE DE REM
        if ~isempty(REMEpoch) && isa(REMEpoch, 'intervalSet')
            % Récupérer les débuts et les fins des épisodes
            starts_rem = Start(REMEpoch);
            ends_rem = End(REMEpoch);

            % Parcourir les épisodes pour trouver le premier valide
            for j = 1:length(starts_rem)
                duration_rem = (ends_rem(j) - starts_rem(j)) / 1e4; % Durée en secondes
                if duration_rem >= min_rem_duration
                    latencies_rem{g}(i) = double(starts_rem(j)) / 1e4 / 60; % Convertir en minutes
                    break; % Sortir dès qu'on trouve le premier épisode valide
                end
            end
        else
            warning('REMEpoch est vide ou mal formaté pour %s.', accelero_path);
        end
    end
end

% Affichage des résultats pour vérifier
disp('Latences SWS :');
disp(latencies_sws);
disp('Latences REM :');
disp(latencies_rem); 
%%%%%%

%% Comparaison statistique des latences
% Conversion des latences en format vectoriel pour analyse
latencies_sws_ctrl = latencies_sws{1};
latencies_sws_mut = latencies_sws{2};
latencies_rem_ctrl = latencies_rem{1};
latencies_rem_mut = latencies_rem{2};

% Comparaison des médianes (Mann-Whitney)
p_value_sws_latency = ranksum(latencies_sws_ctrl, latencies_sws_mut);
p_value_rem_latency = ranksum(latencies_rem_ctrl, latencies_rem_mut);

% Comparaison des moyennes (t-test)
[~, p_value_ttest_sws] = ttest2(latencies_sws_ctrl, latencies_sws_mut, 'Vartype', 'unequal');
[~, p_value_ttest_rem] = ttest2(latencies_rem_ctrl, latencies_rem_mut, 'Vartype', 'unequal');

%% Affichage des résultats
disp('Latences en SWS (minutes) :');
disp(['Contrôles - Mean : ', num2str(mean(latencies_sws_ctrl, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_sws_ctrl, 'omitnan'))]);
disp(['Mutants - Mean : ', num2str(mean(latencies_sws_mut, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_sws_mut, 'omitnan'))]);
disp(['p-valeurs (T-test / Mann-Whitney) : ', num2str(p_value_ttest_sws), ' / ', num2str(p_value_sws_latency)]);

disp('Latences en REM (minutes) :');
disp(['Contrôles - Mean : ', num2str(mean(latencies_rem_ctrl, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_rem_ctrl, 'omitnan'))]);
disp(['Mutants - Mean : ', num2str(mean(latencies_rem_mut, 'omitnan')), ...
      ', Median : ', num2str(median(latencies_rem_mut, 'omitnan'))]);
disp(['p-valeurs (T-test / Mann-Whitney) : ', num2str(p_value_ttest_rem), ' / ', num2str(p_value_rem_latency)]);

%% Affichage graphique des latences SWS et REM avec étoiles de significativité
figure('Name', 'Comparison of Latences SWS et REM');

% Couleurs des groupes
control_edge_color = [0, 0, 1];  % Bleu pour les Contrôles
mutant_edge_color = [1, 0, 0];   % Rouge pour les Mutants

% Largeur des barres
bar_width = 0.35;

%% Graphique pour SWS
subplot(1, 2, 1);
hold on;

% Calcul des médianes et SEM
median_sws = [median(latencies_sws_ctrl, 'omitnan'), median(latencies_sws_mut, 'omitnan')];
mean_sws = [mean(latencies_sws_ctrl, 'omitnan'), mean(latencies_sws_mut, 'omitnan')];
sem_sws = [std(latencies_sws_ctrl, 'omitnan') / sqrt(sum(~isnan(latencies_sws_ctrl))), ...
           std(latencies_sws_mut, 'omitnan') / sqrt(sum(~isnan(latencies_sws_mut)))];

% Création des barres
bar(1 - 0.2, median_sws(1), bar_width, 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5); % Contrôles
bar(2 + 0.2, median_sws(2), bar_width, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5); % Mutants

% Barres d'erreur pour les Moyennes
errorbar(1 - 0.2, mean_sws(1), sem_sws(1), 'k.', 'LineWidth', 1.5, 'CapSize', 10);
errorbar(2 + 0.2, mean_sws(2), sem_sws(2), 'k.', 'LineWidth', 1.5, 'CapSize', 10);

% Points individuels
scatter(ones(size(latencies_sws_ctrl)) * (1 - 0.2), latencies_sws_ctrl, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', control_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);
scatter(ones(size(latencies_sws_mut)) * (2 + 0.2), latencies_sws_mut, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', mutant_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);

% Ajout des étoiles pour les différences significatives
y_max_sws = max([mean_sws(1) + sem_sws(1), mean_sws(2) + sem_sws(2)]) * 1.1; % Position pour les étoiles
if p_value_sws_latency < 0.001
    text(1.5, y_max_sws, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_value_sws_latency < 0.01
    text(1.5, y_max_sws, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_value_sws_latency < 0.05
    text(1.5, y_max_sws, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
end

title('Latence SWS');
ylabel('Minutes');
xticks([1, 2]);
xticklabels({'Contrôles', 'Mutants'});
set(gca, 'FontSize', 14);
hold off;

%% Graphique pour REM
subplot(1, 2, 2);
hold on;

% Calcul des médianes et SEM
median_rem = [median(latencies_rem_ctrl, 'omitnan'), median(latencies_rem_mut, 'omitnan')];
mean_rem = [mean(latencies_rem_ctrl, 'omitnan'), mean(latencies_rem_mut, 'omitnan')];
sem_rem = [std(latencies_rem_ctrl, 'omitnan') / sqrt(sum(~isnan(latencies_rem_ctrl))), ...
           std(latencies_rem_mut, 'omitnan') / sqrt(sum(~isnan(latencies_rem_mut)))];

% Création des barres
bar(1 - 0.2, median_rem(1), bar_width, 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 1.5); % Contrôles
bar(2 + 0.2, median_rem(2), bar_width, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', 1.5); % Mutants

% Barres d'erreur pour les Moyennes
errorbar(1 - 0.2, mean_rem(1), sem_rem(1), 'k.', 'LineWidth', 1.5, 'CapSize', 10);
errorbar(2 + 0.2, mean_rem(2), sem_rem(2), 'k.', 'LineWidth', 1.5, 'CapSize', 10);

% Points individuels
scatter(ones(size(latencies_rem_ctrl)) * (1 - 0.2), latencies_rem_ctrl, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', control_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);
scatter(ones(size(latencies_rem_mut)) * (2 + 0.2), latencies_rem_mut, ...
        80, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', mutant_edge_color, ...
        'LineWidth', 1.5, 'jitter', 'on', 'jitterAmount', 0.05);

% Ajout des étoiles pour les différences significatives
y_max_rem = max([mean_rem(1) + sem_rem(1), mean_rem(2) + sem_rem(2)]) * 1.1; % Position pour les étoiles
if p_value_rem_latency < 0.001
    text(1.5, y_max_rem, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_value_rem_latency < 0.01
    text(1.5, y_max_rem, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
elseif p_value_rem_latency < 0.05
    text(1.5, y_max_rem, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'k');
end

title('Latence REM');
ylabel('Minutes');
xticks([1, 2]);
xticklabels({'Contrôles', 'Mutants'});
set(gca, 'FontSize', 14);
hold off;

% Variables à inclure dans le tableau
variables_to_include = {
    'Percentage Wake (Total Session)', 'Percentage SWS (Total Session)', 'Percentage REM (Total Session)', ...
    'Percentage SWS (Total Sleep)', 'Percentage REM (Total Sleep)', ...
    'Number of Episodes Wake', 'Number of Episodes SWS', 'Number of Episodes REM', ...
    'Latence SWS', 'Latence REM'};

% Collecter les données pour chaque variable
results_table = cell(length(variables_to_include), 7);

% Variables issues des données
data_to_process = { ...
    sleep_percentages_total_session, ... % % of time (total session) : Wake, SWS, REM
    sleep_percentages_total_sleep, ... % % of time (total sleep) : SWS, REM
    num_episodes, ... % Number of episodes: Wake, SWS, REM
    {latencies_sws, latencies_rem} ... % Latences : SWS et REM
};

% Remplissage du tableau pour chaque variable
row = 1; % Initialiser le compteur de ligne
for var_idx = 1:length(data_to_process)
    group_data = data_to_process{var_idx};
    
    % Identifier les sous-variables selon le type (par exemple, Wake, SWS, REM)
    if var_idx <= 2 % Cas des pourcentages
        for subvar_idx = 1:size(group_data{1}, 2)
            % Obtenir les données pour Wake, SWS, ou REM
            ctrl_data = group_data{1}(:, subvar_idx);
            mut_data = group_data{2}(:, subvar_idx);
            
            % Calcul des statistiques
            mean_ctrl = mean(ctrl_data, 'omitnan');
            median_ctrl = median(ctrl_data, 'omitnan');
            mean_mut = mean(mut_data, 'omitnan');
            median_mut = median(mut_data, 'omitnan');
            [~, p_value_ttest] = ttest2(ctrl_data, mut_data, 'Vartype', 'unequal');
            p_value_mannwhitney = ranksum(ctrl_data, mut_data);
            
            % Remplir le tableau
            results_table{row, 1} = variables_to_include{row};
            results_table{row, 2} = mean_ctrl;
            results_table{row, 3} = median_ctrl;
            results_table{row, 4} = mean_mut;
            results_table{row, 5} = median_mut;
            results_table{row, 6} = p_value_ttest;
            results_table{row, 7} = p_value_mannwhitney;
            row = row + 1;
        end
    elseif var_idx == 3 % Cas du nombre d'épisodes
        for subvar_idx = 1:3 % Wake, SWS, REM
            % Obtenir les données pour Wake, SWS, ou REM
            ctrl_data = group_data{1}(:, subvar_idx);
            mut_data = group_data{2}(:, subvar_idx);
            
            % Calcul des statistiques
            mean_ctrl = mean(ctrl_data, 'omitnan');
            median_ctrl = median(ctrl_data, 'omitnan');
            mean_mut = mean(mut_data, 'omitnan');
            median_mut = median(mut_data, 'omitnan');
            [~, p_value_ttest] = ttest2(ctrl_data, mut_data, 'Vartype', 'unequal');
            p_value_mannwhitney = ranksum(ctrl_data, mut_data);
            
            % Remplir le tableau
            results_table{row, 1} = variables_to_include{row};
            results_table{row, 2} = mean_ctrl;
            results_table{row, 3} = median_ctrl;
            results_table{row, 4} = mean_mut;
            results_table{row, 5} = median_mut;
            results_table{row, 6} = p_value_ttest;
            results_table{row, 7} = p_value_mannwhitney;
            row = row + 1;
        end
    elseif var_idx == 4 % Cas des latences
        for subvar_idx = 1:2 % Latence SWS, Latence REM
            ctrl_data = group_data{subvar_idx}{1}; % Contrôles
            mut_data = group_data{subvar_idx}{2}; % Mutants
            
            % Calcul des statistiques
            mean_ctrl = mean(ctrl_data, 'omitnan');
            median_ctrl = median(ctrl_data, 'omitnan');
            mean_mut = mean(mut_data, 'omitnan');
            median_mut = median(mut_data, 'omitnan');
            [~, p_value_ttest] = ttest2(ctrl_data, mut_data, 'Vartype', 'unequal');
            p_value_mannwhitney = ranksum(ctrl_data, mut_data);
            
            % Remplir le tableau
            results_table{row, 1} = variables_to_include{row};
            results_table{row, 2} = mean_ctrl;
            results_table{row, 3} = median_ctrl;
            results_table{row, 4} = mean_mut;
            results_table{row, 5} = median_mut;
            results_table{row, 6} = p_value_ttest;
            results_table{row, 7} = p_value_mannwhitney;
            row = row + 1;
        end
    end
end

% Convertir le tableau en une table MATLAB avec en-têtes
results_table_headers = {'Variable', 'Mean Ctrl', 'Median Ctrl', 'Mean Mut', 'Median Mut', 'p-value T-test', 'p-value Mann-Whitney'};
results_table = cell2table(results_table, 'VariableNames', results_table_headers);

% Afficher la table
disp(results_table);

% Sauvegarder dans un fichier Excel
writetable(results_table, 'Summary_SleepAnalysis.xlsx', 'Sheet', 1);

end