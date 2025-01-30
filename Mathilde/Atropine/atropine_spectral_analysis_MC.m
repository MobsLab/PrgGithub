%% input dir ATROPINE
% Dir_dreadd=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% Dir_dreadd = RestrictPathForExperiment(Dir_dreadd,'nMice',[1245 1247 1248]);
% 
% dir1112 = PathForExperimentsAtropine_MC('BaselineSleep');
% dir1112 = RestrictPathForExperiment(dir1112,'nMice',[1105 1106 1107 1112]); 
% 
% DirSaline = MergePathForExperiment(dir1112,Dir_dreadd);


% DirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% 
% DirCNO = PathForExperimentsAtropine_MC('Atropine');


DirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106]); 
DirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1105 1106]); 

%%
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('H_Low_Spectrum.mat');
spectro = 'PFCx_deep_Low_Spectrum.mat';

%% parameters
en_epoch_preInj = 1.5*1E8;%%1.4
st_epoch_postInj = 1.65*1E8;

%% get the data
% saline condition
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %period of time
    durtotal_saline{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_saline{i} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_saline_all{i} = intervalSet(st_epoch_postInj,durtotal_saline{i});
    epoch_PostInj_saline_3h{i} = intervalSet(st_epoch_postInj,st_epoch_postInj+2*3600*1e4);

       
    try
        %threshold on speed to get period of high/low activity
        thresh_sal{i} = a{i}.Info.mov_threshold;
        b{i} = load('behavResources.mat', 'MovAcctsd');
        thresh_sal{i} = mean(Data(b{i}.MovAcctsd))+std(Data(b{i}.MovAcctsd));
        highMov_sal{i} = thresholdIntervals(b{i}.MovAcctsd, thresh_sal{i}, 'Direction', 'Above');
        lowMov_sal{i} = thresholdIntervals(b{i}.MovAcctsd, thresh_sal{i}, 'Direction', 'Below');
    
        [dur_highMov, durT_highMov] = DurationEpoch(and(and(a{i}.Wake,epoch_PreInj_saline{i}), highMov_sal{i}),'s');
        mean_duration_highMovEpoch_sal(i) = nanmean(dur_highMov);
        total_duration_highMovEpoch_sal(i) =durT_highMov;
        
        [dur_lowMov, durT_lowMov] = DurationEpoch(and(and(a{i}.Wake,epoch_PreInj_saline{i}), lowMov_sal{i}),'s');
        mean_duration_lowMovEpoch_sal(i) = nanmean(dur_lowMov);
        total_duration_lowMovEpoch_sal(i) =durT_lowMov;
    end 
        
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

        %threshold on speed to get period of high/low activity
        thresh_CNO{j} = c{j}.Info.mov_threshold;
        d{j} = load('behavResources.mat', 'MovAcctsd');
        thresh_CNO{j} = mean(Data(d{j}.MovAcctsd))+std(Data(d{j}.MovAcctsd));
        highMov_CNO{j} = thresholdIntervals(d{j}.MovAcctsd, thresh_CNO{j}, 'Direction', 'Above');
        lowMov_CNO{j} = thresholdIntervals(d{j}.MovAcctsd, thresh_CNO{j}, 'Direction', 'Below');
    
        
        
        [dur_highMov, durT_highMov] = DurationEpoch(and(and(c{j}.Wake,epoch_PreInj_cno{j}), highMov_CNO{j}),'s');
        mean_duration_highMovEpoch_CNO(j) = nanmean(dur_highMov);
        total_duration_highMovEpoch_CNO(j) =durT_highMov;
        
        [dur_lowMov, durT_lowMov] = DurationEpoch(and(and(c{j}.Wake,epoch_PreInj_cno{j}), lowMov_CNO{j}),'s');
        mean_duration_lowMovEpoch_CNO(j) = nanmean(dur_lowMov);
        total_duration_lowMovEpoch_CNO(j) =durT_lowMov;
        
        
        
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

% for wake with high/low activity
SpectreSaline_WakeLowMov_Before_SEM = nanstd(SpectreSaline_WakeLowMov_Before_mean)/sqrt(size(SpectreSaline_WakeLowMov_Before_mean,1));
SpectreSaline_WakeLowMov_After_SEM = nanstd(SpectreSaline_WakeLowMov_After_mean)/sqrt(size(SpectreSaline_WakeLowMov_After_mean,1));
SpectreSaline_WakeHighMov_Before_SEM = nanstd(SpectreSaline_WakeHighMov_Before_mean)/sqrt(size(SpectreSaline_WakeHighMov_Before_mean,1));
SpectreSaline_WakeHighMov_After_SEM = nanstd(SpectreSaline_WakeHighMov_After_mean)/sqrt(size(SpectreSaline_WakeHighMov_After_mean,1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    try 
    % for wake with high/low activity
    SpectreSaline_WakeLowMov_Before_mean_norm(i,:) =  SpectreSaline_WakeLowMov_Before_mean(i,:)./nanmean(SpectreSaline_WakeLowMov_Before_mean(i,:));
    SpectreSaline_WakeLowMov_After_mean_norm(i,:) =  SpectreSaline_WakeLowMov_After_mean(i,:)./nanmean(SpectreSaline_WakeLowMov_After_mean(i,:));
    SpectreSaline_WakeHighMov_Before_mean_norm(i,:) =  SpectreSaline_WakeHighMov_Before_mean(i,:)./nanmean(SpectreSaline_WakeHighMov_Before_mean(i,:));
    SpectreSaline_WakeHighMov_After_mean_norm(i,:) =  SpectreSaline_WakeHighMov_After_mean(i,:)./nanmean(SpectreSaline_WakeHighMov_After_mean(i,:));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SEM_norm saline
SpectreSaline_Wake_BeforeInj_SEM_norm = nanstd(SpectreSaline_Wake_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_Wake_BeforeInj_mean_norm,1));
SpectreSaline_SWS_BeforeInj_SEM_norm = nanstd(SpectreSaline_SWS_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_SWS_BeforeInj_mean_norm,1));
SpectreSaline_REM_BeforeInj_SEM_norm = nanstd(SpectreSaline_REM_BeforeInj_mean_norm)/sqrt(size(SpectreSaline_REM_BeforeInj_mean_norm,1));

SpectreSaline_Wake_AfterInj_all_SEM_norm = nanstd(SpectreSaline_Wake_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_all_mean_norm,1));
SpectreSaline_SWS_AfterInj_all_SEM_norm = nanstd(SpectreSaline_SWS_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_all_mean_norm,1));
SpectreSaline_REM_AfterInj_all_SEM_norm = nanstd(SpectreSaline_REM_AfterInj_all_mean_norm)/sqrt(size(SpectreSaline_REM_AfterInj_all_mean_norm,1));

