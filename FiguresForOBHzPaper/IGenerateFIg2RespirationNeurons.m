% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath([dropbox '/Kteam/PrgMatlab/Fra/UtilsStats'])
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
numNeurons=[];
num=1;
SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig2/';
for mm=4:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    load('SpikeData.mat')
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
    DataRespi=load('FreezingModulationRespiRef.mat');
    DataOB=load('FreezingModulationOBRef.mat');
    for i=1:size(DataOB.Kappa,1)
        if not(isempty(DataOB.FR{i,1}))
            SpikeInfo.FR(num)=DataOB.FR{i,1};
            SpikeInfo.OBpval(num)=DataOB.pval{i,1};
            SpikeInfo.OBKappa(num)=DataOB.Kappa{i,1};
            [Y,X]=hist(Data(DataOB.ph{i,1}{1}),30);
            SpikeInfo.OBMod(num,:)=Y;
            [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(DataOB.ph{i}{1}));
            SpikeInfo.OBZ(num)=length(Data(DataOB.ph{i}{1})) * Rmean^2;

            SpikeInfo.Respipval(num)=DataRespi.pval{i,1};
            SpikeInfo.RespiKappa(num)=DataRespi.Kappa{i,1};
            [Y,X]=hist(Data(DataRespi.ph{i,1}{1}),30);
            SpikeInfo.RespiMod(num,:)=Y;
            [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(DataRespi.ph{i}{1}));
            SpikeInfo.RespiZ(num)=length(Data(DataRespi.ph{i}{1})) * Rmean^2;

            num=num+1;
        end
    end
end

k=5;
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure;
subplot(211)
bar([X,X+2*pi],[SpikeInfo.RespiMod(k,:),SpikeInfo.RespiMod(k,:)]/sum(SpikeInfo.RespiMod(k,:)),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
plot([phax,phax+2*pi],[Yax*0.01+0.04,Yax*0.01+0.04],'color','r','linewidth',2)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off
subplot(212)
bar([X,X+2*pi],[SpikeInfo.OBMod(k,:),SpikeInfo.OBMod(k,:)]/sum(SpikeInfo.OBMod(k,:)),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
plot([phax,phax+2*pi],[Yax*0.01+0.04,Yax*0.01+0.04],'color','r','linewidth',2)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off
saveas(fig,[SaveFolder 'ExampleRespiOBNeuron.fig'])


fig=figure;
plot(SpikeInfo.RespiKappa(or(SpikeInfo.Respipval<0.05, SpikeInfo.OBpval<0.05)),SpikeInfo.OBKappa(or(SpikeInfo.Respipval<0.05, SpikeInfo.OBpval<0.05)),'.','MarkerSize',10)
hold on
line([0 1],[0 1])
xlabel('Kappa-Resp mod'),ylabel('Kappa-OB mod')
set(gca,'FontSize',10,'YTick',[0:0.2:1],'XTick',[0:0.2:1])
box off
saveas(fig,[SaveFolder 'KappaOBRespi.fig'])
close all;


