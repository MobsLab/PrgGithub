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


%% En comptant l'extérieur : 
for i = 1:length(FolderName)

    % Load the good file
    cd(FolderName{i});

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
%     load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_accelero = and(Wake, Periode_sommeil_accelero);
    clear Sleep
    clear Wake
    
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
%     load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_OB = and(Sleep, Periode_sommeil_OB);
    Wake_OB = and(Wake, Periode_sommeil_OB);
    


    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
%     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
%     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    SleepEpoch_Piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    WakeEpoch_Piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);

    
    
      
   
    %% Compare with OB scoring 

    % Do the proba
    durS_OB = sum(Stop(SleepEpoch_Piezo,'s') - Start(SleepEpoch_Piezo,'s'));
    durSS_Piez_OB = sum(Stop(and(Sleep_OB,SleepEpoch_Piezo),'s') - Start(and(Sleep_OB,SleepEpoch_Piezo),'s'));
    proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(Wake_OB,SleepEpoch_Piezo),'s') - Start(and(Wake_OB,SleepEpoch_Piezo),'s'));
    proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB,WakeEpoch_Piezo),'s') - Start(and(Wake_OB,WakeEpoch_Piezo),'s'));
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(Sleep_OB,WakeEpoch_Piezo),'s') - Start(and(Sleep_OB,WakeEpoch_Piezo),'s'));
    proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ;

    %% Compare with Accelero scoring 

    % Do the proba
    durS_accelero = sum(Stop(SleepEpoch_Piezo,'s') - Start(SleepEpoch_Piezo,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,SleepEpoch_Piezo),'s') - Start(and(Sleep_accelero,SleepEpoch_Piezo),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,SleepEpoch_Piezo),'s') - Start(and(Wake_accelero,SleepEpoch_Piezo),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,WakeEpoch_Piezo),'s') - Start(and(Wake_accelero,WakeEpoch_Piezo),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,WakeEpoch_Piezo),'s') - Start(and(Sleep_accelero,WakeEpoch_Piezo),'s'));
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ;


    % Create the table : 
    values_overlap_SleepScoring_AF(i,1) = proba_S_S_OB;
    values_overlap_SleepScoring_AF(i,2) = proba_W_S_OB;
    values_overlap_SleepScoring_AF(i,3) = proba_W_W_OB;
    values_overlap_SleepScoring_AF(i,4) = proba_S_W_OB;
    values_overlap_SleepScoring_AF(i,9) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF(i,10) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF(i,11) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF(i,12) = proba_S_W_accelero;

end

for m = 1:12;
mean_values_overlap_SleepScoring_AF(1,m) = mean(values_overlap_SleepScoring_AF(:,m));
end



%% Compare Accelero and OB

 for i = 1:length(FolderName)
    % Load the good file
    cd(FolderName{i});%% Compare with Accelero scoring 

    % Do the proba
    durS_accelero = sum(Stop(Sleep_accelero,'s') - Start(Sleep_accelero,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_OB,Sleep_accelero),'s') - Start(and(Sleep_OB,Sleep_accelero),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_OB,Sleep_accelero),'s') - Start(and(Wake_OB,Sleep_accelero),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake_accelero,'s') - Start(Wake_accelero,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_OB,Wake_accelero),'s') - Start(and(Wake_OB,Wake_accelero),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_OB,Wake_accelero),'s') - Start(and(Sleep_OB,Wake_accelero),'s'));
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
labels= {'Sommeil','Eveil'};

