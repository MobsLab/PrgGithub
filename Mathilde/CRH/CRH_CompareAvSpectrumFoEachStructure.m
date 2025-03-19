%% input dir
DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

%% get the data
%saline condition
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    %load sleep scoring
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %load spectro
    SpectroH{i} = load('dHPC_deep_Low_Spectrum.mat','Spectro');
    SpectroP{i} = load('PFCx_deep_Low_Spectrum.mat','Spectro');
    SpectroOB{i} = load('Bulb_deep_Low_Spectrum.mat','Spectro');
    %get average spectrum from each mouse
    %HPC
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,SpectroH{i});
    avSpectroHPC_Wake_pre_saline(i,:) = sp_WAKE_pre;
    avSpectroHPC_Wake_post_saline(i,:) = sp_WAKE_post;
    avSpectroHPC_SWS_pre_saline(i,:) = sp_SWS_pre;
    avSpectroHPC_SWS_post_saline(i,:) = sp_SWS_post;
    avSpectroHPC_REM_pre_saline(i,:) = sp_REM_pre;
    avSpectroHPC_REM_post_saline(i,:) = sp_REM_post;
    %PFC
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,SpectroP{i});
    avSpectroPFC_Wake_pre_saline(i,:) = sp_WAKE_pre;
    avSpectroPFC_Wake_post_saline(i,:) = sp_WAKE_post;
    avSpectroPFC_SWS_pre_saline(i,:) = sp_SWS_pre;
    avSpectroPFC_SWS_post_saline(i,:) = sp_SWS_post;
    avSpectroPFC_REM_pre_saline(i,:) = sp_REM_pre;
    avSpectroPFC_REM_post_saline(i,:) = sp_REM_post;
    %OBlow
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,SpectroOB{i});
    avSpectroOB_Wake_pre_saline(i,:) = sp_WAKE_pre;
    avSpectroOB_Wake_post_saline(i,:) = sp_WAKE_post;
    avSpectroOB_SWS_pre_saline(i,:) = sp_SWS_pre;
    avSpectroOB_SWS_post_saline(i,:) = sp_SWS_post;
    avSpectroOB_REM_pre_saline(i,:) = sp_REM_pre;
    avSpectroOB_REM_post_saline(i,:) = sp_REM_post;
end


clear SpectroH SpectroOB SpectroP

%cno condition
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    %load sleep scoring
    b{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %load spectro
    SpectroH{j} = load('dHPC_deep_Low_Spectrum.mat','Spectro');
    SpectroP{j} = load('PFCx_deep_Low_Spectrum.mat','Spectro');
    SpectroOB{j} = load('Bulb_deep_Low_Spectrum.mat','Spectro');
    %get average spectrum from each mouse
    %HPC
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,SpectroH{j});
    avSpectroHPC_Wake_pre_cno(j,:) = sp_WAKE_pre;
    avSpectroHPC_Wake_post_cno(j,:) = sp_WAKE_post;
    avSpectroHPC_SWS_pre_cno(j,:) = sp_SWS_pre;
    avSpectroHPC_SWS_post_cno(j,:) = sp_SWS_post;
    avSpectroHPC_REM_pre_cno(j,:) = sp_REM_pre;
    avSpectroHPC_REM_post_cno(j,:) = sp_REM_post;
    %PFC
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,SpectroP{j});
    avSpectroPFC_Wake_pre_cno(j,:) = sp_WAKE_pre;
    avSpectroPFC_Wake_post_cno(j,:) = sp_WAKE_post;
    avSpectroPFC_SWS_pre_cno(j,:) = sp_SWS_pre;
    avSpectroPFC_SWS_post_cno(j,:) = sp_SWS_post;
    avSpectroPFC_REM_pre_cno(j,:) = sp_REM_pre;
    avSpectroPFC_REM_post_cno(j,:) = sp_REM_post;
    %OBlow
    [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,SpectroOB{j});
    avSpectroOB_Wake_pre_cno(j,:) = sp_WAKE_pre;
    avSpectroOB_Wake_post_cno(j,:) = sp_WAKE_post;
    avSpectroOB_SWS_pre_cno(j,:) = sp_SWS_pre;
    avSpectroOB_SWS_post_cno(j,:) = sp_SWS_post;
    avSpectroOB_REM_pre_cno(j,:) = sp_REM_pre;
    avSpectroOB_REM_post_cno(j,:) = sp_REM_post;
