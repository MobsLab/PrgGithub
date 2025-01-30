%%% pour plot toutes les nuits stim vs baseline  pull it et faire une boucle
%%%%Ici 1 Stim vs 1 Baseline
%%% A lancer ligne par ligne car changement de dossier à chaque fois

%%%% Pour plot la figure des spectres HPc par état (REM,SWS,Wake)

% Se mettre dans le dossier Stim
FigurePart1_HPc_Spectres_Stim

%Se mettre dans le dossier Baseline
FigurePart2_HPc_Spectres_Baseline

%% pour sauver la figure (se mettre dans le dossier ou on veut sauver la figure)
pathname='Figures'
filename= 'Spectres HPC Stim vs Baseline'
savefig(fullfile(pathname,filename))


%%%%%%%%%%%%%

%%%% Pour plot la figure des spectres PFc par état (REM,SWS,Wake)

% Se mettre dans le dossier Stim
FigurePart1_PFc_Spectres_Stim

%Se mettre dans le dossier Baseline
FigurePart2_PFc_Spectres_Baseline

%% pour sauver la figure (se mettre dans le dossier ou on veut sauver la figure)
pathname='Figures'
filename= 'Spectres PFC Stim vs Baseline'
savefig(fullfile(pathname,filename))


%%%%%%%%%%%%%
%%%% Pour plot la figure des spectres Bulb par état (REM,SWS,Wake)

% Se mettre dans le dossier Stim
FigurePart1_Bulb_Spectres_Stim

%Se mettre dans le dossier Baseline
FigurePart2_Bulb_Spectres_Baseline

%% pour sauver la figure (se mettre dans le dossier ou on veut sauver la figure)
pathname='Figures'
filename= 'Spectres Bulb Stim vs Baseline'
savefig(fullfile(pathname,filename))


%%%%%%%%%%%%%
%%%% Pour plot la figure des spectres VLPO par état (REM,SWS,Wake)

% Se mettre dans le dossier Stim
FigurePart1_VLPO_Spectres_Stim

%Se mettre dans le dossier Baseline
FigurePart2_VLPO_Spectres_Baseline

%% pour sauver la figure (se mettre dans le dossier ou on veut sauver la figure)
pathname='Figures'
filename= 'Spectres VLPO Stim vs Baseline'
savefig(fullfile(pathname,filename))

