%elseif ExpeInfo.nmouse==647
    
    % subtraction of left hemisphere
    AllChans=[0:15];% all recorded channels
    TetVLPO1=[8:11]; % tetrode to be subtracted
    RefVLPO1=9; % electrode used for subtraction
    AllChans(TetVLPO1+1)=[];
    RefSubtraction_multi('amplifier_M647.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
    
    % subtraction of right hemisphere
    AllChans=[0:15];
    TetVLPO2=[12:15];
    RefVLPO2=14;
    AllChans(TetVLPO2+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M647_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
    
    delete('amplifier_M647_SpikeRef_original.dat')
    movefile('amplifier_M647_SpikeRef_SpikeRef.dat','amplifier_M647_SpikeRef.dat')
    movefile('amplifier_M647_original.dat','amplifier_M647.dat')
    
   % elseif ExpeInfo.nmouse==675
        
        % subtraction of left hemisphere
        AllChans=[0:15];% all recorded channels
        TetVLPO1=[8:11]; % tetrode to be subtracted
        RefVLPO1=9; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M675.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:15];
        TetVLPO2=[12:15];
        RefVLPO2=14;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M675_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M675_SpikeRef_original.dat')
        movefile('amplifier_M675_SpikeRef_SpikeRef.dat','amplifier_M675_SpikeRef.dat')
        movefile('amplifier_M675_original.dat','amplifier_M675.dat')
        
        
        elseif ExpeInfo.nmouse==645
    
    % subtraction of left hemisphere
    AllChans=[0:15];% all recorded channels
    TetVLPO1=[8:11]; % tetrode to be subtracted
    RefVLPO1=9; % electrode used for subtraction
    AllChans(TetVLPO1+1)=[];
    RefSubtraction_multi('amplifier_M645.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
    
    % subtraction of right hemisphere
    AllChans=[0:15];
    TetVLPO2=[12:15];
    RefVLPO2=14;
    AllChans(TetVLPO2+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M645_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
    
    delete('amplifier_M645_SpikeRef_original.dat')
    movefile('amplifier_M645_SpikeRef_SpikeRef.dat','amplifier_M645_SpikeRef.dat')
    movefile('amplifier_M645_original.dat','amplifier_M645.dat')
        
    
       elseif ExpeInfo.nmouse==675
        
        % subtraction of left hemisphere
        AllChans=[0:15];% all recorded channels
        TetVLPO1=[8:11]; % tetrode to be subtracted
        RefVLPO1=9; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M675.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:15];
        TetVLPO2=[12:15];
        RefVLPO2=14;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M675_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M675_SpikeRef_original.dat')
        movefile('amplifier_M675_SpikeRef_SpikeRef.dat','amplifier_M675_SpikeRef.dat')
        movefile('amplifier_M675_original.dat','amplifier_M675.dat')    
     
        
           elseif ExpeInfo.nmouse==711
        
        % subtraction of left hemisphere
        AllChans=[0:15];% all recorded channels
        TetVLPO1=[8:11]; % tetrode to be subtracted
        RefVLPO1=9; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M711.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:15];
        TetVLPO2=[12:15];
        RefVLPO2=14;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M711_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M711_SpikeRef_original.dat')
        movefile('amplifier_M711_SpikeRef_SpikeRef.dat','amplifier_M711_SpikeRef.dat')
        movefile('amplifier_M711_original.dat','amplifier_M711.dat') 
        
        elseif ExpeInfo.nmouse==724
    
    % subtraction of left hemisphere
    AllChans=[0:15];% all recorded channels
    TetVLPO1=[8:11]; % tetrode to be subtracted
    RefVLPO1=9; % electrode used for subtraction
    AllChans(TetVLPO1+1)=[];
    RefSubtraction_multi('amplifier_M724.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
    
    % subtraction of right hemisphere
    AllChans=[0:15];
    TetVLPO2=[12:15];
    RefVLPO2=14;
    AllChans(TetVLPO2+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M724_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
    
    delete('amplifier_M724_SpikeRef_original.dat')
    movefile('amplifier_M724_SpikeRef_SpikeRef.dat','amplifier_M724_SpikeRef.dat')
    movefile('amplifier_M724_original.dat','amplifier_M724.dat')

     
