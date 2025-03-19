% DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirOpto=RestrictPathForExperiment(DirOpto,'nMice',[648 675 733 1074 1076 1109 1137]);
DirOpto=PathForExperiments_Opto_MC('SST_Stim_20Hz');

for i=1:length(DirOpto.path)
    cd(DirOpto.path{i}{1});
%     clear all
    
a{i} = load('SleepScoring_OBGamma','WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');

% stim{i} = load('StimOpto_new.mat');
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise);
stim{i}=Stim;

[MALL_VLPO] = GetEvokedPotentialsDuringStim_MC(stim{i},a{i}.WakeWiNoise,a{i}.REMEpochWiNoise,a{i}.SWSEpochWiNoise,'vlpo',0);
tps(:,i) = MALL_VLPO(:,1);
% MREM_VLPO_opto(:,i) = MREM_VLPO(:,2);
% MSWS_VLPO_opto(:,i) = MSWS_VLPO(:,2);
% MWAKE_VLPO_opto(:,i) = MWAKE_VLPO(:,2);
MALL_VLPO_opto(:,i) = MALL_VLPO(:,2);

[MALL_PFC] = GetEvokedPotentialsDuringStim_MC(stim{i},a{i}.WakeWiNoise,a{i}.REMEpochWiNoise,a{i}.SWSEpochWiNoise,'pfc',0);
% MREM_PFC_opto(:,i) = MREM_PFC(:,2);
% MSWS_PFC_opto(:,i) = MSWS_PFC(:,2);
% MWAKE_PFC_opto(:,i) = MWAKE_PFC(:,2);
MALL_PFC_opto(:,i) = MALL_PFC(:,2);

[MALL_HPC] = GetEvokedPotentialsDuringStim_MC(stim{i},a{i}.WakeWiNoise,a{i}.REMEpochWiNoise,a{i}.SWSEpochWiNoise,'hpc',0);
% MREM_HPC_opto(:,i) = MREM_HPC(:,2);
% MSWS_HPC_opto(:,i) = MSWS_HPC(:,2);
% MWAKE_HPC_opto(:,i) = MWAKE_HPC(:,2);
MALL_HPC_opto(:,i) = MALL_HPC(:,2);

[MALL_OB] = GetEvokedPotentialsDuringStim_MC(stim{i},a{i}.WakeWiNoise,a{i}.REMEpochWiNoise,a{i}.SWSEpochWiNoise,'ob',0);
% MREM_OB_opto(:,i) = MREM_OB(:,2);
% MSWS_OB_opto(:,i) = MSWS_OB(:,2);
% MWAKE_OB_opto(:,i) = MWAKE_OB(:,2);
MALL_OB_opto(:,i) = MALL_OB(:,2);

end

%%
figure, plot(tps(:,1), MALL_VLPO_opto(:,imouse)), xlim([-0.2 1])

