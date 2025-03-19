% Fonction pour calculer la puissance en fonction de la méthode spécifiée
function power_values = calculatePower(data_path, wake_epoch, frequences, f, method, a)
    load(data_path, 't', 'Sp'); % Charger les données temporelles et spectrales
    restricted_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), wake_epoch)), 1);

    % Calcul de la puissance selon les différentes méthodes
    switch method
        case 1  % Mean
            power_values = arrayfun(@(j) mean(restricted_spectrum(f >= frequences(j) & f < (frequences(j) + 5))), 1:length(frequences));
        case 2  % f^a * Mean
            power_values = arrayfun(@(j) mean((f .^ a .* restricted_spectrum)(f >= frequences(j) & f < (frequences(j) + 5))), 1:length(frequences));
        case 3  % log10(Mean)
            power_values = arrayfun(@(j) mean(log10(restricted_spectrum(f >= frequences(j) & f < (frequences(j) + 5)))), 1:length(frequences));
        case 4  % log10(f^a * Mean)
            power_values = arrayfun(@(j) mean(log10(f .^ a .* restricted_spectrum(f >= frequences(j) & f < (frequences(j) + 5)))), 1:length(frequences));
    end
end
