function p = exact_mann_whitney(control, mutant)
    % Combine les données
    combined = [control; mutant];
    n_ctrl = length(control);
    n_mut = length(mutant);

    % Calculer la statistique U pour les groupes originaux
    U_obs = sum(ranksum_stat(control, mutant));

    % Générer toutes les permutations possibles
    all_permutations = nchoosek(1:length(combined), n_ctrl);
    num_permutations = size(all_permutations, 1);

    % Calculer les U pour chaque permutation
    U_perm = zeros(num_permutations, 1);
    for i = 1:num_permutations
        ctrl_perm = combined(all_permutations(i, :));
        mut_perm = combined(setdiff(1:length(combined), all_permutations(i, :)));
        U_perm(i) = sum(ranksum_stat(ctrl_perm, mut_perm));
    end

    % Calculer la p-value exacte
    p = mean(U_perm >= U_obs);
end

function U = ranksum_stat(ctrl, mut)
    % Statistique de rang pour Mann-Whitney
    data = [ctrl; mut];
    ranks = tiedrank(data);
    U = sum(ranks(1:length(ctrl)));
end