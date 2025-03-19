%% input dir
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1217 1218 1219 1220]); %%small volume
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149]); %%big volume
% % 
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline=RestrictPathForExperiment(DirSaline,'nMice',[1217 1218 1219 1220]);

% %%dir basal
% Dir_dreadd1=PathForExperiments_DREADD_MC('BaselineSleep');
% Dir_dreadd2=PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% Dir_dreadd2=RestrictPathForExperiment(Dir_dreadd2,'nMice',[1197 1198]);
% DirBasal = MergePathForExperiment(Dir_dreadd1,Dir_dreadd2);
% 
DirBasal = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');

% %%DIR EXCI DREADDS CRH VLPO SAL/CNO (basal sleep)
dirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');
dirSaline = RestrictPathForExperiment(dirSaline, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217

dirCNO = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_CNOInjection_1pm');
dirCNO = RestrictPathForExperiment(dirCNO, 'nMice', [1218 1219 1220 1371 1372 1373 1374]);%1217
% dirCNO_bigVolume = RestrictPathForExperiment(dirCNO,'nMice',[1105 1106 1148 1149 ]);%1150



%%

% DirSaline = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline=RestrictPathForExperiment(DirSaline,'nMice',[1245 1247]);

% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1245 1247]);

%%parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

same_ending = 234880;



%% get data (saline)
for k=1:length(DirBasal.path)
    cd(DirBasal.path{k}{1});
    %%load behaviour
    if exist('behavResources.mat')
        behav_basal{k} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        
    elseif exist('SleepScoring_Accelero.mat')
        c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_basal=DensitySleepStage_MC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch,'wake',100);
        density_WAKE_basal{k}=D_WAKE_basal;
        D_SWS_basal=DensitySleepStage_MC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch,'sws',100);
        density_SWS_basal{k}=D_SWS_basal;
        D_REM_basal=DensitySleepStage_MC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch,'rem',100);
        density_REM_basal{k}=D_REM_basal;
        
%         %%get time of the day
%         VecTimeDay_basal{k} = GetTimeOfTheDay_MC(Range(density_WAKE_basal{k}), 0);
%         %%indexes to realign recording of every mice
%         idx_inj_basal(k) = find(VecTimeDay_basal{k}>13,1,'first');
%         end_rec_basal(k) = min(length(density_REM_basal{k}));
%         end_half_basal(k) = min(length(density_REM_basal{k})-idx_inj_basal(k));
%         idx_beg_rec_basal(k) = find(VecTimeDay_basal{k}>9,1,'first');
%         max_end_basal(k) = max(length(density_REM_basal{k}));
    else
    end
end


%%
same_len=334;

clear jj
for jj=1:length(density_REM_basal)
    if isempty(density_REM_basal{jj})==0
        %%temperature
        data_temp_basal{jj}=Data(behav_basal{jj}.MouseTemp_tsd);
        time_basal{jj} = Range(behav_basal{jj}.MouseTemp_tsd);
        temp_basal{jj} = Data(behav_basal{jj}.MouseTemp_tsd);
        
        %%stages percentage
        %%time vector
        VecTimeDay_basal{jj}(end_rec_basal(jj):max(max_end_basal))=NaN;
        %%get density data for each stage
        data_density_WAKE_basal{jj}=Data(density_WAKE_basal{jj})';
        data_density_SWS_basal{jj}=Data(density_SWS_basal{jj})';
        data_density_REM_basal{jj}=Data(density_REM_basal{jj})';
       
        %%divide session in 2 part (to realign data from each mouse on
        %%injection time)
        %%pre injection (from start to injection)
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
        
        %%end of each recoring
        taille_basal(jj) = length(data_density_REM_total_basal{jj});

    else
    end
end
%%
clear ii
for jj=1:length(density_REM_basal)
    if isempty(density_REM_basal{jj})==0
        %%temperature
        time_basal_all(jj,:) = time_basal{jj}(1:same_ending,:);
        temp_basal_all(jj,:) = temp_basal{jj}(1:same_ending,:);
        
        %%stages percentage
        %%store easily data from all mice
        av_data_density_WAKE_basal(jj,:) = data_density_WAKE_total_basal{jj}(1,1:min(taille_basal));
        av_data_density_SWS_basal(jj,:) = data_density_SWS_total_basal{jj}(1,1:min(taille_basal));
        av_data_density_REM_basal(jj,:) = data_density_REM_total_basal{jj}(1,1:min(taille_basal));
    else
    end
end






%% get data (saline)
for j=1:length(dirSaline.path)
    cd(dirSaline.path{j}{1});
    %%load behaviour
    if exist('behavResources.mat')
        behav_sal{j} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end
    
    %%load sleep scoring
