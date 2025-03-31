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
else
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);  
end
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
KeepFirstSessionOnly=[[1:8],[1,3,4,6,8:18]+8];
n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    %% get the n° of the neurons of PFCx
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    if exist('SpikeData.mat')>0 & exist('SpikeFieldCoherencePFCRef.mat')==0
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
        
        
        clear LFP
        load(['LFPData/LFP',num2str(chP),'.mat'])        
        for i=1:length(numNeurons)
            [C,phi,S12,S1,S2,t,f{i},zerosp,confC,phistd]=cohgramcpt(Data(LFP),Range(S{numNeurons(i)},'s'),movingwin,params);
            Ctsd{i}=tsd(t*1e4,C);
        end
        save('SpikeFieldCoherencePFCRef.mat','Ctsd','f','-v7.3')
        clear Ctsd f
    end
end