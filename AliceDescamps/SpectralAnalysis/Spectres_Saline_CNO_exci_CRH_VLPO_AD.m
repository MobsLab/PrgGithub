%% Input Dir exci DREADD
DirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
DirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');

%%
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('H_Low_Spectrum.mat');
spectro = 'H_Low_Spectrum.mat';

%% parameters
en_epoch_preInj = 1.5*1E8;%%1.4
st_epoch_postInj = 1.65*1E8;

%% get the data
% saline condition
for i= i1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %period of time
    durtotal_saline{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %prenjection
    epoch_PreInj_saline{i} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_saline_all{i} = intervalSet(st_epoch_postInj,durtotal_saline{i});
    epoch_PostInj_saline_3h{i} = intervalSet(st_epoch_postInj,st_epoch_postInj+2*3600*1e4);

       
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
    %period of time
    durtotal_cno{j} = max([max(End(c{j}.Wake)),max(End(c{j}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno{j} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_cno_all{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
    epoch_PostInj_cno_3h{j} = intervalSet(st_epoch_postInj,st_epoch_postInj+2*3600*1e4);
        
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
    SpectreSaline_Wake_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.REMEpoch)))),1);

    SpectreSaline_Wake_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.REMEpoch)))),1);
       
    SpectreSaline_Wake_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.REMEpoch)))),1);
   
    % for wake with high/low activity
    SpectreSaline_WakeLowMov_Before_mean(i,:) =  nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},and(a{i}.Wake,lowMov_sal{i}))))),1);
    SpectreSaline_WakeLowMov_After_mean(i,:) =  nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},and(a{i}.Wake,lowMov_sal{i}))))),1);
    SpectreSaline_WakeHighMov_Before_mean(i,:) =  nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},and(a{i}.Wake,highMov_sal{i}))))),1);
    SpectreSaline_WakeHighMov_After_mean(i,:) =  nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},and(a{i}.Wake,highMov_sal{i}))))),1);
    end 
end

% sem saline
SpectreSaline_Wake_BeforeInj_SEM = nanstd(SpectreSaline_Wake_BeforeInj_mean)/sqrt(size(SpectreSaline_Wake_BeforeInj_mean,1));
SpectreSaline_SWS_BeforeInj_SEM = nanstd(SpectreSaline_SWS_BeforeInj_mean)/sqrt(size(SpectreSaline_SWS_BeforeInj_mean,1));
SpectreSaline_REM_BeforeInj_SEM = nanstd(SpectreSaline_REM_BeforeInj_mean)/sqrt(size(SpectreSaline_REM_BeforeInj_mean,1));

SpectreSaline_Wake_AfterInj_all_SEM = nanstd(SpectreSaline_Wake_AfterInj_all_mean)/sqrt(size(SpectreSaline_Wake_AfterInj_all_mean,1));
SpectreSaline_SWS_AfterInj_all_SEM = nanstd(SpectreSaline_SWS_AfterInj_all_mean)/sqrt(size(SpectreSaline_SWS_AfterInj_all_mean,1));
SpectreSaline_REM_AfterInj_all_SEM = nanstd(SpectreSaline_REM_AfterInj_all_mean)/sqrt(size(SpectreSaline_REM_AfterInj_all_mean,1));

