%% Code to do the overlap figure for the mean of all mice

clear all 

%% Create the FolderName

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



for i = 1:length(FolderName)

    % Load the good file
    cd(FolderName{i});

    % Create the Sleep without microwake
    load('SleepScoring_OBGamma.mat','Wake');
    load('SleepScoring_OBGamma.mat','SmoothGamma');
    Wake_LongOnly_OB = dropShortIntervals(Wake,30*1e4);

    TotalEpoch = intervalSet(0,max(Range(SmoothGamma)));
    Sleep_without_MicroWake_OB = TotalEpoch - Wake_LongOnly_OB;


    load('SleepScoring_Accelero.mat','Wake');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Wake_LongOnly_accelero = dropShortIntervals(Wake,30*1e4);

    TotalEpoch = intervalSet(0,max(Range(tsdMovement)));
    Sleep_without_MicroWake_accelero = TotalEpoch - Wake_LongOnly_accelero;

    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    Wake_LongOnly_piezo = dropShortIntervals(WakeEpoch_Piezo,30*1e4);

    TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
    Sleep_without_MicroWake_piezo = TotalEpoch - Wake_LongOnly_piezo;

    % Create the sleep without sleep in long period of wake
    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    % Delate the short period of sleep within 2 big periods of wake
    Short_sleep_during_wake = SandwichEpoch(SleepEpoch_Piezo, WakeEpoch_Piezo, 60*1e4, 30*1e4);
    New_sleep = SleepEpoch_Piezo-Short_sleep_during_wake;

        TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
        New_Wake = TotalEpoch - New_sleep;



    %% Compare with OB scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');

    % Do the proba
    durS_OB = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
    durSS_Piez_OB = sum(Stop(and(New_sleep,Sleep),'s') - Start(and(New_sleep,Sleep),'s'));
    proba_S_S_OB_corrected  = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(New_Wake,Sleep),'s') - Start(and(New_Wake,Sleep),'s'));
    proba_W_S_OB_corrected = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(Wake,'s') - Start(Wake,'s'));
    durWW_Piez_OB = sum(Stop(and(New_Wake,Wake),'s') - Start(and(New_Wake,Wake),'s'));
    proba_W_W_OB_corrected  = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(New_sleep,Wake),'s') - Start(and(New_sleep,Wake),'s'));
    proba_S_W_OB_corrected  = (durSW_Piez_OB/durW_OB)*100 ; 

    durS_OB = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
    durSS_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(Wake,'s') - Start(Wake,'s'));
    durWW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ;
    
    
    durS_OB = sum(Stop(Sleep_without_MicroWake_OB,'s') - Start(Sleep_without_MicroWake_OB,'s'));
    durSS_Piez_OB = sum(Stop(and(Sleep_without_MicroWake_piezo,Sleep_without_MicroWake_OB),'s') - Start(and(Sleep_without_MicroWake_piezo,Sleep_without_MicroWake_OB),'s'));
    proba_S_S_OB_withoutshortwake = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(Wake_LongOnly_piezo,Sleep_without_MicroWake_OB),'s') - Start(and(Wake_LongOnly_piezo,Sleep_without_MicroWake_OB),'s'));
    proba_W_S_OB_withoutshortwake = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(Wake_LongOnly_OB,'s') - Start(Wake_LongOnly_OB,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_LongOnly_piezo,Wake_LongOnly_OB),'s') - Start(and(Wake_LongOnly_piezo,Wake_LongOnly_OB),'s'));
    proba_W_W_OB_withoutshortwake = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(Sleep_without_MicroWake_piezo,Wake_LongOnly_OB),'s') - Start(and(Sleep_without_MicroWake_piezo,Wake_LongOnly_OB),'s'));
    proba_S_W_OB_withoutshortwake = (durSW_Piez_OB/durW_OB)*100 ; 

    %% Compare with Accelero scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');

    % Do the proba
    durS_accelero = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
    durSS_Piez_accelero = sum(Stop(and(New_sleep,Sleep),'s') - Start(and(New_sleep,Sleep),'s'));
    proba_S_S_accelero_corrected  = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(New_Wake,Sleep),'s') - Start(and(New_Wake,Sleep),'s'));
    proba_W_S_accelero_corrected  = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake,'s') - Start(Wake,'s'));
    durWW_Piez_accelero = sum(Stop(and(New_Wake,Wake),'s') - Start(and(New_Wake,Wake),'s'));
    proba_W_W_accelero_corrected  = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(New_sleep,Wake),'s') - Start(and(New_sleep,Wake),'s'));
    proba_S_W_accelero_corrected  = (durSW_Piez_accelero/durW_accelero)*100 ; 

    durS_accelero = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
    durSS_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake,'s') - Start(Wake,'s'));
    durWW_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 

    durS_accelero = sum(Stop(Sleep_without_MicroWake_accelero,'s') - Start(Sleep_without_MicroWake_accelero,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_without_MicroWake_piezo,Sleep_without_MicroWake_accelero),'s') - Start(and(Sleep_without_MicroWake_piezo,Sleep_without_MicroWake_accelero),'s'));
    proba_S_S_accelero_withoutshortwake = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_LongOnly_piezo,Sleep_without_MicroWake_accelero),'s') - Start(and(Wake_LongOnly_piezo,Sleep_without_MicroWake_accelero),'s'));
    proba_W_S_accelero_withoutshortwake = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake_LongOnly_accelero,'s') - Start(Wake_LongOnly_accelero,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_LongOnly_piezo,Wake_LongOnly_accelero),'s') - Start(and(Wake_LongOnly_piezo,Wake_LongOnly_accelero),'s'));
    proba_W_W_accelero_withoutshortwake = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_without_MicroWake_piezo,Wake_LongOnly_accelero),'s') - Start(and(Sleep_without_MicroWake_piezo,Wake_LongOnly_accelero),'s'));
    proba_S_W_accelero_withoutshortwake = (durSW_Piez_accelero/durW_accelero)*100 ; 
    
    

    % Create the table : 
    values_overlap_SleepScoring_AF(i,1) = proba_S_S_OB;
    values_overlap_SleepScoring_AF(i,2) = proba_W_S_OB;
    values_overlap_SleepScoring_AF(i,3) = proba_W_W_OB;
    values_overlap_SleepScoring_AF(i,4) = proba_S_W_OB;
    values_overlap_SleepScoring_AF(i,5) = proba_S_S_OB_corrected;
    values_overlap_SleepScoring_AF(i,6) = proba_W_S_OB_corrected;
    values_overlap_SleepScoring_AF(i,7) = proba_W_W_OB_corrected;
    values_overlap_SleepScoring_AF(i,8) = proba_S_W_OB_corrected;
    values_overlap_SleepScoring_AF(i,9) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF(i,10) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF(i,11) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF(i,12) = proba_S_W_accelero;
    values_overlap_SleepScoring_AF(i,13) = proba_S_S_accelero_corrected;
    values_overlap_SleepScoring_AF(i,14) = proba_W_S_accelero_corrected;
    values_overlap_SleepScoring_AF(i,15) = proba_W_W_accelero_corrected;
    values_overlap_SleepScoring_AF(i,16) = proba_S_W_accelero_corrected;
    values_overlap_SleepScoring_AF(i,17) = proba_S_S_OB_withoutshortwake;
    values_overlap_SleepScoring_AF(i,18) = proba_W_S_OB_withoutshortwake;
    values_overlap_SleepScoring_AF(i,19) = proba_W_W_OB_withoutshortwake;
    values_overlap_SleepScoring_AF(i,20) = proba_S_W_OB_withoutshortwake;
    values_overlap_SleepScoring_AF(i,21) = proba_S_S_accelero_withoutshortwake;
    values_overlap_SleepScoring_AF(i,22) = proba_W_S_accelero_withoutshortwake;
    values_overlap_SleepScoring_AF(i,23) = proba_W_W_accelero_withoutshortwake;
    values_overlap_SleepScoring_AF(i,24) = proba_S_W_accelero_withoutshortwake;
