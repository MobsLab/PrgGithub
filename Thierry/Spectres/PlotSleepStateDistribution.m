function PlotSleepStateDistribution(WakeWiNoise, SWSEpochWiNoise, REMEpochWiNoise, bin_size)
    % PlotSleepStateDistribution : Divise le temps en bins et trace les occurrences des états.
    %
    % Inputs :
    % - Wake : périodes d'éveil
    % - SWSEpoch : périodes de sommeil lent profond
    % - REMEpoch : périodes de sommeil paradoxal
    % - bin_size : taille des bins en secondes (ex : 10s)
    %
    % Output :
    % - Affiche un graphique avec les courbes des occurrences de Wake, SWS, et REM.

    % Déterminer les limites temporelles globales
    start_time = min([Start(WakeWiNoise, 's'); Start(SWSEpochWiNoise, 's'); Start(REMEpochWiNoise, 's')]);
    end_time = max([End(WakeWiNoise, 's'); End(SWSEpochWiNoise, 's'); End(REMEpochWiNoise, 's')]);

    % Créer des bins temporels
    time_bins = start_time:bin_size:end_time;
    num_bins = length(time_bins) - 1;

    % Initialiser les vecteurs pour les occurrences
    wake_counts = zeros(1, num_bins);
    sws_counts = zeros(1, num_bins);
    rem_counts = zeros(1, num_bins);

    % Parcourir chaque bin pour compter les états
    for i = 1:num_bins
        bin_start = time_bins(i);
        bin_end = time_bins(i + 1);

        % Compter les occurrences dans chaque état
        wake_counts(i) = sum(Start(WakeWiNoise, 's') < bin_end & End(WakeWiNoise, 's') > bin_start);
        sws_counts(i) = sum(Start(SWSEpochWiNoise, 's') < bin_end & End(SWSEpochWiNoise, 's') > bin_start);
        rem_counts(i) = sum(Start(REMEpochWiNoise, 's') < bin_end & End(REMEpochWiNoise, 's') > bin_start);
    end

    % Tracer les courbes des états
    figure('Color', [1 1 1]);
    hold on;
    plot(time_bins(1:end-1) + bin_size / 2, wake_counts, '-r', 'LineWidth', 2, 'DisplayName', 'Wake');
    plot(time_bins(1:end-1) + bin_size / 2, sws_counts, '-b', 'LineWidth', 2, 'DisplayName', 'SWS');
    plot(time_bins(1:end-1) + bin_size / 2, rem_counts, '-g', 'LineWidth', 2, 'DisplayName', 'REM');
    hold off;

    % Ajouter des labels et une légende
    xlabel('Temps (s)');
    ylabel('Occurrences');
    title('Distribution des états de sommeil par bin');
    legend('show');
    grid on;
end
