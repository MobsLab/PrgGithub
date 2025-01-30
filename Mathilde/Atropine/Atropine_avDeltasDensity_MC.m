
%% baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);


%% input dir ATROPINE
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

DirSaline = PathForExperiments_DREADD_MC('exciDREADD_CRH_VLPO_SalineInjection_1pm');

DirCNO = PathForExperimentsAtropine_MC('Atropine');


%% parameters (to take off injection time (1pm))
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data
%baseline
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});

        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake', 'Info');


        % separate recording before/after injection
        durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
        epoch_pre_basal{i} = intervalSet(0,en_epoch_preInj);
        epoch_post_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_basal{i} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        

        
        if exist('DeltaWaves.mat')
            %%load deltas
            deltBasal{i} = load('DeltaWaves.mat','alldeltas_PFCx');
            % get deltas density
            [Delta_tsd] = GetDeltasDensityTSD_MC(deltBasal{i}.alldeltas_PFCx);
            DeltDensity_basal{i} = Delta_tsd;
            % find deltas in specific epoch
            %%pre
            delt_SWSbefore_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_pre_basal{i}));
            delt_Wakebefore_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.Wake, epoch_pre_basal{i}));
            delt_REMbefore_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.REMEpoch, epoch_pre_basal{i}));
            

            %%post (all)
            delt_SWSafter_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_post_basal{i}));
            delt_Wakeafter_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.Wake, epoch_post_basal{i}));
            delt_REMafter_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.REMEpoch, epoch_post_basal{i}));

            
            %3h post injection
            delt_SWS_3hPostInj_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_3hPostInj_basal{i}));
            delt_Wake_3hPostInj_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.Wake, epoch_3hPostInj_basal{i}));
            delt_REM_3hPostInj_basal{i} = Restrict(DeltDensity_basal{i}, and(a{i}.REMEpoch, epoch_3hPostInj_basal{i}));
            
        else
        end

end

%%
%%get the data for saline mice
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
%     if exist('SleepScoring_Accelero.mat')
        
        c{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        % separate recording before/after injection
        durtotal_sal{j} = max([max(End(c{j}.Wake)),max(End(c{j}.SWSEpoch))]);
        epoch_pre_sal{j} = intervalSet(0,en_epoch_preInj);
        epoch_post_sal{j} = intervalSet(st_epoch_postInj,durtotal_sal{j});
        %3h post injection
        epoch_3hPostInj_sal{j} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        
 
        if isempty(c{j})==0
            if exist('DeltaWaves.mat')
                %%load deltas
                deltSal{j} = load('DeltaWaves.mat','alldeltas_PFCx');
                % get deltas density
                [Delta_tsd] = GetDeltasDensityTSD_MC(deltSal{j}.alldeltas_PFCx);
                DeltDensity_sal{j} = Delta_tsd;
                % find deltas in specific epoch
                %%pre
                delt_SWSbefore_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.SWSEpoch, epoch_pre_sal{j}));
                delt_Wakebefore_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.Wake, epoch_pre_sal{j}));
                delt_REMbefore_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.REMEpoch, epoch_pre_sal{j}));
        
                %%post
                delt_SWSafter_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.SWSEpoch, epoch_post_sal{j}));
                delt_Wakeafter_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.Wake, epoch_post_sal{j}));
                delt_REMafter_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.REMEpoch, epoch_post_sal{j}));
            
                %3h post injection
                delt_REM_3hPostInj_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.REMEpoch, epoch_3hPostInj_sal{j}));
                delt_Wake_3hPostInj_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.Wake, epoch_3hPostInj_sal{j}));
                delt_SWS_3hPostInj_sal{j} = Restrict(DeltDensity_sal{j}, and(c{j}.SWSEpoch, epoch_3hPostInj_sal{j}));
            else
            end
        else
        end
%     else
%     end
end

