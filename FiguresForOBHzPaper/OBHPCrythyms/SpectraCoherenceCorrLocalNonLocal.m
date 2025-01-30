% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[254,253,258,299,395,403,451,248,244,243,402,230,249,250,291,297,298];
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
    load('behavResources.mat')
    if exist('LFPData/LocalHPCActivity.mat')>0
        clear LFP, load('LFPData/LocalHPCActivity.mat')
        LFPAll.HPCLoc=LFP;
        ChanAll.HPCLoc=HPCChannels;
        
        ChanAll.HPC1=HPCChannels(1);
        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
        LFPAll.HPC1=LFP;
        
        ChanAll.HPC2=HPCChannels(2);
        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC2),'.mat']);
        LFPAll.HPC2=LFP;

    else
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            chH=channel;
        catch
            load('ChannelsToAnalyse/dHPC_rip.mat')
            chH=channel;
        end
        ChanAll.HPC1=chH;
        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
        LFPAll.HPC1=LFP;
    end
    
    % Get OB LFP
    if exist('LFPData/LocalOBActivity.mat')>0
        clear LFP, load('LFPData/LocalOBActivity.mat')
        LFPAll.OBLoc=LFP;
        ChanAll.OBLoc=OBChannels;
        
        ChanAll.OB1=OBChannels(1);
        clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB1),'.mat']);
        LFPAll.OB1=LFP;
        
        ChanAll.OB2=OBChannels(2);
        clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB2),'.mat']);
        LFPAll.OB2=LFP;
        
    else
       load('ChannelsToAnalyse/Bulb_deep.mat')
       clear LFP, load(['LFPData/LFP',num2str(channel),'.mat']);
        LFPAll.OB1=LFP;
        ChanAll.OB1=channel;
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
    
    if isfield(ChanAll,'HPCLoc')
%         % HPC1
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.PFCx),movingwin,params);
%         chan1=ChanAll.HPC1;
%         chan2=ChanAll.PFCx;
%         save(['CohgramcDataL/Cohgram_PFC_HPC1.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.HPC1,CorrVals.HPC1]=LFPCrossCorr(LFPAll.HPC1,LFPAll.PFCx,FreezeEpoch,TimeLag);
%         
%         % HPC2
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.PFCx),movingwin,params);
%         chan1=ChanAll.HPC2;
%         chan2=ChanAll.PFCx;
%         save(['CohgramcDataL/Cohgram_PFC_HPC2.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.HPC2,CorrVals.HPC2]=LFPCrossCorr(LFPAll.HPC2,LFPAll.PFCx,FreezeEpoch,TimeLag);
% 
%         % LocHPC
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.PFCx),movingwin,params);
%         chan1=ChanAll.HPCLoc;
%         chan2=ChanAll.PFCx;
%         save(['CohgramcDataL/Cohgram_PFC_HPCLoc.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.HPCLoc,CorrVals.HPCLoc]=LFPCrossCorr(LFPAll.HPCLoc,LFPAll.PFCx,FreezeEpoch,TimeLag);


        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPC1;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_OB1_HPC1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2

        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPC2;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_OB1_HPC2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2

        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPCLoc;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_OB1_HPCLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2

%         mkdir('LFPCorr')
%         save('LFPCorr/HPC_PFCx_Loc_NonLoc_Corr.mat','TimeBin','CorrVals')
%         clear TimeBin CorrVals

    end
    
    
    if isfield(ChanAll,'OBLoc')
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OB1),Data(LFPAll.PFCx),movingwin,params);
        chan1=ChanAll.OB1;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_PFC_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.OB1,CorrVals.OB1]=LFPCrossCorr(LFPAll.OB1,LFPAll.PFCx,FreezeEpoch,TimeLag);
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OB2),Data(LFPAll.PFCx),movingwin,params);
        chan1=ChanAll.OB2;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_PFC_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.OB2,CorrVals.OB2]=LFPCrossCorr(LFPAll.OB2,LFPAll.PFCx,FreezeEpoch,TimeLag);
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OBLoc),Data(LFPAll.PFCx),movingwin,params);
        chan1=ChanAll.OBLoc;
        chan2=ChanAll.PFCx;
        save(['CohgramcDataL/Cohgram_PFC_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         [TimeBin.OBLoc,CorrVals.OBLoc]=LFPCrossCorr(LFPAll.OBLoc,LFPAll.PFCx,FreezeEpoch,TimeLag);
         
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OB1),Data(LFPAll.HPC1),movingwin,params);
        chan1=ChanAll.OB1;
        chan2=ChanAll.HPC1;
        save(['CohgramcDataL/Cohgram_HPC1_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OB2),Data(LFPAll.HPC1),movingwin,params);
        chan1=ChanAll.OB2;
        chan2=ChanAll.HPC1;
        save(['CohgramcDataL/Cohgram_HPC1_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.OBLoc),Data(LFPAll.HPC1),movingwin,params);
        chan1=ChanAll.OBLoc;
        chan2=ChanAll.HPC1;
        save(['CohgramcDataL/Cohgram_HPC1_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2

%         mkdir('LFPCorr')
%         save('LFPCorr/OB_PFCx_Loc_NonLoc_Corr.mat','TimeBin','CorrVals')
%         clear TimeBin CorrVals
    end
    
    
    
    clear ChanAll LFPAll
    
end