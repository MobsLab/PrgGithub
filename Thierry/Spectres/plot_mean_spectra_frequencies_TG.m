function plot_mean_spectra_frequencies(isHighFreq)
    % Si isHighFreq est vrai, on traite les hautes fréquences, sinon les basses
    if isHighFreq
        freqSuffix = 'H';  % Suffixe pour les hautes fréquences
        freqFolder = 'SpectrumDataH';  % Dossier des spectres haute fréquence
    else
        freqSuffix = 'L';  % Suffixe pour les basses fréquences
        freqFolder = 'SpectrumDataL';  % Dossier des spectres basse fréquence
    end

    % Liste des dossiers d'enregistrements (chaque dossier contient un enregistrement)
    enregistrements = { ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M1', ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2', ...
        '/media/mobs/DataMOBS203/TG1_TG2_BaselineSleep_240531_095224/M2', ...
        
    };
    
     % Correspondance entre les zones cérébrales et les fichiers de spectre
    %zones = {'SpectrumSomCxsupL', 'SpectrumSomCxsupH', 'SpectrumSomCxDeepL', 'SpectrumSomCxDeepH', 'SpectrumPFCsupL', 'SpectrumPFCsupH', 'SpectrumPFCdeepL', 'SpectrumPFCdeepH', 'SpectrumHPCripL', 'SpectrumHPCripH', 'SpectrumHPCdeepL', 'SpectrumHPCdeepH', 'SpectrumOBL', 'SpectrumOBH'};
    zones = {'SomCxsupL', 'SomCxsupH', 'SomCxDeepL', 'SomCxDeepH', 'HPCripL', 'HPCripH', 'HPCdeepL', 'HPCdeepH', 'OBL', 'OBH'};
    
     % Matrices pour stocker les spectres par zone pour chaque période (Wake, SWS, REM)
    spectres = struct();
    
    % Boucle sur les enregistrements pour charger et restreindre les spectres
    for i = 1:length(enregistrements)
        % Chemin vers le fichier SleepScoring_Accelero.mat dans le dossier principal de chaque enregistrement
        accelero_path = fullfile(enregistrements{i}, 'SleepScoring_Accelero.mat');
        
        % Charger les périodes Wake, REM, SWS pour chaque enregistrement
        if exist(accelero_path, 'file') == 2
            load(accelero_path, 'Wake', 'REMEpoch', 'SWSEpoch');
        else
            error(['Fichier introuvable : ' accelero_path]);
        end
        
        for j = 1:length(zones)
            zone = zones{j};
            
            % Construire correctement le nom du fichier avec le bon suffixe
            file_name = ['Spectrum' zone freqSuffix '.mat'];
            
            % Chemin vers le fichier de spectre pour la zone j dans le dossier correspondant (SpectrumDataH ou SpectrumDataL)
            file_path = fullfile(enregistrements{i}, freqFolder, file_name);
            
            % Vérifier si le fichier de spectre existe
            if exist(file_path, 'file') == 2
                % Charger les données du spectre (Sp: spectre, t: temps, f: fréquences)
                data = load(file_path, 'Sp', 't', 'f');
            else
                error(['Fichier de spectre introuvable : ' file_path]);
            end
            
            % Créer un objet tsd pour associer le spectre aux timestamps
            Stsd = tsd(data.t * 1E4, data.Sp);  % Adapter les unités de temps
            
            % Restreindre les spectres aux périodes Wake, REM, et SWS
            Sp_Wake = Data(Restrict(Stsd, Wake));         % Spectre pendant le Wake
            Sp_SWS = Data(Restrict(Stsd, SWSEpoch));      % Spectre pendant SWS
            Sp_REM = Data(Restrict(Stsd, REMEpoch));      % Spectre pendant REM
            
            % Si c'est la première itération, initialiser la matrice pour cette zone
            if i == 1
                spectres.(zone).Sp_Wake = Sp_Wake;
                spectres.(zone).Sp_SWS = Sp_SWS;
                spectres.(zone).Sp_REM = Sp_REM;
                spectres.(zone).f = data.f;  % Stocker les fréquences
            else
                % Ajouter les spectres des autres enregistrements
                spectres.(zone).Sp_Wake = spectres.(zone).Sp_Wake + Sp_Wake;
                spectres.(zone).Sp_SWS = spectres.(zone).Sp_SWS + Sp_SWS;
                spectres.(zone).Sp_REM = spectres.(zone).Sp_REM + Sp_REM;
            end
        end
    end
    
    % Moyenne des spectres pour chaque zone et chaque période (division par le nombre d'enregistrements)
    for j = 1:length(zones)
        zone = zones{j};
        spectres.(zone).Sp_Wake = spectres.(zone).Sp_Wake / length(enregistrements);
        spectres.(zone).Sp_SWS = spectres.(zone).Sp_SWS / length(enregistrements);
        spectres.(zone).Sp_REM = spectres.(zone).Sp_REM / length(enregistrements);
    end
    
    % Tracer les spectres moyens pour chaque zone et chaque période
    plot_mean_spectra_for_zones(spectres);
end

function plot_mean_spectra_for_zones(spectres)
    % Zones cérébrales à tracer
    zones = fieldnames(spectres);
    
    % Paramètre pour normalisation (a)
    a = 2;

    % Boucle pour chaque zone cérébrale
    for j = 1:length(zones)
        zone = zones{j};
        Sp_Wake_mean = spectres.(zone).Sp_Wake;
        Sp_SWS_mean = spectres.(zone).Sp_SWS;
        Sp_REM_mean = spectres.(zone).Sp_REM;
        f = spectres.(zone).f;
        
        % Tracer les spectres moyens pour la zone actuelle
        figure;
        
        % Subplot 1 : Spectre pendant le Wake
        subplot(1, 4, 1), hold on;
        plot(f, mean(Sp_Wake_mean, 2), 'k');  % Spectre pendant le Wake
        title([zone ' - Wake']);
        xlabel('Frequency (Hz)');
        ylabel('Power');
        
        % Subplot 2 : Spectre normalisé f^a pendant le Wake
        subplot(1, 4, 2), hold on, title(['Normalized a = ' num2str(a)]);
        plot(f, f.^a .* mean(Sp_Wake_mean, 2), 'k');
        xlabel('Frequency (Hz)');
        ylabel('Power (normalized)');
        
        % Subplot 3 : Spectre pendant le SWS
        subplot(1, 4, 3), hold on;
        plot(f, mean(Sp_SWS_mean, 2), 'b');  % Spectre pendant le SWS
        title([zone ' - SWS']);
        xlabel('Frequency (Hz)');
        ylabel('Power');
        
        % Subplot 4 : Spectre pendant le REM
        subplot(1, 4, 4), hold on;
        plot(f, mean(Sp_REM_mean, 2), 'r');  % Spectre pendant le REM
        title([zone ' - REM']);
        xlabel('Frequency (Hz)');
        ylabel('Power');
        
        pause(1);  % Pause pour visualiser chaque zone séparément
    end
end