fig = figure;
subplot(1,3,1)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,1),mean_values_overlap_SleepScoring_AF_accelero_ob(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,4),mean_values_overlap_SleepScoring_AF_accelero_ob(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,4)),std(values_overlap_SleepScoring_AF_accelero_ob(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Mouvement');
title('Mouvement / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(132)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,1),mean_values_overlap_SleepScoring_AF(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,4),mean_values_overlap_SleepScoring_AF(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF(:,1)),std(values_overlap_SleepScoring_AF(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,4)),std(values_overlap_SleepScoring_AF(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piézo');
title('Piézo / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(133)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,9),mean_values_overlap_SleepScoring_AF(1,10)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,12),mean_values_overlap_SleepScoring_AF(1,11)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,9)),std(values_overlap_SleepScoring_AF(:,9)),'.')
plot(1,values_overlap_SleepScoring_AF(:,9),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,12)),std(values_overlap_SleepScoring_AF(:,12)),'.')
plot(2,values_overlap_SleepScoring_AF(:,12),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piezo');
title('Piezo / Mouvement');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'Mouvement');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';
















%% 
for i = 1:length(FolderName)

    % Load the good file
    cd(FolderName{i});

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
%     load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_accelero = and(Wake, Periode_sommeil_accelero);
    clear Sleep
    clear Wake
    
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
%     load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_OB = and(Sleep, Periode_sommeil_OB);
    Wake_OB = and(Wake, Periode_sommeil_OB);
    


    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
%     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
%     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    SleepEpoch_Piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    WakeEpoch_Piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);

    
    
      
   
    %% Compare with OB scoring 

    % Do the proba
    durSS_Piez_OB = sum(Stop(and(Sleep_OB,SleepEpoch_Piezo),'s') - Start(and(Sleep_OB,SleepEpoch_Piezo),'s'));
    durWS_Piez_OB = sum(Stop(and(Wake_OB,SleepEpoch_Piezo),'s') - Start(and(Wake_OB,SleepEpoch_Piezo),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
    proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

    durWW_Piez_OB = sum(Stop(and(Wake_OB,WakeEpoch_Piezo),'s') - Start(and(Wake_OB,WakeEpoch_Piezo),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep_OB,WakeEpoch_Piezo),'s') - Start(and(Sleep_OB,WakeEpoch_Piezo),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB;
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
    proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ;

    %% Compare with Accelero scoring 

    % Do the proba
    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,SleepEpoch_Piezo),'s') - Start(and(Sleep_accelero,SleepEpoch_Piezo),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,SleepEpoch_Piezo),'s') - Start(and(Wake_accelero,SleepEpoch_Piezo),'s'));
    durS_accelero = durWS_Piez_accelero + durSS_Piez_accelero;
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,WakeEpoch_Piezo),'s') - Start(and(Wake_accelero,WakeEpoch_Piezo),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,WakeEpoch_Piezo),'s') - Start(and(Sleep_accelero,WakeEpoch_Piezo),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ;


    % Create the table : 
    values_overlap_SleepScoring_AF(i,1) = proba_S_S_OB;
    values_overlap_SleepScoring_AF(i,2) = proba_W_S_OB;
    values_overlap_SleepScoring_AF(i,3) = proba_W_W_OB;
    values_overlap_SleepScoring_AF(i,4) = proba_S_W_OB;
    values_overlap_SleepScoring_AF(i,9) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF(i,10) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF(i,11) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF(i,12) = proba_S_W_accelero;

end

for m = 1:12;
mean_values_overlap_SleepScoring_AF(1,m) = mean(values_overlap_SleepScoring_AF(:,m));
end



%% Compare Accelero and OB

 for i = 1:length(FolderName)
    % Load the good file
    cd(FolderName{i});%% Compare with Accelero scoring 

        % Load the good file
    cd(FolderName{i});

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
%     load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_accelero = and(Wake, Periode_sommeil_accelero);
    clear Sleep
    clear Wake
    
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
%     load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_OB = and(Sleep, Periode_sommeil_OB);
    Wake_OB = and(Wake, Periode_sommeil_OB);
    


    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
%     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
%     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    SleepEpoch_Piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    WakeEpoch_Piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);

    
    % Do the proba
    durSS_Piez_accelero = sum(Stop(and(Sleep_OB,Sleep_accelero),'s') - Start(and(Sleep_OB,Sleep_accelero),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_OB,Sleep_accelero),'s') - Start(and(Wake_OB,Sleep_accelero),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero; 
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durWW_Piez_accelero = sum(Stop(and(Wake_OB,Wake_accelero),'s') - Start(and(Wake_OB,Wake_accelero),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_OB,Wake_accelero),'s') - Start(and(Sleep_OB,Wake_accelero),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
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
labels= {'Sommeil','Eveil'};

fig = figure;
subplot(1,3,1)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,1),mean_values_overlap_SleepScoring_AF_accelero_ob(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,4),mean_values_overlap_SleepScoring_AF_accelero_ob(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF_accelero_ob(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,4)),std(values_overlap_SleepScoring_AF_accelero_ob(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF_accelero_ob(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Accéléromètre');
title('Accéléromètre / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(132)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,1),mean_values_overlap_SleepScoring_AF(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,4),mean_values_overlap_SleepScoring_AF(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF(:,1)),std(values_overlap_SleepScoring_AF(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,4)),std(values_overlap_SleepScoring_AF(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piezo');
title('Piezo / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(133)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,9),mean_values_overlap_SleepScoring_AF(1,10)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,12),mean_values_overlap_SleepScoring_AF(1,11)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,9)),std(values_overlap_SleepScoring_AF(:,9)),'.')
plot(1,values_overlap_SleepScoring_AF(:,9),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,12)),std(values_overlap_SleepScoring_AF(:,12)),'.')
plot(2,values_overlap_SleepScoring_AF(:,12),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piezo');
title('Piezo / Accéléromètre');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'Accéléromètre');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';









%% En comptant l'extérieur : 
for i = 1:length(FolderName)

    % Load the good file
    cd(FolderName{i});

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
%     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
%     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    SleepEpoch_Piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    WakeEpoch_Piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);
    
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
%     load('SleepScoring_Accelero.mat','tsdMovement');
%     Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
%     Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_accelero = and(Sleep, Periode_sommeil_piezo);
    Wake_accelero = and(Wake, Periode_sommeil_piezo);
    clear Sleep
    clear Wake
    
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
%     load('SleepScoring_OBGamma.mat','SmoothGamma');
%     Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
%     Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_OB = and(Sleep, Periode_sommeil_piezo);
    Wake_OB = and(Wake, Periode_sommeil_piezo);
       
   
    %% Compare with OB scoring 

    % Do the proba
    durS_OB = sum(Stop(SleepEpoch_Piezo,'s') - Start(SleepEpoch_Piezo,'s'));
    durSS_Piez_OB = sum(Stop(and(Sleep_OB,SleepEpoch_Piezo),'s') - Start(and(Sleep_OB,SleepEpoch_Piezo),'s'));
    proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
    durWS_Piez_OB = sum(Stop(and(Wake_OB,SleepEpoch_Piezo),'s') - Start(and(Wake_OB,SleepEpoch_Piezo),'s'));
    proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

    durW_OB = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB,WakeEpoch_Piezo),'s') - Start(and(Wake_OB,WakeEpoch_Piezo),'s'));
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
    durSW_Piez_OB = sum(Stop(and(Sleep_OB,WakeEpoch_Piezo),'s') - Start(and(Sleep_OB,WakeEpoch_Piezo),'s'));
    proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ;

    %% Compare with Accelero scoring 

    % Do the proba
    durS_accelero = sum(Stop(SleepEpoch_Piezo,'s') - Start(SleepEpoch_Piezo,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,SleepEpoch_Piezo),'s') - Start(and(Sleep_accelero,SleepEpoch_Piezo),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,SleepEpoch_Piezo),'s') - Start(and(Wake_accelero,SleepEpoch_Piezo),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,WakeEpoch_Piezo),'s') - Start(and(Wake_accelero,WakeEpoch_Piezo),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,WakeEpoch_Piezo),'s') - Start(and(Sleep_accelero,WakeEpoch_Piezo),'s'));
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ;


    % Create the table : 
    values_overlap_SleepScoring_AF(i,1) = proba_S_S_OB;
    values_overlap_SleepScoring_AF(i,2) = proba_W_S_OB;
    values_overlap_SleepScoring_AF(i,3) = proba_W_W_OB;
    values_overlap_SleepScoring_AF(i,4) = proba_S_W_OB;
    values_overlap_SleepScoring_AF(i,9) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF(i,10) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF(i,11) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF(i,12) = proba_S_W_accelero;

