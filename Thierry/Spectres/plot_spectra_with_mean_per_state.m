function plot_spectrum_SomCxsupH_Stages()

    % Liste des dossiers d'enregistrements
    enregistrements = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2', ...
        '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3' ...
    };

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

    % Comparaison des spectres pour Wake, SWS et REM avec moyennes

    % --- Wake ---
    figure;
    subplot(1, 3, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake;  % Stocker pour calcul de la moyenne
        plot(f_all_subjects, spectra_wake, 'DisplayName', ['M', num2str(i)]);  % Tracer sans transparence
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');  % Courbe moyenne en noir
    title('Spectres individuels et moyenne - Wake');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % --- SWS ---
    subplot(1, 3, 2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_sws = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).SWSEpoch)));
        individual_spectra(i, :) = spectra_sws;
        plot(f_all_subjects, spectra_sws, 'DisplayName', ['M', num2str(i)]);  % Tracer sans transparence
    end
    mean_spectra_sws = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_sws, 'b', 'LineWidth', 2, 'DisplayName', 'Moyenne SWS');  % Courbe moyenne en bleu
    title('Spectres individuels et moyenne - SWS');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % --- REM ---
    subplot(1, 3, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_rem = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).REMEpoch)));
        individual_spectra(i, :) = spectra_rem;
        plot(f_all_subjects, spectra_rem, 'DisplayName', ['M', num2str(i)]);  % Tracer sans transparence
    end
    mean_spectra_rem = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_rem, 'r', 'LineWidth', 2, 'DisplayName', 'Moyenne REM');  % Courbe moyenne en rouge
    title('Spectres individuels et moyenne - REM');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

end
