%% Exo 1
% Faire une boucle basée sur PathForExperimentsSleepWithDrugs pour aller
% chercher les données des souris fluoxetine chronique, charger les données
% et calculer le % de REM

%% Exo 2
% utiliser la boucle pour aussi calculer la durée moyenne d'un épisode de
% REM et la probabilité d'initier un épisode de REM

%% Exo 3
% Juste regarder le code qui calcule tous les spectrogrammes pour voir
% comment ça marche

%% Exo 4
% Faire le spectre moyen de l'activité de l'hippocampe pendant le REM

%% Exo 5
% Généraliser el 4 pour plusieurs états de sommeil et structures cérébrales
% Je propose d'essayer d'utlisier des structures
% (https://fr.mathworks.com/help/matlab/ref/struct.html) qui permettebt
% de stocker efficacement des données avec leur nom

%% Faire des graphes de tout ça et mettre sur discord!
% Fonctions utiles
% plot()
% PlotErrorBarN_KJ()
% errorbar()

%% Autres idées
% Le premier point important c'est de comaprer ça avec des souris normales
% Tu peux donc refaire tourner tes codes sur des nuits normales, par
% exemples en utilisant un autre PathForeExperiment:
%Dir = PathForExperimentsEmbReact('BaselineSleep') te donneras la liste

% Essayer de faire un graphe de % de REM / NREM en fonction de l'heure de
% la journée, pour ça utiliser la variable NewtsdZT dans behavResources.mat
% qui stocke l'heure de la journée en fonction du temps de l'enregistrement

% Regarder aussi pour N1, N2, N3. Cest Epoch sont stockées dans
% SleepSubstages.mat
% Epoch contient les différents états et NameEpoch t'indique lequel c'est
% donc Epoch{1} c'est l'intervalset pour NameEpoch{1} = 'N1'
% Pour àa tu peux faire % de temps, durée moyenne etc

% Tu peux aussi regarder les oscillations liées au sommeil : Ripples,
% Delta etc... Pour ça se réferer au code qu'on a écrit ensemble
% (CodesExempleBaptisteOthman_SB.m)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% LES SOLUTIONS %%
% J'ai codé ça vite, il y a peut être des erreurs ;-)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

%% Some codes to start analysing sleep with drugs

        %% Exo 1

% Chronic fluoxetine days
DayNames = {'FLX_Ch_Baseline','FLX_Ch_D2','FLX_Ch_W1','FLX_Ch_W2','FLX_Ch_W3'};

% List of mice in protocol. It is important to keep track of mice because
% sometimes one session is missing for one mouse. For example here mouse
% 877 didn't do D2 recording
MouseId = [875,876,877];

for day = 1:length(DayNames)
    
    Dir=PathForExperimentsSleepWithDrugs(DayNames{day});
    
    for mouse = 1:length(Dir.path)
        cd(Dir.path{mouse}{1})
        load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
        
        % Get the right mouse
        nmouse = find(MouseId == Dir.ExpeInfo{mouse}{1}.nmouse);
        nmouse
        
        % get the percent of REM
        PercRem(nmouse,day) = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(SWSEpoch)-Start(SWSEpoch));
        
        
    end
    
end

        %% Exo 2

for day = 1:length(DayNames)
    
    Dir=PathForExperimentsSleepWithDrugs(DayNames{day});
    
    for mouse = 1:length(Dir.path)
        cd(Dir.path{mouse}{1})
        load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
        
        % Get the right mouse
        nmouse = find(MouseId == Dir.ExpeInfo{mouse}{1}.nmouse);
        nmouse
        
        
        % get the transition probability into REM sleep
        RemProba(nmouse,day) = length(Stop(REMEpoch))./sum(Stop(Sleep)-Start(Sleep));
        
        % get the average duration of a REM bout
        RemDur(nmouse,day) = nanmean(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
        
        
        
    end
    
end


%% Exo 3
% Calculate all spectra
% J'ai déjà fait tourner, pas la peine de relancer

for day = 1:length(DayNames)
    
    Dir=PathForExperimentsSleepWithDrugs(DayNames{day});
    
    
    for mouse = 1:length(Dir.path)
        cd(Dir.path{mouse}{1})
        
        [Sp,t,f]=LoadSpectrumML('Bulb_deep');
        [Sp,t,f]=LoadSpectrumML('PFCx_deep');
        try,[Sp,t,f]=LoadSpectrumML('dHPC_rip');end
        try,[Sp,t,f]=LoadSpectrumML('dHPC_deep');end
    end
end

        %% Exo 4
        % get the spectra from REM  for HPC

for day = 1:length(DayNames)
    
    Dir=PathForExperimentsSleepWithDrugs(DayNames{day});
    
    for mouse = 1:length(Dir.path)
        cd(Dir.path{mouse}{1})
        load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
        
        
        clear Sp t f
        try,[Sp,t,f]=LoadSpectrumML('dHPC_rip');end
        try,[Sp,t,f]=LoadSpectrumML('dHPC_deep');end
        
        Sptsd = tsd(t*1e4,log(Sp));
        Mean.HPC.REM(nmouse,day,:) = nanmean(Data(Restrict(Sptsd,REMEpoch)));
        Mean.HPC.SWS(nmouse,day,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        Mean.HPC.Wake(nmouse,day,:) = nanmean(Data(Restrict(Sptsd,Wake)));
        
    end
end

%% Exo 5
% get the spectra from different epochs for many structures
% this shows how to make a structure and use looops for repetitive tasks
StructureNames = {'HPC','OB','PFCx'};
SleepState = {'REMEpoch','SWSEpoch','Wake'};

for day = 1:length(DayNames)
    
    Dir=PathForExperimentsSleepWithDrugs(DayNames{day});
    
    for mouse = 1:length(Dir.path)
        cd(Dir.path{mouse}{1})
        load('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Sleep','Wake')
        
        for struct = 1:length(StructureNames)
            
            % load the righ spectrogram
            clear Sp t f
            switch StructureNames{struct}
                case 'HPC'
                    try,[Sp,t,f]=LoadSpectrumML('dHPC_rip');end
                    try,[Sp,t,f]=LoadSpectrumML('dHPC_deep');end
                    
                case 'OB'
                    [Sp,t,f]=LoadSpectrumML('Bulb_deep');
                    
                case 'PFCx'
                    [Sp,t,f]=LoadSpectrumML('PFCx_deep');
            end
            Sptsd = tsd(t*1e4,log(Sp));
            
            for epoch = 1:length(SleepState)
                MeanSpec.(StructureNames{struct}).(SleepState{epoch})(nmouse,day,:) = nanmean(Data(Restrict(Sptsd,eval(SleepState{epoch}))));
            end
        end
    end
end
