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
        EpNames{1}='Fz';EpNames{2}='NoFz';

for mm=1:length(Dir.path)
    
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('LFPData/LocalOBActivity.mat')>0 | exist('LFPData/LocalHPCActivity.mat')>0
        clear chH chB chP
        load('behavResources.mat')
        tpsmax=max(Range(Movtsd));
        
        % Check all spectra
        % Prefrontal cortex
        clear channel
        load('ChannelsToAnalyse/PFCx_deep.mat')
        chP=channel;
        load(['LFPData/LFP',num2str(chP),'.mat']);
        AllCombiName{1}='PFCx';
        LFPAll{1}=LFP;
        
        if exist('LFPData/LocalOBActivity.mat')>0
            load('LFPData/LocalOBActivity.mat')
            AllCombiName{length(AllCombiName)+1}='OBLoc';
            LFPAll{length(LFPAll)+1}=LFP;
        end
        
        if exist('LFPData/LocalHPCActivity.mat')>0
            load('LFPData/LocalHPCActivity.mat')
            AllCombiName{length(AllCombiName)+1}='HPCLoc';
            LFPAll{length(LFPAll)+1}=LFP;
        end
        
        
        clear TotalNoiseEpoch
        load('StateEpochSB.mat')
        close all
        
        clear Epoch
        Epoch{1}=dropShortIntervals(FreezeEpoch,3*1e4)-TotalNoiseEpoch;
        Epoch{2}=dropShortIntervals(intervalSet(0,tpsmax)-FreezeEpoch,3*1e4)-TotalNoiseEpoch;
        AllCombi=combnk([1:length(AllCombiName)],2);
        % Check all Granger
        for ep=1:2
            for t=1:size(AllCombi,1)
                NameTemp1=['GrangerData/Granger_',EpNames{ep},'_',AllCombiName{AllCombi(t,1)},'_',AllCombiName{AllCombi(t,2)},'.mat'];
                NameTemp2=['GrangerData/Granger_',EpNames{ep},'_',AllCombiName{AllCombi(t,2)},'_',AllCombiName{AllCombi(t,1)},'.mat'];
                if 1%not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
                    if not(isempty(Start(Epoch{ep})))
                        LFP1=LFPAll{AllCombi(t,1)};
                        LFP2=LFPAll{AllCombi(t,2)};
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
    clear LFPAll  AllCombiName AllCombi
    
end


