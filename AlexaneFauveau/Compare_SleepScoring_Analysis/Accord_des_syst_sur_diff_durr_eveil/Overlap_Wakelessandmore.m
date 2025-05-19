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
    Wake_accelerosup300 = dropShortIntervals(Wake,300*1e4);
    Wake_accelerosup240 = dropShortIntervals(Wake,240*1e4);
    Wake_accelerosup180 = dropShortIntervals(Wake,180*1e4);
    Wake_accelerosup120 = dropShortIntervals(Wake,120*1e4);
    Wake_accelerosup60 = dropShortIntervals(Wake,60*1e4);

    Wake_accelero50 = dropShortIntervals(Wake_accelero,50*1e4);
        Wake_accelero50 = Wake_accelero - Wake_accelero50;
    Wake_accelero40 = dropShortIntervals(Wake_accelero,40*1e4);
        Wake_accelero40 = Wake_accelero -Wake_accelero40;
    Wake_accelero30 = dropShortIntervals(Wake_accelero,30*1e4);
        Wake_accelero30 = Wake_accelero -Wake_accelero30;    
    Wake_accelero20 = dropShortIntervals(Wake_accelero,20*1e4);
        Wake_accelero20 = Wake_accelero -Wake_accelero20;
    Wake_accelero10 = dropShortIntervals(Wake_accelero,10*1e4);
        Wake_accelero10 = Wake_accelero -Wake_accelero10;
    Wake_accelero05 = dropShortIntervals(Wake_accelero,5*1e4);
        Wake_accelero05 = Wake_accelero -Wake_accelero05;

    clear Sleep
    clear Wake
    
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
%     load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_OB = and(Sleep, Periode_sommeil_OB);
    Wake_OB = and(Wake, Periode_sommeil_OB);
    Wake_OBsup60 = dropShortIntervals(Wake,60*1e4);
    Wake_OBsup120 = dropShortIntervals(Wake,120*1e4);
    Wake_OBsup180 = dropShortIntervals(Wake,180*1e4);
    Wake_OBsup240 = dropShortIntervals(Wake,240*1e4);
    Wake_OBsup300 = dropShortIntervals(Wake,300*1e4);
    Wake_OB50 = dropShortIntervals(Wake_OB,50*1e4);
        Wake_OB50 = Wake_OB - Wake_OB50;
    Wake_OB40 = dropShortIntervals(Wake_OB,40*1e4);
        Wake_OB40 = Wake_OB -Wake_OB40;
    Wake_OB30 = dropShortIntervals(Wake_OB,30*1e4);
        Wake_OB30 = Wake_OB -Wake_OB30;    
    Wake_OB20 = dropShortIntervals(Wake_OB,20*1e4);
        Wake_OB20 = Wake_OB -Wake_OB20;
    Wake_OB10 = dropShortIntervals(Wake_OB,10*1e4);
        Wake_OB10 = Wake_OB -Wake_OB10;
    Wake_OB05 = dropShortIntervals(Wake_OB,5*1e4);
        Wake_OB05 = Wake_OB -Wake_OB05;

    
    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
