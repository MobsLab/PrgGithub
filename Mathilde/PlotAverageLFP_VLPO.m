% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');

Dir{2}=PathForExperiments_Opto('Stim_20Hz');
number = 1;

for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    
%     [Mrem,Mwake,Msws] = GetEMG_MC(Wake,REMEpoch,SWSEpoch);
%     [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialVLPO_MC(Wake,REMEpoch,SWSEpoch);
%     [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialPFC_MC(Wake,REMEpoch,SWSEpoch);
    [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialOB_MC(Wake,REMEpoch,SWSEpoch);
    
%     [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialHPC_MC(Wake,REMEpoch,SWSEpoch);
    
    w{i}=Mwake;
    r{i}=Mrem;
    
    s{i}=Msws;
    tot{i}=Mtot;
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end

dataREM=cat(3,r{:});
dataWake=cat(3,w{:});
dataSWS=cat(3,s{:});
datatot=cat(3,tot{:});


AvdataREM=nanmean(dataREM,3); 
AvdataWake=nanmean(dataWake,3); 
AvdataSWS=nanmean(dataSWS,3); 
Avdatatot=nanmean(datatot,3); 


%%
figure, subplot(411),  plot(AvdataWake(:,1),AvdataWake(:,2),'b')
ylabel('Amplitude')
line([0 0], ylim,'color','k','linestyle',':')
% ylim([-500 +800])
title('wake')
subplot(412), plot(AvdataSWS(:,1),AvdataSWS(:,2),'r')
ylabel('Amplitude')
line([0 0], ylim,'color','k','linestyle',':')
% ylim([-500 +800])
title('NREM')
subplot(413), plot(AvdataREM(:,1),AvdataREM(:,2),'g')
ylabel('Amplitude')
line([0 0], ylim,'color','k','linestyle',':')
% ylim([-500 +800])
title('REM')
subplot(414), plot(Avdatatot(:,1),Avdatatot(:,2),'k')
ylabel('Amplitude')
line([0 0], ylim,'color','k','linestyle',':')
ylim([-1000 +1000])
title('all')
% xlim([-1 +3])
xlabel('Time (s)')

