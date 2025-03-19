%% input dir DREADD
DirSaline = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_SalineInjection_10am');
DirSaline = RestrictPathForExperiment (DirSaline,'nMice', [1489 1510 1511 1512]); %to use for OB

DirCNO = PathForExperiments_DREADD_MC('inhibDREADD_CRH_VLPO_CNOInjection_10am');
DirCNO = RestrictPathForExperiment (DirCNO,'nMice', [1489 1510 1511 1512]); %to use for OB

%%
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('H_Low_Spectrum.mat');
spectro = 'Bulb_deep_Low_Spectrum.mat';

%% parameters
% time_mid_end_first_period = 1.5*1E8;%%1.4
% st_epoch_postInj = 1.65*1E8;

tempbin = 3600; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
time_end=3*1e8;  %end of the sleep session

time_mid_end_first_period = 1.5*3600*1e4; %1.5         %2 first hours (insomnia)
time_mid_begin_snd_period = 3.3*3600*1e4;%3.3           4 last hours(late pahse of the night)


%% get the data
% saline condition
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
   
    %all session
    epoch_all_saline{i} = intervalSet(time_st, time_end);
    %1st period
    epoch_early_saline{i} = intervalSet(time_st, time_mid_end_first_period);
    %2nd period
    epoch_mid_saline{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    %3rd period
    epoch_late_saline{i} = intervalSet(time_mid_begin_snd_period,time_end);

    if exist(spectro)==2
        load(spectro);
        spectre_saline = tsd(Spectro{2}*1E4,Spectro{1});
        freq_saline = Spectro{3};
        sp_sal{i}  = spectre_saline;
        frq_sal{i}  = freq_saline;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
end

%% CNO condition
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    c{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');

    %all session
    epoch_all_cno{j} = intervalSet(time_st, time_end);
    %1st period
    epoch_early_cno{j} = intervalSet(time_st, time_mid_end_first_period);
    %2nd period
    epoch_mid_cno{j} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    %3rd period
    epoch_late_cno{j} = intervalSet(time_mid_begin_snd_period,time_end);
        
        
    if exist(spectro)==2
        load(spectro);
        spectre_cno = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_cno = Spectro{3};
        temps_cno = Spectro{2};
        sp_cno{j} = spectre_cno;
        frq_cno{j} = frequence_cno;
        tps_cno{j} = temps_cno;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
end
%%
% calculate mean spectrum for each mouse
for i=1:length(sp_sal)
    try 
    SpectreSaline_Wake_first_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_early_saline{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_first_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_early_saline{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_first_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_early_saline{i},a{i}.REMEpoch)))),1);

    SpectreSaline_Wake_mid_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_mid_saline{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_mid_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_mid_saline{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_mid_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_mid_saline{i},a{i}.REMEpoch)))),1);
       
    SpectreSaline_Wake_late_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_late_saline{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_late_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_late_saline{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_late_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_late_saline{i},a{i}.REMEpoch)))),1);
   
    end 
end

% sem saline
SpectreSaline_Wake_first_SEM = nanstd(SpectreSaline_Wake_first_mean)/sqrt(size(SpectreSaline_Wake_first_mean,1));
SpectreSaline_SWS_first_SEM = nanstd(SpectreSaline_SWS_first_mean)/sqrt(size(SpectreSaline_SWS_first_mean,1));
SpectreSaline_REM_first_SEM = nanstd(SpectreSaline_REM_first_mean)/sqrt(size(SpectreSaline_REM_first_mean,1));

SpectreSaline_Wake_mid_SEM = nanstd(SpectreSaline_Wake_mid_mean)/sqrt(size(SpectreSaline_Wake_mid_mean,1));
SpectreSaline_SWS_mid_SEM = nanstd(SpectreSaline_SWS_mid_mean)/sqrt(size(SpectreSaline_SWS_mid_mean,1));
SpectreSaline_REM_mid_SEM = nanstd(SpectreSaline_REM_mid_mean)/sqrt(size(SpectreSaline_REM_mid_mean,1));

