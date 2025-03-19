function compareGammaPowerByFrequency(enregistrements_controles, enregistrements_mutants)
    % Définir les plages de fréquences pour les mesures par intervalles de 5 Hz
    %frequences = 50:5:200;
    frequences = 50:5:100;

    num_frequences = length(frequences);
    a=2
    
% % Run function    
    %% Définition des chemins d'enregistrements
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

% % compareGammaPowerByFrequency(enregistrements_controles, enregistrements_mutants);
    

    % ********** PARTIE POUR LES MUTANTS **********
    gamma_powers_mutants = NaN(length(enregistrements_mutants), num_frequences);

    for i = 1:length(enregistrements_mutants)
        accelero_path = fullfile(enregistrements_mutants{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        %data_path = fullfile(enregistrements_mutants{i}, 'SpectrumDataH', 'SpectrumSomCxDeepH.mat');
       data_path = fullfile(enregistrements_mutants{i}, 'Somato_Middle_Spectrum.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            Wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);
            %Wake_spectrum = 10 * log10 (mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1));
            %Wake_spectrum = (f.^a).*(mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1));
            for j = 1:num_frequences
                % Bin de 5Hz
                freq_idx = f >= frequences(j) & f < (frequences(j) + 5);
                gamma_powers_mutants(i, j) = mean(Wake_spectrum(freq_idx));
            end
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** PARTIE POUR LES CONTROLES **********
    gamma_powers_controles = NaN(length(enregistrements_controles), num_frequences);

    for i = 1:length(enregistrements_controles)
        accelero_path = fullfile(enregistrements_controles{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        %data_path = fullfile(enregistrements_controles{i}, 'SpectrumDataH', 'SpectrumSomCxDeepH.mat');
        data_path = fullfile(enregistrements_controles{i}, 'Somato_Middle_Spectrum.mat');

        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            Wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);
            %Wake_spectrum = 10 * log10 (mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1));
            %Wake_spectrum = (f.^a).*(mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1));

            for j = 1:num_frequences
                % Bin de 5Hz
                freq_idx = f >= frequences(j) & f < (frequences(j) + 5);
                gamma_powers_controles(i, j) = mean(Wake_spectrum(freq_idx));
            end

        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % ********** COMPARAISON ET GRAPHIQUES EN BARRES **********
    figure;
    hold on;
    x_positions = 1:num_frequences;

    mean_gamma_powers_controles = mean(gamma_powers_controles, 1);
    std_gamma_powers_controles = std(gamma_powers_controles, 0, 1) / sqrt(size(gamma_powers_controles, 1));

    mean_gamma_powers_mutants = mean(gamma_powers_mutants, 1);
    std_gamma_powers_mutants = std(gamma_powers_mutants, 0, 1) / sqrt(size(gamma_powers_mutants, 1));

    % Afficher les barres pour les contrôles
    bar(x_positions - 0.15, mean_gamma_powers_controles, 0.3, 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Contrôles');
    errorbar(x_positions - 0.15, mean_gamma_powers_controles, std_gamma_powers_controles, 'k', 'LineStyle', 'none');

    % Afficher les barres pour les mutants
    bar(x_positions + 0.15, mean_gamma_powers_mutants, 0.3, 'FaceColor', 'r', 'DisplayName', 'Mutants');
    errorbar(x_positions + 0.15, mean_gamma_powers_mutants, std_gamma_powers_mutants, 'k', 'LineStyle', 'none');

    % Scatter plot pour les données individuelles
    scatter(repelem(x_positions - 0.15, size(gamma_powers_controles, 1)), gamma_powers_controles(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceAlpha', 0.2, 'jitter', 'on', 'jitterAmount', 0.05);
    scatter(repelem(x_positions + 0.15, size(gamma_powers_mutants, 1)), gamma_powers_mutants(:), 50, ...
            'MarkerFaceColor', 'k', 'MarkerEdgeColor', [1, 0, 0], 'MarkerFaceAlpha', 0.2, 'jitter', 'on', 'jitterAmount', 0.05);


    % ********** TEST DE NORMALITÉ ET COMPARAISON **********

% Initialisation des structures
normality_results_controles = cell(1, num_frequences); % Résultats pour chaque fréquence
normality_results_mutants = cell(1, num_frequences);

% Effectuer les tests
for freq_idx = 1:num_frequences
    % Données pour cette fréquence
    data_control = gamma_powers_controles(:, freq_idx);
    data_mutant = gamma_powers_mutants(:, freq_idx);
    
    % Test de normalité (Shapiro-Wilk)
    [h_control, p_control] = swtest(data_control); % Test Shapiro-Wilk
    [h_mutant, p_mutant] = swtest(data_mutant);   % Test Shapiro-Wilk

    [h, p] = swtest(data_control, 0.05);
    if h == 0
        disp('Les données des contrôles sont normalement distribuées (p ≥ 0.05)');
    else
        disp('Les données des contrôles ne sont pas normalement distribuées (p < 0.05)');
    end

    [h, p] = swtest(data_mutant, 0.05);
    if h == 0
        disp('Les données des mutants sont normalement distribuées (p ≥ 0.05)');
    else
        disp('Les données des mutants ne sont pas normalement distribuées (p < 0.05)');
    end
    
    % Enregistrer les résultats
    normality_results_controles{freq_idx} = struct('is_normal', h_control == 0, 'p_value', p_control);
    normality_results_mutants{freq_idx} = struct('is_normal', h_mutant == 0, 'p_value', p_mutant);
 
    
    % Affichage des résultats
    if h_control == 0
        disp(['Contrôle (fréquence ', num2str(frequences(freq_idx)), ' Hz) : distribution normale (p = ', num2str(p_control, '%.4f'), ')']);
    else
        disp(['Contrôle (fréquence ', num2str(frequences(freq_idx)), ' Hz) : distribution non normale (p = ', num2str(p_control, '%.4f'), ')']);
    end
    
    if h_mutant == 0
        disp(['Mutant (fréquence ', num2str(frequences(freq_idx)), ' Hz) : distribution normale (p = ', num2str(p_mutant, '%.4f'), ')']);
    else
        disp(['Mutant (fréquence ', num2str(frequences(freq_idx)), ' Hz) : distribution non normale (p = ', num2str(p_mutant, '%.4f'), ')']);
    end
end

%%%%%%%%%

    % Calculer les p-values et ajouter des annotations
    p_values = zeros(1, num_frequences);

    for freq_idx = 1:num_frequences
        %[~, p_values(freq_idx)] = ttest2(gamma_powers_controles(:, freq_idx), gamma_powers_mutants(:, freq_idx)); % Student ttest
        p_values(freq_idx) = ranksum(gamma_powers_controles(:, freq_idx), gamma_powers_mutants(:, freq_idx)); % Mann-Whitney
        %%exact_mann_whitney
        %p_values(freq_idx) = exact_mann_whitney(gamma_powers_controles(:, freq_idx), gamma_powers_mutants(:, freq_idx));
     

        y_max = max([mean_gamma_powers_controles(freq_idx) + std_gamma_powers_controles(freq_idx), ...
                     mean_gamma_powers_mutants(freq_idx) + std_gamma_powers_mutants(freq_idx)]);
        if p_values(freq_idx) < 0.001
            text(x_positions(freq_idx), y_max + 0.7 * y_max, '***', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'r');
        elseif p_values(freq_idx) < 0.01
            text(x_positions(freq_idx), y_max + 0.7 * y_max, '**', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'r');
        elseif p_values(freq_idx) < 0.05
            text(x_positions(freq_idx), y_max + 0.7 * y_max, '*', 'HorizontalAlignment', 'center', 'FontSize', 30, 'Color', 'r');
        end
    end

    % Configurer l'axe et le titre
    set(gca, 'XTick', x_positions, 'XTickLabel', arrayfun(@num2str, frequences, 'UniformOutput', false));
    ylabel('Puissance moyenne dans Wake');
    xlabel('Fréquence (Hz)');
    title('Comparaison de la puissance gamma entre contrôles et mutants');
    legend show;
    hold off;
end


%%%%%%%% Comparaison with Somato_Middle_Spectrum.mat %%%%%%%%%%%%%%%%%


% Chemins pour les données
P{1} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224';
P{2} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745';
P{3} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948';
P{4} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343';
P{5} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858';
P{6} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852';
P{7} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657';
P{8} = '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852';

% Définition des bandes de fréquences
frequences = 50:5:100; % Plage de 50 à 100 Hz, par pas de 5 Hz
num_bands = length(frequences) - 1; % Nombre de bandes (ex. 50-55, 55-60, ...)

% Initialisation
gamma_powers_controles = NaN(4, num_bands); % 4 contrôles, bandes de fréquence
gamma_powers_mutants = NaN(4, num_bands);  % 4 mutants, bandes de fréquence

% Calcul des puissances pour chaque souris
for i = 1:8
    load([P{i} filesep 'Somato_Middle_Spectrum.mat']); % Charger le spectre
    Range_Middle = Spectro{3}; % Fréquences
    Somato_Sptsd = tsd(Spectro{2} * 1e4, Spectro{1}); % Spectre avec timestamps

    % Restriction à l'état Wake
    load([P{i} filesep 'SleepScoring_Accelero.mat'], 'Wake');
    Somato_Wake = Restrict(Somato_Sptsd, Wake); % Restriction au Wake
    mean_spectrum = nanmean(Data(Somato_Wake), 1); % Puissances moyennes par fréquence

    % Moyennes par bande de fréquence
    for j = 1:num_bands
        freq_idx = (Range_Middle >= frequences(j) & Range_Middle < frequences(j + 1));
        mean_band_power = mean(mean_spectrum(freq_idx)); % Moyenne dans la bande
        if i <= 4 % Contrôles (indices 1 à 4)
            gamma_powers_controles(i, j) = mean_band_power;
        else % Mutants (indices 5 à 8)
            gamma_powers_mutants(i - 4, j) = mean_band_power;
        end
    end
end

% Calcul des moyennes et SEM
mean_controls = mean(gamma_powers_controles, 1, 'omitnan');
sem_controls = std(gamma_powers_controles, 0, 1, 'omitnan') / sqrt(4);
mean_mutants = mean(gamma_powers_mutants, 1, 'omitnan');
sem_mutants = std(gamma_powers_mutants, 0, 1, 'omitnan') / sqrt(4);

% Tests Mann-Whitney
p_values = NaN(1, num_bands);
for j = 1:num_bands
    p_values(j) = ranksum(gamma_powers_controles(:, j), gamma_powers_mutants(:, j));
end

% Graphique en barres
figure;
hold on;
x_positions = 1:num_bands;

% Barres pour les contrôles
bar(x_positions - 0.15, mean_controls, 0.3, 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Contrôles');
errorbar(x_positions - 0.15, mean_controls, sem_controls, 'k', 'LineStyle', 'none');

% Barres pour les mutants
bar(x_positions + 0.15, mean_mutants, 0.3, 'FaceColor', 'r', 'DisplayName', 'Mutants');
errorbar(x_positions + 0.15, mean_mutants, sem_mutants, 'k', 'LineStyle', 'none');

% Points individuels
scatter(repelem(x_positions - 0.15, 4), gamma_powers_controles(:), 50, 'k', 'filled');
scatter(repelem(x_positions + 0.15, 4), gamma_powers_mutants(:), 50, 'r', 'filled');

% Affichage des p-values
for j = 1:num_bands
    y_max = max([mean_controls(j) + sem_controls(j), mean_mutants(j) + sem_mutants(j)]);
    if p_values(j) < 0.001
        text(x_positions(j), y_max * 1.1, '***', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'r');
    elseif p_values(j) < 0.01
        text(x_positions(j), y_max * 1.1, '**', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'r');
    elseif p_values(j) < 0.05
        text(x_positions(j), y_max * 1.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'r');
    else
        text(x_positions(j), y_max * 1.1, 'ns', 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'k');
    end
end

% Configuration du graphique
xticks(x_positions);
xticklabels(arrayfun(@(x) [num2str(x) '-' num2str(x + 5)], frequences(1:end-1), 'UniformOutput', false));
xlabel('Bandes de fréquences (Hz)');
ylabel('Puissance moyenne (a.u.)');
title('Comparaison des puissances moyennes (Wake)');
legend('show');
box off;
hold off;



