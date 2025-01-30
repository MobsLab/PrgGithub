% Définir la plage de fréquences pour le gamma
gamma_range = [85, 95];  % Gamme de fréquences en Hz

% ********** PARTIE POUR LES MUTANTS **********
enregistrements_mutants = { ...
    '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ...
    '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ...
    '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ...
    '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9', ...
};

gamma_peaks_mutants = [];  % Initialiser les puissances gamma pour les mutants

% Charger et analyser chaque mutant
for i = 1:length(enregistrements_mutants)
    % Charger les périodes et spectres
    accelero_path = fullfile(enregistrements_mutants{i}, 'SleepScoring_Accelero.mat');
    if exist(accelero_path, 'file')
        load(accelero_path, 'Wake');  % Charger les périodes de veille uniquement
    else
        warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
        continue;
    end
    
    data_path = fullfile(enregistrements_mutants{i}, 'SpectrumDataH', 'SpectrumSomCxdeepH.mat');
    if exist(data_path, 'file')
        load(data_path, 'Sp', 'f', 't');  % Charger les spectres, fréquences et temps

        % Vérification des dimensions de t et Sp
        if length(t) ~= size(Sp, 1)
            warning(['Dimensions incompatibles dans le spectre pour : ', data_path]);
            continue;
        end

        % Restreindre le spectre aux périodes de Wake et aux fréquences gamma
        wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);  % Spectre moyen pour Wake
        gamma_indices = f >= gamma_range(1) & f <= gamma_range(2);
        spectra_gamma = wake_spectrum(gamma_indices);  % Spectre gamma pour Wake
        
        % Obtenir la puissance gamma maximale dans Wake
        gamma_peak = max(spectra_gamma);
        gamma_peaks_mutants(end + 1) = gamma_peak;
    else
        warning(['Fichier de spectre introuvable : ', data_path]);
    end
end

% ********** PARTIE POUR LES CONTROLES **********
enregistrements_controles = { ...
    '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ...
    '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ...
    '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ...
    '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343', ...
};

gamma_peaks_controles = [];  % Initialiser les puissances gamma pour les contrôles

% Charger et analyser chaque contrôle
for i = 1:length(enregistrements_controles)
    accelero_path = fullfile(enregistrements_controles{i}, 'SleepScoring_Accelero.mat');
    if exist(accelero_path, 'file')
        load(accelero_path, 'Wake');  % Charger les périodes de veille
    else
        warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
        continue;
    end
    
    data_path = fullfile(enregistrements_controles{i}, 'SpectrumDataH', 'SpectrumSomCxdeepH.mat');
    if exist(data_path, 'file')
        load(data_path, 'Sp', 'f', 't');  % Charger les spectres et les fréquences
        
        % Vérification des dimensions de t et Sp
        if length(t) ~= size(Sp, 1)
            warning(['Dimensions incompatibles dans le spectre pour : ', data_path]);
            continue;
        end
        
        % Restreindre le spectre aux périodes de Wake et aux fréquences gamma
        wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);
        gamma_indices = f >= gamma_range(1) & f <= gamma_range(2);
        spectra_gamma = wake_spectrum(gamma_indices);  % Spectre gamma pour Wake
        
        % Obtenir la puissance gamma maximale dans Wake
        gamma_peak = max(spectra_gamma);
        gamma_peaks_controles(end + 1) = gamma_peak;
    else
        warning(['Fichier de spectre introuvable : ', data_path]);
    end
end

% ********** COMPARAISON ET GRAPHIQUE EN BARRES **********
figure;
hold on;
bar(1, mean(gamma_peaks_controles), 'FaceColor', [0.5, 0.5, 0.5], 'DisplayName', 'Contrôles');
errorbar(1, mean(gamma_peaks_controles), std(gamma_peaks_controles) / sqrt(length(gamma_peaks_controles)), 'k');
scatter(ones(size(gamma_peaks_controles)) * 1, gamma_peaks_controles, 50, 'k', 'filled', 'jitter', 'on', 'jitterAmount', 0.1);

bar(2, mean(gamma_peaks_mutants), 'FaceColor', 'g', 'DisplayName', 'Mutants');
errorbar(2, mean(gamma_peaks_mutants), std(gamma_peaks_mutants) / sqrt(length(gamma_peaks_mutants)), 'k');
scatter(ones(size(gamma_peaks_mutants)) * 2, gamma_peaks_mutants, 50, 'k', 'filled', 'jitter', 'on', 'jitterAmount', 0.1);

set(gca, 'XTick', [1, 2], 'XTickLabel', {'Contrôles', 'Mutants'});
ylabel('Puissance gamma maximale dans Wake');
title('Comparaison de la puissance gamma maximale entre contrôles et mutants');
legend show;

% ********** TEST STATISTIQUE **********
[~, p_value] = ttest2(gamma_peaks_controles, gamma_peaks_mutants);
disp(['p-value pour la comparaison de la puissance gamma maximale dans Wake : ', num2str(p_value)]);
