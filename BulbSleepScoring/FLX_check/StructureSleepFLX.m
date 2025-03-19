clear all
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
        load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake')
        Sleep = or(SWSEpoch,REMEpoch);
        AllDur_REM{f}{mm} = Stop(REMEpoch,'s')-Start(REMEpoch,'s');
        AllDur_Wake{f}{mm} = Stop(Wake,'s')-Start(Wake,'s');

        [aft_cell_SR,bef_cell_SR]=transEpoch(SWSEpoch,REMEpoch);
        [aft_cell_SW,bef_cell_SW]=transEpoch(SWSEpoch,Wake);


        REMSWSREM = and(aft_cell_SR{1,2},bef_cell_SR{1,2});
        WakeSWSREM = and(aft_cell_SR{1,2},bef_cell_SW{1,2});
        WakeSWSWake = and(aft_cell_SW{1,2},bef_cell_SW{1,2});
        REMSWSWake = and(aft_cell_SW{1,2},bef_cell_SR{1,2});
        
        [aft_cell_R,bef_cell_R]=transEpoch(REMSWSREM,REMEpoch);
        REM_REMSWSREM = bef_cell_R{2,1};
        AllDur_REM_REMSWSREM{f}{mm} = Stop(REM_REMSWSREM,'s')-Start(REM_REMSWSREM,'s');
        REM_REMSWSREM = aft_cell_R{2,1};
        AllDur_REMBef_REMSWSREM{f}{mm} = Stop(REM_REMSWSREM,'s')-Start(REM_REMSWSREM,'s');

        
        [aft_cell_R,bef_cell_R]=transEpoch(WakeSWSREM,REMEpoch);
        REM_WakeSWSREM = bef_cell_R{2,1};
        AllDur_REM_WakeSWSREM{f}{mm} = Stop(REM_WakeSWSREM,'s')-Start(REM_WakeSWSREM,'s');
        REM_WakeSWSREM = aft_cell_R{2,1};
        AllDur_REMBef_REM_WakeSWSREM{f}{mm} = Stop(REM_WakeSWSREM,'s')-Start(REM_WakeSWSREM,'s');
        
        
        [aft_cell_R,bef_cell_R]=transEpoch(WakeSWSREM,Wake);
        Wake_WakeSWSREM = aft_cell_R{2,1};
        AllDur_Wake_WakeSWSREM{f}{mm} = Stop(Wake_WakeSWSREM,'s')-Start(Wake_WakeSWSREM,'s');


        [aft_cell_RW,bef_cell_RW]=transEpoch(REMEpoch,Wake);
        REMToWake = (aft_cell_RW{1,2});
        [aft_cell_RS,bef_cell_RS]=transEpoch(REMEpoch,SWSEpoch);
        REMToSleep = (aft_cell_RS{1,2});
        
        
        AllDur_REMSWSREM{f}{mm} = Stop(REMSWSREM,'s')-Start(REMSWSREM,'s');
        AllDur_WakeSWSREM{f}{mm} = Stop(WakeSWSREM,'s')-Start(WakeSWSREM,'s');
        AllDur_WakeSleepWake{f}{mm} = Stop(WakeSWSWake,'s')-Start(WakeSWSWake,'s');
        AllDur_REMSWSWake{f}{mm} = Stop(REMSWSWake,'s')-Start(REMSWSWake,'s');

        AllDur_SWS{f}{mm} = Stop(SWSEpoch,'s')-Start(SWSEpoch,'s');
        
        AllDur_TotSleep{f}{mm} = Stop(Sleep,'s')-Start(Sleep,'s');
        
        AllDur_REMToSleep{f}{mm} = Stop(REMToSleep,'s')-Start(REMToSleep,'s');
        
        AllDur_REMToWake{f}{mm} = Stop(REMToWake,'s')-Start(REMToWake,'s');
        
    end
    
end

