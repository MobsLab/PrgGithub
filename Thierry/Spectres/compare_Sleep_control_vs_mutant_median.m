function compare_control_vs_mutant_median()

     % Liste des dossiers d'enregistrements pour les souris contrôles
     enregistrements_controle = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... % SOMsup not goood - noPFC 
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ... % SOMsup not goood - noPFC 
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/', ... % PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... % PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4', ... % PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5', ...
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ...
                %'/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M2',... % SOMsup not goood - noPFC - OBGamma
                % '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M3', ...% OBGamma

    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutant = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ... %noPFC - low sleep
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %noPFC - low sleep
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1', ... %noPFC - low sleep
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9' ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7', ...%theta not good - 
%         '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M7', ... %theta not good - % OBGamma


    };

    % Préparer les groupes et les noms de sujets
    groups = {'Contrôles', 'Mutants'};
    enregistrements = {enregistrements_controle, enregistrements_mutant};
    
    % Initialisation des matrices pour stocker les données
    sleep_percentages_total_session = cell(1, 2);  % Deux groupes
    total_durations = cell(1, 2);
    num_episodes = cell(1, 2);
    median_durations = cell(1, 2);  % Durée médiane des épisodes

    for g = 1:2  % Pour chaque groupe (contrôle et mutant)
        n_enregistrements = length(enregistrements{g});
        sleep_percentages_total_session{g} = zeros(n_enregistrements, 3);
        total_durations{g} = zeros(n_enregistrements, 3);
        num_episodes{g} = zeros(n_enregistrements, 3);
        median_durations{g} = zeros(n_enregistrements, 3);

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
            sleep_percentages_total_session{g}(i, 1) = SleepStagePerc_totSess(1, 1);  % Wake
            sleep_percentages_total_session{g}(i, 2) = SleepStagePerc_totSess(2, 1);  % SWS
            sleep_percentages_total_session{g}(i, 3) = SleepStagePerc_totSess(3, 1);  % REM

            %% Calcul des durées totales et des épisodes pour Wake, SWS et REM
            % Pour Wake
            [durWAKE, durTWAKE] = DurationEpoch(Wake);
            total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600;  % Durée totale de Wake en heures
            num_episodes{g}(i, 1) = length(durWAKE);             % Nombre d'épisodes de Wake
            median_durations{g}(i, 1) = median(durWAKE / 1e4) / 60;  % Durée médiane de Wake en minutes

            % Pour SWS
            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;   % Durée totale de SWS en heures
            num_episodes{g}(i, 2) = length(durSWS);              % Nombre d'épisodes de SWS
            median_durations{g}(i, 2) = median(durSWS / 1e4) / 60;  % Durée médiane de SWS en minutes

            % Pour REM
            [durREM, durTREM] = DurationEpoch(REMEpoch);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;   % Durée totale de REM en heures
            num_episodes{g}(i, 3) = length(durREM);              % Nombre d'épisodes de REM
            median_durations{g}(i, 3) = median(durREM / 1e4) / 60;  % Durée médiane de REM en minutes
        end
    end

    % Couleurs pour les points individuels
    colors = [0 0 1; 1 0 0]; % Bleu pour contrôles, rouge pour mutants

    % Graphiques pour comparer les souris contrôles et mutantes avec des points et médianes

    figure;

    % Pourcentage de Wake, SWS, et REM (total session)
    for j = 1:3
        subplot(3, 3, j);
        hold on;
        % Données groupées pour Wake, SWS, et REM
        scatter(ones(size(sleep_percentages_total_session{1}(:, j))), sleep_percentages_total_session{1}(:, j), 50, colors(1,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        scatter(2*ones(size(sleep_percentages_total_session{2}(:, j))), sleep_percentages_total_session{2}(:, j), 50, colors(2,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        title(['Pourcentage de ' {'Wake', 'SWS', 'REM'}{j} ' (total session)']);
        ylabel('% du temps');
        xticks([1, 2]);
        xticklabels(groups);
    end

    % Durée totale de Wake, SWS et REM
    for j = 1:3
        subplot(3, 3, j+3);
        hold on;
        % Données groupées pour Wake, SWS, et REM
        scatter(ones(size(total_durations{1}(:, j))), total_durations{1}(:, j), 50, colors(1,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        scatter(2*ones(size(total_durations{2}(:, j))), total_durations{2}(:, j), 50, colors(2,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        title(['Durée totale de ' {'Wake', 'SWS', 'REM'}{j}]);
        ylabel('Durée totale (heures)');
        xticks([1, 2]);
        xticklabels(groups);
    end

    % Durée médiane des épisodes de Wake, SWS et REM
    for j = 1:3
        subplot(3, 3, j+6);
        hold on;
        % Données groupées pour Wake, SWS, et REM
        scatter(ones(size(median_durations{1}(:, j))), median_durations{1}(:, j), 50, colors(1,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        scatter(2*ones(size(median_durations{2}(:, j))), median_durations{2}(:, j), 50, colors(2,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.15);
        title(['Durée médiane des épisodes de ' {'Wake', 'SWS', 'REM'}{j}]);
        ylabel('Durée médiane (minutes)');
        xticks([1, 2]);
        xticklabels(groups);
    end

end
