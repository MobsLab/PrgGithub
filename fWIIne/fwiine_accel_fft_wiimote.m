%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%- fwiine_accel_fft_wiimote.m----------------------------------------------
%- acceleration analysis :Auto Power Spectrum------------------------------
%- v0.2 --------------- August 2008 - William Alozy -----------------------
%--------------------------------------------------------------------------
% - Object :    To record and to analyse measurement from the wiimote accel.
% - Objet  :    Enregistrer et Analyser les mesures d'acceleration de la wiimote    
%--------------------------------------------------------------------------
% 0.1 : sources 
%       http://fwiineur.blogspot.com/
%       
% 0.2 : workaround for fWIIne v0.3 (the file still remains compatible with
%       previous versions) : Avoiding Inf values at beginning and Ts=0.012s
%       
%--------------------------------------------------------------------------
disp('-------------------');
disp('Recording and Analysis of an experiment with one file');
disp('Recording time/Temps d enregistrement = 1mn01s')
disp('-------------------');
close all;
clear all;

%--------------------------- initialization / initialisation
a=0;b=0;c=0;d=0;e=0;t=0;
A=[0,0,0,0,0,0];

% Start Wiimote
fWIIne(1);
disp('Press a key / Pressez une touche / Pulse una tecla ');
pause;

%--------------------------- main / principal
tic;
for j=1:6000
    [a,b,c,d,e]=fWIIne(6);
    t=toc;
    tic;
    %disp([a,b,c,d,e]);
    %pause(0.01);
    A=[A;[a,b,c,d,e,t]]; 
end;

%--------------------------- end / fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);
disp('-------------------');
disp('Press Key [Enter] to analyze / [1]+[Enter] to save measurement file and then to analyze');
keyessai =input('Pressez [Entree] pour l analyse / [1]+[Entree] pour sauvegarder le fichier puis pour l analyse','s');
if (isempty(keyessai))
    % do nothing / rien
else
    regexpessai =input('Enter filename/Entrez nom du fichier : ','s');
    disp('saving acquis. file.../sauvegarde fichier acquis...');
    if (isempty(regexpessai))
        save('default.txt','A','-ASCII');
    else
        save(regexpessai, 'A','-ASCII');
    end;
    disp('...done');



    %--------------Loading file/ Chargement fichier ---------------------------
    regexpessai =input('Enter filename/Entrez nom du fichier : ','s');
    disp('loading acquis. file.../charge fichier acquis...');
    if (isempty(regexpessai))
        A = load('default.txt');
    else
        A = load(regexpessai);
    end;
    disp('...ok');
end;
    
disp('-------------------');
disp('Starting analysis/Démarrage analyse');
disp('-------------------');
%--------------- Sampling time : error statistic distribution -------------
%--------------- Echantillonage : erreur statistique ----------------------
taille_A = size(A);
taille_data = taille_A(1,1);
taille_col = taille_A(1,2);
nbre_col = 10;
if taille_col<10
        A=[A(:,1:5) zeros(taille_data, nbre_col-taille_col) A(:,6)];
end;
% table of estimated sampling time / table des tps d'echant. estimee
tps_sample = [0.002 0.01 0.02 0.025 0.034 0.035 0.05]; 
percent=[0 0 0 0 0 0];
compteur=0;

for j=1:7
    compteur=0;
    for i=1:taille_data;
         if (A(i,10)>tps_sample(1,j)) 
             compteur=compteur+1;
         end;
    end;
    percent(1,j)=100*compteur/taille_data;
end;

hist(A(:,10),50);
title('Sampling time of the measure T(n)-T(n-1)');
legend('record');
xlabel('s.');ylabel('Nbr of data');


%--------------- Re-Sampling measurement ----------------------------------
%--------------- Re-echantillonage mesure ---------------------------------
% sampling time choice / choix du nouveau pas d'echantillonnage
%t_sample=tps_sample(1,3);
t_sample=0.012; %previously : 0.015s
t_step=0;
%AS=[ax ay az 0 0 0 t_sample t_cumul_record]
AS=[0 0 0 0 0 0 0 0];
% cumulative time and sampling time / tps cumule et echantillonnage
for i=2:taille_data
    A(i,9)=A(i-1,9)+A(i,10);
    if (A(i,9)>t_sample+t_step)
        if (i==2)
            t_step = A(i,9);
            A(i,8)=t_sample+t_step;
        else
            A(i,8)=t_sample+t_step;
        end;
        t_step=t_step+t_sample;
        AS=[AS;[A(i,1) A(i,2) A(i,3) A(i,4) A(i,5) 0 A(i,8) A(i,9)]];
    else
        %do nothing / rien
    end;    
end;