end

%% figures
%% normalisé
%wake pre
figure,
subplot(341)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_pre_saline)/max(mean(avSpectroHPC_Wake_pre_saline)),std(avSpectroHPC_Wake_pre_saline)/max(mean(avSpectroHPC_Wake_pre_saline)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_pre_saline)/max(mean(avSpectroPFC_Wake_pre_saline)),std(avSpectroPFC_Wake_pre_saline)/max(mean(avSpectroPFC_Wake_pre_saline)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_pre_saline)/max(mean(avSpectroOB_Wake_pre_saline)),std(avSpectroOB_Wake_pre_saline)/max(mean(avSpectroOB_Wake_pre_saline)),':b',1)
ylim([0 2])
makepretty
ylabel('WAKE')
title('PRE SALINE')
%wake post
% subplot(342)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_post_saline)/max(mean(avSpectroHPC_Wake_post_saline)),std(avSpectroHPC_Wake_post_saline)/max(mean(avSpectroHPC_Wake_post_saline)),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_post_saline)/max(mean(avSpectroPFC_Wake_post_saline)),std(avSpectroPFC_Wake_post_saline)/max(mean(avSpectroPFC_Wake_post_saline)),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_post_saline)/max(mean(avSpectroOB_Wake_post_saline)),std(avSpectroOB_Wake_post_saline)/max(mean(avSpectroOB_Wake_post_saline)),'b',1)
ylim([0 2])
makepretty
title('SALINE')
%sws pre
subplot(345)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_pre_saline)/max(mean(avSpectroHPC_SWS_pre_saline)),std(avSpectroHPC_SWS_pre_saline)/max(mean(avSpectroHPC_SWS_pre_saline)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_pre_saline)/max(mean(avSpectroPFC_SWS_pre_saline)),std(avSpectroPFC_SWS_pre_saline)/max(mean(avSpectroPFC_SWS_pre_saline)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_pre_saline)/max(mean(avSpectroOB_SWS_pre_saline)),std(avSpectroOB_SWS_pre_saline)/max(mean(avSpectroOB_SWS_pre_saline)),':b',1)
ylim([0 2])
makepretty
ylabel('NREM')
%sws post
% subplot(346)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_post_saline)/max(mean(avSpectroHPC_SWS_post_saline)),std(avSpectroHPC_SWS_post_saline)/max(mean(avSpectroHPC_SWS_post_saline)),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_post_saline)/max(mean(avSpectroPFC_SWS_post_saline)),std(avSpectroPFC_SWS_post_saline)/max(mean(avSpectroPFC_SWS_post_saline)),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_post_saline)/max(mean(avSpectroOB_SWS_post_saline)),std(avSpectroOB_SWS_post_saline)/max(mean(avSpectroOB_SWS_post_saline)),'b',1)
ylim([0 2])
makepretty
%rem pre
subplot(349)
shadedErrorBar(frq,mean(avSpectroHPC_REM_pre_saline)/max(mean(avSpectroHPC_REM_pre_saline)),std(avSpectroHPC_REM_pre_saline)/max(mean(avSpectroHPC_REM_pre_saline)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_pre_saline)/max(mean(avSpectroPFC_REM_pre_saline)),std(avSpectroPFC_REM_pre_saline)/max(mean(avSpectroPFC_REM_pre_saline)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_pre_saline)/max(mean(avSpectroOB_REM_pre_saline)),std(avSpectroOB_REM_pre_saline)/max(mean(avSpectroOB_REM_pre_saline)),':b',1)
ylim([0 2])
makepretty
ylabel('REM')
%rem post
% subplot(3,4,10)
shadedErrorBar(frq,mean(avSpectroHPC_REM_post_saline)/max(mean(avSpectroHPC_REM_post_saline)),std(avSpectroHPC_REM_post_saline)/max(mean(avSpectroHPC_REM_post_saline)),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_post_saline)/max(mean(avSpectroPFC_REM_post_saline)),std(avSpectroPFC_REM_post_saline)/max(mean(avSpectroPFC_REM_post_saline)),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_post_saline)/max(mean(avSpectroOB_REM_post_saline)),std(avSpectroOB_REM_post_saline)/max(mean(avSpectroOB_REM_post_saline)),'b',1)
ylim([0 2])
makepretty
%%%
%wake pre cno
% figure,
subplot(343)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_pre_cno)/max(mean(avSpectroHPC_Wake_pre_cno)),std(avSpectroHPC_Wake_pre_cno)/max(mean(avSpectroHPC_Wake_pre_cno)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_pre_cno)/max(mean(avSpectroPFC_Wake_pre_cno)),std(avSpectroPFC_Wake_pre_cno)/max(mean(avSpectroPFC_Wake_pre_cno)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_pre_cno)/max(mean(avSpectroOB_Wake_pre_cno)),std(avSpectroOB_Wake_pre_cno)/max(mean(avSpectroOB_Wake_pre_cno)),':b',1)
ylim([0 2])
makepretty
ylabel('WAKE')
title('PRE CNO')
%wake post cno
% subplot(344)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_post_cno)/max(mean(avSpectroHPC_Wake_post_cno)),std(avSpectroHPC_Wake_post_cno)/max(mean(avSpectroHPC_Wake_post_cno)),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_post_cno)/max(mean(avSpectroPFC_Wake_post_cno)),std(avSpectroPFC_Wake_post_cno)/max(mean(avSpectroPFC_Wake_post_cno)),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_post_cno)/max(mean(avSpectroOB_Wake_post_cno)),std(avSpectroOB_Wake_post_cno)/max(mean(avSpectroOB_Wake_post_cno)),'b',1)
ylim([0 2])
makepretty
title('CNO')
%sws pre cno
subplot(347)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_pre_cno)/max(mean(avSpectroHPC_SWS_pre_cno)),std(avSpectroHPC_SWS_pre_cno)/max(mean(avSpectroHPC_SWS_pre_cno)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_pre_cno)/max(mean(avSpectroPFC_SWS_pre_cno)),std(avSpectroPFC_SWS_pre_cno)/max(mean(avSpectroPFC_SWS_pre_cno)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_pre_cno)/max(mean(avSpectroOB_SWS_pre_cno)),std(avSpectroOB_SWS_pre_cno)/max(mean(avSpectroOB_SWS_pre_cno)),':b',1)
ylim([0 2])
makepretty
ylabel('NREM')
%sws post cno
% subplot(348)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_post_cno)/max(mean(avSpectroHPC_SWS_post_cno)),std(avSpectroHPC_SWS_post_cno)/max(mean(avSpectroHPC_SWS_post_cno)),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_post_cno)/max(mean(avSpectroPFC_SWS_post_cno)),std(avSpectroPFC_SWS_post_cno)/max(mean(avSpectroPFC_SWS_post_cno)),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_post_cno)/max(mean(avSpectroOB_SWS_post_cno)),std(avSpectroOB_SWS_post_cno)/max(mean(avSpectroOB_SWS_post_cno)),'b',1)
ylim([0 2])
makepretty
%rem pre cno
subplot(3,4,11)
shadedErrorBar(frq,mean(avSpectroHPC_REM_pre_cno)/max(mean(avSpectroHPC_REM_pre_cno)),std(avSpectroHPC_REM_pre_cno)/max(mean(avSpectroHPC_REM_pre_cno)),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_pre_cno)/max(mean(avSpectroPFC_REM_pre_cno)),std(avSpectroPFC_REM_pre_cno)/max(mean(avSpectroPFC_REM_pre_cno)),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_pre_cno)/max(mean(avSpectroOB_REM_pre_cno)),std(avSpectroOB_REM_pre_cno)/max(mean(avSpectroOB_REM_pre_cno)),':b',1)
ylim([0 2])
makepretty
ylabel('REM')
%rem post cno
% subplot(3,4,12)
shadedErrorBar(frq,nanmean(avSpectroHPC_REM_post_cno)/max(nanmean(avSpectroHPC_REM_post_cno)),std(avSpectroHPC_REM_post_cno)/max(nanmean(avSpectroHPC_REM_post_cno)),'k',1),hold on
shadedErrorBar(frq,nanmean(avSpectroPFC_REM_post_cno)/max(nanmean(avSpectroPFC_REM_post_cno)),std(avSpectroPFC_REM_post_cno)/max(nanmean(avSpectroPFC_REM_post_cno)),'r',1)
shadedErrorBar(frq,nanmean(avSpectroOB_REM_post_cno)/max(nanmean(avSpectroOB_REM_post_cno)),std(avSpectroOB_REM_post_cno)/max(nanmean(avSpectroOB_REM_post_cno)),'b',1)
ylim([0 2])
makepretty