%     if exist('SleepScoring_OBGamma.mat')
%         b{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        
%     elseif exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
%     else
%     end
    
    %%compute stages density
%     if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_sal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'wake',100);
        density_WAKE_sal{j}=D_WAKE_sal;
        D_SWS_sal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'sws',100);
        density_SWS_sal{j}=D_SWS_sal;
        D_REM_sal=DensitySleepStage_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,'rem',100);
        density_REM_sal{j}=D_REM_sal;
        
        %%get time of the day
        VecTimeDay_sal{j} = GetTimeOfTheDay_MC(Range(density_WAKE_sal{j}), 0);
        %%indexes to realign recording of every mice
        idx_inj_sal(j) = find(VecTimeDay_sal{j}>13,1,'first');
        end_rec_sal(j) = min(length(density_REM_sal{j}));
        end_half_sal(j) = min(length(density_REM_sal{j})-idx_inj_sal(j));
        idx_beg_rec_sal(j) = find(VecTimeDay_sal{j}>9,1,'first');
        max_end_sal(j) = max(length(density_REM_sal{j}));
%     else
%     end
end


%%
same_len=338;

clear jj
for jj=1:length(density_REM_sal)
    if isempty(density_REM_sal{jj})==0
        %%temperature
        data_temp_sal{jj}=Data(behav_sal{jj}.MouseTemp_tsd);
        time_sal{jj} = Range(behav_sal{jj}.MouseTemp_tsd);
        temp_sal{jj} = Data(behav_sal{jj}.MouseTemp_tsd);
        
        %%stages percentage
        %%time vector
        VecTimeDay_sal{jj}(end_rec_sal(jj):max(max_end_sal))=NaN;
        %%get density data for each stage
        data_density_WAKE_sal{jj}=Data(density_WAKE_sal{jj})';
        data_density_SWS_sal{jj}=Data(density_SWS_sal{jj})';
        data_density_REM_sal{jj}=Data(density_REM_sal{jj})';
       
        %%divide session in 2 part (to realign data from each mouse on
        %%injection time)
        %%pre injection (from start to injection)
        data_density_WAKE_pre_sal{jj}=data_density_WAKE_sal{jj}(idx_beg_rec_sal(jj):idx_inj_sal(jj));
        data_density_REM_pre_sal{jj}=data_density_REM_sal{jj}(idx_beg_rec_sal(jj):idx_inj_sal(jj));
        data_density_SWS_pre_sal{jj}=data_density_SWS_sal{jj}(idx_beg_rec_sal(jj):idx_inj_sal(jj));
        %%post injection (from injection to the end)
        data_density_WAKE_post_sal{jj}=data_density_WAKE_sal{jj}(idx_inj_sal(jj):end);
        data_density_REM_post_sal{jj}=data_density_REM_sal{jj}(idx_inj_sal(jj):end);
        data_density_SWS_post_sal{jj}=data_density_SWS_sal{jj}(idx_inj_sal(jj):end);
        
        %%fill vectors with NaNs to get same length recordings
        %%pre
        data_density_WAKE_pre_sal{jj}(min(idx_beg_rec_sal):idx_beg_rec_sal(jj))=NaN;
        data_density_REM_pre_sal{jj}(min(idx_beg_rec_sal):idx_beg_rec_sal(jj))=NaN;
        data_density_SWS_pre_sal{jj}(min(idx_beg_rec_sal):idx_beg_rec_sal(jj))=NaN;
        %%post
        data_density_WAKE_post_sal{jj}(end_half_sal(jj):max(end_half_sal))=NaN;
        data_density_REM_post_sal{jj}(end_half_sal(jj):max(end_half_sal))=NaN;
        data_density_SWS_post_sal{jj}(end_half_sal(jj):max(end_half_sal))=NaN;
        
        %%re concatenate pre and post injection periods
        data_density_WAKE_total_sal{jj} = [data_density_WAKE_pre_sal{jj},data_density_WAKE_post_sal{jj}];
        data_density_SWS_total_sal{jj} = [data_density_SWS_pre_sal{jj},data_density_SWS_post_sal{jj}];
        data_density_REM_total_sal{jj} = [data_density_REM_pre_sal{jj},data_density_REM_post_sal{jj}];
        
        %%end of each recoring
        taille_sal(jj) = length(data_density_REM_total_sal{jj})-1;

    else
    end
