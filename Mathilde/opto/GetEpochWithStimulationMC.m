function [test_interval] = GetEpochWithStimulationMC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,stimulations,timebin)

tempbin=timebin*1E4;

SleepStage=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);close
tps=Range(SleepStage);

rg = [(0:tempbin:tps(end))];

timevec = [];
for i=2:length(rg)
    timevec = [timevec; [rg(i-1), rg(i)]];
    i=i+1;
end

istim=1;
while (stimulations(istim)<timevec(end,2) && istim<length(stimulations))
    epoch_with_stim(istim) = find((stimulations(istim)>timevec(:,1)) + (stimulations(istim)<timevec(:,2))==2);% donne l'index de l'epoch ou il y a au moins une stim en REM
    istim=istim+1;
end


idx_epoch_with_stim = unique(epoch_with_stim); %enlever les doublons (=interval où il y a plusieurs stims)

for iidx=1:length(idx_epoch_with_stim)
    test_interval(iidx)= intervalSet((timevec(idx_epoch_with_stim(iidx),1)), (timevec(idx_epoch_with_stim(iidx),2))); %re créer les epoch avec des stims
end

