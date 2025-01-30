function compareRipplesMeanWaveformByMouse(enregistrements_controles, enregistrements_mutants)
    % Préparer les couleurs pour les groupes et initialiser les moyennes globales
    colors = {'k', 'r'};  % Noir pour contrôles, rouge pour mutants
    groupes = {enregistrements_controles, enregistrements_mutants};
    noms_groupes = {'Controles', 'Mutants'};
    
    % Initialisation pour stocker les moyennes des ripples pour chaque souris
    Mean_Ripples_Group = {[], []};  % Pour stocker les moyennes individuelles
    
    % Initialisation pour trouver les limites globales de l'axe y
    global_y_min = Inf;
    global_y_max = -Inf;
    
    % Boucle sur les groupes (contrôles et mutants)
    figure;
    for g = 1:2
        n_mice = length(groupes{g});
        
        for i = 1:n_mice
            % Changer de dossier pour chaque souris et charger les données nécessaires
            cd(groupes{g}{i});
            load('SWR.mat', 'tRipples');
            load('SleepScoring_OBGamma.mat', 'SWSEpoch');
            load('ChannelsToAnalyse/dHPC_rip.mat', 'channel');
            load(['LFPData/LFP' num2str(channel) '.mat'], 'LFP');
            
            % Restreindre les ripples aux périodes SWS
            ripples_time = Range(Restrict(tRipples, SWSEpoch), 's');
            
            % Calcul de la forme moyenne des ripples pour cette souris
            [M, T] = PlotRipRaw(LFP, ripples_time, 200, 0, 0);
            Mean_Ripples_Group{g}(i, :) = M(:, 2)';  % Stocker la moyenne
            
            % Mettre à jour les valeurs min et max pour ajuster l'échelle de y
            global_y_min = min(global_y_min, min(M(:, 2)));
            global_y_max = max(global_y_max, max(M(:, 2)));
            
            % Tracé de la moyenne individuelle des ripples pour cette souris
            subplot(2, n_mice, i + (g-1) * n_mice);
            plot(linspace(-50, 125, length(M(:, 2))), M(:, 2), colors{g}, 'LineWidth', 1.5);
            vline(0, '--k');
            xlabel('Time (ms)');
            ylabel('Amplitude');
            title([noms_groupes{g} ' - Souris ' num2str(i)]);
        end
    end
    
    % Ajuster les échelles de y pour tous les sous-graphes
    for i = 1:(2 * n_mice)
        subplot(2, n_mice, i);
        ylim([global_y_min, global_y_max]);
    end
    
    % Calculer la moyenne des moyennes pour chaque groupe
    Mean_Ripples_Controls = mean(Mean_Ripples_Group{1}, 1);
    Mean_Ripples_Mutants = mean(Mean_Ripples_Group{2}, 1);
    
    % Tracé final : comparaison des moyennes globales pour contrôles vs mutants
    figure;
    hold on;
    plot(linspace(-50, 125, length(Mean_Ripples_Controls)), Mean_Ripples_Controls, 'k', 'LineWidth', 2, 'DisplayName', 'Controles');
    plot(linspace(-50, 125, length(Mean_Ripples_Mutants)), Mean_Ripples_Mutants, 'r', 'LineWidth', 2, 'DisplayName', 'Mutants');
    vline(0, '--k');
    xlabel('Time (ms)');
    ylabel('Amplitude');
    ylim([global_y_min, global_y_max]); % Appliquer la même échelle pour la comparaison finale
    title('Moyenne de la forme d''onde des ripples : Contrôles vs Mutants');
    legend('show');
    hold off;
end