SpectreSaline_Wake_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_Wake_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_Wake_AfterInj_3h_mean_norm,1));
SpectreSaline_SWS_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_SWS_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_SWS_AfterInj_3h_mean_norm,1));
SpectreSaline_REM_AfterInj_3h_SEM_norm = nanstd(SpectreSaline_REM_AfterInj_3h_mean_norm)/sqrt(size(SpectreSaline_REM_AfterInj_3h_mean_norm,1));

% for wake with high/low activity
SpectreSaline_WakeLowMov_Before_SEM_norm = nanstd(SpectreSaline_WakeLowMov_Before_mean_norm)/sqrt(size(SpectreSaline_WakeLowMov_Before_mean_norm,1));
SpectreSaline_WakeLowMov_After_SEM_norm = nanstd(SpectreSaline_WakeLowMov_After_mean_norm)/sqrt(size(SpectreSaline_WakeLowMov_After_mean_norm,1));
SpectreSaline_WakeHighMov_Before_SEM_norm = nanstd(SpectreSaline_WakeHighMov_Before_mean_norm)/sqrt(size(SpectreSaline_WakeHighMov_Before_mean_norm,1));
SpectreSaline_WakeHighMov_After_SEM_norm = nanstd(SpectreSaline_WakeHighMov_After_mean_norm)/sqrt(size(SpectreSaline_WakeHighMov_After_mean_norm,1));



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
    % for wake with high/low activity
    try 
    SpectreCNO_WakeLowMov_Before_mean(j,:) =  nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},and(c{j}.Wake,lowMov_CNO{j}))))),1);
    SpectreCNO_WakeLowMov_After_mean(j,:) =  nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},and(c{j}.Wake,lowMov_CNO{j}))))),1);
    SpectreCNO_WakeHighMov_Before_mean(j,:) =  nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},and(c{j}.Wake,highMov_CNO{j}))))),1);
    SpectreCNO_WakeHighMov_After_mean(j,:) =  nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},and(c{j}.Wake,highMov_CNO{j}))))),1);
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

