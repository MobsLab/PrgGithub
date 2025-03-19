% Définition de la fonction principale
function analyseSpectres(enregistrements_mutants, enregistrements_controles)
    % Analyse les spectres des mutants et des contrôles

    % ---- Analyser les spectres pour les mutants ----
    disp('Analyse des spectres pour les mutants...');
    analyserGroupe(enregistrements_mutants, 'Mutants', 'r');

    % ---- Analyser les spectres pour les contrôles ----
    disp('Analyse des spectres pour les contrôles...');
    analyserGroupe(enregistrements_controles, 'Contrôles', 'k');
end