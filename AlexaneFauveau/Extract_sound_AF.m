%% Extraire un son joué d'un fichier .wav
% Ce code permet de calculer l'intensité d'un son joué en fonction des V 
% que l'on reçoit. 

% Ouvrir le fichier audio
[audio, Fs] = audioread('CalibratedRecording.wav');
t = (0:length(audio)-1) / Fs ;


%% Définir le seuil : 
periode_calme = audio(1:Fs*5); % Sélectionne les 5 premières secondes de l'enregistrement
niveau_bruit_de_fond = max(periode_calme);
seuil = (max(periode_calme) + 0.0005)

%% Calculer la std pour chaque son 
% Make tsd
tsa = tsd(t*1e4, audio); % t en dizième de ms
figure
plot(Range(tsa,'min'),Data(tsa));

% Make epochs
SoundEpoch = thresholdIntervals(tsa,seuil,'Direction','Above'); % above or below for direction
SoundEpoch = mergeCloseIntervals(SoundEpoch,0.5*1e4)
hold on,plot(Range(Restrict(tsa,SoundEpoch),'min'),Data(Restrict(tsa,SoundEpoch)));

% Historgam of epoch durations
figure
hist(Stop(SoundEpoch,'s') - Start(SoundEpoch,'s'))

% get std for each sound
clear moy_std
for sd = 1:length(Start(SoundEpoch))
    moy_std(sd) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
end
% get rid of 8 first sounds
moy_std(1:8) = [];

%% Plot la courbe de la std en fonction de l'intensité en dB
figure
intensite = [60,60,70,70,80,80,90,90];
scatter((moy_std),intensite,'filled')
xlabel('STD')
ylabel('Intensité en dB')
title('Intensité en dB en fonction de la STD')
hold on 

% Plot the trendline logarithmic
% Sur Matlab: 
  % Apps -> Curve Fitting
  % Select Custom equation
  % Write a*lob(x)+b and select Auto fit
  % y = 8,736log(x)+110,7
  % R-square = 1

%% Mesurer l'intensité d'un son enregistré : 
[audio2, Fs] = audioread('T0000006.wav');
t2 = (0:length(audio2)-1) / Fs ;

periode_calme2 = audio2(1:Fs*2); 
% figure 
% plot(periode_calme2)
seuil2 = (max(periode_calme2) + 0.0005)

% figure
% plot(t2, audio2)
% xlabel('Temps (s)');
% ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
% title('Volt en fonction du temps')
% hold on;
% plot(t2, seuil2 * ones(size(audio2)), 'r--')

% Calculer la std pour chaque son 
% Make tsd
tsa2 = tsd(t2*1e4, audio2); % t en dizième de ms
% figure
% plot(Range(tsa2,'min'),Data(tsa2));

% Make epochs
SoundEpoch2 = thresholdIntervals(tsa2,seuil2,'Direction','Above'); % above or below for direction
SoundEpoch2 = mergeCloseIntervals(SoundEpoch2,0.3*1e4)
% hold on,plot(Range(Restrict(tsa2,SoundEpoch2),'min'),Data(Restrict(tsa2,SoundEpoch2)));

% Historgam of epoch durations
% figure
% hist(Stop(SoundEpoch2,'s') - Start(SoundEpoch2,'s'))

% get std for each sound
clear moy_std2
for sd = 1:length(Start(SoundEpoch2))
    moy_std2(sd) = std(Data(Restrict(tsa2,subset(SoundEpoch2,sd))));
end

% Puis on calcule leur intensité en dB.
for colonne = 1:size(moy_std2, 2)
    moy_std2(2, colonne) = 8.736 * log(moy_std2(1, colonne)) + 110.7;
end

disp(moy_std2)