SpectreSaline_Wake_late_SEM = nanstd(SpectreSaline_Wake_late_mean)/sqrt(size(SpectreSaline_Wake_late_mean,1));
SpectreSaline_SWS_late_SEM = nanstd(SpectreSaline_SWS_late_mean)/sqrt(size(SpectreSaline_SWS_late_mean,1));
SpectreSaline_REM_late_SEM = nanstd(SpectreSaline_REM_late_mean)/sqrt(size(SpectreSaline_REM_late_mean,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(sp_sal)
    try 
    if isempty(sp_sal{i})==0        
        SpectreSaline_Wake_first_mean_norm(i,:)= SpectreSaline_Wake_first_mean(i,:)./nanmean(SpectreSaline_Wake_first_mean(i,:)); SpectreSaline_Wake_first_mean(SpectreSaline_Wake_first_mean==0)=NaN;
        SpectreSaline_SWS_first_mean_norm(i,:)= SpectreSaline_SWS_first_mean(i,:)./nanmean(SpectreSaline_SWS_first_mean(i,:)); SpectreSaline_SWS_first_mean(SpectreSaline_SWS_first_mean==0)=NaN;
        SpectreSaline_REM_first_mean_norm(i,:)= SpectreSaline_REM_first_mean(i,:)./nanmean(SpectreSaline_REM_first_mean(i,:)); SpectreSaline_REM_first_mean(SpectreSaline_REM_first_mean==0)=NaN;
        
        SpectreSaline_Wake_mid_mean_norm(i,:)= SpectreSaline_Wake_mid_mean(i,:)./nanmean(SpectreSaline_Wake_mid_mean(i,:)); SpectreSaline_Wake_mid_mean(SpectreSaline_Wake_mid_mean==0)=NaN;
        SpectreSaline_SWS_mid_mean_norm(i,:)= SpectreSaline_SWS_mid_mean(i,:)./nanmean(SpectreSaline_SWS_mid_mean(i,:)); SpectreSaline_SWS_mid_mean(SpectreSaline_SWS_mid_mean==0)=NaN;
        SpectreSaline_REM_mid_mean_norm(i,:)= SpectreSaline_REM_mid_mean(i,:)./nanmean(SpectreSaline_REM_mid_mean(i,:)); SpectreSaline_REM_mid_mean(SpectreSaline_REM_mid_mean==0)=NaN;
        
        SpectreSaline_Wake_late_mean_norm(i,:)= SpectreSaline_Wake_late_mean(i,:)./nanmean(SpectreSaline_Wake_late_mean(i,:)); SpectreSaline_Wake_late_mean(SpectreSaline_Wake_late_mean==0)=NaN;
        SpectreSaline_SWS_late_mean_norm(i,:)= SpectreSaline_SWS_late_mean(i,:)./nanmean(SpectreSaline_SWS_late_mean(i,:)); SpectreSaline_SWS_AfterInj__3h_mean(SpectreSaline_SWS_late_mean==0)=NaN;
        SpectreSaline_REM_late_mean_norm(i,:)= SpectreSaline_REM_late_mean(i,:)./nanmean(SpectreSaline_REM_late_mean(i,:)); SpectreSaline_REM_late_mean(SpectreSaline_REM_late_mean==0)=NaN;
    else
    end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SEM_norm saline
SpectreSaline_Wake_first_SEM_norm = nanstd(SpectreSaline_Wake_first_mean_norm)/sqrt(size(SpectreSaline_Wake_first_mean_norm,1));
SpectreSaline_SWS_first_SEM_norm = nanstd(SpectreSaline_SWS_first_mean_norm)/sqrt(size(SpectreSaline_SWS_first_mean_norm,1));
SpectreSaline_REM_first_SEM_norm = nanstd(SpectreSaline_REM_first_mean_norm)/sqrt(size(SpectreSaline_REM_first_mean_norm,1));

SpectreSaline_Wake_mid_SEM_norm = nanstd(SpectreSaline_Wake_mid_mean_norm)/sqrt(size(SpectreSaline_Wake_mid_mean_norm,1));
SpectreSaline_SWS_mid_SEM_norm = nanstd(SpectreSaline_SWS_mid_mean_norm)/sqrt(size(SpectreSaline_SWS_mid_mean_norm,1));
SpectreSaline_REM_mid_SEM_norm = nanstd(SpectreSaline_REM_mid_mean_norm)/sqrt(size(SpectreSaline_REM_mid_mean_norm,1));

SpectreSaline_Wake_late_SEM_norm = nanstd(SpectreSaline_Wake_late_mean_norm)/sqrt(size(SpectreSaline_Wake_late_mean_norm,1));
SpectreSaline_SWS_late_SEM_norm = nanstd(SpectreSaline_SWS_late_mean_norm)/sqrt(size(SpectreSaline_SWS_late_mean_norm,1));
SpectreSaline_REM_late_SEM_norm = nanstd(SpectreSaline_REM_late_mean_norm)/sqrt(size(SpectreSaline_REM_late_mean_norm,1));


%%
% mean CNO
for j=1:length(sp_cno)
    try
    if isempty(sp_cno{j})==0        
        SpectreCNO_Wake_first_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_early_cno{j},c{j}.Wake)))),1); SpectreCNO_Wake_first_mean(SpectreCNO_Wake_first_mean==0)=NaN;
        SpectreCNO_SWS_first_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_early_cno{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_first_mean(SpectreCNO_SWS_first_mean==0)=NaN;
        SpectreCNO_REM_first_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_early_cno{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_first_mean(SpectreCNO_REM_first_mean==0)=NaN;
        
        SpectreCNO_Wake_mid_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_mid_cno{j},c{j}.Wake)))),1); SpectreCNO_Wake_mid_mean(SpectreCNO_Wake_mid_mean==0)=NaN;
        SpectreCNO_SWS_mid_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_mid_cno{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_mid_mean(SpectreCNO_SWS_mid_mean==0)=NaN;
        SpectreCNO_REM_mid_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_mid_cno{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_mid_mean(SpectreCNO_REM_mid_mean==0)=NaN;
        
        SpectreCNO_Wake_late_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_late_cno{j},c{j}.Wake)))),1); SpectreCNO_Wake_late_mean(SpectreCNO_Wake_late_mean==0)=NaN;
        SpectreCNO_SWS_late_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_late_cno{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_AfterInj__3h_mean(SpectreCNO_SWS_late_mean==0)=NaN;
        SpectreCNO_REM_late_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_late_cno{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_late_mean(SpectreCNO_REM_late_mean==0)=NaN;
    else
    end
    end
end



% sem CNO
SpectreCNO_Wake_first_SEM = nanstd(SpectreCNO_Wake_first_mean)/sqrt(size(SpectreCNO_Wake_first_mean,1));
SpectreCNO_SWS_first_SEM = nanstd(SpectreCNO_SWS_first_mean)/sqrt(size(SpectreCNO_SWS_first_mean,1));
SpectreCNO_REM_first_SEM = nanstd(SpectreCNO_REM_first_mean)/sqrt(size(SpectreCNO_REM_first_mean,1));

SpectreCNO_Wake_mid_SEM = nanstd(SpectreCNO_Wake_mid_mean)/sqrt(size(SpectreCNO_Wake_mid_mean,1));
SpectreCNO_SWS_mid_SEM = nanstd(SpectreCNO_SWS_mid_mean)/sqrt(size(SpectreCNO_SWS_mid_mean,1));
SpectreCNO_REM_mid_SEM = nanstd(SpectreCNO_REM_mid_mean)/sqrt(size(SpectreCNO_REM_mid_mean,1));

SpectreCNO_Wake_late_SEM = nanstd(SpectreCNO_Wake_late_mean)/sqrt(size(SpectreCNO_Wake_late_mean,1));
SpectreCNO_SWS_late_SEM = nanstd(SpectreCNO_SWS_late_mean)/sqrt(size(SpectreCNO_SWS_late_mean,1));
SpectreCNO_REM_late_SEM = nanstd(SpectreCNO_REM_late_mean)/sqrt(size(SpectreCNO_REM_late_mean,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(sp_cno)
    try
    if isempty(sp_cno{j})==0        
        SpectreCNO_Wake_first_mean_norm(j,:)= SpectreCNO_Wake_first_mean(j,:)./nanmean(SpectreCNO_Wake_first_mean(j,:)); SpectreCNO_Wake_first_mean(SpectreCNO_Wake_first_mean==0)=NaN;
        SpectreCNO_SWS_first_mean_norm(j,:)= SpectreCNO_SWS_first_mean(j,:)./nanmean(SpectreCNO_SWS_first_mean(j,:)); SpectreCNO_SWS_first_mean(SpectreCNO_SWS_first_mean==0)=NaN;
        SpectreCNO_REM_first_mean_norm(j,:)= SpectreCNO_REM_first_mean(j,:)./nanmean(SpectreCNO_REM_first_mean(j,:)); SpectreCNO_REM_first_mean(SpectreCNO_REM_first_mean==0)=NaN;
        
        SpectreCNO_Wake_mid_mean_norm(j,:)= SpectreCNO_Wake_mid_mean(j,:)./nanmean(SpectreCNO_Wake_mid_mean(j,:)); SpectreCNO_Wake_mid_mean(SpectreCNO_Wake_mid_mean==0)=NaN;
        SpectreCNO_SWS_mid_mean_norm(j,:)= SpectreCNO_SWS_mid_mean(j,:)./nanmean(SpectreCNO_SWS_mid_mean(j,:)); SpectreCNO_SWS_mid_mean(SpectreCNO_SWS_mid_mean==0)=NaN;
        SpectreCNO_REM_mid_mean_norm(j,:)= SpectreCNO_REM_mid_mean(j,:)./nanmean(SpectreCNO_REM_mid_mean(j,:)); SpectreCNO_REM_mid_mean(SpectreCNO_REM_mid_mean==0)=NaN;
        
        SpectreCNO_Wake_late_mean_norm(j,:)= SpectreCNO_Wake_late_mean(j,:)./nanmean(SpectreCNO_Wake_late_mean(j,:)); SpectreCNO_Wake_late_mean(SpectreCNO_Wake_late_mean==0)=NaN;
        SpectreCNO_SWS_late_mean_norm(j,:)= SpectreCNO_SWS_late_mean(j,:)./nanmean(SpectreCNO_SWS_late_mean(j,:)); SpectreCNO_SWS_AfterInj__3h_mean(SpectreCNO_SWS_late_mean==0)=NaN;
        SpectreCNO_REM_late_mean_norm(j,:)= SpectreCNO_REM_late_mean(j,:)./nanmean(SpectreCNO_REM_late_mean(j,:)); SpectreCNO_REM_late_mean(SpectreCNO_REM_late_mean==0)=NaN;
    else
    end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SEM_norm CNO
SpectreCNO_Wake_first_SEM_norm = nanstd(SpectreCNO_Wake_first_mean_norm)/sqrt(size(SpectreCNO_Wake_first_mean_norm,1));
SpectreCNO_SWS_first_SEM_norm = nanstd(SpectreCNO_SWS_first_mean_norm)/sqrt(size(SpectreCNO_SWS_first_mean_norm,1));
SpectreCNO_REM_first_SEM_norm = nanstd(SpectreCNO_REM_first_mean_norm)/sqrt(size(SpectreCNO_REM_first_mean_norm,1));

SpectreCNO_Wake_mid_SEM_norm = nanstd(SpectreCNO_Wake_mid_mean_norm)/sqrt(size(SpectreCNO_Wake_mid_mean_norm,1));
SpectreCNO_SWS_mid_SEM_norm = nanstd(SpectreCNO_SWS_mid_mean_norm)/sqrt(size(SpectreCNO_SWS_mid_mean_norm,1));
SpectreCNO_REM_mid_SEM_norm = nanstd(SpectreCNO_REM_mid_mean_norm)/sqrt(size(SpectreCNO_REM_mid_mean_norm,1));

SpectreCNO_Wake_late_SEM_norm = nanstd(SpectreCNO_Wake_late_mean_norm)/sqrt(size(SpectreCNO_Wake_late_mean_norm,1));
SpectreCNO_SWS_late_SEM_norm = nanstd(SpectreCNO_SWS_late_mean_norm)/sqrt(size(SpectreCNO_SWS_late_mean_norm,1));
SpectreCNO_REM_late_SEM_norm = nanstd(SpectreCNO_REM_late_mean_norm)/sqrt(size(SpectreCNO_REM_late_mean_norm,1));

%% figures
% to get figures with normalisation run : atropine_spectral_analysis_figures_norm_MC

%%
figure,
ax(1)=subplot(4,6,7), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'r',1);
ylabel('Power (a.u)')
title('WAKE pre')
makepretty
ax(2)=subplot(4,6,8), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_first_mean), SpectreSaline_SWS_first_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_first_mean), SpectreCNO_SWS_first_SEM,'r',1);
title('NREM pre')
makepretty
ax(3)=subplot(4,6,9), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_first_mean), SpectreSaline_REM_first_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_first_mean), SpectreCNO_REM_first_SEM,'r',1);
title('REM pre')
makepretty

