function [ChanAll,LFPAll]=GetChannelsLFPPhaseCouplingOBHzProject(GetLFP)

if GetLFP==0
    LFPAll=[];
end
% Get HPC LFP
if exist('LFPData/LocalHPCActivity.mat')>0
    load('LFPData/InfoLFP.mat')
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    if GetLFP, LFPAll.HPCLoc=LFP; end
    ChanAll.HPCLoc=HPCChannels;
    
    ChanAll.HPC1=HPCChannels(1);
    if GetLFP,  clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
        LFPAll.HPC1=LFP;end
    
    ChanAll.HPC2=HPCChannels(2);
    if GetLFP, clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC2),'.mat']);
        LFPAll.HPC2=LFP;end
else
    ChanAll.HPCLoc=[];
    if GetLFP, LFPAll.HPCLoc=[];end
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
        chH=channel;
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        chH=channel;
    end
    ChanAll.HPC1=chH;
    if GetLFP, clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
        LFPAll.HPC1=LFP;end
    ChanAll.HPC2=[];
    if GetLFP,  LFPAll.HPC2=[];end
end

% Get OB LFP
if exist('LFPData/LocalOBActivity.mat')>0
    load('LFPData/InfoLFP.mat')
    clear LFP, load('LFPData/LocalOBActivity.mat')
    if GetLFP,  LFPAll.OBLoc=LFP;
        ChanAll.OBLoc=OBChannels;end
    
    ChanAll.OB1=OBChannels(1);
    if GetLFP, clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB1),'.mat']);
        LFPAll.OB1=LFP;end
    
    ChanAll.OB2=OBChannels(2);
    if GetLFP, clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB2),'.mat']);
        LFPAll.OB2=LFP;end
    
elseif exist('ChannelsToAnalyse/Bulb_deep.mat')>0
    if GetLFP, LFPAll.OBLoc=[];end
    ChanAll.OBLoc=[];
    load('ChannelsToAnalyse/Bulb_deep.mat')
    ChanAll.OB1=channel;
    if GetLFP, clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB1),'.mat']);
        LFPAll.OB1=LFP;end
    
    ChanAll.OB2=[];
    if GetLFP, LFPAll.OB2=[];end
else
    ChanAll.OBLoc=[];
    if GetLFP, LFPAll.OBLoc=[];end
    ChanAll.OB1=[];
    if GetLFP, LFPAll.OB1=[];end
    ChanAll.OB2=[];
    if GetLFP, LFPAll.OB2=[];end
end


% Get PFcx LFP
clear y LFP
load('ChannelsToAnalyse/PFCx_deep.mat')
chP=channel;
if GetLFP, clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFCx=LFP;end
ChanAll.PFCx=chP;
end