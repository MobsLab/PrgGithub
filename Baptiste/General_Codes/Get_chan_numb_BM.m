function channel = Get_chan_numb_BM(FolderList , struct)

switch struct
    case 'rip'
        load([FolderList '/ChannelsToAnalyse/dHPC_rip.mat']);
    case 'hpc_deep'
        load([FolderList '/ChannelsToAnalyse/dHPC_deep.mat']);
    case 'hpc_sup'
        load([FolderList '/ChannelsToAnalyse/dHPC_sup.mat']);
    case 'bulb_deep'
        load([FolderList '/ChannelsToAnalyse/Bulb_deep.mat']);
    case 'pfc_deep'
        load([FolderList '/ChannelsToAnalyse/PFCx_deep.mat']);
    case 'EKG'
        load([FolderList '/ChannelsToAnalyse/EKG.mat']);
    case 'EMG'
        load([FolderList '/ChannelsToAnalyse/EMG.mat']);
    case 'ThetaREM'
        load([FolderList '/ChannelsToAnalyse/ThetaREM.mat']);
            case 'Ref'
        load([FolderList '/ChannelsToAnalyse/Ref.mat']);
end
end























