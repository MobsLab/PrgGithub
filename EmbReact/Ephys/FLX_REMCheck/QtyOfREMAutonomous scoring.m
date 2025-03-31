Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180220_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
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
        load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
        RemDur(mm,f)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
        SwsDur(mm,f)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        WakeDur(mm,f)=sum(Stop(Wake,'s')-Start(Wake,'s'));
        TotDur(mm,f)=RemDur(mm,f)+SwsDur(mm,f)+WakeDur(mm,f);
        SleepDur(mm,f) = RemDur(mm,f)+SwsDur(mm,f);
    end
    
end

cd /media/DataMOBsRAIDN/ProjetSlSc/FLXCheck
save('ResultsAutoThresholds.mat','RemDur','SwsDur','WakeDur','TotDur','SleepDur')

figure
subplot(121)
PlotErrorBarN_KJ(100*RemDur(:,2:2:8)./SleepDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(100*RemDur(:,3:2:9)./SleepDur(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(RemDur(:,2:2:8)./TotDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(RemDur(:,3:2:9)./TotDur(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(SleepDur(:,2:2:8)./TotDur(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(SleepDur(:,3:2:9)./TotDur(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

Mice = [666,667,668,669];
for mm=1:4
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180220_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
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
        load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Wake')
        RemDur_Acc(mm,f)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
        SwsDur_Acc(mm,f)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        WakeDur_Acc(mm,f)=sum(Stop(Wake,'s')-Start(Wake,'s'));
        TotDur_Acc(mm,f)=RemDur_Acc(mm,f)+SwsDur_Acc(mm,f)+WakeDur_Acc(mm,f);
        SleepDur_Acc(mm,f) = RemDur_Acc(mm,f)+SwsDur_Acc(mm,f);
    end
    
end

cd /media/DataMOBsRAIDN/ProjetSlSc/FLXCheck
save('ResultsAutoThresholds.mat','RemDur_Acc','SwsDur_Acc','WakeDur_Acc','TotDur_Acc','SleepDur_Acc')

figure
subplot(121)
PlotErrorBarN_KJ(100*RemDur_Acc(:,2:2:8)./SleepDur_Acc(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(100*RemDur_Acc(:,3:2:9)./SleepDur_Acc(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(RemDur_Acc(:,2:2:8)./TotDur_Acc(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(RemDur_Acc(:,3:2:9)./TotDur_Acc(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})

figure
subplot(121)
PlotErrorBarN_KJ(SleepDur_Acc(:,2:2:8)./TotDur_Acc(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(SleepDur_Acc(:,3:2:9)./TotDur_Acc(:,3:2:9),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('sleep % of total')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})



figure
PlotErrorBarN_KJ(100*RemDur_Acc(:,4:2:6)./SleepDur_Acc(:,4:2:6),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('REM % of sleep')
title('day')
set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
