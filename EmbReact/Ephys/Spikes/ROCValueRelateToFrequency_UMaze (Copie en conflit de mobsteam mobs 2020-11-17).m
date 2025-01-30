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
load(['OverallInfoPhysioSpikes',num2str(WndwSz/1e4),'.mat'])
% 
% for mm=1:length(MiceNumber)
%     
%     for spk = 1:size(MouseByMouse.FR{mm},1)
%         
%         fShck = MouseByMouse.FR{mm}(spk,find(MouseByMouse.LinPos{mm}<0.4))';
%         fNoShck = MouseByMouse.FR{mm}(spk,find(MouseByMouse.LinPos{mm}>0.6))';
%         alpha=[];
%         beta=[];
%         minval=min([fShck;fNoShck])-0.1;
%         maxval=max([fShck;fNoShck])+0.2;
%         delval=(maxval-minval)/20;
%         ValsToTest = [minval:delval:maxval];
%         for z=ValsToTest
%             alpha=[alpha,sum(fShck>z)/length(fShck)];
%             beta=[beta,sum(fNoShck>z)/length(fNoShck)];
%         end
%         [val,ind]=min(alpha-beta);
%         RocVal{mm}(spk)=sum(alpha-beta)/length(beta)+0.5;
%         
%         AllVals = [fShck;fNoShck];
%         for shuff = 1:NumShuffles
%             AllVals = AllVals(randperm(length(AllVals),length(AllVals)));
%             fShck = AllVals(1:floor(length(AllVals)/2));
%             fNoShck = AllVals(floor(length(AllVals)/2)+1:end);
%             alpha=[];
%             beta=[];
%             
%             for z=ValsToTest
%                 alpha=[alpha,sum(fShck>z)/length(fShck)];
%                 beta=[beta,sum(fNoShck>z)/length(fNoShck)];
%             end
%             RocValrand(shuff)=sum(alpha-beta)/length(beta)+0.5;
%         end
%         
%         %         hist(RocValrand,100)
%         %         line([1 1]* RocVal{mm}(spk),ylim)
%         if RocVal{mm}(spk)<prctile(RocValrand,2.5)
%             IsSig{mm}(spk) = -1;
%         elseif RocVal{mm}(spk)>prctile(RocValrand,97.5)
%             IsSig{mm}(spk) = 1;
%         else
%             IsSig{mm}(spk) = 0;
%         end
%         
%         %         keyboard
%         %         clf
%     end
% end



% save('SkVsSfROCValueAllUnits_Maze.m','RocVal','IsSig')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
% load('PFCUnitFiringOnOBFrequencyFreezing.mat')
figure
if size(MeanSpk{mm},2)==60
    FreqLims=[2:0.15:11];
else
    FreqLims=[2.5:0.15:6];
end
% FreqLims=[2.5:0.15:6];

%% Just the sig units
GoodNeur = [];
PNeur = [];
RNeur = [];
AllSpk=[];
AllW = [];
AllWS = [];
AllPAnova= [];
for mm=1:length(MiceNumber)
    
    AllW = [AllW, 0.5-RocValSfvsSk{mm}(find(IsPFCNeuron{mm}))];
    GoodNeur = [GoodNeur,IsSigSfvsSk{mm}(find(IsPFCNeuron{mm}))];
    
    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
        AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];

end

fig=figure;
subplot(121)
pie([sum(GoodNeur<0),sum(GoodNeur==0),sum(GoodNeur>0)])
colormap([UMazeColors('safe');[1 1 1];UMazeColors('shock')])
legend({'Neg','NonSig','Pos'},'Location','NorthWestOutside')
colormap redblue
subplot(122)
histogram(AllW(find(abs(GoodNeur)==0)),[-0.4:0.01:0.4],'FaceColor',[0.6 0.6 0.6],'Normalization','probability')
hold on
histogram(AllW(find(abs(GoodNeur)>0)),[-0.4:0.01:0.4],'FaceColor',[0.5 0 0.5],'Normalization','probability')
legend({'NonSig','Sig'})
fig.Position = [2272 174 1153 680];


