% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=1;
% Get data
OBXEphys=[230,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
num=1;
SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig2/';
for mm=1:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('FreezingModulationPFCxRef.mat')>0
        load('SpikeClassification.mat')
        load('SpikeData.mat')
        load('MeanWaveform.mat')
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
        load('FreezingModulationPFCxRef.mat')
        KappaP=Kappa;
        for i=1:size(Kappa,1)
            if not(isempty(FR{i,1}))
            SpikeInfo.FR(num)=FR{i,1};
            SpikeInfo.pval(num)=pval{i,1};
            SpikeInfo.Kappa(num)=Kappa{i,1};
            [Y,X]=hist(Data(ph{i,1}{1}),30);
            SpikeInfo.Mod(num,:)=Y;
            SpikeInfo.PowerAutoCorr(num,:)=FFTAC{i,2};
            SpikeInfo.ID(num,:)=WfId(i);
            SpikeInfo.Params(num,:)=Params{numNeurons(i)};
            [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(ph{i}{1}));
            SpikeInfo.Z(num)=length(Data(ph{i}{1})) * Rmean^2;
            SpikeInfo.KappaP(num)=KappaP{i,1};;
            num=num+1;
            end
        end
    end
end

figure
subplot(121)
imagesc(log(SpikeInfo.PowerAutoCorr))
subplot(233)
g=shadedErrorBar(FFTAC{i,1},mean(log(SpikeInfo.PowerAutoCorr)),[stdError(log(SpikeInfo.PowerAutoCorr));stdError(log(SpikeInfo.PowerAutoCorr))])
