Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
    
    
    for f = 1:length(FileName)
        cd(FileName{f})
        load('StateEpochSB.mat','smooth_ghi','smooth_Theta','TotalNoiseEpoch')
        if f==1
            load('StateEpochSB.mat','gamma_thresh','theta_thresh')
        end
        [REMEpoch,SWSEpoch,Wake,Sleep]=FindBehavEpochPreDefinesThresholds(gamma_thresh,theta_thresh,smooth_ghi,smooth_Theta,TotalNoiseEpoch);
        
        RemDur(mm,f)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
        SwsDur(mm,f)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        WakeDur(mm,f)=sum(Stop(Wake,'s')-Start(Wake,'s'));
        TotDur(mm,f)=RemDur(mm,f)+SwsDur(mm,f)+WakeDur(mm,f);
        SleepDur(mm,f) = RemDur(mm,f)+SwsDur(mm,f);
    end
    
end

save('ResultsSameThresholds.mat','RemDur','SwsDur','WakeDur','TotDur','SleepDur')
figure
subplot(121)
PlotErrorBarN_KJ(100*RemDur(:,1:2:7)./SleepDur(:,1:2:7),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(100*RemDur(:,2:2:8)./SleepDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(RemDur(:,1:2:7)./TotDur(:,1:2:7),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(RemDur(:,2:2:8)./TotDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(SleepDur(:,1:2:7)./TotDur(:,1:2:7),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(SleepDur(:,2:2:8)./TotDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})


figure
Vals = {100*RemDur(:,3)./SleepDur(:,3);100*RemDur(:,5)./SleepDur(:,5)};
XPos = [1.1,1.9];

Cols = [0.4,0.4,0.4;0.9,0.9,0.9];
for k = 1:2
    X = Vals{k};
    a=iosr.statistics.boxPlot(XPos(k),X,'boxColor',Cols(k,:),'lineColor',Cols(k,:),'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    
    handlesplot=plotSpread(X,'distributionColors',[0 0 0],'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',30)
    handlesplot=plotSpread(X,'distributionColors',Cols(k,:)*0.8,'xValues',XPos(k),'spreadWidth',0.4), hold on;
    set(handlesplot{1},'MarkerSize',20)
    
end