% AllSpk = AllSpk(:,5:28);
figure
A = nanzscore(AllSpk(find(GoodNeur==-1,:)');
[val,ind] = max(A);
ind1 = ind;
A = sortrows([ind;A]');
A = A(:,2:end);
A(find(sum(isnan(A)')),:) = [];
subplot(121)
imagesc(FreqLims,1:size(A,1),SmoothDec(A,[0.1 1]))
clim([-1.5 1.5])
title('Safe Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')

B = nanzscore(AllSpk(GoodNeur==1,:)');
[val,ind] = max(B);
B = sortrows([ind;B]');
B = B(:,2:end);
B(find(sum(isnan(B)')),:) = [];
subplot(122)
imagesc(FreqLims,1:size(B,1),SmoothDec(B,[0.1 1]))
clim([-1.5 1.5])
title('Shock Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')

figure
C = nanzscore(AllSpk(:,:)');
[val,indall] = max(C);

A = {FreqLims(ind1),FreqLims(ind)};
Cols = {UMazeColors('safe'),UMazeColors('shock')};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p1,h] = ranksum(FreqLims(ind1),FreqLims(ind));
sigstar_DB({[1,2]},p1)
set(gca,'XTick',[1:2],'XTickLabel',{'SafePref','ShockPref'})
ylabel('Preferred frequency')
set(gca,'LineWidth',2,'FontSize',15), box off


figure
clf
subplot(121)
clear dat mnval
AllFreq = FreqLims(indall);
for shuff = 1:10000
    temp = AllFreq(randsample(length(AllFreq),length(ind1)));
    [Y,X] = hist(temp,FreqLims);
    dat(shuff,:) = runmean(((Y)/sum(Y)),3);
    mnval(shuff) = nanmean(temp);
end
nhist(mnval,200,'noerror')
hold on
line([1 1]*prctile(mnval,5),ylim,'color','k','linewidth',3)
plot(nanmean(FreqLims(ind1)),300,'.','MarkerSize',30,'Color',UMazeColors('safe'))
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency')
pval = sum(mnval<nanmean(FreqLims(ind1)))/length(mnval) ;
title(num2str(pval))
subplot(122)
clear dat mnval
AllFreq = FreqLims(indall);
for shuff = 1:10000
    temp = AllFreq(randsample(length(AllFreq),length(ind)));
    [Y,X] = hist(temp,FreqLims);
    dat(shuff,:) = runmean(((Y)/sum(Y)-Ydef),3);
    mnval(shuff) = nanmean(temp);
end
nhist(mnval,200,'noerror')
hold on
line([1 1]*prctile(mnval,95),ylim,'color','k','linewidth',3)
plot(nanmean(FreqLims(ind)),300,'.','MarkerSize',30,'Color',UMazeColors('shock'))
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency')
pval = sum(mnval>nanmean(FreqLims(ind)))/length(mnval) ;
title(num2str(pval))

% figure
% A = nanzscore(AllSpk(find(GoodNeur~=0),:)');
% [val,ind] = max(A);
% A = sortrows([AllW(find(GoodNeur~=0));A]');
% A = A(:,2:end);
% imagesc(FreqLims,1:size(A,1),SmoothDec(A,[0.1 2]))
% clim([-1.5 1.5])
% [R,P] = corrcoef(FreqLims(ind),AllW(find(GoodNeur~=0)))



%% Look at overall responses

clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice

MiceNumber=[490,507,508,509,510,512,514];
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
% load('SkVsSfROCValueAllUnits_Maze.mat')

SpeedLim = 3;
WndwSz = 0.1*1e4;

for mm=1:length(MiceNumber)
    mm
    clear Dir Spikes numNeurons NoiseEpoch FreezeEpoch Vtsd StimEpoch MovEpoch
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    
    % epochs
    NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    
    % spikes
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    for sp = 1:length(Spikes)
        Q = MakeQfromS(tsdArray(Spikes{sp}),0.1*1e4);
        
        [M,TUp] = PlotRipRaw(Q,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
        NeurResp_Start_Safe{mm}(sp,:) = M(:,2);
        [M,TUp] = PlotRipRaw(Q,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above')),'s'),2000,0,0);
        NeurResp_Stop_Safe{mm}(sp,:) = M(:,2);

        [M,TUp] = PlotRipRaw(Q,Start(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
        NeurResp_Start_Shock{mm}(sp,:) = M(:,2);
        [M,TUp] = PlotRipRaw(Q,Stop(and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below')),'s'),2000,0,0);
        NeurResp_Stop_Shock{mm}(sp,:) = M(:,2);
        
    end
end
    
figure
AllNeurResp_Start_Safe = [];
AllNeurResp_Stop_Safe = [];
AllNeurResp_Start_Shock = [];
AllNeurResp_Stop_Shock = [];
AllIsSig = [];
for mm=1:length(MiceNumber)
    
    AllNeurResp_Start_Safe = [AllNeurResp_Start_Safe;NeurResp_Start_Safe{mm}];
    AllNeurResp_Stop_Safe = [AllNeurResp_Stop_Safe;NeurResp_Stop_Safe{mm}];
    AllNeurResp_Start_Shock = [AllNeurResp_Start_Shock;NeurResp_Start_Shock{mm}];
    AllNeurResp_Stop_Shock = [AllNeurResp_Stop_Shock;NeurResp_Stop_Shock{mm}];
    AllIsSig = [AllIsSig,IsSig{mm}];

end

ZScoreTogether = nanzscore([AllNeurResp_Start_Safe,AllNeurResp_Stop_Safe,AllNeurResp_Start_Shock,AllNeurResp_Stop_Shock]')';
AllNeurResp_Start_Safe = ZScoreTogether(:,1:40);
AllNeurResp_Stop_Safe = ZScoreTogether(:,41:80);
AllNeurResp_Start_Shock = ZScoreTogether(:,81:120);
AllNeurResp_Stop_Shock = ZScoreTogether(:,121:160);

figure
subplot(121)
plot(nanmean(nanzscore(AllNeurResp_Start_Safe(AllIsSig==1,:))))
hold on
plot(nanmean(AllNeurResp_Start_Safe(AllIsSig==-1,:)))
subplot(122)
plot(nanmean(AllNeurResp_Start_Shock(AllIsSig==1,:)))
hold on
plot(nanmean(AllNeurResp_Start_Shock(AllIsSig==-1,:)))

plot(AllNeurResp_Start_Safe(AllIsSig==1,:))

