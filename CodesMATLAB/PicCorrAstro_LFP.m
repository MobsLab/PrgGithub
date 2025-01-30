% PicCorrAstro_LFP
% Recherche du pic de corrélation sur toutes les données

cd H:\Data_Astros_Field
load ResultsCompLFP
figure,plot(lCross,mean(binCrossT))
% 
% binMax=max(mean(binCrossT));
[Max,index]=max(mean(binCrossT));

lagMax=lCross(index);

Max
lagMax

% -----------------------------------------------------------------

[MaxAbs,indexAbs]=max(mean(abs(binCrossT)));

lagMaxAbs=lCross(indexAbs);

Max
lagMax

