% AnalyseNREMsubstages_BilanInterPyrML
% from Sophie Bagur AprilDraftFig3NewWFClustering.m

%% Get data
Dir=PathForExperimentsMLnew('Spikes');
SaveFigFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew/';
Analyname='NREMsubstages_InterPyrWaveforms';


%% Get Waveforms

try
    load([res,'/',Analyname]);
    SpikeInfo.WF;
catch
    num=1;
    for mm=16:length(Dir.path)
        try
            disp(Dir.path{mm})
            cd(Dir.path{mm})
            load('SpikeClassification.mat')
            load('MeanWaveform.mat')
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
            
            % remove MUA from the analysis
            nN=numNeurons;
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                end
            end
            
            % get waveforms
            load('MeanWaveform.mat')
            for i=1:length(nN)
                SpikeInfo.WF(num,:)=W{i}(BestElec{i},:);
                SpikeInfo.FR(num,:)=Params{i}(1);
                num=num+1;
            end
        catch
            disp('Problem')
        end
    end
    %save
    save([res,'/',Analyname],'SpikeInfo','Dir')
end

%% Do clustering
load(['/home/mobsmorty/Dropbox/Kteam/PrgMatlab/WaveFormLibrary.mat'])
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
M=[WFInfo.HalfAmpDur/range(WFInfo.HalfAmpDur);...
    WFInfo.Assymetry/range(WFInfo.Assymetry);...
    WFInfo.TroughToPeakTime/range(WFInfo.TroughToPeakTime)]';
addpath(genpath('/usr/local/MATLAB/R2016a/toolbox/stats/stats'))
A=kmeans(M,2);

%% plot 3D figure



%% plot 2D figure
figure('Color',[1 1 1]); numF=gcf;
subplot(131)
plot(WFInfo.TroughToPeakTime(A==1)*1000,WFInfo.HalfAmpDur(A==1)*1000,'r.'), hold on
plot(WFInfo.TroughToPeakTime(A==2)*1000,WFInfo.HalfAmpDur(A==2)*1000,'b.'), hold on
box off
ylabel('Trough to peak latency (msec)')
xlabel('Half Amplitude duration (msec)')
ylim([0 0.4])

subplot(132)
plot(WFInfo.TroughToPeakTime(A==1)*1000,WFInfo.Assymetry(A==1),'r.'), hold on
plot(WFInfo.TroughToPeakTime(A==2)*1000,WFInfo.Assymetry(A==2),'b.'), hold on
box off
xlabel('Trough to peak latency (msec)')
ylabel('Assymetry index')
ylim([ -1.2 1])

subplot(133)
plot(mean((WaveToUseResample(A==1,:))),'r','linewidth',3), hold on
plot(mean((WaveToUseResample(A==2,:))),'b','linewidth',3), hold on
box off

%saveFigure(numF.Number,'WaveformsIntPyr','/home/mobsmorty/Dropbox/NREMsubstages-Manuscrit/NewFigs')


figure('Color',[1 1 1]); numG=gcf;
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
NumBars=9;

%saveFigure(numG.Number,'WaveformsIntPyrInfo','/home/mobsmorty/Dropbox/NREMsubstages-Manuscrit/NewFigs')
