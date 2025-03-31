% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[244,253,258,259,394];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc'};
TimeLag=1;
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
[params,movingwin,suffix]=SpectrumParametersML('low');

for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    clear AllHPC AllOB OBChannels AllHPCCHans LocHPC OBChanName TimeBin CorrVals LFPAll
    
    load('behavResources.mat')
    load('LFPData/InfoLFP.mat')
    AllHPCCHans=InfoLFP.channel(find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC'))));
    
    for h=1:length(AllHPCCHans)
        load(['LFPData/LFP',num2str(AllHPCCHans(h)),'.mat'])
        AllHPC{h}=LFP;
    end
    if exist('LFPData/LocalHPCActivity.mat')>0
        load('LFPData/LocalHPCActivity.mat')
        LocHPC=LFP;
    end
    
    if exist('LFPData/LocalOBActivity.mat')>0
        load('LFPData/LocalOBActivity.mat')
        AllOB{1}=LFP;
        OBChanName{1}='OBLoc';
        load(['LFPData/LFP',num2str(OBChannels(1)),'.mat'])
        AllOB{2}=LFP;
        OBChanName{2}=num2str(OBChannels(1));
        load(['LFPData/LFP',num2str(OBChannels(2)),'.mat'])
        AllOB{3}=LFP;
        OBChanName{3}=num2str(OBChannels(2));
    else
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        AllOB{1}=LFP;
        OBChanName{1}=num2str(channel);
    end
    
    % Get PFcx LFP
    clear y LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFCx=LFP;
    ChanAll.PFCx=chP;
    
    % coherence
    disp('calculating coherence')
    for h=1:length(AllHPCCHans)
        
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(chP),'_',num2str(AllHPCCHans(h)),'.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllHPCCHans(h)),'_',num2str(chP),'.mat'];
        if exist(NameTemp1)>0 | exist(NameTemp2)>0
        else
            [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(AllHPC{h}),Data(LFPAll.PFCx),movingwin,params);
            save(NameTemp2,'C','phi','S12','confC','t','f')
            clear C phi S12 S1 S2 t f confC phist chan1 chan2
        end
        [TimeBin.HPC_PFC{h},CorrVals.HPC_PFC{h}]=LFPCrossCorr(AllHPC{h},LFPAll.PFCx,FreezeEpoch,TimeLag);
        
        for b=1:length(AllOB)
            NameTemp1=['CohgramcDataL/Cohgram_',OBChanName{b},'_',num2str(AllHPCCHans(h)),'.mat'];
            NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllHPCCHans(h)),'_',OBChanName{b},'.mat'];
            if exist(NameTemp1)==0
                [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(AllHPC{h}),Data(AllOB{b}),movingwin,params);
                save(NameTemp1,'C','phi','S12','confC','t','f')
                clear C phi S12 S1 S2 t f confC phist chan1 chan2
            end
            [TimeBin.HPC_OB{h,b},CorrVals.HPC_OB{h,b}]=LFPCrossCorr(AllHPC{h},AllOB{b},FreezeEpoch,TimeLag);
        end
    end
    
    if exist('LocHPC')
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(chP),'_','HPCLoc','.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_','HPCLoc','_',num2str(chP),'.mat'];
        if exist(NameTemp1)>0 | exist(NameTemp2)>0
        else
            [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LocHPC),Data(LFPAll.PFCx),movingwin,params);
            save(NameTemp2,'C','phi','S12','confC','t','f')
            clear C phi S12 S1 S2 t f confC phist chan1 chan2
        end
        [TimeBin.HPCLoc_PFC,CorrVals.HPCLoc_PFC]=LFPCrossCorr(LocHPC,LFPAll.PFCx,FreezeEpoch,TimeLag);
        
        for b=1:length(AllOB)
            NameTemp1=['CohgramcDataL/Cohgram_',OBChanName{b},'_','HPCLoc','.mat'];
            NameTemp1=['CohgramcDataL/Cohgram_','HPCLoc','_',OBChanName{b},'.mat'];
            if exist(NameTemp1)==0
                [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LocHPC),Data(AllOB{b}),movingwin,params);
                save(NameTemp1,'C','phi','S12','confC','t','f')
                clear C phi S12 S1 S2 t f confC phist chan1 chan2
            end
            [TimeBin.HPCLoc_OB{b},CorrVals.HPCLoc_OB{b}]=LFPCrossCorr(LocHPC,AllOB{b},FreezeEpoch,TimeLag);
        end
        
        
    end
    
    mkdir('LFPCorr')
    save('LFPCorr/AllHPC_PFCx_OB_Loc_NonLoc_Corr.mat','TimeBin','CorrVals')
    
end