% for wake with high/low activity
SpectreCNO_WakeLowMov_Before_SEM = nanstd(SpectreCNO_WakeLowMov_Before_mean)/sqrt(size(SpectreCNO_WakeLowMov_Before_mean,1));
SpectreCNO_WakeLowMov_After_SEM = nanstd(SpectreCNO_WakeLowMov_After_mean)/sqrt(size(SpectreCNO_WakeLowMov_After_mean,1));
SpectreCNO_WakeHighMov_Before_SEM = nanstd(SpectreCNO_WakeHighMov_Before_mean)/sqrt(size(SpectreCNO_WakeHighMov_Before_mean,1));
SpectreCNO_WakeHighMov_After_SEM = nanstd(SpectreCNO_WakeHighMov_After_mean)/sqrt(size(SpectreCNO_WakeHighMov_After_mean,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    try
    % for wake with high/low activity
    SpectreCNO_WakeLowMov_Before_mean_norm(j,:) =  SpectreCNO_WakeLowMov_Before_mean(j,:)./nanmean(SpectreCNO_WakeLowMov_Before_mean(j,:));
    SpectreCNO_WakeLowMov_After_mean_norm(j,:) =  SpectreCNO_WakeLowMov_After_mean(j,:)./nanmean(SpectreCNO_WakeLowMov_After_mean(j,:));
    SpectreCNO_WakeHighMov_Before_mean_norm(j,:) =  SpectreCNO_Wake_AfterInj_3h_mean(j,:)./nanmean(SpectreCNO_WakeHighMov_Before_mean(j,:));
    SpectreCNO_WakeHighMov_After_mean_norm(j,:) =  SpectreCNO_WakeHighMov_After_mean(j,:)./nanmean(SpectreCNO_WakeHighMov_After_mean(j,:));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% for wake with high/low activity
SpectreCNO_WakeLowMov_Before_SEM_norm = nanstd(SpectreCNO_WakeLowMov_Before_mean_norm)/sqrt(size(SpectreCNO_WakeLowMov_Before_mean_norm,1));
SpectreCNO_WakeLowMov_After_SEM_norm = nanstd(SpectreCNO_WakeLowMov_After_mean_norm)/sqrt(size(SpectreCNO_WakeLowMov_After_mean_norm,1));
SpectreCNO_WakeHighMov_Before_SEM_norm = nanstd(SpectreCNO_WakeHighMov_Before_mean_norm)/sqrt(size(SpectreCNO_WakeHighMov_Before_mean_norm,1));
SpectreCNO_WakeHighMov_After_SEM_norm = nanstd(SpectreCNO_WakeHighMov_After_mean_norm)/sqrt(size(SpectreCNO_WakeHighMov_After_mean_norm,1));


%% figures
% to get figures with normalisation run : atropine_spectral_analysis_figures_norm_MC

%%
figure,
ax(1)=subplot(4,6,7), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'r',1);
ylabel('Power (a.u)')
title('WAKE pre')
makepretty
ax(2)=subplot(4,6,8), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'r',1);
title('NREM pre')
makepretty
ax(3)=subplot(4,6,9), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r',1);
title('REM pre')
makepretty

ax(4)=subplot(4,6,13), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'r',1);
title('WAKE post')
ylabel('Power (a.u)')
makepretty
ax(5)=subplot(4,6,14), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'r',1);
title('NREM post')
makepretty
ax(6)=subplot(4,6,15), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
title('REM post')
makepretty

ax(7)=subplot(4,6,19), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'r',1);
title('WAKE 3h post')
xlabel('Frequency(Hz)')
ylabel('Power (a.u)')
makepretty
ax(8)=subplot(4,6,20), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'r',1);
xlabel('Frequency(Hz)')
title('NREM 3h post')
makepretty
ax(9)=subplot(4,6,21), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
xlabel('Frequency(Hz)')
title('REM 3h post')
makepretty

ax(10)=subplot(4,6,4), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'r',1);
title('pre saline')
makepretty

ax(11)=subplot(4,6,5), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'r',1);
title('post saline')
makepretty

