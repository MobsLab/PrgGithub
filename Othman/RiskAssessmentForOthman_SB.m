%% Risk assessment
% Tout le risque assessment a été évalué sur de sessions de conditionnement
% dane le UMaze
% Tu peux avoir la liste en utilisant différents paths
% Dir = PathForExperimentsEmbReact('UMazeCond') --> souris stimulées dans
% le PAG
% Dir = PathForExperimentsEmbReact('UMazeCond_EyeShock') --> souris
% stimulées avec un eyeshock
% Dir = PathForExperimentsEmbReact('UMazeCondExplo_PreDrug') --> souris
% stimulées avec un eyeshock dans la manip où j'injecte une drogue, avant
% injection
% Dir = PathForExperimentsEmbReact('UMazeCondExplo_PostDrug') --> souris
% stimulées avec un eyeshock dans la manip où j'injecte une drogue, avant
% injection    

% Si on va dans un de ces dossiers
Dir = PathForExperimentsEmbReact('UMazeCond_EyeShock')
 cd(Dir.path{5}{1})
% on load le bon fichier
load('behavResources_SB.mat')
% Behav.RAUser =  comment j'ai compté les différentes epoch de risk
% assessment que m'a proposé le logiciel automatique :0=nul, 1=peut être,
% 2=vrai risk assessment.
% Donc pour compter les bons évements c'est 

sum(Behav.RAUser.ToShock==2)

% Je te conseille de trouver une session où il y a beaucoup d'évenements de
% commencer à faire tourner dessp lab cut la dessus
% en général les vidéos sont dans le dossier de la sour, parfois il faut
% aller les chercher dans raw, dans ce cas là n'hésite pas à copier le avi
% dans le dossier principal
% Parfois ce sont des frames enregistrées une à une donc soit tu convertis
% en .avi
% soit tu n'utilisés pas

% Behav.RAEpoch  = les intervalSet correspondants
% Il faut noter que c'est séparé en évenements vers la zone safe et vers la
% zone shock Behav.RAEpoch.ToSafe par exemple

% Petite astuce pour trouver le moment où la souris se retourne pour tout
% réaligner
StepBackFromStart=0.5*1e4;
SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
tpsout=FindClosestZeroCross(Start(Behav.RAEpoch.ToShock)-StepBackFromStart,SmooDiffLinDist,1);
%tpsout = temps où la souris fait demi tour

% Trigger vitesse dessus
figure
[M,T] = PlotRipRaw(Behav.Vtsd,tpsout'/1e4,5000,0,0);
plot(M(:,1),M(:,2))
xlabel('Time to turn (s)'), ylabel('Speed cms')
% Trigger position linearisée dessus
figure
[M,T] = PlotRipRaw(Behav.LinearDist,tpsout'/1e4,5000,0,0);
plot(M(:,1),M(:,2))
xlabel('Linearized distance'), ylabel('Speed cms')

% Tu peux restreindre les epochs à seulement ceux que j'ai noté comme bien
% en faisant ça
GoodEpoch  = subset(Behav.RAEpoch.ToShock,find(Behav.RAUser.ToShock==2));

