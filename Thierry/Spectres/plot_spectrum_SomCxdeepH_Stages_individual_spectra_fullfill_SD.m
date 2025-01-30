% Initialiser les enregistrements
%%%%%%%%%%%%mutants%%%%%%%%%%%%%%%
enregistrements = { ...
        '/media/mobs/DataMOBS203/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1', ... %OK
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8/', ... %OK 
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7',... %OK
        '/media/mobs/DataMOBS203/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9',... %OK
    };

% Extraire les identifiants uniques pour chaque enregistrement
ids = cellfun(@(x) regexp(x, '(?<=BaselineSleep_)[^/]+', 'match', 'once'), enregistrements, 'UniformOutput', false);

% Initialiser des variables pour stocker les tsd et les périodes pour chaque sujet
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

% Comparaison des spectres pour Wake, SWS et REM avec moyennes et différents types de tracés

% --- Wake ---
figure;
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
     'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'g', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - mean');
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
     'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'g', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title(['Wake - f^a \times mean']);
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
     'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'g', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - log10(mean)');
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
     'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(10 * log10(f_all_subjects), mean_spectra_wake, 'g', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - log-log');
xlabel('log10(Fréquence)');
ylabel('log10(Puissance)');
legend show;

% Ajouter un titre général avec annotation
annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxdeepH Wake', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

%%%%%%%%%%%%controles%%%%%%%%%%%%%%%
enregistrements = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2/', ... % SOMsup not goood - noPFC 
        '/media/mobs/DataMOBS203/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3', ... %OK
        '/media/mobs/DataMOBS203/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4', ... % PFCsup not good - HPCrip not good
        '/media/mobs/DataMOBS203/Trami_TG5_BaselineSleep_240718_093343', ... %OK
    };
% Extraire les identifiants uniques pour chaque enregistrement
ids = cellfun(@(x) regexp(x, '(?<=BaselineSleep_)[^/]+', 'match', 'once'), enregistrements, 'UniformOutput', false);

% Initialiser des variables pour stocker les tsd et les périodes pour chaque sujet
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

% Comparaison des spectres pour Wake, SWS et REM avec moyennes et différents types de tracés

% --- Wake ---
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
     'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - mean');
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
     'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title(['Wake - f^a \times mean']);
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
     'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'k', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - log10(mean)');
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
     'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(10 * log10(f_all_subjects), mean_spectra_wake, 'k', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title('Wake - log-log');
xlabel('log10(Fréquence)');
ylabel('log10(Puissance)');
legend show;

% % Ajouter un titre général avec annotation
% annotation('textbox', [0 0.9 1 0.1], 'String', 'SomCxdeepH Wake', ...
%     'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