%--------------- displaying------------------------------------------------
%figure;
Ab=A;
[Bd,Cd]=butter(1,0.01,'low');
Ab(:,1:5)=filtfilt(Bd,Cd,Ab(:,1:5));
%plot(A(:,9),Ab(:,2),'r',A(:,9),A(:,2),'b');
%AS(:,1:5)=filtfilt(Bd,Cd,AS(:,1:5));
taille_as = size(AS);
taille_data_as = taille_as(1,1);

disp('Av. sampling time in s. : ');
disp(mean(A(1:taille_data,10)));
disp('Selected sampling time in s. : ');
disp(t_sample);


%------Relevant plots (removing 0 or Inf values at beginning of wiimote acquis.)--
% -----Suppression des zeros ou Inf a l'init. de l'acquisition--------------------

diff_t_sample = 0;
t_step=0;
i=1;
while (((AS(i,1)==0) && (AS(i,2)==0) && (AS(i,3)==0)) || isinf(AS(i,1)))
   i=i+1; 
end;    
diff_t_sample=(i-1)*t_sample;
%AR=[ax ay az pitch roll 0 new t_sample old t_sample]
AR=[AS(i:taille_data_as,1) AS(i:taille_data_as,2) AS(i:taille_data_as,3) AS(i:taille_data_as,4) AS(i:taille_data_as,5) zeros(taille_data_as-i+1,1) (AS(i:taille_data_as,7)-AS(i,7).*ones(taille_data_as-i+1,1)) AS(i:taille_data_as,7)];
taille_ar = size(AR);
taille_data_ar = taille_ar(1,1);


%--------------- filtering ------------------------------------------------
%--------------- filtage --------------------------------------------------

%RII
%Butterworth bandpass filter / Filtre Butterworth Passe-Bande
%fc=(fc1+fc2)/2=1200
%BP=fc2-fc1=50
fe=1/t_sample;
fc1= 0.0001;    %Hz
fc2= 5;         %Hz
Fc=[fc1 fc2]/fe; %=[fc1 fc2]
[num,den]=butter(3,Fc); %filter order=3 / filtre ordre = 3

%frq response of the filter / Reponse frequentielle du filtre
%[h,w]=freqz(num,den,512);
%B=abs(h);
%frequence=[0:511]*fe/512;
%plot(frequence,B,'r')
%figure;

%Filtering signal / Filtrage du signal
%Comparison between 2 butterworth filters but non-zero phase filtering
%for the second / Comparaison entre 2 filtres butterworth mais le 
%second est post-processe a phase nulle
ARf=filter(num,den,AR(:,1:3));
[B,C]=butter(5,0.2,'low');
filtrada=filtfilt(B,C,AR(:,1:3));

%--------------- FFT  -----------------------------------------------------
%--------------- TFR ------------------------------------------------------

[Bk,Ck]=butter(5,0.8,'low'); %post-process : filtering |FFT| for display !
                             %warning : it should be replaced by averaging!
Fs = 1/t_sample;                    % Sampling frequency
T = t_sample;                       % Sample time
L = taille_data_ar;                 % Length of signal
t = AR(1:taille_data_ar,7);                % Time vector
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2);


X = fft(AR(1:taille_data_ar,1),NFFT)/L;
X2 = filtfilt(Bk,Ck,fft((AR(1:taille_data_ar,1)-mean(AR(1:taille_data_ar,1))).*hanning(length(AR(1:taille_data_ar,1))),NFFT)/L);
X3 = fft((AR(1:taille_data_ar,1)-mean(AR(1:taille_data_ar,1))).*hanning(length(AR(1:taille_data_ar,1))),NFFT)/L;

Y = fft(AR(1:taille_data_ar,2),NFFT)/L;
Y2 = filtfilt(Bk,Ck,fft((AR(1:taille_data_ar,2)-mean(AR(1:taille_data_ar,2))).*hanning(length(AR(1:taille_data_ar,2))),NFFT)/L);
Y3 = fft((AR(1:taille_data_ar,2)-mean(AR(1:taille_data_ar,2))).*hanning(length(AR(1:taille_data_ar,2))),NFFT)/L;

Z = fft(AR(1:taille_data_ar,3),NFFT)/L;
Z2 = filtfilt(Bk,Ck,fft((AR(1:taille_data_ar,3)-mean(AR(1:taille_data_ar,3))).*hanning(length(AR(1:taille_data_ar,3))),NFFT)/L);
Z3 = fft((AR(1:taille_data_ar,3)-mean(AR(1:taille_data_ar,3))).*hanning(length(AR(1:taille_data_ar,3))),NFFT)/L;







