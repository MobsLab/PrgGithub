% Calculate spectra,coherence and Granger
clear all
obx=1;
num=1;
% Get data
OBXEphys=[230,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
if obx
    Dir=RestrictPathForExperiment(Dir,'nMice',[OBXEphys,CtrlEphys]);
else
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
end
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
KeepFirstSessionOnly=[[1:4],[1,3,4,6,8:18]+4];
n=1;

AllCoh=[];AllP=[];AllFR=[];
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('SpikeFieldCoherencePFCRef.mat')>0
        AllCoh{num}=[];AllP{num}=[];AllFR{num}=[];AllK{num}=[];
        AllCoh69{num}=[];AllP69{num}=[];AllFR69{num}=[];AllK69{num}=[];
        
        load('SpikeFieldCoherencePFCRef.mat')
        load('behavResources.mat')
        load('StateEpochSB.mat')
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
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
        load('FreezingModulationPFCxRef.mat')
        for k=1:length(pval)
            AllCoh{num}=[AllCoh{num};nanmean(Data(Restrict(Ctsd{k},FreezeEpoch)))];
            AllP{num}=[AllP{num},pval{k,1}];
            AllFR{num}=[AllFR{num},FR{k,1}];
            AllK{num}=[AllK{num},Kappa{k,1}];
        end
        load('FreezingModulationPFCxRef69Hz.mat')
        for k=1:length(pval)
            AllCoh69{num}=[AllCoh69{num};nanmean(Data(Restrict(Ctsd{k},FreezeEpoch)))];
            AllP69{num}=[AllP69{num},pval{k,1}];
            AllFR69{num}=[AllFR69{num},FR{k,1}];
            AllK69{num}=[AllK69{num},Kappa{k,1}];
        end
        
        
        IsCtrl(num)=strcmp(Dir.group{mm},'CTRL');
        num=num+1;
    end
end

Cols2=[0,146,146;189,109,255]/263;
CohBBX=[];NeurModBBX=[];KappaBBX=[];FRBBX=[];NeurModBBX69=[];KappaBBX69=[];
for k=[1:3]
    CohBBX=[CohBBX;AllCoh{k}];
    NeurModBBX=[NeurModBBX (AllP{k}<0.05)];
    KappaBBX=[KappaBBX AllK{k}];
    FRBBX=[FRBBX AllFR{k}];
    NeurModBBX69=[NeurModBBX69 (AllP69{k}<0.05)];
    KappaBBX69=[KappaBBX69 AllK69{k}];
end
CohSham=[];NeurModSham=[]; KappaSham=[];FRSham=[];KappaSham69=[];NeurModSham69=[];

for k=4:num-1
    CohSham=[CohSham;AllCoh{k}];
    NeurModSham=[NeurModSham AllP{k}<0.05];
    KappaSham=[KappaSham AllK{k}];
    FRSham=[FRSham AllFR{k}];
    NeurModSham69=[NeurModSham69 (AllP69{k}<0.05)];
    KappaSham69=[KappaSham69 AllK69{k}];
end

cd /home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Fig3
fig=figure;
[hl,hp]=boundedline(f{1},nanmean(CohSham),[stdError(CohSham);stdError(CohSham)]','alpha');
set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(1,:))
hold on
[hl,hp]=boundedline(f{1},nanmean(CohBBX),[stdError(CohBBX);stdError(CohBBX)]','alpha');
set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols2(2,:))
saveas(fig,'SpikeFieldCoherence.fig')
close all

fig=figure;
subplot(311)
hold on
line([0.7 1.3],[1 1]*nanmean(log(FRSham)),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(log(FRBBX)),'color','k','linewidth',2)
plotSpread({log(FRSham),log(FRBBX)},'yLabel','log FR (Hz)','xNames',{'CTRL','BBX'},'distributionColors',Cols2)
subplot(312)
hold on
line([0.7 1.3],[1 1]*nanmean(KappaSham(find(NeurModSham))),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(KappaBBX(find(NeurModBBX))),'color','k','linewidth',2)
plotSpread({KappaSham(find(NeurModSham)),KappaBBX(find(NeurModBBX))},'yLabel','Kappa 2-4 Hz, sig neur','xNames',{'CTRL','BBX'},'distributionColors',Cols2)
subplot(313)
ModSham=(KappaSham-KappaSham69)./(KappaSham+KappaSham69);
ModBBX=(KappaBBX-KappaBBX69)./(KappaBBX+KappaBBX69);
line([0.7 1.3],[1 1]*nanmean(ModSham),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmean(ModBBX),'color','k','linewidth',2)
plotSpread({ModSham,ModBBX},'yLabel','MI of Kappa 6-9 vs 2-4Hz','xNames',{'CTRL','BBX'},'distributionColors',Cols2)
line(xlim,[0 0],'color','k')
ylim([-1.2 1.2])
saveas(fig,'ParametersNeurons.fig')
close all


