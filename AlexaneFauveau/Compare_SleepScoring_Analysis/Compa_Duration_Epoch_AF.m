

%% Coder en fonction 
%%
clear

i=0;
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ5_240411/1563_BaselineSleep5_240411/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1562_BaselineSleep6_240412/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1563_BaselineSleep6_240412/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ8_240416_104716/1562_BaselineSleep8_240416/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ8_240416_104716/1563_BaselineSleep8_240416/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ9_240417_111622/1562_BaselineSleep9_240417/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ9_240417_111622/1563_BaselineSleep9_240417/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ10_240418_094639/1562_BaselineSleep10_240418/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ10_240418_094639/1563_BaselineSleep10_240418/1563_BaselineSleep10/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1566_1569_1568_1562_HabJ11 _240422_103619/1562_BaselineSleep11_240422/1562_BaselineSleep11/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1563_BaselineSleep12_240423/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1566_BaselineSleep12_240423/1566_BaselineSleep12/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1568_BaselineSleep12_240423/';
% i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1569_BaselineSleep12_240423/';


p_wake_OB = 0;
p_sleep_OB = 0;
p_wake_accelero = 0;
p_sleep_accelero = 0;
p_wake_piezo = 0;
p_sleep_piezo = 0;
for i = 1:length(FolderName)
    

    % Load the good file
    cd(FolderName{i});

    % Compare features together : total time, % of time, nb of epidose, mean time of episode
    % OB
    load SleepScoring_OBGamma Wake Sleep
    starts_wake = Start(Wake,'s');
    stops_wake = Stop(Wake,'s');
    starts_sleep = Start(Sleep,'s');
    stops_sleep = Stop(Sleep,'s');
    for l = 1:length(starts_wake)
        duration_wake_OB(1, l+p_wake_OB) = stops_wake(l)-starts_wake(l);
    end
    for l = 1:length(starts_sleep);
        duration_sleep_OB(1,l+p_sleep_OB) = stops_sleep(l)-starts_sleep(l);
    end
    
    clear starts_wake
    clear stops_wake
    clear starts_sleep
    clear stops_sleep

    p_wake_OB = length(duration_wake_OB);
    p_sleep_OB = length(duration_sleep_OB);
    
    
    
    % Accelero
    load SleepScoring_Accelero Wake Sleep
    starts_wake_accelero = Start(Wake,'s');
    stops_wake_accelero = Stop(Wake,'s');
    starts_sleep_accelero = Start(Sleep,'s');
    stops_sleep_accelero = Stop(Sleep,'s');
    for l = 1:length(starts_wake_accelero);
        duration_wake_accelero(1, l+p_wake_accelero) = stops_wake_accelero(l)-starts_wake_accelero(l);
    end
    for l = 1:length(starts_sleep_accelero);
        duration_sleep_accelero(1,l+p_sleep_accelero) = stops_sleep_accelero(l)-starts_sleep_accelero(l);;
    end
    clear starts_wake_accelero
    clear stops_wake_accelero
    clear starts_sleep_accelero
    clear stops_sleep_accelero
    
    p_wake_accelero = length(duration_wake_accelero);
    p_sleep_accelero = length(duration_sleep_accelero);
    
    % Piezo
    load PiezoData_SleepScoring WakeEpoch_Piezo SleepEpoch_Piezo
    starts_wake_piezo = Start(WakeEpoch_Piezo,'s');
    stops_wake_piezo = Stop(WakeEpoch_Piezo,'s');
    starts_sleep_piezo = Start(SleepEpoch_Piezo,'s');
    stops_sleep_piezo = Stop(SleepEpoch_Piezo,'s');
    for l = 1:length(starts_wake_piezo)
        duration_wake_piezo(1, l+p_wake_piezo) = stops_wake_piezo(l)-starts_wake_piezo(l);
    end
    for l = 1:length(starts_sleep_piezo)
        duration_sleep_piezo(1,l+p_sleep_piezo) = stops_sleep_piezo(l)-starts_sleep_piezo(l);
    end
        
    clear starts_wake_piezo
    clear stops_wake_piezo
    clear starts_sleep_piezo
    clear stops_sleep_piezo
    
    p_wake_piezo = length(duration_wake_piezo);
    p_sleep_piezo = length(duration_sleep_piezo);
    
end


color = {[0.9290 0.6940 0.1250] [0 1 0] [0.3010 0.7450 0.9330]};

groups = {'OB','Movement','Actimetry'};
% nbins = 10000;
% figure
% nhist({duration_wake_OB,duration_wake_accelero,duration_wake_piezo},'binfactor',5000, 'color', color)
% xlim([0, 40])
% xlabel('')
% ylabel('')
% title('')
% b.FaceColor = 'flat';
% b.CData(1,:) = [0.9290 0.6940 0.1250];
% b.CData(2,:) = [0 1 0];
% b.CData(3,:) = [0.3010 0.7450 0.9330];

n=1000;
figure, hold on,
subplot(2,1,1)
[h3,b3]=hist(duration_sleep_OB,n);
[h2,b2]=hist(duration_sleep_accelero,n);
[h,b]=hist(duration_sleep_piezo,n);
plot(b,h,'color',[0.3010 0.7450 0.9330],'linewidth',2), 
hold on 
plot(b2,h2,'color',[0 1 0],'linewidth',2), 
hold on
plot(b3,h3, 'color',[0.9290 0.6940 0.1250],'linewidth',2),
xlim([0, 400])
xlabel('Duration in s')
ylabel('Number of epochs')
title('Distribution of the duration of Sleep epochs')


n=10000;
subplot(2,1,2)
[h3,b3]=hist(duration_wake_OB,n);
[h2,b2]=hist(duration_wake_accelero,n);
[h,b]=hist(duration_wake_piezo,n);
plot(b,h,'color',[0.3010 0.7450 0.9330],'linewidth',2), 
hold on
plot(b2,h2,'color',[0 1 0],'linewidth',2), 
hold on
plot(b3,h3, 'color',[0.9290 0.6940 0.1250],'linewidth',2),
xlim([0, 400])
xlabel('Duration in s')
ylabel('Number of epochs')
title('Distribution of the duration of Wake epochs')
hold on 

