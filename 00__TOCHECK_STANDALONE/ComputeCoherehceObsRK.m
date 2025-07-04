
%ComputeCoherehceObsRK



EEG=LFP{10};
ECoG=LFP{11};
LfpS=LFP{1};
LfpD=LFP{13};

% EEG=LFP{3};
% ECoG=LFP{2};
% LfpS=LFP{1};
% LfpD=LFP{4};







%-------------------------------------------------------------------------
%%
% definition des periodes a analyser (a doit être en seconde)
%-------------------------------------------------------------------------

%Epoch=intervalSet(500*1E4, 870*1E4);

% deb=213;
% fin=214;

a=30;
deb=a;
fin=a+10;     
% fin=a+3;
%fin=a+0.5;

Epoch=intervalSet(deb*1E4,fin*1E4);
 



%-------------------------------------------------------------------------
%%
% definition des parametres
%-------------------------------------------------------------------------

smo=1;   % utilisé dans la fonction Smooth Dec
   
%movingwin=[(fin-deb)/10,(fin-deb)/100]; % [longueur de la fenêtre, pas] 
%movingwin=[2,0.01];
%movingwin=[0.7,0.035];
%movingwin=[0.5,0.025];
%movingwin=[0.3,0.01];
%movingwin=[0.1,0.01];
movingwin=[1 0.05];

params.trialave = 0; % moyenne sur les différents canaux si 1, pas de myenne si 0
params.err = [1 0.05];  % type d'erreur calculée pour la sortie : [a b] a : type d'erreur (0 : pas de calculs, 1 : theorique ; 2 : jackknife et b: p value

fp1=4/(fin-deb);
%fp1=55;
fp2=150;
 %fp2=75;
%fp2=25;


params.fpass = [fp1 fp2]; % gamme de fréquences étudiée

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));  % fréquence d'échantillonnage
params.tapers=[1 2];   % échelle et nombre de tapers  sous la forme [NW K] 
%params.tapers=[2 4];
%params.tapers=[3 4];
%params.tapers=[5 9];
%params.tapers=[10 19];

% params.pad=0;     % ajout de zéros : -1 : pas de padding; 0 padding
% jusqu'à la première puissance de 2 après la taille des données, 1 la deuxième...
 params.pad=1;
%params.pad=2;
%params.pad=4;
% params.pad=6;


%-------------------------------------------------------------------------
%%
% calcul de la coherence (chronux)
%-------------------------------------------------------------------------

% cohérence entre LFPs et LFPd


d1=Data(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(LfpD,Epoch));
[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);



%-------------------------------------------------------------------------
%%
% Affichage des résultats
%-------------------------------------------------------------------------



yl1=fp1;
yl2=fp2;

% yl1=0;
% yl2=30;

try 
    %num;
catch
    
figure('color',[1 1 1]), 
%num=gcf;


end

if 0  
    
  % Absence de lissage des grandeurs spectrales
  
 figure('color',[1 1 1]),   
%figure(num)

% comparaison temporelle
subplot(7,1,1), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
%ylim([min(min(d1),min(d2)) max(max(d1),max(d2))])
title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])