moy_std2(3,1) = (0.1);
moy_std2(3,2) = (0.5); 
moy_std2(3,3) = (1);
moy_std2(3,4) = (2);
moy_std2(3,5) = (3);
moy_std2(3,6) = (4); 
moy_std2(3,7) = (5);
moy_std2(3,8) = (6);
moy_std2(3,9) = (7);
moy_std2(3,10) = (8); 
moy_std2(3,11) = (10);
moy_std2(3,12) = (11);
moy_std2(3,13) = (15);
moy_std2(3,14) = (20);

figure
scatter(moy_std2(3,1:14), moy_std2(2,1:14),'filled')
xlabel('Multiplication sur Matlab')
ylabel('Intensité en dB')
title('Intensité en dB en fonction de la fonction *x')
hold on 


%% Mesurer l'intensité d'un son enregistré 2 : 
[audio2, Fs] = audioread('T0000006.wav');
t2 = (0:length(audio2)-1) / Fs ;

periode_calme2 = audio2(1:Fs*2); 
% figure 
% plot(periode_calme2)
seuil2 = (max(periode_calme2) + 0.0005)

figure
plot(t2, audio2)
xlabel('Temps (s)');
ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
title('Volt en fonction du temps')
hold on;
plot(t2, seuil2 * ones(size(audio2)), 'r--')

% Calculer la std pour chaque son 
% Make tsd
tsa2 = tsd(t2*1e4, audio2); % t en dizième de ms
figure
plot(Range(tsa2,'min'),Data(tsa2));

% Make epochs
SoundEpoch2 = thresholdIntervals(tsa2,seuil2,'Direction','Above'); % above or below for direction
SoundEpoch2 = mergeCloseIntervals(SoundEpoch2,0.3*1e4)
hold on,plot(Range(Restrict(tsa2,SoundEpoch2),'min'),Data(Restrict(tsa2,SoundEpoch2)));

% Historgam of epoch durations
figure
hist(Stop(SoundEpoch2,'s') - Start(SoundEpoch2,'s'))

% get std for each sound
clear moy_std2
for sd = 1:length(Start(SoundEpoch2))
    moy_std2(sd) = std(Data(Restrict(tsa2,subset(SoundEpoch2,sd))));
end

% Puis on calcule leur intensité en dB.
for colonne = 1:size(moy_std2, 2)
    moy_std2(2, colonne) = 8.736 * log(moy_std2(1, colonne)) + 110.7;
end

disp(moy_std2)



moy_std2(3,1) = (0.1);
moy_std2(3,2) = (0.5); 
moy_std2(3,3) = (1);
moy_std2(3,4) = (2);
moy_std2(3,5) = (3);
moy_std2(3,6) = (4); 
moy_std2(3,7) = (5);
moy_std2(3,8) = (6);
moy_std2(3,9) = (7);
moy_std2(3,10) = (8); 
moy_std2(3,11) = (10);
moy_std2(3,12) = (11);
moy_std2(3,13) = (15);
moy_std2(3,14) = (20);

figure
scatter(moy_std2(3,1:14), moy_std2(2,1:14),'filled')
xlabel('Multiplication sur Matlab')
ylabel('Intensité en dB')
title('Intensité en dB en fonction de la fonction *x')
hold on



i = 1
for i = 1:7  %Modifier le nombre de boucle en fonction du nombre de son par enregistrement
    % Définir la zone autour d'un même son 
    disp('Sélectionner la zone entourant le son')
    [x, ~] = ginput(2) 
  
    % Donner le nom du son 
    
    % Si le nombre d'intervalle =14 indiqué blabla
    % Sinon indiqué blabla en ligne 3
    
    % Tracer le graphe
    
    i = i+1
end


% Récup tous les fichiers d'un même amplificateur 
% et les comparer son par son et *x par *x !
% Voir si on peut moyenner pour une même chambre même condition


%% FIN DU CODE, LE RESTE C'EST DU BROUILLON


%% Même code, mais sans utiliser l'outil tsd 
%Extraire un son joué d'un fichier .wav 
% Ce code permet de calculer l'intensité d'un son joué en fonction des V 
% que l'on reçoit. 

% Ouvrir le fichier audio
[audio, Fs] = audioread('CalibratedRecording.wav');

