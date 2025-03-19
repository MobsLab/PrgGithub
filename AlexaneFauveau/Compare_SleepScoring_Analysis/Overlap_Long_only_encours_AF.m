%% Code to do the overlap figure for the mean of all mice with only lonng period of sleep

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
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','SmoothGamma');
    Sleep_LongOnly_OB = dropShortIntervals(Sleep,30*1e4);
    TotalEpoch = intervalSet(0,max(Range(SmoothGamma)));
    Wake_modified_OB = TotalEpoch - Sleep_LongOnly_OB;

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Sleep_LongOnly_accelero = dropShortIntervals(Sleep,30*1e4);
    TotalEpoch = intervalSet(0,max(Range(tsdMovement)));
    Wake_modified_accelero = TotalEpoch - Sleep_LongOnly_accelero;

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    Sleep_LongOnly_piezo = dropShortIntervals(SleepEpoch_Piezo,30*1e4);
    TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
    Wake_modified_piezo = TotalEpoch - Sleep_LongOnly_piezo;

    figure 
    subplot(311)
    plot(Range(SmoothGamma), Data(SmoothGamma))
    hold on, plot(Range(Restrict(SmoothGamma,Sleep_LongOnly_OB)), Data(Restrict(SmoothGamma,Sleep_LongOnly_OB)),'g');
    
    subplot(312)
    plot(Range(tsdMovement), Data(tsdMovement))
    hold on, plot(Range(Restrict(tsdMovement,Sleep_LongOnly_accelero)), Data(Restrict(tsdMovement,Sleep_LongOnly_accelero)),'g');
    
    subplot(313)
    plot(Range(Piezo_Mouse_tsd), Data(Piezo_Mouse_tsd))
    hold on, plot(Range(Restrict(Piezo_Mouse_tsd,Sleep_LongOnly_piezo)), Data(Restrict(Piezo_Mouse_tsd,Sleep_LongOnly_piezo)),'g');
    
    subplot(311)
    xl = xlim
    subplot(312)
    xlim(xl)
    subplot(313)
    xlim(xl)
    
    %% Compare with OB scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');

    % Do the proba
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
    
    
    durS_OB = sum(Stop(Sleep_LongOnly_OB,'s') - Start(Sleep_LongOnly_OB,'s'));
    durSS_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s'));
    proba_S_S_OB_longsleep_only = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s'));
    proba_W_S_OB_longsleep_only = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(Wake_modified_OB,'s') - Start(Wake_modified_OB,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_modified_piezo,Wake_modified_OB),'s') - Start(and(Wake_modified_piezo,Wake_modified_OB),'s'));
    proba_W_W_OB_longsleep_only = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s'));
    proba_S_W_OB_longsleep_only = (durSW_Piez_OB/durW_OB)*100 ; 

    %% Compare with Accelero scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');

    % Do the proba
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

    durS_accelero = sum(Stop(Sleep_LongOnly_accelero,'s') - Start(Sleep_LongOnly_accelero,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s'));
    proba_S_S_accelero_longsleep_only = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s'));
    proba_W_S_accelero_longsleep_only = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake_modified_accelero,'s') - Start(Wake_modified_accelero,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Wake_modified_accelero),'s') - Start(and(Wake_modified_piezo,Wake_modified_accelero),'s'));
    proba_W_W_accelero_longsleep_only = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s'));
    proba_S_W_accelero_longsleep_only = (durSW_Piez_accelero/durW_accelero)*100 ; 
    
    

    % Create the table : 
    values_overlap_SleepScoring_AF_OB(i,1) = proba_S_S_OB;
    values_overlap_SleepScoring_AF_OB(i,2) = proba_W_S_OB;
    values_overlap_SleepScoring_AF_OB(i,3) = proba_W_W_OB;
    values_overlap_SleepScoring_AF_OB(i,4) = proba_S_W_OB;
    values_overlap_SleepScoring_AF_OB(i,5) = proba_S_S_OB_longsleep_only;
    values_overlap_SleepScoring_AF_OB(i,6) = proba_W_S_OB_longsleep_only;
    values_overlap_SleepScoring_AF_OB(i,7) = proba_W_W_OB_longsleep_only;
    values_overlap_SleepScoring_AF_OB(i,8) = proba_S_W_OB_longsleep_only;

    
    values_overlap_SleepScoring_AF_accelero(i,1) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF_accelero(i,2) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF_accelero(i,3) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF_accelero(i,4) = proba_S_W_accelero;
    values_overlap_SleepScoring_AF_accelero(i,5) = proba_S_S_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero(i,6) = proba_W_S_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero(i,7) = proba_W_W_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero(i,8) = proba_S_W_accelero_longsleep_only;

   
end

for m = 1:8;
    mean_values_overlap_SleepScoring_AF_OB(1,m) = mean(values_overlap_SleepScoring_AF_OB(:,m));
end
for m = 1:8;
    mean_values_overlap_SleepScoring_AF_accelero(1,m) = mean(values_overlap_SleepScoring_AF_accelero(:,m));
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
subplot(1,5,1)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,1),mean_values_overlap_SleepScoring_AF_accelero_ob(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,3),mean_values_overlap_SleepScoring_AF_accelero_ob(1,4)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero_ob(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,3)),std(values_overlap_SleepScoring_AF_accelero_ob(:,3)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero_ob(:,3),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Movement Scoring');
ylim([0 100]);

subplot(1,5,2)
proba_sleep = [mean_values_overlap_SleepScoring_AF_OB(1,1),mean_values_overlap_SleepScoring_AF_OB(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_OB(1,3),mean_values_overlap_SleepScoring_AF_OB(1,4)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_OB(:,1)),std(values_overlap_SleepScoring_AF_OB(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_OB(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_OB(:,3)),std(values_overlap_SleepScoring_AF_OB(:,3)),'.');
plot(2,values_overlap_SleepScoring_AF_OB(:,3),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(1,5,3);
proba_sleep = [mean_values_overlap_SleepScoring_AF_OB(1,5),mean_values_overlap_SleepScoring_AF_OB(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_OB(1,7),mean_values_overlap_SleepScoring_AF_OB(1,8)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF_OB(:,5)),std(values_overlap_SleepScoring_AF_OB(:,5)),'.');
plot(1,values_overlap_SleepScoring_AF_OB(:,5),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_OB(:,7)),std(values_overlap_SleepScoring_AF_OB(:,7)),'.');
plot(2,values_overlap_SleepScoring_AF_OB(:,7),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Long Sleep Only');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(1,5,4)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero(1,1),mean_values_overlap_SleepScoring_AF_accelero(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero(1,3),mean_values_overlap_SleepScoring_AF_accelero(1,4)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero(:,1)),std(values_overlap_SleepScoring_AF_accelero(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero(:,3)),std(values_overlap_SleepScoring_AF_accelero(:,3)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero(:,3),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Accelero');
title('Original');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(1,5,5);
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero(1,5),mean_values_overlap_SleepScoring_AF_accelero(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero(1,7),mean_values_overlap_SleepScoring_AF_accelero(1,8)]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero(:,5)),std(values_overlap_SleepScoring_AF_accelero(:,5)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero(:,5),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero(:,7)),std(values_overlap_SleepScoring_AF_accelero(:,7)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero(:,7),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Accelero');
title('Long Sleep Only');
legend('Similar','Different');
lgd = legend('Similar','Different','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);