end

for m = 1:12;
mean_values_overlap_SleepScoring_AF(1,m) = mean(values_overlap_SleepScoring_AF(:,m));
end



%% Compare Accelero and OB

 for i = 1:length(FolderName)
    % Load the good file
    cd(FolderName{i});%% Compare with Accelero scoring 

    % Do the proba
    durS_accelero = sum(Stop(Sleep_accelero,'s') - Start(Sleep_accelero,'s'));
    durSS_Piez_accelero = sum(Stop(and(Sleep_OB,Sleep_accelero),'s') - Start(and(Sleep_OB,Sleep_accelero),'s'));
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    durWS_Piez_accelero = sum(Stop(and(Wake_OB,Sleep_accelero),'s') - Start(and(Wake_OB,Sleep_accelero),'s'));
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durW_accelero = sum(Stop(Wake_accelero,'s') - Start(Wake_accelero,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_OB,Wake_accelero),'s') - Start(and(Wake_OB,Wake_accelero),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    durSW_Piez_accelero = sum(Stop(and(Sleep_OB,Wake_accelero),'s') - Start(and(Sleep_OB,Wake_accelero),'s'));
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
labels= {'Sommeil','Eveil'};

fig = figure;
subplot(1,3,1)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,1),mean_values_overlap_SleepScoring_AF_accelero_ob(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,4),mean_values_overlap_SleepScoring_AF_accelero_ob(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,4)),std(values_overlap_SleepScoring_AF_accelero_ob(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Accéléromètre');
title('Accéléromètre / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(132)
proba_sleep = [mean_values_overlap_SleepScoring_AF(1,1),mean_values_overlap_SleepScoring_AF(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,4),mean_values_overlap_SleepScoring_AF(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF(:,1)),std(values_overlap_SleepScoring_AF(:,1)),'.')
plot(1,values_overlap_SleepScoring_AF(:,1),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,4)),std(values_overlap_SleepScoring_AF(:,4)),'.')
plot(2,values_overlap_SleepScoring_AF(:,4),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piézo');
title('Piézo / OB Gamma');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'OB Gamma');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';

subplot(133)

proba_sleep = [mean_values_overlap_SleepScoring_AF(1,9),mean_values_overlap_SleepScoring_AF(1,10)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF(1,12),mean_values_overlap_SleepScoring_AF(1,11)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF(:,9)),std(values_overlap_SleepScoring_AF(:,9)),'.')
plot(1,values_overlap_SleepScoring_AF(:,9),'k.','MarkerSize',10)
errorbar(2,mean(values_overlap_SleepScoring_AF(:,12)),std(values_overlap_SleepScoring_AF(:,12)),'.')
plot(2,values_overlap_SleepScoring_AF(:,12),'k.','MarkerSize',10)
set(gca, 'xticklabel',labels);
ylabel('Chevauchement (%)');
xlabel('Piézo');
title('Piézo / Accéléromètre');
lgd = legend('Sommeil','Eveil','Location','southoutside');
title(lgd,'Accéléromètre');
ylim([0 100]);
yyaxis right 
set(gca,'YDir','reverse')
set(gca, 'YLim', [0 100])
ax = gca;
ax.YColor = 'k';
ax.YAxis(2).Color = 'k';





















