%% Input Dir exci DREADD

%1 : sensory exposure in CD1 cage (only for C57 - CRH-cre could be added)
Dir_CD1_classic = PathForExperiments_SD_MC('SensoryExposureCD1cage');
Dir_CD1_tetrodes = PathForExperiments_SD_MC('SensoryExposureCD1cage_tetrodesPFC');
Dir_CD1_ctrl = MergePathForExperiment (Dir_CD1_classic,Dir_CD1_tetrodes);

% Dir_CD1_oneExpo = PathForExperiments_SD_MC('SensoryExposureCD1cage_oneSensoryExposure_tetrodesPFC'); % uniquement pour augmenter le N, peut pas faire de tests pairés si on l'utilise
% Dir_CD1_CD1 = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART1'); % uniquement pour augmenter le N, peut pas faire de tests pairés si on l'utilise
% Dir_Only_CD1 = MergePathForExperiment (Dir_CD1_oneExpo,Dir_CD1_CD1);

Dir_CD1_inhib_PFC_VLPO_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_CD1_inhib_PFC_VLPO_sal = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC');
Dir_CD1_inhib_PFC_VLPO = MergePathForExperiment (Dir_CD1_inhib_PFC_VLPO_cno,Dir_CD1_inhib_PFC_VLPO_sal);

Dir_CD1_mCherry_PFC_VLPO_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_CD1_mCherry_PFC_VLPO_sal = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_CD1_mCherry_PFC_VLPO = MergePathForExperiment (Dir_CD1_mCherry_PFC_VLPO_cno,Dir_CD1_mCherry_PFC_VLPO_sal);

Dir_CD1_PFC_VLPO = MergePathForExperiment (Dir_CD1_inhib_PFC_VLPO,Dir_CD1_mCherry_PFC_VLPO);

Dir_CD1_inhib_PFC_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
Dir_CD1_DREADD = MergePathForExperiment (Dir_CD1_PFC_VLPO,Dir_CD1_inhib_PFC_cno);

Dir_CD1_BM_cno = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection');
Dir_CD1_BM_sal = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_SalineInjection');
Dir_CD1_BM = MergePathForExperiment (Dir_CD1_BM_cno,Dir_CD1_BM_sal);

Dir_CD1_sal_cno = MergePathForExperiment (Dir_CD1_DREADD,Dir_CD1_BM);

Dir_CD1 = MergePathForExperiment (Dir_CD1_ctrl,Dir_CD1_sal_cno);


%2 : sensory exposure in C57 cage (only for C57 - CRH-cre could be added)
Dir_C57_classic = PathForExperiments_SD_MC('SensoryExposureC57cage');
Dir_C57_tetrodes = PathForExperiments_SD_MC('SensoryExposureC57cage_tetrodesPFC');
Dir_C57_ctrl = MergePathForExperiment (Dir_C57_classic,Dir_C57_tetrodes);

Dir_C57_inhib_PFC_VLPO_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_C57_inhib_PFC_VLPO_sal = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC');
Dir_C57_inhib_PFC_VLPO = MergePathForExperiment (Dir_C57_inhib_PFC_VLPO_cno,Dir_C57_inhib_PFC_VLPO_sal);

Dir_C57_mCherry_PFC_VLPO_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_C57_mCherry_PFC_VLPO_sal = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_C57_mCherry_PFC_VLPO = MergePathForExperiment (Dir_C57_mCherry_PFC_VLPO_cno,Dir_C57_mCherry_PFC_VLPO_sal);

Dir_C57_PFC_VLPO = MergePathForExperiment (Dir_C57_inhib_PFC_VLPO,Dir_C57_mCherry_PFC_VLPO);

Dir_C57_inhib_PFC_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
Dir_C57_DREADD = MergePathForExperiment (Dir_C57_PFC_VLPO,Dir_C57_inhib_PFC_cno);

Dir_C57_BM_cno = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection');
Dir_C57_BM_sal = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_SalineInjection');
Dir_C57_BM = MergePathForExperiment (Dir_C57_BM_cno,Dir_C57_BM_sal);

Dir_C57_sal_cno = MergePathForExperiment (Dir_C57_DREADD,Dir_C57_BM);

Dir_C57 = MergePathForExperiment (Dir_C57_ctrl,Dir_C57_sal_cno);

%%
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('H_Low_Spectrum.mat');
spectro = 'Bulb_deep_Low_Spectrum.mat';

%% parameters
% en_epoch_preInj = 1.5*1E8;%%1.4
% st_epoch_postInj = 1.65*1E8;

