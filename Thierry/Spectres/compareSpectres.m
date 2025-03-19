% % Liste des enregistrements mutants
% enregistrements_mutants = { 
%     '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %%OK%%
%     '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ... %%OK%% 
%     '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7', ... %%OK%% 
%     '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9', ... %%OK%% 
% };
% 
% %Liste des enregistrements contrôles
% enregistrements_controles = { 
%     '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... %%OK%% SOMsup not goood - noPFC
%     '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ... %%OK%%
%     '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... %%OK%% PFCsup not good - HPCrip not good
%     '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343' ... %%OK%%      
% };


% % Appel de la fonction de comparaison des spectres
% compareSpectres(enregistrements_mutants, enregistrements_controles);

% Définition de la fonction principale de comparaison
function compareSpectres(enregistrements_mutants, enregistrements_controles)
    % Analyse et compare les spectres des mutants et des contrôles

    % Calcul des spectres pour les mutants
    [f_all_subjects, mean_spectra_mutants, std_spectra_mutants] = analyserGroupe(enregistrements_mutants);

    % Calcul des spectres pour les contrôles
    [~, mean_spectra_controles, std_spectra_controles] = analyserGroupe(enregistrements_controles);

    % Lissage des moyennes
    mean_spectra_mutants = smoothdata(mean_spectra_mutants, 1, 'movmean', 5); % Lissage sur 5 points
    mean_spectra_controles = smoothdata(mean_spectra_controles, 1, 'movmean', 5); % Lissage sur 5 points

    % Création de la figure pour les comparaisons
    figure;
    
    % Tracé pour chaque type de spectre (REMEpoch, f^a, log10(mean), log-log)
    titles = {'REMEpoch - mean', 'REMEpoch - f^a \times mean', 'REMEpoch - log10(mean)', 'REMEpoch - log-log'};
    y_labels = {'Power (normalized)', 'Power (normalized)', 'Power (dB)', 'Power (log-log)'};
    
    for k = 1:4
        subplot(1, 4, k), hold on;
        
        % Affichage pour les mutants
        fill_between(f_all_subjects(:), mean_spectra_mutants(:, k), std_spectra_mutants(:, k), 'g');
        plot(f_all_subjects, mean_spectra_mutants(:, k), 'g', 'LineWidth', 2, 'DisplayName', 'Mutants');
        
        % Affichage pour les contrôles
        fill_between(f_all_subjects(:), mean_spectra_controles(:, k), std_spectra_controles(:, k), 'k');
        plot(f_all_subjects, mean_spectra_controles(:, k), 'k', 'LineWidth', 2, 'DisplayName', 'Contrôles');
        
        title(titles{k});
        xlabel('Fréquence (Hz)');
        ylabel(y_labels{k});
        legend show;
    end
end

function [f_all_subjects, mean_spectra, std_spectra] = analyserGroupe(enregistrements)
    % Analyse un groupe d'enregistrements, calcule la moyenne et l'écart-type des spectres.

    % Initialisation des variables
    StsdSomCxdeepHM = cell(1, length(enregistrements));
    periods = struct();
    f_all_subjects = [];
    individual_spectra = [];

    % Charger les données pour chaque enregistrement
    for i = 1:length(enregistrements)
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'REMEpoch');
            periods(i).REMEpoch = REMEpoch;
        else
            error(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
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
    
    % Calcul des spectres pour chaque condition
    individual_spectra = zeros(length(enregistrements), length(f_all_subjects), 4);
    for i = 1:length(enregistrements)
        % REMEpoch mean
        spectra_REMEpoch = mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).REMEpoch)), 1);
        individual_spectra(i, :, 1) = spectra_REMEpoch;

        % f^a * mean(REMEpoch)
        spectra_REMEpoch_fa = f_all_subjects.^a .* spectra_REMEpoch;
        individual_spectra(i, :, 2) = spectra_REMEpoch_fa;

        % log10(mean(REMEpoch))
        spectra_REMEpoch_log = 10 * log10(spectra_REMEpoch);
        individual_spectra(i, :, 3) = spectra_REMEpoch_log;

        % log10(f) vs log10(mean(REMEpoch))
        log_f = 10 * log10(f_all_subjects);
        individual_spectra(i, :, 4) = spectra_REMEpoch_log;
    end

    % Moyenne et écart-type
    mean_spectra = squeeze(mean(individual_spectra, 1));
    std_spectra = squeeze(std(individual_spectra, 0, 1));
end

function fill_between(x, y_mean, y_std, color)
    % Vérifie si les vecteurs sont de la même longueur
    if length(x) ~= length(y_mean) || length(y_mean) ~= length(y_std)
        error('Les vecteurs x, y_mean et y_std doivent avoir la même longueur.');
    end
    % remplissage de l'intervalle autour de la moyenne avec l'écart type
    fill([x; flipud(x)], [y_mean + y_std; flipud(y_mean - y_std)], color, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
end