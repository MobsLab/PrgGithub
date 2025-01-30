function compare_control_vs_mutant()

    % Liste des dossiers d'enregistrements pour les souris contrôles
    enregistrements_controle = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ...
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ...
    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutant = { ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9' ...
    };

    % Préparer les groupes et les noms de sujets
    groups = {'Controles', 'Mutants'};  % Retirer les accents ici
    enregistrements = {enregistrements_controle, enregistrements_mutant};
    
    % Initialisation des matrices pour stocker les données
    sleep_percentages_total_session = cell(1, 2);  % Deux groupes
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
            
            % Calcul des pourcentages de Wake, SWS et REM par rapport à la session totale
            SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_session{g}(i, :) = SleepStagePerc_totSess(:, 1)';

            % Calcul des pourcentages de SWS et REM par rapport au total du sommeil
            SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_sleep{g}(i, :) = SleepStagePerc_totSleep(2:3, 1)';

            % Calcul des durées totales et des épisodes pour Wake, SWS et REM
            % Pour Wake
            [durWAKE, durTWAKE] = DurationEpoch(Wake);
            total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600;
            num_episodes{g}(i, 1) = length(durWAKE);
            mean_durations{g}(i, 1) = mean(durWAKE / 1e4) / 60;
            sd_durations{g}(i, 1) = std(durWAKE / 1e4) / 60;

            % Pour SWS
            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;
            num_episodes{g}(i, 2) = length(durSWS);
            mean_durations{g}(i, 2) = mean(durSWS / 1e4) / 60;
            sd_durations{g}(i, 2) = std(durSWS / 1e4) / 60;

            % Pour REM
            [durREM, durTREM] = DurationEpoch(REMEpoch);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;
            num_episodes{g}(i, 3) = length(durREM);
            mean_durations{g}(i, 3) = mean(durREM / 1e4) / 60;
            sd_durations{g}(i, 3) = std(durREM / 1e4) / 60;
        end
    end

    % Création de la table récapitulative
    all_enregistrements = [enregistrements_controle, enregistrements_mutant]';
    group_labels = [repmat({'Contrôles'}, length(enregistrements_controle), 1); repmat({'Mutants'}, length(enregistrements_mutant), 1)];

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