% Pour faire une figure: 
t = (0:length(audio)-1) / Fs ;
figure
plot(t, audio)
xlabel('Temps (s)');
ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
title('Volt en fonction du temps')

%% Définir le seuil : 
% periode_calme = audio(1:Fs*5); % Sélectionne les 5 premières secondes de l'enregistrement
% niveau_bruit_de_fond = mean(periode_calme);
% seuil = 10 * std(periode_calme)

% ou : 
periode_calme = audio(1:Fs*5); % Sélectionne les 5 premières secondes de l'enregistrement
niveau_bruit_de_fond = max(periode_calme);
seuil = (max(periode_calme) + 0.0005)


%% Calculer la std pour chaque son 
% Plot la figure de l'enregistrement complet
t = (0:length(audio)-1) / Fs ;
figure
plot(t, audio)
hold on;
plot(t, seuil * ones(size(audio)), 'r--')
xlabel('Temps (s)');
ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
title('Volt en fonction du temps')

i = 1
for i = 1:8
    % Sélectionner la zone à analyser
    disp('Sélectionner la zone entourant le son')
    [x, ~] = ginput(2) ;
    points_entre_x = audio(t >= min(x) & t <= max(x));
    temps_son = t(t >= min(x) & t <= max(x));
%     figure
%     plot(temps_son, points_entre_x)

    % Sélectionner le départ du son
    debut_son = find(points_entre_x > seuil, 1);
   
    temps_partiel = temps_son(debut_son:end);
    audio_partiel = points_entre_x(debut_son:end);
%     figure
%     plot(temps_partiel, audio_partiel)

    indice = find(temps_partiel - temps_partiel(1) >= 0.5, 1);
    temps_period = temps_partiel(1:indice);
    audio_period = audio_partiel(1:indice);
%     figure;
%     plot(temps_period, audio_period);
%     xlabel('Temps (s)');
%     ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
%     title('Volt en fonction du temps')

    % Mettre les STD dans un tableur
    moy_std{1, i} = std(audio_period);
    
    i = i+1;
end
    
moy_std{2,1} = (60);
moy_std{2,2} = (60);
moy_std{2,3} = (70);
moy_std{2,4} = (70);
moy_std{2,5} = (80);
moy_std{2,6} = (80);
moy_std{2,7} = (90);
moy_std{2,8} = (90)     


%% Plot la courbe de la std en fonction de l'intensité en dB
std = cell2mat(moy_std(1,:))
intensite = cell2mat(moy_std(2,:))

figure
scatter((std),intensite,'filled')
xlabel('STD')
ylabel('Intensité en dB')
title('Intensité en dB en fonction de la STD')
hold on 

% Plot the trendline logarithmic
% Sur Excel : pour la trendline logarithmique, on obtient:
  % y = 8.7282ln(x) + 110.72
  % Rsquare = 1
% Sur Matlab: 
  % Apps -> Curve Fitting
  % Select Custom equation
  % Write a*lob(x)+b and select Auto fit
  % y = 8,712log(x)+110,7
  % R-square = 1

%% Mesurer l'intensité d'un son enregistré : 
[audio2, Fs] = audioread('Son_test_1.wav');

debut = 0.6*Fs;
fin = 1.6*Fs;
periode_calme2 = audio2(debut:fin); 
% figure 
% plot(periode_calme2)
seuil2 = (max(periode_calme2) + 0.001)

% Plot la figure de l'enregistrement complet
t2 = (0:length(audio2)-1) / Fs ;
figure
plot(t2, audio2)
hold on;
plot(t2, seuil2 * ones(size(audio2)), 'r--')
xlabel('Temps (s)');
ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
title('Volt en fonction du temps')

i = 1
for i = 1:3  %Modifier le nombre de boucle en fonction du nombre de son par enregistrement
    % Sélectionner la zone à analyser
    disp('Sélectionner la zone entourant le son')
    [x, ~] = ginput(2) 
    points_entre_x = audio2(t2 >= min(x) & t2 <= max(x));
    temps_son = t2(t2 >= min(x) & t2 <= max(x));
