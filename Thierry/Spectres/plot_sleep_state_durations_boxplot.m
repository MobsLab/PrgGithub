function plot_sleep_state_durations_points(enregistrements_controle, enregistrements_mutant)

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
%       '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M7', ... %theta not good - % OBGamma


    };

    % Initialiser des matrices pour stocker les durées moyennes des épisodes
    mean_wake_durations_controle = zeros(length(enregistrements_controle), 1);
    mean_sws_durations_controle = zeros(length(enregistrements_controle), 1);
    mean_rem_durations_controle = zeros(length(enregistrements_controle), 1);
    
    mean_wake_durations_mutant = zeros(length(enregistrements_mutant), 1);
    mean_sws_durations_mutant = zeros(length(enregistrements_mutant), 1);
    mean_rem_durations_mutant = zeros(length(enregistrements_mutant), 1);

    % Calcul des durées moyennes pour les enregistrements contrôles
    for i = 1:length(enregistrements_controle)
        accelero_path = fullfile(enregistrements_controle{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements_controle{i}]);
        end

        mean_wake_durations_controle(i) = mean((End(Wake) - Start(Wake)) / 1e4) / 60;
        mean_sws_durations_controle(i) = mean((End(SWSEpoch) - Start(SWSEpoch)) / 1e4) / 60;
        mean_rem_durations_controle(i) = mean((End(REMEpoch) - Start(REMEpoch)) / 1e4) / 60;
    end

    % Calcul des durées moyennes pour les enregistrements mutants
    for i = 1:length(enregistrements_mutant)
        accelero_path = fullfile(enregistrements_mutant{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements_mutant{i}]);
        end

        mean_wake_durations_mutant(i) = mean((End(Wake) - Start(Wake)) / 1e4) / 60;
        mean_sws_durations_mutant(i) = mean((End(SWSEpoch) - Start(SWSEpoch)) / 1e4) / 60;
        mean_rem_durations_mutant(i) = mean((End(REMEpoch) - Start(REMEpoch)) / 1e4) / 60;
    end

    % Création des graphiques avec les points, médiane, et écart-type
    figure;

    % --- Wake ---
    subplot(1, 3, 1); hold on;
    scatter(ones(size(mean_wake_durations_controle)), mean_wake_durations_controle, 'b', 'filled');
    scatter(2 * ones(size(mean_wake_durations_mutant)), mean_wake_durations_mutant, 'r', 'filled');
    
    % Calcul et affichage des lignes de médiane et écart-type
    plot([1 1], [median(mean_wake_durations_controle) - std(mean_wake_durations_controle), ...
                 median(mean_wake_durations_controle) + std(mean_wake_durations_controle)], 'b', 'LineWidth', 2);
    plot([2 2], [median(mean_wake_durations_mutant) - std(mean_wake_durations_mutant), ...
                 median(mean_wake_durations_mutant) + std(mean_wake_durations_mutant)], 'r', 'LineWidth', 2);
    scatter(1, median(mean_wake_durations_controle), 'bo', 'filled');
    scatter(2, median(mean_wake_durations_mutant), 'ro', 'filled');
    
    title('Wake');
    xlim([0.5 2.5]);
    xticks([1 2]);
    xticklabels({'Controle', 'Mutant'});
    ylabel('Durée moyenne (minutes)');

    % --- SWS ---
    subplot(1, 3, 2); hold on;
    scatter(ones(size(mean_sws_durations_controle)), mean_sws_durations_controle, 'b', 'filled');
    scatter(2 * ones(size(mean_sws_durations_mutant)), mean_sws_durations_mutant, 'r', 'filled');
    
    % Calcul et affichage des lignes de médiane et écart-type
    plot([1 1], [median(mean_sws_durations_controle) - std(mean_sws_durations_controle), ...
                 median(mean_sws_durations_controle) + std(mean_sws_durations_controle)], 'b', 'LineWidth', 2);
    plot([2 2], [median(mean_sws_durations_mutant) - std(mean_sws_durations_mutant), ...
                 median(mean_sws_durations_mutant) + std(mean_sws_durations_mutant)], 'r', 'LineWidth', 2);
    scatter(1, median(mean_sws_durations_controle), 'bo', 'filled');
    scatter(2, median(mean_sws_durations_mutant), 'ro', 'filled');
    
    title('SWS');
    xlim([0.5 2.5]);
    xticks([1 2]);
    xticklabels({'Controle', 'Mutant'});
    ylabel('Durée moyenne (minutes)');

    % --- REM ---
    subplot(1, 3, 3); hold on;
    scatter(ones(size(mean_rem_durations_controle)), mean_rem_durations_controle, 'b', 'filled');
    scatter(2 * ones(size(mean_rem_durations_mutant)), mean_rem_durations_mutant, 'r', 'filled');
    
    % Calcul et affichage des lignes de médiane et écart-type
    plot([1 1], [median(mean_rem_durations_controle) - std(mean_rem_durations_controle), ...
                 median(mean_rem_durations_controle) + std(mean_rem_durations_controle)], 'b', 'LineWidth', 2);
    plot([2 2], [median(mean_rem_durations_mutant) - std(mean_rem_durations_mutant), ...
                 median(mean_rem_durations_mutant) + std(mean_rem_durations_mutant)], 'r', 'LineWidth', 2);
    scatter(1, median(mean_rem_durations_controle), 'bo', 'filled');
    scatter(2, median(mean_rem_durations_mutant), 'ro', 'filled');
    
    title('REM');
    xlim([0.5 2.5]);
    xticks([1 2]);
    xticklabels({'Controle', 'Mutant'});
    ylabel('Durée moyenne (minutes)');

end
