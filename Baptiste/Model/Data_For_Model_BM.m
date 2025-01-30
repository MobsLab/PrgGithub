

Mouse = [893];
% bin de freezing tous les 2s et avoir
% sa fréquence et d'associer à chaque bin
% la position normalisée,
% le temps global dans le conditionnement (qui sert pour situer dans l'apprentissage) et
% le temps depuis le dernier choc.


Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM','linearposition');
end


i=1;
for ep=1:length(Start(Epoch1.Cond{1, 3}))
   AShockTime_Fz_Distance_pre = Start(Epoch1.Cond{1, 2})-Start(subset(Epoch1.Cond{1, 3},ep));
   AShockTime_Fz_Distance = abs(max(AShockTime_Fz_Distance_pre(AShockTime_Fz_Distance_pre<0))/1e4);
end
   if isempty(ShockTime_Fz_Distance); ShockTime_Fz_Distance=NaN; end
       
   for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1 % bin of 2s or less

       SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{1, 3},ep))+2*(bin)*1e4);
       PositionArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
       OB_FrequencyArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));       
       GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(bin-1);       
       TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(bin-1);       
       TimepentFreezing(i) = 2*(bin-1);       
       i=i+1;
   end
   
   ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{1, 3},ep))-Start(subset(Epoch1.Cond{1, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice
   
   SmallEpoch = intervalSet(Start(subset(Epoch1.Cond{1, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{1, 3},ep))); % last small epoch is a bin with time < 2s
   PositionArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{1, 1} , SmallEpoch)));
   OB_FrequencyArray(i) = nanmean(Data(Restrict(TSD_DATA.Cond.respi_freq_BM.tsd{1, 1} , SmallEpoch)));
   GlobalTimeArray(i) = Start(subset(Epoch1.Cond{1, 3},ep))/1e4+2*(ind_to_use);
   TimeSinceLastShockArray(i) = ShockTime_Fz_Distance+2*(ind_to_use);
   try; TimepentFreezing(i) = 2*bin; catch; TimepentFreezing(i) = 0; end

   i=i+1;
   
end

TotalArray = [OB_FrequencyArray' PositionArray' GlobalTimeArray' TimeSinceLastShockArray' TimepentFreezing'];

% 
% Descente de gradient
% Ensuite on essaie de fitter nos 7 paramètres pour prédire à partir des 3 entrées la fréquence du OB.
% Il faudra faire ça par descente de gradient, malheureusement ce n'est pas un système linéaire donc on ne peut pas faire une régression directe. 
% Il y a des familles de fonction Matlab pour faire ça (fmincon, fminunc...), je pense que ça devrait aller parce qu'on sait à peu près quelles vont être les bonnes valeurs (parce qu'on connait le range de valeurs pour le OB par exemple) donc on peut faire partir la recherche de paramètres d'un point de départ qui sera pas trop loin de l'optimum et on pourrai bien restreindre pour éviter que ça diverge.
  
OBFreq_Shock = (1-AlphaLearn) .* ((MaxFreqSk - MinFreqSk) *exp([(-[0:10] -TimeToShock)]/Tau) + MinFreqSk);
OBFreq_Pos = (AlphaLearn) .* ((MaxFreqPos*Pos - MinFreqPos) *Pos + MinFreqPos);
OBFreq_Tot = OBFreq_Shock + OBFreq_Pos;
Learning = 1./(1+exp(-LearnSlope*([0:1500]-LearnPoint)));




OBFreq_Tot = @(x)(1-1./(1+exp(-x(7)*([0:1500]-x(6))))) .* ((x(1) - x(2)) *exp([(-[0:10] -TimeToShock)]/x(3)) + x(2)) + (1./(1+exp(-x(7)*([0:1500]-x(6))))) .* ((x(4)*Pos - x(5)) *Pos + x(5));


fun = @(x)TotalArray(:,1).*(x(2)-x(1)^2) + (1-x(1).*TotalArray(:,2));
x0 = [-1,2];
x = fmincon(fun,x0)


edit FitLaserStims
edit FitTheDataKernal
edit ErrorModelLaserAlphaFunction



figure
subplot(411)
plot(TotalArray(:,1))
subplot(412)
plot(TotalArray(:,2))
subplot(413)
plot(TotalArray(:,3))
subplot(414)
plot(TotalArray(:,4))



fun = @(x)3*x(1)^2 + 2*x(1)*x(2) + x(2)^2 - 4*x(1) + 5*x(2);


x0 = [1,1];
[x,fval] = fminunc(fun,x0)

figure
plot(Range(TSD_DATA.Fear.linearposition.tsd{1, 1}) , Data(TSD_DATA.Fear.linearposition.tsd{1, 1}))
hold on
plot(Range(TSD_DATA.Fear.linearposition.tsd{1, 3}) , Data(TSD_DATA.Fear.linearposition.tsd{1, 3}))


