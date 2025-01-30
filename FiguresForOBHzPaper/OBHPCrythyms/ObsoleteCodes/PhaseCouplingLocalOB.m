% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvOB=[];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvOB);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
for mm=3
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    load('LFPData/InfoLFP.mat')
    
    % Get OB LFP
    clear LFP, load('LFPData/LocalOBActivity.mat')
    LFPAll.LocOB=LFP;clear LFP
    
    OBChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'Bulb')) & ~cellfun(@isempty,strfind(InfoLFP.hemisphere,'Right')));
    OBChannels=InfoLFP.channel(OBChannels(Chans));
    chB1=OBChannels(1);
    clear LFP, load(['LFPData/LFP',num2str(chB1),'.mat']);
    LFPAll.OB1=LFP; clear LFP
    chB2=OBChannels(2);
    clear LFP, load(['LFPData/LFP',num2str(chB2),'.mat']);
    LFPAll.OB2=LFP;clear LFP
    
    if exist('LFPData/LocalHPCActivity.mat')>0
        
        % Look at HPC channels used for local activity
        clear LFP, load('LFPData/LocalHPCActivity.mat')
        LFPAll.LocHPC=LFP;clear LFP
        
        HPCChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC')));
        HPCChannels=InfoLFP.channel(HPCChannels(Chans));
        
        chH1=HPCChannels(1);
        clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
        LFPAll.HPC1=LFP;clear LFP
        chH2=HPCChannels(2);
        clear LFP, load(['LFPData/LFP',num2str(chH2),'.mat']);
        LFPAll.HPC2=LFP;clear LFP
        
        
    else
        % Get default HPC channel
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            chH=channel;
        catch
            load('ChannelsToAnalyse/dHPC_rip.mat')
            chH=channel;
        end
        chH1=chH;
        clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
        LFPAll.HPC1=LFP;clear LFP
        chH2=[];
        LFPAll.LocHPC=[];
    end
    
    % Get PFcx LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFCx=LFP;clear LFP
    
    FreqRange=[1:12;[3:14]];
    
    %OB1
    if exist('OBHPCPhaseCouplingOB1HPC1.mat')==0
        disp('OB1_HPC1')
        chH=chH1;
        chB=chB1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB1,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB1HPC1.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOB1HPC2.mat')==0 & not(isempty(chH2))
        disp('OB1_HPC2')
        chH=chH2;
        chB=chB1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB1,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB1HPC2.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOB1HPCLoc.mat')==0 &  exist('LFPData/LocalHPCActivity.mat')>0
        disp('OB1_HPCLoc')
        chH=chH1;
        chB=chB1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB1,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB1HPCLoc.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    if exist('OBPFCxPhaseCouplingOB1PFCx.mat')==0
        disp('OB1_HPC1')
        chB=chB1;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB1,LFPAll.PFCx,FreqRange,FreezeEpoch,500,0);
        save OBPFCxPhaseCouplingOB1PFCx.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    % OB2
    if exist('OBHPCPhaseCouplingOB2HPC1.mat')==0
        disp('OB2_HPC1')
        chH=chH1;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB2,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB2HPC1.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOB2HPC2.mat')==0 & not(isempty(chH2))
        disp('OB2_HPC1')
        chH=chH2;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB2,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB2HPC2.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOB2HPCLoc.mat')==0 &  exist('LFPData/LocalHPCActivity.mat')>0
        disp('OB2_HPCLoc')
        chH=chH1;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB2,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOB2HPCLoc.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    if exist('OBPFCxPhaseCouplingOB2PFCx.mat')==0
        disp('OB2_HPC1')
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB2,LFPAll.PFCx,FreqRange,FreezeEpoch,500,0);
        save OBPFCxPhaseCouplingOB2PFCx.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    % OBLoc
    if exist('OBHPCPhaseCouplingOBLocHPC1.mat')==0
        disp('OBLoc_HPC1')
        chH=chH1;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.LocOB,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOBLocHPC1.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOBLocHPC2.mat')==0 & not(isempty(chH2))
        disp('OBLoc_HPC1')
        chH=chH2;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.LocOB,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOBLocHPC2.mat Index IndexRand Phase chH chB
        clear Index IndexRand Phase
    end
    
    if exist('OBHPCPhaseCouplingOBLocHPCLoc.mat')==0 &  exist('LFPData/LocalHPCActivity.mat')>0
        disp('OBLoc_HPCLoc')
        chH=chH1;
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.LocOB,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
        save OBHPCPhaseCouplingOBLocHPCLoc.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    if exist('OBPFCxPhaseCouplingOBLocPFCx.mat')==0
        disp('OBLoc_HPC1')
        chB=chB2;
        [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.LocOB,LFPAll.PFCx,FreqRange,FreezeEpoch,500,0);
        save OBPFCxPhaseCouplingOBLocPFCx.mat Index IndexRand Phase chB
        clear Index IndexRand Phase
    end
    
    
    clear LFPAll chH chH2 chH1 Chans HPCChannels FreezeEpoch
    
end

