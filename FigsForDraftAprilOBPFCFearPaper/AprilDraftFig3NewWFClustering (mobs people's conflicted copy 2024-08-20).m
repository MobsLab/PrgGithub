% This code generates pannels used in april draft
% It generates Fig3

clear all,close all
obx=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigAfterSkype/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];
KeepFirstSessionOnly=[1,5:length(Dir.path)];

%  get parameters
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
numNeurons=[];
num=1;
StrucNames={'OBVars' 'PFCVars' 'HPCVars'}

for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    load('SpikeClassification.mat')
    load('SpikeData.mat')
    load('MeanWaveform.mat')
    load('behavResources.mat')
    load('OBPFCxPhaseDiffFz.mat')
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
%     if obx,load('PFCx_Low_Spectrum.mat','ch'); chP=ch;
%     else,load('B_Low_Spectrum.mat','ch'); chP=ch;end
    
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
    SpikeMod.PFCVars=load('NeuronLFPCoupling/FzNeuronModFreqSpecificBandCorrected_PFCx.mat');
    SpikeMod.HPCVars=load('NeuronLFPCoupling/FzNeuronModFreqSpecificBandCorrected_HPC1.mat');
    SpikeMod.OBVars=load('NeuronLFPCoupling/FzNeuronModFreqSpecificBandCorrected_OB1.mat');
    load('MeanWaveform.mat')
    for i=1:size(SpikeMod.OBVars.Kappa,2)
        SpikeInfo.WF(num,:)=W{i}(BestElec{i},:);
        SpikeInfo.FR(num,:)=Params{i}(1);
        SpikeInfo.MeanPhaseDiff(num)=MeanPhdiff;
        SpikeInfo.NumSpikes(num)=length((SpikeMod.PFCVars.PhasesSpikes{i}.Transf));
        for s=1:length(StrucNames)
            
            SpikeInfo.(StrucNames{s}).pval(num)=SpikeMod.(StrucNames{s}).pval{i}.Transf;
            SpikeInfo.(StrucNames{s}).Kappa(num)=SpikeMod.(StrucNames{s}).Kappa{i}.Transf;
            SpikeInfo.(StrucNames{s}).PhaseMu(num,:)=SpikeMod.(StrucNames{s}).mu{i}.Transf;
            [Y,X]=hist(mod(SpikeMod.(StrucNames{s}).PhasesSpikes{i}.Transf,2*pi),30);
            SpikeInfo.(StrucNames{s}).Mod(num,:)=Y;
            SpikeInfo.(StrucNames{s}).Params(num,:)=Params{numNeurons(i)};
            [mutest, ~, ~, Rmean, ~, ~,~,~] = CircularMean((SpikeMod.(StrucNames{s}).PhasesSpikes{i}.Transf));
            SpikeInfo.(StrucNames{s}).Z(num)=length((SpikeMod.(StrucNames{s}).PhasesSpikes{i}.Transf)) * Rmean^2; % R^2/N
            % note this calculation looks weird givent he comment its
            % because in circular mean Rmean = C/N 
            [Y,X]=hist(mod(SpikeMod.(StrucNames{s}).PhasesSpikes{i}.Transf-MeanPhdiff,2*pi),30);
            SpikeInfo.(StrucNames{s}).ModCorr(num,:)=Y;
            [muCorr, ~, ~, Rmean, ~, ~,~,~] = CircularMean(mod(SpikeMod.(StrucNames{s}).PhasesSpikes{i}.Transf-MeanPhdiff,2*pi));
            SpikeInfo.(StrucNames{s}).PhaseMuCorr(num,:)=muCorr;
        end
        num=num+1;
    end
    
    
end

