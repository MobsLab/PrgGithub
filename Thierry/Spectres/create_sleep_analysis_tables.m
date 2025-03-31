function create_sleep_analysis_tables()

    % Liste des dossiers d'enregistrements pour les souris contrôles
    enregistrements_controle = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4', ...
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5', ...
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ...
    };

    % Liste des dossiers d'enregistrements pour les souris mutantes
    enregistrements_mutant = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9', ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9', ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7' ...
    };

    % Préparer les groupes
    groups = {'Controle', 'Mutant'};
    enregistrements = {enregistrements_controle, enregistrements_mutant};

    % Initialisation des données pour les tableaux
    data_tables = cell(1, 2);  % Stockera un tableau pour chaque groupe

    for g = 1:2
        n_enregistrements = length(enregistrements{g});
        table_data = cell(n_enregistrements, 13);  % 13 colonnes pour les différentes variables

        for i = 1:n_enregistrements
            % Charger les périodes Wake, SWS, REM
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');
            if exist(accelero_path, 'file')
                load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
            else
                error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{g}{i}]);
            end

            % Nom de l'enregistrement
            table_data{i, 1} = enregistrements{g}{i};

            % Calcul des pourcentages de chaque état par rapport à la session totale
            SleepStagePerc_totSess = ComputeSleepStagesPercentagesMC(Wake, SWSEpoch, REMEpoch);
            table_data{i, 2} = SleepStagePerc_totSess(1, 1);  % Wake %
            table_data{i, 3} = SleepStagePerc_totSess(2, 1);  % SWS %
            table_data{i, 4} = SleepStagePerc_totSess(3, 1);  % REM %

            % Calcul des pourcentages de SWS et REM par rapport au total du sommeil
            SleepStagePerc_totSleep = ComputeSleepStagesPercentagesWithoutWakeMC(Wake, SWSEpoch, REMEpoch);
            table_data{i, 5} = SleepStagePerc_totSleep(2, 1);  % SWS % du sommeil
            table_data{i, 6} = SleepStagePerc_totSleep(3, 1);  % REM % du sommeil

            % Durée totale et nombre d'épisodes de Wake, SWS et REM
            [durWAKE, durTWAKE] = DurationEpoch(Wake);
            table_data{i, 7} = (durTWAKE / 1e4) / 3600;          % Durée totale de Wake en heures
            table_data{i, 8} = length(durWAKE);                  % Nombre d'épisodes de Wake
            table_data{i, 9} = mean(durWAKE / 1e4) / 60;         % Durée moyenne des épisodes de Wake en minutes

            [durSWS, durTSWS] = DurationEpoch(SWSEpoch);
            table_data{i, 10} = (durTSWS / 1e4) / 3600;         % Durée totale de SWS en heures
            table_data{i, 11} = length(durSWS);                 % Nombre d'épisodes de SWS
            table_data{i, 12} = mean(durSWS / 1e4) / 60;        % Durée moyenne des épisodes de SWS en minutes

            [durREM, durTREM] = DurationEpoch(REMEpoch);
            table_data{i, 13} = (durTREM / 1e4) / 3600;         % Durée totale de REM en heures
            table_data{i, 14} = length(durREM);                 % Nombre d'épisodes de REM
            table_data{i, 15} = mean(durREM / 1e4) / 60;        % Durée moyenne des épisodes de REM en minutes
        end

        % Créer le tableau pour le groupe actuel
        data_tables{g} = cell2table(table_data, 'VariableNames', ...
            {'Enregistrement', 'Wake_Session_Percent', 'SWS_Session_Percent', 'REM_Session_Percent', ...
             'SWS_Sleep_Percent', 'REM_Sleep_Percent', 'Total_Wake_Hours', 'Wake_Episodes', ...
             'Mean_Wake_Duration_Min', 'Total_SWS_Hours', 'SWS_Episodes', ...
             'Mean_SWS_Duration_Min', 'Total_REM_Hours', 'REM_Episodes', 'Mean_REM_Duration_Min'});
    end

    % Afficher les tableaux pour chaque groupe
    disp('Tableau des contrôles :');
    disp(data_tables{1});
    disp('Tableau des mutants :');
    disp(data_tables{2});

    % Sauvegarder les tableaux en fichier .mat si besoin
    save('sleep_analysis_control.mat', 'data_tables');
end