%% non normalisé
%wake pre
figure,
subplot(341)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_pre_saline),std(avSpectroHPC_Wake_pre_saline),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_pre_saline),std(avSpectroPFC_Wake_pre_saline),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_pre_saline),std(avSpectroOB_Wake_pre_saline),':b',1)
makepretty
ylabel('WAKE')
title('PRE SALINE')
%wake post
% subplot(342)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_post_saline),std(avSpectroHPC_Wake_post_saline),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_post_saline),std(avSpectroPFC_Wake_post_saline),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_post_saline),std(avSpectroOB_Wake_post_saline),'b',1)
makepretty
title('SALINE')
%sws pre
subplot(345)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_pre_saline),std(avSpectroHPC_SWS_pre_saline),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_pre_saline),std(avSpectroPFC_SWS_pre_saline),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_pre_saline),std(avSpectroOB_SWS_pre_saline),':b',1)
makepretty
ylabel('NREM')
%sws post
% subplot(346)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_post_saline),std(avSpectroHPC_SWS_post_saline),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_post_saline),std(avSpectroPFC_SWS_post_saline),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_post_saline),std(avSpectroOB_SWS_post_saline),'b',1)
makepretty

%rem pre
subplot(349)
shadedErrorBar(frq,mean(avSpectroHPC_REM_pre_saline),std(avSpectroHPC_REM_pre_saline),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_pre_saline),std(avSpectroPFC_REM_pre_saline),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_pre_saline),std(avSpectroOB_REM_pre_saline),':b',1)
makepretty
ylabel('REM')
%rem post
% subplot(3,4,10)
shadedErrorBar(frq,mean(avSpectroHPC_REM_post_saline),std(avSpectroHPC_REM_post_saline),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_post_saline),std(avSpectroPFC_REM_post_saline),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_post_saline),std(avSpectroOB_REM_post_saline),'b',1)
makepretty