%% get data for CNO mice
for k=1:length(DirCNO.path)
    cd(DirCNO.path{k}{1});
    e{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_cno{k} = max([max(End(e{k}.Wake)),max(End(e{k}.SWSEpoch))]);
    epoch_pre_cno{k} = intervalSet(0,en_epoch_preInj);
    epoch_post_cno{k} = intervalSet(st_epoch_postInj,durtotal_cno{k});
    %3h post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    %%load deltas
    deltCNO{k} = load('DeltaWaves.mat','alldeltas_PFCx');
    % get deltas density
    [Delta_tsd] = GetDeltasDensityTSD_MC(deltCNO{k}.alldeltas_PFCx);
    DeltDensity_cno{k} = Delta_tsd;
    % find deltas density in specific epoch
    %%pre
    delt_SWSbefore_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.SWSEpoch, epoch_pre_cno{k}));
    delt_Wakebefore_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.Wake, epoch_pre_cno{k}));
    delt_REMbefore_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.REMEpoch, epoch_pre_cno{k}));

    %%post (all)
    delt_SWSafter_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.SWSEpoch, epoch_post_cno{k}));
    delt_Wakeafter_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.Wake, epoch_post_cno{k}));
    delt_REMafter_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.REMEpoch, epoch_post_cno{k}));
    
    %3h post injection
    delt_SWS_3hPostInj_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.SWSEpoch, epoch_3hPostInj_cno{k}));
    delt_Wake_3hPostInj_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.Wake, epoch_3hPostInj_cno{k}));
    delt_REM_3hPostInj_cno{k} = Restrict(DeltDensity_cno{k}, and(e{k}.REMEpoch, epoch_3hPostInj_cno{k}));
    
end

%% calculate mean
%%baseline mice
for ii=1:length(delt_SWSbefore_basal)
    if isempty(delt_SWSbefore_basal{ii})==0
        avDeltaPerMin_SWSbefore_basal(ii,:)=nanmean(Data(delt_SWSbefore_basal{ii}(:,:)),1); avDeltaPerMin_SWSbefore_basal(avDeltaPerMin_SWSbefore_basal==0)=NaN;
        avDeltaPerMin_Wakebefore_basal(ii,:)=nanmean(Data(delt_Wakebefore_basal{ii}(:,:)),1); avDeltaPerMin_Wakebefore_basal(avDeltaPerMin_Wakebefore_basal==0)=NaN;
        avDeltaPerMin_REMbefore_basal(ii,:)=nanmean(Data(delt_REMbefore_basal{ii}(:,:)),1); avDeltaPerMin_REMbefore_basal(avDeltaPerMin_REMbefore_basal==0)=NaN;
            else
    end
end
for ii=1:length(delt_SWSafter_basal)
    if isempty(delt_SWSafter_basal{ii})==0
        avDeltaPerMin_SWSafter_basal(ii,:)=nanmean(Data(delt_SWSafter_basal{ii}(:,:)),1); avDeltaPerMin_SWSafter_basal(avDeltaPerMin_SWSafter_basal==0)=NaN;
        avDeltaPerMin_Wakeafter_basal(ii,:)=nanmean(Data(delt_Wakeafter_basal{ii}(:,:)),1); avDeltaPerMin_Wakeafter_basal(avDeltaPerMin_Wakeafter_basal==0)=NaN;
        avDeltaPerMin_REMafter_basal(ii,:)=nanmean(Data(delt_REMafter_basal{ii}(:,:)),1); avDeltaPerMin_REMafter_basal(avDeltaPerMin_REMafter_basal==0)=NaN;
                
        
        %3h post injection
        avDeltaPerMin_SWS_3hPostInj_basal(ii,:)=nanmean(Data(delt_SWS_3hPostInj_basal{ii}(:,:)),1); avDeltaPerMin_SWS_3hPostInj_basal(avDeltaPerMin_SWS_3hPostInj_basal==0)=NaN;
        avDeltaPerMin_Wake_3hPostInj_basal(ii,:)=nanmean(Data(delt_Wake_3hPostInj_basal{ii}(:,:)),1); avDeltaPerMin_Wake_3hPostInj_basal(avDeltaPerMin_Wake_3hPostInj_basal==0)=NaN;
        avDeltaPerMin_REM_3hPostInj_basal(ii,:)=nanmean(Data(delt_REM_3hPostInj_basal{ii}(:,:)),1); avDeltaPerMin_REM_3hPostInj_basal(avDeltaPerMin_REM_3hPostInj_basal==0)=NaN;
    else
    end