%     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
%     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    SleepEpoch_Piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    Wake_piezosup60 = dropShortIntervals(WakeEpoch_Piezo,60*1e4);
    Wake_piezosup120 = dropShortIntervals(WakeEpoch_Piezo,120*1e4);
    Wake_piezosup180 = dropShortIntervals(WakeEpoch_Piezo,180*1e4);
    Wake_piezosup240 = dropShortIntervals(WakeEpoch_Piezo,240*1e4);
    Wake_piezosup300 = dropShortIntervals(WakeEpoch_Piezo,300*1e4);
    WakeEpoch_Piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);
    Wake_piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);
    Wake_piezo50 = dropShortIntervals(WakeEpoch_Piezo,50*1e4);
        Wake_piezo50 = Wake_piezo - Wake_piezo50;
    Wake_piezo40 = dropShortIntervals(Wake_piezo,40*1e4);
        Wake_piezo40 = Wake_piezo -Wake_piezo40;
    Wake_piezo30 = dropShortIntervals(Wake_piezo,30*1e4);
        Wake_piezo30 = Wake_piezo -Wake_piezo30;    
    Wake_piezo20 = dropShortIntervals(Wake_piezo,20*1e4);
        Wake_piezo20 = Wake_piezo -Wake_piezo20;
    Wake_piezo10 = dropShortIntervals(Wake_piezo,10*1e4);
        Wake_piezo10 = Wake_piezo -Wake_piezo10;
    Wake_piezo05 = dropShortIntervals(Wake_piezo,5*1e4);
        Wake_piezo05 = Wake_piezo -Wake_piezo05;

    
    
      
   
    %% Compare with OB scoring 

    % Do the proba
    durW_OB = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB,WakeEpoch_Piezo),'s') - Start(and(Wake_OB,WakeEpoch_Piezo),'s'));
    proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 

    durW_OB = sum(Stop(Wake_piezo50,'s') - Start(Wake_piezo50,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB50,Wake_piezo50),'s') - Start(and(Wake_OB50,Wake_piezo50),'s'));
    proba_W_W_OB50 = (durWW_Piez_OB/durW_OB)*100 ; 
    
    durW_OB = sum(Stop(Wake_piezo40,'s') - Start(Wake_piezo40,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB40,Wake_piezo40),'s') - Start(and(Wake_OB40,Wake_piezo40),'s'));
    proba_W_W_OB40 = (durWW_Piez_OB/durW_OB)*100 ; 
    
    durW_OB = sum(Stop(Wake_piezo30,'s') - Start(Wake_piezo30,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB30,Wake_piezo30),'s') - Start(and(Wake_OB30,Wake_piezo30),'s'));
    proba_W_W_OB30 = (durWW_Piez_OB/durW_OB)*100 ;     

    durW_OB = sum(Stop(Wake_piezo20,'s') - Start(Wake_piezo20,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB20,Wake_piezo20),'s') - Start(and(Wake_OB20,Wake_piezo20),'s'));
    proba_W_W_OB20 = (durWW_Piez_OB/durW_OB)*100 ;     
    
    durW_OB = sum(Stop(Wake_piezo10,'s') - Start(Wake_piezo10,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB10,Wake_piezo10),'s') - Start(and(Wake_OB10,Wake_piezo10),'s'));
    proba_W_W_OB10 = (durWW_Piez_OB/durW_OB)*100 ;     

    durW_OB = sum(Stop(Wake_piezo05,'s') - Start(Wake_piezo05,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB05,Wake_piezo05),'s') - Start(and(Wake_OB05,Wake_piezo05),'s'));
    proba_W_W_OB05 = (durWW_Piez_OB/durW_OB)*100 ;   

    durW_OB = sum(Stop(Wake_piezosup60,'s') - Start(Wake_piezosup60,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup60,Wake_piezosup60),'s') - Start(and(Wake_OBsup60,Wake_piezosup60),'s'));
    proba_W_W_OBsup60 = (durWW_Piez_OB/durW_OB)*100 ;   
    
    durW_OB = sum(Stop(Wake_piezosup120,'s') - Start(Wake_piezosup120,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup120,Wake_piezosup120),'s') - Start(and(Wake_OBsup120,Wake_piezosup120),'s'));
    proba_W_W_OBsup120 = (durWW_Piez_OB/durW_OB)*100 ;  
    
    durW_OB = sum(Stop(Wake_piezosup180,'s') - Start(Wake_piezosup180,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup180,Wake_piezosup180),'s') - Start(and(Wake_OBsup180,Wake_piezosup180),'s'));
    proba_W_W_OBsup180 = (durWW_Piez_OB/durW_OB)*100 ;  
    
    durW_OB = sum(Stop(Wake_piezosup240,'s') - Start(Wake_piezosup240,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup240,Wake_piezosup240),'s') - Start(and(Wake_OBsup240,Wake_piezosup240),'s'));
    proba_W_W_OBsup240 = (durWW_Piez_OB/durW_OB)*100 ;      
    
    durW_OB = sum(Stop(Wake_piezosup300,'s') - Start(Wake_piezosup300,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup300,Wake_piezosup300),'s') - Start(and(Wake_OBsup300,Wake_piezosup300),'s'));
    proba_W_W_OBsup300 = (durWW_Piez_OB/durW_OB)*100 ;      
    %% Compare with Accelero scoring 
    % Do the proba
    durW_accelero = sum(Stop(WakeEpoch_Piezo,'s') - Start(WakeEpoch_Piezo,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero,WakeEpoch_Piezo),'s') - Start(and(Wake_accelero,WakeEpoch_Piezo),'s'));
    proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 

    durW_accelero = sum(Stop(Wake_piezo50,'s') - Start(Wake_piezo50,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero50,Wake_piezo50),'s') - Start(and(Wake_accelero50,Wake_piezo50),'s'));
    proba_W_W_accelero50 = (durWW_Piez_accelero/durW_accelero)*100 ; 
    
    durW_accelero = sum(Stop(Wake_piezo40,'s') - Start(Wake_piezo40,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero40,Wake_piezo40),'s') - Start(and(Wake_accelero40,Wake_piezo40),'s'));
    proba_W_W_accelero40 = (durWW_Piez_accelero/durW_accelero)*100 ; 
    
    durW_accelero = sum(Stop(Wake_piezo30,'s') - Start(Wake_piezo30,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero30,Wake_piezo30),'s') - Start(and(Wake_accelero30,Wake_piezo30),'s'));
    proba_W_W_accelero30 = (durWW_Piez_accelero/durW_accelero)*100 ;     

    durW_accelero = sum(Stop(Wake_piezo20,'s') - Start(Wake_piezo20,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero20,Wake_piezo20),'s') - Start(and(Wake_accelero20,Wake_piezo20),'s'));
    proba_W_W_accelero20 = (durWW_Piez_accelero/durW_accelero)*100 ;     
    
    durW_accelero = sum(Stop(Wake_piezo10,'s') - Start(Wake_piezo10,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero10,Wake_piezo10),'s') - Start(and(Wake_accelero10,Wake_piezo10),'s'));
    proba_W_W_accelero10 = (durWW_Piez_accelero/durW_accelero)*100 ;     

    durW_accelero = sum(Stop(Wake_piezo05,'s') - Start(Wake_piezo05,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelero05,Wake_piezo05),'s') - Start(and(Wake_accelero05,Wake_piezo05),'s'));
    proba_W_W_accelero05 = (durWW_Piez_accelero/durW_accelero)*100 ;   
    
    durW_accelero = sum(Stop(Wake_piezosup60,'s') - Start(Wake_piezosup60,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelerosup60,Wake_piezosup60),'s') - Start(and(Wake_accelerosup60,Wake_piezosup60),'s'));
    proba_W_W_accelerosup60 = (durWW_Piez_accelero/durW_accelero)*100 ;  

    durW_accelero = sum(Stop(Wake_piezosup120,'s') - Start(Wake_piezosup120,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelerosup120,Wake_piezosup120),'s') - Start(and(Wake_accelerosup120,Wake_piezosup120),'s'));
    proba_W_W_accelerosup120 = (durWW_Piez_accelero/durW_accelero)*100 ;      
    
    durW_accelero = sum(Stop(Wake_piezosup180,'s') - Start(Wake_piezosup180,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelerosup180,Wake_piezosup180),'s') - Start(and(Wake_accelerosup180,Wake_piezosup180),'s'));
    proba_W_W_accelerosup180 = (durWW_Piez_accelero/durW_accelero)*100 ;      
    
    durW_accelero = sum(Stop(Wake_piezosup240,'s') - Start(Wake_piezosup240,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelerosup240,Wake_piezosup240),'s') - Start(and(Wake_accelerosup240,Wake_piezosup240),'s'));
    proba_W_W_accelerosup240 = (durWW_Piez_accelero/durW_accelero)*100 ;      
    
    durW_accelero = sum(Stop(Wake_piezosup300,'s') - Start(Wake_piezosup300,'s'));
    durWW_Piez_accelero = sum(Stop(and(Wake_accelerosup300,Wake_piezosup300),'s') - Start(and(Wake_accelerosup300,Wake_piezosup300),'s'));
    proba_W_W_accelerosup300 = (durWW_Piez_accelero/durW_accelero)*100 ;      
        %% Compare with OB and Accelero scoring 
    % Do the proba
    durW_OB = sum(Stop(Wake_accelero,'s') - Start(Wake_accelero,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB,Wake_accelero),'s') - Start(and(Wake_OB,Wake_accelero),'s'));
    proba_W_W_OBacc = (durWW_Piez_OB/durW_OB)*100 ; 

    durW_OB = sum(Stop(Wake_accelero50,'s') - Start(Wake_accelero50,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB50,Wake_accelero50),'s') - Start(and(Wake_OB50,Wake_accelero50),'s'));
    proba_W_W_OBacc50 = (durWW_Piez_OB/durW_OB)*100 ; 
    
    durW_OB = sum(Stop(Wake_accelero40,'s') - Start(Wake_accelero40,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB40,Wake_accelero40),'s') - Start(and(Wake_OB40,Wake_accelero40),'s'));
    proba_W_W_OBacc40 = (durWW_Piez_OB/durW_OB)*100 ; 
    
    durW_OB = sum(Stop(Wake_accelero30,'s') - Start(Wake_accelero30,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB30,Wake_accelero30),'s') - Start(and(Wake_OB30,Wake_accelero30),'s'));
    proba_W_W_OBacc30 = (durWW_Piez_OB/durW_OB)*100 ;     

    durW_OB = sum(Stop(Wake_accelero20,'s') - Start(Wake_accelero20,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB20,Wake_accelero20),'s') - Start(and(Wake_OB20,Wake_accelero20),'s'));
    proba_W_W_OBacc20 = (durWW_Piez_OB/durW_OB)*100 ;     
    
    durW_OB = sum(Stop(Wake_accelero10,'s') - Start(Wake_accelero10,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB10,Wake_accelero10),'s') - Start(and(Wake_OB10,Wake_accelero10),'s'));
    proba_W_W_OBacc10 = (durWW_Piez_OB/durW_OB)*100 ;     

    durW_OB = sum(Stop(Wake_accelero05,'s') - Start(Wake_accelero05,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OB05,Wake_accelero05),'s') - Start(and(Wake_OB05,Wake_accelero05),'s'));
    proba_W_W_OBacc05 = (durWW_Piez_OB/durW_OB)*100 ;   
    
    durW_OB = sum(Stop(Wake_accelerosup60,'s') - Start(Wake_accelerosup60,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup60,Wake_accelerosup60),'s') - Start(and(Wake_OBsup60,Wake_accelerosup60),'s'));
    proba_W_W_OBaccsup60 = (durWW_Piez_OB/durW_OB)*100 ;   

    durW_OB = sum(Stop(Wake_accelerosup120,'s') - Start(Wake_accelerosup120,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup120,Wake_accelerosup120),'s') - Start(and(Wake_OBsup120,Wake_accelerosup120),'s'));
    proba_W_W_OBaccsup120 = (durWW_Piez_OB/durW_OB)*100 ;   
    
    durW_OB = sum(Stop(Wake_accelerosup180,'s') - Start(Wake_accelerosup180,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup180,Wake_accelerosup180),'s') - Start(and(Wake_OBsup180,Wake_accelerosup180),'s'));
    proba_W_W_OBaccsup180 = (durWW_Piez_OB/durW_OB)*100 ;       
    
    durW_OB = sum(Stop(Wake_accelerosup240,'s') - Start(Wake_accelerosup240,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup240,Wake_accelerosup240),'s') - Start(and(Wake_OBsup240,Wake_accelerosup240),'s'));
    proba_W_W_OBaccsup240 = (durWW_Piez_OB/durW_OB)*100 ;   
    
    durW_OB = sum(Stop(Wake_accelerosup300,'s') - Start(Wake_accelerosup300,'s'));
    durWW_Piez_OB = sum(Stop(and(Wake_OBsup300,Wake_accelerosup300),'s') - Start(and(Wake_OBsup300,Wake_accelerosup300),'s'));
    proba_W_W_OBaccsup300 = (durWW_Piez_OB/durW_OB)*100 ;       
    %% Create the table : 
    values_overlap_SleepScoring_AF(i,1) = proba_W_W_OB;
    values_overlap_SleepScoring_AF(i,2) = proba_W_W_OB50;
    values_overlap_SleepScoring_AF(i,3) = proba_W_W_OB40;
    values_overlap_SleepScoring_AF(i,4) = proba_W_W_OB30;
    values_overlap_SleepScoring_AF(i,5) = proba_W_W_OB20;
    values_overlap_SleepScoring_AF(i,6) = proba_W_W_OB10;
    values_overlap_SleepScoring_AF(i,7) = proba_W_W_OB05;
    values_overlap_SleepScoring_AF(i,8) = proba_W_W_OBsup60;
    values_overlap_SleepScoring_AF(i,9) = proba_W_W_OBsup120;
    values_overlap_SleepScoring_AF(i,10) = proba_W_W_OBsup180;
    values_overlap_SleepScoring_AF(i,11) = proba_W_W_OBsup240;
    values_overlap_SleepScoring_AF(i,12) = proba_W_W_OBsup300;
    values_overlap_SleepScoring_AF(i,13) = proba_W_W_accelero;
    values_overlap_SleepScoring_AF(i,14) = proba_W_W_accelero50;
    values_overlap_SleepScoring_AF(i,15) = proba_W_W_accelero40;
    values_overlap_SleepScoring_AF(i,16) = proba_W_W_accelero30;
    values_overlap_SleepScoring_AF(i,18) = proba_W_W_accelero20;
    values_overlap_SleepScoring_AF(i,19) = proba_W_W_accelero10;
    values_overlap_SleepScoring_AF(i,20) = proba_W_W_accelero05;
    values_overlap_SleepScoring_AF(i,21) = proba_W_W_accelerosup60;
    values_overlap_SleepScoring_AF(i,22) = proba_W_W_accelerosup120;   
    values_overlap_SleepScoring_AF(i,23) = proba_W_W_accelerosup180;   
    values_overlap_SleepScoring_AF(i,24) = proba_W_W_accelerosup240;   
    values_overlap_SleepScoring_AF(i,25) = proba_W_W_accelerosup300;   
    values_overlap_SleepScoring_AF(i,26) = proba_W_W_OBacc;
    values_overlap_SleepScoring_AF(i,27) = proba_W_W_OBacc50;
    values_overlap_SleepScoring_AF(i,28) = proba_W_W_OBacc40;
    values_overlap_SleepScoring_AF(i,29) = proba_W_W_OBacc30;
    values_overlap_SleepScoring_AF(i,30) = proba_W_W_OBacc20;
    values_overlap_SleepScoring_AF(i,31) = proba_W_W_OBacc10;
    values_overlap_SleepScoring_AF(i,32) = proba_W_W_OBacc05;
    values_overlap_SleepScoring_AF(i,33) = proba_W_W_OBaccsup60;
    values_overlap_SleepScoring_AF(i,34) = proba_W_W_OBaccsup120;
    values_overlap_SleepScoring_AF(i,35) = proba_W_W_OBaccsup180;
    values_overlap_SleepScoring_AF(i,36) = proba_W_W_OBaccsup240;
    values_overlap_SleepScoring_AF(i,37) = proba_W_W_OBaccsup300;