ax(4)=subplot(4,6,13), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'r',1);
title('WAKE post')
ylabel('Power (a.u)')
makepretty
ax(5)=subplot(4,6,14), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_mid_mean), SpectreSaline_SWS_mid_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_mid_mean), SpectreCNO_SWS_mid_SEM,'r',1);
title('NREM post')
makepretty
ax(6)=subplot(4,6,15), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_mid_mean), SpectreSaline_REM_mid_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_mid_mean), SpectreCNO_REM_mid_SEM,'r',1);
title('REM post')
makepretty

ax(7)=subplot(4,6,19), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_late_mean), SpectreSaline_Wake_late_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_late_mean), SpectreCNO_Wake_late_SEM,'r',1);
title('WAKE 3h post')
xlabel('Frequency(Hz)')
ylabel('Power (a.u)')
makepretty
ax(8)=subplot(4,6,20), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_late_mean), SpectreSaline_SWS_late_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_late_mean), SpectreCNO_SWS_late_SEM,'r',1);
xlabel('Frequency(Hz)')
title('NREM 3h post')
makepretty
ax(9)=subplot(4,6,21), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_late_mean), SpectreSaline_REM_late_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_late_mean), SpectreCNO_REM_late_SEM,'r',1);
xlabel('Frequency(Hz)')
title('REM 3h post')
makepretty

