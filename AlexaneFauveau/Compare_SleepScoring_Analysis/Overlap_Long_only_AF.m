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

    % Create the Sleep without microwake    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
    load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_LongOnly_OB = and(Sleep, Periode_sommeil_OB);
    Wake_modified_OB = and(Wake, Periode_sommeil_OB);
    clear Sleep
    clear Wake
    

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_LongOnly_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_modified_accelero = and(Wake, Periode_sommeil_accelero);

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    Sleep_LongOnly_piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    Wake_modified_piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);

    figure 
    subplot(311)
    plot(Range(SmoothGamma,'s'), Data(SmoothGamma),'k')
    hold on, plot(Range(Restrict(SmoothGamma,Periode_sommeil_OB),'s'), Data(Restrict(SmoothGamma,Periode_sommeil_OB)),'g');
    hold on, plot(Range(Restrict(SmoothGamma,Sleep_LongOnly_OB),'s'), Data(Restrict(SmoothGamma,Sleep_LongOnly_OB)),'r');
    hold on, plot(Range(Restrict(SmoothGamma,Wake_modified_OB),'s'), Data(Restrict(SmoothGamma,Wake_modified_OB)),'c');
    xlabel('Temps en heure')
    xlim([0 max(length(Range(SmoothGamma,'s')))/3600])
    title('OB Gamma')
    
    subplot(312)
    plot(Range(tsdMovement,'s'), Data(tsdMovement),'k')
    hold on, plot(Range(Restrict(tsdMovement,Periode_sommeil_accelero),'s'), Data(Restrict(tsdMovement,Periode_sommeil_accelero)),'g');
    hold on, plot(Range(Restrict(tsdMovement,Sleep_LongOnly_accelero),'s'), Data(Restrict(tsdMovement,Sleep_LongOnly_accelero)),'r');
    hold on, plot(Range(Restrict(tsdMovement,Wake_modified_accelero),'s'), Data(Restrict(tsdMovement,Wake_modified_accelero)),'c');
    xlabel('Temps en heure') 
    xlim([0 3.5E4])
    title('Mouvement')

    subplot(313)
    plot(Range(Smooth_actimetry,'s'), Data(Smooth_actimetry),'k')
    hold on, plot(Range(Restrict(Smooth_actimetry,Periode_sommeil_piezo),'s'), Data(Restrict(Smooth_actimetry,Periode_sommeil_piezo)),'g');
    hold on, plot(Range(Restrict(Smooth_actimetry,Sleep_LongOnly_piezo),'s'), Data(Restrict(Smooth_actimetry,Sleep_LongOnly_piezo)),'r');
    hold on, plot(Range(Restrict(Smooth_actimetry,Wake_modified_piezo),'s'), Data(Restrict(Smooth_actimetry,Wake_modified_piezo)),'c');
    xlabel('Temps en heure')
    xlim([0 3.5E4])
    title('Piézo')
      
      
