function compareBandPowerByFrequencyBetaGamma(enregistrements_controles, enregistrements_mutants)
    % Définir les bandes de fréquences
    bandes_frequences = struct('Theta', [4, 8], ...
                               'Sigma', [12, 16]);
    noms_bandes = fieldnames(bandes_frequences);
    num_band = length(noms_bandes);

    % ********** PARTIE POUR LES MUTANTS **********
    puissances_mutants = NaN(length(enregistrements_mutants), num_band);

    for i = 1:length(enregistrements_mutants)
        accelero_path = fullfile(enregistrements_mutants{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        data_path = fullfile(enregistrements_mutants{i}, 'SpectrumDataL', 'SpectrumSomCxdeepL.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);

            % Calculer la puissance moyenne pour chaque bande de fréquence
            for j = 1:num_band
                band_range = bandes_frequences.(noms_bandes{j});
                freq_idx = (f >= band_range(1)) & (f <= band_range(2));
                
                if any(freq_idx)  % Vérifie si la plage de fréquence existe
                    puissances_mutants(i, j) = mean(wake_spectrum(freq_idx));
                else
                    warning(['Plage de fréquence non trouvée pour la bande : ', noms_bandes{j}]);
                end
            end
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** PARTIE POUR LES CONTROLES **********
    puissances_controles = NaN(length(enregistrements_controles), num_band);

    for i = 1:length(enregistrements_controles)
        accelero_path = fullfile(enregistrements_controles{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        data_path = fullfile(enregistrements_controles{i}, 'SpectrumDataL', 'SpectrumSomCxdeepL.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);

            % Calculer la puissance moyenne pour chaque bande de fréquence
            for j = 1:num_band
                band_range = bandes_frequences.(noms_bandes{j});
                freq_idx = (f >= band_range(1)) & (f <= band_range(2));
                
                if any(freq_idx)  % Vérifie si la plage de fréquence existe
                    puissances_controles(i, j) = mean(wake_spectrum(freq_idx));
                else
                    warning(['Plage de fréquence non trouvée pour la bande : ', noms_bandes{j}]);
                end
            end
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** COMPARAISON ET GRAPHIQUES EN BARRES **********
    figure;
    hold on;
    x_positions = 1:num_band;

    mean_puissances_controles = mean(puissances_controles, 1);
    std_puissances_controles = std(puissances_controles, 0, 1) / sqrt(size(puissances_controles, 1));

    mean_puissances_mutants = mean(puissances_mutants, 1);
    std_puissances_mutants = std(puissances_mutants, 0, 1) / sqrt(size(puissances_mutants, 1));

    % Afficher les barres pour les contrôles
    bar(x_positions - 0.15, mean_puissances_controles, 0.3, 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Contrôles');
    errorbar(x_positions - 0.15, mean_puissances_controles, std_puissances_controles, 'k', 'LineStyle', 'none');

    % Afficher les barres pour les mutants
    bar(x_positions + 0.15, mean_puissances_mutants, 0.3, 'FaceColor', 'r', 'DisplayName', 'Mutants');
    errorbar(x_positions + 0.15, mean_puissances_mutants, std_puissances_mutants, 'k', 'LineStyle', 'none');

    % Scatter plot pour les données individuelles
    scatter(repelem(x_positions - 0.15, size(puissances_controles, 1)), puissances_controles(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceAlpha', 0.2, 'jitter', 'on', 'jitterAmount', 0.05);
    scatter(repelem(x_positions + 0.15, size(puissances_mutants, 1)), puissances_mutants(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceAlpha', 0.2, 'jitter', 'on', 'jitterAmount', 0.05);

    % Calculer les p-values et ajouter des annotations
    p_values = zeros(1, num_band);

    for band_idx = 1:num_band
        [~, p_values(band_idx)] = ttest2(puissances_controles(:, band_idx), puissances_mutants(:, band_idx));

        y_max = max([mean_puissances_controles(band_idx) + std_puissances_controles(band_idx), ...
                     mean_puissances_mutants(band_idx) + std_puissances_mutants(band_idx)]);
        if p_values(band_idx) < 0.001
            text(x_positions(band_idx), y_max + 0.1 * y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'r');
        elseif p_values(band_idx) < 0.01
            text(x_positions(band_idx), y_max + 0.1 * y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'r');
        elseif p_values(band_idx) < 0.05
            text(x_positions(band_idx), y_max + 0.1 * y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'r');
        end
    end

    % Configurer l'axe et le titre
    set(gca, 'XTick', x_positions, 'XTickLabel', noms_bandes);
    ylabel('Puissance moyenne dans Wake');
    xlabel('Bandes de fréquence');
    title('Comparaison de la puissance par bande entre contrôles et mutants');
    legend show;
    hold off;
end