function plot_spectrum_Stages_individual_spectra()

    % Liste des dossiers d'enregistrements contrôles
    enregistrements = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... %%OK%% SOMsup not goood - noPFC
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ... %%OK%%
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3', ... 
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... %%OK%% PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ... %%OK%%      
};

%         '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M2',... % SOMsup not goood - noPFC - OBGamma
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ... % SOMsup not goood - noPFC
%         '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M3', ...% OBGamma
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/', ... % PFCsup not good - HPCrip not good
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4', ... % PFCsup not good - HPCrip not good
%         '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5', ...

    % Liste des enregistrements mutants
	enregistrements_mutants = { 
    '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %%OK%%
    '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ... %%OK%% 
    '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ... %%OK%% 
    '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9', ... %%OK%% 
};

%         '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7', ...  !!! high_noise_Somsup !!!
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1', ...
%         '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1/',... % big effect

      };

%          '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ...
%          '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4', ...

%     };






    % Extraire les identifiants uniques pour chaque enregistrement
    ids = cellfun(@(x) regexp(x, '(?<=BaselineSleep_)[^/]+', 'match', 'once'), enregistrements, 'UniformOutput', false);

    % Initialiser des variables pour stocker les tsd et les périodes pour chaque sujet
    StsdSomCxsupHM = cell(1, length(enregistrements));  % Stocker les tsd objects
    periods = struct();  % Stocker les périodes Wake, SWS, REM pour ch % Extraire les identifiants uniques pour chaque enregistrement
    ids = cellfun(@(x) regexp(x, '(?<=BaselineSleep_)[^/]+', 'match', 'once'), enregistrements, 'UniformOutput', false);

    % Initialiser des variables pour stocker les tsd et les périodes pour chaque sujet
    StsdSomCxsupHM = cell(1, length(enregistrements));  % Stocker les tsd objects
    periods = struct();  % Stocker les périodes Wake, SWS, REM pour chaque sujet
    f_all_subjects = [];  % Pour stocker les fréquences (fréquence doit être la même pour tous les sujets)

    % Charger et générer les tsd et les périodes pour chaque enregistrement
    for i = 1:length(enregistrements)
        % Charger le fichier SleepScoring_Accelero.mat pour chaque enregistrement
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  % Charger les périodes pour ce sujet
            periods(i).Wake = Wake;
            periods(i).REMEpoch = REMEpoch;
            periods(i).SWSEpoch = SWSEpoch;
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{i}]);
        end
        
        % Charger les données de spectres
        data_path = fullfile(enregistrements{i}, 'SpectrumDataH', 'SpectrumSomCxsupH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');  % Charger les variables de spectre
            StsdSomCxsupHM{i} = tsd(t * 1E4, Sp);  % Générer le tsd
            f_all_subjects = f;  % Supposons que f est identique pour tous les sujets
        else
            error(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % Paramètre de normalisation
    a = 2;
    colors = lines(length(enregistrements));

    % Comparaison des spectres pour Wake, SWS et REM avec moyennes et différents types de tracés

    % --- Wake ---
    figure;
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        %spectra_wake = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)))/mean(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;  % Stocker pour calcul de la moyenne
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');  % Courbe moyenne en noir
    title('Wake - mean');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % Normalisation f^a pour Wake
    subplot(1, 4,2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        %spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)))/mean( f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))))
        %spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)))/max( f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))))
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    %mean_spectra_wake = smoothdata(mean_spectra_wake, 1, 'movmean', 5); % Lissage sur 5 points
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title(['Wake - f^a \times mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance normalisée');
    legend show;

    % Log10 du spectre pour Wake
    subplot(1, 4, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title('Wake - log10(mean)');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance (dB)');
    legend show;

    % Log-log pour Wake
    subplot(1, 4, 4), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(10 * log10(f_all_subjects), spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(10 * log10(f_all_subjects), mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title('Wake - log-log');
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;
    
    % Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxsupH Wake', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Charger et générer les tsd et les périodes pour chaque enregistrement
    for i = 1:length(enregistrements)
        % Charger le fichier SleepScoring_Accelero.mat pour chaque enregistrement
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');  % Charger les périodes pour ce sujet
            periods(i).Wake = Wake;
            periods(i).REMEpoch = REMEpoch;
            periods(i).SWSEpoch = SWSEpoch;
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', enregistrements{i}]);
        end
        
        % Charger les données de spectres
        data_path = fullfile(enregistrements{i}, 'SpectrumDataH', 'SpectrumSomCxsupH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');  % Charger les variables de spectre
            StsdSomCxsupHM{i} = tsd(t * 1E4, Sp);  % Générer le tsd
            f_all_subjects = f;  % Supposons que f est identique pour tous les sujets
        else
            error(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % Paramètre de normalisation
    a = 2;
    colors = lines(length(enregistrements));

    % Comparaison des spectres pour Wake, SWS et REM avec moyennes et différents types de tracés

    % --- Wake ---
    figure;
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake;  % Stocker pour calcul de la moyenne
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');  % Courbe moyenne en noir
    title('Wake - mean');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % Normalisation f^a pour Wake
    subplot(1, 4, 2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title(['Wake - f^a \times mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance normalisée');
    legend show;

    % Log10 du spectre pour Wake
    subplot(1, 4, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title('Wake - log10(mean)');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance (dB)');
    legend show;

    % Log-log pour Wake
    subplot(1, 4, 4), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake))));
        individual_spectra(i, :) = spectra_wake;
        plot(10 * log10(f_all_subjects), spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); % Tracer chaque spectre individuel
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(10 * log10(f_all_subjects), mean_spectra_wake, 'k--', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
    title('Wake - log-log');
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;
    
    % Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxsupH Wake M3', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold');

    % --- Répéter pour SWS et REM ---
    % Vous pouvez maintenant reproduire les mêmes étapes pour les périodes SWS et REM.
end
