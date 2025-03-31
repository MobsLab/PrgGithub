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
        if RocValSfvsSk{mm}(spk)<prctile(RocValrand,2.5)
            IsSigSfvsSk{mm}(spk) = -1; % safe preferring
        elseif RocValSfvsSk{mm}(spk)>prctile(RocValrand,97.5)
            IsSigSfvsSk{mm}(spk) = 1; % shock preferring
        else
            IsSigSfvsSk{mm}(spk) = 0;
        end
        
        %         keyboard
        %         clf
    end
end

for mm=1:length(MiceNumber)
    
    for spk = 1:size(MouseByMouse.FRMov{mm},1)
        
        fShck = MouseByMouse.FRMov{mm}(spk,find(MouseByMouse.LinPosMov{mm}<0.4))';
        fNoShck = MouseByMouse.FRMov{mm}(spk,find(MouseByMouse.LinPosMov{mm}>0.6))';
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
        RocValSfvsSkMov{mm}(spk)=sum(alpha-beta)/length(beta)+0.5;
        
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
        RocValSfvsSkMovrand{mm}(spk) = nanmean(RocValrand);
        
        %         hist(RocValrand,100)
        %         line([1 1]* RocVal{mm}(spk),ylim)
        if RocValSfvsSkMov{mm}(spk)<prctile(RocValrand,2.5)
            IsSigSfvsSkMov{mm}(spk) = -1; % safe preferring
        elseif RocValSfvsSkMov{mm}(spk)>prctile(RocValrand,97.5)
            IsSigSfvsSkMov{mm}(spk) = 1; % shock preferring
        else
            IsSigSfvsSkMov{mm}(spk) = 0;
        end
        
        %         keyboard
        %         clf
    end
end

for mm=1:length(MiceNumber)
    
    for spk = 1:size(MouseByMouse.FRMov{mm},1)
        
        
        ShockBins = find(MouseByMouse.LinPosFz{mm}<0.4);
        SafeBins = find(MouseByMouse.LinPosFz{mm}>0.6);
        TotBins = min([length(ShockBins),length(SafeBins)]);
        BinsFz = [SafeBins(randperm(length(SafeBins),TotBins)),ShockBins(randperm(length(ShockBins),TotBins))];
        fFz = MouseByMouse.FRFz{mm}(spk,BinsFz)';
        
        ShockBins = find(MouseByMouse.LinPosMov{mm}<0.4);
        SafeBins = find(MouseByMouse.LinPosMov{mm}>0.6);
        TotBins = min([length(ShockBins),length(SafeBins)]);
        BinsNoFz = [SafeBins(randperm(length(SafeBins),TotBins)),ShockBins(randperm(length(ShockBins),TotBins))];
        fNoFz = MouseByMouse.FRMov{mm}(spk,BinsNoFz)';
        
        alpha=[];
        beta=[];
        minval=min([fFz;fNoFz])-0.1;
        maxval=max([fFz;fNoFz])+0.2;
        delval=(maxval-minval)/20;
        ValsToTest = [minval:delval:maxval];
        for z=ValsToTest
            alpha=[alpha,sum(fFz>z)/length(fFz)];
            beta=[beta,sum(fNoFz>z)/length(fNoFz)];
        end
        [val,ind]=min(alpha-beta);
        RocValFzvsMov{mm}(spk)=sum(alpha-beta)/length(beta)+0.5;
        
        AllVals = [fFz;fNoFz];
        for shuff = 1:NumShuffles
            AllVals = AllVals(randperm(length(AllVals),length(AllVals)));
            fFz = AllVals(1:floor(length(AllVals)/2));
            fNoFz = AllVals(floor(length(AllVals)/2)+1:end);
            alpha=[];
            beta=[];
            
            for z=ValsToTest
                alpha=[alpha,sum(fFz>z)/length(fFz)];
                beta=[beta,sum(fNoFz>z)/length(fNoFz)];
            end
            RocValrand(shuff)=sum(alpha-beta)/length(beta)+0.5;
        end
        
        %         hist(RocValrand,100)
        %         line([1 1]* RocVal{mm}(spk),ylim)
        if RocValFzvsMov{mm}(spk)<prctile(RocValrand,2.5)
            IsSigFzvsMov{mm}(spk) = -1; % nofz preferring
        elseif RocValFzvsMov{mm}(spk)>prctile(RocValrand,97.5)
            IsSigFzvsMov{mm}(spk) = 1; % fz preferring
        else
            IsSigFzvsMov{mm}(spk) = 0;
        end
        
        %         keyboard
        %         clf
    end
