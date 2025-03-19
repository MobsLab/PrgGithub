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
% load('PFCUnitFiringOnOBFrequencyEPMOnlySpeedCorrBroadFreq.mat')
% load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleepNoFear.mat')
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
    
%     AllW = [AllW, 0.5-RocValSfvsSk{mm}];
%     AllWMov = [AllWMov, 0.5-RocValFzvsMov{mm}];

%     GoodNeur = [GoodNeur,IsSigSfvsSk{mm}];
%     GoodNeurMov = [GoodNeurMov,IsSigFzvsMov{mm}];

    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
%     PNeur = [PNeur,PSpk{mm}(find(IsPFCNeuron{mm}))];

end
plim =1%0.05;%/(length(PNeur));
figure
A = smooth2a(nanzscore(AllSpk(find(PNeur<plim & GoodNeur==-1),:)')',0,0);
A(find(sum(isnan(A)')),:) = [];
A=A';
[val,ind] = max(A);
ind1 = ind;
A = sortrows([ind;A]');
A = A(:,2:end)';
SafePrefMat = A';
SafePrefFreq = FreqLims(ind1);

B = smooth2a(nanzscore(AllSpk(find(PNeur<plim & GoodNeur==1),:)')',0,0)
B(find(sum(isnan(B)')),:) = [];
B = B';
[val,ind] = max(B);
B = sortrows([ind;B]');
B = B(:,2:end)';
ShockPreMat = B';
ShockPrefFreq = FreqLims(ind);

subplot(131)
imagesc(FreqLims,[1:size(SafePrefMat,1)]/size(SafePrefMat,1),SmoothDec(SafePrefMat,[0.01 1]))
hold on
plot(sort(SafePrefFreq),[1:size(SafePrefMat,1)]/size(SafePrefMat,1),'color','b','linewidth',2)
plot(sort(ShockPrefFreq),[1:size(ShockPreMat,1)]/size(ShockPreMat,1),'color','r','linewidth',2)
clim([-1.5 1.5])
title('Safe Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')
freezeColors(gca)


subplot(132)
imagesc(FreqLims,[1:size(ShockPreMat,1)]/size(ShockPreMat,1),SmoothDec(ShockPreMat,[0.01 1]))
hold on
plot(sort(SafePrefFreq),[1:size(SafePrefMat,1)]/size(SafePrefMat,1),'color','b','linewidth',2)
plot(sort(ShockPrefFreq),[1:size(ShockPreMat,1)]/size(ShockPreMat,1),'color','r','linewidth',2)
clim([-1.5 1.5])
title('Shock Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')
freezeColors(gca)

subplot(2,3,3)
C = nanzscore(AllSpk(:,:)');
[val,indall] = max(C);
A = {SafePrefFreq,ShockPrefFreq};
Cols = {UMazeColors('safe'),UMazeColors('shock')};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{})
[p1,h] = ranksum(FreqLims(ind1),FreqLims(ind));
sigstar_DB({[1,2]},p1)
set(gca,'XTick',[1:2],'XTickLabel',{'SafePref','ShockPref'})
ylabel('Preferred frequency')
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(2,6,11)
pie([sum(A{1}<5),sum(A{1}>5)])
colormap([UMazeColors('Safe')*0.6;UMazeColors('Safe')])
freezeColors(gca)

subplot(2,6,12)
pie([sum(A{2}<5),sum(A{2}>5)])
colormap([UMazeColors('Shock')*0.6;UMazeColors('Shock')])
freezeColors(gca)

[h,p] = prop_test([sum(A{1}<5) sum(A{2}<5)],[sum(A{1}>0) sum(A{2}>0)],0)

