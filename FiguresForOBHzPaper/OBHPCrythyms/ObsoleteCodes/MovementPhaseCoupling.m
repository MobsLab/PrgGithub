% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphys=[253,258,299,395,403,451,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
FreqRange=[1:12;[3:14]];
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Parameters for triggered spectro
for mm=7:-1:3
    mm
    clear chH chH1 chH2 Dur Mov
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    NoFreezeEpoch=intervalSet(0,max(Range(Movtsd)));
    NoFreezeEpoch=NoFreezeEpoch-FreezeEpoch;
    NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,3*1e4);
    FzDur=sum(Stop(FreezeEpoch)-Start(FreezeEpoch))/1e4;
    for ep=1:length(Start(NoFreezeEpoch))
        Dur(ep)=Stop(subset(NoFreezeEpoch,ep),'s')-Start(subset(NoFreezeEpoch,ep),'s');
        Mov(ep)=mean(Data(Restrict(Movtsd,subset(NoFreezeEpoch,ep))));
    end
    [val,ind]=sort(Mov);
    EpToKeepLim=find(cumsum(Dur(ind))>FzDur,1,'first');
    if isempty(EpToKeepLim)
        EpToKeepLim=length(Dur);
    end
    NoFreezeEpoch=subset(NoFreezeEpoch,sort(ind(1:EpToKeepLim)));
    
    % Get HPC LFP
    if exist('LFPData/LocalHPCActivity.mat')>0
        load('LFPData/InfoLFP.mat')
        clear LFP, load('LFPData/LocalHPCActivity.mat')
        LFPAll.HPCLoc=LFP;
        chH1=HPCChannels(1);
        clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
        LFPAll.HPC1=LFP;
        chH2=HPCChannels(2);
        clear LFP, load(['LFPData/LFP',num2str(chH2),'.mat']);
        LFPAll.HPC2=LFP;
    else
        LFPAll.HPCLoc=[];
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            chH=channel;
        catch
            load('ChannelsToAnalyse/dHPC_rip.mat')
            chH=channel;
        end
        chH1=chH;
        clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
        LFPAll.HPC1=LFP;
        chH2=[];
        LFPAll.HPC2=[];
    end
    
    % Get OB LFP
    if exist('LFPData/LocalOBActivity.mat')>0
        load('LFPData/InfoLFP.mat')
        clear LFP, load('LFPData/LocalOBActivity.mat')
        LFPAll.OBLoc=LFP;
        chB1=OBChannels(1);
        clear LFP, load(['LFPData/LFP',num2str(chB1),'.mat']);
        LFPAll.OB1=LFP;
        chB2=OBChannels(2);
        clear LFP, load(['LFPData/LFP',num2str(chB2),'.mat']);
        LFPAll.OB2=LFP;
    else
        LFPAll.OBLoc=[];
        load('ChannelsToAnalyse/Bulb_deep.mat')
        chB1=channel;
        clear LFP, load(['LFPData/LFP',num2str(chB1),'.mat']);
        LFPAll.OB1=LFP;
        chB2=[];
        LFPAll.OB2=[];
    end
    
    
    % Get PFcx LFP
    clear y LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFCx=LFP;
    
    AllCombi=combnk([1:length(FieldNames)],2);
    
    for cc=1:length(AllCombi)
        if not(strcmp(FieldNames{AllCombi(cc,1)}(1:2),FieldNames{AllCombi(cc,2)}(1:2)))
            if not(isempty(eval(['LFPAll.',FieldNames{AllCombi(cc,1)}]))) & not(isempty(eval(['LFPAll.',FieldNames{AllCombi(cc,2)}])))
                if exist(['MovPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])==0
                    disp(['MovPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])
                    
                    [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(eval(['LFPAll.',FieldNames{AllCombi(cc,1)}]),eval(['LFPAll.',FieldNames{AllCombi(cc,2)}]),...
                        FreqRange,NoFreezeEpoch,500,0);
                    save(['MovPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'],'Index','IndexRand','Phase','NoFreezeEpoch')
                end
            end
        end
    end
    
    clear LFPAll chH chH2 chH1 Chans HPCChannels FreezeEpoch
    
end

