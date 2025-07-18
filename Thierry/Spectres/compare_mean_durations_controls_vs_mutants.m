function compare_mean_durations_controls_vs_mutants()

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

    % États à analyser
    states = {'Wake', 'WakeWiNoise', 'SWSEpoch', 'SWSEpochWiNoise', 'REMEpoch', 'REMEpochWiNoise'};

    % Initialisation des résultats
    mean_durations = cell(1, 2); % Une cellule par groupe (contrôles et mutants)

    %% Calcul des moyennes pour chaque groupe
    for g = 1:2
        group_name = groups{g};
        n_souris = length(enregistrements{g});
        mean_durations{g} = zeros(n_souris, length(states)); % Initialiser les durées moyennes par état

        for i = 1:n_souris
            accelero_path = fullfile(enregistrements{g}{i}, 'SleepScoring_Accelero.mat');

            % Charger les données depuis le fichier
            if exist(accelero_path, 'file')
                load(accelero_path, 'Wake', 'WakeWiNoise', 'SWSEpoch', 'SWSEpochWiNoise', 'REMEpoch', 'REMEpochWiNoise');
            else
                error(['Fichier introuvable : ', accelero_path]);
            end

            % Calculer la durée moyenne pour chaque état
            mean_durations{g}(i, 1) = mean(DurationEpoch(Wake) / 1e4) / 60;           % Wake
            mean_durations{g}(i, 2) = mean(DurationEpoch(WakeWiNoise) / 1e4) / 60;    % WakeWiNoise
            mean_durations{g}(i, 3) = mean(DurationEpoch(SWSEpoch) / 1e4) / 60;       % SWSEpoch
            mean_durations{g}(i, 4) = mean(DurationEpoch(SWSEpochWiNoise) / 1e4) / 60;% SWSEpochWiNoise
            mean_durations{g}(i, 5) = mean(DurationEpoch(REMEpoch) / 1e4) / 60;       % REMEpoch
            mean_durations{g}(i, 6) = mean(DurationEpoch(REMEpochWiNoise) / 1e4) / 60;% REMEpochWiNoise
        end
    end

    %% Génération des graphiques
    % Calcul des moyennes et écarts-types pour chaque état
    mean_controls = mean(mean_durations{1});
    mean_mutants = mean(mean_durations{2});
    std_controls = std(mean_durations{1});
    std_mutants = std(mean_durations{2});

    % Graphique
    figure('Name', 'Comparaison des moyennes des durées par état', 'Color', [1 1 1]);
    hold on;

    % Position des barres
    x = 1:length(states);

    % Barres pour les groupes
    bar(x - 0.15, mean_controls, 0.3, 'FaceColor', [0.2 0.6 0.8], 'DisplayName', 'Contrôles'); % Barres contrôles
    bar(x + 0.15, mean_mutants, 0.3, 'FaceColor', [0.8 0.4 0.4], 'DisplayName', 'Mutants');    % Barres mutants

    % Ajout des points individuels
    jitter_amount = 0.05; % Écart pour la dispersion des points
    for s = 1:length(states)
        % Points pour les contrôles
        scatter(repmat(s - 0.15, size(mean_durations{1}, 1), 1) + rand(size(mean_durations{1}, 1), 1) * jitter_amount, ...
                mean_durations{1}(:, s), 50, [0 0 1], 'filled', 'jitter', 'on');

        % Points pour les mutants
        scatter(repmat(s + 0.15, size(mean_durations{2}, 1), 1) + rand(size(mean_durations{2}, 1), 1) * jitter_amount, ...
                mean_durations{2}(:, s), 50, [1 0 0], 'filled', 'jitter', 'on');
    end

    % Ajout des barres d'erreur
    errorbar(x - 0.15, mean_controls, std_controls, 'k.', 'LineWidth', 1.5); % Contrôles
    errorbar(x + 0.15, mean_mutants, std_mutants, 'k.', 'LineWidth', 1.5);   % Mutants

    % Comparaisons statistiques (Mann-Whitney)
    for s = 1:length(states)
        p_val = ranksum(mean_durations{1}(:, s), mean_durations{2}(:, s));
        y_max = max([mean_controls(s) + std_controls(s), mean_mutants(s) + std_mutants(s)]) * 1.1;

        % Affichage des étoiles de significativité
        if p_val < 0.001
            text(s, y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
        elseif p_val < 0.01
            text(s, y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
        elseif p_val < 0.05
            text(s, y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
        end
    end

    % Personnalisation des axes
    set(gca, 'XTick', x, 'XTickLabel', states, 'FontSize', 10);
    xlabel('États', 'FontSize', 12);
    ylabel('Durée moyenne (minutes)', 'FontSize', 12);
    title('Comparaison des durées moyennes des épisodes', 'FontSize', 14);
    legend('Location', 'Best');
    grid on;
    hold off;

end
