% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly')
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc'};
TimeLag=1;
% Parameters for  spectro
MouseNum=1;
[params,movingwin,suffix]=SpectrumParametersML('low');
% Parameters for Granger
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];



for mm=1:length(KeepFirstSessionOnly)
    mm
    cd(Dir.path{KeepFirstSessionOnly(mm)})
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.HPCLoc=LFP;
    ChanAll.HPCLoc=HPCChannels;
    
    ChanAll.HPC1=HPCChannels(1);
    clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
    LFPAll.HPC1=LFP;
    
    ChanAll.HPC2=HPCChannels(2);
    clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC2),'.mat']);
    LFPAll.HPC2=LFP;
    
    
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
    
    % Get PFC LFP
    clear y LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFC=LFP;
    ChanAll.PFC=chP;
    
    % coherence
    disp('calculating coherence')
    
    if isfield(ChanAll,'OBLoc')
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.OB1),movingwin,params);
%         chan1=ChanAll.PFC;
%         chan2=ChanAll.OB1;
%         save(['CohgramcDataL/Cohgram_PFC_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         % [TimeBin.OB1,CorrVals.OB1]=LFPCrossCorr(LFPAll.OB1,LFPAll.PFC,FreezeEpoch,TimeLag);
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.OB2),movingwin,params);
%         chan1=ChanAll.PFC;
%         chan2=ChanAll.OB2;
%         save(['CohgramcDataL/Cohgram_PFC_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         % [TimeBin.OB2,CorrVals.OB2]=LFPCrossCorr(LFPAll.OB2,LFPAll.PFC,FreezeEpoch,TimeLag);
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.OBLoc),movingwin,params);
%         chan1=ChanAll.PFC;
%         chan2=ChanAll.OBLoc;
%         save(['CohgramcDataL/Cohgram_PFC_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         % [TimeBin.OBLoc,CorrVals.OBLoc]=LFPCrossCorr(LFPAll.OBLoc,LFPAll.PFC,FreezeEpoch,TimeLag);
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.OB1),movingwin,params);
%         chan1=ChanAll.HPC1;
%         chan2=ChanAll.OB1;
%         save(['CohgramcDataL/Cohgram_HPC1_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.OB2),movingwin,params);
%         chan1=ChanAll.HPC1;
%         chan2=ChanAll.OB2;
%         save(['CohgramcDataL/Cohgram_HPC1_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.OBLoc),movingwin,params);
%         chan1=ChanAll.HPC1;
%         chan2=ChanAll.OBLoc;
%         save(['CohgramcDataL/Cohgram_HPC1_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.OB1),movingwin,params);
%         chan1=ChanAll.HPC2;
%         chan2=ChanAll.OB1;
%         save(['CohgramcDataL/Cohgram_HPC2_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.OB2),movingwin,params);
%         chan1=ChanAll.HPC2;
%         chan2=ChanAll.OB2;
%         save(['CohgramcDataL/Cohgram_HPC2_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.OBLoc),movingwin,params);
%         chan1=ChanAll.HPC2;
%         chan2=ChanAll.OBLoc;
%         save(['CohgramcDataL/Cohgram_HPC2_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.OB1),movingwin,params);
%         chan1=ChanAll.HPCLoc;
%         chan2=ChanAll.OB1;
%         save(['CohgramcDataL/Cohgram_HPCLoc_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.OB2),movingwin,params);
%         chan1=ChanAll.HPCLoc;
%         chan2=ChanAll.OB2;
%         save(['CohgramcDataL/Cohgram_HPCLoc_OB2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.OBLoc),movingwin,params);
%         chan1=ChanAll.HPCLoc;
%         chan2=ChanAll.OBLoc;
%         save(['CohgramcDataL/Cohgram_HPCLoc_OBLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
%         clear C phi S12 S1 S2 t f confC phist chan1 chan2
%         
%         %         mkdir('LFPCorr')
%         %         save('LFPCorr/OB_PFC_Loc_NonLoc_Corr.mat','TimeBin','CorrVals')
%         %         clear TimeBin CorrVals
        
    else
        % HPC1
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.HPC1),movingwin,params);
        chan1=ChanAll.PFC;
        chan2=ChanAll.HPC1;
        save(['CohgramcDataL/Cohgram_PFC_HPC1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        % [TimeBin.HPC1,CorrVals.HPC1]=LFPCrossCorr(LFPAll.HPC1,LFPAll.PFC,FreezeEpoch,TimeLag);
        
        % HPC2
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.HPC2),movingwin,params);
        chan1=ChanAll.PFC;
        chan2=ChanAll.HPC2;
        save(['CohgramcDataL/Cohgram_PFC_HPC2.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        %  [TimeBin.HPC2,CorrVals.HPC2]=LFPCrossCorr(LFPAll.HPC2,LFPAll.PFC,FreezeEpoch,TimeLag);
        
        % LocHPC
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.PFC),Data(LFPAll.HPCLoc),movingwin,params);
        chan1=ChanAll.PFC;
        chan2=ChanAll.HPCLoc;
        save(['CohgramcDataL/Cohgram_PFC_HPCLoc.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        % [TimeBin.HPCLoc,CorrVals.HPCLoc]=LFPCrossCorr(LFPAll.HPCLoc,LFPAll.PFC,FreezeEpoch,TimeLag);
        
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC1),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPC1;
        chan2=ChanAll.OB1;
        save(['CohgramcDataL/Cohgram_HPC1_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPC2),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPC2;
        chan2=ChanAll.OB1;
        save(['CohgramcDataL/Cohgram_HPC2_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.HPCLoc),Data(LFPAll.OB1),movingwin,params);
        chan1=ChanAll.HPCLoc;
        chan2=ChanAll.OB1;
        save(['CohgramcDataL/Cohgram_HPCLoc_OB1.mat'],'C','phi','S1','S2','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        %         mkdir('LFPCorr')
        %         save('LFPCorr/HPC_PFC_Loc_NonLoc_Corr.mat','TimeBin','CorrVals')
        %         clear TimeBin CorrVals
        
    end
    %% Granger
    
    % Make sure noise Epochs exist
    if exist('StateEpochSB.mat')==0
        disp('Calculating noise')
        FindNoiseEpoch([Dir.path{mm} filesep],chH,1)
    end
    clear TotalNoiseEpoch
    load('StateEpochSB.mat')
    close all
    
%     clear Epoch
%     Epoch{1}=dropShortIntervals(FreezeEpoch,3*1e4)-TotalNoiseEpoch;
%     Epoch{2}=dropShortIntervals(intervalSet(0,tpsmax)-FreezeEpoch,3*1e4)-TotalNoiseEpoch;
%     EpNames{1}='Fz';EpNames{2}='NoFz';
%     if isfield(ChanAll,'OBLoc')
%         AllCombi={'HPC1','HPC1','HPC1','HPC1','HPC2','HPC2','HPC2','HPC2','HPCLoc','HPCLoc','HPCLoc','HPCLoc';'OB1','OB2','OBLoc','PFC','OB1','OB2','OBLoc','PFC','OB1','OB2','OBLoc','PFC'}
%     else
%         AllCombi={'HPC1','HPC1','HPC2','HPC2','HPCLoc','HPCLoc';'OB1','PFC','OB1','PFC','OB1','PFC'}
%     end
    
%     % Check all Granger
%     for ep=1:2
%         for t=1:size(AllCombi,2)
%             NameTemp1=['GrangerData/Granger_',EpNames{ep},'_',num2str(AllCombi{1,t}),'_',num2str(AllCombi{2,t}),'.mat'];
%             if not(isempty(Start(Epoch{ep})))
%                 ('calculating granger causality')
%                 [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFPAll.(AllCombi{1,t}),LFPAll.(AllCombi{2,t}),Epoch{ep},order,paramsGranger,movingwinGranger,0);
%                 mkdir('GrangerData')
%                 save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
%                 clear  granger_F granger_pvalue Fx2y Fy2x freqBin
%             end
%         end
%     end
%     
    clear ChanAll LFPAll
    
end