end

for m = 1:37;
mean_values_overlap_SleepScoring_AF(1,m) = mean(values_overlap_SleepScoring_AF(:,m));
end



%% Plot the figure:

groups = {'>300s','>240s','>180s','>120s','>60s','<60s','<50s','<40s','<30s','<20s','<10s','<5s'};

fig = figure; 
suptitle('Chevauchement (%) sur les petits éveils')

subplot(311);
A = {values_overlap_SleepScoring_AF(:,37),values_overlap_SleepScoring_AF(:,36),values_overlap_SleepScoring_AF(:,35),...
    values_overlap_SleepScoring_AF(:,34),values_overlap_SleepScoring_AF(:,33),...
    values_overlap_SleepScoring_AF(:,26),values_overlap_SleepScoring_AF(:,27),values_overlap_SleepScoring_AF(:,28),...
    values_overlap_SleepScoring_AF(:,29),values_overlap_SleepScoring_AF(:,30),values_overlap_SleepScoring_AF(:,31),...
    values_overlap_SleepScoring_AF(:,32)};
Cols = {magma(12)};
Cols = {[0.00146159096000000,0.000466127766000000,0.0138655200000000],[0.0705722209499949,0.0501428903038421,0.195357867272727],...
    [0.200615203661423,0.0635238948216726,0.406738160272727],[0.350985666787874,0.0842682619994275,0.494873744636364],...
    [0.492582630743639,0.140841429406746,0.507994081727273],[0.638632839454546,0.189736741408806,0.494262267333334],...
    [0.786777335636364,0.241761787433362,0.449946841969349],[0.914536298545455,0.331534161396806,0.381834800851296],...
    [0.978862331545455,0.486976844361431,0.366823367427078],[0.996252059454545,0.658319055920175,0.449360950421359],...
    [0.995184503454545,0.825758484186287,0.584508787891694],[0.987052509000000,0.991437853000000,0.749504188000000]};