ax(10)=subplot(4,6,4), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_first_mean), SpectreSaline_SWS_first_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_first_mean), SpectreSaline_REM_first_SEM,'r',1);
title('pre saline')
makepretty

ax(11)=subplot(4,6,5), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_mid_mean), SpectreSaline_SWS_mid_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_mid_mean), SpectreSaline_REM_mid_SEM,'r',1);
title('post saline')
makepretty

ax(12)=subplot(4,6,6), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_late_mean), SpectreSaline_Wake_late_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_late_mean), SpectreSaline_SWS_late_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_late_mean), SpectreSaline_REM_late_SEM,'r',1);
title('3h post saline')
makepretty


ax(13)=subplot(4,6,10), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_first_mean), SpectreCNO_SWS_first_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_first_mean), SpectreCNO_REM_first_SEM,'r',1);
title('pre CNO')
makepretty

ax(14)=subplot(4,6,11), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_mid_mean), SpectreCNO_SWS_mid_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_mid_mean), SpectreCNO_REM_mid_SEM,'r',1);
title('post CNO')
makepretty

ax(15)=subplot(4,6,12), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_late_mean), SpectreCNO_Wake_late_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_late_mean), SpectreCNO_SWS_late_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_late_mean), SpectreCNO_REM_late_SEM,'r',1);
title('3h post CNO')
makepretty