end
%%
clear ii
for jj=1:length(density_REM_sal)
    if isempty(density_REM_sal{jj})==0
        %%temperature
        time_sal_all(jj,:) = time_sal{jj}(1:same_ending,:);
        temp_sal_all(jj,:) = temp_sal{jj}(1:same_ending,:);
        
        %%stages percentage
        %%store easily data from all mice
        av_data_density_WAKE_sal(jj,:) = data_density_WAKE_total_sal{jj}(1,1:min(taille_sal));
        av_data_density_SWS_sal(jj,:) = data_density_SWS_total_sal{jj}(1,1:min(taille_sal));
        av_data_density_REM_sal(jj,:) = data_density_REM_total_sal{jj}(1,1:min(taille_sal));
    else
    end
end


%% get data (CNO)
for i=1:length(dirCNO.path)
    cd(dirCNO.path{i}{1});
    mouseNum{i}=load('ExpeInfo.mat')
    %%load behaviour
    if exist('behavResources.mat')
        behav_cno{i} = load('behavResources.mat', 'MouseTemp_InDegrees','MouseTemp_tsd','Xtsd');
    else
    end

        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'WakeWiNoise', 'Wake');
        if mouseNum{i}.ExpeInfo.nmouse == 1247
            a{i}.Wake = a{i}.WakeWiNoise;
        else
        end

    
    %%compute stages density
%     if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_cno=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'wake',100);
        density_WAKE_cno{i}=D_WAKE_cno;
        D_SWS_cno=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'sws',100);
        density_SWS_cno{i}=D_SWS_cno;
        D_REM_cno=DensitySleepStage_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,'rem',100);
        density_REM_cno{i}=D_REM_cno;
        
        %%get time of the day
        VecTimeDay_cno{i} = GetTimeOfTheDay_MC(Range(density_WAKE_cno{i}), 0);
        %%indexes to realign recording of every mice
        idx_inj_cno(i) = find(VecTimeDay_cno{i}>13,1,'first');
        end_rec_cno(i) = min(length(density_REM_cno{i}));
        end_half_cno(i) = min(length(density_REM_cno{i})-idx_inj_cno(i));
        idx_beg_rec_cno(i) = find(VecTimeDay_cno{i}>9,1,'first');
        max_end_cno(i) = max(length(density_REM_cno{i}));
%     else
%     end
end


%%
same_len=316;

clear ii
for ii=1:length(density_REM_cno)
    if isempty(density_REM_cno{ii})==0
        %%temperature
        data_temp{ii}=Data(behav_cno{ii}.MouseTemp_tsd);
        time_cno{ii} = Range(behav_cno{ii}.MouseTemp_tsd);
        temp_cno{ii} = Data(behav_cno{ii}.MouseTemp_tsd);
        
        %%stages percentage
        %%time vector
        VecTimeDay_cno{ii}(end_rec_cno(ii):max(max_end_cno))=NaN;
        %%get density data for each stage
        data_density_WAKE_cno{ii}=Data(density_WAKE_cno{ii})';
        data_density_SWS_cno{ii}=Data(density_SWS_cno{ii})';
        data_density_REM_cno{ii}=Data(density_REM_cno{ii})';
       
        %%divide session in 2 part (to realign data from each mouse on
        %%injection time)
        %%pre injection (from start to injection)
        data_density_WAKE_pre_cno{ii}=data_density_WAKE_cno{ii}(idx_beg_rec_cno(ii):idx_inj_cno(ii));
        data_density_REM_pre_cno{ii}=data_density_REM_cno{ii}(idx_beg_rec_cno(ii):idx_inj_cno(ii));
        data_density_SWS_pre_cno{ii}=data_density_SWS_cno{ii}(idx_beg_rec_cno(ii):idx_inj_cno(ii));
        %%post injection (from injection to the end)
        data_density_WAKE_post_cno{ii}=data_density_WAKE_cno{ii}(idx_inj_cno(ii):end);
        data_density_REM_post_cno{ii}=data_density_REM_cno{ii}(idx_inj_cno(ii):end);
        data_density_SWS_post_cno{ii}=data_density_SWS_cno{ii}(idx_inj_cno(ii):end);
        
        %%fill vectors with NaNs to get same length recordings
        %%pre
        data_density_WAKE_pre_cno{ii}(min(idx_beg_rec_cno):idx_beg_rec_cno(ii))=NaN;
        data_density_REM_pre_cno{ii}(min(idx_beg_rec_cno):idx_beg_rec_cno(ii))=NaN;
        data_density_SWS_pre_cno{ii}(min(idx_beg_rec_cno):idx_beg_rec_cno(ii))=NaN;
        %%post
        data_density_WAKE_post_cno{ii}(end_half_cno(ii):max(end_half_cno))=NaN;
        data_density_REM_post_cno{ii}(end_half_cno(ii):max(end_half_cno))=NaN;
        data_density_SWS_post_cno{ii}(end_half_cno(ii):max(end_half_cno))=NaN;
        
        %%re concatenate pre and post injection periods
        data_density_WAKE_total_cno{ii} = [data_density_WAKE_pre_cno{ii},data_density_WAKE_post_cno{ii}];
        data_density_SWS_total_cno{ii} = [data_density_SWS_pre_cno{ii},data_density_SWS_post_cno{ii}];
        data_density_REM_total_cno{ii} = [data_density_REM_pre_cno{ii},data_density_REM_post_cno{ii}];
        
        %%end of each recoring
        taille_cno(ii) = length(data_density_REM_total_cno{ii});

    else
    end
