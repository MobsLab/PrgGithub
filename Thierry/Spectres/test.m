function compare_SleepWakeVariables_control_vs_mutant()

    % Liste des dossiers d'enregistrements pour les souris contrôles
    enregistrements_controles = { ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343/' ...
    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutants = { ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852/' ...
    };

    % Préparer les groupes et les noms de sujets
    groups = {'Controles', 'Mutants'};  % Retirer les accents ici
    enregistrements = {enregistrements_controles, enregistrements_mutants};

    % Initialisation des matrices pour stocker les données
    sleep_percentages_total_session = cell(1, 2);  
    sleep_percentages_total_sleep = cell(1, 2);
    total_durations = cell(1, 2);
    num_episodes = cell(1, 2);
    mean_durations = cell(1, 2);
    sd_durations = cell(1, 2);

    for g = 1:2  % Pour chaque groupe (contrôle et mutant)
        n_enregistrements = length(enregistrements{g});
        sleep_percentages_total_session{g} = zeros(n_enregistrements, 3);
        sleep_percentages_total_sleep{g} = zeros(n_enregistrements, 2);
        total_durations{g} = zeros(n_enregistrements, 3);
        num_episodes{g} = zeros(n_enregistrements, 3);
        mean_durations{g} = zeros(n_enregistrements, 3);
        sd_durations{g} = zeros(n_enregistrements, 3);

        for i = 1:n_enregistrements
            % Charger les périodes Wake, SWS, REM depuis SleepScoring_Accelero.mat
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
            if exist(accelero_path, 'file')
                load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  % Charger les périodes
            else
                error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{g}{i}]);
            end
            
            %% Calcul des pourcentages de Wake, SWS et REM par rapport à la session totale
            SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_session{g}(i, :) = SleepStagePerc_totSess(:, 1)';  

            %% Calcul des pourcentages de SWS et REM par rapport au total du sommeil
            SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_sleep{g}(i, :) = SleepStagePerc_totSleep(2:3, 1)';

            %% Calcul des durées totales et des épisodes pour Wake, SWS et REM
            [durWAKE, durTWAKE] = DurationEpoch(Wake);
            total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600;
            num_episodes{g}(i, 1) = length(durWAKE);             
            mean_durations{g}(i, 1) = mean(durWAKE / 1e4) / 60;
            sd_durations{g}(i, 1) = std(durWAKE / 1e4) / 60;     

            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;   
            num_episodes{g}(i, 2) = length(durSWS);              
            mean_durations{g}(i, 2) = mean(durSWS / 1e4) / 60;   
            sd_durations{g}(i, 2) = std(durSWS / 1e4) / 60;      

            [durREM, durTREM] = DurationEpoch(REMEpoch);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;   
            num_episodes{g}(i, 3) = length(durREM);              
            mean_durations{g}(i, 3) = mean(durREM / 1e4) / 60;   
            sd_durations{g}(i, 3) = std(durREM / 1e4) / 60;      
        end
    end

    % Données à analyser
    data_sets = {sleep_percentages_total_session, sleep_percentages_total_sleep, total_durations, num_episodes};
    y_labels = {'% du temps (total session)', '% du temps (total sommeil)', 'Durée totale (heures)', 'Nombre d''épisodes'};
    titles = {'Pourcentage de Wake, SWS, et REM (total session)', ...
              'Pourcentage de SWS et REM (total sommeil)', ...
              'Durée totale de Wake, SWS, et REM (en heures)', ...
              'Nombre d''épisodes de Wake, SWS, et REM'};

    % Fonction pour générer les graphiques
    function plot_with_stars(test_type)
        figure;
        for k = 1:length(data_sets)
            subplot(2, 2, k);
            hold on;
            data_control = data_sets{k}{1};
            data_mutant = data_sets{k}{2};
            
            bar_data = [median(data_control); median(data_mutant)];
            bar(1:size(bar_data, 2), bar_data', 'grouped');
            
            % Affichage des points individuels
            for g = 1:2
                group_data = data_sets{k}{g};
                for j = 1:size(group_data, 2)
                    scatter(repmat(j + (g-1.5) * 0.15, size(group_data, 1), 1), ...
                            group_data(:, j), 50, colors(g, :), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
                end
            end

            % Test statistique et ajout des étoiles de significativité
            for j = 1:size(data_control, 2)
                if strcmp(test_type, 'ttest')
                    [~, p_val] = ttest2(data_control(:, j), data_mutant(:, j));
                elseif strcmp(test_type, 'ranksum')
                    p_val = ranksum(data_control(:, j), data_mutant(:, j));
                end

                y_max = max([bar_data(:, j)]) * 1.1; % Position de l'étoile

                if p_val < 0.001
                    text(j, y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                elseif p_val < 0.01
                    text(j, y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                elseif p_val < 0.05
                    text(j, y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
                end
            end

            ylabel(y_labels{k});
            title(titles{k});
            legend(groups, 'Location', 'Best');
            hold off;
        end
    end

    % Génération des graphiques
    plot_with_stars('ttest');  % Avec test de Student
    plot_with_stars('ranksum');  % Avec test Mann-Whitney
end
