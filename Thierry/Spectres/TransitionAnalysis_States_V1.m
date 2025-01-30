% Paramètres pour l'analyse
bin_size = 3; % Taille des bins en secondes
window_size = 1800; % Taille des fenêtres en secondes

%% Étape 1 : Conversion des IntervalSet en matrices d'intervalles
disp('Extraction des intervalles pour chaque état...');
load('SleepScoring_Accelero.mat');

% Extraction des intervalles pour chaque état
Wake_intervals = [Start(Wake), End(Wake)] / 10000; % Conversion en secondes
SWS_intervals = [Start(SWSEpoch), End(SWSEpoch)] / 10000; % Conversion en secondes
REM_intervals = [Start(REMEpoch), End(REMEpoch)] / 10000; % Conversion en secondes

%% Étape 2 : Analyse des transitions

% Calcul de la durée totale de l'enregistrement
recording_duration = max([Wake_intervals(:); SWS_intervals(:); REM_intervals(:)]);

% Générer les bins
time_bins = 0:bin_size:recording_duration;

% % Fonction pour assigner les états aux bins
% function state_bins = assign_bins(intervals, time_bins)
%     state_bins = zeros(1, length(time_bins) - 1);
%     for i = 1:size(intervals, 1)
%         start_bin = find(time_bins >= intervals(i, 1), 1, 'first');
%         end_bin = find(time_bins <= intervals(i, 2), 1, 'last');
%         if ~isempty(start_bin) && ~isempty(end_bin)
%             state_bins(start_bin:end_bin) = 1;
%         end
%     end
% end

% Attribuer les états
wake_bins = assign_bins(Wake_intervals, time_bins);
sws_bins = assign_bins(SWS_intervals, time_bins);
rem_bins = assign_bins(REM_intervals, time_bins);

% Combiner les états
state_sequence = zeros(1, length(wake_bins));
state_sequence(wake_bins == 1) = 1;
state_sequence(sws_bins == 1) = 2;
state_sequence(rem_bins == 1) = 3;

% Étape 1 : Interpoler les états non définis (state = 0)
for i = 2:length(state_sequence)
    if state_sequence(i) == 0
        state_sequence(i) = state_sequence(i - 1); % Remplir avec l'état précédent
    end
end

% Calculer les probabilités de transition
num_states = 3; % Wake, SWS, REM
num_bins_per_window = floor(window_size / bin_size);
transition_probabilities = [];
time_points = [];

for start_idx = 1:num_bins_per_window:(length(state_sequence) - num_bins_per_window + 1)
    window = state_sequence(start_idx:start_idx + num_bins_per_window - 1);
    transitions = zeros(num_states, num_states);
    
    % Étape 2 : Identifier les bins valides
    valid_bins = window > 0;
    valid_window = window(valid_bins); % Exclure les bins non définis
    
    % Compter les transitions entre états
    for i = 1:(length(valid_window) - 1)
        from_state = valid_window(i);
        to_state = valid_window(i + 1);
        transitions(from_state, to_state) = transitions(from_state, to_state) + 1;
    end
    
    % Normaliser par le nombre de bins valides dans la fenêtre
    valid_bins_count = length(valid_window) - 1; % Nombre de transitions valides
    if valid_bins_count > 0
        probabilities = transitions / valid_bins_count;
    else
        probabilities = zeros(num_states, num_states); % Aucune transition valide
    end
    
    transition_probabilities = cat(3, transition_probabilities, probabilities);
    time_points = [time_points, (start_idx - 1) * bin_size];
end

% Tracer les graphiques empilés pour chaque état source dans des subplots
state_labels = {'Wake', 'SWS', 'REM'};
figure;

% Subplots empilés
for from_state = 1:num_states
    subplot(3, 1, from_state);
    hold on;
    for to_state = 1:num_states
        plot_data = squeeze(transition_probabilities(from_state, to_state, :));
        area(time_points / 60, plot_data, 'FaceAlpha', 0.6); % Zone empilée
    end
    hold off;
    legend({[state_labels{from_state}, ' → Wake'], ...
            [state_labels{from_state}, ' → SWS'], ...
            [state_labels{from_state}, ' → REM']}, 'Location', 'Best');
    xlabel('Time (minutes)');
    ylabel('Transition Probability');
    title(['Transitions from ', state_labels{from_state}]);
    grid on;
end

% Histogramme empilé
figure;

% Subplots pour les transitions empilées à partir de chaque état source
for from_state = 1:num_states
    subplot(3, 1, from_state);
    bar_data = zeros(length(time_points), num_states);
    
    % Préparer les données pour les barres empilées
    for to_state = 1:num_states
        bar_data(:, to_state) = squeeze(transition_probabilities(from_state, to_state, :));
    end
    
    % Tracer les barres empilées
    bar(time_points / 60, bar_data, 'stacked');
    
    % Ajouter des détails au graphe
    legend({[state_labels{from_state}, ' → Wake'], ...
            [state_labels{from_state}, ' → SWS'], ...
            [state_labels{from_state}, ' → REM']}, 'Location', 'Best');
    xlabel('Time (minutes)');
    ylabel('Transition Probability');
    title(['Stacked Bar Chart of Transitions from ', state_labels{from_state}]);
    grid on;
end