end
%%
clear ii
for ii=1:length(density_REM_cno)
    if isempty(density_REM_cno{ii})==0
        %%temperature
        time_cno_all(ii,:) = time_cno{ii}(1:same_ending,:);
        temp_cno_all(ii,:) = temp_cno{ii}(1:same_ending,:);
        
        %%stages percentage
        %%store easily data from all mice
        av_data_density_WAKE_cno(ii,:) = data_density_WAKE_total_cno{ii}(1,1:min(taille_cno));
        av_data_density_SWS_cno(ii,:) = data_density_SWS_total_cno{ii}(1,1:min(taille_cno));
        av_data_density_REM_cno(ii,:) = data_density_REM_total_cno{ii}(1,1:min(taille_cno));
    else
    end
end




%%
col_basal = [0 0 0];
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];



t_basal=Range(density_REM_basal{2});
time_basal = t_basal(1:min(taille_basal));

t_sal=Range(density_REM_sal{2});
time_sal = t_sal(1:min(taille_sal));

t_cno=Range(density_REM_cno{2});
time_cno = t_cno(1:min(taille_cno));

figure,
subplot(5,1,[1,2]), hold on
plot(time_cno_all(1,:), runmean(mean(temp_basal_all),50),'color',col_basal)
plot(time_cno_all(1,:), runmean(mean(temp_sal_all),50),'color',col_sal)
plot(time_cno_all(1,:), runmean(mean(temp_cno_all),50),'color',col_cno)
line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('Temperature (°C)')
set(gca,'FontSize',14)
legend({'Baseline','Saline','CNO','',''})

subplot(513), hold on
plot(time_basal,nanmean(av_data_density_WAKE_basal),'k')
plot(time_basal,nanmean(av_data_density_SWS_basal),'b')
plot(time_basal,nanmean(av_data_density_REM_basal),'r')
% line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
% line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('Baseline')
set(gca,'FontSize',14)
legend({'WAKE','NREM','REM','',''})

subplot(514), hold on
plot(time_sal,nanmean(av_data_density_WAKE_sal),'k')
plot(time_sal,nanmean(av_data_density_SWS_sal),'b')
plot(time_sal,nanmean(av_data_density_REM_sal),'r')
line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('Saline')
set(gca,'FontSize',14)

subplot(515), hold on
plot(time_cno,nanmean(av_data_density_WAKE_cno),'k')
plot(time_cno,nanmean(av_data_density_SWS_cno),'b')
plot(time_cno,nanmean(av_data_density_REM_cno),'r')
line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('CNO')
xlabel('Time (s)')
set(gca,'FontSize',14)

%%
col_basal = [0 0 0];
col_sal = [1 0.6 0.6];
col_cno = [1 0 0];

t=Range(density_REM_cno{2});
time=t(1:same_len);

figure,
subplot(211), hold on
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_basal_all),50),stdError(temp_basal_all),'k',1)
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_sal_all),50),stdError(temp_sal_all),'m',1)
shadedErrorBar(time_cno_all(1,:), runmean(mean(temp_cno_all),50),stdError(temp_cno_all),'r',1)
line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('Temperature (°C)')
set(gca,'FontSize',14)

subplot(212), hold on
shadedErrorBar(time,av_data_density_REM_cno,{@nanmean,@stdError},'r',1)
shadedErrorBar(time,av_data_density_SWS_cno,{@nanmean,@stdError},'b',1)
shadedErrorBar(time,av_data_density_WAKE_cno,{@nanmean,@stdError},'k',1)
line([1.35e8 1.35e8],ylim,'color','k','linestyle',':')
line([1.52e8 1.52e8],ylim,'color','k','linestyle',':')
xlim([0 2.72e8])
ylabel('Percentage (%)')
xlabel('Time (s)')
set(gca,'FontSize',14)


