% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
% close all
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
    if exist('FreezingModulationOBRef.mat')>0
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
        try
            SpikeInfoHPC=load('FreezingModulationHPCRef69Hz.mat');
            SpikeInfoOB=load('FreezingModulationOBRef36Hz.mat');
            
            for i=1:size(SpikeInfoHPC.Kappa,1)
                if not(isempty(SpikeInfoHPC.FR{i,1}))
                    SpikeInfo.FR(num)=SpikeInfoHPC.FR{i,1};
                    SpikeInfo.HPC.pval(num)=SpikeInfoHPC.pval{i,1};
                    SpikeInfo.HPC.Kappa(num)=SpikeInfoHPC.Kappa{i,1};
                    SpikeInfo.HPC.Mu(num)=SpikeInfoHPC.mu{i,1};
                    [Y,X]=hist(Data(SpikeInfoHPC.ph{i,1}{1}),30);
                    SpikeInfo.HPC.Mod(num,:)=Y;
                    [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(SpikeInfoHPC.ph{i}{1}));
                    SpikeInfo.HPC.Z(num)=length(Data(SpikeInfoHPC.ph{i}{1})) * Rmean^2;
                    
                    SpikeInfo.OB.pval(num)=SpikeInfoOB.pval{i,1};
                    SpikeInfo.OB.Kappa(num)=SpikeInfoOB.Kappa{i,1};
                    [Y,X]=hist(Data(SpikeInfoOB.ph{i,1}{1}),30);
                    SpikeInfo.OB.Mod(num,:)=Y;
                    SpikeInfo.OB.Mu(num)=SpikeInfoOB.mu{i,1};
                    [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(SpikeInfoOB.ph{i}{1}));
                    SpikeInfo.OB.Z(num)=length(Data(SpikeInfoOB.ph{i}{1})) * Rmean^2;
                    
                    num=num+1;
                end
            end
        end
    end
end

figure
alpha=0.05;
subplot(121)
JustOB=sum(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval>alpha)./length(SpikeInfo.HPC.pval);
JustHPC=sum(SpikeInfo.OB.pval>alpha & SpikeInfo.HPC.pval<alpha)./length(SpikeInfo.HPC.pval);
Both=sum(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval<alpha)./length(SpikeInfo.HPC.pval);
None=sum(SpikeInfo.OB.pval>alpha & SpikeInfo.HPC.pval>alpha)./length(SpikeInfo.HPC.pval);
pie([JustOB,JustHPC,Both,None],{'JustOB','JustHPC','Both','Neither'}), colormap hot
subplot(122)
AllOBKappa=[SpikeInfo.OB.Kappa];
AllHPCKappa=[SpikeInfo.HPC.Kappa];
[Y,X]=hist(AllOBKappa(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval<alpha)-AllHPCKappa(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval<alpha));
bar(X,Y,'Facecolor',[1 0.8 0.2]), hold on
line([0 0],ylim,'color','k','linewidth',3)
xlim([-0.5 0.5]), box off
text(0.2,6,'OB pref')
text(-0.4,6,'HPC pref')


figure
AllOBPhase=[SpikeInfo.OB.Mu];
AllHPCPhase=[SpikeInfo.HPC.Mu];
subplot(311)
[Y,X]=hist(AllOBPhase(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval>alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'k','linewidth',3)
xlim([0 4*pi])
subplot(312)
[Y,X]=hist(AllHPCPhase(SpikeInfo.OB.pval>alpha & SpikeInfo.HPC.pval<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'r','linewidth',3)
xlim([0 4*pi])
subplot(313)
[Y,X]=hist(AllHPCPhase(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'r','linewidth',3),hold on
[Y,X]=hist(AllOBPhase(SpikeInfo.OB.pval<alpha & SpikeInfo.HPC.pval<alpha),10);
stairs([X,X+2*pi],[Y/sum(Y),Y/sum(Y)],'k','linewidth',3),hold on
xlim([0 4*pi])