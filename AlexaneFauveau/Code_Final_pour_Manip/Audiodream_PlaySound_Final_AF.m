%% Code pour jouer le son pendant la manip Audiodream
% Protocole adapté pour 12h, avec une pause de 2h.

% Load the curve fitting function : 
CurveFittingFolder = 'C:\Users\MOBSmembers\Documents\Audiodream\3_ArousalSound\Son_Audiodream'
cd(CurveFittingFolder)
load fitresult.mat

% Définition des sons et de leurs intensités
SoundFolder = 'C:\Users\MOBSmembers\Documents\Audiodream\3_ArousalSound\Son_Audiodream\'
sons = {'orage_70dB 1.wav', 'Ramps_down_7050_WN.wav', 'Ramps_up_5070_WN.wav', 'Sin20Hz_WN_70dB.wav', 'Sin80Hz_WN_70dB.wav', 'Tono_70dB_WN.wav', 'Tono_70dB_5kHz.wav', 'Tono_70dB_12kHz.wav'};
intensites = [50 60 70 80]; % En dB
SaveFoldername = uigetdir('','Crée et ouvre un nouveau fichier pour enregistrer les données')
cd(SaveFoldername)

% Durée de jeu des sons (en secondes)
duree_min = 10 * 60; % 15 minutes en secondes
duree_max = 15 * 60; % 25 minutes en secondes

% Temps total de simulation (en secondes)
temps_total = 8 * 3600; % x heures en secondes

% Temps de pause sans son (en secondes)
pause_sans_son = 2 * 3600; % 2 heures en secondes

% Initialisation du temps écoulé
temps_ecoule = 0;

% Initialisation du journal des sons joués
journal_sons = cell(0, 2);
journal_pause = cell(0, 2);
journal_X  = cell(0, 2);

%% Connect to arduino
ard = serial('Com3');
fopen(ard)

%% Boucle principale
p1 = 0;

% Start intan
fwrite(ard,1)
start_recording = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF')
save('start_recording.mat','start_recording')

while temps_ecoule < temps_total
    % Générer un temps aléatoire pour la prochaine lecture de son
    temps_prochain_son = randi([duree_min, duree_max]);

    % Jouer un son aléatoire à une intensité aléatoire
    num_son = randi(length(sons));
    son_joue = sons{num_son};
    intensite_choisie = intensites(randi(length(intensites)));

    % Calculer la valeur matlab
    if num_son == 1;
        value_matlab = feval(fitresult{1},intensite_choisie);
    elseif num_son == 2;
        value_matlab =  feval(fitresult{2},intensite_choisie);
    elseif num_son == 3;
        value_matlab =  feval(fitresult{3},intensite_choisie);
    elseif num_son == 4;
        value_matlab =  feval(fitresult{4},intensite_choisie);
    elseif num_son == 5;
        value_matlab = feval(fitresult{5},intensite_choisie);
    elseif num_son == 6;
        value_matlab = feval(fitresult{6},intensite_choisie);
    elseif num_son == 7;
        value_matlab = feval(fitresult{7},intensite_choisie);
    elseif num_son == 8;
        value_matlab = feval(fitresult{8},intensite_choisie);
    end


    % Enregistrer dans le journal des sons joués
    journal_sons{end+1, 1} = son_joue;
    journal_sons{end, 2} = intensite_choisie;
    journal_sons{end, 3} = value_matlab;
    journal_sons{end, 5} = temps_prochain_son/60 ;
    journal_sons{end, 6} = temps_prochain_son; 
    now_time = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
    disp(['Jouer ', son_joue, ' à une intensité de ', num2str(intensite_choisie),' à ' , now_time])
    [audio, Fs] = audioread([SoundFolder son_joue]);
    journal_sons{end, 4} = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF'); % Enregistrer le temps actuel
    sound(audio*value_matlab, Fs)
    
    save('journal_sons.mat','journal_sons');
    journal_sons_table = cell2table(journal_sons);
    save('journal_sons_table.mat','journal_sons_table');
    
    
    % Mettre en pause pendant le temps défini
    pause(temps_prochain_son);

    % Mettre à jour le temps écoulé
    temps_ecoule = temps_ecoule + temps_prochain_son;

    X = randi (10);
    journal_X{end+1, 1} = X;
    journal_X{end, 3} = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
    % Vérifier s'il faut faire une pause sans son
    if X == 1
        if p1 == 0 
            if temps_ecoule < temps_total
            now_time2 = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
            disp(['Pause sans son pendant ', num2str(pause_sans_son / 3600), ' heures', ' à ', now_time2]);
            journal_pause{end+1, 1} = 'Pause 2h';
            journal_pause{end, 3} = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
            pause(pause_sans_son-temps_prochain_son);
            temps_ecoule = temps_ecoule + pause_sans_son;
            p1 = p1 + 1;
            end
        end
    end

    save('journal_pause.mat','journal_pause');
    journal_pause_table = cell2table(journal_pause);
    save('journal_pause_table.mat','journal_pause_table');
end

% Afficher le journal des sons joués
disp('--- Journal des sons joués ---');
disp('Son joué               | Moment de lecture');
disp(journal_sons);
disp('--- Journal des pauses ---');
disp('Pause                  | Moment du début de la pause');
disp(journal_pause);       


%% Switch off intan
fwrite(ard,3)

%% Sauvergarder les journaux sons et pauses
% % SaveFoldername = uigetdir('','Crée et ouvre un nouveau fichier Test')
% % cd(SaveFoldername)
% % save('journal_sons.mat','journal_sons')
% % journal_sons_table = cell2table(journal_sons)
% % save('journal_sons_table.mat','journal_sons_table')
% % 
% % save('journal_pause.mat','journal_pause')
% % journal_pause_table = cell2table(journal_pause)
% % save('journal_pause_table.mat','journal_pause_table')
% % % Il faut faire marcher avec tracking matlab 