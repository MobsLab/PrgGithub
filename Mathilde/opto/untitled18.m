
Dir{2}=PathForExperiments_Opto('Stim_20Hz');
number = 1;

for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    
    [Mrem,Mwake,Msws] = GetEvokedPotentialVLPO_MC(Wake,REMEpoch,SWSEpoch);
    matWake{i}=Mwake;
    matREM{i}=Mrem;
    matSWS{i}=Msws;
    
  clear Mwake
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end

dataREM=cat(3,matREM{:});
dataWake=cat(3,matWake{:});
dataSWS=cat(3,matSWS{:});

AvdataREM=nanmean(dataREM,3); 
AvdataWake=nanmean(dataWake,3); 
AvdataSWS=nanmean(dataSWS,3); 

figure, hold on, plot(AvdataWake(:,1),AvdataWake(:,2),'b')
plot(AvdataSWS(:,1),AvdataSWS(:,2),'r')
plot(AvdataREM(:,1),AvdataREM(:,2),'g')

legend('Wake','NREM','REM')

