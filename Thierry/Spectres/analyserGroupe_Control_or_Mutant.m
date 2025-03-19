function analyserGroupe(enregistrements, groupe_nom, couleur_moyenne)
    % Analyse un groupe d'enregistrements, charge les périodes et les spectres, puis trace les spectres moyens
    % Paramètres:
    % enregistrements (cell): Liste des chemins d'accès pour les enregistrements.
    % groupe_nom (str): Nom du groupe (par ex. 'Mutants' ou 'Contrôles').
    % couleur_moyenne (str): Couleur pour la ligne de moyenne du groupe ('g' pour vert, 'k' pour noir).
    
    % Extraire les identifiants uniques pour chaque enregistrement
    ids = cellfun(@(x) regexp(x, '(?<=BaselineSleep_)[^/]+', 'match', 'once'), enregistrements, 'UniformOutput', false);
    StsdSomCxdeepHM = cell(1, length(enregistrements));
    periods = struct();  
    f_all_subjects = []; 

    % Charger et générer les tsd et les périodes pour chaque enregistrement
    for i = 1:length(enregistrements)
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  
            periods(i).Wake = Wake;
            periods(i).REMEpoch = REMEpoch;
            periods(i).SWSEpoch = SWSEpoch;
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{i}]);
        end
        
        data_path = fullfile(enregistrements{i}, 'SpectrumDataH', 'SpectrumSomCxdeepH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');  
            StsdSomCxdeepHM{i} = tsd(t * 1E4, Sp);  
            f_all_subjects = f;  
        else
            error(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % Paramètre de normalisation
    a = 2;
    colors = lines(length(enregistrements));

    % Création des figures pour les différents types de tracés de spectres pour chaque groupe
    figure;
    % --- Wake (éveil) ---
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake; 
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); 
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    std_spectra_wake = std(individual_spectra, 0, 1); 

    % Ajouter l'ombre de l'écart-type autour de la moyenne
    fill([f_all_subjects, fliplr(f_all_subjects)], ...
         [mean_spectra_wake + std_spectra_wake, fliplr(mean_spectra_wake - std_spectra_wake)], ...
         couleur_moyenne, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    plot(f_all_subjects, mean_spectra_wake, couleur_moyenne, 'LineWidth', 2, 'DisplayName', ['Moyenne ' groupe_nom ' Wake']);
    title([groupe_nom ' Wake - mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % Normalisation f^a pour Wake
    subplot(1, 4, 2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); 
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    std_spectra_wake = std(individual_spectra, 0, 1);

    fill([f_all_subjects, fliplr(f_all_subjects)], ...
         [mean_spectra_wake + std_spectra_wake, fliplr(mean_spectra_wake - std_spectra_wake)], ...
         couleur_moyenne, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    plot(f_all_subjects, mean_spectra_wake, couleur_moyenne, 'LineWidth', 2, 'DisplayName', ['Moyenne ' groupe_nom ' Wake']);
    title([groupe_nom ' Wake - f^a \times mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance normalisée');
    legend show;

    % Log10 du spectre pour Wake
    subplot(1, 4, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); 
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    std_spectra_wake = std(individual_spectra, 0, 1);

    fill([f_all_subjects, fliplr(f_all_subjects)], ...
         [mean_spectra_wake + std_spectra_wake, fliplr(mean_spectra_wake - std_spectra_wake)], ...
         couleur_moyenne, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    plot(f_all_subjects, mean_spectra_wake, couleur_moyenne, 'LineWidth', 2, 'DisplayName', ['Moyenne ' groupe_nom ' Wake']);
    title([groupe_nom ' Wake - log10(mean)']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance (dB)');
    legend show;

    % Log-log pour Wake
    subplot(1, 4, 4), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(10 * log10(f_all_subjects), spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); 
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    std_spectra_wake = std(individual_spectra, 0, 1);

    fill([10 * log10(f_all_subjects), fliplr(10 * log10(f_all_subjects))], ...
         [mean_spectra_wake + std_spectra_wake, fliplr(mean_spectra_wake - std_spectra_wake)], ...
         couleur_moyenne, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    plot(10 * log10(f_all_subjects), mean_spectra_wake, couleur_moyenne, 'LineWidth', 2, 'DisplayName', ['Moyenne ' groupe_nom ' Wake']);
    title([groupe_nom ' Wake - log-log']);
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;

    % Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', [groupe_nom ' SomCxdeepH Wake'], ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
end