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
num1=1;
SaveFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig2/';
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('FreezingModulationOBRef.mat')>0
        load('SpikeClassification.mat')
        load('SpikeData.mat')
        load('MeanWaveform.mat')
        load('behavResources.mat')
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        if obx,load('PFCx_Low_Spectrum.mat','ch'); chP=ch;
        else,load('B_Low_Spectrum.mat','ch'); chP=ch;end
        
        if exist('OBPFCxPhaseDiffFz.mat')==0
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        FilLFPOB=FilterLFP(LFP,[3 6],1024);
        load('ChannelsToAnalyse/PFCx_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        FilLFPP=FilterLFP(LFP,[3 6],1024);

        hil=hilbert(Data(FilLFPOB));hiltsd=tsd(Range(LFP),hil);
        PhB=phase(Data(Restrict(hiltsd,FreezeEpoch))); PhBtsd=tsd(Range(Restrict(hiltsd,FreezeEpoch),'s'),PhB);
        clear PhB
        hil=hilbert(Data(FilLFPP));hiltsd=tsd(Range(LFP),hil);
        PhP=phase(Data(Restrict(hiltsd,FreezeEpoch))); PhPtsd=tsd(Range(Restrict(hiltsd,FreezeEpoch),'s'),PhP);
        clear PhP
        Phdiff=mod(Data(PhBtsd)-Data(PhPtsd),2*pi);
        [Y,X]=hist(Phdiff,200);
        MeanPhdiff=X(find(Y==max(Y)));
        save('OBPFCxPhaseDiffFz.mat','MeanPhdiff')
        
        else
            load('OBPFCxPhaseDiffFz.mat')
        end

        clear PhP PhPtsd PhB PhBtsd hil Phdiff
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
                SpikeInfo.MeanPhDiff(num)=MeanPhdiff;
                AnimalByAnimal{mm}=[AnimalByAnimal{mm};Y];
                num=num+1;
            end
        end
        load('FreezingModulationPFCxRef.mat')
        AnimalByAnimalP{mm}=[];
        for i=1:size(Kappa,1)
            if  not(isempty(FR{i,1}))
                SpikeInfo.FR(num1)=FR{i,1};
                SpikeInfo.pvalP(num1)=pval{i,1};
                SpikeInfo.KappaP(num1)=Kappa{i,1};
                [Y,X]=hist(Data(ph{i,1}{1}),30);
                SpikeInfo.ModP(num1,:)=Y;
                SpikeInfo.PowerAutoCorrP(num1,:)=FFTAC{i,1};
                SpikeInfo.IDP(num1,:)=WfId(i);
                SpikeInfo.ParamsP(num1,:)=Params{numNeurons(i)};
                [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(ph{i}{1}));
                SpikeInfo.ZP(num1)=length(Data(ph{i}{1})) * Rmean^2;
                AnimalByAnimalP{mm}=[AnimalByAnimalP{mm};Y];
                num1=num1+1;
            end
        end
         load('FreezingModulationPFCxRef.mat')
        AnimalByAnimalP{mm}=[];
        for i=1:size(Kappa,1)
            if  not(isempty(FR{i,1}))
                SpikeInfo.FR(num1)=FR{i,1};
                SpikeInfo.pvalP(num1)=pval{i,1};
                SpikeInfo.KappaP(num1)=Kappa{i,1};
                [Y,X]=hist(Data(ph{i,1}{1}),30);
                SpikeInfo.ModP(num1,:)=Y;
                SpikeInfo.PowerAutoCorrP(num1,:)=FFTAC{i,1};
                SpikeInfo.IDP(num1,:)=WfId(i);
                SpikeInfo.ParamsP(num1,:)=Params{numNeurons(i)};
                [~, ~, ~, Rmean, ~, ~,~,~] = CircularMean(Data(ph{i}{1}));
                SpikeInfo.ZP(num1)=length(Data(ph{i}{1})) * Rmean^2;
                AnimalByAnimalP{mm}=[AnimalByAnimalP{mm};Y];
                num1=num1+1;
            end
        end
        PValMouse(mm,1)=sum([pval{:}]<0.05)/length([pval{:}]);
        PValMouse(mm,2)=length([pval{:}]);
        clear MeanPhdiff
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
SpikeInfo.IDP=AllWfId(end-length(SpikeInfo.ID)+1:end);
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
figure
PNSig=find(SpikeInfo.pvalP<0.05 & SpikeInfo.IDP'>0);AllPN=find(SpikeInfo.IDP'>0);
INSig=find(SpikeInfo.pvalP<0.05 & SpikeInfo.IDP'<0);AllIN=find(SpikeInfo.IDP'<0);
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure;
subplot(221)
TempMat=zscore(SpikeInfo.ModP(PNSig,:)');
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
TempMat=zscore(SpikeInfo.ModP(INSig,:)');
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
[Y,phax]=hist(Data(ph{i,1}{1}),30);

figure
hold on
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pvalP<0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pvalP<0.05,:)');
plot(phax(indB),phax(indP),'r.','MarkerSize',10)
[R,P]=corrcoef(indB,indP)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval<0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval<0.05,:)');
plot(phax(indB),phax(indP),'b.','MarkerSize',10)
[R,P]=corrcoef(indB,indP)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval<0.05 & SpikeInfo.pvalP<0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval<0.05 & SpikeInfo.pvalP<0.05,:)');
plot(phax(indB),phax(indP),'k.','MarkerSize',10)
[R,P]=corrcoef(indB,indP)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval>0.05 & SpikeInfo.pvalP>0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval>0.05 & SpikeInfo.pvalP>0.05,:)');
plot(phax(indB),phax(indP),'.','color',[0.6 0.6 0.6],'MarkerSize',10)
[R,P]=corrcoef(indB,indP)
xlim([0 2*pi]),ylim([0 2*pi])

