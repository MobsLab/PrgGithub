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
        
    for f = 2:length(FileName)
        cd(FileName{f})
        load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
        RemDur(mm,f)=sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
        SwsDur(mm,f)=sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        WakeDur(mm,f)=sum(Stop(Wake,'s')-Start(Wake,'s'));
        TotDur(mm,f)=RemDur(mm,f)+SwsDur(mm,f)+WakeDur(mm,f);
        SleepDur(mm,f) = RemDur(mm,f)+SwsDur(mm,f);
        load('IdFigureData.mat')
        SubStages(mm,f,:) = percentvalues_NREM;
        
        
    end
    
end

RemPerc = RemDur./SleepDur;
figure
subplot(221)
PlotErrorBarN_KJ(RemPerc(:,[2,4,6,8]),'newfig',0)
ylabel('% REM')
set(gca,'XTick',[1:4],'XTickLabel',{'Day1','Day2SAL','Day3FLX','Day4'})
title('DAY')
subplot(223)
bar(squeeze((mean((SubStages(:,[2,4,6,8],:))))),'stacked')
set(gca,'XTick',[1:4],'XTickLabel',{'Day1','Day2SAL','Day3FLX','Day4'})
ylabel('% substage')
subplot(222)
PlotErrorBarN_KJ(RemPerc(:,[2,4,6,8]+1),'newfig',0)
ylabel('% REM')
set(gca,'XTick',[1:4],'XTickLabel',{'Day1','Day2SAL','Day3FLX','Day4'})
title('Night')
subplot(224)
bar(squeeze((mean((SubStages(:,[2,4,6,8]+1,:))))),'stacked')
set(gca,'XTick',[1:4],'XTickLabel',{'Day1','Day2SAL','Day3FLX','Day4'})
legend('N1','N2','N3')
ylabel('% substage')
