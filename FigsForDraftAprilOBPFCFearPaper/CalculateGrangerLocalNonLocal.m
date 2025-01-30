% Calculate spectra,coherence and Granger
clear all
% Get data

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

[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly')
for mm=KeepFirstSessionOnly
    disp(Dir.path{(mm)})
    cd(Dir.path{(mm)})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    
    % Get HPC activity
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.HPCLoc=LFP;
    ChanAll.HPCLoc=HPCChannels;
    
    ChanAll.HPC1=HPCChannels(1);
    clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
    LFPAll.HPC1=LFP;
    
    ChanAll.HPC2=HPCChannels(2);
    clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC2),'.mat']);
    LFPAll.HPC2=LFP;
    
    % Get PFC activity
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
    LFPAll.PFC=LFP;
    ChanAll.PFC=chP;
    
    % Get OB activity
    load('ChannelsToAnalyse/Bulb_deep.mat')
    clear LFP, load(['LFPData/LFP',num2str(channel),'.mat']);
    LFPAll.OB1=LFP;
    ChanAll.OB1=channel;
    
    % Make sure noise Epochs exist
    if exist('StateEpochSB.mat')==0
        disp('Calculating noise')
        FindNoiseEpoch([Dir.path{mm} filesep],chH,1)
    end
    clear TotalNoiseEpoch
    load('StateEpochSB.mat')
    close all
    
    clear Epoch
    Epoch{1}=dropShortIntervals(FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    Epoch{2}=dropShortIntervals(intervalSet(0,tpsmax)-FreezeEpoch,3*1e4)-TotalNoiseEpoch;
    EpNames{1}='Fz';EpNames{2}='NoFz';
    AllCombi={'HPC1','HPC1','HPC2','HPC2','HPCLoc','HPCLoc';'OB1','PFC','OB1','PFC','OB1','PFC'}
    % Check all Granger
    for ep=1:2
        for t=1:size(AllCombi,2)
            NameTemp1=['GrangerData/Granger_',EpNames{ep},'_',num2str(AllCombi{1,t}),'_',num2str(AllCombi{2,t}),'.mat'];
            if not(isempty(Start(Epoch{ep})))
                ('calculating granger causality')
                [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFPAll.(AllCombi{1,t}),LFPAll.(AllCombi{2,t}),Epoch{ep},order,paramsGranger,movingwinGranger,0);
                mkdir('GrangerData')
                save(NameTemp1,'granger2', 'granger_F', 'granger_pvalue','Fx2y','Fy2x','freqBin')
                clear  granger_F granger_pvalue Fx2y Fy2x freqBin
            end
        end
    end
end