end

for m = 1:24;
mean_values_overlap_SleepScoring_AF(1,m) = mean(values_overlap_SleepScoring_AF(:,m));
end



%% Compare Accelero and OB

 for i = 1:length(FolderName)
    % Load the good file
    cd(FolderName{i});%% Compare with Accelero scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    Sleep_accelero = Sleep
    Wake_accelero = Wake
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');


    % Do the proba
    durS_accelero = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,Sleep),'s') - Start(and(Sleep_accelero,Sleep),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,Sleep),'s') - Start(and(Wake_accelero,Sleep),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake,'s') - Start(Wake,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,Wake),'s') - Start(and(Wake_accelero,Wake),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,Wake),'s') - Start(and(Sleep_accelero,Wake),'s'));
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 
    

    % Create the table : 
    values_overlap_SleepScoring_AF_accelero_ob(i,1) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,2) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,3) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,4) = proba_S_W_accelero;
 end
for m = 1:4;
mean_values_overlap_SleepScoring_AF_accelero_ob(1,m) = mean(values_overlap_SleepScoring_AF_accelero_ob(:,m));
end
    


%% Plot the figure : 
labels= {'Sleep','Wake'};

fig = figure;
subplot(1,7,1)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,1),mean_values_overlap_SleepScoring_AF_accelero_ob(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,3),mean_values_overlap_SleepScoring_AF_accelero_ob(1,4)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,3)),std(values_overlap_SleepScoring_AF_accelero_ob(:,3)),'.')
plot(2,values_overlap_SleepScoring_AF(:,3),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Movement Scoring');
ylim([0 100]);

subplot(1,7,2)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,1),mean_values_overlap_SleepScoring_AF(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,3),mean_values_overlap_SleepScoring_AF(1,4)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF(:,1)),std(values_overlap_SleepScoring_AF(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,3)),std(values_overlap_SleepScoring_AF(:,3)),'.')
plot(2,values_overlap_SleepScoring_AF(:,3),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,7,5)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,9),mean_values_overlap_SleepScoring_AF(1,10)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,11),mean_values_overlap_SleepScoring_AF(1,12)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,9)),std(values_overlap_SleepScoring_AF(:,9)),'.')
plot(1,values_overlap_SleepScoring_AF(:,9),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,11)),std(values_overlap_SleepScoring_AF(:,11)),'.')
plot(2,values_overlap_SleepScoring_AF(:,11),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Movement');
title('Original');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,7,3);
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,5),mean_values_overlap_SleepScoring_AF(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,7),mean_values_overlap_SleepScoring_AF(1,8)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,5)),std(values_overlap_SleepScoring_AF(:,5)),'.')
plot(1,values_overlap_SleepScoring_AF(:,5),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,7)),std(values_overlap_SleepScoring_AF(:,7)),'.')
plot(2,values_overlap_SleepScoring_AF(:,7),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Corrected');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,7,6);
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,13),mean_values_overlap_SleepScoring_AF(1,14)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,15),mean_values_overlap_SleepScoring_AF(1,16)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,13)),std(values_overlap_SleepScoring_AF(:,13)),'.')
plot(1,values_overlap_SleepScoring_AF(:,13),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,15)),std(values_overlap_SleepScoring_AF(:,15)),'.')
plot(2,values_overlap_SleepScoring_AF(:,15),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Movement');
title('Corrected');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,7,4);
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,17),mean_values_overlap_SleepScoring_AF(1,18)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,19),mean_values_overlap_SleepScoring_AF(1,20)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,17)),std(values_overlap_SleepScoring_AF(:,17)),'.')
plot(1,values_overlap_SleepScoring_AF(:,17),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,19)),std(values_overlap_SleepScoring_AF(:,19)),'.')
plot(2,values_overlap_SleepScoring_AF(:,19),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Without short wake -less than 30s-');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,7,7);
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,21),mean_values_overlap_SleepScoring_AF(1,22)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,23),mean_values_overlap_SleepScoring_AF(1,24)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,21)),std(values_overlap_SleepScoring_AF(:,21)),'.')
plot(1,values_overlap_SleepScoring_AF(:,21),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,23)),std(values_overlap_SleepScoring_AF(:,23)),'.')
plot(2,values_overlap_SleepScoring_AF(:,23),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Movement');
title('Without short wake -less than 30s-');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);