%     figure
%     plot(temps_son, points_entre_x)

    % Sélectionner le départ du son
    debut_son = find(points_entre_x > seuil2, 1);
   
    temps_partiel = temps_son(debut_son:end);
    audio_partiel = points_entre_x(debut_son:end);
%     figure
%     plot(temps_partiel, audio_partiel)

    indice = find(temps_partiel - temps_partiel(1) >= 0.1, 1);   % Modifier la durée du son 
    temps_period = temps_partiel(1:indice);
    audio_period = audio_partiel(1:indice);
%     figure;
%     plot(temps_period, audio_period);
%     xlabel('Temps (s)');
%     ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
%     title('Volt en fonction du temps')

    % Mettre les STD dans un tableur
    moy_std2{1, i} = std(audio_period)
    
    i = i+1;
end

% Puis on calcule leur intensité en dB.
for colonne = 1:size(moy_std2, 2)
    moy_std2{2, colonne} = 8.7282 * log(moy_std2{1, colonne}) + 110.72;
end

disp(moy_std2)



%Code brouillon 2: 
% Make tsd
tsa = tsd(t*1e4, audio); % t en dizième de ms
figure
plot(Range(tsa,'min'),Data(tsa));

% Make epochs
SoundEpoch = thresholdIntervals(tsa,seuil,'Direction','Above'); % above or below for direction
SoundEpoch = mergeCloseIntervals(SoundEpoch,0.5*1e4)
hold on,plot(Range(Restrict(tsa,SoundEpoch),'min'),Data(Restrict(tsa,SoundEpoch)));

% Historgam of epoch durations
figure
hist(Stop(SoundEpoch,'s') - Start(SoundEpoch,'s'))

% get std for each sound
clear moy_std
for sd = 1:length(Start(SoundEpoch))
    moy_std(sd) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
end
% get rid of 8 first sounds
moy_std(1:8) = [];

figure
intensite = [60,60,70,70,80,80,90,90];
scatter((moy_std),intensite,'filled')
xlabel('STD')
ylabel('Intensité en dB')
title('Intensité en dB en fonction de la STD')
hold on 




i = 1
for i = 1:3  %Modifier le nombre de boucle en fonction du nombre de son par enregistrement
    % Sélectionner le début des Epochs
    StartPoint = find(Data(tsa) > seuil2, 1);
    StopPoint = Range(tsa(StartPoint+0.5))
    Study_Epoch = intervalSet(StartPoint , StopPoint);
    % Sélectionner la zone à analyser
    disp('Sélectionner la zone entourant le son')
    [x, ~] = ginput(2) 
    points_entre_x = audio2(t >= min(x) & t <= max(x));
    temps_son = t(t >= min(x) & t <= max(x));
%     figure
%     plot(temps_son, points_entre_x)

    % Sélectionner le départ du son
    debut_son = find(points_entre_x > seuil2, 1);
   
    temps_partiel = temps_son(debut_son:end);
    audio_partiel = points_entre_x(debut_son:end);
%     figure
%     plot(temps_partiel, audio_partiel)

    indice = find(temps_partiel - temps_partiel(1) >= 0.1, 1);   % Modifier la durée du son 
    temps_period = temps_partiel(1:indice);
    audio_period = audio_partiel(1:indice);
%     figure;
%     plot(temps_period, audio_period);
%     xlabel('Temps (s)');
%     ylabel('Volt'); % Vérifier qu'il s'agit bien de Volt
%     title('Volt en fonction du temps')

    % Mettre les STD dans un tableur
    moy_std2{1, i} = std(audio_period)
    
    i = i+1;
end

% Puis on calcule leur intensité en dB.
for colonne = 1:size(moy_std2, 2)
    moy_std2{2, colonne} = 8.7282 * log(moy_std2{1, colonne}) + 110.72;
end

disp(moy_std2)

