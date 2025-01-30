% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphys=[253,258,299,395,403,451,248,244,254,402,230,249,250,291,297,298];
IsObx=[0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered spectro
FreqRange=[1:12;[3:14]];
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    
 % All types of phase coupling with filtering in different frequencies
    % HPC - PFcx
    if exist('LFPPhaseCoupling/FzPhaseCouplingHPCLoc_PFCx.mat')>0
        % HPC non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingHPC1_PFCx.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingHPC2_PFCx.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPCnonlocPFCX.Shannon(mm,:)=FinalSig.Shannon;
        AllHPCnonlocPFCX.VectLength(mm,:)=FinalSig.VectLength;
        % HPC  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingHPCLoc_PFCx.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllHPClocPFCX.Shannon(mm,:)=(FinalSig.Shannon);
        AllHPClocPFCX.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllHPCnonlocPFCX.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllHPCnonlocPFCX.VectLength(mm,:)=nan(1,size(FreqRange,2));
        AllHPClocPFCX.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllHPClocPFCX.VectLength(mm,:)=nan(1,size(FreqRange,2));
    end
    
    % HPC local / non local - OB
    if exist('LFPPhaseCoupling/FzPhaseCouplingOB2_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC1.mat')
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC2.mat')
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPCLoc.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPCLoc.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
    elseif exist('LFPPhaseCoupling/FzPhaseCouplingOB1_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPCLoc.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllHPCnonlocOB.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllHPCnonlocOB.VectLength(mm,:)=nan(1,size(FreqRange,2));
        AllHPClocOB.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllHPClocOB.VectLength(mm,:)=nan(1,size(FreqRange,2));
    end
    
    % OB - PFCx
    if exist('LFPPhaseCoupling/FzPhaseCouplingOBLoc_PFCx.mat')>0
        % OB non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_PFCx.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_PFCx.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBnonlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBnonlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
        
        % OB  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_PFCx.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllOBlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    else
        AllOBnonlocPFCX.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllOBnonlocPFCX.VectLength(mm,:)=nan(1,size(FreqRange,2));
        AllOBlocPFCX.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllOBlocPFCX.VectLength(mm,:)=nan(1,size(FreqRange,2));
    end
    
    % OB local / non local - HPC
    if exist('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC2.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC1.mat')
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC2.mat')
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC2.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    elseif  exist('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC1.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingOB1_HPC1.mat')
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        load('LFPPhaseCoupling/FzPhaseCouplingOB2_HPC1.mat')
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingOBLoc_HPC1.mat')
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange);
        AllOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    else
        AllOBnonlocHPC.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllOBnonlocHPC.VectLength(mm,:)=nan(1,size(FreqRange,2));
        AllOBlocHPC.Shannon(mm,:)=nan(1,size(FreqRange,2));
        AllOBlocHPC.VectLength(mm,:)=nan(1,size(FreqRange,2));
    end
    
    % Same but with Phase definedusng interpoled peak troughs
    % HPC - PFcx
    if exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiHPCLoc_PFCx.mat')>0
        % HPC non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiHPC1_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiHPC2_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiHPCnonlocPFCX.Shannon(mm,:)=FinalSig.Shannon;
        AllMiniMaxiHPCnonlocPFCX.VectLength(mm,:)=FinalSig.VectLength;
        % HPC  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiHPCLoc_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllMiniMaxiHPClocPFCX.Shannon(mm,:)=(FinalSig.Shannon);
        AllMiniMaxiHPClocPFCX.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllMiniMaxiHPCnonlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPCnonlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPClocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPClocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % HPC local / non local - OB
    if exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllMiniMaxiHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllMiniMaxiHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllMiniMaxiHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
    elseif exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllMiniMaxiHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllMiniMaxiHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllMiniMaxiHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllMiniMaxiHPCnonlocOB.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPCnonlocOB.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPClocOB.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiHPClocOB.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % OB - PFCx
    if exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_PFCx.mat')>0
        % OB non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiOBnonlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBnonlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
        
        % OB  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllMiniMaxiOBlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    else
        AllMiniMaxiOBnonlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBnonlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % OB local / non local - HPC
    if exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC2.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllMiniMaxiOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    elseif  exist('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC1.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllMiniMaxiOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingMiniMaxiOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllMiniMaxiOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllMiniMaxiOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    else
        AllMiniMaxiOBnonlocHPC.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBnonlocHPC.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBlocHPC.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllMiniMaxiOBlocHPC.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
        % MN coupling but with filtering in the bans that presents a peak in
    % the spectra
    if exist('LFPPhaseCoupling/FzPhaseCouplingMNHPCLoc_PFCx.mat')>0
        % HPC non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMNHPC1_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNHPC2_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNHPCnonlocPFCX.Shannon(mm,:)=FinalSig.Shannon;
        AllSpeBandMNHPCnonlocPFCX.VectLength(mm,:)=FinalSig.VectLength;
        % HPC  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMNHPCLoc_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllSpeBandMNHPClocPFCX.Shannon(mm,:)=(FinalSig.Shannon);
        AllSpeBandMNHPClocPFCX.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllSpeBandMNHPCnonlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPCnonlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPClocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPClocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % HPC local / non local - OB
    if exist('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllSpeBandMNHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllSpeBandMNHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllSpeBandMNHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
    elseif exist('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPCLoc.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNHPCnonlocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllSpeBandMNHPCnonlocOB.VectLength(mm,:)=(FinalSig.VectLength);
        
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPCLoc.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllSpeBandMNHPClocOB.Shannon(mm,:)=(FinalSig.Shannon);
        AllSpeBandMNHPClocOB.VectLength(mm,:)=(FinalSig.VectLength);
    else
        AllSpeBandMNHPCnonlocOB.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPCnonlocOB.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPClocOB.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNHPClocOB.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % OB - PFCx
    if exist('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_PFCx.mat')>0
        % OB non local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNOBnonlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBnonlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
        
        % OB  local - PFCx
        load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_PFCx.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllSpeBandMNOBlocPFCX.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBlocPFCX.VectLength(mm,:,:)=FinalSig.VectLength;
    else
        AllSpeBandMNOBnonlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBnonlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBlocPFCX.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBlocPFCX.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end
    
    % OB local / non local - HPC
    if exist('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC2.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig3=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig4=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength+FinalSig3.VectLength+FinalSig4.VectLength)/4;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon+FinalSig3.Shannon+FinalSig4.Shannon)/4;
        AllSpeBandMNOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC2.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    elseif  exist('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC1.mat')>0
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB1_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig1=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        load('LFPPhaseCoupling/FzPhaseCouplingMNOB2_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig2=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        FinalSig.VectLength=(FinalSig1.VectLength+FinalSig2.VectLength)/2;
        FinalSig.Shannon=(FinalSig1.Shannon+FinalSig2.Shannon)/2;
        AllSpeBandMNOBnonlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBnonlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
        load('LFPPhaseCoupling/FzPhaseCouplingMNOBLoc_HPC1.mat'),IndexRand=TransformIndRand(IndexRand,MNRatio');
        FinalSig=GetPhaseCouplingSig(Index,IndexRand,MNRatio');
        AllSpeBandMNOBlocHPC.Shannon(mm,:,:)=FinalSig.Shannon;
        AllSpeBandMNOBlocHPC.VectLength(mm,:,:)=FinalSig.VectLength;
        
    else
        AllSpeBandMNOBnonlocHPC.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBnonlocHPC.VectLength(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBlocHPC.Shannon(mm,:)=nan(1,size(MNRatio',2));
        AllSpeBandMNOBlocHPC.VectLength(mm,:)=nan(1,size(MNRatio',2));
    end

end

% Hippocampus figure - CTL mice
figure('name','Hippocampus - CTRL mice')
subplot(2,2,1), hold on
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.VectLength(IsObx==0,:),FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocPFCX.VectLength(IsObx==0,:),FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,2)
AvCouplingAndSignifPlot(AllHPCnonlocOB.VectLength(IsObx==0,:),FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocOB.VectLength(IsObx==0,:),FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi OB')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,3)
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.Shannon(IsObx==0,:),FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocPFCX.Shannon(IsObx==0,:),FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])
subplot(2,2,4)
AvCouplingAndSignifPlot(AllHPCnonlocOB.Shannon(IsObx==0,:),FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocOB.Shannon(IsObx==0,:),FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi OB')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])

% Hippocampus figure - OBX mice
figure('name','Hippocampus - OBX mice')
subplot(2,1,1), hold on
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.VectLength(IsObx==1,:),FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllHPClocPFCX.VectLength(IsObx==1,:),FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,1,2)
AvCouplingAndSignifPlot(AllHPCnonlocPFCX.Shannon(IsObx==1,:),FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllHPClocPFCX.Shannon(IsObx==1,:),FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])

% OB figure - CTL mice
figure('name','OB - CTRL mice')
subplot(2,2,1), hold on
AvCouplingAndSignifPlot(AllOBnonlocPFCX.VectLength(IsObx==0,:),FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllOBlocPFCX.VectLength(IsObx==0,:),FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi PFCx')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,2)
AvCouplingAndSignifPlot(AllOBnonlocHPC.VectLength(IsObx==0,:),FreqRange,[1 0 0],0.85,0.02)
AvCouplingAndSignifPlot(AllOBlocHPC.VectLength(IsObx==0,:),FreqRange,[0 0 1],0.7,0.02)
title('Local/NonLocal HPC wi OB')
ylabel('Vect Length'), ylim([0 0.9]), xlim([2 13])
subplot(2,2,3)
AvCouplingAndSignifPlot(AllOBnonlocPFCX.Shannon(IsObx==0,:),FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllOBlocPFCX.Shannon(IsObx==0,:),FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi PFCx')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])
subplot(2,2,4)
AvCouplingAndSignifPlot(AllOBnonlocHPC.Shannon(IsObx==0,:),FreqRange,[1 0 0],0.2,0.005)
AvCouplingAndSignifPlot(AllOBlocHPC.Shannon(IsObx==0,:),FreqRange,[0 0 1],0.15,0.005)
title('Local/NonLocal HPC wi OB')
ylabel('Entropy'), ylim([0 0.2]), xlim([2 13])

%% MN coupling with peak trough method
figure('name','MN Coupling Peak-Trough method - vect str')
subplot(411)
temp1=AllMiniMaxiHPCnonlocPFCX.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocPFCX.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.35,'n*PFCx:1*HPC')
text(8,0.35,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
subplot(412)
temp1=AllMiniMaxiHPCnonlocOB.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocOB.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,0.3,'n*HPC:1*OB')
text(8,0.3,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
subplot(413)
temp1=AllMiniMaxiOBnonlocPFCX.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiOBlocPFCX.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.7,'n*PFCx:1*OB')
text(8,0.7,'n*OB:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - PFCx')
subplot(414)
temp1=AllMiniMaxiOBnonlocHPC.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiOBlocHPC.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.3,'n*HPC:1*OB')
text(8,0.3,'n*OB:1*HPC')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - HPC')

%% MN coupling with peak trough method
figure('name','MN Coupling spe filter method - vect str')
subplot(411)
temp1=AllSpeBandMNHPCnonlocPFCX.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocPFCX.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.07,'n*PFCx:1*HPC')
text(8,0.07,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
subplot(412)
temp1=AllSpeBandMNHPCnonlocOB.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocOB.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,0.05,'n*HPC:1*OB')
text(8,0.05,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
subplot(413)
temp1=AllSpeBandMNOBnonlocPFCX.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNOBlocPFCX.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.7,'n*PFCx:1*OB')
text(8,0.7,'n*OB:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - PFCx')
subplot(414)
temp1=AllSpeBandMNOBnonlocHPC.VectLength(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNOBlocHPC.VectLength(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.07,'n*HPC:1*OB')
text(8,0.07,'n*OB:1*HPC')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - HPC')


% Same with Shannon
%% MN coupling with peak trough method
figure('name','MN Coupling Peak-Trough method - Shannon')
subplot(411)
temp1=AllMiniMaxiHPCnonlocPFCX.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocPFCX.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.015,'n*PFCx:1*HPC')
text(8,0.015,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
subplot(412)
temp1=AllMiniMaxiHPCnonlocOB.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiHPClocOB.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,0.015,'n*HPC:1*OB')
text(8,0.015,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
subplot(413)
temp1=AllMiniMaxiOBnonlocPFCX.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiOBlocPFCX.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.15,'n*PFCx:1*OB')
text(8,0.15,'n*OB:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - PFCx')
subplot(414)
temp1=AllMiniMaxiOBnonlocHPC.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllMiniMaxiOBlocHPC.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.015,'n*HPC:1*OB')
text(8,0.015,'n*OB:1*HPC')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - HPC')

%% MN coupling with specifi band method
figure('name','MN Coupling spe filter method - Shannon')
subplot(411)
temp1=AllSpeBandMNHPCnonlocPFCX.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocPFCX.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,1.5e-3,'n*PFCx:1*HPC')
text(8,1.5e-3,'n*HPC:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('HPC (l-nl) - PFCx')
subplot(412)
temp1=AllSpeBandMNHPCnonlocOB.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNHPClocOB.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
text(3,1.5e-3,'n*HPC:1*OB')
text(8,1.5e-3,'n*OB:1*HPC')
title('HPC (l-nl) - OB')
subplot(413)
temp1=AllSpeBandMNOBnonlocPFCX.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNOBlocPFCX.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,0.3,'n*PFCx:1*OB')
text(8,0.3,'n*OB:1*PFCx')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - PFCx')
subplot(414)
temp1=AllSpeBandMNOBnonlocHPC.Shannon(IsObx==0,:);TotMice1=sum(sum(isnan(temp1'))==0);TotSig1=sum(temp1>0);
temp1(temp1==0)=NaN;
temp2=AllSpeBandMNOBlocHPC.Shannon(IsObx==0,:);TotMice2=sum(sum(isnan(temp2'))==0);TotSig2=sum(temp2>0);
temp2(temp2==0)=NaN;
g=bar([1:11],[nanmean(temp1);nanmean(temp2)]')
set(g(1),'facecolor','r')
set(g(2),'facecolor','b')
Yl=max(ylim)*1.2;
for k=1:length(MNRatio')
    text(k,Yl,[num2str(TotSig1(k)),'/',num2str(TotMice1)],'color','r')
    text(k,Yl*1.1,[num2str(TotSig2(k)),'/',num2str(TotMice2)],'color','b')
    XTickList{k}=[num2str(MNRatio(k,1)),':',num2str(MNRatio(k,2))];
end
ylim([0 Yl*1.2])
line([1.5 1.5],ylim,'color','k','linewidth',2,'linestyle','--'),line([6.5 6.5],ylim,'color','k','linewidth',2,'linestyle','--'),
text(3,1.5e-3,'n*HPC:1*OB')
text(8,1.5e-3,'n*OB:1*HPC')
set(gca,'XTickLabel',XTickList)
legend('non local','local','Location','NorthEastOutside')
box off
title('OB (l-nl) - HPC')


