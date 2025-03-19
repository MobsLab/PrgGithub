clear all
% This data only includes freezing
WndwSz =  5000;
DecodingLimits = [0.4,0.6]; NumMice = 6;
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
% was generated with /home/gruffalo/Dropbox/Kteam/PrgMatlab/EmbReact/Ephys/Spikes/DecodeFreezingSideWithSpikes_SB.m
% so just contains freezing
load(['OverallInfoPhysioSpikes',num2str(WndwSz/1e4),'.mat'])

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves
load('BRTuning_Wake_Explo_PFC.mat') % Use this to be sure there is no leak
% load('BRTuning_Freezing_PFC.mat')


%% Order neurons by OB frequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

AllSpk = [];
AllPAnova = [];
AllSpk_CV = [];
for mm=1:NumMice
    AllSpk = [AllSpk;MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:)];
    AllSpk_CV = [AllSpk_CV;MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:)];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
end
plim = 0.05/(length(AllPAnova));
ZScSp = smooth2a(nanzscore(AllSpk_CV(AllPAnova<plim,:)')',0,2)';
[val,ind]= max(ZScSp);
[~,ind]= sort(ind);

% for freezing
% W = nanmean(ZScSp(1:10,:),1) - nanmean(ZScSp(10:20,:),1);
% W = W-mean(W);

% for active
W = nanmean(ZScSp(1:15,:),1) - nanmean(ZScSp(15:25,:),1);
W = W-mean(W);


ShockAct = [];
SafeAct = [];
for mm=1:NumMice
    ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<DecodingLimits(1));
    SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>DecodingLimits(2));
    
    ShockAct = [ShockAct;nanmean(MouseByMouse.FR{mm}(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,MouseByMouse.LinPos{mm}<DecodingLimits(1)),2)];
    SafeAct = [SafeAct ;nanmean(MouseByMouse.FR{mm}(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,MouseByMouse.LinPos{mm}>DecodingLimits(2)),2)];
end

[R,P] = corr(SafeAct - ShockAct,W')



for mm=1:NumMice
    
    % location
    ShockBins = find(MouseByMouse.LinPos{mm}<DecodingLimits(1));
    SafeBins = find(MouseByMouse.LinPos{mm}>DecodingLimits(2));
    SkNum(mm) = length(ShockBins);
    SfNum(mm) = length(SafeBins);
end

MinSf = min(SfNum(1:end));
MinSk = min(SkNum(1:end));

for perm= 1:100
    ShockAct = [];
    SafeAct = [];
    
    for mm=1:NumMice
        Firing = nanzscore(MouseByMouse.FR{mm}')';
        
        ShockBins = find(MouseByMouse.LinPos{mm}<DecodingLimits(1));
        SafeBins = find(MouseByMouse.LinPos{mm}>DecodingLimits(2));
        ShockAct = [ShockAct;Firing(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,ShockBins(randperm(length(ShockBins),MinSf)))];
        SafeAct = [SafeAct;Firing(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,SafeBins(randperm(length(SafeBins),MinSf)))];
    end
    
    NeurToKeep = randi(length(W),length(W),1);
    Acc_Act(perm) = nanmean((ShockAct(NeurToKeep,:)'*W(NeurToKeep)')<(SafeAct(NeurToKeep,:)'*W(NeurToKeep)'));
    NeurToKeep_Rd = randi(length(W),length(W),1);
    Acc_Rd(perm) = nanmean((ShockAct(NeurToKeep,:)'*W(NeurToKeep_Rd)')<(SafeAct(NeurToKeep,:)'*W(NeurToKeep_Rd)'));

    
end


% load('BRTuning_Wake_Explo_PFC.mat') % Use this to be sure there is no leak
load('BRTuning_Freezing_PFC.mat')


%% Order neurons by OB frequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

AllSpk = [];
AllPAnova = [];
AllSpk_CV = [];
for mm=1:NumMice
    AllSpk = [AllSpk;MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:)];
    AllSpk_CV = [AllSpk_CV;MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:)];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
end
plim = 0.05/(length(AllPAnova));
ZScSp = smooth2a(nanzscore(AllSpk_CV(AllPAnova<plim,:)')',0,2)';
[val,ind]= max(ZScSp);
[~,ind]= sort(ind);

% for freezing
W = nanmean(ZScSp(1:10,:),1) - nanmean(ZScSp(10:20,:),1);
W = W-mean(W);


ShockAct = [];
SafeAct = [];
for mm=1:NumMice
    ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<DecodingLimits(1));
    SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>DecodingLimits(2));
    
    ShockAct = [ShockAct;nanmean(MouseByMouse.FR{mm}(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,MouseByMouse.LinPos{mm}<DecodingLimits(1)),2)];
    SafeAct = [SafeAct ;nanmean(MouseByMouse.FR{mm}(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,MouseByMouse.LinPos{mm}>DecodingLimits(2)),2)];
end

[R,P] = corr(SafeAct - ShockAct,W')



for mm=1:NumMice
    
    % location
    ShockBins = find(MouseByMouse.LinPos{mm}<DecodingLimits(1));
    SafeBins = find(MouseByMouse.LinPos{mm}>DecodingLimits(2));
    SkNum(mm) = length(ShockBins);
    SfNum(mm) = length(SafeBins);
end

MinSf = min(SfNum(1:end));
MinSk = min(SkNum(1:end));

for perm= 1:100
    ShockAct = [];
    SafeAct = [];
    
    for mm=1:NumMice
        Firing = nanzscore(MouseByMouse.FR{mm}')';
        
        ShockBins = find(MouseByMouse.LinPos{mm}<DecodingLimits(1));
        SafeBins = find(MouseByMouse.LinPos{mm}>DecodingLimits(2));
        ShockAct = [ShockAct;Firing(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,ShockBins(randperm(length(ShockBins),MinSf)))];
        SafeAct = [SafeAct;Firing(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))<plim,SafeBins(randperm(length(SafeBins),MinSf)))];
    end
    
    NeurToKeep = randi(length(W),length(W),1);
    Acc_Fz(perm) = nanmean((ShockAct(NeurToKeep,:)'*W(NeurToKeep)')<(SafeAct(NeurToKeep,:)'*W(NeurToKeep)'));
    NeurToKeep_Rd = randi(length(W),length(W),1);
    Acc_Rd(perm) = nanmean((ShockAct(NeurToKeep,:)'*W(NeurToKeep_Rd)')<(SafeAct(NeurToKeep,:)'*W(NeurToKeep_Rd)'));

    
end
figure
% nhist({ShockAct'*W',SafeAct'*W'})
MakeSpreadAndBoxPlot_SB({Acc_Rd,Acc_Fz,Acc_Act},{},[],{'Rand','Fz','Act'},1)
ylim([0 1])



