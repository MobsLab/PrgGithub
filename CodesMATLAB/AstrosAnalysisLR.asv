% AstrosAnalysisLR
function [Res,S,f,Serr]=AstrosAnalysisLR
                                       %Res=[VmMoy,STD,Error,Skew]
                                       
try                                       
load Data
end


voie=2;


try
    chF;
catch
    
chF=50;    %freqce voulue finale en Hz, pas trop loin de la freqce qu'on veut analyser
% chF=1
end

resamp=10000/chF;


Y=resample(data(:,voie),1,resamp);
%resample d'un facteur 1/resamp, doit rester un facteurs de 10, ou des
%entiers

Y=smooth(Y,5);                      %pour enlever le 50Hz,pour virer le bruit


Y=Y(20:end-20);                     % pour éviter les effets de bords

dataRes=[[0:length(Y)-1]'/chF, Y];   %matrice resamplée à 50Hz, temps rééchantillonné

%--------------------------------------------------------------------------
% Pour ajuster la baseline: moyenne locale sur une fenêtre de 200sec,
% décalage de 10sec à chaque itération
% Valeurs autour de la valeur de Y au 100ème point (ajustement par rapport
% au potentiel de la cellule et non pas zero): +Y(100)(la 100ème valeur pour Y
% correspond à zero)

Y=locdetrend(Y,chF,[200,10])+Y(100);                                   


% Fs           (sampling frequency) - optional. Default 1
% movingwin    (length of moving window, and stepsize) [window winstep] -
% optional. Ici 200 et 10


dataBas=[[0:length(Y)-1]'/chF, Y]; 




%--------------------------------------------------------------------------

[m,s,e]=MeanDifNan(Y);

% ne prend pas en compte les valeurs nan
% m: mean
% s: std
% e: SEM: std/racine(n)

VmMoy=m;
STD=s;
Error=e;

Skew=skewness(Y);
% Skewness is a measure of the asymmetry of the data around the sample
% mean. If skewness is negative, the data are spread out more to the left of
% the mean than to the right. If skewness is positive, the data are spread out
% more to the right. The skewness of the normal distribution (or any perfectly
% symmetric distribution) is zero.


save Analysis VmMoy STD Error Skew % ne seront pas déjà sauvés dans Res????
% saveFigure(1,nom,pwd);
close all
%--------------------------------------------------------------------------

Fup=10;  % limite d'oberservation des freqces analysés

Fpass=[0 10];

% Fpass correspond à la fenêtre de freqces approx ou on veut faire l'analyse

params.Fs=chF;
params.pad=3;

params.tapers=[10 19];
% TAPERS: n sous la forme nx2-1, définit la forme de la fenêtre sur laquelle se fait l'analyse, 
% la fenêtre peut utiliser une "pondération" (ex:mediane,gaussienne) ou pas
% multitapers spectrum, fait varier les paramètres de ta fenêtre, permet de faire des stats 
% [3 5] en routine


params.fpass = Fpass;
params.trialave = 0;
params.err = [1 0.05];

tps=[0:length(Y)-1]/params.Fs;      %params.Fs=chF;

%resamplage du temps




[S,f,Serr]=mtspectrumc(Y,params);   %MultiTapers Powerpectrum; params est une structure
% [S,f,Serr]=mtspectrumc(dataBas,params);

figure('Color',[1 1 1])         %fond blanc
subplot(3,1,1), plot(tps,Y), title([nom,' Vm Moyen: ',num2str(VmMoy),'mV _ STD: ',num2str(STD),'mV _ StdErr: ',num2str(Error)])
subplot(3,1,2), plot(f,10*log10(S))
subplot(3,1,3), plot(10*log10(f),10*log10(S))

save Spectre1 S f Serr
saveFigure(1,nom,pwd);
close all

%--------------------------------------------------------------------------



Res=[VmMoy,STD,Error,Skew];


