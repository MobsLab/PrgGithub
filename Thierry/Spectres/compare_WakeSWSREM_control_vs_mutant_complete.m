function compare_WakeSWSREM_control_vs_mutant_Test()
    % % Liste des dossiers d'enregistrements pour les souris contrôles
    % enregistrements_controle = { ...
    %     '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ...
    %     '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
    %     '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ...
    %     '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ...
    % };
    % 
    % % Liste des dossiers d'enregistrements pour les souris mutantes
    % enregistrements_mutant = { ...
    %     '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ...
    %     '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
    %     '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
    %     '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9' ...
    % };


%%%%%%
% Liste des dossiers d'enregistrements pour les souris contrôles
    enregistrements_controle = { ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343/' ...
    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutant = { ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657/', ...
        '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852/' ...
    };


    % Préparer les groupes et les noms de sujets
    groups = {'Controles', 'Mutants'};
    enregistrements = {enregistrements_controle, enregistrements_mutant};

    % Initialisation des matrices pour stocker les données
    sleep_percentages_total_session = cell(1, 2);  
    sleep_percentages_total_sleep = cell(1, 2);
    total_durations = cell(1, 2);
    num_episodes = cell(1, 2);
    mean_durations = cell(1, 2);
    sd_durations = cell(1, 2);
    latencies = cell(1, 2); % Stocker les latences vers NREM et REM

    for g = 1:2  % Pour chaque groupe (contrôle et mutant)
        n_enregistrements = length(enregistrements{g});
        sleep_percentages_total_session{g} = zeros(n_enregistrements, 3);
        sleep_percentages_total_sleep{g} = zeros(n_enregistrements, 2);
        total_durations{g} = zeros(n_enregistrements, 3);
        num_episodes{g} = zeros(n_enregistrements, 3);
        mean_durations{g} = zeros(n_enregistrements, 3);
        sd_durations{g} = zeros(n_enregistrements, 3);
        latencies{g} = zeros(n_enregistrements, 2); % Latence vers NREM et REM

        for i = 1:n_enregistrements
            % Charger les périodes Wake, SWS, REM depuis SleepScoring_Accelero.mat
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
            if exist(accelero_path, 'file')
                load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  
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

            % Calcul de la latence pour NREM et REM
            start_of_recording = min([Start(Wake), Start(SWSEpoch), Start(REMEpoch)]);
            first_SWS_time = Start(SWSEpoch);
            first_REM_time = Start(REMEpoch);
            latencies{g}(i, 1) = (first_SWS_time - start_of_recording) / 1e4 / 60; % Latence NREM en minutes
            latencies{g}(i, 2) = (first_REM_time - start_of_recording) / 1e4 / 60; % Latence REM en minutes
        end
    end

    % Diagnostic des dimensions des matrices avant concaténation
    disp("Dimensions des matrices avant concaténation :");
    disp("sleep_percentages_total_session:");
    disp([size(sleep_percentages_total_session{1}); size(sleep_percentages_total_session{2})]);
    disp("sleep_percentages_total_sleep:");
    disp([size(sleep_percentages_total_sleep{1}); size(sleep_percentages_total_sleep{2})]);
    disp("total_durations:");
    disp([size(total_durations{1}); size(total_durations{2})]);
    disp("num_episodes:");
    disp([size(num_episodes{1}); size(num_episodes{2})]);
    disp("mean_durations:");
    disp([size(mean_durations{1}); size(mean_durations{2})]);
    disp("sd_durations:");
    disp([size(sd_durations{1}); size(sd_durations{2})]);
    disp("latencies:");
    disp([size(latencies{1}); size(latencies{2})]);

    % Création de la table récapitulative
    all_enregistrements = [enregistrements_controle, enregistrements_mutant]';
    group_labels = [repmat({'Contrôles'}, length(enregistrements_controle), 1); repmat({'Mutants'}, length(enregistrements_mutant), 1)];

    % Vérification et concaténation des données
    try
        sleep_total_session_data = [vertcat(sleep_percentages_total_session{1}); vertcat(sleep_percentages_total_session{2})];
        sleep_total_sleep_data = [vertcat(sleep_percentages_total_sleep{1}); vertcat(sleep_percentages_total_sleep{2})];
        total_durations_data = [vertcat(total_durations{1}); vertcat(total_durations{2})];
        num_episodes_data = [vertcat(num_episodes{1}); vertcat(num_episodes{2})];
        mean_durations_data = [vertcat(mean_durations{1}); vertcat(mean_durations{2})];
        sd_durations_data = [vertcat(sd_durations{1}); vertcat(sd_durations{2})];
        latencies_data = [vertcat(latencies{1}); vertcat(latencies{2})];
    catch ME
        disp("Erreur lors de la concaténation des données :");
        disp(ME.message);
        return;
    end

    % Création de la table finale avec les variables
    var_names = { ...
        'Enregistrement', 'Groupe', ...
        'Wake_Total_Session_Percent', 'SWS_Total_Session_Percent', 'REM_Total_Session_Percent', ...
        'SWS_Total_Sleep_Percent', 'REM_Total_Sleep_Percent', ...
        'Total_Duration_Wake_hr', 'Total_Duration_SWS_hr', 'Total_Duration_REM_hr', ...
        'Num_Episodes_Wake', 'Num_Episodes_SWS', 'Num_Episodes_REM', ...
        'Mean_Duration_Wake_min', 'Mean_Duration_SWS_min', 'Mean_Duration_REM_min', ...
        'SD_Duration_Wake_min', 'SD_Duration_SWS_min', 'SD_Duration_REM_min', ...
        'Latency_NREM_min', 'Latency_REM_min'};

    recap_table = table(all_enregistrements, group_labels, ...
        sleep_total_session_data(:, 1), sleep_total_session_data(:, 2), sleep_total_session_data(:, 3), ...
        sleep_total_sleep_data(:, 1), sleep_total_sleep_data(:, 2), ...
        total_durations_data(:, 1), total_durations_data(:, 2), total_durations_data(:, 3), ...
        num_episodes_data(:, 1), num_episodes_data(:, 2), num_episodes_data(:, 3), ...
        mean_durations_data(:, 1), mean_durations_data(:, 2), mean_durations_data(:, 3), ...
        sd_durations_data(:, 1), sd_durations_data(:, 2), sd_durations_data(:, 3), ...
        latencies_data(:, 1), latencies_data(:, 2), ...
        'VariableNames', var_names);

    disp(recap_table);
end

