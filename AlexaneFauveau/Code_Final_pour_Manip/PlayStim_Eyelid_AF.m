clear all
%% Code pour jouer le son pendant la manip Audiodream
% Protocole adapté pour 12h, avec une pause de 2h.
% Load the PulsePal
addpath(genpath('C:\Users\MOBSmembers\Documents\MATLAB\PulsePalCode'))

SaveFoldername = 'C:\Users\MOBSmembers\Documents\Audiodream\2_Eyelid'
cd(SaveFoldername)

    
% Connect to PP
PulsePal
    % Program PP
ProgramPulsePalParam(1, 'IsBiphasic', 1); 
ProgramPulsePalParam(1, 'Phase1Duration', 0.001); 
ProgramPulsePalParam(1, 'Phase2Duration', 0.001); 
ProgramPulsePalParam(1, 'InterPhaseInterval', 0.00); 
ProgramPulsePalParam(1, 'InterPulseInterval', 0.0073); 
ProgramPulsePalParam(1, 'PulseTrainDelay', 0.00); 
ProgramPulsePalParam(1, 'PulseTrainDuration', 0.2); 
ProgramPulsePalParam(1, 'Phase1Voltage', (0))
ProgramPulsePalParam(1, 'Phase2Voltage', (0))

    % Connect to arduino
ard = serial('Com3');
fopen(ard)

% Donner les voltages : 
voltages = [1.5 2 2.5 3]
% Durée de jeu des sons (en secondes)
duree_min = 1 * 60; % 15 minutes en secondes
duree_max = 2 * 60; % 25 minutes en secondes

% Temps total de simulation (en secondes)
temps_total = 4 * 3600; % 24 heures en secondes


% Initialisation du temps écoulé
temps_ecoule = 0;

% Initialisation du journal des sons joués
journal_stim = cell(0, 2);

% Boucle principale
p1 = 0;

% Start intan
fwrite(ard,1)

% start 0.001

while temps_ecoule < temps_total
    % Générer un temps aléatoire pour la prochaine lecture de son
    temps_prochain_son = randi([duree_min, duree_max]);

    % Jouer un son aléatoire à une intensité aléatoire
    voltage_choisi = voltages(randi(numel(voltages)));
    inverse_voltage_choisi = -(voltage_choisi);
    
    ProgramPulsePalParam(1, 'Phase1Voltage', (voltage_choisi))
    ProgramPulsePalParam(1, 'Phase2Voltage', (inverse_voltage_choisi))

    % Enregistrer dans le journal des sons joués
    journal_stim{end+1, 1} = voltage_choisi;
    journal_stim{end, 3} = temps_prochain_son/60 ;
    journal_stim{end, 4} = temps_prochain_son; 
    now_time = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
    disp(['Stim à un voltage de ', num2str(voltage_choisi),' Volt à ' , now_time])
    journal_stim{end, 2} = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF'); % Enregistrer le temps actuel
    fwrite(ard,9)

    save('journal_stim.mat','journal_stim')
    journal_stim_table = cell2table(journal_stim)
    save('journal_stim_table.mat','journal_stim_table')
    
    % Mettre en pause pendant le temps défini
    pause(temps_prochain_son);

    % Mettre à jour le temps écoulé
    temps_ecoule = temps_ecoule + temps_prochain_son;

   
end

% Afficher le journal des sons joués
disp('--- Journal des stim joués ---');
disp('Stim joué               | Moment de lecture');
disp(journal_stim);
disp('--- Journal des pauses ---');
disp('Pause                  | Moment du début de la pause');
disp(journal_pause);       

% Switch off intan
fwrite(ard,3)

%% Sauvergarder les journaux sons et pauses
% SaveFoldername = uigetdir('','Crée et ouvre un nouveau fichier Test')
% cd(SaveFoldername)
% save('journal_stim.mat','journal_stim')
% journal_stim_table = cell2table(journal_stim)
% save('journal_stim_table.mat','journal_stim_table')


%%%%%

%%
fwrite(ard,1)


voltage_choisi = 3;
inverse_voltage_choisi = -voltage_choisi;
ProgramPulsePalParam(1, 'Phase1Voltage', (voltage_choisi))
ProgramPulsePalParam(1, 'Phase2Voltage', (inverse_voltage_choisi))

    % Enregistrer dans le journal des sons joués
    journal_stim{end+1, 1} = voltage_choisi;
    now_time = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF');
    disp(['Stim à un voltage de ', num2str(voltage_choisi),' Volt à ' , now_time])
    journal_stim{end, 2} = datestr(now, 'dd-mm-yyyy HH:MM:SS:FFF'); % Enregistrer le temps actuel
    fwrite(ard,9)

    save('journal_stim.mat','journal_stim')
    journal_stim_table = cell2table(journal_stim)
    save('journal_stim_table.mat','journal_stim_table')
    
    
    
    fwrite(ard,3)
