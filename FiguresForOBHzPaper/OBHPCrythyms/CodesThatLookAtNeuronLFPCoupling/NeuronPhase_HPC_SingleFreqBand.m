% Calculate spectra,coherence and Granger
clear all
obx=1;
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
FilterFreq=[3 6];
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('FreezingModulationHPCRef.mat')>0
        movefile('FreezingModulationHPCRef.mat','FreezingModulationHPCRef69Hz.mat');
    end
    
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    %% get the n° of the neurons of PFCx
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    if exist('SpikeData.mat')>0
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('H_Low_Spectrum.mat','ch'); chP=ch;
        
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
        FilLFP=FilterLFP((LFP),FilterFreq,1024);
        clear ph mu Kappa pval FR FFTAC
        for i=1:length(numNeurons)
            try,
                [ph{i,1},mu{i,1}, Kappa{i,1}, pval{i,1},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,FreezeEpoch,30,0);close all
                
                FR{i,1}=length(Range(Restrict(S{numNeurons(i)},FreezeEpoch)))./sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
            end
        end
        save(['FreezingModulationHPCRef',num2str(FilterFreq(1)),num2str(FilterFreq(2)),'.mat'],'ph','mu','Kappa','pval','FR')
        clear ph mu Kappa pval FR FFTAC S numNeurons
    end
    close all
end
