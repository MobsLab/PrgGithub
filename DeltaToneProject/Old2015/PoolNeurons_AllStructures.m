%PoolNeurons_AllStructures

try
    load SpikeData PFCx_Spk
catch
    disp(' ')
    PFCx_neurons=input('Which neurons from PFCx ? ');
    PFCx_Spk=PoolNeurons(S,PFCx_neurons);
    disp(' ')
    save SpikeData -append PFCx_Spk
end

try
    load SpikeData dHPC_Spk
catch
    disp(' ')
    dHPC_neurons=input('Which neurons from dHPC ? ');
    dHPC_Spk=PoolNeurons(S,dHPC_neurons);
    disp(' ')
    save SpikeData -append dHPC_Spk
end

try
    load SpikeData NRT_Spk
catch
    disp(' ')
    NRT_neurons=input('Which neurons from NRT ? ');
    NRT_Spk=PoolNeurons(S,NRT_neurons);
    disp(' ')
    save SpikeData -append NRT_Spk
end

try
    load SpikeData OBulb_Spk
catch
    disp(' ')
    OBulb_neurons=input('Which neurons from OBulb ? ');
    OBulb_Spk=PoolNeurons(S,OBulb_neurons);
    disp(' ')
    save SpikeData -append OBulb_Spk
end

