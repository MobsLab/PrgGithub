function calculate_and_plot_mean_durations()

    %% Définition des chemins d'enregistrements
    % Liste des dossiers contenant les enregistrements pour chaque souris
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

    % Regrouper tous les enregistrements
    groups = {'Controles', 'Mutants'};
    enregistrements = {enregistrements_controles, enregistrements_mutants};

    % Initialisation des résultats
    mean_durations = struct();

    %% Itération sur les groupes et calcul des durées moyennes
    for g = 1:2
        group_name = groups{g};
        for i = 1:length(enregistrements{g})
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');

            % Charger les données depuis le fichier
            if exist(accelero_path, 'file')
                load(accelero_path, 'Wake', 'WakeWiNoise', 'SWSEpoch', 'SWSEpochWiNoise', 'REMEpoch', 'REMEpochWiNoise');
            else
                error(['Fichier introuvable : ', accelero_path]);
            end

            % Calcul des durées moyennes des épisodes pour chaque état
            mean_durations(g, i).file = accelero_path; % Nom du fichier analysé
            mean_durations(g, i).group = group_name;   % Nom du groupe

            % Wake
            [durWake, ~] = DurationEpoch(Wake);
            mean_durations(g, i).Wake = mean(durWake / 1e4) / 60; % Convertir en minutes

            % WakeWiNoise
            [durWakeWiNoise, ~] = DurationEpoch(WakeWiNoise);
            mean_durations(g, i).WakeWiNoise = mean(durWakeWiNoise / 1e4) / 60;

            % SWSEpoch
            [durSWS, ~] = DurationEpoch(SWSEpoch);
            mean_durations(g, i).SWSEpoch = mean(durSWS / 1e4) / 60;

            % SWSEpochWiNoise
            [durSWSWiNoise, ~] = DurationEpoch(SWSEpochWiNoise);
            mean_durations(g, i).SWSEpochWiNoise = mean(durSWSWiNoise / 1e4) / 60;

            % REMEpoch
            [durREM, ~] = DurationEpoch(REMEpoch);
            mean_durations(g, i).REMEpoch = mean(durREM / 1e4) / 60;

            % REMEpochWiNoise
            [durREMWiNoise, ~] = DurationEpoch(REMEpochWiNoise);
            mean_durations(g, i).REMEpochWiNoise = mean(durREMWiNoise / 1e4) / 60;

            % Préparer les données pour le graphique
            states = {'Wake', 'WakeWiNoise', 'SWSEpoch', 'SWSEpochWiNoise', 'REMEpoch', 'REMEpochWiNoise'};
            durations = [mean_durations(g, i).Wake, mean_durations(g, i).WakeWiNoise, ...
                         mean_durations(g, i).SWSEpoch, mean_durations(g, i).SWSEpochWiNoise, ...
                         mean_durations(g, i).REMEpoch, mean_durations(g, i).REMEpochWiNoise];

            % Création du graphique pour chaque enregistrement
            figure('Name', ['Durées moyennes - ', group_name, ' - Fichier ', num2str(i)], 'Color', [1 1 1]);
            bar(durations, 'FaceColor', [0.2 0.6 0.8]); % Graphique en barres
            set(gca, 'XTickLabel', states, 'XTick', 1:numel(states), 'FontSize', 10);
            xlabel('États', 'FontSize', 12);
            ylabel('Durée moyenne (minutes)', 'FontSize', 12);
            title(['Durée moyenne des épisodes - ', group_name, ' - ', accelero_path], 'Interpreter', 'none', 'FontSize', 14);
            grid on;
        end
    end

    %% Résumé des résultats
    disp('Durées moyennes des épisodes (en minutes) :');
    for g = 1:2
        for i = 1:length(enregistrements{g})
            disp(['Groupe : ', mean_durations(g, i).group]);
            disp(['Fichier : ', mean_durations(g, i).file]);
            disp(mean_durations(g, i));
        end
    end

end