ax(16)=subplot(4,6,16),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k:',1);hold on
% shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1);
s1=shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_late_mean), SpectreSaline_Wake_late_SEM,'k',1);
title('WAKE- saline')
makepretty
%sws saline
ax(17)=subplot(4,6,17),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_first_mean), SpectreSaline_SWS_first_SEM,'b:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_mid_mean), SpectreSaline_SWS_mid_SEM,'b',1);
 shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_late_mean), SpectreSaline_SWS_late_SEM,'b',1);
 title('NREM - saline')
makepretty
% rem saline
ax(18)=subplot(4,6,18), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_first_mean), SpectreSaline_REM_first_SEM,'r:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_mid_mean), SpectreSaline_REM_mid_SEM,'r',1);
  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_late_mean), SpectreSaline_REM_late_SEM,'r',1);
  title('REM - saline')
makepretty
%wake cno
ax(19)=subplot(4,6,22),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'k:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'k',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_late_mean), SpectreCNO_Wake_late_SEM,'k',1);
title('WAKE - CNO')
makepretty
xlabel('Frequency (Hz)')
%sws cno
ax(20)=subplot(4,6,23),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_first_mean), SpectreCNO_SWS_first_SEM,'b:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj__all_mean), SpectreCNO_SWS_mid_SEM,'b',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_late_mean), SpectreCNO_SWS_late_SEM,'b',1);
title('NREM - CNO')
makepretty
xlabel('Frequency (Hz)')
%rem cno
ax(21)=subplot(4,6,24),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_first_mean), SpectreCNO_REM_first_SEM,'r:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_mid_mean), SpectreCNO_REM_mid_SEM,'r',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_late_mean), SpectreCNO_REM_late_SEM,'r',1);
makepretty
title('REM - CNO')
xlabel('Frequency (Hz)')