%     subplot(311)
%     xl = xlim
%     subplot(312)
%     xlim(xl)
%     subplot(313)
%     xlim(xl)
%     
    %% Compare with OB scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');

    % Do the proba
    durSS_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    durWS_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    adurS_OB(i,1) = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
    proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;


    durWW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    durSW_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB ;
    adurW_OB(i,1) = durWW_Piez_OB + durSW_Piez_OB ;
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
    proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ;
    
    

    durSS_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s'));
    durWS_Piez_OB = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    adurS_OB_longsleep_only(i,1) = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_OB_longsleep_only = (durSS_Piez_OB/durS_OB)*100;
    proba_W_S_OB_longsleep_only = (durWS_Piez_OB/durS_OB)*100;


    durWW_Piez_OB = sum(Stop(and(Wake_modified_piezo,Wake_modified_OB),'s') - Start(and(Wake_modified_piezo,Wake_modified_OB),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB;
    adurW_OB_longsleep_only(i,1) = durWW_Piez_OB + durSW_Piez_OB;
    proba_S_W_OB_longsleep_only = (durSW_Piez_OB/durW_OB)*100 ; 
    proba_W_W_OB_longsleep_only = (durWW_Piez_OB/durW_OB)*100 ; 

    %% Compare with Accelero scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');

    % Do the proba
    durSS_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    durWS_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    adurS_accelero(i,1) = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    durWW_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    durSW_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    adurW_accelero(i,1) = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 

    durSS_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    adurS_accelero_longsleep_only(i,1) = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero_longsleep_only = (durSS_Piez_accelero/durS_accelero)*100;
    proba_W_S_accelero_longsleep_only = (durWS_Piez_accelero/durS_accelero)*100;

    durWW_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Wake_modified_accelero),'s') - Start(and(Wake_modified_piezo,Wake_modified_accelero),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    adurW_accelero_longsleep_only(i,1) = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero_longsleep_only = (durWW_Piez_accelero/durW_accelero)*100 ; 
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
    
    
    
    % Compare Periode sommeil
    durSS_accelero_OB = sum(Stop(and(Sleep_LongOnly_accelero,Sleep_LongOnly_OB),'s') - Start(and(Sleep_LongOnly_accelero,Sleep_LongOnly_OB),'s'));
    durWS_accelero_OB = sum(Stop(and(Wake_modified_accelero,Sleep_LongOnly_OB),'s') - Start(and(Wake_modified_accelero,Sleep_LongOnly_OB),'s'));
    durS_OB = durSS_accelero_OB + durWS_accelero_OB;
    adurS_OB_accelero_longsleep_only(i,1) = durSS_accelero_OB + durWS_accelero_OB;
    proba_S_S_OB_accelero_longsleep_only = (durSS_accelero_OB/durS_OB)*100;
    proba_W_S_OB_accelero_longsleep_only = (durWS_accelero_OB/durS_OB)*100;


    durWW_Piez_OB = sum(Stop(and(Wake_modified_accelero,Wake_modified_OB),'s') - Start(and(Wake_modified_accelero,Wake_modified_OB),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep_LongOnly_accelero,Wake_modified_OB),'s') - Start(and(Sleep_LongOnly_accelero,Wake_modified_OB),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB;
    adurW_OB_accelero_longsleep_only(i,1) = durWW_Piez_OB + durSW_Piez_OB;
    proba_S_W_OB_accelero_longsleep_only = (durSW_Piez_OB/durW_OB)*100 ; 
    proba_W_W_OB_accelero_longsleep_only = (durWW_Piez_OB/durW_OB)*100 ; 
    

    % Create the table : 
    values_overlap_SleepScoring_AF_accelero_ob(i,5) = proba_S_S_OB_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero_ob(i,6) = proba_W_S_OB_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero_ob(i,7) = proba_W_W_OB_accelero_longsleep_only;
    values_overlap_SleepScoring_AF_accelero_ob(i,8) = proba_S_W_OB_accelero_longsleep_only;

   
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
    
    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,Sleep),'s') - Start(and(Sleep_accelero,Sleep),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,Sleep),'s') - Start(and(Wake_accelero,Sleep),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    adurS_OB_accelero(i,1) = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
    proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

    
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,Wake),'s') - Start(and(Wake_accelero,Wake),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,Wake),'s') - Start(and(Sleep_accelero,Wake),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    adurW_OB_accelero(i,1) = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
    proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 


    % Create the table : 
    values_overlap_SleepScoring_AF_accelero_ob(i,1) = proba_S_S_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,2) = proba_W_S_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,3) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF_accelero_ob(i,4) = proba_S_W_accelero;

%     
 end
for m = 1:8;
mean_values_overlap_SleepScoring_AF_accelero_ob(1,m) = mean(values_overlap_SleepScoring_AF_accelero_ob(:,m));
end
    


%% Plot the figure : 
labels= {'Sleep','Wake'};