%% get the data
% Sensory exposure in CD1 cage
for i=1:length(Dir_CD1.path)
    cd(Dir_CD1.path{i}{1});
    a{i} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz,durT_fz]=DurationEpoch(a{i}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressCD1cage(i) = nanmean(dur_fz);
    num_fz_stressCD1cage(i) = length(dur_fz);
    freezing_total_duration_stressCD1cage(i) = durT_fz;
    perc_fz_stressCD1cage(i) = (freezing_total_duration_stressCD1cage(i)./1200)*100;
    %%spectro
    if exist(spectro)==2
        load(spectro);
        spectre_CD1 = tsd(Spectro{2}*1E4,Spectro{1});
        freq_CD1 = Spectro{3};
        sp_CD1{i}  = spectre_CD1;
        frq_CD1{i}  = freq_CD1;
    else
    end
end

%% Sensory exposure in C57 cage
for j=1:length(Dir_C57.path)
    cd(Dir_C57.path{j}{1});
    c{j} = load('behavResources.mat','Ratio_IMAonREAL','Xtsd','Ytsd','mask','ref','FreezeAccEpoch');
    %%freezing
    [dur_fz,durT_fz]=DurationEpoch(c{j}.FreezeAccEpoch,'min');
    freezing_mean_duration_stressC57cage(j) = nanmean(dur_fz);
    num_fz_stressC57cage(j) = length(dur_fz);
    freezing_total_duration_stressC57cage(j) = durT_fz;
    perc_fz_stressC57cage(j) = (freezing_total_duration_stressC57cage(j)./1200)*100;
    %%spectro
    if exist(spectro)==2
        load(spectro);
        spectre_C57 = tsd(Spectro{2}*1E4,Spectro{1});
        freq_C57 = Spectro{3};
        sp_C57{j}  = spectre_C57;
        frq_C57{j}  = freq_C57;
    else
    end
end
%%
% calculate mean spectrum for each mouse
for i=1:length(sp_CD1)
    try
        SpectreCD1_fz_mean(i,:)= nanmean(10*(Data(Restrict(sp_CD1{i},a{i}.FreezeAccEpoch))),1);
    end
end

% sem CD1 cage
SpectreCD1_fz_SEM = nanstd(SpectreCD1_fz_mean)/sqrt(size(SpectreCD1_fz_mean,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on mean spectrum
for i=1:length(sp_CD1)
    try 
    if isempty(sp_CD1{i})==0        
        SpectreCD1_fz_mean_norm(i,:)= SpectreCD1_fz_mean(i,:)./nanmean(SpectreCD1_fz_mean(i,:)); SpectreCD1_fz_mean(SpectreCD1_fz_mean==0)=NaN;
    else
    end
    end
end

% SEM_mean_norm CD1 cage
SpectreCD1_fz_SEM_norm = nanstd(SpectreCD1_fz_mean_norm)/sqrt(size(SpectreCD1_fz_mean_norm,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on max
for i=1:length(sp_CD1)
    try 
    if isempty(sp_CD1{i})==0        
        SpectreCD1_fz_max_norm(i,:)= SpectreCD1_fz_mean(i,:)./max(SpectreCD1_fz_mean(i,:)); SpectreCD1_fz_mean(SpectreCD1_fz_mean==0)=NaN;
    else
    end
    end
end

% SEM_max_norm CD1 cage
SpectreCD1_fz_SEM_max_norm = nanstd(SpectreCD1_fz_max_norm)/sqrt(size(SpectreCD1_fz_max_norm,1));


%%
% mean C57 cage
for j=1:length(sp_C57)
    try
    if isempty(sp_C57{j})==0        
        SpectreC57_fz_mean(j,:)= nanmean(10*(Data(Restrict(sp_C57{j},c{j}.FreezeAccEpoch))),1);
    else
    end
    end
end

% sem C57 cage
SpectreC57_fz_SEM = nanstd(SpectreC57_fz_mean)/sqrt(size(SpectreC57_fz_mean,1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on mean spectrum
for j=1:length(sp_C57)
    try
    if isempty(sp_C57{j})==0        
        SpectreC57_fz_mean_norm(j,:)= SpectreC57_fz_mean(j,:)./nanmean(SpectreC57_fz_mean(j,:)); SpectreC57_fz_mean(SpectreC57_fz_mean==0)=NaN;
    else
    end
    end
end

% SEM_norm C57 cage
SpectreC57_fz_SEM_norm = nanstd(SpectreC57_fz_mean_norm)/sqrt(size(SpectreC57_fz_mean_norm,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on max spectrum
for j=1:length(sp_C57)
    try
    if isempty(sp_C57{j})==0        
        SpectreC57_fz_max_norm(j,:)= SpectreC57_fz_mean(j,:)./max(SpectreC57_fz_mean(j,:)); SpectreC57_fz_mean(SpectreC57_fz_mean==0)=NaN;
    else
    end
    end
end


% SEM_max_norm C57 cage
SpectreC57_fz_SEM_max_norm = nanstd(SpectreC57_fz_max_norm)/sqrt(size(SpectreC57_fz_max_norm,1));


%% figures
% to get figures
% every possible comparison : Figure_Spectres_Saline_CNO_exci_CRH_VLPO_AD.m
% with normalisation on mean run : Figure_Spectres_normalized_mean_Saline_CNO_exci_CRH_VLPO_AD.m
% with normalisation on max run : Figure_Spectres_normalized_max_Saline_CNO_exci_CRH_VLPO_AD.m