SpectreSaline_Wake_AfterInj_3h_SEM = nanstd(SpectreSaline_Wake_AfterInj_3h_mean)/sqrt(size(SpectreSaline_Wake_AfterInj_3h_mean,1));
SpectreSaline_SWS_AfterInj_3h_SEM = nanstd(SpectreSaline_SWS_AfterInj_3h_mean)/sqrt(size(SpectreSaline_SWS_AfterInj_3h_mean,1));
SpectreSaline_REM_AfterInj_3h_SEM = nanstd(SpectreSaline_REM_AfterInj_3h_mean)/sqrt(size(SpectreSaline_REM_AfterInj_3h_mean,1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on mean spectrum
for i=1:length(sp_sal)
    try 
    if isempty(sp_sal{i})==0        
        SpectreSaline_Wake_BeforeInj_mean_norm(i,:)= SpectreSaline_Wake_BeforeInj_mean(i,:)./nanmean(SpectreSaline_Wake_BeforeInj_mean(i,:)); SpectreSaline_Wake_BeforeInj_mean(SpectreSaline_Wake_BeforeInj_mean==0)=NaN;
        SpectreSaline_SWS_BeforeInj_mean_norm(i,:)= SpectreSaline_SWS_BeforeInj_mean(i,:)./nanmean(SpectreSaline_SWS_BeforeInj_mean(i,:)); SpectreSaline_SWS_BeforeInj_mean(SpectreSaline_SWS_BeforeInj_mean==0)=NaN;
        SpectreSaline_REM_BeforeInj_mean_norm(i,:)= SpectreSaline_REM_BeforeInj_mean(i,:)./nanmean(SpectreSaline_REM_BeforeInj_mean(i,:)); SpectreSaline_REM_BeforeInj_mean(SpectreSaline_REM_BeforeInj_mean==0)=NaN;
        
        SpectreSaline_Wake_AfterInj_all_mean_norm(i,:)= SpectreSaline_Wake_AfterInj_all_mean(i,:)./nanmean(SpectreSaline_Wake_AfterInj_all_mean(i,:)); SpectreSaline_Wake_AfterInj_all_mean(SpectreSaline_Wake_AfterInj_all_mean==0)=NaN;
        SpectreSaline_SWS_AfterInj_all_mean_norm(i,:)= SpectreSaline_SWS_AfterInj_all_mean(i,:)./nanmean(SpectreSaline_SWS_AfterInj_all_mean(i,:)); SpectreSaline_SWS_AfterInj_all_mean(SpectreSaline_SWS_AfterInj_all_mean==0)=NaN;
        SpectreSaline_REM_AfterInj_all_mean_norm(i,:)= SpectreSaline_REM_AfterInj_all_mean(i,:)./nanmean(SpectreSaline_REM_AfterInj_all_mean(i,:)); SpectreSaline_REM_AfterInj_all_mean(SpectreSaline_REM_AfterInj_all_mean==0)=NaN;
        
        SpectreSaline_Wake_AfterInj_3h_mean_norm(i,:)= SpectreSaline_Wake_AfterInj_3h_mean(i,:)./nanmean(SpectreSaline_Wake_AfterInj_3h_mean(i,:)); SpectreSaline_Wake_AfterInj_3h_mean(SpectreSaline_Wake_AfterInj_3h_mean==0)=NaN;
        SpectreSaline_SWS_AfterInj_3h_mean_norm(i,:)= SpectreSaline_SWS_AfterInj_3h_mean(i,:)./nanmean(SpectreSaline_SWS_AfterInj_3h_mean(i,:)); SpectreSaline_SWS_AfterInj__3h_mean(SpectreSaline_SWS_AfterInj_3h_mean==0)=NaN;
        SpectreSaline_REM_AfterInj_3h_mean_norm(i,:)= SpectreSaline_REM_AfterInj_3h_mean(i,:)./nanmean(SpectreSaline_REM_AfterInj_3h_mean(i,:)); SpectreSaline_REM_AfterInj_3h_mean(SpectreSaline_REM_AfterInj_3h_mean==0)=NaN;
    else
    end
    end
end

%normalisation on max
for i=1:length(sp_sal)
    try 
    if isempty(sp_sal{i})==0        
        SpectreSaline_Wake_BeforeInj_max_norm(i,:)= SpectreSaline_Wake_BeforeInj_mean(i,:)./max(SpectreSaline_Wake_BeforeInj_mean(i,:)); SpectreSaline_Wake_BeforeInj_mean(SpectreSaline_Wake_BeforeInj_mean==0)=NaN;
        SpectreSaline_SWS_BeforeInj_max_norm(i,:)= SpectreSaline_SWS_BeforeInj_mean(i,:)./max(SpectreSaline_SWS_BeforeInj_mean(i,:)); SpectreSaline_SWS_BeforeInj_mean(SpectreSaline_SWS_BeforeInj_mean==0)=NaN;
        SpectreSaline_REM_BeforeInj_max_norm(i,:)= SpectreSaline_REM_BeforeInj_mean(i,:)./max(SpectreSaline_REM_BeforeInj_mean(i,:)); SpectreSaline_REM_BeforeInj_mean(SpectreSaline_REM_BeforeInj_mean==0)=NaN;
        
        SpectreSaline_Wake_AfterInj_all_max_norm(i,:)= SpectreSaline_Wake_AfterInj_all_mean(i,:)./max(SpectreSaline_Wake_AfterInj_all_mean(i,:)); SpectreSaline_Wake_AfterInj_all_mean(SpectreSaline_Wake_AfterInj_all_mean==0)=NaN;
        SpectreSaline_SWS_AfterInj_all_max_norm(i,:)= SpectreSaline_SWS_AfterInj_all_mean(i,:)./max(SpectreSaline_SWS_AfterInj_all_mean(i,:)); SpectreSaline_SWS_AfterInj_all_mean(SpectreSaline_SWS_AfterInj_all_mean==0)=NaN;
        SpectreSaline_REM_AfterInj_all_max_norm(i,:)= SpectreSaline_REM_AfterInj_all_mean(i,:)./max(SpectreSaline_REM_AfterInj_all_mean(i,:)); SpectreSaline_REM_AfterInj_all_mean(SpectreSaline_REM_AfterInj_all_mean==0)=NaN;
        
        SpectreSaline_Wake_AfterInj_3h_max_norm(i,:)= SpectreSaline_Wake_AfterInj_3h_mean(i,:)./max(SpectreSaline_Wake_AfterInj_3h_mean(i,:)); SpectreSaline_Wake_AfterInj_3h_mean(SpectreSaline_Wake_AfterInj_3h_mean==0)=NaN;
        SpectreSaline_SWS_AfterInj_3h_max_norm(i,:)= SpectreSaline_SWS_AfterInj_3h_mean(i,:)./max(SpectreSaline_SWS_AfterInj_3h_mean(i,:)); SpectreSaline_SWS_AfterInj__3h_mean(SpectreSaline_SWS_AfterInj_3h_mean==0)=NaN;
        SpectreSaline_REM_AfterInj_3h_max_norm(i,:)= SpectreSaline_REM_AfterInj_3h_mean(i,:)./max(SpectreSaline_REM_AfterInj_3h_mean(i,:)); SpectreSaline_REM_AfterInj_3h_mean(SpectreSaline_REM_AfterInj_3h_mean==0)=NaN;
    else
    end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SEM_mean_norm saline
SpectreSaline_Wake_BeforeInj_SEM_norm = nanstd(SpectreSaline_Wake_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_Wake_BeforeInj_mean_norm,1));
SpectreSaline_SWS_BeforeInj_SEM_norm = nanstd(SpectreSaline_SWS_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_SWS_BeforeInj_mean_norm,1));
SpectreSaline_REM_BeforeInj_SEM_norm = nanstd(SpectreSaline_REM_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_REM_BeforeInj_mean_norm,1));