fig = figure;
subplot(1,6,1)
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
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,1)),std(values_overlap_SleepScoring_AF_accelero_ob(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero_ob(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,4)),std(values_overlap_SleepScoring_AF_accelero_ob(:,4)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero_ob(:,4),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Movement Scoring');
ylim([0 100]);

subplot(162)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,5),mean_values_overlap_SleepScoring_AF_accelero_ob(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero_ob(1,8),mean_values_overlap_SleepScoring_AF_accelero_ob(1,7)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero_ob(:,5)),std(values_overlap_SleepScoring_AF_accelero_ob(:,5)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero_ob(:,5),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero_ob(:,8)),std(values_overlap_SleepScoring_AF_accelero_ob(:,8)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero_ob(:,8),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Long Sleep Only');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Movement Scoring');
ylim([0 100]);



subplot(163)
proba_sleep = [mean_values_overlap_SleepScoring_AF_OB(1,1),mean_values_overlap_SleepScoring_AF_OB(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_OB(1,4),mean_values_overlap_SleepScoring_AF_OB(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_OB(:,1)),std(values_overlap_SleepScoring_AF_OB(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_OB(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_OB(:,4)),std(values_overlap_SleepScoring_AF_OB(:,4)),'.');
plot(2,values_overlap_SleepScoring_AF_OB(:,4),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Original');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(164);
proba_sleep = [mean_values_overlap_SleepScoring_AF_OB(1,5),mean_values_overlap_SleepScoring_AF_OB(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_OB(1,8),mean_values_overlap_SleepScoring_AF_OB(1,7)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_OB(:,5)),std(values_overlap_SleepScoring_AF_OB(:,5)),'.');
plot(1,values_overlap_SleepScoring_AF_OB(:,5),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_OB(:,8)),std(values_overlap_SleepScoring_AF_OB(:,8)),'.');
plot(2,values_overlap_SleepScoring_AF_OB(:,8),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('Long Sleep Only');
legend('Similar','Different');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(165)
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero(1,1),mean_values_overlap_SleepScoring_AF_accelero(1,2)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero(1,4),mean_values_overlap_SleepScoring_AF_accelero(1,3)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero(:,1)),std(values_overlap_SleepScoring_AF_accelero(:,1)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero(:,1),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero(:,4)),std(values_overlap_SleepScoring_AF_accelero(:,4)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero(:,4),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Accelero');
title('Original');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);


subplot(166);
proba_sleep = [mean_values_overlap_SleepScoring_AF_accelero(1,5),mean_values_overlap_SleepScoring_AF_accelero(1,6)]; 
proba_wake = [mean_values_overlap_SleepScoring_AF_accelero(1,8),mean_values_overlap_SleepScoring_AF_accelero(1,7)]; 
proba_stacked = [proba_sleep;proba_wake];
h = bar(proba_stacked, 'stacked');
for i = 1:size(proba_stacked, 1)
    h(i).FaceColor = [1 0 0 ];
end
for i = size(proba_stacked, 2)
    h(i).FaceColor = [0 1 1 ];
end
hold on 
errorbar(1,mean(values_overlap_SleepScoring_AF_accelero(:,5)),std(values_overlap_SleepScoring_AF_accelero(:,5)),'.');
plot(1,values_overlap_SleepScoring_AF_accelero(:,5),'k.','MarkerSize',10);
errorbar(2,mean(values_overlap_SleepScoring_AF_accelero(:,8)),std(values_overlap_SleepScoring_AF_accelero(:,8)),'.');
plot(2,values_overlap_SleepScoring_AF_accelero(:,8),'k.','MarkerSize',10);
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Accelero');
title('Long Sleep Only');
legend('Sleep','Wake');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);







%% Calcul des durées de Sleep et Wake en Original ou LongSleepOnly


durS_OB = sum(adurS_OB(1:i,1));
durW_OB = sum(adurW_OB(1:i,1));
durS_OB_longsleep_only = sum(adurS_OB_longsleep_only(1:i,1));
durW_OB_longsleep_only = sum(adurW_OB_longsleep_only(1:i,1));

durS_accelero = sum(adurS_accelero(1:i,1));
durW_accelero = sum(adurW_accelero(1:i,1));
durS_accelero_longsleep_only = sum(adurS_accelero_longsleep_only(1:i,1));
durW_accelero_longsleep_only = sum(adurW_accelero_longsleep_only(1:i,1));

durS_OB_accelero = sum(adurS_OB_accelero(1:i,1));
durW_OB_accelero = sum(adurW_OB_accelero(1:i,1));
durS_OB_accelero_longsleep_only = sum(adurS_OB_accelero_longsleep_only(1:i,1));
durW_OB_accelero_longsleep_only = sum(adurW_OB_accelero_longsleep_only(1:i,1));



