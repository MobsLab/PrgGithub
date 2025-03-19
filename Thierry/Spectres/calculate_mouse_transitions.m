 
function transitions = calculate_mouse_transitions(mouse_data, bin_size, window_size, num_states)
    % Générer les bins de temps
    time_bins = 0:bin_size:mouse_data.recording_duration; % Bins de 10 secondes
    num_bins_per_window = floor(window_size / bin_size);  % Nombre de bins par fenêtre (180 pour 30 min)
    num_windows = floor(length(time_bins) / num_bins_per_window); % Nombre de fenêtres
    transitions = zeros(num_states, num_states, num_windows); % Matrice des transitions

    % Assigner les états aux bins
    wake_bins = assign_bins(mouse_data.Wake_intervals, time_bins);
    sws_bins = assign_bins(mouse_data.SWS_intervals, time_bins);
    rem_bins = assign_bins(mouse_data.REM_intervals, time_bins);

    % Séquence d'états pour chaque bin (0 = aucun état, 1 = Wake, 2 = SWS, 3 = REM)
    state_sequence = zeros(1, length(wake_bins));
    state_sequence(wake_bins == 1) = 1;
    state_sequence(sws_bins == 1) = 2;
    state_sequence(rem_bins == 1) = 3;

    % Calculer les transitions par fenêtre
    for w = 1:num_windows
        % Déterminer les indices de bins dans la fenêtre courante
        window_start_idx = (w - 1) * num_bins_per_window + 1;
        window_end_idx = w * num_bins_per_window;

        % Extraire les états de cette fenêtre
        window_states = state_sequence(window_start_idx:window_end_idx);

        % Comptage des transitions par état de départ
        num_bins_in_state = zeros(num_states, 1); % Nombre de bins dans chaque état (Wake, SWS, REM)
        for i = 1:length(window_states) - 1
            % Compter les transitions valides
            if window_states(i) > 0 && window_states(i + 1) > 0
                transitions(window_states(i), window_states(i + 1), w) = ...
                    transitions(window_states(i), window_states(i + 1), w) + 1;
            end
            % Comptabiliser les bins dans l'état courant
            if window_states(i) > 0
                num_bins_in_state(window_states(i)) = num_bins_in_state(window_states(i)) + 1;
            end
        end

        % Normaliser les transitions par le nombre total de bins dans chaque état de départ
        for from_state = 1:num_states
            if num_bins_in_state(from_state) > 0
                transitions(from_state, :, w) = ...
                    transitions(from_state, :, w) / num_bins_in_state(from_state);
            end
        end
    end
end




%function transitions = calculate_mouse_transitions(mouse_data, bin_size, window_size, num_states)
%     % Générer les bins de temps
%     time_bins = 0:bin_size:mouse_data.recording_duration;
%     num_bins_per_window = floor(window_size / bin_size);
%     num_windows = floor(length(time_bins) / num_bins_per_window);
%     transitions = zeros(num_states, num_states, num_windows);
% 
%     % Assigner les états
%     wake_bins = assign_bins(mouse_data.Wake_intervals, time_bins);
%     sws_bins = assign_bins(mouse_data.SWS_intervals, time_bins);
%     rem_bins = assign_bins(mouse_data.REM_intervals, time_bins);
% 
%     state_sequence = zeros(1, length(wake_bins));
%     state_sequence(wake_bins == 1) = 1;
%     state_sequence(sws_bins == 1) = 2;
%     state_sequence(rem_bins == 1) = 3;
% 
%     % Calculer les transitions par fenêtre
%     for w = 1:num_windows
%         window_states = state_sequence((w - 1) * num_bins_per_window + 1:w * num_bins_per_window);
%         for i = 1:length(window_states) - 1
%             if window_states(i) > 0 && window_states(i + 1) > 0
%                 transitions(window_states(i), window_states(i + 1), w) = ...
%                     transitions(window_states(i), window_states(i + 1), w) + 1;
%             end
%         end
%     end
% 
%     % Normaliser par le nombre total de transitions par fenêtre
%     for w = 1:num_windows
%         transitions(:, :, w) = transitions(:, :, w) / sum(transitions(:, :, w), 'all');
%     end
% end
