% Example units from M778 that are well locked to freezing
cd /media/nas4/ProjetMTZL/Mouse778/20181218

[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
unitnum = 19;
load('SpikeData.mat')
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
load('SleepSubstages.mat')
figure(3)
Phasetsd = tsd(Range(Restrict(S{numNeurons(unitnum)},epoch)), PhasesSpikes.Transf{numNeurons(unitnum)});
for ep = 1:5
subplot(2,3,ep)
hist([Data(Restrict(Phasetsd,Epoch{ep}));Data(Restrict(Phasetsd,Epoch{ep}))+2*pi],30)
title(NameEpoch{ep})
end
CheckMyUnit_SB(TT{numNeurons(unitnum)},epoch)

[numNeurons, numtt, TT]=GetSpikesFromStructure('Bulb', 'remove_MUA',1);
unitnum = 1;
load('SpikeData.mat')
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
load('SleepSubstages.mat')
figure
Phasetsd = tsd(Range(Restrict(S{numNeurons(unitnum)},epoch)), PhasesSpikes.Transf{numNeurons(unitnum)});
for ep = 1:5
subplot(2,3,ep)
hist([Data(Restrict(Phasetsd,Epoch{ep}));Data(Restrict(Phasetsd,Epoch{ep}))+2*pi],30)
title(NameEpoch{ep})
end
CheckMyUnit_SB(TT{numNeurons(unitnum)},epoch)