end
%%
%%saline mice
for jj=1:length(delt_SWSbefore_sal)
    avDeltaPerMin_SWSbefore_sal(jj,:)=nanmean(Data(delt_SWSbefore_sal{jj}(:,:)),1); avDeltaPerMin_SWSbefore_sal(avDeltaPerMin_SWSbefore_sal==0)=NaN;
    avDeltaPerMin_Wakebefore_sal(jj,:)=nanmean(Data(delt_Wakebefore_sal{jj}(:,:)),1); avDeltaPerMin_Wakebefore_sal(avDeltaPerMin_Wakebefore_sal==0)=NaN;
    avDeltaPerMin_REMbefore_sal(jj,:)=nanmean(Data(delt_REMbefore_sal{jj}(:,:)),1); avDeltaPerMin_REMbefore_sal(avDeltaPerMin_REMbefore_sal==0)=NaN;
end
for jj=1:length(delt_SWSafter_sal)
    avDeltaPerMin_SWSafter_sal(jj,:)=nanmean(Data(delt_SWSafter_sal{jj}(:,:)),1); avDeltaPerMin_SWSafter_sal(avDeltaPerMin_SWSafter_sal==0)=NaN;
    avDeltaPerMin_Wakeafter_sal(jj,:)=nanmean(Data(delt_Wakeafter_sal{jj}(:,:)),1); avDeltaPerMin_Wakeafter_sal(avDeltaPerMin_Wakeafter_sal==0)=NaN;
    avDeltaPerMin_REMafter_sal(jj,:)=nanmean(Data(delt_REMafter_sal{jj}(:,:)),1); avDeltaPerMin_REMafter_sal(avDeltaPerMin_REMafter_sal==0)=NaN;
    %3h post injection
    avDeltaPerMin_SWS_3hPostInj_sal(jj,:)=nanmean(Data(delt_SWS_3hPostInj_sal{jj}(:,:)),1);
    avDeltaPerMin_Wake_3hPostInj_sal(jj,:)=nanmean(Data(delt_Wake_3hPostInj_sal{jj}(:,:)),1);
    avDeltaPerMin_REM_3hPostInj_sal(jj,:)=nanmean(Data(delt_REM_3hPostInj_sal{jj}(:,:)),1);
end
%% cno mice
for kk=1:length(delt_SWSbefore_cno)
    avDeltaPerMin_SWSbefore_cno(kk,:)=nanmean(Data(delt_SWSbefore_cno{kk}(:,:)),1); avDeltaPerMin_SWSbefore_cno(avDeltaPerMin_SWSbefore_cno==0)=NaN;
    avDeltaPerMin_Wakebefore_cno(kk,:)=nanmean(Data(delt_Wakebefore_cno{kk}(:,:)),1); avDeltaPerMin_Wakebefore_cno(avDeltaPerMin_Wakebefore_cno==0)=NaN;
    avDeltaPerMin_REMbefore_cno(kk,:)=nanmean(Data(delt_REMbefore_cno{kk}(:,:)),1); avDeltaPerMin_REMbefore_cno(avDeltaPerMin_REMbefore_cno==0)=NaN;
end
for kk=1:length(delt_SWSafter_cno)
    avDeltaPerMin_SWSafter_cno(kk,:)=nanmean(Data(delt_SWSafter_cno{kk}(:,:)),1); avDeltaPerMin_SWSafter_cno(avDeltaPerMin_SWSafter_cno==0)=NaN;
    avDeltaPerMin_Wakeafter_cno(kk,:)=nanmean(Data(delt_Wakeafter_cno{kk}(:,:)),1); avDeltaPerMin_Wakeafter_cno(avDeltaPerMin_Wakeafter_cno==0)=NaN;
    avDeltaPerMin_REMafter_cno(kk,:)=nanmean(Data(delt_REMafter_cno{kk}(:,:)),1); avDeltaPerMin_REMafter_cno(avDeltaPerMin_REMafter_cno==0)=NaN;
        
    %3h post injection
    avDeltaPerMin_SWS_3hPostInj_cno(kk,:)=nanmean(Data(delt_SWS_3hPostInj_cno{kk}(:,:)),1);
    avDeltaPerMin_Wake_3hPostInj_cno(kk,:)=nanmean(Data(delt_Wake_3hPostInj_cno{kk}(:,:)),1);
    avDeltaPerMin_REM_3hPostInj_cno(kk,:)=nanmean(Data(delt_REM_3hPostInj_cno{kk}(:,:)),1);
