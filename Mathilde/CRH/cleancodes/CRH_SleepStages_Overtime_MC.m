% %%
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% 
% Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
% 
% DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
% 
% % DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% % DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);


%% input dir : exi DREADD VLPO CRH-neurons
DirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
DirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');

% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % dirCNO=RestrictPathForExperiment(dirCNO,'nMice',[1217 1218 1219 1220]); %%small volume
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149]); %%big volume

%% input dir : inhi DREADD in PFC
%baseline sleep
% DirBasal_KJ=PathForExperimentsAllBasalSleep('Basal');
% DirBasal_BM=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirBasal_KJ,DirBasal_BM);
% DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

% DirBasal=MergePathForExperiment(DirBasal_KJ,DirBasal_MC);

% 
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% % %cno
% % DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

%% ATROPINE

% DirCNO = PathForExperimentsAtropine_MC('Atropine');

% DirCNO = PathForExperimentsAtropine_MC('CNO_Atropine_DreaddMouse');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149]);

%%parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%% get data (baseline)
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        b{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        
        
    elseif exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'wake',100);
        density_WAKE_basal{j}=D_WAKE_basal;
        D_SWS_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'sws',100);
        density_SWS_basal{j}=D_SWS_basal;
        D_REM_basal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'rem',100);
        density_REM_basal{j}=D_REM_basal;
        %%get time of the day
        VecTimeDay_basal{j} = GetTimeOfTheDay_MC(Range(density_WAKE_basal{j}), 0);
        
        if isempty(VecTimeDay_basal{j})==0
        idx_inj_basal(j) = find(VecTimeDay_basal{j}>13,1,'first');
        
        end_rec_basal(j) = min(length(density_REM_basal{j}));
        end_half_basal(j) = min(length(density_REM_basal{j})-idx_inj_basal(j));
        
        
        idx_beg_rec_basal(j) = find(VecTimeDay_basal{j}>9,1,'first');
        
        max_end_basal(j) = max(length(density_REM_basal{j}));
        else
        end
    else
    end
end



%% get data (SD)
for i=1:length(DirCNO.path)
    cd(DirCNO.path{i}{1});
    %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'wake',100);
        density_WAKE{i}=D_WAKE;
        D_SWS=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'sws',100);
        density_SWS{i}=D_SWS;
        D_REM=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'rem',100);
        density_REM{i}=D_REM;
        %%get time of the day
        VecTimeDay{i} = GetTimeOfTheDay_MC(Range(density_WAKE{i}), 0);
        
        idx_inj(i) = find(VecTimeDay{i}>13,1,'first');
        
        end_rec(i) = min(length(density_REM{i}));
        end_half(i) = min(length(density_REM{i})-idx_inj(i));
        
        
        idx_beg_rec(i) = find(VecTimeDay{i}>9,1,'first');
        
        max_end(i) = max(length(density_REM{i}));
    else
    end
end

%%



%%
same_len_basal=329;

clear jj
for jj=1:length(density_REM_basal)
    if isempty(density_REM_basal{jj})==0
        if isempty(VecTimeDay_basal{jj})==0
        % %%time vector
        VecTimeDay_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        %%get density data for each stage
        data_density_WAKE_basal{jj}=Data(density_WAKE_basal{jj})';
        data_density_SWS_basal{jj}=Data(density_SWS_basal{jj})';
        data_density_REM_basal{jj}=Data(density_REM_basal{jj})';
        
        %%divide session in 2 part (to realign data from each mouse on
        %%injection time)
        %%pre injection (from start to injection)
        idx_beg_rec_basal(idx_beg_rec_basal==0)=1;
        idx_inj_basal(idx_inj_basal==0)=1;
        data_density_WAKE_pre_basal{jj}=data_density_WAKE_basal{jj}(idx_beg_rec_basal(jj):idx_inj_basal(jj));
        data_density_REM_pre_basal{jj}=data_density_REM_basal{jj}(idx_beg_rec_basal(jj):idx_inj_basal(jj));
        data_density_SWS_pre_basal{jj}=data_density_SWS_basal{jj}(idx_beg_rec_basal(jj):idx_inj_basal(jj));
        %%post injection (from injection to the end)
        data_density_WAKE_post_basal{jj}=data_density_WAKE_basal{jj}(idx_inj_basal(jj):end);
        data_density_REM_post_basal{jj}=data_density_REM_basal{jj}(idx_inj_basal(jj):end);
        data_density_SWS_post_basal{jj}=data_density_SWS_basal{jj}(idx_inj_basal(jj):end);
        
        %%fill vectors with NaNs to get same length recordings
        %%pre
        data_density_WAKE_pre_basal{jj}(min(idx_beg_rec_basal):idx_beg_rec_basal(jj))=NaN;
        data_density_REM_pre_basal{jj}(min(idx_beg_rec_basal):idx_beg_rec_basal(jj))=NaN;
        data_density_SWS_pre_basal{jj}(min(idx_beg_rec_basal):idx_beg_rec_basal(jj))=NaN;
        %%post
        data_density_WAKE_post_basal{jj}(end_half_basal(jj):max(end_half_basal))=NaN;
        data_density_REM_post_basal{jj}(end_half_basal(jj):max(end_half_basal))=NaN;
        data_density_SWS_post_basal{jj}(end_half_basal(jj):max(end_half_basal))=NaN;
        
        %%re concatenate pre and post injection periods
        data_density_WAKE_total_basal{jj} = [data_density_WAKE_pre_basal{jj},data_density_WAKE_post_basal{jj}];
        data_density_SWS_total_basal{jj} = [data_density_SWS_pre_basal{jj},data_density_SWS_post_basal{jj}];
        data_density_REM_total_basal{jj} = [data_density_REM_pre_basal{jj},data_density_REM_post_basal{jj}];
