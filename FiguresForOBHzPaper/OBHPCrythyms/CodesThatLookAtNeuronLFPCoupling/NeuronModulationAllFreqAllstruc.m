
% Calculate spectra,coherence and Granger
clear all
obx=0;
FreqBand=[3 6];
plo=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
if obx
    Dir=RestrictPathForExperiment(Dir,'nMice',[OBXEphys,CtrlEphys]);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
    KeepFirstSessionOnly=[[1,2,4,6:8],[1,3,4,6,8:18]+8];
else
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
    KeepFirstSessionOnly=[[1,3,4,6,8:18]];
end
numNeurons=[];

n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];
FreqRange=[1:0.25:12;[3:0.25:14]];
nbin=30;
for mm=1:length(KeepFirstSessionOnly)
    try
    mm
    cd(Dir.path{KeepFirstSessionOnly(mm)})
    if exist('SpikeData.mat')>0
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        if obx,load('PFCx_Low_Spectrum.mat','ch'); chP=ch;
        else,load('B_Low_Spectrum.mat','ch'); chP=ch;end
        
        for cc=1:length(chans)
            for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                    numtt=[numtt,tt];
                end
            end
        end
        
        numNeurons=[]; % neurones du PFCx
        for i=1:length(S);
            if ismember(TT{i}(1),numtt)
                numNeurons=[numNeurons,i];
            end
        end
        
        numMUA=[];
        for k=1:length(numNeurons)
            j=numNeurons(k);
            if TT{j}(2)==1
                numMUA=[numMUA, k];
            end
        end
        numNeurons(numMUA)=[];
        
        
        load('behavResources.mat')
        load('StateEpochSB.mat','TotalNoiseEpoch')
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        
        % Get HPC LFP
        if exist('LFPData/LocalHPCActivity.mat')>0
            load('LFPData/InfoLFP.mat')
            clear LFP, load('LFPData/LocalHPCActivity.mat')
            LFPAll.LocHPC=LFP;
            chH1=HPCChannels(1);
            clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
            LFPtemp1=LFP;stdLFP1=std(Data(Restrict(LFP,FreezeEpoch)));
            chH2=HPCChannels(2);
            clear LFP, load(['LFPData/LFP',num2str(chH2),'.mat']);
            LFPtemp2=LFP;stdLFP2=std(Data(Restrict(LFP,FreezeEpoch)));
            if stdLFP1>stdLFP2
                LFPAll.HPC1=LFPtemp1;
                
            else
                LFPAll.HPC1=LFPtemp2;
            end
        else
            LFPAll.LocHPC=[];
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
        end
        
        % Get OB LFP
        if exist('LFPData/LocalOBActivity.mat')>0
            load('LFPData/InfoLFP.mat')
            clear LFP, load('LFPData/LocalOBActivity.mat')
            LFPAll.LocOB=LFP;
            chB1=OBChannels(1);
            clear LFP, load(['LFPData/LFP',num2str(chB1),'.mat']);
            LFPtemp1=LFP;stdLFP1=std(Data(Restrict(LFP,FreezeEpoch)));
            chB2=OBChannels(2);
            clear LFP, load(['LFPData/LFP',num2str(chB2),'.mat']);
            LFPtemp2=LFP;stdLFP2=std(Data(Restrict(LFP,FreezeEpoch)));
               if stdLFP1>stdLFP2
                LFPAll.OB1=LFPtemp1;
                
            else
                LFPAll.OB1=LFPtemp2;
               end
        else
            LFPAll.LocOB=[];
            load('ChannelsToAnalyse/Bulb_deep.mat')
            chB1=channel;
            clear LFP, load(['LFPData/LFP',num2str(chB1),'.mat']);
            LFPAll.OB1=LFP;
        end
        
        
        % Get PFcx LFP
        clear y LFP
        load('ChannelsToAnalyse/PFCx_deep.mat')
        chP=channel;
        clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
        LFPAll.PFCx=LFP;
        AllFields=fieldnames(LFPAll);
        for field=1:length(AllFields)
            LFPTemp=eval(['LFPAll.',AllFields{field}]);
            if not(isempty(LFPTemp))
                disp(AllFields{field})
                for f=1:length(FreqRange)
                    fil=FilterLFP(LFPTemp,FreqRange(:,f),1024);
                    for i=1:length(numNeurons)
                        [ph.(AllFields{field}){i,f},mu.(AllFields{field}){i,f},Kappa.(AllFields{field}){i,f}, pval.(AllFields{field}){i,f}]=SpikeLFPModulationTransform(S{numNeurons(i)},fil,FreezeEpoch,nbin,0);
                    end
                end
            end
        end
        save('NeuronModFreqStructCorrected.mat','ph','mu','Kappa','pval')
        clear('ph','mu','Kappa','pval')
    end
    end
end
