% Tests de normalité sur les données
disp('Tests de normalité pour les données...');
normality_results = struct();

data_sets = {sleep_percentages_total_session, sleep_percentages_total_sleep, total_durations, num_episodes};
data_names = {'Pourcentages_Total_Session', 'Pourcentages_Total_Sleep', 'Durations', 'Episodes'};
groups = {'Controles', 'Mutants'};

for k = 1:length(data_sets)
    disp(['--- Vérification pour : ', data_names{k}, ' ---']);
    data_control = data_sets{k}{1};
    data_mutant = data_sets{k}{2};
    
    for j = 1:size(data_control, 2) % Pour chaque variable (Wake, SWS, REM)
        % Données des contrôles et mutants pour cette variable
        control_data = data_control(:, j);
        mutant_data = data_mutant(:, j);
        
        % Tests de normalité pour chaque groupe
        [h_sw_ctrl, p_sw_ctrl] = swtest(control_data);
        [h_sw_mut, p_sw_mut] = swtest(mutant_data);
        
        % Stocker les résultats
        normality_results.(data_names{k}).(groups{1})(j).p_value = p_sw_ctrl;
        normality_results.(data_names{k}).(groups{1})(j).h = h_sw_ctrl;
        normality_results.(data_names{k}).(groups{2})(j).p_value = p_sw_mut;
        normality_results.(data_names{k}).(groups{2})(j).h = h_sw_mut;

        % Affichage des résultats
        fprintf('Variable %d (Contrôles): p = %.3f, h = %d\n', j, p_sw_ctrl, h_sw_ctrl);
        fprintf('Variable %d (Mutants): p = %.3f, h = %d\n', j, p_sw_mut, h_sw_mut);
    end
end

disp('Tests de normalité terminés.');
