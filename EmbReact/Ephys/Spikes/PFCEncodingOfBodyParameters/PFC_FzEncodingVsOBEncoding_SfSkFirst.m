clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{1} = 'AllCondSessions';

WndwSz = 0.5*1e4;
Recalc = 0;
NumShuffles = 1000;
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
load(['OverallSpikesFzandMov',num2str(WndwSz/1e4),'.mat'])
for mm=1:length(MiceNumber)
    
    for spk = 1:size(MouseByMouse.FRFz{mm},1)
        
        fShck = MouseByMouse.FRFz{mm}(spk,find(MouseByMouse.LinPosFz{mm}<0.4))';
        fNoShck = MouseByMouse.FRFz{mm}(spk,find(MouseByMouse.LinPosFz{mm}>0.6))';
        alpha=[];
        beta=[];
        minval=min([fShck;fNoShck])-0.1;
        maxval=max([fShck;fNoShck])+0.2;
        delval=(maxval-minval)/20;
        ValsToTest = [minval:delval:maxval];
        for z=ValsToTest
            alpha=[alpha,sum(fShck>z)/length(fShck)];
            beta=[beta,sum(fNoShck>z)/length(fNoShck)];
        end
        [val,ind]=min(alpha-beta);
        RocValSfvsSk{mm}(spk)=sum(alpha-beta)/length(beta)+0.5;
        
        AllVals = [fShck;fNoShck];
        for shuff = 1:NumShuffles
            AllVals = AllVals(randperm(length(AllVals),length(AllVals)));
            fShck = AllVals(1:floor(length(AllVals)/2));
            fNoShck = AllVals(floor(length(AllVals)/2)+1:end);
            alpha=[];
            beta=[];
            
            for z=ValsToTest
                alpha=[alpha,sum(fShck>z)/length(fShck)];
                beta=[beta,sum(fNoShck>z)/length(fNoShck)];
            end
            RocValrand(shuff)=sum(alpha-beta)/length(beta)+0.5;
        end
        RocValSfvsSkrand{mm}(spk) = nanmean(RocValrand);
        
        %         hist(RocValrand,100)
        %         line([1 1]* RocVal{mm}(spk),ylim)
        if RocValSfvsSk{mm}(spk)<prctile(RocValrand,5)
            IsSigSfvsSk{mm}(spk) = -1; % safe preferring
        elseif RocValSfvsSk{mm}(spk)>prctile(RocValrand,95)
            IsSigSfvsSk{mm}(spk) = 1; % shock preferring
        else
            IsSigSfvsSk{mm}(spk) = 0;
        end
        
        %         keyboard
        %         clf
    end
end



cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves
% load('BRTuning_Wake_Explo_PFC.mat') % Use this to be sure there is no leak
% load('BRTuning_Freezing_PFC.mat')
load('BRTuning_Wake_PFC.mat')
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

NumMice = 7;
AllSpk = [];
AllPAnova = [];
AllSpk_CV = [];
AlSfVsSk = [];
for mm=1:NumMice
    AllSpk = [AllSpk;MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:)];
    AllSpk_CV = [AllSpk_CV;MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:)];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
    AlSfVsSk = [AlSfVsSk,IsSigSfvsSk{mm}];
end
plim = 0.01;
AllSpk = AllSpk(:,1:22);
FreqLims = FreqLims(:,1:22)
AllSpk = smooth2a(nanzscore(AllSpk')',0,1);

figure
errorbar(FreqLims,nanmean(AllSpk(AlSfVsSk==-1 & AllPAnova<plim,:)),stdError(AllSpk(AlSfVsSk==-1 & AllPAnova<plim,:)))
hold on
errorbar(FreqLims,nanmean(AllSpk(AlSfVsSk==1 & AllPAnova<plim,:)),stdError(AllSpk(AlSfVsSk==1 & AllPAnova<plim,:)))
legend('Sf','Sk')

% Get best frequency
for sp = 1:size(AllSpk,1)
    FreqLims.*AllSpk(spk,:)

[val,ind] = max(AllSpk(AlSfVsSk==-1 & AllPAnova<plim,:)');
SafeFreq = FreqLims(ind);
[val,ind] = max(AllSpk(AlSfVsSk==1 & AllPAnova<plim,:)');
ShockFreq = FreqLims(ind);

figure,MakeSpreadAndBoxPlot_SB({ShockFreq,SafeFreq},{},[],{'Shock','Safe'},1)
ranksum(ShockFreq,SafeFreq)