%
%wake pre cno
% figure,
subplot(343)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_pre_cno),std(avSpectroHPC_Wake_pre_cno),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_pre_cno),std(avSpectroPFC_Wake_pre_cno),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_pre_cno),std(avSpectroOB_Wake_pre_cno),':b',1)
makepretty
ylabel('WAKE')
title('PRE CNO')
%wake post cno
% subplot(344)
shadedErrorBar(frq,mean(avSpectroHPC_Wake_post_cno),std(avSpectroHPC_Wake_post_cno),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_Wake_post_cno),std(avSpectroPFC_Wake_post_cno),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_Wake_post_cno),std(avSpectroOB_Wake_post_cno),'b',1)
makepretty
title('CNO')
%sws pre cno
subplot(347)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_pre_cno),std(avSpectroHPC_SWS_pre_cno),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_pre_cno),std(avSpectroPFC_SWS_pre_cno),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_pre_cno),std(avSpectroOB_SWS_pre_cno),':b',1)
makepretty
ylabel('NREM')
%sws post cno
% subplot(348)
shadedErrorBar(frq,mean(avSpectroHPC_SWS_post_cno),std(avSpectroHPC_SWS_post_cno),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_SWS_post_cno),std(avSpectroPFC_SWS_post_cno),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_SWS_post_cno),std(avSpectroOB_SWS_post_cno),'b',1)
makepretty

%rem pre cno
subplot(3,4,11)
shadedErrorBar(frq,mean(avSpectroHPC_REM_pre_cno),std(avSpectroHPC_REM_pre_cno),':k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_pre_cno),std(avSpectroPFC_REM_pre_cno),':r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_pre_cno),std(avSpectroOB_REM_pre_cno),':b',1)
makepretty
ylabel('REM')
%rem post cno
% subplot(3,4,12)
shadedErrorBar(frq,mean(avSpectroHPC_REM_post_cno),std(avSpectroHPC_REM_post_cno),'k',1),hold on
shadedErrorBar(frq,mean(avSpectroPFC_REM_post_cno),std(avSpectroPFC_REM_post_cno),'r',1)
shadedErrorBar(frq,mean(avSpectroOB_REM_post_cno),std(avSpectroOB_REM_post_cno),'b',1)
makepretty