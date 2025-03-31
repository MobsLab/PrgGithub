cd /media/nas4/ProjetMTZL/Mouse778/20181218
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
[numNeurons, numtt, TT]=GetSpikesFromStructure('Bulb', 'remove_MUA',1);
figure
[Y,X] = hist((PhasesSpikes.Transf{numNeurons(1)}),30);
bar([X,X+2*pi], [Y,Y],'FaceColor', [0.6 0 0],'EdgeColor', [0.6 0 0])
CheckMyUnit_SB(TT{numNeurons(1)},intervalSet(0,100000*1E4))

cd /media/nas4/ProjetMTZL/Mouse778/20181213
 load('/media/nas4/ProjetMTZL/Mouse778/20181213/NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
[numNeurons, numtt, TT]=GetSpikesFromStructure('Bulb', 'remove_MUA',1);
figure
[Y,X] = hist((PhasesSpikes.Transf{numNeurons(1)}),30);
bar([X,X+2*pi], [Y,Y],'FaceColor', [0.6 0 0],'EdgeColor', [0.6 0 0])
box off
CheckMyUnit_SB(TT{numNeurons(1)},intervalSet(0,100000*1E4))