%--------------- displaying -----------------------------------------------
%--------------- affichage ------------------------------------------------
% - Pitch and Roll
figure;
subplot(2,1,1);
plot(A(:,9),A(:,4),'b',t_sample*(1:taille_data_as),AS(1:taille_data_as,4),'g',A(:,9),Ab(:,4),'r');
title(' "Pitch(t)" Sampled signals (under conditions)');
xlabel('s.');ylabel('deg°');
subplot(2,1,2);
plot(A(:,9),A(:,5),'b',t_sample*(1:taille_data_as),AS(1:taille_data_as,5),'g',A(:,9),Ab(:,5),'r');
title('"Roll(t)" Sampled signals (under conditions)');
xlabel('s.');ylabel('deg°');


%- Main figure
figure;
subplot(3,3,1);
plot(AR(1:taille_data_ar,7),AR(1:taille_data_ar,1),'b',AR(1:taille_data_ar,7),filtrada(:,1),'g')
title('ax(t) ampl. compar. "g": non-zero phase fil. ax-"b":unfilt. ax');
xlabel('s');ylabel('.g m/s²');
subplot(3,3,2);
plot(AR(1:taille_data_ar,7),AR(1:taille_data_ar,2),'b',AR(1:taille_data_ar,7),filtrada(:,2),'g')
title('ay(t) ampl. compar. "g": non-zero phase fil. ay-"b":unfilt. ay');
xlabel('s');ylabel('.g m/s²');
subplot(3,3,3);
plot(AR(1:taille_data_ar,7),AR(1:taille_data_ar,3),'b',AR(1:taille_data_ar,7),filtrada(:,3),'g')
title('az(t) ampl. compar. "g": non-zero phase fil. az-"b":unfilt. az');
xlabel('s');ylabel('.g m/s²');

% Plot single-sided amplitude spectrum. aX / Trace |A#(f)|
subplot(3,3,4);
plot(f,2*abs(X3(1:NFFT/2)),'g') ;
grid on;
title('Single-Sided Amplitude Spectrum of ax(t)');
xlabel('Frequency (Hz)');
ylabel('|AX(f)| ');
subplot(3,3,5);
plot(f,2*abs(Y3(1:NFFT/2)),'g') ;
grid on;
title('Single-Sided Amplitude Spectrum of ay(t)');
xlabel('Frequency (Hz)');
ylabel('|AY(f)|');
subplot(3,3,6);
plot(f,2*abs(Z3(1:NFFT/2)),'g') ;
grid on;
title('Single-Sided Amplitude Spectrum of az(t)');
xlabel('Frequency (Hz)');
ylabel('|AZ(f)|');


% Plot Auto Power Spectrum. / Affichage Spectre de Puissance
subplot(3,3,7);
plot(f,2*abs(X3(1:NFFT/2)).^2,'r'); 
grid on;
title('A. Power Spectrum of ax(t)');
xlabel('Frequency (Hz)')
ylabel('|AX(f)|² (g²/Hz)')
subplot(3,3,8);
plot(f,2*abs(Y3(1:NFFT/2)).^2,'r'); 
grid on;
title('A. Power Spectrum of ay(t)');
xlabel('Frequency (Hz)')
ylabel('|AY(f)|² (g²/Hz)')
subplot(3,3,9);
plot(f,2*abs(Z3(1:NFFT/2)).^2,'r'); 
grid on;
title('A. Power Spectrum of az(t)');
xlabel('Frequency (Hz)')
ylabel('|AZ(f)|² (g²/Hz)')





figure;
Spwindow=250;
Spnoverlap=240;
Spnfft=150;
Spfs=1/t_sample;
subplot(131);
[Yr,Fr,Tr,Pr]=spectrogram((AR(1:taille_data_ar,1)-mean(AR(1:taille_data_ar,1))),Spwindow,Spnoverlap,Spnfft,Spfs,'yaxis');
surf(Tr,Fr,abs(Pr),'EdgeColor','none','EdgeLighting','phong','FaceColor','interp');axis xy; axis tight; colormap(jet);
xlabel('Time s.');
ylabel('aX Frequency (Hz)');
view([0 90]);
subplot(132);
[Yq,Fq,Tq,Pq]=spectrogram((AR(1:taille_data_ar,2)-mean(AR(1:taille_data_ar,2))),Spwindow,Spnoverlap,Spnfft,Spfs,'yaxis');
surf(Tq,Fq,abs(Pq),'EdgeColor','none','EdgeLighting','phong','FaceColor','interp');axis xy; axis tight; colormap(jet);
xlabel('Time s.');
ylabel('aY Frequency (Hz)');
view([0 90]);
subplot(133);
[Yt,Ft,Tt,Pt]=spectrogram((AR(1:taille_data_ar,3)-mean(AR(1:taille_data_ar,3))),Spwindow,Spnoverlap,Spnfft,Spfs,'yaxis');
surf(Tt,Ft,abs(Pt),'EdgeColor','none','EdgeLighting','phong','FaceColor','interp');axis xy; axis tight; colormap(jet);
xlabel('Time s.');
ylabel('aZ Frequency (Hz)');
view([0 90]);