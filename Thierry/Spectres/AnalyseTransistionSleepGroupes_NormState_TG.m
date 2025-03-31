
%         Définition des chemins d'enregistrements
%     enregistrements_controles = { ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M2_240531_095224/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M3_240709_093745/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M4_240705_100948/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Controles/M5_240718_093343/' ...
%     };
% 
%     enregistrements_mutants = { ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M1_240628_091858/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M7_240711_090852/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M8_240704_093657/', ...
%         '/Volumes/GALLOPIN_T/Thrami_PV_Project/Mutant/M9_240711_090852/' ...
%     };

enregistrements_controles = { ...
     '/media/nas6/Projet TramiPV/TG1_TG2_BaselineSleep_240531_095224/M2';
     '/media/nas6/Projet TramiPV/Trami_TG2_TG3_TG4_TG5_BaselineSleep_240709_093745/M3';
     '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240705_100948/M4';
     '/media/nas6/Projet TramiPV/Trami_TG5_BaselineSleep_240718_093343';
 };
enregistrements_mutants = { ...
    '/media/nas6/Projet TramiPV/Trami_TG1_TG2_TG3_TG7_BaselineSleep_240628_091858/M1';
    '/media/nas6/Projet TramiPV/Trami_TG4_TG8_TG9_BaselineSleep_240704_093657/M8';
    '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M7';
    '/media/nas6/Projet TramiPV/Trami_TG1_TG7_TG8_TG9_BaselineSleep_240711_090852/M9';
   };

    groups = {'Controles', 'Mutants'};
    enregistrements = {enregistrements_controles, enregistrements_mutants};


% Initialiser une structure pour stocker les données des groupes
data = struct();

