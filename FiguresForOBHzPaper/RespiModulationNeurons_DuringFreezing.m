% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
numNeurons=[];
n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];

for mm=4:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    %% get the n° of the neurons of PFCx
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    if exist('SpikeData.mat')>0
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        load('BreathingInfo.mat')
         FreezeEpoch=FreezeEpoch-BreathNoiseEpoch;
        
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('ChannelsToAnalyse/Respi.mat'); chP=channel;
        
        
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
        
        
        clear LFP
        load(['LFPData/LFP',num2str(chP),'.mat'])
        FilLFP=FilterLFP((LFP),[3 6],1024);
        clear ph mu Kappa pval FR FFTAC
        
        for i=1:length(numNeurons)
            try,
                [ph{i,1},mu{i,1}, Kappa{i,1}, pval{i,1},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,FreezeEpoch,30,0);
                
                FR{i,1}=length(Range(Restrict(S{numNeurons(i)},FreezeEpoch)))./sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
               
            end
        end
        
        save FreezingModulationRespiRef.mat ph mu Kappa pval FR
        clear ph mu Kappa pval FR FFTAC S numNeurons
    end
    close all
end

