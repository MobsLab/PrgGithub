

load('SleepSubstages.mat')
REMEpoch = Epoch{strcmp(NameEpoch, 'REM')}

[Sp, t, f] = LoadSpectrumML(26, pwd, 'low');
Stsd=tsd(t*1E4,Sp);
figure, imagesc(t,f,10*log10(Sp)'), axis xy
% ou : figure, imagesc(Range(Stsd,'s'),f,10*log10(Data(Stsd)')), axis xy
figure, plot(f,mean(Data(Restrict(Stsd,REMEpoch))))


pow=mean(Sp(:,find(f>1&f<4)),2); % puissance spectrale dans la bande 1-4 Hz en fonction du temps
powtsd=tsd(t*1E4,pow);




% A) etablir le lien entre la puissance (pour différente bandes de fréquences : 1-4Hz ou bien 1-2Hz, 2-3Hz, et 3-4Hz)
% et 1) la densité de delta waves (2ch), slow waves (positives ou négatives -> s�par�es) et down states
%    2) l'interval inter-delta/slow waves
%    3) durée des DOWN ou durée des UPs
%    4) régularité de la durée des DOWN ou des UPs
% -> hom�ostasie (Cf. 

% B) etablir un lien entre la phase par rapport au signal vu comme une oscillation
% et le temps après (ou avant) une onde delta et le comparer par rapport aux DOWN
% essayer d'atablir un lien entre début et fin de delta avec debut et fin de down
% fait attention avec les sous-stage de sommeil N1 N2 N3
% load SleepSubstages
% N1=Epoch{1};N2=Epoch{2};N3=Epoch{3};
% Fil=FilterLFP(LFP,[f1 f2],1024); (ou 512 ou 2048 (nb points de la dFFT)
% règle absolue regarder les signaux bruts et les signaux filtrés par
% dessus !!!!!!

% Question est ce que le signal entre les deltas waves a une contribution sur le spectre global ?
% - detecter les vrais deltas waves (2ch)
% - prendre leur forme moyenne sur un canal (n'importe)
% - créer un signal synthétique: 
%      1ère possibilité : créer un signal avec cette forme moyenne apparaissant à tous le temps des vraies delta waves
%      2ème possibilité : créer un signal en ne gardant que les vraies delta waves (tout le signal entre le delta waves est plat)
% - Prendre le spectrogramme du signal synthétique
% - le comparer par rapport au spectrogramme du vrai signal (du canal utilisé)

% Etablir un modèle expliquant le spectrogramme moyen
% - prendre le spectrogramme de la delta wave moyenne
% - le spectrogramme moyen est donc la contribution des fréquences expliquant la forme moyenne de la delta et les fréquences expliquant leur occurrence
%











