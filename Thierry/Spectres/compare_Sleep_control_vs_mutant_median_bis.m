function compare_control_vs_mutant()

    % Liste des dossiers d'enregistrements pour les souris contrôles
     enregistrements_controle = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... % SOMsup not goood - noPFC 
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ... % SOMsup not goood - noPFC 
%         '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3', ...
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/', ... % PFCsup not good - HPCrip not good
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... % PFCsup not good - HPCrip not good
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4', ... % PFCsup not good - HPCrip not good
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5', ...
%         '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ...
                %'/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M2',... % SOMsup not goood - noPFC - OBGamma
                % '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M3', ...% OBGamma

    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutant = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ... %noPFC - low sleep
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %noPFC - low sleep
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1', ... %noPFC - low sleep
%         '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7', ...%theta not good - % OBGamma
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9' ...
                %'/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M7', ... %theta not good

    };

    % Préparer les groupes et les noms de sujets
    groups = {'Contrôles', 'Mutants'};
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
            
            %% Calcul des pourcentages de Wake, SWS et REM par rapport à la session totale
            SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_session{g}(i, 1) = SleepStagePerc_totSess(1, 1);  % Wake
            sleep_percentages_total_session{g}(i, 2) = SleepStagePerc_totSess(2, 1);  % SWS
            sleep_percentages_total_session{g}(i, 3) = SleepStagePerc_totSess(3, 1);  % REM

            %% Calcul des pourcentages de SWS et REM par rapport au total du sommeil
            SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
            sleep_percentages_total_sleep{g}(i, 1) = SleepStagePerc_totSleep(2, 1);  % SWS
            sleep_percentages_total_sleep{g}(i, 2) = SleepStagePerc_totSleep(3, 1);  % REM

            %% Calcul des durées totales et des épisodes pour Wake, SWS et REM
            % Pour Wake
            [durWAKE, durTWAKE] = DurationEpoch(Wake);
            total_durations{g}(i, 1) = (durTWAKE / 1e4) / 3600;  % Durée totale de Wake en heures
            num_episodes{g}(i, 1) = length(durWAKE);             % Nombre d'épisodes de Wake
            mean_durations{g}(i, 1) = mean(durWAKE / 1e4) / 60;  % Durée moyenne de Wake en minutes
            sd_durations{g}(i, 1) = std(durWAKE / 1e4) / 60;     % Écart-type de la durée moyenne de Wake

            % Pour SWS
            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            total_durations{g}(i, 2) = (durTSWS / 1e4) / 3600;   % Durée totale de SWS en heures
            num_episodes{g}(i, 2) = length(durSWS);              % Nombre d'épisodes de SWS
            mean_durations{g}(i, 2) = mean(durSWS / 1e4) / 60;   % Durée moyenne de SWS en minutes
            sd_durations{g}(i, 2) = std(durSWS / 1e4) / 60;      % Écart-type de la durée moyenne de SWS

            % Pour REM
            [durREM, durTREM] = DurationEpoch(REMEpoch);
            total_durations{g}(i, 3) = (durTREM / 1e4) / 3600;   % Durée totale de REM en heures
            num_episodes{g}(i, 3) = length(durREM);              % Nombre d'épisodes de REM
            mean_durations{g}(i, 3) = mean(durREM / 1e4) / 60;   % Durée moyenne de REM en minutes
            sd_durations{g}(i, 3) = std(durREM / 1e4) / 60;      % Écart-type de la durée moyenne de REM
        end
    end

    % Calcul des médianes et des intervalles interquartiles (25e et 75e percentiles) pour chaque groupe
    med_sleep_percentages_total_session = cellfun(@median, sleep_percentages_total_session, 'UniformOutput', false);
    iqr_sleep_percentages_total_session = cellfun(@(x) prctile(x, [25 75]), sleep_percentages_total_session, 'UniformOutput', false);
    
    med_sleep_percentages_total_sleep = cellfun(@median, sleep_percentages_total_sleep, 'UniformOutput', false);
    iqr_sleep_percentages_total_sleep = cellfun(@(x) prctile(x, [25 75]), sleep_percentages_total_sleep, 'UniformOutput', false);
    
    med_total_durations = cellfun(@median, total_durations, 'UniformOutput', false);
    iqr_total_durations = cellfun(@(x) prctile(x, [25 75]), total_durations, 'UniformOutput', false);
    
    med_num_episodes = cellfun(@median, num_episodes, 'UniformOutput', false);
    iqr_num_episodes = cellfun(@(x) prctile(x, [25 75]), num_episodes, 'UniformOutput', false);

    % Couleurs pour les points individuels
    colors = [0 0 1; 1 0 0]; % Bleu pour contrôles, rouge pour mutants

    % Graphiques pour comparer les souris contrôles et mutantes
    data_points = struct();  % Structure pour stocker les valeurs de chaque point


    figure;

    % Pourcentage médian de Wake, SWS, et REM (total session)
    subplot(2, 2, 1);
    hold on;
    bar(1:3, [med_sleep_percentages_total_session{1}; med_sleep_percentages_total_session{2}]', 'grouped');
    for g = 1:2
        for j = 1:3
            scatter(repmat(j + (g-1.5) * 0.15, size(sleep_percentages_total_session{g}, 1), 1), ...
                sleep_percentages_total_session{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
                % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_sleep_percentages_total_session']).(groups{g}).(sprintf('State_%d', j)) = sleep_percentages_total_session{g}(:, j);
        end
        errorbar((1:3) + (g-1.5) * 0.15, med_sleep_percentages_total_session{g}, ...
            med_sleep_percentages_total_session{g} - iqr_sleep_percentages_total_session{g}(1,:), ...
            iqr_sleep_percentages_total_session{g}(2,:) - med_sleep_percentages_total_session{g}, '.k', 'LineWidth', 1.5);
    end
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
    xlabel('États');
    ylabel('% du temps (total session)');
    title('Pourcentage médian de Wake, SWS, et REM (total session)');
    legend(groups, 'Location', 'Best');
        % Afficher les valeurs enregistrées pour chaque point dans la console
disp('sleep_percentages_total_session :');
disp(data_points.(['group', num2str(g), '_sleep_percentages_total_session']));

    % Pourcentage médian de SWS et REM (total sommeil)
    subplot(2, 2, 2);
    hold on;
    bar(1:2, [med_sleep_percentages_total_sleep{1}; med_sleep_percentages_total_sleep{2}]', 'grouped');
    for g = 1:2
        for j = 1:2
            scatter(repmat(j + (g-1.5) * 0.15, size(sleep_percentages_total_sleep{g}, 1), 1), ...
                sleep_percentages_total_sleep{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
              % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_sleep_percentages_total_sleep']).(groups{g}).(sprintf('State_%d', j)) = sleep_percentages_total_sleep{g}(:, j);
        end
        errorbar((1:2) + (g-1.5) * 0.15, med_sleep_percentages_total_sleep{g}, ...
            med_sleep_percentages_total_sleep{g} - iqr_sleep_percentages_total_sleep{g}(1,:), ...
            iqr_sleep_percentages_total_sleep{g}(2,:) - med_sleep_percentages_total_sleep{g}, '.k', 'LineWidth', 1.5);
    end
    set(gca, 'XTick', 1:2, 'XTickLabel', {'SWS', 'REM'});
    xlabel('États');
    ylabel('% du temps (total sommeil)');
    title('Pourcentage médian de SWS et REM (total sommeil)');
    legend(groups, 'Location', 'Best');
       % Afficher les valeurs enregistrées pour chaque point dans la console
disp('sleep_percentages_total_sleep :');
disp(data_points.(['group', num2str(g), '_sleep_percentages_total_sleep']));

    % Durée totale médiane de Wake, SWS et REM
    subplot(2, 2, 3);
    hold on;
    bar(1:3, [med_total_durations{1}; med_total_durations{2}]', 'grouped');
    for g = 1:2
        for j = 1:3
            scatter(repmat(j + (g-1.5) * 0.15, size(total_durations{g}, 1), 1), ...
                total_durations{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
                % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_total_durations']).(groups{g}).(sprintf('State_%d', j)) = total_durations{g}(:, j);
        end
        errorbar((1:3) + (g-1.5) * 0.15, med_total_durations{g}, ...
            med_total_durations{g} - iqr_total_durations{g}(1,:), ...
            iqr_total_durations{g}(2,:) - med_total_durations{g}, '.k', 'LineWidth', 1.5);
    end
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
    xlabel('États');
    ylabel('Durée totale (heures)');
    title('Durée totale médiane de Wake, SWS, et REM (en heures)');
    legend(groups, 'Location', 'Best');
         % Afficher les valeurs enregistrées pour chaque point dans la console
disp('total_durations :');
disp(data_points.(['group', num2str(g), '_total_durations']));

    % Nombre médian d'épisodes de Wake, SWS et REM
    subplot(2, 2, 4);
    hold on;
    bar(1:3, [med_num_episodes{1}; med_num_episodes{2}]', 'grouped');
    for g = 1:2
        for j = 1:3
            scatter(repmat(j + (g-1.5) * 0.15, size(num_episodes{g}, 1), 1), ...
                num_episodes{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
           % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_num_episodes']).(groups{g}).(sprintf('State_%d', j)) = num_episodes{g}(:, j);
        end
        errorbar((1:3) + (g-1.5) * 0.15, med_num_episodes{g}, ...
            med_num_episodes{g} - iqr_num_episodes{g}(1,:), ...
            iqr_num_episodes{g}(2,:) - med_num_episodes{g}, '.k', 'LineWidth', 1.5);
    end
    set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
    xlabel('États');
    ylabel('Nombre médian episodes');
    title('Nombre médian episodes de Wake, SWS, et REM');
    legend(groups, 'Location', 'Best');
        % Afficher les valeurs enregistrées pour chaque point dans la console
    disp('num_episodes :');
    disp(data_points.(['group', num2str(g), '_num_episodes']));

end