%%
figure, 
subplot(411),
plot(tps(:,1),mean(MWAKE_VLPO_opto,2),'k'), hold on
plot(tps(:,1),600+mean(MWAKE_OB_opto,2),'b')
plot(tps(:,1),50+mean(MWAKE_PFC_opto,2),'r')
plot(tps(:,1),300+mean(MWAKE_HPC_opto,2),'c')
xlim([-0.15 0.5])
% ylim([-1500 4000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('WAKE')

legend({'VLPO','OB','PFC','HPC'},'location','southwest')

subplot(412),
plot(tps(:,1),mean(MSWS_VLPO_opto,2),'k'), hold on
plot(tps(:,1),600+mean(MSWS_OB_opto,2),'b')
plot(tps(:,1),50+mean(MSWS_PFC_opto,2),'r')
plot(tps(:,1),300+mean(MSWS_HPC_opto,2),'c')
xlim([-0.15 0.5])
% ylim([-1500 4000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('NREM')

subplot(413),
plot(tps(:,1),mean(MREM_VLPO_opto,2),'k'), hold on
plot(tps(:,1),600+mean(MREM_OB_opto,2),'b')
plot(tps(:,1),50+mean(MREM_PFC_opto,2),'r')
plot(tps(:,1),300+mean(MREM_HPC_opto,2),'c')
xlim([-0.15 0.5])
% ylim([-1500 4000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('REM')

subplot(414),
plot(tps(:,1),mean(MALL_VLPO_opto,2),'k'), hold on
plot(tps(:,1),600+mean(MALL_OB_opto,2),'b')
plot(tps(:,1),50+mean(MALL_PFC_opto,2),'r')
plot(tps(:,1),300+mean(MALL_HPC_opto,2),'c')
xlim([-0.15 0.5])
% ylim([-1500 4000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('ALL')


%%
figure, 
subplot(411),
shadedErrorBar(tps(:,1),mean(MWAKE_VLPO_opto,2), std(MWAKE_VLPO_opto'),'k'), hold on
shadedErrorBar(tps(:,1),2000+mean(MWAKE_OB_opto,2), std(MWAKE_OB_opto'),'b')
shadedErrorBar(tps(:,1),700+mean(MWAKE_PFC_opto,2), std(MWAKE_PFC_opto'),'r')
shadedErrorBar(tps(:,1),1500+mean(MWAKE_HPC_opto,2), std(MWAKE_HPC_opto'),'c')
xlim([-0.15 0.5])
ylim([-1000 3000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('WAKE')

legend({'VLPO','OB','PFC','HPC'},'location','southwest')

subplot(412),
shadedErrorBar(tps(:,1),mean(MSWS_VLPO_opto,2), std(MSWS_VLPO_opto'),'k'), hold on
shadedErrorBar(tps(:,1),2000+mean(MSWS_OB_opto,2), std(MSWS_OB_opto'),'b')
shadedErrorBar(tps(:,1),700+mean(MSWS_PFC_opto,2), std(MSWS_PFC_opto'),'r')
shadedErrorBar(tps(:,1),1500+mean(MSWS_HPC_opto,2), std(MSWS_HPC_opto'),'c')
xlim([-0.15 0.5])
ylim([-1000 3000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('NREM')

subplot(413),
shadedErrorBar(tps(:,1),mean(MREM_VLPO_opto,2), std(MREM_VLPO_opto'),'k'), hold on
shadedErrorBar(tps(:,1),2000+mean(MREM_OB_opto,2), std(MREM_OB_opto'),'b')
shadedErrorBar(tps(:,1),700+mean(MREM_PFC_opto,2), std(MREM_PFC_opto'),'r')
shadedErrorBar(tps(:,1),1500+mean(MREM_HPC_opto,2), std(MREM_HPC_opto'),'c')
xlim([-0.15 0.5])
ylim([-1000 3000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('REM')

subplot(414),
shadedErrorBar(tps(:,1),mean(MALL_VLPO_opto,2), std(MALL_VLPO_opto'),'k'), hold on
shadedErrorBar(tps(:,1),2000+mean(MALL_OB_opto,2), std(MALL_OB_opto'),'b')
shadedErrorBar(tps(:,1),700+mean(MALL_PFC_opto,2), std(MALL_PFC_opto'),'r')
shadedErrorBar(tps(:,1),1500+mean(MALL_HPC_opto,2), std(MALL_HPC_opto'),'c')
xlim([-0.15 0.5])
ylim([-1000 3000])
line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('ALL')

%% figure pour chaque souris


for imouse=1:length(DirOpto.path)
    figure, 

subplot(411),
plot(tps(:,1),MWAKE_VLPO_opto(:,imouse),'k'), hold on
plot(tps(:,1),2000+MWAKE_OB_opto(:,imouse),'b')
plot(tps(:,1),700+MWAKE_PFC_opto(:,imouse),'r')
plot(tps(:,1),1500+MWAKE_HPC_opto(:,imouse),'c')
xlim([-0.15 0.5])
ylim([-1000 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('WAKE')

legend({'VLPO','OB','PFC','HPC'},'location','southwest')

subplot(412),
plot(tps(:,1),MSWS_VLPO_opto(:,imouse),'k'), hold on
plot(tps(:,1),2000+MSWS_OB_opto(:,imouse),'b')
plot(tps(:,1),700+MSWS_PFC_opto(:,imouse),'r')
plot(tps(:,1),1500+MSWS_HPC_opto(:,imouse),'c')
xlim([-0.15 0.5])
ylim([-1000 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('NREM')

subplot(413),
plot(tps(:,1),MREM_VLPO_opto(:,imouse),'k'), hold on
plot(tps(:,1),2000+MREM_OB_opto(:,imouse),'b')
plot(tps(:,1),700+MREM_PFC_opto(:,imouse),'r')
plot(tps(:,1),1500+MREM_HPC_opto(:,imouse),'c')
xlim([-0.15 0.5])
ylim([-1000 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('REM')

subplot(414),
plot(tps(:,1),MALL_VLPO_opto(:,imouse),'k'), hold on
plot(tps(:,1),2000+MALL_OB_opto(:,imouse),'b')
plot(tps(:,1),700+MALL_PFC_opto(:,imouse),'r')
plot(tps(:,1),1500+MALL_HPC_opto(:,imouse),'c')
xlim([-0.15 0.5])
ylim([-1000 4000])

line([0 0], ylim,'color','k','linestyle',':', 'linewidth',2)
makepretty
title('ALL')
end