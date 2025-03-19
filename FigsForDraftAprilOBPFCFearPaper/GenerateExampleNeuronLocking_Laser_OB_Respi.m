NumBins = 30;

% phase histograms for figure 3 and figure S2
cd('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117')
load('NeuronRespLaserOB.mat')

k=30
figure
subplot(211)
[Y,X] = hist([(ph.Laser{k,3})],NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=mu.Laser(k,3);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,Kappa.Laser(k,3));
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

subplot(212)
[Y,X] = hist([(ph.Laser{k,5})],NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=mu.Laser(k,5);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,Kappa.Laser(k,5));
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

k=30
figure
subplot(211)
[Y,X] = hist([(Data(ph.OB{k,3}{1}))],NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=mu.OB(k,3);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,Kappa.OB(k,3));
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

subplot(212)
[Y,X] = hist([Data(ph.OB{k,5}{1})],NumBins);
bar([X,X+2*pi],[Y,Y]/sum(Y),'Facecolor',[0.6 0.6 0.6],'Edgecolor',[0.6 0.6 0.6]), hold on
dB = 2*pi/NumBins;
B = [dB/2:dB:2*pi-dB/2];
t=mu.OB(k,5);
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,Kappa.OB(k,5));
hold on
plot([B B+2*pi],max(Y/sum(Y)).*[vm vm]/max(vm),'r','lineWidth',3)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Phase hisotrgam for figure 1
obx=0;
% Get data
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
plot([B B+2*pi],max(SpikeInfo.RespiMod(k,:)/sum(SpikeInfo.RespiMod(k,:))).*[vm vm]/max(vm),'r','lineWidth',3)

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
plot([B B+2*pi],max(SpikeInfo.OBMod(k,:)/sum(SpikeInfo.OBMod(k,:))).*[vm vm]/max(vm),'r','lineWidth',3)

set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
xlim([0 4*pi])
box off
