% Pourcentage médian de Wake, SWS, et REM (total session)
subplot(2, 2, 1);
hold on;
bar(1:3, [med_sleep_percentages_total_session{1}; med_sleep_percentages_total_session{2}]', 'grouped');
for g = 1:2
    for j = 1:3
        scatter(repmat(j + (g-1.5) * 0.15, size(sleep_percentages_total_session{g}, 1), 1), ...
            sleep_percentages_total_session{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
         % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_sleep_percentages_total_session']).(groups{g}).(sprintf('State_%d', j)) = sleep_percentages_total_session{g}(:, j);
    end
    errorbar((1:3) + (g-1.5) * 0.15, med_sleep_percentages_total_session{g}, ...
        med_sleep_percentages_total_session{g} - iqr_sleep_percentages_total_session{g}(1,:), ...
        iqr_sleep_percentages_total_session{g}(2,:) - med_sleep_percentages_total_session{g}, '.k', 'LineWidth', 1.5);
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
xlabel('États');
ylabel('% du temps (total session)');
title('Pourcentage médian de Wake, SWS, et REM (total session)');
legend(groups, 'Location', 'Best');
    % Afficher les valeurs enregistrées pour chaque point dans la console
disp('sleep_percentages_total_session :');
disp(data_points.(['group', num2str(g), '_sleep_percentages_total_session']));

% Pourcentage médian de SWS et REM (total sommeil)
subplot(2, 2, 2);
hold on;
bar(1:2, [med_sleep_percentages_total_sleep{1}; med_sleep_percentages_total_sleep{2}]', 'grouped');
for g = 1:2
    for j = 1:2
        scatter(repmat(j + (g-1.5) * 0.15, size(sleep_percentages_total_sleep{g}, 1), 1), ...
            sleep_percentages_total_sleep{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
           % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_sleep_percentages_total_sleep']).(groups{g}).(sprintf('State_%d', j)) = sleep_percentages_total_sleep{g}(:, j);
    end
    errorbar((1:2) + (g-1.5) * 0.15, med_sleep_percentages_total_sleep{g}, ...
        med_sleep_percentages_total_sleep{g} - iqr_sleep_percentages_total_sleep{g}(1,:), ...
        iqr_sleep_percentages_total_sleep{g}(2,:) - med_sleep_percentages_total_sleep{g}, '.k', 'LineWidth', 1.5);
end
set(gca, 'XTick', 1:2, 'XTickLabel', {'SWS', 'REM'});
xlabel('États');
ylabel('% du temps (total sommeil)');
title('Pourcentage médian de SWS et REM (total sommeil)');
legend(groups, 'Location', 'Best');
   % Afficher les valeurs enregistrées pour chaque point dans la console
disp('sleep_percentages_total_sleep :');
disp(data_points.(['group', num2str(g), '_sleep_percentages_total_sleep']));

% Durée totale médiane de Wake, SWS et REM
subplot(2, 2, 3);
hold on;
bar(1:3, [med_total_durations{1}; med_total_durations{2}]', 'grouped');
for g = 1:2
    for j = 1:3
        scatter(repmat(j + (g-1.5) * 0.15, size(total_durations{g}, 1), 1), ...
            total_durations{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
           % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_total_durations']).(groups{g}).(sprintf('State_%d', j)) = total_durations{g}(:, j);
    end
    errorbar((1:3) + (g-1.5) * 0.15, med_total_durations{g}, ...
        med_total_durations{g} - iqr_total_durations{g}(1,:), ...
        iqr_total_durations{g}(2,:) - med_total_durations{g}, '.k', 'LineWidth', 1.5);
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
xlabel('États');
ylabel('Durée totale (heures)');
title('Durée totale médiane de Wake, SWS, et REM (en heures)');
legend(groups, 'Location', 'Best');
   % Afficher les valeurs enregistrées pour chaque point dans la console
disp('total_durations :');
disp(data_points.(['group', num2str(g), '_total_durations']));

% Nombre médian d'épisodes de Wake, SWS et REM
subplot(2, 2, 4);
hold on;
bar(1:3, [med_num_episodes{1}; med_num_episodes{2}]', 'grouped');
for g = 1:2
    for j = 1:3
        scatter(repmat(j + (g-1.5) * 0.15, size(num_episodes{g}, 1), 1), ...
            num_episodes{g}(:, j), 50, colors(g,:), 'filled', 'jitter', 'on', 'jitterAmount', 0.05);
        % Enregistrer les valeurs des points dans la structure
        data_points.(['group', num2str(g), '_num_episodes']).(groups{g}).(sprintf('State_%d', j)) = num_episodes{g}(:, j);
    end
    errorbar((1:3) + (g-1.5) * 0.15, med_num_episodes{g}, ...
        med_num_episodes{g} - iqr_num_episodes{g}(1,:), ...
        iqr_num_episodes{g}(2,:) - med_num_episodes{g}, '.k', 'LineWidth', 1.5);
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'Wake', 'SWS', 'REM'});
xlabel('États');
ylabel('Nombre médian episodes');
title('Nombre médian episodes de Wake, SWS, et REM');
legend(groups, 'Location', 'Best');
   % Afficher les valeurs enregistrées pour chaque point dans la console
disp('num_episodes :');
disp(data_points.(['group', num2str(g), '_num_episodes']));
end
