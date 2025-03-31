function compare_SleepWakeVariables_control_vs_mutant_moyennes_medianes()
    % Compare les moyennes et les médianes des variables de sommeil entre groupes de souris contrôles et mutants.
    % Ajoute les erreurs standards de la moyenne (SEM) sur les barres et réalise les tests Mann-Whitney.

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
    sleep_percentages_total_session = cell(1, 2);  
    sleep_percentages_total_sleep = cell(1, 2);
    total_durations = cell(1, 2);
    num_episodes = cell(1, 2);

    %% Calcul des métriques pour chaque groupe
    for g = 1:2
        n_enregistrements = length(enregistrements{g});
        sleep_percentages_total_session{g} = zeros(n_enregistrements, 3); % Wake, SWS, REM
        sleep_percentages_total_sleep{g} = zeros(n_enregistrements, 2);   % SWS, REM
        total_durations{g} = zeros(n_enregistrements, 3);                % Wake, SWS, REM
        num_episodes{g} = zeros(n_enregistrements, 3);

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

            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;
            num_episodes{g}(i, 2) = length(durSWS);

            [durREM, durTREM] = DurationEpoch(REMEpoch);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;
            num_episodes{g}(i, 3) = length(durREM);
        end
    end

    %% Données pour les graphiques
    data_sets = {sleep_percentages_total_session, sleep_percentages_total_sleep, total_durations, num_episodes};
    y_labels = {'% du temps (total session)', '% du temps (total sommeil)', 'Durée totale (heures)', 'Nombre d''épisodes'};
    titles = {'Pourcentage de Wake, SWS, et REM (total session)', ...
              'Pourcentage de SWS et REM (total sommeil)', ...
              'Durée totale de Wake, SWS, et REM (en heures)', ...
              'Nombre d''épisodes de Wake, SWS, et REM'};
    colors = [0 0 1; 1 0 0]; % Bleu pour contrôles, rouge pour mutants

    %% Génération des graphiques pour les moyennes et les médianes
    stats_types = {'Moyenne', 'Médiane'};
    for stat_type = stats_types
        figure('Name', ['Comparaison des ' char(stat_type)]);
        for k = 1:length(data_sets)
            subplot(2, 2, k);
            hold on;
            data_control = data_sets{k}{1};
            data_mutant = data_sets{k}{2};

            % Calcul des moyennes/médianes et SEM
            if strcmp(stat_type, 'Moyenne')
                bar_data = [mean(data_control); mean(data_mutant)];
                sem_control = std(data_control) ./ sqrt(size(data_control, 1));
                sem_mutant = std(data_mutant) ./ sqrt(size(data_mutant, 1));
            else
                bar_data = [median(data_control); median(data_mutant)];
                sem_control = zeros(1, size(data_control, 2)); % Pas de SEM pour médianes
                sem_mutant = zeros(1, size(data_mutant, 2)); % Pas de SEM pour médianes
            end

            % Création des barres
            bar(1:size(bar_data, 2), bar_data', 'grouped');

            % Ajout des barres d'erreur (SEM)
            errorbar(1:size(bar_data, 2) - 0.15, bar_data(1, :), sem_control, 'k.', 'LineWidth', 1.5);
            errorbar(1:size(bar_data, 2) + 0.15, bar_data(2, :), sem_mutant, 'k.', 'LineWidth', 1.5);

            % Ajouter les points individuels
            for g = 1:2
                group_data = data_sets{k}{g};
                for j = 1:size(group_data, 2)
                    scatter(repmat(j + (g - 1.5) * 0.15, size(group_data, 1), 1), ...
                            group_data(:, j), 50, colors(g, :), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
                end
            end

            % Comparaisons statistiques (Mann-Whitney)
            for j = 1:size(data_control, 2)
                p_val = ranksum(data_control(:, j), data_mutant(:, j));
                y_max = max([bar_data(:, j)]) * 1.1;

                % Afficher les étoiles de significativité
                if p_val < 0.001
                    text(j, y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                elseif p_val < 0.01
                    text(j, y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                elseif p_val < 0.05
                    text(j, y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                end
            end

            % Ajouter les étiquettes et la légende
            ylabel(y_labels{k});
            title(titles{k});
            legend(groups, 'Location', 'Best');
            hold off;
        end
    end
end