SpectreSaline_Wake_AfterInj_all_SEM_norm = nanstd(SpectreSaline_Wake_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_all_mean_norm,1));
SpectreSaline_SWS_AfterInj_all_SEM_norm = nanstd(SpectreSaline_SWS_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_all_mean_norm,1));
SpectreSaline_REM_AfterInj_all_SEM_norm = nanstd(SpectreSaline_REM_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_REM_AfterInj_all_mean_norm,1));

SpectreSaline_Wake_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_Wake_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_3h_mean_norm,1));
SpectreSaline_SWS_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_SWS_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_3h_mean_norm,1));
SpectreSaline_REM_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_REM_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_REM_AfterInj_3h_mean_norm,1));

% SEM_max_norm saline
SpectreSaline_Wake_BeforeInj_SEM_max_norm = nanstd(SpectreSaline_Wake_BeforeInj_max_norm)/sqrt(size(SpectreSaline_Wake_BeforeInj_max_norm,1));
SpectreSaline_SWS_BeforeInj_SEM_max_norm = nanstd(SpectreSaline_SWS_BeforeInj_max_norm)/sqrt(size(SpectreSaline_SWS_BeforeInj_max_norm,1));
SpectreSaline_REM_BeforeInj_SEM_max_norm = nanstd(SpectreSaline_REM_BeforeInj_max_norm)/sqrt(size(SpectreSaline_REM_BeforeInj_max_norm,1));

