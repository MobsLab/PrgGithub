%LoadNeuronPFCx

try
    S;
    NumNeurons;
    SWSEpoch;
    REMEpoch;
    Wake;
catch
    tic
    load StateEpochSB SWSEpoch REMEpoch Wake
    load SpikeData
    try
        tetrodeChannels;
    catch
        SetCurrentSession
        global DATA
        tetrodeChannels=DATA.spikeGroups.groups;
        rep=input('Do you want to save tetrodechannels ? (y/n)','s');
        if rep=='y'
        save SpikeData -Append tetrodeChannels
        end
        
    end
    
    load LFPData/InfoLFP InfoLFP
    ok=0;
    for i=1:32
        try
        if InfoLFP.structure{i}=='CxPF';
            ok=1;
           InfoLFP.structure{i}='PFCx';
        end
        end
    end
    if ok==1
        disp('****** Modification of InfoLFP ******')
        res=pwd;
        cd LFPData
        save InfoLFP InfoLFP
        cd(res)
    end
    clear InfoLFP
    
    [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
    
 
    
    toc
end
