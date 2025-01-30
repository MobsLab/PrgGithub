% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
number = 1;

for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    load SleepScoring_OBGamma WakeWiNoise REMEpochWiNoise SWSEpochWiNoise 
    
    %     [Mrem,Mwake,Msws] = GetEMG_MC(Wake,REMEpoch,SWSEpoch);
    
    [MatRemVLPO,MatWakeVLPO,MatSwsVLPO,MatAllVLPO] = GetEvokedPotentialVLPO_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,0);
    [MatRemPFC,MatWakePFC,MatSwsPFC,MatAllPFC] = GetEvokedPotentialPFC_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,0);
    [MatRemOB,MatWakeOB,MatSwsOB,MatAllOB] = GetEvokedPotentialOB_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,0);
    [MatRemHPC,MatWakeHPC,MatSwsHPC,MatAllHPC] = GetEvokedPotentialHPC_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,0);
    
    RemVLPO{i}=MatRemVLPO;
    RemPFC{i}=MatRemPFC;
    RemHPC{i}=MatRemHPC;
    RemOB{i}=MatRemOB;
    
    SwsVLPO{i}=MatSwsVLPO;
    SwsPFC{i}=MatSwsPFC;
    SwsHPC{i}=MatSwsHPC;
    SwsOB{i}=MatSwsOB;
    
    WakeVLPO{i}=MatWakeVLPO;
    WakePFC{i}=MatWakePFC;
    WakeHPC{i}=MatWakeHPC;
    WakeOB{i}=MatWakeOB;
    
    
    
    allVLPO{i}=MatAllVLPO;
    allPFC{i}=MatAllPFC;
    allHPC{i}=MatAllHPC;
    allOB{i}=MatAllOB;
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end
%%
dataRemVLPO=cat(3,RemVLPO{:});
dataRemHPC=cat(3,RemHPC{:});
dataRemPFC=cat(3,RemPFC{:});
dataRemOB=cat(3,RemOB{:});

dataSwsVLPO=cat(3,SwsVLPO{:});
dataSwsHPC=cat(3,SwsHPC{:});
dataSwsPFC=cat(3,SwsPFC{:});
dataSwsOB=cat(3,SwsOB{:});

dataWakeVLPO=cat(3,WakeVLPO{:});
dataWakeHPC=cat(3,WakeHPC{:});
dataWakePFC=cat(3,WakePFC{:});
dataWakeOB=cat(3,WakeOB{:});

dataAllVLPO=cat(3,allVLPO{:});
dataAllHPC=cat(3,allHPC{:});
dataAllPFC=cat(3,allPFC{:});
dataAllOB=cat(3,allOB{:});


AvdataRemVLPO=nanmean(dataRemVLPO,3); 
AvdataRemPFC=nanmean(dataRemPFC,3);
AvdataRemHPC=nanmean(dataRemHPC,3);
AvdataRemOB=nanmean(dataRemOB,3);

AvdataSwsVLPO=nanmean(dataSwsVLPO,3); 
AvdataSwsPFC=nanmean(dataSwsPFC,3);
AvdataSwsHPC=nanmean(dataSwsHPC,3);
AvdataSwsOB=nanmean(dataSwsOB,3);

AvdataWakeVLPO=nanmean(dataWakeVLPO,3); 
AvdataWakePFC=nanmean(dataWakePFC,3);
AvdataWakeHPC=nanmean(dataWakeHPC,3);
AvdataWakeOB=nanmean(dataWakeOB,3);


AvdataAllVLPO=nanmean(dataAllVLPO,3); 
AvdataAllPFC=nanmean(dataAllPFC,3);
AvdataAllHPC=nanmean(dataAllHPC,3);
AvdataAllOB=nanmean(dataAllOB,3);


%% OB
figure,subplot(411), plot(AvdataRemOB(:,1),AvdataRemOB(:,2),'b','linewidth',2)
hold on
plot(AvdataRemVLPO(:,1),1000+AvdataRemVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('REM')
legend('OB','VLPO')

subplot(412), plot(AvdataSwsOB(:,1),AvdataSwsOB(:,2),'b','linewidth',2)
hold on
plot(AvdataSwsVLPO(:,1),1000+AvdataSwsVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('NREM')
legend('OB','VLPO')

subplot(413), plot(AvdataWakeOB(:,1),AvdataWakeOB(:,2),'b','linewidth',2)
hold on
plot(AvdataWakeVLPO(:,1),1000+AvdataWakeVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('Wake')
legend('OB','VLPO')

subplot(414), plot(AvdataAllOB(:,1),AvdataAllOB(:,2),'b','linewidth',2)
hold on
plot(AvdataAllVLPO(:,1),1000+AvdataAllVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('All')
legend('OB','VLPO')
suptitle('OB')
%% PFC
figure,subplot(411),plot(AvdataRemPFC(:,1),AvdataRemPFC(:,2),'b','linewidth',2)
hold on
plot(AvdataRemVLPO(:,1),700+AvdataRemVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('REM')
legend('PFC','VLPO')

subplot(412),plot(AvdataSwsPFC(:,1),AvdataSwsPFC(:,2),'b','linewidth',2)
hold on
plot(AvdataSwsVLPO(:,1),700+AvdataSwsVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('NREM')
legend('PFC','VLPO')

subplot(413),plot(AvdataWakePFC(:,1),AvdataWakePFC(:,2),'b','linewidth',2)
hold on
plot(AvdataWakeVLPO(:,1),700+AvdataWakeVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('Wake')
legend('PFC','VLPO')

subplot(414),plot(AvdataAllPFC(:,1),AvdataAllPFC(:,2),'b','linewidth',2)
hold on
plot(AvdataAllVLPO(:,1),700+AvdataAllVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('All')
legend('PFC','VLPO')
suptitle('PFC')
%% HPC
figure, subplot(411), plot(AvdataRemHPC(:,1),AvdataRemHPC(:,2),'b','linewidth',2)
hold on
plot(AvdataRemVLPO(:,1),1000+AvdataRemVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('REM')
legend('HPC','VLPO')

subplot(412), plot(AvdataSwsHPC(:,1),AvdataSwsHPC(:,2),'b','linewidth',2)
hold on
plot(AvdataSwsVLPO(:,1),1000+AvdataSwsVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('NREM')
legend('HPC','VLPO')

subplot(413), plot(AvdataWakeHPC(:,1),AvdataWakeHPC(:,2),'b','linewidth',2)
hold on
plot(AvdataWakeVLPO(:,1),1000+AvdataWakeVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('Wake')
legend('HPC','VLPO')
 
subplot(414), plot(AvdataAllHPC(:,1),AvdataAllHPC(:,2),'b','linewidth',2)
hold on
plot(AvdataAllVLPO(:,1),1000+AvdataAllVLPO(:,2),'k','linewidth',2)
xlim([-0.1 +0.5])
ylim([-800 +2500])
line([0 0], ylim,'color','k','linestyle',':')
title('All')
legend('HPC','VLPO')
suptitle('HPC')