end

%% figure
%% figure : delta density overtime
clear jj
figure
for jj=1:length(DirSaline.path)
    VecTimeDay_WAKE_sal{jj} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_sal{jj},c{jj}.Wake)), 0);
    VecTimeDay_SWS_sal{jj} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_sal{jj},c{jj}.SWSEpoch)), 0);
    VecTimeDay_REM_sal{jj} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_sal{jj},c{jj}.REMEpoch)), 0);
    
    subplot(3,5,[1,2]),
    %     plot(Range(Restrict(DeltDensity_sal{jj},c{jj}.Wake))/1E4, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.Wake)),70),'.'), hold on
    plot(VecTimeDay_WAKE_sal{jj}, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.Wake)),70),'.'), hold on
    ylabel('Deltas/s')
    title('WAKE (saline)')
    ylim([0 2])
    xlim([8 19])
    
    set(gca,'FontSize',14)
    subplot(3,5,[6,7]),
    %     plot(Range(Restrict(DeltDensity_sal{jj},c{jj}.SWSEpoch))/1E4, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.SWSEpoch)),70),'.'), hold on
    plot(VecTimeDay_SWS_sal{jj}, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.SWSEpoch)),70),'.'), hold on
    ylabel('Deltas/s')
    title('NREM (saline)')
    ylim([0 2])
    xlim([8 19])
    
    set(gca,'FontSize',14)
    subplot(3,5,[11,12]),
    %     plot(Range(Restrict(DeltDensity_sal{jj},c{jj}.REMEpoch))/1E4, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.REMEpoch)),70),'.'), hold on
    plot(VecTimeDay_REM_sal{jj}, runmean(Data(Restrict(DeltDensity_sal{jj},c{jj}.REMEpoch)),70),'.'), hold on
    
    ylabel('Deltas/s')
    title('REM (saline)')
    xlabel('Time (s)')
    ylim([0 2])
    xlim([8 19])
    
    set(gca,'FontSize',14)
    % legend({'mouse','mouse','mouse','mouse'})
    xlim([8 19])
    
end

for kk=1:length(DirCNO.path)
    VecTimeDay_WAKE_CNO{kk} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_cno{kk},e{kk}.Wake)), 0);
    VecTimeDay_SWS_CNO{kk} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_cno{kk},e{kk}.SWSEpoch)), 0);
    VecTimeDay_REM_CNO{kk} = GetTimeOfTheDay_MC(Range(Restrict(DeltDensity_cno{kk},e{kk}.REMEpoch)), 0);
    
    subplot(3,5,[3,4]),
    %     plot(Range(Restrict(DeltDensity_cno{kk},e{kk}.Wake))/1E4, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.Wake)),70),'.'), hold on
    plot(VecTimeDay_WAKE_CNO{kk}, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.Wake)),70),'.'), hold on
    
    title('WAKE (cno)')
    ylim([0 2])
    xlim([8 19])
    
    set(gca,'FontSize',14)
    subplot(3,5,[8,9]),
    %     plot(Range(Restrict(DeltDensity_cno{kk},e{kk}.SWSEpoch))/1E4, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.SWSEpoch)),70),'.'), hold on
    plot(VecTimeDay_SWS_CNO{kk}, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.SWSEpoch)),70),'.'), hold on
    title('NREM (cno)')
    ylim([0 2])
    xlim([8 19])
    
    set(gca,'FontSize',14)
    subplot(3,5,[13,14]),
    %     plot(Range(Restrict(DeltDensity_cno{kk},e{kk}.REMEpoch))/1E4, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.REMEpoch)),70),'.'), hold on
    
    plot(VecTimeDay_REM_CNO{kk}, runmean(Data(Restrict(DeltDensity_cno{kk},e{kk}.REMEpoch)),70),'.'), hold on
    title('REM (cno)')
    xlabel('Time (s)')
    ylim([0 2])
    set(gca,'FontSize',14)
    % legend({'mouse','mouse','mouse','mouse'})
    xlim([8 19])
