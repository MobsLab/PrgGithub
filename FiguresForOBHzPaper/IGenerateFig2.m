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
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('FreezingModulationOBRef.mat')>0
        load('SpikeClassification.mat')
        try, load('SpikeClassification.mat'), catch, load('NeuronClassification.mat'), WfId = UnitID(:,1);end
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
        load('FreezingModulationOBRef.mat')
        AnimalByAnimal{mm}=[];
        for i=1:size(Kappa,1)
            if not(isempty(FR{i,1}))
                SpikeInfo.FR(num)=FR{i,1};
                SpikeInfo.pval(num)=pval{i,1};
                SpikeInfo.Kappa(num)=Kappa{i,1};
                [Y,X]=hist(Data(ph{i,1}{1}),30);
                SpikeInfo.Mod(num,:)=Y;
                SpikeInfo.PowerAutoCorr(num,:)=FFTAC{i,1};
                SpikeInfo.ID(num,:)=WfId(i);
                SpikeInfo.Params(num,:)=Params{numNeurons(i)};
                [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(ph{i}{1}));
                SpikeInfo.Z(num)=length(Data(ph{i}{1})) * Rmean^2;
                SpikeInfo.KappaP(num)=KappaP{i,1};
                AnimalByAnimal{mm}=[AnimalByAnimal{mm};Y];
                num=num+1;
            end
        end
        
        PValMouse(mm,1)=sum([pval{:}]<0.05)/length([pval{:}]);
        PValMouse(mm,2)=length([pval{:}]);
        
    end
end

load(['/home/vador/Dropbox/Kteam/PrgMatlab/WaveFormLibrary.mat'])
% Add library WF Data
ClusterData=[AllData2(:,1:3);SpikeInfo.Params];
ClusterData(:,1)=ClusterData(:,1)./(max(ClusterData(:,1))-min(ClusterData(:,1)));
ClusterData(:,2)=ClusterData(:,2)./(max(ClusterData(:,2))-min(ClusterData(:,2)));
ClusterData(:,3)=ClusterData(:,3)./(max(ClusterData(:,3))-min(ClusterData(:,3)));

AllWfId=kmeans(ClusterData(:,1:3),2);
% Identify the PN cell group as the most numerous one
NumofOnes=sum(AllWfId==1)/length(AllWfId);
if NumofOnes>0.5
    AllWfId(AllWfId==1)=1;
    AllWfId(AllWfId==2)=-1;
else
    AllWfId(AllWfId==1)=-1;
    AllWfId(AllWfId==2)=1;
end
SpikeInfo.ID=AllWfId(end-length(SpikeInfo.ID)+1:end);


PNSig=find(SpikeInfo.pval<0.05 & SpikeInfo.ID'>0);AllPN=find(SpikeInfo.ID'>0);
INSig=find(SpikeInfo.pval<0.05 & SpikeInfo.ID'<0);AllIN=find(SpikeInfo.ID'<0);
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure;
subplot(221)
TempMat=zscore(SpikeInfo.Mod(PNSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH1=X(ind);
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(PNSig)],[TempMat,TempMat]), axis xy
xlim([0 4*pi])
clim([-3 3])
hold on
ylabel('cell number')
plot([phax,phax+2*pi],[Yax,Yax]*length(PNSig)/4+length(PNSig)/2,'r','linewidth',2)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
set(gca,'FontSize',14)
subplot(223)
[Count,Phase]=hist(PH1,6);Count=100*Count/sum(Count);
bar([[2*pi/6:2*pi/6:2*pi],[2*pi/6:2*pi/6:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.2 0.2 0.8])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
subplot(222)
TempMat=zscore(SpikeInfo.Mod(INSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH2=X(ind);
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(INSig)],[TempMat,TempMat]), axis xy
ylabel('cell number')
clim([-3 3])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
hold on
plot([phax,phax+2*pi],[Yax,Yax]*length(INSig)/4+length(INSig)/2,'r','linewidth',2)
set(gca,'FontSize',14)
subplot(224)
[Count,Phase]=hist(PH2,6);Count=100*Count/sum(Count);
bar([[2*pi/6:2*pi/6:2*pi],[2*pi/6:2*pi/6:2*pi]+2*pi]-2*pi/12,[Count,Count],'FaceColor',[0.8 0.2 0.2])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','π','2π','3π','4π'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
saveas(fig,[SaveFolder 'SpikeModGeneralPFCx.fig'])
close all;

fig=figure;
[Y1,X1]=(hist(log(SpikeInfo.Z(AllPN)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'b','linewidth',2), hold on
[Y1,X1]=(hist(log(SpikeInfo.Z(AllIN)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'r','linewidth',2)
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])
saveas(fig,[SaveFolder 'HowManyUNitmod.fig'])
close all;

fig=figure;
plot(SpikeInfo.KappaP([PNSig,INSig]),SpikeInfo.Kappa([PNSig,INSig]),'.')
hold on
line([0 1],[0 1])
xlabel('Kappa-PFCx mod'),ylabel('Kappa-OB mod')
set(gca,'FontSize',10,'YTick',[0:0.2:1],'XTick',[0:0.2:1])
box off
saveas(fig,[SaveFolder 'KappaTwoLFPs.fig'])
close all;

fig=figure;
h=pie([length(PNSig)/length(AllPN),1-length(PNSig)/length(AllPN)]);
set(h(1),'FaceColor',[0.2 0.2 0.8])
set(h(3),'FaceColor',[1 1 1])
saveas(fig,[SaveFolder 'PiePN.fig'])
close all;

fig=figure;
h=pie([length(INSig)/length(AllIN),1-length(INSig)/length(AllIN)]);
set(h(1),'FaceColor',[0.8 0.2 0.2])
set(h(3),'FaceColor',[1 1 1])
saveas(fig,[SaveFolder 'PieIN.fig'])
close all;


fig=figure;
plot3(ClusterData(find(AllWfId==-1),2),ClusterData(find(AllWfId==-1),3),ClusterData(find(AllWfId==-1),1),'b.')
hold on
plot3(ClusterData(find(AllWfId==1),2),ClusterData(find(AllWfId==1),3),ClusterData(find(AllWfId==1),1),'r.')
