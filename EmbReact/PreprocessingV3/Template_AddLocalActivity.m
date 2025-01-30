MouseOfInterest = XXXXXXXx;
HPCLocChannels = XXXXX;
OBLocChannels = XXXX;

FileNames=GetAllMouseTaskSessions(MouseOfInterest);

for k = 1:length(FileNames)
    
    cd(FileNames{k})
    clear ExpeInfo
    load('ExpeInfo.mat','ExpeInfo')
    
    
    % HPCLoc
    if not(isempty(HPCLocChannels))
        ExpeInfo.IsLocalHPC=1;
        channel=HPCLocChannels;
        save('ChannelsToAnalyse/dHPC_local.mat','channel')
        ExpeInfo.ChannelsToAnalyse.dHPC_local=channel;
        load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
        load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
        LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
        save('LFPData/LocalHPCActivity.mat','LFP','channel')
        clear LFP1 LFP2 LFP channel
    else
        ExpeInfo.IsLocalHPC=0;
    end
    
    % OBloc
    if not(isempty(OBLocChannels))
        ExpeInfo.IsLocalOB=1;
        channel=OBLocChannels;
        save('ChannelsToAnalyse/Bulb_local.mat','channel')
        ExpeInfo.ChannelsToAnalyse.Bulb_local=channel;
        load(['LFPData/LFP',num2str(channel(1)),'.mat']); LFP1=LFP;
        load(['LFPData/LFP',num2str(channel(2)),'.mat']); LFP2=LFP;
        LFP=tsd(Range(LFP),Data(LFP1)-Data(LFP2));
        save('LFPData/LocalOBActivity.mat','LFP','channel')
        clear LFP1 LFP2 LFP channel
    else
        ExpeInfo.IsLocalOB=1;
    end
    
    save('ExpeInfo.mat','ExpeInfo')
    clear ExpeInfo
end