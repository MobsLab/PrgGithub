% Calculate spectra,coherence and Granger
clear all
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];

[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

for mm=1:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    % Check all spectra
    % Prefrontal cortex
    clear channel
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    if exist('P_LowSpectrum.mat')>0
        movefile('P_Low_Spectrum.mat','PFCx_Low_Spectrum.mat')
    end
    if exist('PFCx_Low_Spectrum.mat')==0
        disp('Calculating PFCx Spectrum')
        LowSpectrumSB([Dir.path{mm} filesep],channel,'PFCx',0)
    end
    
    % OB
    clear channel
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    if exist('B_Low_Spectrum.mat')==0
       disp('Calculating OB Spectrum')
       LowSpectrumSB([Dir.path{mm} filesep],channel,'B',0)
    end
    
    if exist('BLoc_Low_Spectrum.mat')==0 & exist('LFPData/LocalOBActivity.mat')>0
        disp('Calculating local OB Spectrum')
        load('LFPData/LocalOBActivity.mat')
        Spectro=LowSpectrumSBNoSaveCode(LFP,0);
        ch=OBChannels;
        save(strcat('BLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
    end
    
    % HPC
    clear channel
    try,load('ChannelsToAnalyse/dHPC_rip.mat')
        if isempty(channel)
            load('ChannelsToAnalyse/dHPC_deep.mat')
        end
    catch,load('ChannelsToAnalyse/dHPC_deep.mat')
    end
    chH=channel;
    if exist('H_Low_Spectrum.mat')==0
        disp('Calculating HPC Spectrum')
        LowSpectrumSB([Dir.path{mm} filesep],channel,'H',0)
    end
    if exist('HLoc_Low_Spectrum.mat')==0 & exist('LFPData/LocalHPCActivity.mat')>0
        disp('Calculating local HPC Spectrum')
        load('LFPData/LocalHPCActivity.mat')
        Spectro=LowSpectrumSBNoSaveCode(LFP,0);
        ch=HPCChannels;
        save(strcat('HLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
    end
    
    
    % Make sure noise Epochs exist
    if exist('StateEpochSB.mat')==0
        disp('Calculating noise')
        FindNoiseEpoch([Dir.path{mm} filesep],chH,1)
    end
    clear TotalNoiseEpoch
    load('StateEpochSB.mat')
    close all
    
    
    % Check all coherence
    mkdir('CohgramcDataL')
    AllCombi=combnk([chH,chB,chP],2);
    for t=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,1)),'_',num2str(AllCombi(t,2)),'.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,2)),'_',num2str(AllCombi(t,1)),'.mat'];
        if not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
            load(['LFPData/LFP',num2str(AllCombi(t,1)),'.mat']);LFP1=LFP;
            load(['LFPData/LFP',num2str(AllCombi(t,2)),'.mat']);LFP2=LFP;
            disp('calculating coherence')
            [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
            save(NameTemp1,'C','phi','S12','confC','t','f')
            clear LFP1 LFP LFP C phi S12 S1 S2 t f confC phist
        end
    end
    
    clear Epoch
    Epoch{1}=dropShortIntervals(FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    Epoch{2}=dropShortIntervals(intervalSet(0,tpsmax)-FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    EpNames{1}='Fz';EpNames{2}='NoFz';
    % Check all Granger
    for ep=1:2
        for t=1:size(AllCombi,1)
            NameTemp1=['GrangerData/Granger_',EpNames{ep},'_',num2str(AllCombi(t,1)),'_',num2str(AllCombi(t,2)),'.mat'];
            NameTemp2=['GrangerData/Cohgram_',EpNames{ep},'_',num2str(AllCombi(t,2)),'_',num2str(AllCombi(t,1)),'.mat'];
            if not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
                if not(isempty(Start(Epoch{ep})))
                    load(['LFPData/LFP',num2str(AllCombi(t,1)),'.mat']);LFP1=LFP;
                    load(['LFPData/LFP',num2str(AllCombi(t,2)),'.mat']);LFP2=LFP;
                    ('calculating granger causality')
                    [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,Epoch{ep},order,paramsGranger,movingwinGranger,0);
                    mkdir('GrangerData')
                    save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
                    clear LFP1 LFP LFP granger_F granger_pvalue Fx2y Fy2x freqBin
                else
                    mkdir('GrangerData')
                    granger2=[];granger_F=[];granger_pvalue=[];Fx2y=[];Fy2x=[];freqBin=[];
                    save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
                end
            end
        end
    end
end



Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');


for mm=5:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    % Check all spectra
    % Prefrontal cortex
    clear channel
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    if exist('P_LowSpectrum.mat')>0
        movefile('P_Low_Spectrum.mat','PFCx_Low_Spectrum.mat')
    end
    if exist('PFCx_Low_Spectrum.mat')==0
        LowSpectrumSB([Dir.path{mm} filesep],channel,'PFCx',0)
    end
    
    
    % HPC
    clear channel
    try,load('ChannelsToAnalyse/dHPC_rip.mat')
        if isempty(channel)
            load('ChannelsToAnalyse/dHPC_deep.mat')
        end
    catch,load('ChannelsToAnalyse/dHPC_deep.mat')
    end
    chH=channel;
    if exist('H_Low_Spectrum.mat')==0
        LowSpectrumSB([Dir.path{mm} filesep],channel,'H',0)
    end
    
    % Make sure noise Epochs exist
    if exist('StateEpochSB.mat')==0
        FindNoiseEpoch([Dir.path{mm} filesep],chH,1)
    end
    clear TotalNoiseEpoch
    load('StateEpochSB.mat')
    close all
    
    
    % Check all coherence
    mkdir('CohgramcDataL')
    AllCombi=combnk([chH,chP],2);
    for t=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,1)),'_',num2str(AllCombi(t,2)),'.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,2)),'_',num2str(AllCombi(t,1)),'.mat'];
        if not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
            load(['LFPData/LFP',num2str(AllCombi(t,1)),'.mat']);LFP1=LFP;
            load(['LFPData/LFP',num2str(AllCombi(t,2)),'.mat']);LFP2=LFP;
            disp('calculating coherence')
            [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
            save(NameTemp1,'C','phi','S12','confC','t','f')
            clear LFP1 LFP LFP C phi S12 S1 S2 t f confC phist
        end
    end
    
    clear Epoch
    Epoch{1}=dropShortIntervals(FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    Epoch{2}=dropShortIntervals(intervalSet(0,tpsmax)-FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    EpNames{1}='Fz';EpNames{2}='NoFz';
    % Check all Granger
    for ep=1:2
        for t=1:size(AllCombi,1)
            NameTemp1=['GrangerData/Granger_',EpNames{ep},'_',num2str(AllCombi(t,1)),'_',num2str(AllCombi(t,2)),'.mat'];
            NameTemp2=['GrangerData/Cohgram_',EpNames{ep},'_',num2str(AllCombi(t,2)),'_',num2str(AllCombi(t,1)),'.mat'];
            if not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
                if not(isempty(Start(Epoch{ep})))
                    load(['LFPData/LFP',num2str(AllCombi(t,1)),'.mat']);LFP1=LFP;
                    load(['LFPData/LFP',num2str(AllCombi(t,2)),'.mat']);LFP2=LFP;
                    ('calculating granger causality')
                    [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,Epoch{ep},order,paramsGranger,movingwinGranger,0);
                    mkdir('GrangerData')
                    save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
                    clear LFP1 LFP LFP granger_F granger_pvalue Fx2y Fy2x freqBin
                else
                    mkdir('GrangerData')
                    granger2=[];granger_F=[];granger_pvalue=[];Fx2y=[];Fy2x=[];freqBin=[];
                    save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
                end
            end
        end
    end
end










