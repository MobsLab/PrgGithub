%AnalysisKB10052019.m
[Dir24,nameSessions]=NREMstages_path('SD24h');
[Dir6h,nameSessions]=NREMstages_path('SD6h');
[DirOR,nameSessions]=NREMstages_path('OR');

k=4; n=4; cd(Dir6h{k,n}), nameSessions{n}

load behavResources NewtsdZT
try
    load AllDeltaPFCx DeltaEpoch
end
try
    load DeltaWaves 
    DeltaEpoch=deltas_PFCx;
end

load NREMepochsML op
homeo{1}=op{4};
homeo{2}=op{6};
homeo{3}=op{5};
homeo{4}=NewtsdZT;
homeo{5}=DeltaEpoch;
homeo{6}=1;
figure, subplot(1,4,1:3), hold on
[val,tps]=SleepHomeostasisSleepCycleFunction(homeo);
subplot(1,4,4), 
bar([ sum(End(op{5},'s')-Start(op{5},'s')) sum(End(op{6},'s')-Start(op{6},'s')) sum(End(op{4},'s')-Start(op{4},'s'))]/60,1,'k'); title(num2str([sum(End(op{4},'s')-Start(op{4},'s'))/(sum(End(op{4},'s')-Start(op{4},'s'))+sum(End(op{6},'s')-Start(op{6},'s')))*100]))
clear op DeltaEpoch NewtsdZT




% 
% j'ai mes les lignes de code dans NeuronsPhasesForKB.m
% il y a aussi un path for experiment avec des jours d'enregsitrement dans le plethysmo
% par contre fais gaffe il y a de methimazole
% et si tu veux recalculer des phases avec tes propres paramètres:
% GetModulationAllUnits_FreqBand_SB
% ça te permet de calculer pour une bande de frqeunce donnée et un channel to analyse donné la phase de tous les neurones

% GetModulationAllUnits_FreqBand_SB
% 
% NeuronsPhasesForKB


