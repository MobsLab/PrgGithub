% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
numNeurons=[];
num=1;

SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig2/';
for mm=1:length(Dir.path)-1
    Dir.path{mm}
    cd(Dir.path{mm})
    load('SpikeData.mat')
    if sum(size(S))>0
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        %     if obx,load('PFCx_Low_Spectrum.mat','ch'); chP=ch;
        %     else,load('B_Low_Spectrum.mat','ch'); chP=ch;end
        %
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
                [mu, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(DataOB.ph{i}{1}));
                SpikeInfo.OBZ(num)=length(Data(DataOB.ph{i}{1})) * Rmean^2;
                                SpikeInfo.OBmu(num)=mu;

                SpikeInfo.Respipval(num)=DataRespi.pval{i,1};
                SpikeInfo.RespiKappa(num)=DataRespi.Kappa{i,1};
                [Y,X]=hist(Data(DataRespi.ph{i,1}{1}),30);
                SpikeInfo.RespiMod(num,:)=Y;
                [mu, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(DataRespi.ph{i}{1}));
                SpikeInfo.RespiZ(num)=length(Data(DataRespi.ph{i}{1})) * Rmean^2;
                SpikeInfo.Respimu(num)=mu;

                num=num+1;
            end
        end
    end
end


% Example neuron for figure 1
k=5;
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure;
subplot(211)
bar([X,X+2*pi],[SpikeInfo.RespiMod(k,:),SpikeInfo.RespiMod(k,:)]/sum(SpikeInfo.RespiMod(k,:)),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on

dB = 2*pi/15;
B = [dB/2:dB:2*pi-dB/2];
t=SpikeInfo.Respimu(k);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,SpikeInfo.RespiKappa(k));
hold on
plot([B B+2*pi],max(SpikeInfo.RespiMod(k,:)/sum(SpikeInfo.RespiMod(k,:))).*[vm vm]/max(vm)+0.01,'r','lineWidth',3)

set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

subplot(212)
bar([X,X+2*pi],[SpikeInfo.OBMod(k,:),SpikeInfo.OBMod(k,:)]/sum(SpikeInfo.OBMod(k,:)),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on

dB = 2*pi/15;
B = [dB/2:dB:2*pi-dB/2];
t=SpikeInfo.OBmu(k);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,SpikeInfo.OBKappa(k));
hold on
plot([B B+2*pi],max(SpikeInfo.OBMod(k,:)/sum(SpikeInfo.OBMod(k,:))).*[vm vm]/max(vm)+0.01,'r','lineWidth',3)

set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off
saveas(fig,[SaveFolder 'ExampleRespiOBNeuron.fig'])

fig=figure;
plot(SpikeInfo.RespiKappa(SpikeInfo.OBpval<0.05 & SpikeInfo.Respipval>0.05),SpikeInfo.OBKappa(SpikeInfo.OBpval<0.05 & SpikeInfo.Respipval>0.05),'ko','MarkerSize',10,'MarkerFaceColor','k')
hold on
plot(SpikeInfo.RespiKappa(SpikeInfo.OBpval>0.05 & SpikeInfo.Respipval<0.05),SpikeInfo.OBKappa(SpikeInfo.OBpval>0.05 & SpikeInfo.Respipval<0.05),'k^','MarkerSize',10,'MarkerFaceColor','k')
plot(SpikeInfo.RespiKappa(SpikeInfo.OBpval<0.05 & SpikeInfo.Respipval<0.05),SpikeInfo.OBKappa(SpikeInfo.OBpval<0.05 & SpikeInfo.Respipval<0.05),'ksq','MarkerSize',10)
line([0 1.5],[0 1.5],'color','k')
xlim([0 1.2]),ylim([0 1.2])
xlabel('Kappa-PFCx mod'),ylabel('Kappa-OB mod')
set(gca,'FontSize',15,'YTick',[0:0.2:1.2],'XTick',[0:0.2:1.2])
box off
saveas(fig,[SaveFigFolder 'KappaRespivsOB.fig'])
close all;


fig=figure;
plot(SpikeInfo.RespiKappa(or(SpikeInfo.Respipval<0.05, SpikeInfo.OBpval<0.05)),SpikeInfo.OBKappa(or(SpikeInfo.Respipval<0.05, SpikeInfo.OBpval<0.05)),'.','MarkerSize',10)
hold on
line([0 1],[0 1])
xlabel('Kappa-Resp mod'),ylabel('Kappa-OB mod')
set(gca,'FontSize',10,'YTick',[0:0.2:1],'XTick',[0:0.2:1])
box off
saveas(fig,[SaveFolder 'KappaOBRespi.fig'])
close all;

Y=SpikeInfo.RespiKappa((SpikeInfo.Respipval<0.05 & SpikeInfo.OBpval<0.05))';
X=SpikeInfo.OBKappa((SpikeInfo.Respipval<0.05 & SpikeInfo.OBpval<0.05))';
[p,h,stats]=ModIndexPlot(X,Y)


%% Make barplot
figure
Y=SpikeInfo.RespiKappa((SpikeInfo.Respipval<0.05 & SpikeInfo.OBpval<0.05))';
X=SpikeInfo.OBKappa((SpikeInfo.Respipval<0.05 & SpikeInfo.OBpval<0.05))';
X = (X-Y)./(X+Y);
a=iosr.statistics.boxPlot(1,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',1,'spreadWidth',0.4), hold on;
set(handlesplot{1},'MarkerSize',15)

line([0 2],[0 0],'linestyle','--','linewidth',1,'color',[0.6 0.6 0.6])
xlim([0.5 1.5])
ylim([-0.6 0.6])
set(gca,'FontSize',18,'XTick',[],'Linewidth',1.5)
ylabel('MI - Kappa')
box off