X = [1,2,3,4,5,6,7,8,9,10,11,12];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',0)
xlabel('Durée d éveil')
ylabel('Chevauchement (%)')
title('Accéléromètre/OB Gamma')
set(gca, 'XTickLabel',groups);
ylim([0 100]);
hold on 

subplot(312);
A = {values_overlap_SleepScoring_AF(:,12),values_overlap_SleepScoring_AF(:,11),values_overlap_SleepScoring_AF(:,10),...
    values_overlap_SleepScoring_AF(:,9),values_overlap_SleepScoring_AF(:,8),values_overlap_SleepScoring_AF(:,1),...
    values_overlap_SleepScoring_AF(:,2),values_overlap_SleepScoring_AF(:,3),...
    values_overlap_SleepScoring_AF(:,4),values_overlap_SleepScoring_AF(:,5),values_overlap_SleepScoring_AF(:,6),...
    values_overlap_SleepScoring_AF(:,7)};
Cols = {magma(12)};
Cols = {[0.00146159096000000,0.000466127766000000,0.0138655200000000],[0.0705722209499949,0.0501428903038421,0.195357867272727],...
    [0.200615203661423,0.0635238948216726,0.406738160272727],[0.350985666787874,0.0842682619994275,0.494873744636364],...
    [0.492582630743639,0.140841429406746,0.507994081727273],[0.638632839454546,0.189736741408806,0.494262267333334],...
    [0.786777335636364,0.241761787433362,0.449946841969349],[0.914536298545455,0.331534161396806,0.381834800851296],...
    [0.978862331545455,0.486976844361431,0.366823367427078],[0.996252059454545,0.658319055920175,0.449360950421359],...
    [0.995184503454545,0.825758484186287,0.584508787891694],[0.987052509000000,0.991437853000000,0.749504188000000]};