end

%%
ax(1)=subplot(3,5,5),PlotErrorBarN_KJ({avDeltaPerMin_Wakebefore_sal,avDeltaPerMin_Wakebefore_cno,avDeltaPerMin_Wakeafter_sal,avDeltaPerMin_Wakeafter_cno},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('WAKE')
makepretty
ax(2)=subplot(3,5,10),PlotErrorBarN_KJ({avDeltaPerMin_SWSbefore_sal,avDeltaPerMin_SWSbefore_cno,avDeltaPerMin_SWSafter_sal,avDeltaPerMin_SWSafter_cno},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('NREM')
makepretty
ax(3)=subplot(3,5,15),PlotErrorBarN_KJ({avDeltaPerMin_REMbefore_sal,avDeltaPerMin_REMbefore_cno,avDeltaPerMin_REMafter_sal,avDeltaPerMin_REMafter_cno},'newfig',0,'paired',0);
ylabel('Deltas/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('REM')
makepretty

set(ax,'ylim',[0 1.5])



%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];

figure,
subplot(131)
MakeSpreadAndBoxPlot2_SB({avDeltaPerMin_Wakebefore_basal,avDeltaPerMin_Wakebefore_sal,avDeltaPerMin_Wakebefore_cno, avDeltaPerMin_Wakeafter_basal,avDeltaPerMin_Wakeafter_sal,avDeltaPerMin_Wakeafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('Wake')

subplot(132)
MakeSpreadAndBoxPlot2_SB({avDeltaPerMin_SWSbefore_basal,avDeltaPerMin_SWSbefore_sal,avDeltaPerMin_SWSbefore_cno,avDeltaPerMin_SWSafter_basal,avDeltaPerMin_SWSafter_sal,avDeltaPerMin_SWSafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('NREM')

subplot(133)
MakeSpreadAndBoxPlot2_SB({avDeltaPerMin_REMbefore_basal,avDeltaPerMin_REMbefore_sal,avDeltaPerMin_REMbefore_cno, avDeltaPerMin_REMafter_basal,avDeltaPerMin_REMafter_sal,avDeltaPerMin_REMafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('REM')



%% deltas density during wake -low/high movement)
figure
subplot(131)
MakeBoxPlot_MC({avDeltaPerMin_Wakebefore_basal,avDeltaPerMin_Wakebefore_sal,avDeltaPerMin_Wakebefore_cno, avDeltaPerMin_Wakeafter_basal,avDeltaPerMin_Wakeafter_sal,avDeltaPerMin_Wakeafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('Wake')
% ylim([0 0.25])

subplot(132)
MakeBoxPlot_MC({avDeltaPerMin_Wakebefore_lowMov_basal,avDeltaPerMin_Wakebefore_lowMov_sal, avDeltaPerMin_Wakebefore_lowMov_cno, avDeltaPerMin_Wakeafter_lowMov_basal,avDeltaPerMin_Wakeafter_lowMov_sal, avDeltaPerMin_Wakeafter_lowMov_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('Wake - low movnt')
% ylim([0 0.25])

subplot(133)
MakeBoxPlot_MC({avDeltaPerMin_Wakebefore_highMov_basal,avDeltaPerMin_Wakebefore_highMov_sal, avDeltaPerMin_Wakebefore_highMov_cno, avDeltaPerMin_Wakeafter_highMov_basal,avDeltaPerMin_Wakeafter_highMov_sal, avDeltaPerMin_Wakeafter_highMov_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Deltas/s')
title('Wake - high movnt')