figure
f = 3;
for mm=1:4
% plot(AllDur_Wake_WakeSWSREM{f}{mm},AllDur_REM_WakeSWSREM{f}{mm},'k*'), hold on
    [Y,X] = hist(AllDur_Wake_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    Wake_StartNum_sal(mm) = 60*length(AllDur_Wake_WakeSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_TotDur_sal(mm) = sum(AllDur_Wake_WakeSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    Wake_MeanDur_sal(mm) = nanmean(AllDur_Wake_WakeSWSREM{f}{mm});

end
f = 5;
for mm=1:4
% plot(AllDur_Wake_WakeSWSREM{f}{mm},AllDur_REM_WakeSWSREM{f}{mm},'r*'), hold on
    [Y,X] = hist(AllDur_Wake_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    Wake_StartNum_flx(mm) = 60*length(AllDur_Wake_WakeSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_TotDur_flx(mm) = sum(AllDur_Wake_WakeSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
   Wake_MeanDur_flx(mm) = nanmean(AllDur_Wake_WakeSWSREM{f}{mm});

end


figure
% REMbef_REMSWSREM
subplot(3,4,1)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REMBef_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    REM_StartNum_sal(mm) = 60*length(AllDur_REMBef_REMSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_sal(mm) = sum(AllDur_REMBef_REMSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_sal(mm) = nanmean(AllDur_REMBef_REMSWSREM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REMBef_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    REM_StartNum_flx(mm) = 60*length(AllDur_REMBef_REMSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_flx(mm) = sum(AllDur_REMBef_REMSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_flx(mm) = nanmean(AllDur_REMBef_REMSWSREM{f}{mm});

end
xlabel('REM bout duration')
ylabel('Cum proba')

subplot(3,4,2)
PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% REM in sleep')
subplot(3,4,3)
PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq REM init (/min)')
subplot(3,4,4)
PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('REM bout dur (s)')

% REMaft_REMSWSREM
subplot(3,4,5)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REM_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    REM_StartNum_sal(mm) = 60*length(AllDur_REM_REMSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_sal(mm) = sum(AllDur_REM_REMSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_sal(mm) = nanmean(AllDur_REM_REMSWSREM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REM_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    REM_StartNum_flx(mm) = 60*length(AllDur_REM_REMSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_flx(mm) = sum(AllDur_REM_REMSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_flx(mm) = nanmean(AllDur_REM_REMSWSREM{f}{mm});

end
xlabel('REM bout duration')
ylabel('Cum proba')

subplot(3,4,6)
PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% REM in sleep')
subplot(3,4,7)
PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq REM init (/min)')
subplot(3,4,8)
PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('REM bout dur (s)')

subplot(3,4,9)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REM_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    REM_StartNum_sal(mm) = 60*length(AllDur_REM_WakeSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_sal(mm) = sum(AllDur_REM_WakeSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_sal(mm) = nanmean(AllDur_REM_WakeSWSREM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REM_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    REM_StartNum_flx(mm) = 60*length(AllDur_REM_WakeSWSREM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_flx(mm) = sum(AllDur_REM_WakeSWSREM{f}{mm})./sum(AllDur_REM{f}{mm});
    REM_MeanDur_flx(mm) = nanmean(AllDur_REM_WakeSWSREM{f}{mm});

end
xlabel('REM bout duration')
ylabel('Cum proba')

subplot(3,4,10)
PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% REM in sleep')
subplot(3,4,11)
PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq REM init (/min)')
subplot(3,4,12)
PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('REM bout dur (s)')

%%%

figure
clear SWS_StartNum_sal SWS_MeanDur_sal SWS_TotDur_sal SWS_StartNum_flx SWS_TotDur_flx SWS_MeanDur_flx
% REM
subplot(3,4,1)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    REM_StartNum_sal(mm) = 60*length(AllDur_REM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_sal(mm) = sum(AllDur_REM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    REM_MeanDur_sal(mm) = nanmean(AllDur_REM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    REM_StartNum_flx(mm) = 60*length(AllDur_REM{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    REM_TotDur_flx(mm) = sum(AllDur_REM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    REM_MeanDur_flx(mm) = nanmean(AllDur_REM{f}{mm});

end
xlabel('REM bout duration')
ylabel('Cum proba')

subplot(3,4,2)
PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% REM in sleep')
subplot(3,4,3)
PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq REM init (/min)')
subplot(3,4,4)
PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('REM bout dur (s)')

% All SWS 
subplot(3,4,5)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_SWS{f}{mm},[0:5:400]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    SWS_StartNum_sal(mm) = 60*length(AllDur_SWS{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    SWS_TotDur_sal(mm) = sum(AllDur_SWS{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_sal(mm) = nanmean(AllDur_SWS{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_SWS{f}{mm},[0:5:400]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    SWS_StartNum_flx(mm) = 60*length(AllDur_SWS{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    SWS_TotDur_flx(mm) = sum(AllDur_SWS{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_flx(mm) = nanmean(AllDur_SWS{f}{mm});

end
xlabel('SWS bout duration')
ylabel('Cum proba')

subplot(3,4,6)
PlotErrorBarN_KJ([SWS_TotDur_sal;SWS_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% SWS in sleep')
subplot(3,4,7)
PlotErrorBarN_KJ([SWS_StartNum_sal;SWS_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq SWS init (/min)')
subplot(3,4,8)
PlotErrorBarN_KJ([SWS_MeanDur_sal;SWS_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('SWS bout dur (s)')

% All Wake 
subplot(3,4,9)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_Wake{f}{mm},[0:5:400]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    Wake_StartNum_sal(mm) = 60*length(AllDur_Wake{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_TotDur_sal(mm) = sum(AllDur_Wake{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_MeanDur_sal(mm) = nanmean(AllDur_Wake{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_Wake{f}{mm},[0:5:400]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    Wake_StartNum_flx(mm) = 60*length(AllDur_Wake{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_TotDur_flx(mm) = sum(AllDur_Wake{f}{mm})./(sum(AllDur_TotSleep{f}{mm})+sum(AllDur_Wake{f}{mm}));
    Wake_MeanDur_flx(mm) = nanmean(AllDur_Wake{f}{mm});

end
xlabel('Wake bout duration')
ylabel('Cum proba')

subplot(3,4,10)
PlotErrorBarN_KJ([Wake_TotDur_sal;Wake_TotDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% wake in whole day')
subplot(3,4,11)
PlotErrorBarN_KJ([Wake_StartNum_sal;Wake_StartNum_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Freq Wake init (/min)')
subplot(3,4,12)
PlotErrorBarN_KJ([Wake_MeanDur_sal;Wake_MeanDur_flx]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('Wake bout dur (s)')
% 
% 
% figure
% % REM
% subplot(2,4,1)
% f = 3;
% for mm=1:4
%     [Y,X] = hist(AllDur_REMToWake{f}{mm},[0:5:300]);
%     plot(X,cumsum(Y)/sum(Y),'k'), hold on
%     REM_StartNum_sal(mm) = 60*length(AllDur_REMToWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_TotDur_sal(mm) = sum(AllDur_REMToWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_MeanDur_sal(mm) = nanmean(AllDur_REMToWake{f}{mm});
% 
% end
% f = 5;
% for mm=1:4
%     [Y,X] = hist(AllDur_REMToWake{f}{mm},[0:5:300]);
%     plot(X,cumsum(Y)/sum(Y),'r'), hold on
%     REM_StartNum_flx(mm) = 60*length(AllDur_REMToWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_TotDur_flx(mm) = sum(AllDur_REMToWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_MeanDur_flx(mm) = nanmean(AllDur_REMToWake{f}{mm});
% 
% end
% xlabel('REM bout duration')
% ylabel('Cum proba')
% subplot(2,4,2)
% PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('REM duration (s)')
% subplot(2,4,3)
% PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('Freq REM init (/min)')
% subplot(2,4,4)
% PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('REM bout dur (s)')
% 
% subplot(2,4,5)
% f = 3;
% for mm=1:4
%     [Y,X] = hist(AllDur_REMToSleep{f}{mm},[0:5:300]);
%     plot(X,cumsum(Y)/sum(Y),'k'), hold on
%     REM_StartNum_sal(mm) = 60*length(AllDur_REMToSleep{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_TotDur_sal(mm) = sum(AllDur_REMToSleep{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_MeanDur_sal(mm) = nanmean(AllDur_REMToSleep{f}{mm});
% 
% end
% f = 5;
% for mm=1:4
%     [Y,X] = hist(AllDur_REMToSleep{f}{mm},[0:5:300]);
%     plot(X,cumsum(Y)/sum(Y),'r'), hold on
%     REM_StartNum_flx(mm) = 60*length(AllDur_REMToSleep{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_TotDur_flx(mm) = sum(AllDur_REMToSleep{f}{mm})./sum(AllDur_TotSleep{f}{mm});
%     REM_MeanDur_flx(mm) = nanmean(AllDur_REMToSleep{f}{mm});
% 
% end
% xlabel('REM bout duration')
% ylabel('Cum proba')
% subplot(2,4,6)
% PlotErrorBarN_KJ([REM_TotDur_sal;REM_TotDur_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('REM duration (s)')
% subplot(2,4,7)
% PlotErrorBarN_KJ([REM_StartNum_sal;REM_StartNum_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('Freq REM init (/min)')
% subplot(2,4,8)
% PlotErrorBarN_KJ([REM_MeanDur_sal;REM_MeanDur_flx]','newfig',0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
% ylabel('REM bout dur (s)')


%%
%% different kinds of SWS sleep
figure
clear SWS_StartNum_sal SWS_MeanDur_sal SWS_TotDur_sal SWS_StartNum_flx SWS_TotDur_flx SWS_MeanDur_flx

% W-S-W
type = 1;
subplot(4,3,1)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_WakeSleepWake{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    SWS_TotDur_sal{type}(mm) = sum(AllDur_WakeSleepWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_sal{type}(mm) = nanmean(AllDur_WakeSleepWake{f}{mm});
    SWS_Number_sal{type}(mm) = length(AllDur_WakeSleepWake{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_WakeSleepWake{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    SWS_TotDur_flx{type}(mm) = sum(AllDur_WakeSleepWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_flx{type}(mm) = nanmean(AllDur_WakeSleepWake{f}{mm});
    SWS_Number_flx{type}(mm) = length(AllDur_WakeSleepWake{f}{mm});

end
xlabel('Bout dur (s)')
ylabel('Cum proba')
title('W-S-W')

subplot(4,3,2)
PlotErrorBarN_KJ([SWS_Number_sal{type};SWS_Number_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% total sleep')
subplot(4,3,3)
PlotErrorBarN_KJ([SWS_MeanDur_sal{type};SWS_MeanDur_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('SWS bout dur (s)')


% W-S-R
type = 2;
subplot(4,3,4)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    SWS_TotDur_sal{type}(mm) = sum(AllDur_WakeSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_sal{type}(mm) = nanmean(AllDur_WakeSWSREM{f}{mm});
    SWS_Number_sal{type}(mm) = length(AllDur_WakeSWSREM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_WakeSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    SWS_TotDur_flx{type}(mm) = sum(AllDur_WakeSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_flx{type}(mm) = nanmean(AllDur_WakeSWSREM{f}{mm});
    SWS_Number_flx{type}(mm) = length(AllDur_WakeSWSREM{f}{mm});

end
xlabel('Bout dur (s)')
ylabel('Cum proba')
title('W-S-R')

subplot(4,3,5)
PlotErrorBarN_KJ([SWS_Number_sal{type};SWS_Number_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% total sleep')
subplot(4,3,6)
PlotErrorBarN_KJ([SWS_MeanDur_sal{type};SWS_MeanDur_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('SWS bout dur (s)')

% R-S-R
subplot(4,3,7)
type = 3;
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    SWS_TotDur_sal{type}(mm) = sum(AllDur_REMSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_sal{type}(mm) = nanmean(AllDur_REMSWSREM{f}{mm});
    SWS_Number_sal{type}(mm) = length(AllDur_REMSWSREM{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REMSWSREM{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    SWS_TotDur_flx{type}(mm) = sum(AllDur_REMSWSREM{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_flx{type}(mm) = nanmean(AllDur_REMSWSREM{f}{mm});
    SWS_Number_flx{type}(mm) = length(AllDur_REMSWSREM{f}{mm});

end
xlabel('Bout dur (s)')
ylabel('Cum proba')
title('R-S-R')

subplot(4,3,8)
PlotErrorBarN_KJ([SWS_Number_sal{type};SWS_Number_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% total sleep')
subplot(4,3,9)
PlotErrorBarN_KJ([SWS_MeanDur_sal{type};SWS_MeanDur_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('SWS bout dur (s)')

% R-S-W
type = 4;
subplot(4,3,10)
f = 3;
for mm=1:4
    [Y,X] = hist(AllDur_REMSWSWake{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'k'), hold on
    SWS_TotDur_sal{type}(mm) = sum(AllDur_REMSWSWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_sal{type}(mm) = nanmean(AllDur_REMSWSWake{f}{mm});
    SWS_Number_sal{type}(mm) = length(AllDur_REMSWSWake{f}{mm});

end
f = 5;
for mm=1:4
    [Y,X] = hist(AllDur_REMSWSWake{f}{mm},[0:5:300]);
    plot(X,cumsum(Y)/sum(Y),'r'), hold on
    SWS_TotDur_flx{type}(mm) = sum(AllDur_REMSWSWake{f}{mm})./sum(AllDur_TotSleep{f}{mm});
    SWS_MeanDur_flx{type}(mm) = nanmean(AllDur_REMSWSWake{f}{mm});
    SWS_Number_flx{type}(mm) = length(AllDur_REMSWSWake{f}{mm});

end
xlabel('Bout dur (s)')
ylabel('Cum proba')
title('R-S-W')

subplot(4,3,11)
PlotErrorBarN_KJ([SWS_Number_sal{type};SWS_Number_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% total sleep')
subplot(4,3,12)
PlotErrorBarN_KJ([SWS_MeanDur_sal{type};SWS_MeanDur_flx{type}]','newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('SWS bout dur (s)')


figure
a = mean(reshape([SWS_TotDur_flx{:}],4,4)).*ones(4,4);
a=a(1,:);
a=a/sum(a);

b = mean(reshape([SWS_TotDur_sal{:}],4,4)).*ones(4,4);
b=b(1,:);
b=b/sum(b);
bar([b;a],'Stack')
legend('W-S-W','W-S-R','R-S-R','R-S-W')
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% of SWS of each type')