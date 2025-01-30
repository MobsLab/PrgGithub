if ExpeInfo.nmouse==507
    AllChans=[0:63];
    TetPFC1=[5:23];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M507.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    AllChans=[0:63];
    TetPFC1=[32,33,34,36:43,56:63];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M507_SpikeRef.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    delete('amplifier_M507_SpikeRef_original.dat')
    movefile('amplifier_M507_SpikeRef_SpikeRef.dat','amplifier_M507_SpikeRef.dat')
    movefile('amplifier_M507_original.dat','amplifier_M507.dat')
    
elseif ExpeInfo.nmouse==508
    AllChans=[0:63];
    TetPFC1=[0:7,20:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M508.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    AllChans=[0:63];
    TetPFC1=[32:43,56:63];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M508_SpikeRef.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    delete('amplifier_M508_SpikeRef_original.dat')
    movefile('amplifier_M508_SpikeRef_SpikeRef.dat','amplifier_M508_SpikeRef.dat')
    movefile('amplifier_M508_original.dat','amplifier_M508.dat')
    
elseif ExpeInfo.nmouse==509
    AllChans=[0:63];
    TetPFC1=[0:7,22,24:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M509.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    AllChans=[0:63];
    TetPFC1=[32,33,36:43,56:61,63];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M509_SpikeRef.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    delete('amplifier_M509_SpikeRef_original.dat')
    movefile('amplifier_M509_SpikeRef_SpikeRef.dat','amplifier_M509_SpikeRef.dat')
    movefile('amplifier_M509_original.dat','amplifier_M509.dat')
    
elseif ExpeInfo.nmouse==512
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[4:23];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M512.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M512_original.dat','amplifier_M512.dat')
    
elseif ExpeInfo.nmouse==510
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[4:23];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M512.dat',36,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M512_original.dat','amplifier_M512.dat')
    
    
elseif ExpeInfo.nmouse==490
    copyfile('/media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles/amplifier_SpikeRef.xml')
    AllChans=[0:63];
    TotChans=length(AllChans);
    TetPFC1=[32:39,48:57,59:61,63];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M490.dat',64,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M490_original.dat','amplifier_M490.dat')
    
elseif ExpeInfo.nmouse==514
    AllChans=[0:47];
    TotChans=length(AllChans);
    TetPFC1=[1,3:7,15:22,25:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M514.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M514_original.dat','amplifier_M514.dat')
    
elseif ExpeInfo.nmouse==750
    %     AllChans=[0:31];
    % modified for MTZL experiment
    AllChans=[0:35];
    TotChans=length(AllChans);
    TetPFC1=[12:22];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M750.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M750_original.dat','amplifier_M750.dat')
    
elseif ExpeInfo.nmouse==779
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[8:19];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M779.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M779_original.dat','amplifier_M779.dat')
    
elseif ExpeInfo.nmouse==778
    %     AllChans=[0:31];
    % modified for MTZL experiment
    AllChans=[0:35];
    TotChans=length(AllChans);
    TetPFC1=[1,2,24:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M778.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M778_original.dat','amplifier_M778.dat')
    
elseif ExpeInfo.nmouse==775
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[1,2,4,5,6,7,28:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M775.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M775_original.dat','amplifier_M775.dat')
    
elseif ExpeInfo.nmouse==777
    %     AllChans=[0:31];
    % modified for MTZL experiment
    AllChans=[0:35];
    TotChans=length(AllChans);
    TetPFC1=[0:7,28:31];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M777.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M777_original.dat','amplifier_M777.dat')
    
elseif ExpeInfo.nmouse==795
    
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[12:23];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M795.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M795_original.dat','amplifier_M795.dat')
        
elseif ExpeInfo.nmouse==829
    
    AllChans=[0:31];
    TotChans=length(AllChans);
    TetPFC1=[16 27];
    AllChans(TetPFC1+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M829.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
    movefile('amplifier_M829_original.dat','amplifier_M829.dat')

end