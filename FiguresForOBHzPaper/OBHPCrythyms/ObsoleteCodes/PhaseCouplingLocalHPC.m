% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[253,258,299,395,403,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
for mm=6
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
    % Get OB LFP
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    clear LFP,load(['LFPData/LFP',num2str(chB),'.mat']);
    LFPAll.OB=LFP;
    clear y LFP
    
    % Get default HPC channel
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
        chH=channel;
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        chH=channel;
    end
    
    % Look at HPC channels used for local activity
    load('LFPData/InfoLFP.mat')
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.LocHPC=LFP;
    
    HPCChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC')));
    HPCChannels=InfoLFP.channel(HPCChannels(Chans));
  
    chH1=HPCChannels(1);
    clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
    LFPAll.HPC1=LFP;
    chH2=HPCChannels(2);
    clear LFP, load(['LFPData/LFP',num2str(chH2),'.mat']);
    LFPAll.HPC2=LFP;

    
    % Get PFcx LFP
    clear y LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFCx=LFP;
    
%     delete('OBHPCPhaseCoupling1.mat')
%     delete('OBHPCPhaseCoupling2.mat')
%     delete('PFCxHPCPhaseCoupling1.mat')
%     delete('PFCxHPCPhaseCoupling2.mat')
    
    FreqRange=[1:12;[3:14]];
            [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC1,FreqRange,FreezeEpoch,0,0);

    if exist('OBHPCPhaseCoupling1.mat')==0
        disp('OB_HPC 1')
        chH=chH1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCoupling1.mat Index IndexRand Phase chH
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCoupling2.mat')==0 
        disp('OB_HPC 2')
        chH=chH2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCoupling2.mat Index IndexRand Phase chH
        clear Index IndexRand Phase
    end

    if exist('PFCxHPCPhaseCoupling1.mat')==0 
        disp('PFC_HPC 1')
        chH=chH1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.PFCx,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
        save PFCxHPCPhaseCoupling1.mat Index IndexRand Phase chH
        clear Index IndexRand Phase
    end
    
    if exist('PFCxHPCPhaseCoupling2.mat')==0 
        disp('PFC_HPC 2')        
        chH=chH2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.PFCx,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
        save PFCxHPCPhaseCoupling2.mat Index IndexRand Phase chH
        clear Index IndexRand Phase
    end
    
    if exist('OBLocHPCPhaseCoupling.mat')==0
        disp('OB_HPCLoc')
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
        save OBLocHPCPhaseCoupling.mat Index IndexRand Phase
        clear Index IndexRand Phase
    end
    
    if exist('PFCxLocHPChaseCoupling.mat')==0
        disp('PFC_HPCLoc')
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.PFCx,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
        save PFCxLocHPChaseCoupling.mat Index IndexRand Phase
        clear Index IndexRand Phase
    end
    
    if exist('OBPFCxPhaseCoupling.mat')==0
        disp('OB_PFCx')
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.PFCx,FreqRange,FreezeEpoch,500,0);
        save OBPFCxPhaseCoupling.mat Index IndexRand Phase
        clear Index IndexRand Phase
    end
    
    clear LFPAll chH chH2 chH1 Chans HPCChannels FreezeEpoch
    
end

