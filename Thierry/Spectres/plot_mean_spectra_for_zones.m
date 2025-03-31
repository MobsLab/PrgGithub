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