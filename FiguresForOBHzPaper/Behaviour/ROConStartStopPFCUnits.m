clear all
cols=[0,0,0;0.5,0.5,0.5]
binsize=1;

% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');

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
        
        % Spike loading
        % Spikes
        load('SpikeData.mat')
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        
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
        
        
        % Roc curves constructed using thresholds from all Fz and Noz Fz,
        % to see how the evolve at onset and offset
        
        begin=Start(FreezeEpoch);
        endin=Stop(FreezeEpoch);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(1*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for sp=1:length(numNeurons)
                    Fr{sp,1}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        begin=Start(NoFreezeEpoch);
        endin=Stop(NoFreezeEpoch);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for sp=1:length(numNeurons)
                    Fr{sp,2}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        dur=1400*1e4;
        index=1;
        numbins=round(dur/(binsize*1E4));
        epdur=(dur/1E4)/numbins;
        for nn=1:numbins
            startcounting=(nn-1)*dur/numbins;
            stopcounting=nn*dur/numbins;
            for sp=1:length(numNeurons)
                Fr{sp,3}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
            end
            index=index+1;
        end
        
        
        for sp=1:length(numNeurons)
            alpha=[];
            beta=[];
            minval=min([Fr{sp,2};Fr{sp,1}]);
            maxval=max([Fr{sp,2};Fr{sp,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr{sp,2};Fr{sp,1}])-delval:delval:max([Fr{sp,2};Fr{sp,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr{sp,2}>z)/length(Fr{sp,2})];
                beta=[beta,sum(Fr{sp,1}>z)/length(Fr{sp,1})];
            end
            %             plot(alpha,beta,'color',cols(cc,:),'linewidth',2), hold on
            RocVal{m}(sp)=sum(beta-alpha)/length(beta)+0.5;
            if RocVal{m}(sp)<0.5
                [val,ind]=max(alpha-beta);
                ROCGUess=tsd([binsize:binsize:1400]*1e4,Fr{sp,3}<ValsToTest(ind));
            else
                [val,ind]=min(alpha-beta);
                ROCGUess=tsd([binsize:binsize:1400]*1e4,Fr{sp,3}>ValsToTest(ind));
                
            end
            %             plot(alpha(ind),beta(ind),'*'), hold on
            ROCAlpha{m}(sp,:)=alpha;
            ROCBeta{m}(sp,:)=beta;
            
            
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
            
            [M_Start{m}{sp},T]=PlotRipRaw(ROCGUess,Start(FreezeEpoch,'s'),10*1000,0,0);
            [M_Stop{m}{sp},T]=PlotRipRaw(ROCGUess,Stop(FreezeEpoch,'s'),10*1000,0,0);
            [M_Start_Clean{m}{sp},T]=PlotRipRaw(ROCGUess,Start(FreezeEpochBis,'s'),10*1000,0,0);
            [M_Stop_Clean{m}{sp},T]=PlotRipRaw(ROCGUess,Stop(FreezeEpochBis,'s'),10*1000,0,0);
        end
        clear Fr
        AllSt = [];AllSp=[];
        for sp=1:length(numNeurons)
            AllSt = [AllSt,M_Start{m}{sp}(:,2)];
            AllSp = [AllSp,M_Stop{m}{sp}(:,2)];
        end
        
        % Roc Curves on beginning  of fzing periods
        begin=Start(FreezeEpochBis);
        endin=Start(FreezeEpochBis)+4*1e4;
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for sp=1:length(numNeurons)
                    Fr_Start{sp,1}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        begin=Start(FreezeEpochBis)-4*1e4;
        endin=Start(FreezeEpochBis);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for sp=1:length(numNeurons)
                    Fr_Start{sp,2}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        % Do the ROC analysis
        for sp=1:length(numNeurons)
            alpha=[];
            beta=[];
            minval=min([Fr_Start{sp,2};Fr_Start{sp,1}]);
            maxval=max([Fr_Start{sp,2};Fr_Start{sp,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr_Start{sp,2};Fr_Start{sp,1}])-delval:delval:max([Fr_Start{sp,2};Fr_Start{sp,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr_Start{sp,2}>z)/length(Fr_Start{sp,2})];
                beta=[beta,sum(Fr_Start{sp,1}>z)/length(Fr_Start{sp,1})];
            end
            RocVal_Start{m}(sp)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha_Start{m}(sp,:)=alpha;
            ROCBeta_Start{m}(sp,:)=beta;
        end
                clear Fr

        % Roc Curves on  end of fzing periods
        begin=Stop(FreezeEpochBis)-4*1e4;
        endin=Stop(FreezeEpochBis);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(binsize*1E4));
            epdur=(dur/1E4)/numbins;
            for nn=1:numbins
                startcounting=begin(ff)+(nn-1)*dur/numbins;
                stopcounting=begin(ff)+nn*dur/numbins;
                for sp=1:length(numNeurons)
                    Fr_Stop{sp,1}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
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
                for sp=1:length(numNeurons)
                    Fr_Stop{sp,2}(index,1)=length(Range(Restrict(S{numNeurons(sp)},intervalSet(startcounting,stopcounting))));
                end
                index=index+1;
            end
        end
        
        % Do the ROC analysis
        for sp=1:length(numNeurons)
            alpha=[];
            beta=[];
            minval=min([Fr_Stop{sp,2};Fr_Stop{sp,1}]);
            maxval=max([Fr_Stop{sp,2};Fr_Stop{sp,1}]);
            delval=(maxval-minval)/20;
            ValsToTest=[min([Fr_Stop{sp,2};Fr_Stop{sp,1}])-delval:delval:max([Fr_Stop{sp,2};Fr_Stop{sp,1}])+delval];
            for z=ValsToTest
                alpha=[alpha,sum(Fr_Stop{sp,2}>z)/length(Fr_Stop{sp,2})];
                beta=[beta,sum(Fr_Stop{sp,1}>z)/length(Fr_Stop{sp,1})];
            end
            RocVal_Stop{m}(sp)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha_Stop{m}(sp,:)=alpha;
            ROCBeta_Stop{m}(sp,:)=beta;
        end
        
        clear Fr alpha beta Powtsd       
    end
    
end

cd /media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/
load('ROCOnsetOffset_PFCUnits_1s.mat','RocVal_Stop','ROCBeta_Stop','ROCAlpha_Stop','RocVal_Start','ROCBeta_Start','ROCAlpha_Start',...
    'M_Start','M_Stop','M_Start_Clean','M_Stop_Clean','ROCAlpha','ROCBeta','RocVal');


figure,plot(abs([RocVal_Start{:}]-0.5)+0.5,abs([RocVal_Stop{:}]-0.5)+0.5,'k.','MarkerSize',18)
line([0 0.4],[0 0.4])
xlabel('ROCval Start')
ylabel('ROCval Stop')

figure
subplot(121)
AllStart=[];AllStart_Weight=[];
for m=1:length(KeepFirstSessionOnly)
    for sp = 1:length(M_Start_Clean{m})
        %         plot(M_Start_Clean{m}{sp}(:,1),(M_Start_Clean{m}{sp}(:,2)),'r'), hold on,
        AllStart=[AllStart,M_Start_Clean{m}{sp}(1:20,2)];
        AllStart_Weight=[AllStart_Weight,abs(RocVal_Start{m}(sp)-0.5)];
    end
end
AllStart_Weight=AllStart_Weight/norm(AllStart_Weight);
g=shadedErrorBar(M_Stop{m}{sp}(1:20,1),nanmean(AllStart'.*AllStart_Weight'),stdError(AllStart'.*AllStart_Weight'),'r')
xlim([-6 6])
% ylim([4e-3 12e-3])
title('Start Freezing')
xlabel('time (s)')
box off
line([0 0],ylim)
subplot(122)
AllStop=[];AllStop_Weight=[];
for m=1:length(KeepFirstSessionOnly)
    for sp = 1:length(M_Start_Clean{m})
        % plot(M_Stop_Clean{m}{sp}(:,1),(M_Stop_Clean{m}{sp}(:,2)),'k'), hold on,
        AllStop=[AllStop,M_Stop_Clean{m}{sp}(1:20,2)];
        AllStop_Weight=[AllStop_Weight,abs(RocVal_Stop{m}(sp)-0.5)];
    end
end
AllStop_Weight=AllStop_Weight/norm(AllStop_Weight);
g=shadedErrorBar(M_Stop_Clean{m}{sp}(1:20,1),nanmean(AllStop'.*AllStop_Weight'),stdError(AllStop'.*AllStop_Weight'));
xlim([-4 4])
ylim([4e-3 12e-3])
title('Stop Freezing')
xlabel('time (s)')
box off
line([0 0],ylim)

figure
plot(M_Stop_Clean{m}{sp}(1:20,1),nanmean(AllStart'.*AllStart_Weight'),':','color','k','linewidth',4), hold on
plot(M_Stop_Clean{m}{sp}(1:20,1),fliplr(nanmean(AllStop'.*AllStop_Weight')),'color',[0.4 0.4 0.4],'linewidth',4), hold on
line([0 0],ylim)
box off

figure
StartVals  = (abs([RocVal_Start{:}]-0.5));
StopVals = (abs([RocVal_Stop{:}]-0.5));
fig=figure;
line([0.7 1.3],[1 1]*nanmedian(StartVals),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(StopVals),'color','k','linewidth',2)
handlesplot=plotSpread({StartVals,StopVals},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(StartVals,StopVals);
H=sigstar({[1,2]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'Onset','Offset'})

figure
StartVals  = (abs([RocVal_Start{:}]-0.5));
StopVals = (abs([RocVal_Stop{:}]-0.5));
MI = (StopVals - StartVals)./(StopVals + StartVals);
fig=figure;
line([0.7 1.3],[1 1]*nanmedian(MI),'color','k','linewidth',2), hold on
handlesplot=plotSpread({MI},'distributionColors',[Cols1(2,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p,h,stats]=signrank(MI);
H=sigstar({[1,1.05]},p);set(H(1),'Color','w');set(H(2),'FontSize',14)



Alpha_Stop=[];Alpha_Start=[];
Beta_Stop=[];Beta_Start=[];
Roc_Start = []; Roc_Stop = [];
for m=1:length(ROCAlpha_Start)
    for sp = 1 :size(ROCAlpha_Start{m},1)
        if abs(RocVal_Stop{m}(sp)-0.5)>0.1 | abs(RocVal_Start{m}(sp)-0.5)>0.1
        if RocVal_Stop{m}(sp)<0.5
            Alpha_Stop = [Alpha_Stop;(1-ROCAlpha_Stop{m}(sp,:))];
            Beta_Stop = [Beta_Stop;(1-ROCBeta_Stop{m}(sp,:))];
            Roc_Stop = [Roc_Stop,1-RocVal_Stop{m}(sp)];

        else
            Alpha_Stop = [Alpha_Stop;ROCAlpha_Stop{m}(sp,:)];
            Beta_Stop = [Beta_Stop;(ROCBeta_Stop{m}(sp,:))];
            Roc_Stop = [Roc_Stop,RocVal_Stop{m}(sp)];

        end
        if RocVal_Start{m}(sp)<0.5
            Alpha_Start = [Alpha_Start;(1-ROCAlpha_Start{m}(sp,:))];
            Beta_Start = [Beta_Start;(1-ROCBeta_Start{m}(sp,:))];
                        Roc_Start = [Roc_Start,1-RocVal_Start{m}(sp)];

        else
            Alpha_Start = [Alpha_Start;ROCAlpha_Start{m}(sp,:)];
            Beta_Start = [Beta_Start;(ROCBeta_Start{m}(sp,:))];
                        Roc_Start = [Roc_Start,RocVal_Start{m}(sp)];

            
        end
    end
    end
    
end


clear NewBeta_Stop NewBeta_Start
NewAlpha=[0:0.01:1];
for m=1:length(Alpha_Start)
    OldAlpha=Alpha_Stop(m,:);
    OldBeta=Beta_Stop(m,:);
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
    NewBeta_Stop(m,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end

for m=1:length(Alpha_Stop)
    OldAlpha=Alpha_Start(m,:);
    OldBeta=Beta_Start(m,:);
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
    NewBeta_Start(m,:)=interp1(OldAlpha,OldBeta,NewAlpha);
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
line([0.7 1.3],[1 1]*nanmedian(Roc_Start),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(Roc_Stop),'color','k','linewidth',2)
handlesplot=plotSpread({Roc_Start,Roc_Stop},'distributionColors',[0 0 0;0.4 0.4 0.4]); hold on
set(handlesplot{1},'MarkerSize',20)
ylim([0.4 0.9])
set(gca,'XTick',[1,2],'XTickLabel',{'FZ start','FZ end'})


figure
clf
Vals = {Roc_Start';Roc_Stop'};
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
