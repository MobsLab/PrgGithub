%% Piezo Processing
% Project : Audiodream 
% By Sophie Bagur, Alexane Fauveau and Chloé Hayhurst

%% First : making the data readable for the sleep socring.
% The file you're in has to have the intan data (ie. analogin.dat,
% digitalin.dat, info.rhd, settings.xml and time.dat), the piezo
% data(act_XX#X.dat) and the sound data (journal_pause, journal_pause_table, journal_sons, journal_sons_table and start_recording)

clear all, close all
Soundtime_CodeRapport_AF % This code creates the behavResources with TTLInfo

%% Second : Synchronizing the intan and piezo data

% The synchro was done using a pizoelectric which vibrates at 5Hz every hour
% on the piezo, and sends a signal on the DigitalIN 8 on Intan. 

clear all

% MousePiezoNum = str2double(inputdlg(['NumberOfPiezo']));

PiezoNum = [1 2 3 5 6 7];

Folder = [cd , '/'];
SynchroPiezoNum = 4;
Synchro_thresh = 1*1e-3;

% Get Sync events from the piezo

allfiles = dir(Folder);
name_file = [Folder allfiles(5).name(1:8) sprintf('#%d.dat', SynchroPiezoNum)];
try
    data = load(name_file);
catch
    name_file = [Folder allfiles(21).name(1:8) sprintf('#%d.dat', SynchroPiezoNum)];
    data = load(name_file);
end

Piezo_tsd = tsd(data(:,1)*1e4,data(:,2));
Fil_Piezo_tsd = FilterLFP(Piezo_tsd,[3 7],256);
PiezoEvent = tsd(Range(Piezo_tsd),Data(Fil_Piezo_tsd).^2);

% plot to see if it's OK
figure
plot(Range(Piezo_tsd,'s'),Data(PiezoEvent))
t_start = min(Range(Piezo_tsd));
t_stop = max(Range(Piezo_tsd));

Synchro_Epoch = thresholdIntervals(PiezoEvent,Synchro_thresh,'Direction','Above');
Synchro_Epoch = mergeCloseIntervals(Synchro_Epoch,1*1e4);
Synchro_Epoch = dropShortIntervals(Synchro_Epoch,0.8*1e4);
Synchro_Epoch = and(Synchro_Epoch,intervalSet(t_start*1e4,t_stop*1e4));
Synchro_Piezo_Start = Start(Synchro_Epoch);
NumPiezoSynch = length((Synchro_Piezo_Start));

hold on,plot(Range(Restrict(Piezo_tsd,Synchro_Epoch),'s'),Data(Restrict(PiezoEvent,Synchro_Epoch)),'.r')
plot(Synchro_Piezo_Start/1e4,Synchro_thresh,'k*')
% xlim([0 max(Range(Piezo_tsd,'s'))])

%% Get sync events intan

load([Folder 'behavResources.mat'])
Synchro_Intan_Start = [TTLInfo.StartSession;Start(TTLInfo.Sync)]; %%%%%%%%%%%%%%%%%%%%%

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


%% Save all the piezo data

% piezo_file = [Folder allfiles(5).name(1:8) sprintf('#%d.dat', MousePiezoNum)];    % You may have to change the name of files
% data = load(piezo_file);
% Piezo_Mouse_tsd = tsd(new_piezo_time,data(:,2));
% save([num2str(Mouse) '_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd')

% close all;

for i = PiezoNum
    if i==1
        Mouse = 1618;
    elseif i == 2
        Mouse = 1617;
    elseif i == 3
        Mouse = 1620;
    elseif i == 4
        disp('Not Possible, 4 is the number of synch!');
    elseif i == 5
        Mouse = 1616;
    elseif i == 6
        Mouse = 1615;
    elseif i == 7
        Mouse = 1619;
    elseif i == 8
        disp('Not possible, this cage doesnt work');
    end
    
    disp(i);
    
    piezo_file = [Folder allfiles(5).name(1:8) sprintf('#%d.dat', i)];    % You may have to change the name of files
    try
        data = load(piezo_file);
    catch
        piezo_file = [Folder allfiles(21).name(1:8) sprintf('#%d.dat', i)];
        data = load(piezo_file);
    end
    Piezo_Mouse_tsd = tsd(new_piezo_time,data(:,2));
    save([num2str(Mouse) '_PiezoData_Corrected.mat'],'Piezo_Mouse_tsd')
    load('behavResources.mat','TTLInfo')
    
    % Do the sleep scoring
    if exist([num2str(Mouse) '_SleepScoring.png'])==0

            load([num2str(Mouse) '_PiezoData_Corrected.mat'])
            [WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF(Piezo_Mouse_tsd, Folder, Mouse, TTLInfo)
            
        saveas(gcf, [num2str(Mouse) '_SleepScoring.png'])
    end
    close all
end
