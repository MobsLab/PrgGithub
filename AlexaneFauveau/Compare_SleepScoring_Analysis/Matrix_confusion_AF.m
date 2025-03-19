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
    Periode_sommeil_OB = mergeCloseIntervals(Sleep_LongOnly_OB, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB, 90*1e4);
    Wake_modified_OB = Periode_sommeil_OB - Sleep_LongOnly_OB;
    

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Sleep_LongOnly_accelero = dropShortIntervals(Sleep,30*1e4);
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep_LongOnly_accelero, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero, 90*1e4);
    Wake_modified_accelero = Periode_sommeil_accelero - Sleep_LongOnly_accelero;

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    Sleep_LongOnly_piezo = dropShortIntervals(SleepEpoch_Piezo,30*1e4);
    Periode_sommeil_piezo = mergeCloseIntervals(Sleep_LongOnly_piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo, 90*1e4);
    Wake_modified_piezo = Periode_sommeil_piezo - Sleep_LongOnly_piezo;

%     figure 
%     subplot(311)
%     plot(Range(SmoothGamma), Data(SmoothGamma))
%     hold on, plot(Range(Restrict(SmoothGamma,Sleep_LongOnly_OB)), Data(Restrict(SmoothGamma,Sleep_LongOnly_OB)),'g');
%     hold on, plot(Range(Restrict(SmoothGamma,Wake_modified_OB)), Data(Restrict(SmoothGamma,Wake_modified_OB)),'k');
%     
%     subplot(312)
%     plot(Range(tsdMovement), Data(tsdMovement))
%     hold on, plot(Range(Restrict(tsdMovement,Sleep_LongOnly_accelero)), Data(Restrict(tsdMovement,Sleep_LongOnly_accelero)),'g');
%     hold on, plot(Range(Restrict(tsdMovement,Wake_modified_accelero)), Data(Restrict(tsdMovement,Wake_modified_accelero)),'k');
%     
%     subplot(313)
%     plot(Range(Piezo_Mouse_tsd), Data(Piezo_Mouse_tsd))
%     hold on, plot(Range(Restrict(Piezo_Mouse_tsd,Sleep_LongOnly_piezo)), Data(Restrict(Piezo_Mouse_tsd,Sleep_LongOnly_piezo)),'g');
%     hold on, plot(Range(Restrict(Piezo_Mouse_tsd,Wake_modified_piezo)), Data(Restrict(Piezo_Mouse_tsd,Wake_modified_piezo)),'k');
%     
%     subplot(311)
%     xl = xlim
%     subplot(312)
%     xlim(xl)
%     subplot(313)
%     xlim(xl)
    
    %% Compare with OB scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');

    % Do the proba
    durSS_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    durWS_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_OB(i,1) = (durSS_Piez_OB/durS_OB);
    proba_W_S_OB(i,1) = (durWS_Piez_OB/durS_OB);

    durWW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    durSW_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB ;
    proba_W_W_OB(i,1) = (durWW_Piez_OB/durW_OB) ; 
    proba_S_W_OB(i,1) = (durSW_Piez_OB/durW_OB) ;

    durSS_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_OB),'s'));
    durWS_Piez_OB = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_OB),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_OB_longsleep_only(i,1) = (durSS_Piez_OB/durS_OB);
    proba_W_S_OB_longsleep_only(i,1) = (durWS_Piez_OB/durS_OB);
    
    durWW_Piez_OB = sum(Stop(and(Wake_modified_piezo,Wake_modified_OB),'s') - Start(and(Wake_modified_piezo,Wake_modified_OB),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_OB),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB;
    proba_S_W_OB_longsleep_only(i,1) = (durSW_Piez_OB/durW_OB) ; 
    proba_W_W_OB_longsleep_only(i,1) = (durWW_Piez_OB/durW_OB) ;
    
    % En fonction du Piezo
    durSS_Piez_OB = sum(Stop(and(Sleep,SleepEpoch_Piezo),'s') - Start(and(Sleep,SleepEpoch_Piezo),'s'));
    durWS_Piez_OB = sum(Stop(and(Wake,SleepEpoch_Piezo),'s') - Start(and(Wake,SleepEpoch_Piezo),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_Piezo_OB(i,1) = (durSS_Piez_OB/durS_OB);
    proba_W_S_Piezo_OB(i,1) = (durWS_Piez_OB/durS_OB);
    
    durWW_Piez_OB = sum(Stop(and(Wake,WakeEpoch_Piezo),'s') - Start(and(Wake,WakeEpoch_Piezo),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep,WakeEpoch_Piezo),'s') - Start(and(Sleep,WakeEpoch_Piezo),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB ;
    proba_W_W_Piezo_OB(i,1) = (durWW_Piez_OB/durW_OB) ; 
    proba_S_W_Piezo_OB(i,1) = (durSW_Piez_OB/durW_OB) ;
    
    
    durSS_Piez_OB = sum(Stop(and(Sleep_LongOnly_OB,Sleep_LongOnly_piezo),'s') - Start(and(Sleep_LongOnly_OB,Sleep_LongOnly_piezo),'s'));
    durWS_Piez_OB = sum(Stop(and(Wake_modified_OB,Sleep_LongOnly_piezo),'s') - Start(and(Wake_modified_OB,Sleep_LongOnly_piezo),'s'));
    durS_OB = durSS_Piez_OB + durWS_Piez_OB;
    proba_S_S_Piezo_OB_longsleep_only(i,1) = (durSS_Piez_OB/durS_OB);
    proba_W_S_Piezo_OB_longsleep_only(i,1) = (durWS_Piez_OB/durS_OB);
    
    durWW_Piez_OB = sum(Stop(and(Wake_modified_OB,Wake_modified_piezo),'s') - Start(and(Wake_modified_OB,Wake_modified_piezo),'s'));
    durSW_Piez_OB = sum(Stop(and(Sleep_LongOnly_OB,Wake_modified_piezo),'s') - Start(and(Sleep_LongOnly_OB,Wake_modified_piezo),'s'));
    durW_OB = durWW_Piez_OB + durSW_Piez_OB;
    proba_S_W_Piezo_OB_longsleep_only(i,1) = (durSW_Piez_OB/durW_OB) ; 
    proba_W_W_Piezo_OB_longsleep_only(i,1) = (durWW_Piez_OB/durW_OB) ;

    %% Compare with Accelero scoring 
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');

    % Do the proba
    durSS_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
    durWS_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero(i,1) = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_accelero(i,1) = (durWS_Piez_accelero/durS_accelero);

    
    durWW_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
    durSW_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero(i,1) = (durWW_Piez_accelero/durW_accelero) ; 
    proba_S_W_accelero(i,1) = (durSW_Piez_accelero/durW_accelero) ; 

    durSS_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s') - Start(and(Wake_modified_piezo,Sleep_LongOnly_accelero),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero_longsleep_only(i,1) = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_accelero_longsleep_only(i,1) = (durWS_Piez_accelero/durS_accelero);

    durWW_Piez_accelero = sum(Stop(and(Wake_modified_piezo,Wake_modified_accelero),'s') - Start(and(Wake_modified_piezo,Wake_modified_accelero),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s') - Start(and(Sleep_LongOnly_piezo,Wake_modified_accelero),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero_longsleep_only(i,1) = (durWW_Piez_accelero/durW_accelero) ; 
    proba_S_W_accelero_longsleep_only(i,1) = (durSW_Piez_accelero/durW_accelero) ; 
    
    % En fonction du piezo
    durSS_Piez_accelero = sum(Stop(and(Sleep,SleepEpoch_Piezo),'s') - Start(and(Sleep,SleepEpoch_Piezo),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake,SleepEpoch_Piezo),'s') - Start(and(Wake,SleepEpoch_Piezo),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_Piezo_accelero(i,1) = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_Piezo_accelero(i,1) = (durWS_Piez_accelero/durS_accelero);
    
    durWW_Piez_accelero = sum(Stop(and(Wake,WakeEpoch_Piezo),'s') - Start(and(Wake,WakeEpoch_Piezo),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep,WakeEpoch_Piezo),'s') - Start(and(Sleep,WakeEpoch_Piezo),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero ;
    proba_W_W_Piezo_accelero(i,1) = (durWW_Piez_accelero/durW_accelero) ; 
    proba_S_W_Piezo_accelero(i,1) = (durSW_Piez_accelero/durW_accelero) ;
    
    
    durSS_Piez_accelero = sum(Stop(and(Sleep_LongOnly_accelero,Sleep_LongOnly_piezo),'s') - Start(and(Sleep_LongOnly_accelero,Sleep_LongOnly_piezo),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_modified_accelero,Sleep_LongOnly_piezo),'s') - Start(and(Wake_modified_accelero,Sleep_LongOnly_piezo),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_Piezo_accelero_longsleep_only(i,1) = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_Piezo_accelero_longsleep_only(i,1) = (durWS_Piez_accelero/durS_accelero);
    
    durWW_Piez_accelero = sum(Stop(and(Wake_modified_accelero,Wake_modified_piezo),'s') - Start(and(Wake_modified_accelero,Wake_modified_piezo),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_LongOnly_accelero,Wake_modified_piezo),'s') - Start(and(Sleep_LongOnly_accelero,Wake_modified_piezo),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_S_W_Piezo_accelero_longsleep_only(i,1) = (durSW_Piez_accelero/durW_accelero) ; 
    proba_W_W_Piezo_accelero_longsleep_only(i,1) = (durWW_Piez_accelero/durW_accelero) ;


    %% Compare OB and Accelero
       
    % load('SleepScoring_OBGamma.mat');
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    Sleep_accelero = Sleep;
    Wake_accelero = Wake;
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');

    durSS_Piez_accelero = sum(Stop(and(Sleep_accelero,Sleep),'s') - Start(and(Sleep_accelero,Sleep),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake_accelero,Sleep),'s') - Start(and(Wake_accelero,Sleep),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_ob_accelero = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_ob_accelero = (durWS_Piez_accelero/durS_accelero);

    
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,Wake),'s') - Start(and(Wake_accelero,Wake),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep_accelero,Wake),'s') - Start(and(Sleep_accelero,Wake),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_ob_accelero = (durWW_Piez_accelero/durW_accelero) ; 
    proba_S_W_ob_accelero = (durSW_Piez_accelero/durW_accelero) ; 
    
    
    durSS_Piez_accelero = sum(Stop(and(Sleep,Sleep_accelero),'s') - Start(and(Sleep,Sleep_accelero),'s'));
    durWS_Piez_accelero = sum(Stop(and(Wake,Sleep_accelero),'s') - Start(and(Wake,Sleep_accelero),'s'));
    durS_accelero = durSS_Piez_accelero + durWS_Piez_accelero;
    proba_S_S_accelero_ob = (durSS_Piez_accelero/durS_accelero);
    proba_W_S_accelero_ob = (durWS_Piez_accelero/durS_accelero);

    
    durWW_Piez_accelero = sum(Stop(and(Wake,Wake_accelero),'s') - Start(and(Wake,Wake_accelero),'s'));
    durSW_Piez_accelero = sum(Stop(and(Sleep,Wake_accelero),'s') - Start(and(Sleep,Wake_accelero),'s'));
    durW_accelero = durWW_Piez_accelero + durSW_Piez_accelero;
    proba_W_W_accelero_ob = (durWW_Piez_accelero/durW_accelero) ; 
    proba_S_W_accelero_ob = (durSW_Piez_accelero/durW_accelero) ;
    
end

m = i + 1;
    mean_proba_S_S_OB = mean(proba_S_S_OB(:,1));
    mean_proba_W_S_OB = mean(proba_W_S_OB(:,1));

    mean_proba_W_W_OB = mean(proba_W_W_OB(:,1));
    mean_proba_S_W_OB = mean(proba_S_W_OB(:,1));

    mean_proba_S_S_OB_longsleep_only = mean(proba_S_S_OB_longsleep_only(:,1));
    mean_proba_W_S_OB_longsleep_only = mean(proba_W_S_OB_longsleep_only(:,1));
    
    mean_proba_S_W_OB_longsleep_only = mean(proba_S_W_OB_longsleep_only(:,1));
    mean_proba_W_W_OB_longsleep_only = mean(proba_W_W_OB_longsleep_only(:,1));

    mean_proba_S_S_Piezo_OB = mean(proba_S_S_Piezo_OB(:,1));
    mean_proba_W_S_Piezo_OB = mean(proba_W_S_Piezo_OB(:,1));

    mean_proba_W_W_Piezo_OB = mean(proba_W_W_Piezo_OB(:,1));
    mean_proba_S_W_Piezo_OB = mean(proba_S_W_Piezo_OB(:,1));

    mean_proba_S_S_Piezo_OB_longsleep_only = mean(proba_S_S_Piezo_OB_longsleep_only(:,1));
    mean_proba_W_S_Piezo_OB_longsleep_only = mean(proba_W_S_Piezo_OB_longsleep_only(:,1));
    
    mean_proba_S_W_Piezo_OB_longsleep_only = mean(proba_S_W_Piezo_OB_longsleep_only(:,1));
    mean_proba_S_W_Piezo_OB_longsleep_only = mean(proba_S_W_Piezo_OB_longsleep_only(:,1));

    mean_proba_S_S_accelero = mean(proba_S_S_accelero(:,1));
    mean_proba_W_S_accelero = mean(proba_W_S_accelero(:,1));

    mean_proba_W_W_accelero = mean(proba_W_W_accelero(:,1));
    mean_proba_S_W_accelero = mean(proba_S_W_accelero(:,1));
  
    mean_proba_S_S_accelero_longsleep_only = mean(proba_S_S_accelero_longsleep_only(:,1));
    mean_proba_W_S_accelero_longsleep_only = mean(proba_W_S_accelero_longsleep_only(:,1));

    mean_proba_W_W_accelero_longsleep_only = mean(proba_W_W_accelero_longsleep_only(:,1));
    mean_proba_S_W_accelero_longsleep_only = mean(proba_S_W_accelero_longsleep_only(:,1));    

    mean_proba_S_S_Piezo_accelero = mean(proba_S_S_Piezo_accelero(:,1));
    mean_proba_W_S_Piezo_accelero = mean(proba_W_S_Piezo_accelero(:,1));

    mean_proba_W_W_Piezo_accelero = mean(proba_W_W_Piezo_accelero(:,1));
    mean_proba_S_W_Piezo_accelero = mean(proba_S_W_Piezo_accelero(:,1));

    mean_proba_S_S_Piezo_accelero_longsleep_only = mean(proba_S_S_Piezo_accelero_longsleep_only(:,1));
    mean_proba_S_S_Piezo_accelero_longsleep_only = mean(proba_S_S_Piezo_accelero_longsleep_only(:,1));
    
    mean_proba_S_W_Piezo_accelero_longsleep_only = mean(proba_S_W_Piezo_accelero_longsleep_only(:,1));
    mean_proba_W_W_Piezo_accelero_longsleep_only = mean(proba_W_W_Piezo_accelero_longsleep_only(:,1));

    mean_proba_S_S_ob_accelero = mean(proba_S_S_ob_accelero(:,1));
    mean_proba_W_S_ob_accelero = mean(proba_W_S_ob_accelero(:,1));

    mean_proba_W_W_ob_accelero = mean(proba_W_W_ob_accelero(:,1));
    mean_proba_S_W_ob_accelero = mean(proba_S_W_ob_accelero(:,1));
    
    mean_proba_S_S_accelero_ob = mean(proba_S_S_accelero_ob(:,1));
    mean_proba_W_S_accelero_ob = mean(proba_W_S_accelero_ob(:,1));

    mean_proba_W_W_accelero_ob = mean(proba_W_W_accelero_ob(:,1));
    mean_proba_S_W_accelero_ob = mean(proba_S_W_accelero_ob(:,1));


    
%% Créer la matrix de confusion : 
% Matrix Wake
matrix_wake = zeros([3,3])
matrix_wake(1,1) = 1
matrix_wake(2,1) = mean_proba_W_W_Piezo_OB
matrix_wake(3,1) = mean_proba_W_W_Piezo_accelero
matrix_wake(1,2) = mean_proba_W_W_OB
matrix_wake(2,2) = 1
matrix_wake(3,2) = mean_proba_W_W_ob_accelero
matrix_wake(1,3) = mean_proba_W_W_accelero
matrix_wake(2,3) = mean_proba_W_W_accelero_ob
matrix_wake(3,3) = 1

figure;
subplot(231)
imagesc(matrix_wake);
colormap parula
caxis([0 1])
colorbar
[x, y] = meshgrid(1:3);
for i = 1:numel(matrix_wake)
    text(x(i),y(i),sprintf('%.2f',matrix_wake(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
end
xticks(1:3);
ax = gca;
ax.XAxisLocation = 'top';
xticklabels({'Piezo','OB Gamma', 'Movement'});
xlabel('Wake predicted by','Position', [1.5 0.25]);
yticks(1:3);
yticklabels({'Piezo','OB Gamma', 'Movement'});
ylabel('Agreed by');


% Matrix Sleep
matrix_sleep = zeros([3,3])
matrix_sleep(1,1) = 1
matrix_sleep(2,1) = mean_proba_S_S_Piezo_OB
matrix_sleep(3,1) = mean_proba_S_S_Piezo_accelero
matrix_sleep(1,2) = mean_proba_S_S_OB
matrix_sleep(2,2) = 1
matrix_sleep(3,2) = mean_proba_S_S_ob_accelero
matrix_sleep(1,3) = mean_proba_S_S_accelero
matrix_sleep(2,3) = mean_proba_S_S_accelero_ob
matrix_sleep(3,3) = 1

subplot(233)
imagesc(matrix_sleep);
colormap
[x, y] = meshgrid(1:3);
colormap parula
caxis([0 1])
colorbar
for i = 1:numel(matrix_sleep)
    text(x(i),y(i),sprintf('%.2f',matrix_sleep(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
end
xticks(1:3);
ax = gca;
ax.XAxisLocation = 'top';
xticklabels({'Piezo','OB Gamma', 'Movement'});
xlabel('Sleep predicted by','Position', [1.5 0.25]);
yticks(1:3);
yticklabels({'Piezo','OB Gamma', 'Movement'});
ylabel('Agreed by');


% Matrix OB/Accelero
matrix_ob_accelero = zeros([2,2])
matrix_ob_accelero(1,1) = mean_proba_W_W_ob_accelero
matrix_ob_accelero(2,1) = mean_proba_S_W_ob_accelero
matrix_ob_accelero(1,2) = mean_proba_W_S_ob_accelero
matrix_ob_accelero(2,2) = mean_proba_S_S_ob_accelero


subplot(234)
imagesc(matrix_ob_accelero);
colormap
[x, y] = meshgrid(1:2);
colormap parula
caxis([0 1])
colorbar
for i = 1:numel(matrix_ob_accelero)
    text(x(i),y(i),sprintf('%.2f',matrix_ob_accelero(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
end
xticks(1:3);
xticklabels({'Wake','Sleep'});
ax = gca;
ax.XAxisLocation = 'top';
xlabel('Predicted by OB','Position', [1.5 0.25]);
yticks(1:3);
yticklabels({'Wake','Sleep'});
ylabel('Movement agreement');


% Matrix Piezo/OB
matrix_Piezo_OB = zeros([2,2])
matrix_Piezo_OB(1,1) = mean_proba_W_W_Piezo_OB
matrix_Piezo_OB(2,1) = mean_proba_S_W_Piezo_OB
matrix_Piezo_OB(1,2) = mean_proba_W_S_Piezo_OB
matrix_Piezo_OB(2,2) = mean_proba_S_S_Piezo_OB

subplot(235)
imagesc(matrix_Piezo_OB);
colormap
[x, y] = meshgrid(1:2);
colormap parula
caxis([0 1])
colorbar
for i = 1:numel(matrix_Piezo_OB)
    text(x(i),y(i),sprintf('%.2f',matrix_Piezo_OB(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
end
xticks(1:3);
xticklabels({'Wake','Sleep'});
ax = gca;
ax.XAxisLocation = 'top';
xlabel('Predicted by Piezo','Position', [1.5 0.25]);
yticks(1:3);
yticklabels({'Wake','Sleep'});
ylabel('OB agreement');



% Matrix Piezo/Accelero
matrix_Piezo_accelero = zeros([2,2])
matrix_Piezo_accelero(1,1) = mean_proba_W_W_Piezo_accelero
matrix_Piezo_accelero(2,1) = mean_proba_S_W_Piezo_accelero
matrix_Piezo_accelero(1,2) = mean_proba_W_S_Piezo_accelero
matrix_Piezo_accelero(2,2) = mean_proba_S_S_Piezo_accelero

subplot(236)
imagesc(matrix_Piezo_accelero);
colormap
[x, y] = meshgrid(1:2);
colormap parula
caxis([0 1])
colorbar
for i = 1:numel(matrix_Piezo_accelero)
    text(x(i),y(i),sprintf('%.2f',matrix_Piezo_accelero(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
end
xticks(1:3);
xticklabels({'Wake','Sleep'});
ax = gca;
ax.XAxisLocation = 'top';
xlabel('Predicted by Piezo','Position', [1.5 0.25]);
yticks(1:3);
yticklabels({'Wake','Sleep'});
ylabel('Movement agreement');



% 
% 
% % Matrix Piezo/Accelero
% matrix_Piezo_accelero(1,1) = 1
% matrix_Piezo_accelero(2,1) = 0
% matrix_Piezo_accelero(3,1) = mean_proba_W_W_Piezo_accelero
% matrix_Piezo_accelero(4,1) = mean_proba_S_W_Piezo_accelero
% matrix_Piezo_accelero(1,2) = 0
% matrix_Piezo_accelero(2,2) = 1
% matrix_Piezo_accelero(3,2) = mean_proba_W_S_Piezo_accelero
% matrix_Piezo_accelero(4,2) = mean_proba_S_S_Piezo_accelero
% matrix_Piezo_accelero(1,3) = mean_proba_W_W_accelero
% matrix_Piezo_accelero(2,3) = mean_proba_S_W_accelero
% matrix_Piezo_accelero(3,3) = 1
% matrix_Piezo_accelero(4,3) = 0
% matrix_Piezo_accelero(1,4) = mean_proba_W_S_accelero
% matrix_Piezo_accelero(2,4) = mean_proba_S_S_accelero
% matrix_Piezo_accelero(3,4) = 0
% matrix_Piezo_accelero(4,4) = 1
% 
% 
% figure
% imagesc(matrix_Piezo_accelero);
% colormap
% [x, y] = meshgrid(1:4);
% colormap parula
% caxis([0 1])
% colorbar
% for i = 1:numel(matrix_Piezo_accelero)
%     text(x(i),y(i),sprintf('%.2f',matrix_Piezo_accelero(i)), 'HorizontalAlignment','center','VerticalAlignment','middle');
% end
% xticks(1:4);
% xticklabels({'Wake','Sleep','Wake','Sleep'});
% ax = gca;
% ax.XAxisLocation = 'top';
% xlabel('Predicted by Piezo                                                                                            Predicted by Accelero','Position', [2.5 0.25]);
% yticks(1:4);
% yticklabels({'Wake','Sleep','Wake','Sleep'});
% ylabel('Movement agreement');
% 
% 
% 