% Corrélation
subplot(7,1,2), imagesc(t,f,Cf'), axis xy, ylim([yl1 yl2])

% Différence de Phase
subplot(7,1,3), imagesc(t,f,phif'), axis xy, ylim([yl1 yl2])

% Spectre de LFPd sans la composante continue (échelle logarithmique)
subplot(7,1,4), imagesc(t,f,10*log(S1f)'), axis xy, ylim([yl1 yl2])

% Spectre de LFPs sans la composante continue (échelle logarithmique)
subplot(7,1,5), imagesc(t,f,10*log(S2f)'), axis xy, ylim([yl1 yl2])

fvec=f'*ones(1,length(t));

% Spectre de LFPd  épuré sans la composante continue (échelle logarithmique)
subplot(7,1,6), imagesc(t,f,fvec.*(S1f)'), axis xy, ylim([yl1 yl2])

% Spectre de LFPs épuré sans la composante continue (échelle logarithmique)
subplot(7,1,7), imagesc(t,f,fvec.*(S2f)'), axis xy, ylim([yl1 yl2])


else 

  % Lissage des grandeurs spectrales
  
figure('color',[1 1 1]),
%figure(num)

subplot(7,1,1), hold on   
% comparaison temporelle
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
%ylim([min(min(d1),min(d2)) max(max(d1),max(d2))])

title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])

% Corrélation 
subplot(7,1,2), imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([yl1 yl2]) 
% Différence de Phase
subplot(7,1,3), imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([yl1 yl2]) 

% Spectre de LFPd sans la composante continue (échelle logarithmique)
subplot(7,1,4), imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([yl1 yl2]) 

% Spectre de LFPs sans la composante continue (échelle logarithmique)
subplot(7,1,5), imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([yl1 yl2])

fvec=f'*ones(1,length(t));

% Spectre de LFPd épuré sans la composante continue (échelle logarithmique)
subplot(7,1,6), imagesc(t,f,SmoothDec(fvec.*(S1f)',[smo smo])), axis xy, ylim([yl1 yl2]) 

% Spectre de LFPs épuré sans la composante continue (échelle logarithmique)
subplot(7,1,7), imagesc(t,f,SmoothDec(fvec.*(S2f)',[smo smo])), axis xy, ylim([yl1 yl2])


end

%% Filtre 1- 5

figure,

subplot(5,1,1),

% Filtrage

Filt_LfpD = FilterLFP(LfpD, [1 5], 1024); 
Filt_LfpS = FilterLFP(LfpS, [1 5], 1024); 

%Corrélation et tracé

d1=Data(Restrict(Filt_LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(Filt_LfpD,Epoch));

[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);
imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([1 5])
title('Corrélation')
grid

subplot(5,1,2),

% Différence de Phase

imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([1 5]) 
title('Phase')
grid

subplot(5,1,3),

% Allure temporelle

plot(Range(Restrict(Filt_LfpD,Epoch),'s'),Data(Restrict(Filt_LfpD,Epoch)),'r')

hold on 

plot(Range(Restrict(Filt_LfpS,Epoch),'s'),Data(Restrict(Filt_LfpS,Epoch)),'k')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
title('Filtre BP 0-5 Hz ')
grid

subplot(5,1,4), 
% Spectre de LFPd sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([1 5])
title('Spectre LFPd ')


subplot(5,1,5), 
% Spectre de LFPs sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([1 5])
title('Spectre LFPs ')



%% Filtre 5-10


figure,

subplot(5,1,1),

% Filtrage

Filt_LfpD = FilterLFP(LfpD, [5 10], 1024); 
Filt_LfpS = FilterLFP(LfpS, [5 10], 1024); 

%Corrélation et tracé

d1=Data(Restrict(Filt_LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(Filt_LfpD,Epoch));

[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);
imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([5 10])
title('Corrélation')
grid

subplot(5,1,2),

% Différence de Phase

imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([5 10]) 
title('Phase')
grid

subplot(5,1,3),

% Allure temporelle

plot(Range(Restrict(Filt_LfpD,Epoch),'s'),Data(Restrict(Filt_LfpD,Epoch)),'r')

hold on 

plot(Range(Restrict(Filt_LfpS,Epoch),'s'),Data(Restrict(Filt_LfpS,Epoch)),'k')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
title('Filtre BP 5-10 Hz ')
grid

subplot(5,1,4), 
% Spectre de LFPd sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([5 10])
title('Spectre LFPd ')


subplot(5,1,5), 
% Spectre de LFPs sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([5 10])
title('Spectre LFPs ')






%% Filtre 10-15

figure,

subplot(5,1,1),

% Filtrage

Filt_LfpD = FilterLFP(LfpD, [10 15], 1024); 
Filt_LfpS = FilterLFP(LfpS, [10 15], 1024); 

%Corrélation et tracé

d1=Data(Restrict(Filt_LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(Filt_LfpD,Epoch));

[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);
imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([10 15])
title('Corrélation')
grid

subplot(5,1,2),

% Différence de Phase

imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([10 15]) 
title('Phase')
grid

subplot(5,1,3),


% Allure temporelle

plot(Range(Restrict(Filt_LfpD,Epoch),'s'),Data(Restrict(Filt_LfpD,Epoch)),'r')

hold on 

plot(Range(Restrict(Filt_LfpS,Epoch),'s'),Data(Restrict(Filt_LfpS,Epoch)),'k')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
title('Filtre BP 10-15 Hz ')
grid

subplot(5,1,4), 
% Spectre de LFPd sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([10 15])
title('Spectre LFPd ')


subplot(5,1,5), 
% Spectre de LFPs sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([10 15])
title('Spectre LFPs ')




%% Filtre 15-25

figure,

subplot(5,1,1),

% Filtrage

Filt_LfpD = FilterLFP(LfpD, [15 25], 1024); 
Filt_LfpS = FilterLFP(LfpS, [15 25], 1024); 

%Corrélation et tracé

d1=Data(Restrict(Filt_LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(Filt_LfpD,Epoch));
title('Corrélation')
grid

[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);
imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([15 25])

subplot(5,1,2),

% Différence de Phase

imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([15 25]) 
title('Phase')
grid

subplot(5,1,3),


% Allure temporelle

plot(Range(Restrict(Filt_LfpD,Epoch),'s'),Data(Restrict(Filt_LfpD,Epoch)),'r')

hold on 

plot(Range(Restrict(Filt_LfpS,Epoch),'s'),Data(Restrict(Filt_LfpS,Epoch)),'k')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
title('Filtre BP 15-25 Hz ')
grid

subplot(5,1,4), 
% Spectre de LFPd sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([15 25])
title('Spectre LFPd ')


subplot(5,1,5), 
% Spectre de LFPs sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([15 25])
title('Spectre LFPs ')









%%



figure,

subplot(5,1,1),

% Filtrage

Filt_LfpD = FilterLFP(LfpD, [30 45], 1024); 
Filt_LfpS = FilterLFP(LfpS, [30 45], 1024); 

%Corrélation et tracé

d1=Data(Restrict(Filt_LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(Filt_LfpD,Epoch));
title('Corrélation')
grid

[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);
imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([30 45])

subplot(5,1,2),

% Différence de Phase

imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([30 45]) 
title('Phase')
grid

subplot(5,1,3),


% Allure temporelle

plot(Range(Restrict(Filt_LfpD,Epoch),'s'),Data(Restrict(Filt_LfpD,Epoch)),'r')

hold on 

plot(Range(Restrict(Filt_LfpS,Epoch),'s'),Data(Restrict(Filt_LfpS,Epoch)),'k')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
title('Filtre BP 15-25 Hz ')
grid

subplot(5,1,4), 
% Spectre de LFPd sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([30 45])
title('Spectre LFPd ')


subplot(5,1,5), 
% Spectre de LFPs sans la composante continue (échelle logarithmique)
imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([30 45])
title('Spectre LFPs ')










% 
% x1=a;
% x2=a+1;
% subplot(7,1,1), xlim([x1 x2])
% for i=2:7
% subplot(7,1,i), xlim([x1 x2]-deb)
% end
% 
% 
% figure('color',[1 1 1]),hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
% 
% plot(Range(Restrict(ECoG,Epoch),'s'),Data(Restrict(ECoG,Epoch)),'b')
% 