X = [1,2,3,4,5,6,7,8,9,10,11,12];
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',0)
xlabel('Durée d éveil')
ylabel('Chevauchement (%)')
title('Piezo/OB Gamma')
set(gca, 'XTickLabel',groups);
ylim([0 100]);
hold on 

subplot(313);
A = {values_overlap_SleepScoring_AF(:,25),values_overlap_SleepScoring_AF(:,24),values_overlap_SleepScoring_AF(:,23),...
    values_overlap_SleepScoring_AF(:,22),values_overlap_SleepScoring_AF(:,21),...
    values_overlap_SleepScoring_AF(:,13),values_overlap_SleepScoring_AF(:,14),values_overlap_SleepScoring_AF(:,15),...
    values_overlap_SleepScoring_AF(:,16),values_overlap_SleepScoring_AF(:,18),values_overlap_SleepScoring_AF(:,19),...
    values_overlap_SleepScoring_AF(:,20)};
Cols = {magma(12)};
Cols = {[0.00146159096000000,0.000466127766000000,0.0138655200000000],[0.0705722209499949,0.0501428903038421,0.195357867272727],...
    [0.200615203661423,0.0635238948216726,0.406738160272727],[0.350985666787874,0.0842682619994275,0.494873744636364],...
    [0.492582630743639,0.140841429406746,0.507994081727273],[0.638632839454546,0.189736741408806,0.494262267333334],...
    [0.786777335636364,0.241761787433362,0.449946841969349],[0.914536298545455,0.331534161396806,0.381834800851296],...
    [0.978862331545455,0.486976844361431,0.366823367427078],[0.996252059454545,0.658319055920175,0.449360950421359],...
    [0.995184503454545,0.825758484186287,0.584508787891694],[0.987052509000000,0.991437853000000,0.749504188000000]};
X = [1,2,3,4,5,6,7,8,9,10,11,12];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',0)
xlabel('Durée d éveil')
ylabel('Chevauchement (%)')
title('Piezo/Accéléromètre')
ylim([0 100]);
set(gca, 'XTickLabel',groups);