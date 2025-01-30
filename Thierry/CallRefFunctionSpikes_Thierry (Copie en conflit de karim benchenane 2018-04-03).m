if ExpeInfo.nmouse==648
    
    % subtraction of left hemisphere
    AllChans=[0:15];% all recorded channels
    TetVLPO1=[8:11]; % tetrode to be subtracted
    RefVLPO1=9; % electrode used for subtraction
    AllChans(TetVLPO1+1)=[];
    RefSubtraction_multi('amplifier_M648.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
    
    % subtraction of right hemisphere
    AllChans=[0:15];
    TetVLPO2=[12:15];
    RefVLPO2=12;
    AllChans(TetVLPO2+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M648_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
    
    delete('amplifier_M648_SpikeRef_original.dat')
    movefile('amplifier_M648_SpikeRef_SpikeRef.dat','amplifier_M648_SpikeRef.dat')
    movefile('amplifier_M648_original.dat','amplifier_M648.dat')
    
elseif ExpeInfo.nmouse==XXX
    
    
end