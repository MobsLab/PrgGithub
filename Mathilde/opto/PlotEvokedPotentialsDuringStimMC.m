% DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% 
% 
% for j=1:length(DirOpto.path)
%     cd(DirOpto.path{j}{1});
%     clear all
    
load('SleepScoring_OBGamma','WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
stim = load('StimOpto_new.mat');

[MREM_VLPO,MSWS_VLPO,MWAKE_VLPO,MALL_VLPO] = GetEvokedPotentialsDuringStim_MC(stim,WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,'vlpo',0);
[MREM_PFC,MSWS_PFC,MWAKE_PFC,MALL_PFC] = GetEvokedPotentialsDuringStim_MC(stim,WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,'pfc',0);
[MREM_HPC,MSWS_HPC,MWAKE_HPC,MALL_HPC] = GetEvokedPotentialsDuringStim_MC(stim,WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,'hpc',0);
[MREM_OB,MSWS_OB,MWAKE_OB,MALL_OB] = GetEvokedPotentialsDuringStim_MC(stim,WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,'ob',0);

%%
figure, 
subplot(411),
plot(MWAKE_VLPO(:,1),MWAKE_VLPO(:,2),'k'), hold on
plot(MWAKE_OB(:,1),2000+MWAKE_OB(:,2),'b')
plot(MWAKE_PFC(:,1),100+MWAKE_PFC(:,2),'r')
plot(MWAKE_HPC(:,1),900+MWAKE_HPC(:,2),'c')
xlim([-0.15 0.5])
ylim([-1500 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('WAKE')

legend({'VLPO','OB','PFC','HPC'},'location','southwest')

subplot(412),
plot(MSWS_VLPO(:,1),MSWS_VLPO(:,2),'k'), hold on
plot(MSWS_OB(:,1),2000+MSWS_OB(:,2),'b')
plot(MSWS_PFC(:,1),100+MSWS_PFC(:,2),'r')
plot(MSWS_HPC(:,1),900+MSWS_HPC(:,2),'c')
xlim([-0.15 0.5])
ylim([-1500 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('NREM')

subplot(413),
plot(MREM_VLPO(:,1),MREM_VLPO(:,2),'k'), hold on
plot(MREM_OB(:,1),2000+MREM_OB(:,2),'b')
plot(MREM_PFC(:,1),100+MREM_PFC(:,2),'r')
plot(MREM_HPC(:,1),900+MREM_HPC(:,2),'c')
xlim([-0.15 0.5])
ylim([-1500 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('REM')

subplot(414),
plot(MALL_VLPO(:,1),MALL_VLPO(:,2),'k'), hold on
plot(MALL_OB(:,1),2000+MALL_OB(:,2),'b')
plot(MALL_PFC(:,1),100+MALL_PFC(:,2),'r')
plot(MALL_HPC(:,1),900+MALL_HPC(:,2),'c')
xlim([-0.15 0.5])
ylim([-1500 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('ALL')

% end