% Charger les données pour chaque groupe et chaque souris
for g = 1:length(groups)
    group_name = groups{g};
    data.(group_name) = struct(); % Créer une structure pour chaque groupe
    
    for i = 1:length(enregistrements{g})
        mouse_path = enregistrements{g}{i};
        
        % Extraire un nom explicite pour la souris à partir du chemin
        [~, mouse_name] = fileparts(mouse_path); % Récupère le dernier dossier du chemin

        % Charger les données pour la souris
        sleep_data = load(fullfile(mouse_path, 'SleepScoring_Accelero.mat'));
        
        % Extraire les informations nécessaires (par exemple, intervalles d'états)
        data.(group_name).(mouse_name).Wake_intervals = [Start(sleep_data.Wake), End(sleep_data.Wake)] / 10000;
        data.(group_name).(mouse_name).SWS_intervals = [Start(sleep_data.SWSEpoch), End(sleep_data.SWSEpoch)] / 10000;
        data.(group_name).(mouse_name).REM_intervals = [Start(sleep_data.REMEpoch), End(sleep_data.REMEpoch)] / 10000;
        
        % Calculer la durée totale de l'enregistrement
        data.(group_name).(mouse_name).recording_duration = ...
            max([data.(group_name).(mouse_name).Wake_intervals(:); ...
                 data.(group_name).(mouse_name).SWS_intervals(:); ...
                 data.(group_name).(mouse_name).REM_intervals(:)]);
        
        % Afficher le statut
        disp(['Données chargées pour ', group_name, ' - ', mouse_name]);
    end
end

% Sauvegarder les données dans un fichier .mat pour une utilisation ultérieure
save('GroupSleepData.mat', 'data');
disp('Les données ont été sauvegardées dans GroupSleepData.mat');

%%%%%%%%%%%%%%%%%%%%

% Script pour l'analyse des transitions entre groupes
clear; clc;

%% Étape 1 : Charger les données groupées
disp('Chargement des données...');
load('GroupSleepData.mat'); % Charger les données des souris (structure `data`)

% Paramètres d'analyse
bin_size = 10; % Taille des bins en secondes
window_size = 1800; % Taille des fenêtres en secondes (30 minutes)
num_states = 3; % Wake, SWS, REM
groups = fieldnames(data); % 'Controles', 'Mutants'

%% Étape 2 : Déterminer la durée minimale parmi tous les enregistrements
disp('Détermination de la durée minimale...');
min_duration = inf; % Initialiser avec une valeur élevée

for g = 1:length(groups)
    group_name = groups{g};
    mice_names = fieldnames(data.(group_name));
    
    for i = 1:length(mice_names)
        mouse_name = mice_names{i};
        mouse_data = data.(group_name).(mouse_name);
        
        % Mettre à jour la durée minimale
        min_duration = min(min_duration, mouse_data.recording_duration);
    end
end

disp(['Durée minimale trouvée : ', num2str(min_duration), ' secondes.']);

%% Étape 3 : Calculer les transitions normalisées pour chaque souris
disp('Calcul des transitions normalisées pour chaque souris...');

% Noms des états
state_labels = {'Wake', 'SWS', 'REM'};

% Initialiser la structure pour les transitions normalisées
group_transitions_normalized = struct();

for g = 1:length(groups)
    group_name = groups{g};
    mice_names = fieldnames(data.(group_name)); % Récupérer les noms explicites des souris
    group_transitions_normalized.(group_name) = []; % Initialiser
    
    for i = 1:length(mice_names)
        mouse_name = mice_names{i};
        mouse_data = data.(group_name).(mouse_name); % Charger les données de la souris
        
        % Tronquer les intervalles dépassant la durée minimale
        mouse_data.Wake_intervals(mouse_data.Wake_intervals(:, 2) > min_duration, 2) = min_duration;
        mouse_data.SWS_intervals(mouse_data.SWS_intervals(:, 2) > min_duration, 2) = min_duration;
        mouse_data.REM_intervals(mouse_data.REM_intervals(:, 2) > min_duration, 2) = min_duration;
        
        % Supprimer les intervalles commençant après la durée minimale
        mouse_data.Wake_intervals(mouse_data.Wake_intervals(:, 1) > min_duration, :) = [];
        mouse_data.SWS_intervals(mouse_data.SWS_intervals(:, 1) > min_duration, :) = [];
        mouse_data.REM_intervals(mouse_data.REM_intervals(:, 1) > min_duration, :) = [];
        
        % Fusionner tous les intervalles dans une structure
        all_intervals = struct('Wake', mouse_data.Wake_intervals, ...
                               'SWS', mouse_data.SWS_intervals, ...
                               'REM', mouse_data.REM_intervals);
        
        % Calculer le nombre de fenêtres
        num_windows = floor(min_duration / window_size); % Nombre entier de fenêtres
        
        % Initialiser les transitions normalisées
        transitions_normalized = zeros(num_states, num_states, num_windows); % [From, To, Window]
        
        % Parcourir chaque fenêtre de 30 minutes
        for w = 1:num_windows
            % Début et fin de la fenêtre
            window_start = (w - 1) * window_size + 1;
            window_end = w * window_size;
            
            % Initialiser un compteur pour les transitions
            transitions_window = zeros(num_states, num_states);
            
            % Parcourir chaque état de départ
            for from_state = 1:num_states
                from_intervals = all_intervals.(state_labels{from_state});
                
                % Filtrer les intervalles dans la fenêtre actuelle
                from_bins = from_intervals(from_intervals(:, 1) >= window_start & from_intervals(:, 2) <= window_end, :);
                
                % Découper les intervalles en bins de 10 secondes
                for t = 1:size(from_bins, 1)
                    start_bin = max(from_bins(t, 1), window_start); % Limite au début de la fenêtre
                    end_bin = min(from_bins(t, 2), window_end);     % Limite à la fin de la fenêtre
                    
                    % Calculer le nombre de bins dans cet intervalle
                    num_bins = floor((end_bin - start_bin) / bin_size);
                    
                    % Parcourir chaque bin et calculer les transitions
                    for b = 1:num_bins
                        bin_start = start_bin + (b - 1) * bin_size;
                        bin_end = bin_start + bin_size;
                        
                        % Identifier l'état cible (où l'animal transite)
                        to_state = identify_to_state(bin_end, all_intervals);
                        
                        if ~isempty(to_state)
                            transitions_window(from_state, to_state) = transitions_window(from_state, to_state) + 1;
                        end
                    end
                end
            end
            
            % Normaliser les transitions pour cette fenêtre
            for from_state = 1:num_states
                total_transitions = sum(transitions_window(from_state, :));
                if total_transitions > 0
                    transitions_window(from_state, :) = transitions_window(from_state, :) / total_transitions;
                end
            end
            
            % Stocker les transitions pour cette fenêtre
            transitions_normalized(:, :, w) = transitions_window;
        end
        
        % Ajouter les transitions normalisées à la structure du groupe
        if isempty(group_transitions_normalized.(group_name))
            group_transitions_normalized.(group_name) = transitions_normalized;
        else
            group_transitions_normalized.(group_name) = cat(4, group_transitions_normalized.(group_name), transitions_normalized);
        end
    end
end

disp('Transitions normalisées calculées pour chaque souris.');



%% Étape 4 : Visualiser les transitions pour chaque souris
disp('Visualisation des transitions pour chaque souris...');

