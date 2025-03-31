% Calculate spectra,coherence and Granger
clear all
obx=0;
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
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];

for mm=1:length(Dir.path)
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
        fig=figure('Position',[100 100 500 800]);
        clear ph mu Kappa pval FR FFTAC
        
        Sptimes=[];
        for i=1:length(numNeurons)
            Sptimes=[Sptimes;Range(Restrict(S{numNeurons(i)},FreezeEpoch))];
        end
        Sptimes=sort(Sptimes);
        [H0,B] = CrossCorr(Sptimes,Sptimes,10,400); % 400 bins of 1ms and
        H1=H0;
        H0(ceil(length(H0)/2))=0;
        plot(B/1000,H1,'linewidth',2),xlabel('ms'), hold on,xlim([-0.9 0.9])
        try, ylim([min(H1)*0.9 max(H0)*1.1]), end
        saveas(fig,['/home/vador/Documents/AllNeurModulation/AvCrossCorr/M',Dir.name{mm},'.png'])
        close all
    end
    clear ph mu Kappa pval FR FFTAC S numNeurons
end


