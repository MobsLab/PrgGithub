clear all
channelstoAnalyse={'B'};
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]
binsize=1;

% Get data
CtrlEphys=[242,248,244,253,254,259,299,394,395,402,403,450,451];
% Excluded mice (too much noise)=258
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[2,3,4,6,7:length(Dir.path)];

n=1;
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';

for m=1:length(KeepFirstSessionOnly)
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    NoFreezeEpoch=TotEpoch-FreezeEpoch;
    NoFreezeEpoch=NoFreezeEpoch-TotalNoiseEpoch;
    NoFreezeEpoch=and(NoFreezeEpoch,intervalSet(0,1400*1e4));
    FreezeEpoch=and(FreezeEpoch,intervalSet(0,1400*1e4));
    DurFz=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
    DurNoFz=sum(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
    
    if DurFz>10 & DurNoFz>10
        for cc=1:length(channelstoAnalyse)
            load([channelstoAnalyse{cc},'_Low_Spectrum.mat'])
            flow=find(Spectro{3}<FreqRange(1),1,'last');
            fhigh=find(Spectro{3}<FreqRange(2),1,'last');
            flowOut=find(Spectro{3}<OutFreqRange(1),1,'last');
            fhighOut=find(Spectro{3}<OutFreqRange(2),1,'last');
            Powtsd{cc}=tsd(Spectro{2}*1e4,(mean(Spectro{1}(:,flow:fhigh)')./mean(Spectro{1}(:,flowOut:fhighOut)'))');
        end
        
        % Roc curves constructed using thresholds from all Fz and Noz Fz,
        % to see how the evolve at onset and offset
        begin=Start(FreezeEpoch);
        endin=Stop(FreezeEpoch);
        Fr{cc,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(1*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    
                    Fr{cc,1}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        begin=Start(NoFreezeEpoch);
        endin=Stop(NoFreezeEpoch);
        Fr{cc,2}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    
                    Fr{cc,2}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        Fr{cc,3}=zeros(1,1);
        dur=1400*1e4;
        index=1;
        numbins=round(dur/(binsize*1E4));
        epdur=(dur/1E4)/numbins;
        for nn=1:numbins
            startcounting=(nn-1)*dur/numbins;
            stopcounting=nn*dur/numbins;
            for cc=1:length(channelstoAnalyse)
                Fr{cc,3}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
            end
            index=index+1;
        end
        
        
        for cc=1:length(channelstoAnalyse)
            alpha=[];
            beta=[];
            minval=min([Fr{cc,2};Fr{cc,1}]);
            maxval=max([Fr{cc,2};Fr{cc,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr{cc,2};Fr{cc,1}])-delval:delval:max([Fr{cc,2};Fr{cc,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr{cc,2}>z)/length(Fr{cc,2})];
                beta=[beta,sum(Fr{cc,1}>z)/length(Fr{cc,1})];
            end
            %             plot(alpha,beta,'color',cols(cc,:),'linewidth',2), hold on
            [val,ind]=min(alpha-beta);
            %             plot(alpha(ind),beta(ind),'*'), hold on
            RocVal(m,cc)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha{cc}(m,:)=alpha;
            ROCBeta{cc}(m,:)=beta;
        end
        
        ROCGUess=tsd([binsize:binsize:1400]*1e4,Fr{cc,3}>ValsToTest(ind))
        FreezeEpoch=dropShortIntervals(FreezeEpoch,4*1e4);
        FreezeEpochBis=FreezeEpoch;
        for fr_ep=1:length(Start(FreezeEpoch))
            LitEp=subset(FreezeEpoch,fr_ep);
            NotLitEp=FreezeEpoch-LitEp;
            StopEp=intervalSet(Stop(LitEp)-4*1e4,Stop(LitEp)+4*1e4);
            if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
                FreezeEpochBis=FreezeEpochBis-LitEp;
            end
        end
        FreezeEpochBis=CleanUpEpoch(FreezeEpochBis);

        [M_Start{m},T]=PlotRipRaw(ROCGUess,Start(FreezeEpoch,'s'),10*1000,0,0);
        [M_Stop{m},T]=PlotRipRaw(ROCGUess,Stop(FreezeEpoch,'s'),10*1000,0,0);
        [M_Start_Clean{m},T]=PlotRipRaw(ROCGUess,Start(FreezeEpochBis,'s'),10*1000,0,0);
        [M_Stop_Clean{m},T]=PlotRipRaw(ROCGUess,Stop(FreezeEpochBis,'s'),10*1000,0,0);
        
        
        % Roc Curves on beginning  of fzing periods
        begin=Start(FreezeEpochBis);
        endin=Start(FreezeEpochBis)+4*1e4;
        Fr_Start{cc,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    Fr_Start{cc,1}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        begin=Start(FreezeEpochBis)-4*1e4;
        endin=Start(FreezeEpochBis);
        Fr_Start{cc,2}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    Fr_Start{cc,2}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        % Do the ROC analysis
        for cc=1:length(channelstoAnalyse)
            alpha=[];
            beta=[];
            minval=min([Fr_Start{cc,2};Fr_Start{cc,1}]);
            maxval=max([Fr_Start{cc,2};Fr_Start{cc,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr_Start{cc,2};Fr_Start{cc,1}])-delval:delval:max([Fr_Start{cc,2};Fr_Start{cc,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr_Start{cc,2}>z)/length(Fr_Start{cc,2})];
                beta=[beta,sum(Fr_Start{cc,1}>z)/length(Fr_Start{cc,1})];
            end
            RocVal_Start(m,cc)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha_Start{cc}(m,:)=alpha;
            ROCBeta_Start{cc}(m,:)=beta;
        end
        
        % Roc Curves on  end of fzing periods
        begin=Stop(FreezeEpochBis)-4*1e4;
        endin=Stop(FreezeEpochBis);
        Fr_Stop{cc,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    Fr_Stop{cc,1}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        begin=Stop(FreezeEpochBis);
        endin=Stop(FreezeEpochBis)+4*1e4;
        Fr_Stop{cc,2}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for cc=1:length(channelstoAnalyse)
                    Fr_Stop{cc,2}(index,1)=mean(Data(Restrict(Powtsd{cc},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        % Do the ROC analysis
        for cc=1:length(channelstoAnalyse)
            alpha=[];
            beta=[];
            minval=min([Fr_Stop{cc,2};Fr_Stop{cc,1}]);
            maxval=max([Fr_Stop{cc,2};Fr_Stop{cc,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr_Stop{cc,2};Fr_Stop{cc,1}])-delval:delval:max([Fr_Stop{cc,2};Fr_Stop{cc,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr_Stop{cc,2}>z)/length(Fr_Stop{cc,2})];
                beta=[beta,sum(Fr_Stop{cc,1}>z)/length(Fr_Stop{cc,1})];
            end
            RocVal_Stop(m,cc)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha_Stop{cc}(m,:)=alpha;
            ROCBeta_Stop{cc}(m,:)=beta;
        end
        
        clear Fr alpha beta Powtsd
    else
        for cc=1:length(channelstoAnalyse)
            RocVal(m,cc)=NaN;
            ROCAlpha{cc}(m,:)=nan(1,23);
            ROCBeta{cc}(m,:)=nan(1,23);
        end
    end
    
end

cd /media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/
load('ROCOnsetOffset','RocVal_Stop','ROCAlpha_Stop','ROCBeta_Stop','RocVal_Start','ROCBeta_Start','ROCAlpha_Start',...
'M_Start','M_Stop','M_Start_Clean','M_Stop_Clean');
% 
figure
subplot(121)
plot(ROCAlpha_Start{1}',ROCBeta_Start{1}','r'), hold on
plot(ROCAlpha_Stop{1}',ROCBeta_Stop{1}','k')
subplot(122)
PlotErrorBarN_KJ([RocVal_Start,RocVal_Stop],'newfig',0)
ylim([0.4 0.8])
set(gca,'XTick',[1,2],'XTickLabel',{'On','Off'})
ylabel('ROC value')


NewAlpha=[0:0.01:1];
for m=3:length(KeepFirstSessionOnly)
    OldAlpha=ROCAlpha_Start{1}(m,:);
    OldBeta=ROCBeta_Start{1}(m,:);
    while sum(OldAlpha==1)>1
        OldBeta(find(OldAlpha==1,1,'last'))=[];
        OldAlpha(find(OldAlpha==1,1,'last'))=[];
    end
    while sum(OldAlpha==0)>1
        OldBeta(find(OldAlpha==0,1,'first'))=[];
        OldAlpha(find(OldAlpha==0,1,'first'))=[];
    end
    [C,IA,IC] = unique(OldAlpha);
    OldBeta=OldBeta(IA);
    OldAlpha=OldAlpha(IA);
    NewBeta_Start(m-2,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end

for m=3:length(KeepFirstSessionOnly)
    OldAlpha=ROCAlpha_Stop{1}(m,:);
    OldBeta=ROCBeta_Stop{1}(m,:);
    while sum(OldAlpha==1)>1
        OldBeta(find(OldAlpha==1,1,'last'))=[];
        OldAlpha(find(OldAlpha==1,1,'last'))=[];
    end
    while sum(OldAlpha==0)>1
        OldBeta(find(OldAlpha==0,1,'first'))=[];
        OldAlpha(find(OldAlpha==0,1,'first'))=[];
    end
    [C,IA,IC] = unique(OldAlpha);
    OldBeta=OldBeta(IA);
    OldAlpha=OldAlpha(IA);
    NewBeta_Stop(m-2,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end
figure
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta_Start),[stdError(NewBeta_Start);stdError(NewBeta_Start)]','k');
set(hl,'Color',[0.4 0.4 0.4]*0.5,'linewidth',2,'linestyle',':')
set(hp,'FaceColor',[0.4 0.4 0.4])
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta_Stop),[stdError(NewBeta_Stop);stdError(NewBeta_Stop)]','k');
set(hl,'Color',[0.4 0.4 0.4],'linewidth',2)
line([0 1],[0 1],'color','k','linestyle',':','linewidth',2)
xlim([0 1]),ylim([0 1]),box off

figure
line([0.7 1.3],[1 1]*nanmedian(RocVal_Start([3,5,6:end])),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(RocVal_Stop([3,5,6:end])),'color','k','linewidth',2)
handlesplot=plotSpread({RocVal_Start([3,5,6:end]),RocVal_Stop([3,5,6:end])},'distributionColors',[0 0 0;0.4 0.4 0.4]); hold on
set(handlesplot{1},'MarkerSize',20)
ylim([0.4 0.9])
set(gca,'XTick',[1,2],'XTickLabel',{'FZ start','FZ end'})


%% BoxPlot version

PlotErrorBarN_KJ([RocVal_Start,RocVal_Stop],'newfig',0)
ylim([0.4 0.8])
set(gca,'XTick',[1,2],'XTickLabel',{'On','Off'})
ylabel('ROC value')

figure
clf
Vals = {RocVal_Start([3,5,6:end]);RocVal_Stop([3,5,6:end])};
XPos = [1.1,1.9];

Cols = [0.9,0.9,1;1,0.9,0.9];
for k = 1:2
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Cols(k,:),'lineColor',Cols(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    
    handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',22)
    handlesplot=plotSpread(X,'distributionColors',Cols(k,:)*0.8,'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',12)
    
end

xlim([0.5 2.4])
ylim([0.4 0.9])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Onset','Offset'},'linewidth',1.5,'YTick',[0.5:0.2:0.9])
ylabel('ROC value')
box off

figure
subplot(121)
AllStart=[];
for m=3:length(KeepFirstSessionOnly)
plot(M_Start_Clean{m}(:,1),(M_Start_Clean{m}(:,2)),'r'), hold on,
AllStart=[AllStart,M_Start_Clean{m}(1:20,2)];
end
g=shadedErrorBar(M_Stop{m}(1:20,1),nanmean(AllStart'),stdError(AllStart'),'r')
xlim([-4 4])
ylim([0 1])
title('Start Freezing')
line([0 0],xlim)
xlabel('time (s)')
subplot(122)
AllStop=[];
for m=3:length(KeepFirstSessionOnly)
plot(M_Stop_Clean{m}(:,1),(M_Stop_Clean{m}(:,2)),'k'), hold on,
AllStop=[AllStop,M_Stop_Clean{m}(1:20,2)];
end
g=shadedErrorBar(M_Stop_Clean{m}(1:20,1),nanmean(AllStop'),stdError(AllStop'))
xlim([-4 4])
ylim([0 1])
title('Stop Freezing')
line([0 0],xlim)
xlabel('time (s)')