set(ax,'xlim',[0 15], 'ylim',[0 1e6])
% set(ax,'xlim',[20 100], 'ylim',[0 1e5])




%% pre vs post
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_first_mean), SpectreSaline_SWS_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_mid_mean), SpectreSaline_SWS_mid_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_first_mean), SpectreSaline_REM_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_mid_mean), SpectreSaline_REM_mid_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(234)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_first_mean), SpectreCNO_SWS_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_mid_mean), SpectreCNO_SWS_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_first_mean), SpectreCNO_REM_first_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_mid_mean), SpectreCNO_REM_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty



%% sal vs atropine
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_first_mean), SpectreSaline_SWS_first_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_first_mean), SpectreCNO_SWS_first_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_first_mean), SpectreSaline_REM_first_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_first_mean), SpectreCNO_REM_first_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


subplot(234)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_mid_mean), SpectreSaline_SWS_mid_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_mid_mean), SpectreCNO_SWS_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_mid_mean), SpectreSaline_REM_mid_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_mid_mean), SpectreCNO_REM_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty




%% wake high/low movement
figure
subplot(2,6,[1,2,7,8])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_first_mean), SpectreSaline_Wake_first_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_first_mean), SpectreCNO_Wake_first_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake pre')


subplot(2,6,[4,5,10,11])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_mid_mean), SpectreSaline_Wake_mid_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_mid_mean), SpectreCNO_Wake_mid_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake')



%% individual trace

figure
subplot(2,6,[1,2,7,8])
s = plot(frq_sal{1},  (SpectreSaline_Wake_first_mean),'k');hold on
s = plot(frq_cno{1},  (SpectreCNO_Wake_first_mean),'g');hold on
makepretty
xlim([20 100])
title('Wake pre')

subplot(2,6,[4,5,10,11])
s = plot(frq_sal{1},  (SpectreSaline_Wake_mid_mean),'k'); hold on
s = plot(frq_cno{1},  (SpectreCNO_Wake_mid_mean),'g');
makepretty
xlim([20 100])
title('Wake')