load(['/home/vador/Dropbox/Kteam/PrgMatlab/WaveFormLibrary.mat'])
%%
Dat=[(AllData2(:,end-31:end)'),SpikeInfo.WF'];
for k=1:size(Dat,2)
    WaveToUseResample(k,:) = resample(Dat(:,k),300,1);
    WaveToUseResample(k,:)=WaveToUseResample(k,:)./(max(WaveToUseResample(k,:))-min(WaveToUseResample(k,:)));
    % Trough To Peak
    [valMin,indMin]=min(WaveToUseResample(k,:));
    [val2,ind2]=max(WaveToUseResample(k,indMin:end));
    WFInfo.TroughToPeakTime(k)=ind2*5e-5/300;
    % Half amplitude duration
    HalfAmp=valMin/2;
    TimeAtHlafAmp(1)=find(WaveToUseResample(k,:)<HalfAmp,1,'first');
    TimeAtHlafAmp(2)=find(WaveToUseResample(k,:)<HalfAmp,1,'last');
    WFInfo.HalfAmpDur(k)=(TimeAtHlafAmp(2)-TimeAtHlafAmp(1))*5e-5/300;
    % Get half width
    DD=diff(WaveToUseResample(k,:));
    diffpeak=find(DD(indMin:end)==max(DD(indMin:end)))+indMin;
    DD=DD(diffpeak:end);
    IndMax=find(DD<max(abs(diff(WaveToUseResample(k,:))))*0.01,1,'first')+diffpeak;
    if WaveToUseResample(k,IndMax)<0
        try
            IndMax=find(WaveToUseResample(k,IndMax:end)>0,1,'first')+IndMax ;
        catch
            IndMax=length(WaveToUseResample(k,:));
        end
    end
    WFInfo.HalfWidth(k)=(IndMax-indMin)*5e-5/300;
    % Area under curve
    WaveToUseResampleTemp=WaveToUseResample(k,indMin:end);
    valzero=find(WaveToUseResampleTemp>0,1,'first');
    WaveToCalc=WaveToUseResampleTemp(valzero:end);
    WFInfo.AreaUnderCurve(k)=sum(abs(WaveToCalc));
    WFInfo.AreaUnderCurveNorm(k)=sum(abs(WaveToCalc))./(length(WaveToUseResample(k,:))-valzero);
    % Assymetry
    MaxBef=max(WaveToUseResample(k,1:indMin));
    MaxAft=max(WaveToUseResample(k,indMin:end));
    WFInfo.Assymetry(k)=(MaxAft-MaxBef)./(MaxAft+MaxBef);
end
clear A

A=kmeans(([WFInfo.HalfAmpDur/range(WFInfo.HalfAmpDur);WFInfo.Assymetry/range(WFInfo.Assymetry);WFInfo.TroughToPeakTime/range(WFInfo.TroughToPeakTime)]'),2);
figure
subplot(121)
plot(WFInfo.TroughToPeakTime(A==1)*1000,WFInfo.HalfAmpDur(A==1)*1000,'r*'), hold on
plot(WFInfo.TroughToPeakTime(A==2)*1000,WFInfo.HalfAmpDur(A==2)*1000,'b*'), hold on
box off
ylabel('Trough to peak latency (msec)')
xlabel('Half Amplitude duration (msec)')
ylim([0 0.4])
subplot(122)
plot(WFInfo.TroughToPeakTime(A==1)*1000,WFInfo.Assymetry(A==1),'r*'), hold on
plot(WFInfo.TroughToPeakTime(A==2)*1000,WFInfo.Assymetry(A==2),'b*'), hold on
box off
xlabel('Trough to peak latency (msec)')
ylabel('Assymetry index')
ylim([ -1.2 1])
figure
plot(mean((WaveToUseResample(A==1,:))),'r','linewidth',3), hold on
plot(mean((WaveToUseResample(A==2,:))),'b','linewidth',3), hold on
box off

figure
nbin=1;
subplot(131)
nhist(WFInfo.TroughToPeakTime*1000,'noerror','binfactor',nbin,'numbers')
title('Trough to peak latency (msec)')
subplot(132)
nhist(WFInfo.HalfAmpDur*1000,'noerror','binfactor',nbin,'numbers')
title('Half Amplitude duration (msec)')
subplot(133)
nhist(WFInfo.Assymetry,'noerror','binfactor',nbin,'numbers')
title('Assymetry index')
% Identify the PN cell group as the most numerous one
NumofOnes=sum(A==1)/length(A);
if NumofOnes>0.5
    A(A==1)=1;
    A(A==2)=-1;
else
    A(A==1)=-1;
    A(A==2)=1;
end
SpikeInfo.ID=A(end-size(SpikeInfo.WF,1)+1:end);
PNSig=find(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.ID'>0);AllPN=find(SpikeInfo.ID'>0);
INSig=find(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.ID'<0);AllIN=find(SpikeInfo.ID'<0);

NumBars=9;
clear A
%OB
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure('name','OB');
subplot(221)
TempMat=zscore(SpikeInfo.OBVars.Mod(PNSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH1=X(ind);
PH1OB=PH1;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(PNSig)],[TempMat,TempMat]), axis xy
xlim([0 4*pi])
clim([-2.5 2.5])
hold on
ylabel('cell number')
plot([phax,phax+2*pi],[Yax,Yax]*length(PNSig)/4+length(PNSig)/2,'r','linewidth',2)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
set(gca,'FontSize',14)
subplot(223)
[Count,Phase]=hist(SpikeInfo.OBVars.PhaseMu(PNSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.2 0.2 0.8])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
subplot(222)
TempMat=zscore(SpikeInfo.OBVars.Mod(INSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH2=X(ind);
PH2OB=PH2;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(INSig)],[TempMat,TempMat]), axis xy
ylabel('cell number')
clim([-2.5 2.5])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
hold on
set(gca,'FontSize',14)
subplot(224)
[Count,Phase]=hist(SpikeInfo.OBVars.PhaseMu(INSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.8 0.2 0.2])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
saveas(fig,[SaveFigFolder, 'OBOverall.fig']),close all


%PFC
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure('name','PFC');
subplot(221)
TempMat=zscore(SpikeInfo.PFCVars.Mod(PNSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH1=X(ind);
PH1OB=PH1;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(PNSig)],[TempMat,TempMat]), axis xy
xlim([0 4*pi])
clim([-2.5 2.5])
hold on
ylabel('cell number')
plot([phax,phax+2*pi],[Yax,Yax]*length(PNSig)/4+length(PNSig)/2,'r','linewidth',2)
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
set(gca,'FontSize',14)
subplot(223)
[Count,Phase]=hist(SpikeInfo.PFCVars.PhaseMu(PNSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.2 0.2 0.8])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
subplot(222)
TempMat=zscore(SpikeInfo.PFCVars.Mod(INSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH2=X(ind);
PH2OB=PH2;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(INSig)],[TempMat,TempMat]), axis xy
ylabel('cell number')
clim([-2.5 2.5])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
hold on
set(gca,'FontSize',14)
subplot(224)
[Count,Phase]=hist(SpikeInfo.PFCVars.PhaseMu(INSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.8 0.2 0.2])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
saveas(fig,[SaveFigFolder 'PFCOverall.fig'])
close all


%OB corrected
phax=[0:2*pi/100:2*pi];
Yax=cos(phax);
fig=figure('name','OBCorr');
subplot(221)
TempMat=zscore(SpikeInfo.OBVars.ModCorr(PNSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH1=X(ind);
PH1OB=PH1;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(PNSig)],[TempMat,TempMat]), axis xy
xlim([0 4*pi])
clim([-2.5 2.5])
hold on
ylabel('cell number')
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
set(gca,'FontSize',14)
subplot(223)
[Count,Phase]=hist(SpikeInfo.OBVars.PhaseMuCorr(PNSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.2 0.2 0.8])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
subplot(222)
TempMat=zscore(SpikeInfo.OBVars.ModCorr(INSig,:)');
[val,ind]=max(TempMat);
TempMat=[X(ind);TempMat];
PH2=X(ind);
PH2OB=PH2;
TempMat=sortrows(TempMat');
TempMat=TempMat(:,2:end);
imagesc([X,X+2*pi],[1:length(INSig)],[TempMat,TempMat]), axis xy
ylabel('cell number')
clim([-2.5 2.5])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
hold on
set(gca,'FontSize',14)
subplot(224)
[Count,Phase]=hist(SpikeInfo.OBVars.PhaseMuCorr(INSig),NumBars);
Count=100*Count/sum(Count);
bar([[2*pi/NumBars:2*pi/NumBars:2*pi],[2*pi/NumBars:2*pi/NumBars:2*pi]+2*pi]-2*pi/(NumBars*2),[Count,Count],'FaceColor',[0.8 0.2 0.2])
xlim([0 4*pi])
set(gca,'XTick',[0:pi:4*pi],'XTickLabel',{'0','?�','2?�','3?�','4?�'})
box off
xlabel('phase'), ylabel('% units')
set(gca,'FontSize',14)
saveas(fig,[SaveFigFolder 'OBCorrOverall.fig'])
close all

fig=figure;
plot(SpikeInfo.OBVars.PhaseMu(sort([PNSig,INSig])),SpikeInfo.PFCVars.PhaseMu(sort([PNSig,INSig])),'*')
hold on
plot(mod(SpikeInfo.OBVars.PhaseMu(sort([PNSig,INSig]))-SpikeInfo.MeanPhaseDiff(sort([PNSig,INSig]))',2*pi),SpikeInfo.PFCVars.PhaseMu(sort([PNSig,INSig])),'*')
[RCorr,PCorr]=corrcoef(mod(SpikeInfo.OBVars.PhaseMu(sort([PNSig,INSig]))-SpikeInfo.MeanPhaseDiff(sort([PNSig,INSig]))',2*pi),SpikeInfo.PFCVars.PhaseMu(sort([PNSig,INSig])));
[R,P]=corrcoef(SpikeInfo.OBVars.PhaseMu(sort([PNSig,INSig])),SpikeInfo.PFCVars.PhaseMu(sort([PNSig,INSig])));
saveas(fig,[SaveFigFolder 'PhaseCorrectionImproved.fig'])
close all

fig=figure;
[Y1,X1]=(hist(log(SpikeInfo.OBVars.Z(AllPN)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'b','linewidth',2), hold on
[Y1,X1]=(hist(log(SpikeInfo.OBVars.Z(AllIN)),100));
plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'r','linewidth',2)
line([1.12 1.12],ylim,'linestyle','--','color','k')
xlim([0 6]),ylim([0 100])
box off
xlabel('ln(Z)'), ylabel('% units')
set(gca,'FontSize',10,'YTick',[0:20:100])
saveas(fig,[SaveFigFolder 'HowManyUNitmod.fig'])
close all;

fig=figure;
plot(SpikeInfo.PFCVars.Kappa(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.PFCVars.pval>0.05),SpikeInfo.OBVars.Kappa(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.PFCVars.pval>0.05),'ko','MarkerSize',10,'MarkerFaceColor','k')
hold on
plot(SpikeInfo.PFCVars.Kappa(SpikeInfo.OBVars.pval>0.05 & SpikeInfo.PFCVars.pval<0.05),SpikeInfo.OBVars.Kappa(SpikeInfo.OBVars.pval>0.05 & SpikeInfo.PFCVars.pval<0.05),'k^','MarkerSize',10,'MarkerFaceColor','k')
plot(SpikeInfo.PFCVars.Kappa(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.PFCVars.pval<0.05),SpikeInfo.OBVars.Kappa(SpikeInfo.OBVars.pval<0.05 & SpikeInfo.PFCVars.pval<0.05),'ksq','MarkerSize',10)
line([0 1],[0 1])
xlabel('Kappa-PFCx mod'),ylabel('Kappa-OB mod')
set(gca,'FontSize',10,'YTick',[0:0.2:1],'XTick',[0:0.2:1])
box off
saveas(fig,[SaveFigFolder 'KappaTwoLFPs.fig'])
close all;

X=SpikeInfo.OBVars.Kappa(and(SpikeInfo.OBVars.pval<0.05,SpikeInfo.PFCVars.pval<0.05))';
Y=SpikeInfo.PFCVars.Kappa(and(SpikeInfo.OBVars.pval<0.05,SpikeInfo.PFCVars.pval<0.05))';
[p,h,stats]=ModIndexPlot(X,Y)


%% Make barplot
figure
X=SpikeInfo.OBVars.Kappa(and(SpikeInfo.OBVars.pval<0.05,SpikeInfo.PFCVars.pval<0.05))';
Y=SpikeInfo.PFCVars.Kappa(and(SpikeInfo.OBVars.pval<0.05,SpikeInfo.PFCVars.pval<0.05))';
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
set(gca,'FontSize',18,'XTick',[])
ylabel('MI - Kappa')c
box off




fig=figure;
h=pie([length(PNSig)/length(AllPN),1-length(PNSig)/length(AllPN)]);
set(h(1),'FaceColor',[0.2 0.2 0.8])
set(h(3),'FaceColor',[1 1 1])
saveas(fig,[SaveFigFolder 'PiePN.fig'])
close all;

fig=figure;
h=pie([length(INSig)/length(AllIN),1-length(INSig)/length(AllIN)]);
set(h(1),'FaceColor',[0.8 0.2 0.2])
set(h(3),'FaceColor',[1 1 1])
saveas(fig,[SaveFigFolder 'PieIN.fig'])
close all;

[pval z]=circ_rtest(SpikeInfo.OBVars.PhaseMuCorr([INSig,PNSig]))

% fig=figure;
% plot3(ClusterData(find(AllWfId==-1),2),ClusterData(find(AllWfId==-1),3),ClusterData(find(AllWfId==-1),1),'b.')
% hold on
% plot3(ClusterData(find(AllWfId==1),2),ClusterData(find(AllWfId==1),3),ClusterData(find(AllWfId==1),1),'r.')
