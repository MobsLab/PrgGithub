function plot_spectrum_SomCxsupH_Stages()

    % Liste des dossiers d'enregistrements mutants
    enregistrements = { ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %OK
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ... %OK 
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7',... %OK
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9',... %OK
    };

%         '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M7', ...  !!! high_noise_Somsup !!!
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M9', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M8', ...
%         '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M9/', ...
%         '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M1', ...
%         '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1/',... % big effect

    % Liste des dossiers d'enregistrements controles
    enregistrements = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... % SOMsup not goood - noPFC 
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ... %OK
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... % PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343', ... %OK
    };
%     '/media/mobs/DataMOBS203/Trami_TG3_TG7_BaselineSleep_240627_092728/M3', ...
%     '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M5', ...
%     '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M2', ... %SOMsup not goood - noPFC - !!!high_noise_Somsup!!!
%     '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M4/', ... %PFCsup not good - HPCrip not good - !!!high_noise_Somsup!!!
%     '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M4',... %PFCsup not good - HPCrip not good - !!!high_noise_Somsup!!!


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
        data_path = fullfile(enregistrements{i}, 'SpectrumDataH', 'SpectrumSomCxdeepH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');  % Charger les variables de spectre
            StsdSomCxsupHM{i} = tsd(t * 1E4, Sp);  % Générer le tsd
            f_all_subjects = f;  % Supposons que f est identique pour tous les sujets
        else
            error(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % Paramètre de normalisation
    a = 1.5;
colors = lines(length(enregistrements));

    % Comparaison des spectres pour Wake, SWS et REM avec moyennes et différents types de tracés

    % --- Wake ---
    figure;
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_wake = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).Wake)));
        individual_spectra(i, :) = spectra_wake;  % Stocker pour calcul de la moyenne
%         plot(f_all_subjects, spectra_wake, 'LineWidth', 1, 'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);  % Tracer en gris
%         Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_wake(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 1, 'DisplayName', 'Moyenne Wake');  % Courbe moyenne en noir
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
%         plot(f_all_subjects, spectra_wake, 'LineWidth', 1, 'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_wake(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 1, 'DisplayName', 'Moyenne Wake');
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
%         plot(f_all_subjects, spectra_wake, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_wake(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 1, 'DisplayName', 'Moyenne Wake');
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
%         plot(10 * log10(f_all_subjects), spectra_wake,'LineWidth', 1, 'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         Ajouter le label pour chaque sujet
%         text(10 * log10(f_all_subjects(end)), spectra_wake(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_wake = mean(individual_spectra, 1);
    plot(10 * log10(f_all_subjects), mean_spectra_wake, 'k', 'LineWidth', 1, 'DisplayName', 'Moyenne Wake');
    title('Wake - log-log');
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;
    
% Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxdeepH Wake', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');



    % --- SWS ---
    figure;
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_sws = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).SWSEpoch)));
        individual_spectra(i, :) = spectra_sws;
%         plot(f_all_subjects, spectra_sws, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);  % Tracer en gris
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_sws(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_sws = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_sws, 'b', 'LineWidth', 1, 'DisplayName', 'Moyenne SWS');  % Courbe moyenne en bleu
    title('SWS - mean');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % Normalisation f^a pour SWS
    subplot(1, 4, 2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_sws = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).SWSEpoch)));
        individual_spectra(i, :) = spectra_sws;
%         plot(f_all_subjects, spectra_sws, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_sws(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_sws = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_sws, 'b', 'LineWidth', 1, 'DisplayName', 'Moyenne SWS');
    title(['SWS - f^a \times mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance normalisée');
    legend show;

    % Log10 du spectre pour SWS
    subplot(1, 4, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_sws = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).SWSEpoch))));
        individual_spectra(i, :) = spectra_sws;
%         plot(f_all_subjects, spectra_sws, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_sws(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_sws = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_sws, 'b', 'LineWidth', 1, 'DisplayName', 'Moyenne SWS');
    title('SWS - log10(mean)');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance (dB)');
    legend show;

    % Log-log pour SWS
    subplot(1, 4, 4), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_sws = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).SWSEpoch))));
        individual_spectra(i, :) = spectra_sws;
%         plot(10 * log10(f_all_subjects), spectra_sws, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(10 * log10(f_all_subjects(end)), spectra_sws(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_sws = mean(individual_spectra, 1);
    plot(10 * log10(f_all_subjects), mean_spectra_sws, 'b', 'LineWidth', 1, 'DisplayName', 'Moyenne SWS');
    title('SWS - log-log');
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;

    % Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxdeepH SWS', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

    % --- REM ---
    figure;
    subplot(1, 4, 1), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_rem = mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).REMEpoch)));
        individual_spectra(i, :) = spectra_rem;
%         plot(f_all_subjects, spectra_rem, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);  % Tracer en gris
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_rem(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_rem = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_rem, 'r', 'LineWidth', 1, 'DisplayName', 'Moyenne REM');  % Courbe moyenne en rouge
    title('REM - mean');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance');
    legend show;

    % Normalisation f^a pour REM
    subplot(1, 4, 2), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_rem = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).REMEpoch)));
        individual_spectra(i, :) = spectra_rem;
%         plot(f_all_subjects, spectra_rem, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_rem(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_rem = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_rem, 'r', 'LineWidth', 1, 'DisplayName', 'Moyenne REM');
    title(['REM - f^a \times mean']);
    xlabel('Fréquence (Hz)');
    ylabel('Puissance normalisée');
    legend show;

    % Log10 du spectre pour REM
    subplot(1, 4, 3), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_rem = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).REMEpoch))));
        individual_spectra(i, :) = spectra_rem;
%         plot(f_all_subjects, spectra_rem, 'LineWidth', 1,'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(f_all_subjects(end), spectra_rem(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_rem = mean(individual_spectra, 1);
    plot(f_all_subjects, mean_spectra_rem, 'r', 'LineWidth', 1, 'DisplayName', 'Moyenne REM');
    title('REM - log10(mean)');
    xlabel('Fréquence (Hz)');
    ylabel('Puissance (dB)');
    legend show;

    % Log-log pour REM
    subplot(1, 4, 4), hold on;
    individual_spectra = [];
    for i = 1:length(enregistrements)
        spectra_rem = 10 * log10(mean(Data(Restrict(StsdSomCxsupHM{i}, periods(i).REMEpoch))));
        individual_spectra(i, :) = spectra_rem;
%         plot(10 * log10(f_all_subjects), spectra_rem,'LineWidth', 1, 'Color', [0.5 0.5 0.5], 'DisplayName', ['M', num2str(i)]);
%         % Ajouter le label pour chaque sujet
%         text(10 * log10(f_all_subjects(end)), spectra_rem(end), ['M', num2str(i)], 'HorizontalAlignment', 'left', 'FontSize', 10);
    end
    mean_spectra_rem = mean(individual_spectra, 1);
    plot(10 * log10(f_all_subjects), mean_spectra_rem, 'r', 'LineWidth', 1, 'DisplayName', 'Moyenne REM');
    title('REM - log-log');
    xlabel('log10(Fréquence)');
    ylabel('log10(Puissance)');
    legend show;
    
    % Ajouter un titre général avec annotation
    annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxdeepH REM', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');



end
