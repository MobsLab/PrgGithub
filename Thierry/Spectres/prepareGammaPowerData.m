function prepareGammaPowerData(enregistrements, output_file, freq_start, freq_end)
    % Prépare et sauvegarde les données de puissance gamma pour un intervalle donné
    num_mice = length(enregistrements);
    gamma_powers = NaN(num_mice, 1); % Stockage des puissances gamma pour chaque souris

    for i = 1:num_mice
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        if exist(accelero_path, 'file')
            load(accelero_path, 'Wake');
        else
            warning(['Fichier SleepScoring_Accelero.mat introuvable pour : ', accelero_path]);
            continue;
        end

        data_path = fullfile(enregistrements{i}, 'SpectrumDataH', 'SpectrumSomCxDeepH.mat');
        if exist(data_path, 'file')
            load(data_path, 't', 'Sp', 'f');
            Wake_spectrum = mean(Data(Restrict(tsd(t * 1E4, Sp), Wake)), 1);

            % Calcul de la puissance gamma pour l'intervalle spécifié
            freq_idx = (f >= freq_start & f < freq_end); % Indices correspondant à l'intervalle
            gamma_powers(i) = mean(Wake_spectrum(freq_idx));
        else
            warning(['Fichier de spectre introuvable : ', data_path]);
        end
    end

    % Sauvegarder les résultats dans un fichier .mat
    save(output_file, 'gamma_powers', 'freq_start', 'freq_end');
    disp(['Données sauvegardées dans : ', output_file]);
end