%         
        taille_basal(jj) = length(data_density_REM_total_basal{jj});

        else
        end
       
    else
    end
end
%%
clear jj
for jj=1:length(density_REM_basal)
    if isempty(density_REM_basal{jj})==0
%             if isempty(data_density_WAKE_total_basal{jj})==0

        %store easily data from all mice
        av_data_density_WAKE_basal(jj,:) = data_density_WAKE_total_basal{jj}(1,1:min(taille_basal));
        av_data_density_SWS_basal(jj,:) = data_density_SWS_total_basal{jj}(1,1:min(taille_basal));
        av_data_density_REM_basal(jj,:) = data_density_REM_total_basal{jj}(1,1:min(taille_basal));
%             else
%             end
    else
    end
end

%%
same_len=338;

clear ii
for ii=1:length(density_REM)
    if isempty(density_REM{ii})==0
        % %%time vector
        VecTimeDay{ii}(end_rec(ii):max(max_end))=NaN;
        %%get density data for each stage
        data_density_WAKE{ii}=Data(density_WAKE{ii})';
        data_density_SWS{ii}=Data(density_SWS{ii})';
        data_density_REM{ii}=Data(density_REM{ii})';
        
        
        %%divide session in 2 part (to realign data from each mouse on
        %%injection time)
        %%pre injection (from start to injection)
        data_density_WAKE_pre{ii}=data_density_WAKE{ii}(idx_beg_rec(ii):idx_inj(ii));
        data_density_REM_pre{ii}=data_density_REM{ii}(idx_beg_rec(ii):idx_inj(ii));
        data_density_SWS_pre{ii}=data_density_SWS{ii}(idx_beg_rec(ii):idx_inj(ii));
        %%post injection (from injection to the end)
        data_density_WAKE_post{ii}=data_density_WAKE{ii}(idx_inj(ii):end);
        data_density_REM_post{ii}=data_density_REM{ii}(idx_inj(ii):end);
        data_density_SWS_post{ii}=data_density_SWS{ii}(idx_inj(ii):end);
        
        %%fill vectors with NaNs to get same length recordings
        %%pre
        data_density_WAKE_pre{ii}(min(idx_beg_rec):idx_beg_rec(ii))=NaN;
        data_density_REM_pre{ii}(min(idx_beg_rec):idx_beg_rec(ii))=NaN;
        data_density_SWS_pre{ii}(min(idx_beg_rec):idx_beg_rec(ii))=NaN;
        %%post
        data_density_WAKE_post{ii}(end_half(ii):max(end_half))=NaN;
        data_density_REM_post{ii}(end_half(ii):max(end_half))=NaN;
        data_density_SWS_post{ii}(end_half(ii):max(end_half))=NaN;
        
        %%re concatenate pre and post injection periods
        data_density_WAKE_total{ii} = [data_density_WAKE_pre{ii},data_density_WAKE_post{ii}];
        data_density_SWS_total{ii} = [data_density_SWS_pre{ii},data_density_SWS_post{ii}];
        data_density_REM_total{ii} = [data_density_REM_pre{ii},data_density_REM_post{ii}];
        
        taille(ii) = length(data_density_REM_total{ii});

    else
    end
end

clear ii
for ii=1:length(density_REM)
    if isempty(density_REM{ii})==0
        %store easily sata from all mice
        av_data_density_WAKE(ii,:) = data_density_WAKE_total{ii}(1,1:min(taille));
        av_data_density_SWS(ii,:) = data_density_SWS_total{ii}(1,1:min(taille));
        av_data_density_REM(ii,:) = data_density_REM_total{ii}(1,1:min(taille));
    else
    end
end

%% figure
figure,
subplot(211), hold on
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille_basal),1), av_data_density_WAKE_basal, {@nanmean,@stdError}, 'k', 1);
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille_basal),1), av_data_density_SWS_basal, {@nanmean,@stdError}, 'b', 1);
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille_basal),1), av_data_density_REM_basal, {@nanmean,@stdError}, 'r', 1);
line([12.8 12.8],ylim,'linestyle',':','color','r','linewidth',2)
line([13.2 13.2],ylim,'linestyle',':','color','r','linewidth',2)
xlim([9 18.5])
makepretty
subplot(212), hold on
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille),1), av_data_density_WAKE, {@nanmean,@stdError}, 'k', 1);
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille),1), av_data_density_SWS, {@nanmean,@stdError}, 'b', 1);
shadedErrorBar(VecTimeDay_basal{1}(1:min(taille),1), av_data_density_REM, {@nanmean,@stdError}, 'r', 1);
line([12.8 12.8],ylim,'linestyle',':','color','g','linewidth',2)
line([13.2 13.2],ylim,'linestyle',':','color','g','linewidth',2)
xlim([9 18.5])
makepretty
xlabel('Time (hour)')

%%
line([14.2 14.2],ylim,'linestyle',':','color','g','linewidth',2)
line([13.8 13.8],ylim,'linestyle',':','color','g','linewidth',2)