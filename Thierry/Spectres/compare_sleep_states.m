function compare_sleep_states()

    % Liste des dossiers d'enregistrements
    enregistrements = { ...
%         '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1/', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1/', ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3/' ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/',...
    };

    % Générer dynamiquement les noms des sujets en fonction des dossiers
    subjects = cell(1, length(enregistrements));
    for i = 1:length(enregistrements)
        [~, folder_name] = fileparts(enregistrements{i});
        subjects{i} = folder_name;  % Extraire le nom du dossier, par exemple 'M1', 'M2', etc.
    end

    % Matrices pour stocker les données par sujet
    sleep_percentages_total_session = zeros(length(enregistrements), 3);  % Colonnes : [Wake, SWS, REM]
    sleep_percentages_total_sleep = zeros(length(enregistrements), 2);    % Colonnes : [SWS, REM]
    total_durations = zeros(length(enregistrements), 3);                 % Colonnes : [Wake, SWS, REM]
    num_episodes = zeros(length(enregistrements), 3);                    % Colonnes : [Wake, SWS, REM]
    mean_durations = zeros(length(enregistrements), 3);                  % Colonnes : [Wake, SWS, REM]
    sd_durations = zeros(length(enregistrements), 3);                    % Colonnes : [Wake, SWS, REM] pour l'écart-type des durées moyennes
    
    % Boucle sur chaque sujet pour charger les périodes et calculer les statistiques
    for i = 1:length(enregistrements)
        % Charger les périodes Wake, SWS, REM depuis SleepScoring_Accelero.mat
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  % Charger les périodes
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{i}]);
        end
        
        %% Calcul des pourcentages de Wake, SWS et REM par rapport à la session totale
        SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
        sleep_percentages_total_session(i, 1) = SleepStagePerc_totSess(1, 1);  % Wake
        sleep_percentages_total_session(i, 2) = SleepStagePerc_totSess(2, 1);  % SWS
        sleep_percentages_total_session(i, 3) = SleepStagePerc_totSess(3, 1);  % REM

        %% Calcul des pourcentages de SWS et REM par rapport au total du sommeil
        SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
        sleep_percentages_total_sleep(i, 1) = SleepStagePerc_totSleep(2, 1);  % SWS
        sleep_percentages_total_sleep(i, 2) = SleepStagePerc_totSleep(3, 1);  % REM

        %% Calcul des durées totales et des épisodes pour Wake, SWS et REM
        % Pour Wake
        [durWAKE, durTWAKE] = DurationEpoch(Wake);
        total_durations(i, 1) = (durTWAKE / 1e4) / 3600;  % Durée totale de Wake en heures
        num_episodes(i, 1) = length(durWAKE);             % Nombre d'épisodes de Wake
        mean_durations(i, 1) = mean(durWAKE / 1e4) / 60;  % Durée moyenne de Wake en minutes
        sd_durations(i, 1) = std(durWAKE / 1e4) / 60;     % Écart-type de la durée moyenne de Wake

        % Pour SWS
        [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
        total_durations(i, 2) = (durTSWS / 1e4) / 3600;   % Durée totale de SWS en heures
        num_episodes(i, 2) = length(durSWS);              % Nombre d'épisodes de SWS
        mean_durations(i, 2) = mean(durSWS / 1e4) / 60;   % Durée moyenne de SWS en minutes
        sd_durations(i, 2) = std(durSWS / 1e4) / 60;      % Écart-type de la durée moyenne de SWS

        % Pour REM
        [durREM, durTREM] = DurationEpoch(REMEpoch);
        total_durations(i, 3) = (durTREM / 1e4) / 3600;   % Durée totale de REM en heures
        num_episodes(i, 3) = length(durREM);              % Nombre d'épisodes de REM
        mean_durations(i, 3) = mean(durREM / 1e4) / 60;   % Durée moyenne de REM en minutes
        sd_durations(i, 3) = std(durREM / 1e4) / 60;      % Écart-type de la durée moyenne de REM
    end

    % Afficher les résultats
    states_session = {'Wake', 'SWS', 'REM'};
    states_sleep = {'SWS', 'REM'};
    
    disp('Pourcentage de temps passé dans chaque état pour chaque sujet (total session) :');
    for i = 1:length(enregistrements)
        fprintf('%s:\n', subjects{i});
        for j = 1:3
            fprintf('  %s: %.2f%%\n', states_session{j}, sleep_percentages_total_session(i, j));
        end
    end

    % Graphiques des résultats
    figure;

    % Pourcentage de Wake, SWS, et REM pour chaque sujet (total session)
    subplot(2, 2, 1);
    bar(sleep_percentages_total_session);
    set(gca, 'XTickLabel', subjects);
    xlabel('Sujets');
    ylabel('% du temps (total session)');
    title('Pourcentage de Wake, SWS, et REM par session pour chaque sujet');
    legend(states_session, 'Location', 'Best');
    
    % Pourcentage de SWS et REM pour chaque sujet (total sommeil)
    subplot(2, 2, 2);
    bar(sleep_percentages_total_sleep);
    set(gca, 'XTickLabel', subjects);
    xlabel('Sujets');
    ylabel('% du temps (total sommeil)');
    title('Pourcentage de SWS et REM par rapport au total du sommeil');
    legend(states_sleep, 'Location', 'Best');
    
    % Durée totale de Wake, SWS et REM pour chaque sujet
    subplot(2, 2, 3);
    bar(total_durations);
    set(gca, 'XTickLabel', subjects);
    xlabel('Sujets');
    ylabel('Durée totale (heures)');
    title('Durée totale de Wake, SWS, et REM (en heures)');
    legend(states_session, 'Location', 'Best');
    
    % Nombre d'épisodes de Wake, SWS et REM pour chaque sujet
    subplot(2, 2, 4);
    bar(num_episodes);
    set(gca, 'XTickLabel', subjects);
    xlabel('Sujets');
    ylabel('Nombre episodes');
    title('Nombre episodes de Wake, SWS, et REM');
    legend(states_session, 'Location', 'Best');
 
%     % Durée moyenne d'un épisode de Wake, SWS et REM pour chaque sujet (avec barres d'erreur)
%     subplot(3, 2, 5);
%     hold on;
%     bar(mean_durations);
% %     % Ajouter les barres d'erreur
% %     for i = 1:3
% %         errorbar(1:length(subjects), mean_durations(:, i), sd_durations(:, i), '.k', 'LineWidth', 1.5);
% %     end
%     set(gca, 'XTickLabel', subjects);
%     xlabel('Sujets');
%     ylabel('Durée moyenne episode (minutes)');
%     title('Durée moyenne episode de Wake, SWS, et REM (en minutes)');
%     legend(states_session, 'Location', 'Best');
    
end
