function compare_SleepWakeVariablesWiNoise_control_vs_mutant()
    % Compare les variables de sommeil et d'éveil entre les groupes de souris contrôles et mutants.
    % Deux tests statistiques sont utilisés : Test de Student (t-test) et Mann-Whitney (ranksum).
    % Les résultats sont affichés sous forme de graphiques avec des étoiles de significativité.

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
    mean_durations = cell(1, 2);
    sd_durations = cell(1, 2);

    %% Boucle sur les groupes pour calculer les métriques
    for g = 1:2
        n_enregistrements = length(enregistrements{g});
        sleep_percentages_total_session{g} = zeros(n_enregistrements, 3);
        sleep_percentages_total_sleep{g} = zeros(n_enregistrements, 2);
        total_durations{g} = zeros(n_enregistrements, 3);
        num_episodes{g} = zeros(n_enregistrements, 3);
        mean_durations{g} = zeros(n_enregistrements, 3);
        sd_durations{g} = zeros(n_enregistrements, 3);

        for i = 1:n_enregistrements
            % Charger le fichier contenant les périodes de sommeil et d'éveil
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
            if exist(accelero_path, 'file')
                load(accelero_path, 'WakeWiNoise', 'REMEpochWiNoise', 'SWSEpochWiNoise');
            else
                error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{g}{i}]);
            end
            
            % Calcul des pourcentages de chaque état (WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise) par rapport à la session totale
            SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise);
            sleep_percentages_total_session{g}(i, :) = SleepStagePerc_totSess(:, 1)';  

            % Calcul des pourcentages par rapport au temps de sommeil total (sans WakeWiNoise)
            SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise);
            sleep_percentages_total_sleep{g}(i, :) = SleepStagePerc_totSleep(2:3, 1)';

            % Calcul des durées totales, moyennes, et écarts-types pour chaque état
            [durWAKE, durTWAKE] = DurationEpoch(WakeWiNoise);
            total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600; 
            num_episodes{g}(i, 1) = length(durWAKE);             
            mean_durations{g}(i, 1) = mean(durWAKE / 1e4) / 60;  
            sd_durations{g}(i, 1) = std(durWAKE / 1e4) / 60;     

            [durSWS, durTSWS] = DurationEpoch(SWSEpochWiNoise);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;   
            num_episodes{g}(i, 2) = length(durSWS);              
            mean_durations{g}(i, 2) = mean(durSWS / 1e4) / 60;   
            sd_durations{g}(i, 2) = std(durSWS / 1e4) / 60;      

            [durREM, durTREM] = DurationEpoch(REMEpochWiNoise);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;   
            num_episodes{g}(i, 3) = length(durREM);              
            mean_durations{g}(i, 3) = mean(durREM / 1e4) / 60;   
            sd_durations{g}(i, 3) = std(durREM / 1e4) / 60;      
        end
    end

    %% Définir les données pour les graphiques
    data_sets = {sleep_percentages_total_session, sleep_percentages_total_sleep, total_durations, num_episodes};
    y_labels = {'% du temps (total session)', '% du temps (total sommeil)', 'Durée totale (heures)', 'Nombre d''épisodes'};
    titles = {'Pourcentage de Wake, SWS, et REM (total session)', ...
              'Pourcentage de SWS et REM (total sommeil)', ...
              'Durée totale de Wake, SWS, et REM (en heures)', ...
              'Nombre d''épisodes de Wake, SWS, et REM'};
    colors = [0 0 1; 1 0 0];

    %% Génération des graphiques pour les deux tests
    for test_type = {'ttest', 'ranksum'}
        test_name = test_type{1};
        if strcmp(test_name, 'ttest')
            figure('Name', 'Test de Student');
        else
            figure('Name', 'Test de Mann-Whitney');
        end

        for k = 1:length(data_sets)
            subplot(2, 2, k);
            hold on;
            data_control = data_sets{k}{1};
            data_mutant = data_sets{k}{2};
            bar_data = [median(data_control); median(data_mutant)];
            bar(1:size(bar_data, 2), bar_data', 'grouped');

            for g = 1:2
                group_data = data_sets{k}{g};
                for j = 1:size(group_data, 2)
                    scatter(repmat(j + (g-1.5) * 0.15, size(group_data, 1), 1), ...
                            group_data(:, j), 50, colors(g, :), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
                end
            end

            for j = 1:size(data_control, 2)
                if strcmp(test_name, 'ttest')
                    [~, p_val] = ttest2(data_control(:, j), data_mutant(:, j));
                else
                    p_val = ranksum(data_control(:, j), data_mutant(:, j));
                end

                y_max = max([bar_data(:, j)]) * 1.1; 
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

   % Création de la table récapitulative
    all_enregistrements = [enregistrements_controles, enregistrements_mutants]';
    group_labels = [repmat({'Contrôles'}, length(enregistrements_controles), 1); repmat({'Mutants'}, length(enregistrements_mutants), 1)];

    % Rassembler toutes les données pour chaque variable
    sleep_total_session_data = [vertcat(sleep_percentages_total_session{1}); vertcat(sleep_percentages_total_session{2})];
    sleep_total_sleep_data = [vertcat(sleep_percentages_total_sleep{1}); vertcat(sleep_percentages_total_sleep{2})];
    total_durations_data = [vertcat(total_durations{1}); vertcat(total_durations{2})];
    num_episodes_data = [vertcat(num_episodes{1}); vertcat(num_episodes{2})];
    mean_durations_data = [vertcat(mean_durations{1}); vertcat(mean_durations{2})];
    sd_durations_data = [vertcat(sd_durations{1}); vertcat(sd_durations{2})];

    % Effectuer les tests statistiques et enregistrer les p-values
    p_values = struct();
    [~, p_values.Wake_Total_Session] = ttest2(sleep_percentages_total_session{1}(:, 1), sleep_percentages_total_session{2}(:, 1));
    [~, p_values.SWS_Total_Session] = ttest2(sleep_percentages_total_session{1}(:, 2), sleep_percentages_total_session{2}(:, 2));
    [~, p_values.REM_Total_Session] = ttest2(sleep_percentages_total_session{1}(:, 3), sleep_percentages_total_session{2}(:, 3));
    [~, p_values.SWS_Total_Sleep] = ttest2(sleep_percentages_total_sleep{1}(:, 1), sleep_percentages_total_sleep{2}(:, 1));
    [~, p_values.REM_Total_Sleep] = ttest2(sleep_percentages_total_sleep{1}(:, 2), sleep_percentages_total_sleep{2}(:, 2));
    [~, p_values.Total_Duration_Wake] = ttest2(total_durations{1}(:, 1), total_durations{2}(:, 1));
    [~, p_values.Total_Duration_SWS] = ttest2(total_durations{1}(:, 2), total_durations{2}(:, 2));
    [~, p_values.Total_Duration_REM] = ttest2(total_durations{1}(:, 3), total_durations{2}(:, 3));
    [~, p_values.Num_Episodes_Wake] = ttest2(num_episodes{1}(:, 1), num_episodes{2}(:, 1));
    [~, p_values.Num_Episodes_SWS] = ttest2(num_episodes{1}(:, 2), num_episodes{2}(:, 2));
    [~, p_values.Num_Episodes_REM] = ttest2(num_episodes{1}(:, 3), num_episodes{2}(:, 3));

    % Conversion des p-values en table
    p_values_table = struct2table(p_values, 'RowNames', {'p-value'});
    
    % Création des noms de variables compatibles
    var_names = { ...
        'Enregistrement', 'Groupe', ...
        'Wake_Total_Session_Percent', 'SWS_Total_Session_Percent', 'REM_Total_Session_Percent', ...
        'SWS_Total_Sleep_Percent', 'REM_Total_Sleep_Percent', ...
        'Total_Duration_Wake_hr', 'Total_Duration_SWS_hr', 'Total_Duration_REM_hr', ...
        'Num_Episodes_Wake', 'Num_Episodes_SWS', 'Num_Episodes_REM', ...
        'Mean_Duration_Wake_min', 'Mean_Duration_SWS_min', 'Mean_Duration_REM_min', ...
        'SD_Duration_Wake_min', 'SD_Duration_SWS_min', 'SD_Duration_REM_min' ...
    };

    % Création de la table récapitulative
    recap_table = table(all_enregistrements, group_labels, ...
        sleep_total_session_data(:, 1), sleep_total_session_data(:, 2), sleep_total_session_data(:, 3), ...
        sleep_total_sleep_data(:, 1), sleep_total_sleep_data(:, 2), ...
        total_durations_data(:, 1), total_durations_data(:, 2), total_durations_data(:, 3), ...
        num_episodes_data(:, 1), num_episodes_data(:, 2), num_episodes_data(:, 3), ...
        mean_durations_data(:, 1), mean_durations_data(:, 2), mean_durations_data(:, 3), ...
        sd_durations_data(:, 1), sd_durations_data(:, 2), sd_durations_data(:, 3), ...
        'VariableNames', var_names);

    disp(recap_table);
    disp(p_values_table);
end