end


% save('SkVsSfandMovFzROCValueAllUnits_Maze.m','RocValFzvsMov','IsSigFzvsMov','IsSigSfvsSk','RocValSfvsSk')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
% load('PFCUnitFiringOnOBFrequencyFreezing.mat')
figure
if size(MeanSpk{1},2)==60
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
AllWMov = [];
AllWS = [];
GoodNeurMov= [];
for mm=1:length(MiceNumber)
    
    AllW = [AllW, 0.5-RocValSfvsSk{mm}];
    AllWMov = [AllWMov, 0.5-RocValFzvsMov{mm}];

    GoodNeur = [GoodNeur,IsSigSfvsSk{mm}];
    GoodNeurMov = [GoodNeurMov,IsSigFzvsMov{mm}];

    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    
end

subplot(2,3,5)
pie([nanmean(GoodNeur==1),nanmean(GoodNeur==0),nanmean(GoodNeur==-1)])
colormap([UMazeColors('Shock');[1 1 1];UMazeColors('Safe')])
freezeColors(gca)
legend('Shock pref','No Pref','Safe pref')

subplot(2,3,1)
pie([nanmean(GoodNeurMov(GoodNeur==1)==1),nanmean(GoodNeurMov(GoodNeur==1)==0),nanmean(GoodNeurMov(GoodNeur==1)==-1)])
colormap([UMazeColors('Shock')*0.3;[1 1 1];UMazeColors('Shock')*0.6])
freezeColors(gca)
legend('Fz pref','No Pref','Mov pref')

subplot(2,3,3)
pie([nanmean(GoodNeurMov(GoodNeur==-1)==1),nanmean(GoodNeurMov(GoodNeur==-1)==0),nanmean(GoodNeurMov(GoodNeur==-1)==-1)])
colormap([UMazeColors('Safe')*0.3;[1 1 1];UMazeColors('Safe')*0.6])
legend('Fz pref','No Pref','Mov pref')
% AllSpk = AllSpk(:,5:28);
for g=-1:1
figure
A = nanzscore(AllSpk(find(GoodNeur==-1),:)');
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
end

figure
clf
subplot(121)
clear dat mnval
AllFreq = FreqLims(indall);
for shuff = 1:10000
    temp = AllFreq(randsample(length(AllFreq),length(ind1)));
    [Y,X] = hist(temp,FreqLims);
    dat(shuff,:) = runmean(((Y)/sum(Y)-Ydef),3);
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
            TotalEpoch = intervalSet(0,max(Range(Q)));
    Q = Restrict(Q,TotalEpoch-NoiseEpoch);

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
    AllIsSig = [AllIsSig,IsSigSfvsSk{mm}];

end

ZScoreTogether = nanzscore([AllNeurResp_Start_Safe,AllNeurResp_Stop_Safe,AllNeurResp_Start_Shock,AllNeurResp_Stop_Shock]')';
AllNeurResp_Start_Safe = ZScoreTogether(:,1:40);
AllNeurResp_Stop_Safe = ZScoreTogether(:,41:80);
AllNeurResp_Start_Shock = ZScoreTogether(:,81:120);
AllNeurResp_Stop_Shock = ZScoreTogether(:,121:160);

figure
subplot(121)
plot(nanmean((AllNeurResp_Start_Safe(GoodNeur==1 & GoodNeurMov==-1,:))))
hold on
plot(nanmean(AllNeurResp_Start_Safe(GoodNeur==-1 & GoodNeurMov==-1,:)))
subplot(122)
plot(nanmean(AllNeurResp_Start_Shock(GoodNeur==1 & GoodNeurMov==-1,:)))
hold on
plot(nanmean(AllNeurResp_Start_Shock(GoodNeur==-1 & GoodNeurMov==-1,:)))


