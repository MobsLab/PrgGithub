% AnlaySystematicSpectro

% a partir d'un fichier .lfp, 
% renvoie un ensemble de fichier .mat contenant:
%      - les vecteurs de données des spectrogrammes 
%      - les paramètres utilisés pour la réalisation du calcul, notamment
%      SampleFreq qui fournit la fréquence d'échantillonage du signal sur
%      lequel on effectue le calcul du spectrogramme.  
% Pour chaque la voie 1 de LFP spécifiée par l'utilisateur dans listLFP.channels
% on obtient un Spectro01.mat 

% Liste des fonctions/scripts appelés:
% SetCurrentSession
% resample
% mtspecgramc

% 14 Janvier 2013 - ESPCI UMR 7637 - Equipe Karim Benchenane
% Utilisateur Marie Lacroix

%% Initialisation

% ---- Inputs ------
listLFP.channels=[];% liste des numéros de lfp dans neuroscope. A fournir
SampleFreq=1250; % default 1250Hz, used 200 Hz
% ------------------

Params.Fs=1250;
Params.trialave=0;
Params.err=[1 0.0500];
Params.pad=2;
Params.fpass=[0 30];
%Params.tapers=[1 2];
Params.tapers=[3 5];
movingwin=[3 0.2];



SetCurrentSession
SetCurrentSession('same')

%% Calcul Spectro

lfp=GetLFP('all');
    
 for i=1:1:length(listLFP.channels)
    
     params=Params;
     if SampleFreq~=Params.Fs
        LFPtemp=resample(lfp(:,listLFP.channels(i)+2),DownSampleFreq,params.Fs);
        params.Fs=SampleFreq;
     else
        LFPtemp=lfp(:,listLFP.channels(i)+2);
     end
    
     [Sp,t,f]=mtspecgramc(LFPtemp,movingwin,params);
     
     if listLFP.channels(i)<10
         save(['Spectro0',listLFP.channels(i),'.mat'],'Sp','t','f','params','movingwin')
     else
         save(['Spectro',listLFP.channels(i),'.mat'],'Sp','t','f','params','movingwin')
     end
     
 end
                    