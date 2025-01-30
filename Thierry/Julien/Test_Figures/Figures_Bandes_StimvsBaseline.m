%%%%%% Figure 1Stim vs 1Baseline


%%% Theta HPc (bande  6 à 9Hz)

%%Se mettre dans le dossier Stim
Courbe_Theta_HPc_Stim

%%Se mettre dans le dossier baseline 
Courbe_Theta_HPc_Baseline

%%Pour sauver la figure 
pathname='Figures'
filename= 'Bande Theta HPC REM Stim vs Baseline'
savefig(fullfile(pathname,filename))



%%%% Delta (fenetre 2.5-4.5Hz) PFc

%%Se mettre dans le dossier Stim
Courbe_Delta_PFc_Stim
%%Se mettre dans le dossier baseline
Courbe_Delta_PFc_Baseline
%%Pour sauver la figure 
pathname='Figures'
filename= 'Bande 4Hz PFC SWS Stim vs Baseline'
savefig(fullfile(pathname,filename))


%%% Bande 4Hz dans le bulb

%%Se mettre dans le dossier Stim
Courbe_4Hz_Bulb_Stim
%%Se mettre dans le dossier baseline
Courbe_4Hz_Bulb_Baseline
%%Pour sauver la figure 
pathname='Figures'
filename= 'Bande 4Hz Bulb REM Stim vs Baseline'
savefig(fullfile(pathname,filename))
