clear all
% MiceNumber=[490,507,508,509,510,512,514];
MiceNumber=[490,507,508,510,512,514];
SessNames={'EPM'};
Dir = PathForExperimentsEmbReact(SessNames{1});

WndwSz = 0.5*1e4;
Recalc = 0;
NumShuffles = 1000;

nbin=30;
nmouse=1;

SpeedLim = 0.1;
MovLim = 1;

for dd=1:length(Dir.path)
    MaxTime=0;
    clear AllS
    if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
        
        %% Get all the phases of spikes during both kinds of freezing
        for ddd=1:length(Dir.path{dd})
            
            % Go to location and load data
            cd(Dir.path{dd}{ddd})
            disp(Dir.path{dd}{ddd})
            load('SpikeData.mat')
            load('behavResources_SB.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch')
            
            
            for sp = 1:length(S)
                Q = MakeQfromS(tsdArray(S{sp}),WndwSz);
                fOpen = Data(Restrict(Q,Behav.ZoneEpoch{1}));
                fClose = Data(Restrict(Q,Behav.ZoneEpoch{2}));
                
                alpha=[];
                beta=[];
                minval=min([fOpen;fClose])-0.1;
                maxval=max([fOpen;fClose])+0.2;
                delval=(maxval-minval)/20;
                ValsToTest = [minval:delval:maxval];
                for z=ValsToTest
                    alpha=[alpha,sum(fOpen>z)/length(fOpen)];
                    beta=[beta,sum(fClose>z)/length(fClose)];
                end
                [val,ind]=min(alpha-beta);
                RocValOpenVsClosed{nmouse}(sp)=sum(alpha-beta)/length(beta)+0.5;
                
                AllVals = [fOpen;fClose];
                for shuff = 1:NumShuffles
                    AllVals = AllVals(randperm(length(AllVals),length(AllVals)));
                    fOpen = AllVals(1:floor(length(AllVals)/2));
                    fClose = AllVals(floor(length(AllVals)/2)+1:end);
                    alpha=[];
                    beta=[];
                    
                    for z=ValsToTest
                        alpha=[alpha,sum(fOpen>z)/length(fOpen)];
                        beta=[beta,sum(fClose>z)/length(fClose)];
                    end
                    RocValrand(shuff)=sum(alpha-beta)/length(beta)+0.5;
                end
                RocValOpenVsClosedrand{nmouse}(sp) = nanmean(RocValrand);
                
                if RocValOpenVsClosed{nmouse}(sp)<prctile(RocValrand,2.5)
                    IsSigOpenVsClosed{nmouse}(sp) = -1; % closed preferring
                elseif RocValOpenVsClosed{nmouse}(sp)>prctile(RocValrand,97.5)
                    IsSigOpenVsClosed{nmouse}(sp) = 1; % open preferring
                else
                    IsSigOpenVsClosed{nmouse}(sp) = 0;
                end
                
                
            end
        end
        nmouse=nmouse+1;
        
    end
end


FreqLimsFz=[2.5:0.15:6];
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
load('PFCUnitFiringOnOBFrequency.mat')
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency

% load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleepNoFear.mat')

AllFreq = [];
AllSpk = [];
GoodNeur = [];
for  mm = 1:6
    AllFreq = [AllFreq;MeanSpk{mm}];
    %     AllSpk = [AllSpk,(NeuronWeight.Open{mm}-NeuronWeight.Closed{mm})./(NeuronWeight.Open{mm}+NeuronWeight.Closed{mm})];
    GoodNeur = [GoodNeur,IsSigOpenVsClosed{mm}];
    
end
DelUnit = unique([find(sum(isnan((nanzscore(AllFreq(:,4:23)'))))),find(sum(isnan((nanzscore(AllFreq')))))]);
GoodNeur(DelUnit)=[];
AllFreq(DelUnit,:)=[];
AllFreq = zscore(AllFreq')';

OpenPref = SmoothDec((AllFreq(GoodNeur==1,:)),[0.01 1]);
[val,ind] = max(OpenPref');
FreqOpen = FreqLimsFz(ind);
OpenPref = sortrows([ind',OpenPref]);
OpenPref = OpenPref(:,2:end);
ClosePref = SmoothDec((AllFreq(GoodNeur==-1,:)),[0.01 1]);
[val,ind] = max(ClosePref');
ClosePref = sortrows([ind',ClosePref]);
ClosePref = ClosePref(:,2:end);
FreqClosed = FreqLimsFz(ind);


figure

subplot(131)
imagesc(FreqLimsFz,[1:size(ClosePref,1)]/size(ClosePref,1),SmoothDec(ClosePref,[0.01 1]))
hold on
plot(sort(FreqClosed),[1:size(ClosePref,1)]/size(ClosePref,1),'color','b','linewidth',2)
plot(sort(FreqOpen),[1:size(OpenPref,1)]/size(OpenPref,1),'color','r','linewidth',2)
clim([-1.5 1.5])
title('Closed Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')
freezeColors(gca)


subplot(132)
imagesc(FreqLimsFz,[1:size(OpenPref,1)]/size(OpenPref,1),SmoothDec(OpenPref,[0.01 1]))

hold on
plot(sort(FreqClosed),[1:size(ClosePref,1)]/size(ClosePref,1),'color','b','linewidth',2)
plot(sort(FreqOpen),[1:size(OpenPref,1)]/size(OpenPref,1),'color','r','linewidth',2)
clim([-1.5 1.5])
title('Open Preferring')
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB frequency')
ylabel('Neuron number')
freezeColors(gca)

subplot(2,3,3)
A = {FreqClosed,FreqOpen};
Cols = {UMazeColors('safe'),UMazeColors('shock')};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p1,h] = ranksum(FreqClosed,FreqOpen);
sigstar_DB({[1,2]},p1)
set(gca,'XTick',[1:2],'XTickLabel',{'Closed Pref','Open Pref'})
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


