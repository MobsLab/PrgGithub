%% Distributions
figure
sgtitle('Распределения', 'FontSize', 30, 'FontWeight', 'bold')

subplot(2, 3, 1)
hist(heart, 13);
title('Пульс')
ylim([0 110])
xline(mean_heart, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_heart-std_heart 0 2*std_heart 110], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_heart-2*std_heart 0 4*std_heart 110], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty


subplot(2, 3, 2)
hist(mood, 10)
title('Настроение')
xlim([0 11])
ylim([0 70])
xline(mean_mood, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_mood-std_mood 0 2*std_mood 70], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_mood-2*std_mood 0 4*std_mood 70], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty

subplot(2, 3, 3)
hist(sleep_quality, 10)
title('Качество сна')
xlim([0 11])
ylim([0 70])
xline(mean_sleep_quality, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_sleep_quality-std_sleep_quality 0 2*std_sleep_quality 70], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_sleep_quality-2*std_sleep_quality 0 4*std_sleep_quality 70], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty

subplot(2, 3, 4)
hist(sleep_hours, 10)
title('Количество сна')
xlim([2 15])
ylim([0 120])
xline(mean_sleep_hours, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_sleep_hours-std_sleep_hours 0 2*std_sleep_hours 120], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_sleep_hours-2*std_sleep_hours 0 4*std_sleep_hours 120], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty

subplot(2, 3, 5)
hist(reaction_time, 60)
title('Скорость реакции')
xlim([0 600])
ylim([0 50])
xline(mean_reaction_time, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_reaction_time-std_reaction_time 0 2*std_reaction_time 50], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_reaction_time-2*std_reaction_time 0 4*std_reaction_time 50], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty

subplot(2, 3, 6)
hist(time_perception, 40)
title('Восприятие времени')
xlim([0 100])
ylim([0 40])
xline(mean_time_perception, '-r', 'LineWidth', 2)
%1 std
rectangle('Position', [mean_time_perception-std_time_perception 0 2*std_time_perception 40], 'FaceColor', [0 0 0.8 0.1])
%2 std
rectangle('Position', [mean_time_perception-2*std_time_perception 0 4*std_time_perception 40], 'FaceColor', [0.2 0.4 0.2 0.1])
makepretty
