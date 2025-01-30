function compareGroupedGammaPower(enregistrements_controles, enregistrements_mutants)
    % Définir l'intervalle spécifique
    freq_start = 80; % Fréquence de début
    freq_end = 90;   % Fréquence de fin
    
    % Initialisation
    num_intervals = 1; % Un seul intervalle dans ce cas
    gamma_powers_controles = NaN(length(enregistrements_controles), num_intervals);
    gamma_powers_mutants = NaN(length(enregistrements_mutants), num_intervals);

    % ********** Extraction des puissances gamma : Mutants **********
    for i = 1:length(enregistrements_mutants)
        accelero_path = fullfile(enregistrements_mutants{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        data_path = fullfile(enregistrements_mutants{i}, 'SpectrumDataH', 'SpectrumSomCxDeepH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            Wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);

            % Calcul de la puissance gamma pour l'intervalle 80-90 Hz
            freq_idx = (f >= freq_start & f < freq_end); % Indices correspondant à 80-90 Hz
            gamma_powers_mutants(i, 1) = mean(Wake_spectrum(freq_idx));
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** Extraction des puissances gamma : Contrôles **********
    for i = 1:length(enregistrements_controles)
        accelero_path = fullfile(enregistrements_controles{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        data_path = fullfile(enregistrements_controles{i}, 'SpectrumDataH', 'SpectrumSomCxDeepH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            Wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);

            % Calcul de la puissance gamma pour l'intervalle 80-90 Hz
            freq_idx = (f >= freq_start & f < freq_end); % Indices correspondant à 80-90 Hz
            gamma_powers_controles(i, 1) = mean(Wake_spectrum(freq_idx));
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** Comparaison et représentation graphique **********
    % Moyennes et SEM
    mean_gamma_powers_controles = mean(gamma_powers_controles, 'omitnan');
    sem_gamma_powers_controles = std(gamma_powers_controles, 'omitnan') / sqrt(sum(~isnan(gamma_powers_controles)));

    mean_gamma_powers_mutants = mean(gamma_powers_mutants, 'omitnan');
    sem_gamma_powers_mutants = std(gamma_powers_mutants, 'omitnan') / sqrt(sum(~isnan(gamma_powers_mutants)));

    % Graphique
    figure;
    hold on;

    % Barres pour les contrôles
    bar(1 - 0.15, mean_gamma_powers_controles, 0.3, 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Contrôles');
    errorbar(1 - 0.15, mean_gamma_powers_controles, sem_gamma_powers_controles, 'k', 'LineStyle', 'none');

    % Barres pour les mutants
    bar(1 + 0.15, mean_gamma_powers_mutants, 0.3, 'FaceColor', 'r', 'DisplayName', 'Mutants');
    errorbar(1 + 0.15, mean_gamma_powers_mutants, sem_gamma_powers_mutants, 'k', 'LineStyle', 'none');

    % Points individuels
    scatter(repelem(1 - 0.15, size(gamma_powers_controles, 1)), gamma_powers_controles(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [0, 0, 1], 'MarkerFaceAlpha', 0.5, 'jitter', 'on', 'jitterAmount', 0.05);
    scatter(repelem(1 + 0.15, size(gamma_powers_mutants, 1)), gamma_powers_mutants(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceAlpha', 0.5, 'jitter', 'on', 'jitterAmount', 0.05);

    % Test statistique (Mann-Whitney)
    p_value = ranksum(gamma_powers_controles, gamma_powers_mutants);

    % Affichage de la p-value
    y_max = max([mean_gamma_powers_controles + sem_gamma_powers_controles, ...
                 mean_gamma_powers_mutants + sem_gamma_powers_mutants]);
    annotation_text = sprintf('p = %.3f', p_value);
    text(1, y_max * 1.2, annotation_text, 'HorizontalAlignment', 'center', 'FontSize', 15, 'Color', 'k');

    % Personnalisation du graphique
    ylabel('Puissance moyenne dans Wake');
    xticks([1]);
    xticklabels({'80-90 Hz'});
    title('Comparaison de la puissance gamma (80-90 Hz)');
    legend('show');
    box off;
    hold off;
end