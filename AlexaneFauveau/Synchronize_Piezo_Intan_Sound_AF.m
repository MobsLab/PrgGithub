%% This code allows to synchronize the data of the PiezoSleep System and INTAN (elecctrophysiology signals)
% The synchro was done using a pizoelectric which vibrate at 5Hz every hour
% on the piezo, and send a signal on the DigitalIN 8 on Intan. 

% Project : Audiodream 
% By Sophie Bagur and Alexane Fauveau

% Code used inside of this code :
% - SleepScoring_Piezo_AF : allows to do the sleep_scoring on the
% piezo_data

% Code using this code : 

% Ce code est fait pour analyser les souris 1615 à 1620, en respectant leur
% position sur les cages piézo. 
% Si vous utiliser ce code pour d'autres souris, rectifier le avant. 

% To use this code : be in the folder with the Expe.info and
% SleepScoring_data of the mouse (which is the LFP_Folder path)
% Give the right path for LFP_Folder and Piezo_Folder


clear all
% LFP_Folder = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1563_BaselineSleep6_240412/';
% Piezo_Folder = '/media/gruffalo/DataMOBS198/3_Sound/1615à1620_Sound13_240618/1615à1620_Sound_240618_105237/';

% Adapt those variables to your need ! 
LFP_Folder = '/media/gruffalo/DataMOBS198/3_Sound/1615à1620_Sound15_240620/';
Piezo_Folder = '/media/gruffalo/DataMOBS198/3_Sound/1615à1620_Sound15_240620/1615à1620_Sound_240620_105635/';
    % Put a file with all the act_00XX in it
    
cd(LFP_Folder)

SynchroPiezoNum = 4;
Synchro_thresh = 1*1e-3;


%% Get Sync events from the piezo
allfiles = dir(Piezo_Folder);
name_file = [Piezo_Folder allfiles(5).name(1:8) sprintf('#%d.dat', SynchroPiezoNum)];    % You may have to change the name of files
% Load the .dat
data = load(name_file);
Piezo_tsd = tsd(data(:,1)*1e4,data(:,2));
Fil_Piezo_tsd = FilterLFP(Piezo_tsd,[3 7],256);
PiezoEvent = tsd(Range(Piezo_tsd),Data(Fil_Piezo_tsd).^2);

% figure
% hold on,plot(Range(Piezo_tsd,'h'),Data(PiezoEvent))
% disp('Look for synchro event : does it look good ? What about the first and last ones ?')

% plot to see if it's OK
figure
clf
hold on,plot(Range(Piezo_tsd,'s'),Data(PiezoEvent))
hold on,xlim([0 30*60])
title('When does session start?');
[t_start,y] = ginput(1);
xlim([max(Range(Piezo_tsd,'s'))-30*60 max(Range(Piezo_tsd,'s'))])
title('When does session end?');
[t_stop,y] = ginput(1);

Synchro_Epoch = thresholdIntervals(PiezoEvent,Synchro_thresh,'Direction','Above');
Synchro_Epoch = mergeCloseIntervals(Synchro_Epoch,1*1e4);
Synchro_Epoch = dropShortIntervals(Synchro_Epoch,0.8*1e4);
Synchro_Epoch = and(Synchro_Epoch,intervalSet(t_start*1e4,t_stop*1e4));
Synchro_Piezo_Start = Start(Synchro_Epoch);
NumPiezoSynch = length((Synchro_Piezo_Start));

hold on,plot(Range(Restrict(Piezo_tsd,Synchro_Epoch),'s'),Data(Restrict(PiezoEvent,Synchro_Epoch)),'.r')
plot(Synchro_Piezo_Start/1e4,Synchro_thresh,'k*')
xlim([0 max(Range(Piezo_tsd,'s'))])


%% Get sync events intan
load([LFP_Folder 'behavResources.mat'])
Synchro_Intan_Start = [TTLInfo.StartSession;Start(TTLInfo.Sync)];

%% A MODIF SINON !!!  (Pour ceux qui ont le premier TTL répeter ?)
% Synchro_Intan_Start = Synchro_Intan_Start([3:end]);
%% %%%%%%%%%%%%%%%%%%%%%

NumIntanSynch = length(Synchro_Intan_Start);

if NumPiezoSynch~=NumIntanSynch
   disp('Non matching sync events - do something!!') 
   keyboard % allows to block the code here 
end

%% Line everything up
Synchro_Piezo_Start = Synchro_Piezo_Start;
p = polyfit(Synchro_Piezo_Start,Synchro_Intan_Start,1);
new_piezo_time = p(1)*Range(Piezo_tsd) + p(2);
Piezo_corr_tsd = tsd(new_piezo_time,Data(Fil_Piezo_tsd));


%% Save data piezo

for MousePiezoNum = [1,2,3,5,6,7];   % numéro de la cage

name_file = [Piezo_Folder allfiles(5).name(1:8) sprintf('#%d.dat', MousePiezoNum)];    % You may have to change the name of files
data = load(name_file);
Piezo_Mouse_tsd = tsd(new_piezo_time,data(:,2));
[WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF(Piezo_Mouse_tsd, LFP_Folder)

scoring_ok='n';
user_confirmation =1;

%loop until SleepScorign scoring is ok
while scoring_ok =='n'
    [WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF(Piezo_Mouse_tsd, LFP_Folder)

    %can skip this step if user_confirmation==0
    if user_confirmation
        scoring_ok = input('--- Are you satisfied with the Sleep threshold (y/n) ? ', 's');
        while ~ismember(scoring_ok,['y' 'n' 'm'])
            scoring_ok = input('--- Are you satisfied with the Sleep threshold (y/n) ?', 's');
        end
    else
        scoring_ok='y';
    end
end

if MousePiezoNum == 1
    save([LFP_Folder '1618_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd');
    movefile('PiezoData_SleepScoring.mat','1618_PiezoData_SleepScoring.mat')
elseif MousePiezoNum == 2
    save([LFP_Folder '1617_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd');
    movefile('PiezoData_SleepScoring.mat','1617_PiezoData_SleepScoring.mat')
elseif MousePiezoNum == 3
    save([LFP_Folder '1620_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd');
    movefile('PiezoData_SleepScoring.mat','1620_PiezoData_SleepScoring.mat')
elseif MousePiezoNum == 5
    save([LFP_Folder '1616_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd');
    movefile('PiezoData_SleepScoring.mat','1616_PiezoData_SleepScoring.mat')
elseif MousePiezoNum == 6
    save([LFP_Folder '1615_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd');
    movefile('PiezoData_SleepScoring.mat','1615_PiezoData_SleepScoring.mat')
elseif MousePiezoNum == 7
    save([LFP_Folder '1619_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd'); 
    movefile('PiezoData_SleepScoring.mat','1619_PiezoData_SleepScoring.mat')
end
   
end
    
