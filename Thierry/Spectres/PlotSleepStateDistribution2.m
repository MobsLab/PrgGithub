function PlotSleepStateDistribution2(Wake, SWSEpoch, REMEpoch, bin_size)
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
    start_time = min([Start(Wake, 's'); Start(SWSEpoch, 's'); Start(REMEpoch, 's')]);
    end_time = max([End(Wake, 's'); End(SWSEpoch, 's'); End(REMEpoch, 's')]);

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

        % Vérifier si une période chevauche le bin (au moins une fois)
        wake_counts(i) = any(Start(Wake, 's') < bin_end & End(Wake, 's') > bin_start);
        sws_counts(i) = any(Start(SWSEpoch, 's') < bin_end & End(SWSEpoch, 's') > bin_start);
        rem_counts(i) = any(Start(REMEpoch, 's') < bin_end & End(REMEpoch, 's') > bin_start);
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
    ylabel('Présence (0 ou 1)');
    title('Présence des états de sommeil par bin');
    legend('show');
    grid on;
end