figure
hold on
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pvalP<0.05 & SpikeInfo.pval>0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pvalP<0.05 & SpikeInfo.pval>0.05,:)');
[Y,X]=hist(phax(indB)-phax(indP),30);
stairs(X,Y,'r','linewidth',3)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval<0.05 & SpikeInfo.pvalP>0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval<0.05 & SpikeInfo.pvalP>0.05,:)');
[Y,X]=hist(phax(indB)-phax(indP),30);
stairs(X,Y,'b','linewidth',3)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval<0.05 & SpikeInfo.pvalP<0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval<0.05 & SpikeInfo.pvalP<0.05,:)');
[Y,X]=hist(phax(indB)-phax(indP),30);
stairs(X,Y,'k','linewidth',3)
[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pval>0.05 & SpikeInfo.pvalP>0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pval>0.05 & SpikeInfo.pvalP>0.05,:)');
[Y,X]=hist(phax(indB)-phax(indP),30);
stairs(X,Y,'color',[0.6 0.6 0.6],'linewidth',3)
xlim([-2*pi 2*pi])
legend('PFCx sig','OB sig','PFCx+OB sig','Not sig')





[val,indP]=max(SpikeInfo.ModP(SpikeInfo.pvalP<0.05 | SpikeInfo.pval<0.05,:)');
[val,indB]=max(SpikeInfo.Mod(SpikeInfo.pvalP<0.05 | SpikeInfo.pval<0.05,:)');
figure
plot(phax(indB),mod(phax(indP)+SpikeInfo.MeanPhDiff((SpikeInfo.pvalP<0.05 | SpikeInfo.pval<0.05)),2*pi),'r.','MarkerSize',10)
hold on
plot(phax(indB),phax(indP),'k.','MarkerSize',10)
[Y,X]=hist(phax(indB)-phax(indP),30);
stairs(X,Y,'color',[0.6 0.6 0.6],'linewidth',3)
xlim([-2*pi 2*pi])
[Y,X]=hist(phax(indB)-mod(phax(indP)+SpikeInfo.MeanPhDiff((SpikeInfo.pvalP<0.05 | SpikeInfo.pval<0.05)),2*pi),30);
stairs(X,Y,'color',[1 0 0],'linewidth',3)
xlim([-2*pi 2*pi])

