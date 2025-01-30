% Appliquer un filtre passe-bas (ici lissage simple)
for i = 1:length(enregistrements)
    spectra_wake = mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake)));
    spectra_wake = smoothdata(spectra_wake, 'movmean', 1);  % Lissage sur 5 points
    individual_spectra(i, :) = spectra_wake;
    plot(f_all_subjects, spectra_wake, 'Color', colors(i,:), 'LineWidth', 1, 'DisplayName', ids{i}); 
end
% Calcul et tracé de la moyenne comme précédemment
mean_spectra_wake = mean(individual_spectra, 1);
std_spectra_wake = std(individual_spectra, 0, 1);

fill([f_all_subjects, fliplr(f_all_subjects)], ...
     [mean_spectra_wake + std_spectra_wake, fliplr(mean_spectra_wake - std_spectra_wake)], ...
     'k', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

plot(f_all_subjects, mean_spectra_wake, 'r', 'LineWidth', 2, 'DisplayName', 'Moyenne Wake');
title(['Wake - f^a \times mean']);
xlabel('Fréquence (Hz)');
ylabel('Puissance normalisée');
legend show;
%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(1, 4, 1), hold on;
individual_spectra = [];
for i = 1:length(enregistrements)
    spectra_wake = f_all_subjects.^a .* mean(Data(Restrict(StsdSomCxdeepHM{i}, periods(i).Wake)));
    spectra_wake = smoothdata(spectra_wake, 'movmean', 8);  % Lissage sur 8 points
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