% Définir les points de temps pour les fenêtres d'analyse
num_windows = size(group_transitions_normalized.(groups{1}), 3); % Nombre total de fenêtres
time_points = (0:num_windows - 1) * window_size; % Points de temps en secondes

% Noms des états
state_labels = {'Wake', 'SWS', 'REM'};

for g = 1:length(groups)
    group_name = groups{g};
    mice_names = fieldnames(data.(group_name));
    
    for i = 1:length(mice_names)
        mouse_name = mice_names{i};
        mouse_transitions = group_transitions_normalized.(group_name)(:, :, :, i); % Transitions pour cette souris
        
        % Graphiques par état source
        for from_state = 1:num_states
            figure;
            hold on;
            
            % Extraire les données pour les transitions depuis cet état
            bar_data = squeeze(mouse_transitions(from_state, :, :))';
            
            % Tracer les barres empilées
            bar(time_points / 60, bar_data, 'stacked');
            
            % Détails du graphique
            xlabel('Time (minutes)');
            ylabel('Transition Probability');
            title(['Normalized Transitions from ', state_labels{from_state}, ' for ', group_name, ' - ', mouse_name]);
            legend({'To Wake', 'To SWS', 'To REM'}, 'Location', 'Best');
            grid on;
            hold off;
        end
    end
end

%% Étape 5 : Calculer les médianes et SD par groupe
disp('Calcul des médianes et SD par groupe...');
median_controls = median(group_transitions_normalized.Controles, 4);
median_mutants = median(group_transitions_normalized.Mutants, 4);
std_controls = std(group_transitions_normalized.Controles, 0, 4);
std_mutants = std(group_transitions_normalized.Mutants, 0, 4);

%% Étape 6 : Visualiser les médianes et SD par groupe
disp('Visualisation des médianes et SD par groupe...');

% Accès direct aux médianes et SD pour chaque groupe
median_struct = struct('Controles', median_controls, 'Mutants', median_mutants);
std_struct = struct('Controles', std_controls, 'Mutants', std_mutants);

for g = 1:length(groups)
    group_name = groups{g};
    medians = median_struct.(group_name); % Accéder directement aux médianes du groupe
    std_devs = std_struct.(group_name);  % Accéder directement aux SD du groupe
    
    % Graphiques par état source
    for from_state = 1:num_states
        figure;
        hold on;
        
        % Extraire les données pour les transitions depuis cet état
        median_data = squeeze(medians(from_state, :, :))';
        sd_data = squeeze(std_devs(from_state, :, :))';
        
        % Tracer les barres empilées avec les médianes
        bar(time_points / 60, median_data, 'stacked');
        
        % Ajouter des barres d'erreur pour l'écart-type
        for t = 1:size(median_data, 1)
            for to_state = 1:num_states
                x = time_points(t) / 60; % Temps en minutes
                y = sum(median_data(t, 1:to_state)); % Position cumulative
                errorbar(x, y, sd_data(t, to_state), 'k.', 'LineWidth', 1.5);
            end
        end
        
        % Détails du graphique
        xlabel('Time (minutes)');
        ylabel('Transition Probability');
        title(['Median Transitions from ', state_labels{from_state}, ' for ', group_name]);
        legend({'To Wake', 'To SWS', 'To REM'}, 'Location', 'Best');
        grid on;
        hold off;
    end
end

function to_state = identify_to_state(bin_end, all_intervals)
    % Identifie l'état cible à la fin d'un bin
    % 
    % Entrées :
    % - bin_end : Fin du bin en cours
    % - all_intervals : Structure contenant les intervalles pour chaque état (Wake, SWS, REM)
    %
    % Sortie :
    % - to_state : Indice de l'état cible (1 = Wake, 2 = SWS, 3 = REM), ou [] si aucun état trouvé

    to_state = []; % Valeur par défaut si aucun état n'est trouvé
    state_labels = fieldnames(all_intervals); % Liste des états : {'Wake', 'SWS', 'REM'}
    
    for s = 1:length(state_labels)
        state_name = state_labels{s};
        intervals = all_intervals.(state_name); % Obtenir les intervalles pour cet état
        
        % Vérifier si le bin_end est contenu dans un intervalle de cet état
        if any(intervals(:, 1) <= bin_end & intervals(:, 2) >= bin_end)
            to_state = s; % Retourne l'indice de l'état
            return; % Arrête la recherche après avoir trouvé l'état
        end
    end
end


%% Étape 7 : Sauvegarder les résultats
disp('Sauvegarde des résultats...');
save('TransitionComparison.mat', 'median_controls', 'median_mutants', 'std_controls', 'std_mutants', 'min_duration');
disp('Résultats sauvegardés dans TransitionComparison.mat.');