SpectreSaline_Wake_AfterInj_all_SEM_max_norm = nanstd(SpectreSaline_Wake_AfterInj_all_max_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_all_max_norm,1));
SpectreSaline_SWS_AfterInj_all_SEM_max_norm = nanstd(SpectreSaline_SWS_AfterInj_all_max_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_all_max_norm,1));
SpectreSaline_REM_AfterInj_all_SEM_max_norm = nanstd(SpectreSaline_REM_AfterInj_all_max_norm)/sqrt(size(SpectreSaline_REM_AfterInj_all_max_norm,1));

SpectreSaline_Wake_AfterInj_3h_SEM_max_norm = nanstd(SpectreSaline_Wake_AfterInj_3h_max_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_3h_max_norm,1));
SpectreSaline_SWS_AfterInj_3h_SEM_max_norm = nanstd(SpectreSaline_SWS_AfterInj_3h_max_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_3h_max_norm,1));
SpectreSaline_REM_AfterInj_3h_SEM_max_norm = nanstd(SpectreSaline_REM_AfterInj_3h_max_norm)/sqrt(size(SpectreSaline_REM_AfterInj_3h_max_norm,1));




%%
% mean CNO
for j=1:length(sp_cno)
    try
    if isempty(sp_cno{j})==0        
        SpectreCNO_Wake_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.Wake)))),1); SpectreCNO_Wake_BeforeInj_mean(SpectreCNO_Wake_BeforeInj_mean==0)=NaN;
        SpectreCNO_SWS_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_BeforeInj_mean(SpectreCNO_SWS_BeforeInj_mean==0)=NaN;
        SpectreCNO_REM_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_BeforeInj_mean(SpectreCNO_REM_BeforeInj_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.Wake)))),1); SpectreCNO_Wake_AfterInj_all_mean(SpectreCNO_Wake_AfterInj_all_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_AfterInj_all_mean(SpectreCNO_SWS_AfterInj_all_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_AfterInj_all_mean(SpectreCNO_REM_AfterInj_all_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.Wake)))),1); SpectreCNO_Wake_AfterInj_3h_mean(SpectreCNO_Wake_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_AfterInj__3h_mean(SpectreCNO_SWS_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_AfterInj_3h_mean(SpectreCNO_REM_AfterInj_3h_mean==0)=NaN;
    else
    end
    end
end



% sem CNO
SpectreCNO_Wake_BeforeInj_SEM = nanstd(SpectreCNO_Wake_BeforeInj_mean)/sqrt(size(SpectreCNO_Wake_BeforeInj_mean,1));
SpectreCNO_SWS_BeforeInj_SEM = nanstd(SpectreCNO_SWS_BeforeInj_mean)/sqrt(size(SpectreCNO_SWS_BeforeInj_mean,1));
SpectreCNO_REM_BeforeInj_SEM = nanstd(SpectreCNO_REM_BeforeInj_mean)/sqrt(size(SpectreCNO_REM_BeforeInj_mean,1));

SpectreCNO_Wake_AfterInj_all_SEM = nanstd(SpectreCNO_Wake_AfterInj_all_mean)/sqrt(size(SpectreCNO_Wake_AfterInj_all_mean,1));
SpectreCNO_SWS_AfterInj_all_SEM = nanstd(SpectreCNO_SWS_AfterInj_all_mean)/sqrt(size(SpectreCNO_SWS_AfterInj_all_mean,1));
SpectreCNO_REM_AfterInj_all_SEM = nanstd(SpectreCNO_REM_AfterInj_all_mean)/sqrt(size(SpectreCNO_REM_AfterInj_all_mean,1));

SpectreCNO_Wake_AfterInj_3h_SEM = nanstd(SpectreCNO_Wake_AfterInj_3h_mean)/sqrt(size(SpectreCNO_Wake_AfterInj_3h_mean,1));
SpectreCNO_SWS_AfterInj_3h_SEM = nanstd(SpectreCNO_SWS_AfterInj_3h_mean)/sqrt(size(SpectreCNO_SWS_AfterInj_3h_mean,1));
SpectreCNO_REM_AfterInj_3h_SEM = nanstd(SpectreCNO_REM_AfterInj_3h_mean)/sqrt(size(SpectreCNO_REM_AfterInj_3h_mean,1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on mean spectrum
for j=1:length(sp_cno)
    try
    if isempty(sp_cno{j})==0        
        SpectreCNO_Wake_BeforeInj_mean_norm(j,:)= SpectreCNO_Wake_BeforeInj_mean(j,:)./nanmean(SpectreCNO_Wake_BeforeInj_mean(j,:)); SpectreCNO_Wake_BeforeInj_mean(SpectreCNO_Wake_BeforeInj_mean==0)=NaN;
        SpectreCNO_SWS_BeforeInj_mean_norm(j,:)= SpectreCNO_SWS_BeforeInj_mean(j,:)./nanmean(SpectreCNO_SWS_BeforeInj_mean(j,:)); SpectreCNO_SWS_BeforeInj_mean(SpectreCNO_SWS_BeforeInj_mean==0)=NaN;
        SpectreCNO_REM_BeforeInj_mean_norm(j,:)= SpectreCNO_REM_BeforeInj_mean(j,:)./nanmean(SpectreCNO_REM_BeforeInj_mean(j,:)); SpectreCNO_REM_BeforeInj_mean(SpectreCNO_REM_BeforeInj_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_all_mean_norm(j,:)= SpectreCNO_Wake_AfterInj_all_mean(j,:)./nanmean(SpectreCNO_Wake_AfterInj_all_mean(j,:)); SpectreCNO_Wake_AfterInj_all_mean(SpectreCNO_Wake_AfterInj_all_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_all_mean_norm(j,:)= SpectreCNO_SWS_AfterInj_all_mean(j,:)./nanmean(SpectreCNO_SWS_AfterInj_all_mean(j,:)); SpectreCNO_SWS_AfterInj_all_mean(SpectreCNO_SWS_AfterInj_all_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_all_mean_norm(j,:)= SpectreCNO_REM_AfterInj_all_mean(j,:)./nanmean(SpectreCNO_REM_AfterInj_all_mean(j,:)); SpectreCNO_REM_AfterInj_all_mean(SpectreCNO_REM_AfterInj_all_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_3h_mean_norm(j,:)= SpectreCNO_Wake_AfterInj_3h_mean(j,:)./nanmean(SpectreCNO_Wake_AfterInj_3h_mean(j,:)); SpectreCNO_Wake_AfterInj_3h_mean(SpectreCNO_Wake_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_3h_mean_norm(j,:)= SpectreCNO_SWS_AfterInj_3h_mean(j,:)./nanmean(SpectreCNO_SWS_AfterInj_3h_mean(j,:)); SpectreCNO_SWS_AfterInj__3h_mean(SpectreCNO_SWS_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_3h_mean_norm(j,:)= SpectreCNO_REM_AfterInj_3h_mean(j,:)./nanmean(SpectreCNO_REM_AfterInj_3h_mean(j,:)); SpectreCNO_REM_AfterInj_3h_mean(SpectreCNO_REM_AfterInj_3h_mean==0)=NaN;
    else
    end
    end
end

% SEM_norm CNO
SpectreCNO_Wake_BeforeInj_SEM_norm = nanstd(SpectreCNO_Wake_BeforeInj_mean_norm)/sqrt(size(SpectreCNO_Wake_BeforeInj_mean_norm,1));
SpectreCNO_SWS_BeforeInj_SEM_norm = nanstd(SpectreCNO_SWS_BeforeInj_mean_norm)/sqrt(size(SpectreCNO_SWS_BeforeInj_mean_norm,1));
SpectreCNO_REM_BeforeInj_SEM_norm = nanstd(SpectreCNO_REM_BeforeInj_mean_norm)/sqrt(size(SpectreCNO_REM_BeforeInj_mean_norm,1));

SpectreCNO_Wake_AfterInj_all_SEM_norm = nanstd(SpectreCNO_Wake_AfterInj_all_mean_norm)/sqrt(size(SpectreCNO_Wake_AfterInj_all_mean_norm,1));
SpectreCNO_SWS_AfterInj_all_SEM_norm = nanstd(SpectreCNO_SWS_AfterInj_all_mean_norm)/sqrt(size(SpectreCNO_SWS_AfterInj_all_mean_norm,1));
SpectreCNO_REM_AfterInj_all_SEM_norm = nanstd(SpectreCNO_REM_AfterInj_all_mean_norm)/sqrt(size(SpectreCNO_REM_AfterInj_all_mean_norm,1));

SpectreCNO_Wake_AfterInj_3h_SEM_norm = nanstd(SpectreCNO_Wake_AfterInj_3h_mean_norm)/sqrt(size(SpectreCNO_Wake_AfterInj_3h_mean_norm,1));
SpectreCNO_SWS_AfterInj_3h_SEM_norm = nanstd(SpectreCNO_SWS_AfterInj_3h_mean_norm)/sqrt(size(SpectreCNO_SWS_AfterInj_3h_mean_norm,1));
SpectreCNO_REM_AfterInj_3h_SEM_norm = nanstd(SpectreCNO_REM_AfterInj_3h_mean_norm)/sqrt(size(SpectreCNO_REM_AfterInj_3h_mean_norm,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%normalisation on max spectrum
for j=1:length(sp_cno)
    try
    if isempty(sp_cno{j})==0        
        SpectreCNO_Wake_BeforeInj_max_norm(j,:)= SpectreCNO_Wake_BeforeInj_mean(j,:)./max(SpectreCNO_Wake_BeforeInj_mean(j,:)); SpectreCNO_Wake_BeforeInj_mean(SpectreCNO_Wake_BeforeInj_mean==0)=NaN;
        SpectreCNO_SWS_BeforeInj_max_norm(j,:)= SpectreCNO_SWS_BeforeInj_mean(j,:)./max(SpectreCNO_SWS_BeforeInj_mean(j,:)); SpectreCNO_SWS_BeforeInj_mean(SpectreCNO_SWS_BeforeInj_mean==0)=NaN;
        SpectreCNO_REM_BeforeInj_max_norm(j,:)= SpectreCNO_REM_BeforeInj_mean(j,:)./max(SpectreCNO_REM_BeforeInj_mean(j,:)); SpectreCNO_REM_BeforeInj_mean(SpectreCNO_REM_BeforeInj_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_all_max_norm(j,:)= SpectreCNO_Wake_AfterInj_all_mean(j,:)./max(SpectreCNO_Wake_AfterInj_all_mean(j,:)); SpectreCNO_Wake_AfterInj_all_mean(SpectreCNO_Wake_AfterInj_all_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_all_max_norm(j,:)= SpectreCNO_SWS_AfterInj_all_mean(j,:)./max(SpectreCNO_SWS_AfterInj_all_mean(j,:)); SpectreCNO_SWS_AfterInj_all_mean(SpectreCNO_SWS_AfterInj_all_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_all_max_norm(j,:)= SpectreCNO_REM_AfterInj_all_mean(j,:)./max(SpectreCNO_REM_AfterInj_all_mean(j,:)); SpectreCNO_REM_AfterInj_all_mean(SpectreCNO_REM_AfterInj_all_mean==0)=NaN;
        
        SpectreCNO_Wake_AfterInj_3h_max_norm(j,:)= SpectreCNO_Wake_AfterInj_3h_mean(j,:)./max(SpectreCNO_Wake_AfterInj_3h_mean(j,:)); SpectreCNO_Wake_AfterInj_3h_mean(SpectreCNO_Wake_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_SWS_AfterInj_3h_max_norm(j,:)= SpectreCNO_SWS_AfterInj_3h_mean(j,:)./max(SpectreCNO_SWS_AfterInj_3h_mean(j,:)); SpectreCNO_SWS_AfterInj_3h_mean(SpectreCNO_SWS_AfterInj_3h_mean==0)=NaN;
        SpectreCNO_REM_AfterInj_3h_max_norm(j,:)= SpectreCNO_REM_AfterInj_3h_mean(j,:)./max(SpectreCNO_REM_AfterInj_3h_mean(j,:)); SpectreCNO_REM_AfterInj_3h_mean(SpectreCNO_REM_AfterInj_3h_mean==0)=NaN;
    else
    end
    end
end

% SEM_max_norm CNO
SpectreCNO_Wake_BeforeInj_SEM_max_norm = nanstd(SpectreCNO_Wake_BeforeInj_max_norm)/sqrt(size(SpectreCNO_Wake_BeforeInj_max_norm,1));
SpectreCNO_SWS_BeforeInj_SEM_max_norm = nanstd(SpectreCNO_SWS_BeforeInj_max_norm)/sqrt(size(SpectreCNO_SWS_BeforeInj_max_norm,1));
SpectreCNO_REM_BeforeInj_SEM_max_norm = nanstd(SpectreCNO_REM_BeforeInj_max_norm)/sqrt(size(SpectreCNO_REM_BeforeInj_max_norm,1));

SpectreCNO_Wake_AfterInj_all_SEM_max_norm = nanstd(SpectreCNO_Wake_AfterInj_all_max_norm)/sqrt(size(SpectreCNO_Wake_AfterInj_all_max_norm,1));
SpectreCNO_SWS_AfterInj_all_SEM_max_norm = nanstd(SpectreCNO_SWS_AfterInj_all_max_norm)/sqrt(size(SpectreCNO_SWS_AfterInj_all_max_norm,1));
SpectreCNO_REM_AfterInj_all_SEM_max_norm = nanstd(SpectreCNO_REM_AfterInj_all_max_norm)/sqrt(size(SpectreCNO_REM_AfterInj_all_max_norm,1));

SpectreCNO_Wake_AfterInj_3h_SEM_max_norm = nanstd(SpectreCNO_Wake_AfterInj_3h_max_norm)/sqrt(size(SpectreCNO_Wake_AfterInj_3h_max_norm,1));
SpectreCNO_SWS_AfterInj_3h_SEM_max_norm = nanstd(SpectreCNO_SWS_AfterInj_3h_max_norm)/sqrt(size(SpectreCNO_SWS_AfterInj_3h_max_norm,1));
SpectreCNO_REM_AfterInj_3h_SEM_max_norm = nanstd(SpectreCNO_REM_AfterInj_3h_max_norm)/sqrt(size(SpectreCNO_REM_AfterInj_3h_max_norm,1));


%% figures
% to get figures
% every possible comparison : Figure_Spectres_Saline_CNO_exci_CRH_VLPO_AD.m
% with normalisation on mean run : Figure_Spectres_normalized_mean_Saline_CNO_exci_CRH_VLPO_AD.m
% with normalisation on max run : Figure_Spectres_normalized_max_Saline_CNO_exci_CRH_VLPO_AD.m

