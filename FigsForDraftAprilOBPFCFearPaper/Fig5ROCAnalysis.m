clear all
channelstoAnalyse={'B','PFCx'};
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]

% Get data
CtrlEphys=[242,248,244,253,254,259,299,394,395,402,403,450,451];
% Excluded mice (too much noise)=258
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[2,3,4,6,7:length(Dir.path)];

n=1;

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
    NoFreezeEpoch=and(NoFreezeEpoch,intervalSet(0,1000*1e4));
    FreezeEpoch=and(FreezeEpoch,intervalSet(0,1000*1e4));
    DurFz=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
    DurNoFz=sum(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
    
    if DurFz>10 & DurNoFz>10
        for cc=1:length(channelstoAnalyse)
            
            load([channelstoAnalyse{cc},'_Low_Spectrum.mat'])
            flow=find(Spectro{3}<FreqRange(1),1,'last');
            fhigh=find(Spectro{3}<FreqRange(2),1,'last');
            flowOut=find(Spectro{3}<OutFreqRange(1),1,'last');
            fhighOut=find(Spectro{3}<OutFreqRange(2),1,'last');
% Powtsd{cc}=tsd(Spectro{2}*1e4,mean(Spectro{1}(:,flow:fhigh)')');
            Powtsd{cc}=tsd(Spectro{2}*1e4,(mean(Spectro{1}(:,flow:fhigh)')./mean(Spectro{1}(:,flowOut:fhighOut)'))');
        end
        
        begin=Start(FreezeEpoch);
        endin=Stop(FreezeEpoch);
        Fr{cc,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(2*1E4));
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
            numbins=round(dur/(2*1E4));
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
        
        for cc=1:length(channelstoAnalyse)
            alpha=[];
            beta=[];
            minval=min([Fr{cc,2};Fr{cc,1}]);
            maxval=max([Fr{cc,2};Fr{cc,1}]);
            delval=(maxval-minval)/20;
            for z=[min([Fr{cc,2};Fr{cc,1}])-delval:delval:max([Fr{cc,2};Fr{cc,1}])+delval]
                alpha=[alpha,sum(Fr{cc,2}>z)/length(Fr{cc,2})];
                beta=[beta,sum(Fr{cc,1}>z)/length(Fr{cc,1})];
            end
%             plot(alpha,beta,'color',cols(cc,:),'linewidth',2), hold on
            RocVal(m,cc)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlpha{cc}(m,:)=alpha;
            ROCBeta{cc}(m,:)=beta;
            
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



%%

channelstoAnalyse={'PFCx'};
FreqRange=[3,6];
cols=[0,0,0;0.5,0.5,0.5]

% Get data
OBXEphys=[230,291,297,298];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,2,3,4];

n=1;
clear m
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
    NoFreezeEpoch=and(NoFreezeEpoch,intervalSet(0,1000*1e4));
    FreezeEpoch=and(FreezeEpoch,intervalSet(0,1000*1e4));
    DurFz=sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
    DurNoFz=sum(Stop(NoFreezeEpoch,'s')-Start(NoFreezeEpoch,'s'));
    
    if DurFz>10 & DurNoFz>10
        for cc=1:length(channelstoAnalyse)
            
            load([channelstoAnalyse{cc},'_Low_Spectrum.mat'])
            flow=find(Spectro{3}<FreqRange(1),1,'last');
            fhigh=find(Spectro{3}<FreqRange(2),1,'last');
            
            flowOut=find(Spectro{3}<OutFreqRange(1),1,'last');
            fhighOut=find(Spectro{3}<OutFreqRange(2),1,'last');
% Powtsd{cc}=tsd(Spectro{2}*1e4,mean(Spectro{1}(:,flow:fhigh)')');
             Powtsd{cc}=tsd(Spectro{2}*1e4,(mean(Spectro{1}(:,flow:fhigh)')./mean(Spectro{1}(:,flowOut:fhighOut)'))');
        end
        
        begin=Start(FreezeEpoch);
        endin=Stop(FreezeEpoch);
        Fr{cc,1}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(2*1E4));
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
        Fr{cc,1}(Fr{cc,1}>prctile(Fr{cc,1},95))=[];
        
        begin=Start(NoFreezeEpoch);
        endin=Stop(NoFreezeEpoch);
        Fr{cc,2}=zeros(1,1);
        index=1;
        for ff=1:length(begin)
            dur=endin(ff)-begin(ff);
            numbins=round(dur/(2*1E4));
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
        Fr{cc,2}(Fr{cc,2}>prctile(Fr{cc,2},95))=[];
        
        for cc=1:length(channelstoAnalyse)
            alpha=[];
            beta=[];
            minval=min([Fr{cc,2};Fr{cc,1}]);
            maxval=max([Fr{cc,2};Fr{cc,1}]);
            delval=(maxval-minval)/20;
            for z=[min([Fr{cc,2};Fr{cc,1}])-delval:delval:max([Fr{cc,2};Fr{cc,1}])+delval]
                alpha=[alpha,sum(Fr{cc,2}>z)/length(Fr{cc,2})];
                beta=[beta,sum(Fr{cc,1}>z)/length(Fr{cc,1})];
            end
%                     plot(alpha,beta,'color',cols(cc,:),'linewidth',2), hold on
            RocValOB(m,cc)=sum(beta-alpha)/length(beta)+0.5;
            ROCAlphaOB{cc}(m,:)=alpha;
            ROCBetaOB{cc}(m,:)=beta;
            
        end
        
        
        clear Fr alpha beta Powtsd
    end
end


%%

figure
xlim([0.5 2.5])
line([0.6 1.4],[1 1]*nanmedian(RocVal(:,2)),'color','k','linewidth',2)
line([1.6 2.4],[1 1]*nanmedian(RocValOB),'color','k','linewidth',2)
line(xlim,[0.5 0.5],'color','k','linestyle',':')
hold on
handlesplot=plotSpread({RocVal(:,2),RocValOB},'distributionColors',[0 0.45 0.75;0 0 1]);
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'CTRL','OBX'})
ylim([0.4 0.9])
[p,h,stats]=ranksum(RocVal(:,2),RocValOB);
xlim([0.5 2.5])

figure
clf
Vals = {RocVal(:,2); RocValOB};
XPos = [1.1,1.9,3.5,4.4];
Colors_Points = [Cols1(1,:);Cols1(2,:)];
Colors_Boxplot = [0.9,0.9,1;1,0.9,0.9];
for k = 1:2
X = Vals{k};
a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Colors_Boxplot(k,:),'lineColor',Colors_Boxplot(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
a.handles.medianLines.LineWidth = 5;

handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(X,'distributionColors',Colors_Points(k,:),'xValues',XPos(k),'spreadWidth',0.7), hold on;
set(handlesplot{1},'MarkerSize',20)

end

xlim([0.5 2.5])
ylim([0.4 0.9])
set(gca,'FontSize',18,'XTick',XPos,'XTickLabel',{'Ctrl','OBX'},'linewidth',1.5,'YTick',[0.4:0.2:0.8])
ylabel('ROC value')
box off


figure
NewAlpha=[0:0.01:1];
for m=1:13
    OldAlpha=ROCAlpha{2}(m,:);
    OldBeta=ROCBeta{2}(m,:);
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
    NewBeta1(m,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end

for m=1:4
    OldAlpha=ROCAlphaOB{1}(m,:);
    OldBeta=ROCBetaOB{1}(m,:);
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
    NewBeta2(m,:)=interp1(OldAlpha,OldBeta,NewAlpha);
end
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta1),[stdError(NewBeta1);stdError(NewBeta1)]');
set(hp,'FaceColor',[0 0.45 0.75],'FaceAlpha',0.3)
set(hl,'Color',[0 0.45 0.75],'linewidth',2)
[hl,hp]=boundedline(NewAlpha,nanmean(NewBeta2),[stdError(NewBeta2);stdError(NewBeta2)]');
set(hp,'FaceColor',[0 0 1],'FaceAlpha',0.3)
set(hl,'Color',[0 0 1],'linewidth',2)
line([0 1],[0 1],'color','k','linestyle',':','linewidth',2)
xlim([0 1]),ylim([0 1]),box off