ax(12)=subplot(4,6,6), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'r',1);
title('3h post saline')
makepretty


ax(13)=subplot(4,6,10), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r',1);
title('pre CNO')
makepretty

ax(14)=subplot(4,6,11), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
title('post CNO')
makepretty

ax(15)=subplot(4,6,12), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
title('3h post CNO')
makepretty


ax(16)=subplot(4,6,16),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k:',1);hold on
% shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1);
s1=shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1);
title('WAKE- saline')
makepretty
%sws saline
ax(17)=subplot(4,6,17),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'b:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'b',1);
 shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'b',1);
 title('NREM - saline')
makepretty
% rem saline
ax(18)=subplot(4,6,18), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'r:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'r',1);
  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'r',1);
  title('REM - saline')
makepretty
%wake cno
ax(19)=subplot(4,6,22),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'k:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'k',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'k',1);
title('WAKE - CNO')
makepretty
xlabel('Frequency (Hz)')
%sws cno
ax(20)=subplot(4,6,23),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'b:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj__all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'b',1);
title('NREM - CNO')
makepretty
xlabel('Frequency (Hz)')
%rem cno
ax(21)=subplot(4,6,24),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
makepretty
title('REM - CNO')
xlabel('Frequency (Hz)')

set(ax,'xlim',[0 15], 'ylim',[0 2e6])
% set(ax,'xlim',[20 100], 'ylim',[0 1e5])




%% pre vs post
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(234)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty



%% sal vs atropine
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


subplot(234)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty




%% wake high/low movement
figure
subplot(2,6,[1,2,7,8])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake pre')

subplot(2,6,3)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_Before_mean), SpectreSaline_WakeLowMov_Before_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_Before_mean), SpectreCNO_WakeLowMov_Before_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 99])
title('Wake Low mov')

subplot(2,6,9)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_Before_mean), SpectreSaline_WakeHighMov_Before_SEM,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_Before_mean), SpectreCNO_WakeHighMov_Before_SEM,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake High mov')

subplot(2,6,[4,5,10,11])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake')

subplot(2,6,6)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_After_mean), SpectreSaline_WakeLowMov_After_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_After_mean), SpectreCNO_WakeLowMov_After_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake Low mov')

subplot(2,6,12)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_After_mean), SpectreSaline_WakeHighMov_After_SEM,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_After_mean), SpectreCNO_WakeHighMov_After_SEM,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
% xlim([20 100])
title('Wake High mov')


%% individual trace

figure
subplot(2,6,[1,2,7,8])
s = plot(frq_sal{1},  (SpectreSaline_Wake_BeforeInj_mean),'k');hold on
s = plot(frq_cno{1},  (SpectreCNO_Wake_BeforeInj_mean),'g');hold on
makepretty
xlim([20 100])
title('Wake pre')

subplot(2,6,3)
s = plot(frq_sal{1},  (SpectreSaline_WakeLowMov_Before_mean),'k');hold on
s = plot(frq_sal{1},  (SpectreCNO_WakeLowMov_Before_mean),'g');hold on
makepretty
xlim([20 100])
title('Wake Low mov')

subplot(2,6,9)
s = plot(frq_sal{1},  (SpectreSaline_WakeHighMov_Before_mean),'k');hold on
s = plot(frq_sal{1},  (SpectreCNO_WakeHighMov_Before_mean),'g');hold on
makepretty
xlim([20 100])
title('Wake High mov')

subplot(2,6,[4,5,10,11])
s = plot(frq_sal{1},  (SpectreSaline_Wake_AfterInj_all_mean),'k'); hold on
s = plot(frq_cno{1},  (SpectreCNO_Wake_AfterInj_all_mean),'g');
makepretty
xlim([20 100])
title('Wake')

subplot(2,6,6)
s = plot(frq_sal{1},  (SpectreSaline_WakeLowMov_After_mean),'k'); hold on
s = plot(frq_sal{1},  (SpectreCNO_WakeLowMov_After_mean),'g');
makepretty
xlim([20 100])
title('Wake Low mov')

subplot(2,6,12)
s = plot(frq_sal{1},  (SpectreSaline_WakeHighMov_After_mean),'k'); hold on
s = plot(frq_sal{1},  (SpectreCNO_WakeHighMov_After_mean),'g');
makepretty
xlim([20 100])
title('Wake High mov')

