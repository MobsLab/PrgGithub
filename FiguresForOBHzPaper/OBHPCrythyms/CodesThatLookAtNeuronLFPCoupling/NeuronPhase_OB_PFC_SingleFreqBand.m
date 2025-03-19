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
        load(['LFPData/LFP',num2str(chP),'.mat'])
        FilLFP=FilterLFP((LFP),FreqBand,1024);
        if plo,fig=figure('Position',[100 100 500 800]);end
        clear ph mu Kappa pval FR FFTAC
        for i=1:length(numNeurons)
            figure(2)
            try,
                [ph{i,1},mu{i,1}, Kappa{i,1}, pval{i,1},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,FreezeEpoch,30,0);
                
                FR{i,1}=length(Range(Restrict(S{numNeurons(i)},FreezeEpoch)))./sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
                if plo,
                    [H0,B] = CrossCorr(Range(Restrict(S{numNeurons(i)},FreezeEpoch)),Range(Restrict(S{numNeurons(i)},FreezeEpoch)),10,400); % 400 bins of 1ms and
                    H1=H0;
                    H0(ceil(length(H0)/2))=0;
                    [fftF,fftP1]=FFtAutoCorr(B,H1,0);
                    FFTAC{i,1}=fftF;
                    FFTAC{i,2}=fftP1;
                    
                    figure(fig);
                    subplot(311)
                    [Y,X]=hist(Data(ph{i,1}{1}),30);
                    bar([X,X+2*pi],[Y,Y]),xlim([0 4*pi])
                    title(num2str(pval{i,1}))
                    ylabel('Percentage of spikes');
                    xlabel('Phase (rad)');
                    title(['K : ' num2str(Kappa{i,1}) ', p = '  num2str(pval{i,1})])
                    
                    subplot(312)
                    plot(B/1000,H1,'linewidth',2),xlabel('ms'), hold on,xlim([-0.9 0.9])
                    try, ylim([0 max(H0)*2]), end
                    subplot(313)
                    plot(fftF,fftP1,'linewidth',2)
                    xlabel('Freq - Hz'), xlim([0 20])
                    ylabel('PowerAutocorr')
                    ylim([0 max(fftP1(20:end))*3])
                    if obx
                        saveas(fig,['/home/vador/Documents/AllNeurModulation/PFCxRef69Hz/',Dir.name{mm},'Neuron',num2str(i),'.png'])
                    else
                        saveas(fig,['/home/vador/Documents/AllNeurModulation/OBRef/',Dir.name{mm},'Neuron',num2str(i),'.png'])
                    end
                end
            end
            close(2);
            if plo,
                figure(fig)
                clf
            end
        end
        if obx
            save(['FreezingModulationPFCxRef',num2str(FreqBand(1)),num2str(FreqBand(2)),'Hz.mat'],'ph','mu','Kappa','pval','FR')
        else
            save(['FreezingModulationOBRef',num2str(FreqBand(1)),num2str(FreqBand(2)),'Hz.mat'],'ph','mu','Kappa','pval','FR')
        end
        clear ph mu Kappa pval FR FFTAC S numNeurons
    end
    close all
end

