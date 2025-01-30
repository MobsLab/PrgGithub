% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[253,258,299,395,403,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
FreqRg.HPC=[5,8];
FreqRg.OB=[3,6];
NM=[0.5,1.2,1.5,1.7,2,2.5,3,4,5];
NumBins=80;
Smax=log(NumBins);
DoStats=500;
% Parameters for triggered spectro
for mm=1:length(CtrlEphysInvHPC)
    mm
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        Epoch=FreezeEpoch;

    % Get OB LFP
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    clear LFP,load(['LFPData/LFP',num2str(chB),'.mat']);
    LFPAll.OB=FilterLFP(LFP,FreqRg.OB,1024);
    clear y LFP
    
    % Look at HPC channels used for local activity
    load('LFPData/InfoLFP.mat')
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.LocHPC=FilterLFP(LFP,FreqRg.HPC,1024);
    
    % Step one : for each mini-epoch filter in freq ranges, get instantaneous phase with Hilbert
    AllPhase.OB=[];
    AllPhase.LocHPC=[];
    for p=1:length(Start(Epoch))
        LitEpoch=subset(Epoch,p);
        Hil=hilbert(Data(Restrict(LFPAll.OB,LitEpoch)));
        PhaseOB{p}=phase(Hil);
        AllPhase.OB=[AllPhase.OB;PhaseOB{p}];
        Hil=hilbert(Data(Restrict(LFPAll.LocHPC,LitEpoch)));
        PhaseHPC{p}=phase(Hil);
        AllPhase.LocHPC=[AllPhase.LocHPC;PhaseHPC{p}];
    end
    
    for n=1:length(NM)
        AllPhaseDiff{n}=(mod(AllPhase.LocHPC-NM(n)*AllPhase.OB,2*pi));
        [Y1,X1]=hist(AllPhaseDiff{n},NumBins);
        Y1=Y1/sum(Y1);
        S=-sum(Y1.*log(Y1));
        Index.Shannon(n)=(Smax-S)/Smax;
        Index.VectLength(n)=sqrt(sum(cos(AllPhaseDiff{n})).^2+sum(sin(AllPhaseDiff{n})).^2)/length(AllPhaseDiff{n});
        
        for sh=1:DoStats
            
            AllPhaseDiffSh=[];
            for p=1:length(Start(Epoch))
                snip=ceil(rand(1)*length(PhaseHPC{p}));
                temp1=[PhaseHPC{p}(snip:end);PhaseHPC{p}(1:snip-1)];
                snip=ceil(rand(1)*length(PhaseOB{p}));
                temp2=[PhaseOB{p}(snip:end);PhaseOB{p}(1:snip-1)];
                AllPhaseDiffSh=[AllPhaseDiffSh,(mod(temp1-NM(n)*temp2,2*pi))'];
            end
            
            [Y,X]=hist(AllPhaseDiffSh,NumBins);
            Y=Y/sum(Y);
            S=-sum(Y.*log(Y));
            IndexRand.Shannon(n,sh)=(Smax-S)/Smax;
            IndexRand.VectLength(n,sh)=sqrt(sum(cos(AllPhaseDiffSh)).^2+sum(sin(AllPhaseDiffSh)).^2)/length(AllPhaseDiffSh);
        end
    end
    
    save('NMCouplingOB_HPCLocal.mat','NM','Index','IndexRand')
    clear Index IndexRand Phase LFPAll AllPhaseDiffSh AllPhaseDiff AllPhase PhaseOB PhaseHPC
    
end

